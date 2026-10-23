import { test } from 'node:test';
import assert from 'node:assert/strict';
import { evidenceFor, newJourney, publicJourney, submissionIssue, submitAnswer, transition, type Action, type Journey } from '../src/domain/journey.ts';
import { readJourney } from '../src/domain/snapshot.ts';

const explanation = 'Lima hanya dikalikan ke x; angka 2 tetap.';
const correctExplanation = 'Lima dikalikan ke setiap suku: x menjadi 5x dan 2 menjadi 10.';

function answer(journey: Journey, id: string, value: string) {
  const next = submitAnswer(journey, id, value, '2026-10-22T00:00:00Z');
  assert.ok(next, id);
  return next;
}

function advance(journey: Journey, action: Action) {
  const next = transition(journey, action);
  assert.ok(next, action);
  return next;
}

function confirmed() {
  let journey = advance(newJourney(), 'select-topic');
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '4x+3');
  return answer(journey, 'distribution-q3', explanation);
}

function readyForRetry() {
  let journey = advance(confirmed(), 'start-recovery');
  journey = advance(advance(journey, 'advance'), 'advance');
  return answer(journey, 'distribution-practice', '10');
}

test('FR-X-01/02/03: every interrupted stage of existing journeys round-trips without changing evidence', () => {
  const phases = new Set<string>();
  const check = (journey: Journey) => {
    const saved = JSON.parse(JSON.stringify(journey));
    const before = structuredClone(saved);
    assert.deepEqual(readJourney(saved), journey, journey.phase);
    assert.deepEqual(saved, before, 'resume validation must not rewrite stored evidence');
    phases.add(journey.phase);
    return journey;
  };
  for (const [retry, transfer] of [['4x+5', null], ['4x+20', '3x+4'], ['20+4x', '12+3x']]) {
    let journey = check(newJourney());
    journey = check(advance(journey, 'select-topic'));
    journey = check(answer(journey, 'spl-q1', 'B'));
    journey = check(answer(journey, 'distribution-q2', '4x+3'));
    journey = check(answer(journey, 'distribution-q3', explanation));
    journey = check(advance(journey, 'start-recovery'));
    journey = check(advance(journey, 'advance'));
    journey = check(advance(journey, 'advance'));
    journey = check(answer(journey, 'distribution-practice', '2'));
    journey = check(answer(journey, 'distribution-practice', '10'));
    journey = check(answer(journey, 'distribution-retry', retry!));
    if (transfer) journey = check(answer(journey, 'distribution-transfer', transfer));
    if (journey.learnerState !== 'understood') {
      journey = check(advance(journey, 'reinforce'));
      assert.equal(publicJourney(journey).map.progress, null);
      journey = check(advance(journey, 'advance'));
      journey = check(advance(journey, 'advance'));
      journey = check(answer(journey, 'distribution-practice', '10'));
      journey = check(answer(journey, 'distribution-retry', '4x+20'));
      check(answer(journey, 'distribution-transfer', '3x+12'));
    }
  }
  for (const [q1, q2, q3, q4] of [
    ['A', '4x+12', correctExplanation, null],
    ['B', '4x+12', correctExplanation, null],
    ['B', '4x+3', 'Saya belum yakin.', '8'],
    ['B', '4x+3', 'Saya belum yakin.', '4'],
  ]) {
    let journey = advance(newJourney(), 'select-topic');
    journey = check(answer(journey, 'spl-q1', q1!));
    journey = check(answer(journey, 'distribution-q2', q2!));
    journey = check(answer(journey, 'distribution-q3', q3!));
    if (q4) journey = check(answer(journey, 'distribution-q4', q4));
    if (journey.diagnosticOutcome === 'rejected' || journey.diagnosticOutcome === 'uncertain') {
      journey = check(advance(journey, 'start-review'));
      journey = check(advance(journey, 'advance'));
      journey = check(advance(journey, 'advance'));
      check(answer(journey, 'distribution-practice', '10'));
    }
  }
  assert.deepEqual([...phases].sort(), [
    'entry', 'diagnosis', 'diagnostic-result',
    'visual', 'worked', 'practice', 'review-complete', 'retry', 'transfer', 'validation-result',
  ].sort());
});

test('FR-C5-04/05 and FR-X-03: unsupported saved validation claims are rejected, never downgraded or regraded', () => {
  const retry = readyForRetry();
  const transfer = answer(retry, 'distribution-retry', '4x+20');
  const understood = answer(transfer, 'distribution-transfer', '3x+12');
  const failedRetry = answer(retry, 'distribution-retry', '4x+5');
  const procedural = answer(transfer, 'distribution-transfer', '3x+4');
  const legacyApproximate = structuredClone(understood);
  legacyApproximate.attempts.find(a => a.role === 'retry')!.answer = '4x+20.0000000001';
  const invalid: Journey[] = [
    { ...understood, attempts: [] },
    { ...understood, attempts: understood.attempts.slice(0, -1) },
    { ...failedRetry, learnerState: 'understood' },
    { ...understood, learnerState: 'procedural-only' },
    { ...procedural, learnerState: 'needs-reinforcement' },
    { ...retry, phase: 'transfer' },
    { ...understood, attempts: understood.attempts.filter(a => a.role !== 'practice') },
    { ...understood, origin: 'optional-review', diagnosticOutcome: 'rejected' },
    legacyApproximate,
  ];
  for (const saved of invalid) {
    const before = structuredClone(saved);
    assert.equal(readJourney(saved), null, JSON.stringify(saved));
    assert.deepEqual(saved, before);
  }
});

test('FR-C3-03/05/06 and FR-X-01: corrupted, repeated or out-of-order evidence cannot resume', () => {
  const source = confirmed();
  const reordered = structuredClone(source);
  [reordered.attempts[0], reordered.attempts[1]] = [reordered.attempts[1], reordered.attempts[0]];
  const forged = structuredClone(source);
  forged.attempts[1].answer = '4x+12'; // observation still claims the omitted-constant error.
  const unreadable = structuredClone(source);
  unreadable.attempts[1].answer = 'alert(1)';
  const insufficientValidation = answer(readyForRetry(), 'distribution-retry', '4x+5');
  insufficientValidation.attempts.at(-1)!.observation = 'insufficient';
  insufficientValidation.attempts.at(-1)!.evidence = evidenceFor('retry', 'insufficient');
  for (const saved of [
    reordered, forged, unreadable, insufficientValidation,
    { ...source, attempts: [...source.attempts, source.attempts[2]] },
    { ...source, phase: 'diagnosis' },
    { ...source, diagnosticOutcome: 'rejected' },
  ]) assert.equal(readJourney(saved), null);
});

test('FR-C3-08 and FR-X-01: bounded AI interpretation provenance survives resume without a provider call', () => {
  let journey = advance(newJourney(), 'select-topic');
  journey = answer(journey, 'spl-q1', 'A');
  journey = answer(journey, 'distribution-q2', '4x+12');
  journey = submitAnswer(journey, 'distribution-q3', 'Angka 5 berlaku pada kedua suku, x dan 2.',
    '2026-10-22T00:00:00Z', { observation: 'correct', source: 'gateway' })!;
  assert.ok(journey);
  assert.equal(journey.attempts[2].interpretationSource, 'gateway');
  assert.deepEqual(readJourney(journey), journey);
  assert.equal(journey.phase, 'diagnostic-result');
  assert.equal(journey.diagnosticOutcome, 'rejected');
});

test('FR-X-01/03 OI-03: legacy all-correct pending evidence requires explicit reset, never silent regrading', () => {
  let current = advance(newJourney(), 'select-topic');
  current = answer(current, 'spl-q1', 'A');
  current = answer(current, 'distribution-q2', '4x+12');
  current = answer(current, 'distribution-q3', correctExplanation);
  const legacy = { ...current, phase: 'diagnostic-decision-pending', diagnosticOutcome: null };
  const before = structuredClone(legacy);
  assert.equal(readJourney(legacy), null);
  assert.deepEqual(legacy, before);
  assert.deepEqual(readJourney(current), current);
});

test('FR-X-01: the existing 100-attempt bound also applies when restoring a long practice session', () => {
  let journey = advance(advance(advance(confirmed(), 'start-recovery'), 'advance'), 'advance');
  while (journey.attempts.length < 100) journey = answer(journey, 'distribution-practice', '2');
  assert.deepEqual(readJourney(journey), journey);
  assert.equal(submitAnswer(journey, 'distribution-practice', '10'), null);
  assert.equal(submissionIssue(journey, 'distribution-practice', '10'), 'attempt_limit');
  assert.deepEqual(publicJourney(journey).availableActions, ['reset']);
  assert.deepEqual(transition(journey, 'reset'), newJourney());
  const overflow = { ...journey, attempts: [...journey.attempts, journey.attempts.at(-1)!] };
  assert.equal(readJourney(overflow), null);
});

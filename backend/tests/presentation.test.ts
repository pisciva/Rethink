import { test } from 'node:test';
import assert from 'node:assert/strict';
import { newJourney, publicJourney, submitAnswer, transition, type Journey, type Action } from '../src/domain/journey.ts';
import { readJourney } from '../src/domain/snapshot.ts';

function act(j: Journey, action: Action) { const n = transition(j, action); assert.ok(n); return n; }
function answer(j: Journey, id: string, text: string) {
  const n = submitAnswer(j, id, text, '2026-10-23T04:00:00Z'); assert.ok(n); return n;
}
function diagnosed(correct = false) {
  let j = act(newJourney(), 'select-topic');
  j = answer(j, 'spl-q1', correct ? 'A' : 'B');
  j = answer(j, 'distribution-q2', correct ? '4x+12' : '4x+3');
  return answer(j, 'distribution-q3', correct
    ? 'Lima dikalikan ke setiap suku: x menjadi 5x dan 2 menjadi 10.'
    : 'Lima hanya dikalikan ke x; angka 2 tetap.');
}
function retryReady(j = diagnosed()) {
  j = act(j, 'start-recovery'); j = act(act(j, 'advance'), 'advance');
  return answer(j, 'distribution-practice', '10');
}
const view = (j: Journey) => publicJourney(j).presentation;

test('GAM P-01/03..07: core and optional probe progress use saved roles, with no grading disclosure', () => {
  let j = act(newJourney(), 'select-topic');
  assert.equal(view(j).activity, 'Soal inti 1 dari 3');
  assert.equal(view(j).achievement, null);
  j = answer(j, 'spl-q1', 'B'); assert.equal(view(j).activity, 'Soal inti 2 dari 3');
  j = answer(j, 'distribution-q2', '4x+3'); assert.equal(view(j).activity, 'Soal inti 3 dari 3');
  j = answer(j, 'distribution-q3', 'Saya belum yakin.');
  assert.match(view(j).activity, /3 dari 3 selesai.*tambahan 1 dari 1/);
  assert.equal(view(j).stages[0].state, 'current');
  assert.equal(view(j).validation, null);
  assert.equal(view(j).achievement, null);
  for (const word of ['4x+12', '5x+10', 'benar', 'known-error', 'supporting']) {
    assert.equal(JSON.stringify(view(j)).includes(word), false);
  }
});

test('GAM P-11..18/25..26: learning progress preserves optional origin and never implies mastery', () => {
  const confirmed = diagnosed();
  assert.equal(view(confirmed).stages[0].state, 'complete');
  assert.equal(view(confirmed).achievement, null);
  let j = act(confirmed, 'start-recovery');
  assert.equal(view(j).stages[1].state, 'current');
  assert.equal(view(j).context, 'confirmed-recovery');
  j = act(act(j, 'advance'), 'advance');
  j = answer(j, 'distribution-practice', '2');
  assert.equal(view(j).stages[1].state, 'current');
  j = answer(j, 'distribution-practice', '10');
  assert.equal(view(j).stages[1].state, 'complete');
  assert.equal(view(j).achievement, null);
  assert.equal(publicJourney(j).learnerState, null);

  j = diagnosed(true);
  assert.equal(j.diagnosticOutcome, 'rejected');
  assert.equal(view(j).stages[1].state, 'optional');
  assert.equal(view(j).stages[2].state, 'not-applicable');
  j = act(j, 'start-review');
  assert.equal(view(j).context, 'optional-review');
  j = act(act(j, 'advance'), 'advance');
  j = answer(j, 'distribution-practice', '10');
  assert.equal(view(j).stages[1].state, 'complete');
  assert.equal(view(j).stages[2].state, 'not-applicable');
  assert.equal(view(j).achievement, null);
});

test('GAM P-19..23 and A-01..06: recognition requires valid eligible retry AND transfer', () => {
  const retry = retryReady();
  assert.equal(view(retry).validation, null);
  const failed = answer(retry, 'distribution-retry', '4x+5');
  assert.deepEqual(view(failed).validation, { retry: 'not-passed', transfer: 'not-administered' });
  assert.equal(view(failed).achievement, null);
  assert.equal(view(failed).stages[2].state, 'needs-action');
  const transfer = answer(retry, 'distribution-retry', '4x+20');
  assert.equal(view(transfer).achievement, null);
  assert.equal(view(transfer).validation, null, 'keep C5 feedback scaffold-free until final result');
  const procedural = answer(transfer, 'distribution-transfer', '3x+4');
  assert.deepEqual(view(procedural).validation, { retry: 'passed', transfer: 'not-passed' });
  assert.equal(view(procedural).achievement, null);
  const understood = answer(transfer, 'distribution-transfer', '12+3x');
  assert.deepEqual(view(understood).validation, { retry: 'passed', transfer: 'passed' });
  assert.equal(view(understood).achievement?.concept, 'distribution');
  assert.equal(view(understood).stages[2].state, 'complete');
});

test('GAM A-07/09..14 and X-05: forged claims do not award and persisted results project identically on repeat reads', () => {
  const j = answer(answer(retryReady(), 'distribution-retry', '4x+20'), 'distribution-transfer', '3x+12');
  const before = structuredClone(j);
  const resumed = readJourney(JSON.parse(JSON.stringify(j))); assert.ok(resumed);
  assert.deepEqual(view(resumed), view(j));
  assert.deepEqual(view(resumed), view(j));
  assert.deepEqual(j, before, 'projection creates no new attempt/reward write');
  for (const forged of [
    { ...j, origin: 'optional-review' as const }, { ...j, attempts: [] },
    { ...j, learningCompleted: false }, { ...j, learnerState: 'procedural-only' as const },
    { ...j, attempts: j.attempts.slice(0, -1) },
  ]) assert.equal(view(forged).achievement, null);
});

test('GAM P-20/24 and A-20: reinforcement never reuses an earlier transfer as current evidence', () => {
  let j = answer(answer(retryReady(), 'distribution-retry', '4x+20'), 'distribution-transfer', '3x+4');
  j = act(j, 'reinforce');
  assert.equal(view(j).achievement, null);
  j = act(act(j, 'advance'), 'advance');
  j = answer(j, 'distribution-practice', '10');
  j = answer(j, 'distribution-retry', '4x+5');
  assert.deepEqual(view(j).validation, { retry: 'not-passed', transfer: 'not-administered' });
  assert.equal(view(j).achievement, null);
});

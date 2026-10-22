import { test } from 'node:test';
import assert from 'node:assert/strict';
import { newJourney, publicJourney, submissionIssue, submitAnswer, transition } from '../lib/v2/engine.ts';

function answer(session: ReturnType<typeof newJourney>, questionId: string, value: string) {
  const next = submitAnswer(session, questionId, value, '2026-10-18T00:00:00Z');
  assert.ok(next, `expected ${questionId} to accept a valid response`);
  return next;
}

function startedJourney() {
  const selected = transition(newJourney(), 'select-topic');
  assert.ok(selected);
  return selected;
}

test('catalog entry has no personal assessment until the supported SPL topic is selected', () => {
  const entry = newJourney();
  assert.equal(publicJourney(entry).phase, 'entry');
  assert.equal(publicJourney(entry).selectedTopic, null);
  assert.equal(publicJourney(entry).currentQuestion, null);
  assert.equal(submitAnswer(entry, 'spl-q1', 'A'), null);
  const selected = startedJourney();
  assert.equal(publicJourney(selected).selectedTopic, 'spl');
  assert.equal(publicJourney(selected).currentQuestion?.id, 'spl-q1');
});

test('diagnosis administers three distinct core roles and holds all-correct decision', () => {
  let journey = startedJourney();
  assert.equal(publicJourney(journey).currentQuestion?.id, 'spl-q1');
  journey = answer(journey, 'spl-q1', 'A');
  assert.equal(publicJourney(journey).currentQuestion?.id, 'distribution-q2');
  journey = answer(journey, 'distribution-q2', '3x+6');
  assert.equal(publicJourney(journey).currentQuestion?.id, 'distribution-q3');
  journey = answer(journey, 'distribution-q3', 'Tiga dikalikan ke setiap suku: x menjadi 3x dan 2 menjadi 6.');
  const view = publicJourney(journey);
  assert.equal(view.phase, 'diagnostic-decision-pending');
  assert.equal(view.diagnosticOutcome, null);
  assert.equal(view.currentQuestion, null);
  assert.deepEqual(view.availableActions, []);
  assert.match(view.resultExplanation || '', /belum.*keputusan/i);
  assert.equal(transition(journey, 'start-recovery'), null);
  assert.equal(transition(journey, 'start-review'), null);
});

test('two concordant conceptual errors confirm only after Q3 and allow guided recovery', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '3x+2');
  assert.equal(publicJourney(journey).diagnosticOutcome, null);
  assert.equal('correct' in publicJourney(journey).attempts[1], false);
  journey = answer(journey, 'distribution-q3', 'Tiga hanya dikalikan ke x; angka 2 tetap.');
  assert.equal(publicJourney(journey).diagnosticOutcome, 'confirmed');
  assert.equal(publicJourney(journey).map.focus, 'distribution');
  journey = transition(journey, 'start-recovery')!;
  assert.equal(journey.phase, 'visual');
  assert.equal(publicJourney(journey).learningContent?.kind, 'visual');
  journey = transition(journey, 'advance')!;
  assert.equal(journey.phase, 'worked');
  assert.equal(publicJourney(journey).learningContent?.kind, 'worked');
  journey = transition(journey, 'advance')!;
  assert.equal(journey.phase, 'practice');
  assert.equal(publicJourney(journey).learningCompleted, false);
  journey = answer(journey, 'distribution-practice', '2');
  assert.equal(journey.phase, 'practice');
});

test('rejected diagnosis can review content without entering validation', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '3x+6');
  journey = answer(journey, 'distribution-q3', 'Tiga dikali ke setiap suku: x menjadi 3x dan 2 menjadi 6.');
  assert.equal(publicJourney(journey).diagnosticOutcome, 'rejected');
  assert.equal(transition(journey, 'start-recovery'), null);
  journey = transition(journey, 'start-review')!;
  journey = transition(transition(journey, 'advance')!, 'advance')!;
  journey = answer(journey, 'distribution-practice', '10');
  assert.equal(journey.phase, 'review-complete');
  assert.equal(publicJourney(journey).learningCompleted, true);
  assert.equal(publicJourney(journey).learnerState, null);
  assert.equal(transition(journey, 'start-validation'), null);
});

test('ambiguous core evidence permits at most one targeted Q4 and no fabricated learner state', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '3x+2');
  journey = answer(journey, 'distribution-q3', 'Saya mencoba menghitungnya.');
  assert.equal(publicJourney(journey).currentQuestion?.id, 'distribution-q4');
  journey = answer(journey, 'distribution-q4', '8');
  assert.equal(journey.attempts.length, 4);
  assert.equal(publicJourney(journey).diagnosticOutcome, 'uncertain');
  assert.equal(publicJourney(journey).learnerState, null);
  assert.equal(publicJourney(journey).currentQuestion, null);
  assert.equal(submitAnswer(journey, 'distribution-q4', '8'), null);
});

test('confirmed recovery gates transfer and scopes final validation state', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '3x+2');
  journey = answer(journey, 'distribution-q3', 'Tiga hanya dikalikan ke x; angka 2 tetap.');
  journey = transition(journey, 'start-recovery')!;
  journey = transition(transition(journey, 'advance')!, 'advance')!;
  journey = answer(journey, 'distribution-practice', '10');
  assert.equal(journey.phase, 'retry');
  assert.equal(publicJourney(journey).learningCompleted, true);
  assert.equal(publicJourney(journey).learnerState, null);
  journey = answer(journey, 'distribution-retry', '4x+20');
  assert.equal(journey.phase, 'transfer');
  journey = answer(journey, 'distribution-transfer', '3x+4');
  assert.equal(journey.phase, 'validation-result');
  assert.equal(publicJourney(journey).learnerState, 'procedural-only');
  assert.equal(publicJourney(journey).map.progress, 'procedural-only');
  assert.deepEqual(publicJourney(journey).availableActions, ['reinforce']);
});

test('retry failure blocks transfer and both valid successes establish only concept-level understanding', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '3x+2');
  journey = answer(journey, 'distribution-q3', 'Tiga hanya dikalikan ke x; angka 2 tetap.');
  journey = transition(journey, 'start-recovery')!;
  journey = transition(transition(journey, 'advance')!, 'advance')!;
  journey = answer(journey, 'distribution-practice', '10');
  const failed = answer(journey, 'distribution-retry', '4x+5');
  assert.equal(failed.phase, 'validation-result');
  assert.equal(publicJourney(failed).learnerState, 'needs-reinforcement');
  assert.equal(failed.attempts.some(a => a.role === 'transfer'), false);
  assert.equal(submitAnswer(failed, 'distribution-transfer', '3x+12'), null);
  journey = answer(journey, 'distribution-retry', '4x+20');
  journey = answer(journey, 'distribution-transfer', '3x+12');
  assert.equal(publicJourney(journey).learnerState, 'understood');
  assert.match(publicJourney(journey).resultExplanation || '', /Sifat Distributif/);
  assert.match(publicJourney(journey).resultExplanation || '', /tidak menyatakan penguasaan seluruh SPL/);
});

test('invalid math and stale question do not create evidence', () => {
  const journey = startedJourney();
  assert.equal(submitAnswer(journey, 'distribution-q2', '3x+6'), null);
  const afterQ1 = answer(journey, 'spl-q1', 'B');
  assert.equal(submitAnswer(afterQ1, 'distribution-q2', 'alert(1)'), null);
  assert.equal(submitAnswer(afterQ1, 'distribution-q2', '3(x+2)'), null);
  assert.equal(afterQ1.attempts.length, 1);
});

test('negated misconception wording is not read as evidence of that misconception', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '3x+2');
  journey = answer(journey, 'distribution-q3', 'Bukan hanya x yang dikali 3: angka 2 juga dikali 3 sehingga menjadi 3x+6.');
  assert.notEqual(publicJourney(journey).diagnosticOutcome, 'confirmed');
});

test('a correct SPL target response is counterevidence, so two later errors require the bounded probe', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'A');
  journey = answer(journey, 'distribution-q2', '3x+2');
  journey = answer(journey, 'distribution-q3', 'Tiga hanya dikalikan ke x; angka 2 tetap.');
  assert.equal(publicJourney(journey).currentQuestion?.id, 'distribution-q4');
  assert.equal(publicJourney(journey).diagnosticOutcome, null);
  journey = answer(journey, 'distribution-q4', '4');
  assert.equal(publicJourney(journey).diagnosticOutcome, 'uncertain');
});

test('a correct conceptual explanation remains counterevidence after a matching Q4 error', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '3x+2');
  journey = answer(journey, 'distribution-q3', 'Tiga dikali ke setiap suku: x menjadi 3x dan 2 menjadi 6.');
  assert.equal(publicJourney(journey).currentQuestion?.id, 'distribution-q4');
  journey = answer(journey, 'distribution-q4', '4');
  assert.equal(publicJourney(journey).diagnosticOutcome, 'uncertain');
  assert.equal(publicJourney(journey).map.focus, null);
});

test('attempts carry internal evidence provenance without exposing it publicly', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '3x+2');
  journey = answer(journey, 'distribution-q3', 'Tiga hanya dikalikan ke x; angka 2 tetap.');
  assert.deepEqual(journey.attempts.map(a => a.evidence), [
    { category: 'outcome', direction: 'supporting' },
    { category: 'transformation', direction: 'supporting' },
    { category: 'explanation', direction: 'supporting' },
  ]);
  assert.equal('evidence' in publicJourney(journey).attempts[0], false);
  assert.equal('observation' in publicJourney(journey).attempts[0], false);
});

test('reinforcement clears the projected C5 state while retaining validation attempts', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '3x+2');
  journey = answer(journey, 'distribution-q3', 'Tiga hanya dikalikan ke x; angka 2 tetap.');
  journey = transition(journey, 'start-recovery')!;
  journey = transition(transition(journey, 'advance')!, 'advance')!;
  journey = answer(journey, 'distribution-practice', '10');
  journey = answer(journey, 'distribution-retry', '4x+5');
  assert.equal(publicJourney(journey).map.progress, 'needs-reinforcement');
  journey = transition(journey, 'reinforce')!;
  assert.equal(journey.phase, 'visual');
  assert.equal(journey.learnerState, null);
  assert.equal(publicJourney(journey).learnerState, null);
  assert.equal(publicJourney(journey).map.progress, null);
  assert.equal(journey.attempts.some(a => a.role === 'retry'), true);
});

test('optional review completion explains that validation is not opened', () => {
  let journey = startedJourney();
  journey = answer(journey, 'spl-q1', 'B');
  journey = answer(journey, 'distribution-q2', '3x+6');
  journey = answer(journey, 'distribution-q3', 'Tiga dikali ke setiap suku: x menjadi 3x dan 2 menjadi 6.');
  journey = transition(journey, 'start-review')!;
  journey = transition(transition(journey, 'advance')!, 'advance')!;
  journey = answer(journey, 'distribution-practice', '10');
  assert.equal(journey.phase, 'review-complete');
  assert.match(publicJourney(journey).resultExplanation || '', /tidak membuka validasi/i);
});

test('submission issue distinguishes stale, format and unreadable answers', () => {
  const journey = startedJourney();
  assert.equal(submissionIssue(journey, 'distribution-q2', '3x+6'), 'stale_question');
  assert.equal(submissionIssue(journey, 'spl-q1', 'A'), 'invalid_answer');
  const afterQ1 = answer(journey, 'spl-q1', 'A');
  assert.equal(submissionIssue(afterQ1, 'distribution-q2', '3(x+2)'), 'expanded_form_required');
  assert.equal(submissionIssue(afterQ1, 'distribution-q2', 'alert(1)'), 'invalid_answer');
});

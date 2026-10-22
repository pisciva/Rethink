import { test } from 'node:test';
import assert from 'node:assert/strict';
import { newJourney, type Journey } from '../src/domain/journey.ts';
import { learningTransition, completePractice } from '../src/domain/learning.ts';
import { validationTransition } from '../src/domain/validation.ts';
import { projectMap } from '../src/domain/map.ts';

test('FR-C4-02/07/08: learning cannot invent an origin, completion evidence or learner state', () => {
  const practice: Journey = { ...newJourney(), selectedTopic: 'spl', phase: 'practice' };
  assert.equal(completePractice(practice, 'correct'), null);
  assert.equal(completePractice({ ...practice, origin: 'confirmed-recovery', diagnosticOutcome: 'rejected' }, 'correct'), null);
  const confirmed: Journey = { ...practice, origin: 'confirmed-recovery', diagnosticOutcome: 'confirmed' };
  assert.equal(completePractice(confirmed, 'insufficient'), null);
  const completed = completePractice(confirmed, 'correct')!;
  assert.equal(completed.phase, 'retry');
  assert.equal(completed.learnerState, null);
  assert.equal(projectMap(completed).progress, null);
  const review = completePractice({ ...practice, origin: 'optional-review', diagnosticOutcome: 'uncertain' }, 'correct')!;
  assert.equal(review.phase, 'review-complete');
  assert.equal(validationTransition(review, 'correct'), null);
  assert.equal(learningTransition({ ...newJourney(), phase: 'diagnostic-result' }, 'start-review'), null);
});

test('FR-C5-01/03/05/08: validation consumes valid eligible evidence and applies only the approved matrix', () => {
  const retry: Journey = { ...newJourney(), selectedTopic: 'spl', phase: 'retry', origin: 'confirmed-recovery',
    diagnosticOutcome: 'confirmed', learningCompleted: true };
  for (const evaluation of ['insufficient', 'known-error'] as const) assert.equal(validationTransition(retry, evaluation), null);
  for (const invalid of [
    { ...retry, origin: 'optional-review' as const }, { ...retry, diagnosticOutcome: 'uncertain' as const },
    { ...retry, learningCompleted: false },
  ]) assert.equal(validationTransition(invalid, 'correct'), null);
  const failed = validationTransition(retry, 'incorrect')!;
  assert.equal(failed.learnerState, 'needs-reinforcement');
  assert.equal(validationTransition(failed, 'correct'), null);
  const transfer = validationTransition(retry, 'correct')!;
  assert.equal(transfer.phase, 'transfer');
  assert.equal(transfer.learnerState, null);
  assert.equal(validationTransition(transfer, 'incorrect')!.learnerState, 'procedural-only');
  assert.equal(validationTransition(transfer, 'correct')!.learnerState, 'understood');
});

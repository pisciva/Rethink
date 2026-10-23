import type { Journey, Observation } from './model.ts';

/** C5 consumes valid evaluations only; it never diagnoses a conceptual blocker. */
export function validationTransition(journey: Journey, evaluation: Observation): Journey | null {
  if (journey.origin !== 'confirmed-recovery' || journey.diagnosticOutcome !== 'confirmed' || !journey.learningCompleted ||
      (evaluation !== 'correct' && evaluation !== 'incorrect')) return null;
  if (journey.phase === 'retry') return evaluation === 'correct'
    ? { ...journey, phase: 'transfer' }
    : { ...journey, phase: 'validation-result', learnerState: 'needs-reinforcement' };
  if (journey.phase === 'transfer') return {
    ...journey, phase: 'validation-result', learnerState: evaluation === 'correct' ? 'understood' : 'procedural-only',
  };
  return null;
}

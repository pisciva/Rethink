import type { Action, Journey, Observation } from './model.ts';

/** C4 linear curated package; OPS-01/02 rules approved for implementation on 23 October 2026. */
export function learningTransition(journey: Journey, action: Action): Journey | null {
  if (action === 'start-recovery' && journey.phase === 'diagnostic-result' && journey.diagnosticOutcome === 'confirmed') return { ...journey, phase: 'visual', origin: 'confirmed-recovery', learningCompleted: false };
  if (action === 'start-review' && journey.phase === 'diagnostic-result' && (journey.diagnosticOutcome === 'rejected' || journey.diagnosticOutcome === 'uncertain')) return { ...journey, phase: 'visual', origin: 'optional-review', learningCompleted: false };
  if (action === 'advance' && journey.phase === 'visual') return { ...journey, phase: 'worked' };
  if (action === 'advance' && journey.phase === 'worked') return { ...journey, phase: 'practice' };
  if (action === 'reinforce' && journey.phase === 'validation-result' && journey.origin === 'confirmed-recovery' && (journey.learnerState === 'needs-reinforcement' || journey.learnerState === 'procedural-only')) {
    return { ...journey, phase: 'visual', learningCompleted: false, learnerState: null };
  }
  return null;
}


export function completePractice(journey: Journey, observation: Observation): Journey | null {
  if (journey.phase !== 'practice' || journey.origin === null ||
      (observation !== 'correct' && observation !== 'incorrect')) return null;
  if (journey.origin === 'confirmed-recovery' && journey.diagnosticOutcome !== 'confirmed') return null;
  if (journey.origin === 'optional-review' && journey.diagnosticOutcome !== 'rejected' && journey.diagnosticOutcome !== 'uncertain') return null;
  return observation === 'correct'
    ? { ...journey, learningCompleted: true, phase: journey.origin === 'confirmed-recovery' ? 'retry' : 'review-complete' }
    : journey;
}

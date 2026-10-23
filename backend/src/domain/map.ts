import type { Journey, PublicJourney } from './model.ts';

/** C2 projects C3/C5 evidence. Graph edges do not create personal judgments. */
export function projectMap(journey: Journey): PublicJourney['map'] {
  return { explore: journey.selectedTopic, focus: journey.diagnosticOutcome === 'confirmed' ? 'distribution' : null,
    progress: journey.phase === 'validation-result' ? journey.learnerState : null };
}

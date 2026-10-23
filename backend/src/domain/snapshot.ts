import { CONTENT_VERSION, questions } from '../content/distribution.ts';
import { evidenceFor, newJourney, submitAnswer, transition, type Journey, type Observation, type Phase } from './journey.ts';
const phases: Phase[] = ['entry', 'diagnosis', 'diagnostic-result', 'diagnostic-decision-pending', 'visual', 'worked', 'practice', 'review-complete', 'retry', 'transfer', 'validation-result'];
const outcomes = ['confirmed', 'rejected', 'uncertain'];
const learnerStates = ['understood', 'procedural-only', 'needs-reinforcement'];
const observations = ['correct', 'known-error', 'incorrect', 'insufficient'];
const byId = new Map(Object.values(questions).map(q => [q.id, q]));

// These are existing, evidence-free navigation steps, not new recovery rules.
// Reconstructing them validates reachability without changing the saved record.
function nextNavigationStep(journey: Journey): Journey | null {
  switch (journey.phase) {
    case 'diagnostic-result':
      return transition(journey, journey.diagnosticOutcome === 'confirmed' ? 'start-recovery' : 'start-review');
    case 'visual':
    case 'worked':
      return transition(journey, 'advance');
    case 'validation-result':
      return transition(journey, 'reinforce');
    default:
      return null;
  }
}

/** Check the current bank's stored history against the existing engine, without AI/network calls. */
function historyMatches(journey: Journey): boolean {
  let replay = newJourney();
  if (journey.selectedTopic === 'spl') replay = transition(replay, 'select-topic')!;
  for (const attempt of journey.attempts) {
    let submitted: Journey | null = null;
    // At most recovery/reinforce -> visual -> worked -> practice between answers.
    for (let step = 0; step < 4; step++) {
      submitted = submitAnswer(replay, attempt.questionId, attempt.answer, attempt.at,
        attempt.interpretationSource === 'gateway'
          ? { observation: attempt.observation, source: 'gateway' } : undefined);
      if (submitted) break;
      const next = nextNavigationStep(replay);
      if (!next) return false;
      replay = next;
    }
    if (!submitted) return false;
    const evaluated = submitted.attempts[submitted.attempts.length - 1];
    if (evaluated.observation !== attempt.observation ||
        evaluated.interpretationSource !== attempt.interpretationSource) return false;
    replay = submitted;
  }
  // The learner may have navigated to a learning screen since their last answer.
  for (let step = 0; replay.phase !== journey.phase && step < 3; step++) {
    const next = nextNavigationStep(replay);
    if (!next) return false;
    replay = next;
  }
  return replay.phase === journey.phase && replay.selectedTopic === journey.selectedTopic &&
    replay.origin === journey.origin && replay.diagnosticOutcome === journey.diagnosticOutcome &&
    replay.learningCompleted === journey.learningCompleted && replay.learnerState === journey.learnerState;
}

/** Validate private service-role data before using it as an authoritative session. */
export function readJourney(value: unknown): Journey | null {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return null;
  const row = value as Record<string, unknown>;
  if (row.version !== 2 || row.contentVersion !== CONTENT_VERSION || row.concept !== 'distribution' || !phases.includes(row.phase as Phase)) return null;
  if (row.selectedTopic !== null && row.selectedTopic !== 'spl') return null;
  if (row.origin !== null && row.origin !== 'confirmed-recovery' && row.origin !== 'optional-review') return null;
  if (row.diagnosticOutcome !== null && !outcomes.includes(String(row.diagnosticOutcome))) return null;
  if (typeof row.learningCompleted !== 'boolean') return null;
  if (row.learnerState !== null && !learnerStates.includes(String(row.learnerState))) return null;
  if (row.phase !== 'validation-result' && row.learnerState !== null) return null;
  if (!Array.isArray(row.attempts) || row.attempts.length > 100) return null;
  for (const raw of row.attempts) {
    if (!raw || typeof raw !== 'object' || Array.isArray(raw)) return null;
    const attempt = raw as Record<string, unknown>;
    const q = byId.get(String(attempt.questionId));
    if (!q || attempt.role !== q.role || typeof attempt.answer !== 'string' || attempt.answer.length > (q.role === 'q3-reasoning' ? 1200 : 160) || !observations.includes(String(attempt.observation)) || typeof attempt.at !== 'string' || !Number.isFinite(Date.parse(attempt.at))) return null;
    if (!attempt.evidence || typeof attempt.evidence !== 'object' || Array.isArray(attempt.evidence)) return null;
    const evidence = attempt.evidence as Record<string, unknown>;
    const expectedEvidence = evidenceFor(q.role, attempt.observation as Observation);
    if (evidence.category !== expectedEvidence.category || evidence.direction !== expectedEvidence.direction) return null;
    if (attempt.interpretationSource !== undefined &&
      (q.role !== 'q3-reasoning' || !['curated', 'gateway'].includes(String(attempt.interpretationSource)))) return null;
  }
  if (row.phase === 'entry' && (row.selectedTopic !== null || row.origin !== null || row.diagnosticOutcome !== null || row.learningCompleted !== false || row.learnerState !== null || row.attempts.length > 0)) return null;
  if (row.phase !== 'entry' && row.selectedTopic !== 'spl') return null;
  if (['diagnosis', 'diagnostic-result', 'diagnostic-decision-pending'].includes(String(row.phase)) && row.origin !== null) return null;
  if (row.phase === 'diagnosis' && row.diagnosticOutcome !== null) return null;
  if (row.phase === 'diagnostic-decision-pending' && (row.diagnosticOutcome !== null || row.learnerState !== null)) return null;
  if (row.phase === 'diagnostic-result' && row.diagnosticOutcome === null) return null;
  if (['entry', 'diagnosis', 'diagnostic-result', 'diagnostic-decision-pending', 'review-complete'].includes(String(row.phase)) && row.learnerState !== null) return null;
  if (['retry', 'transfer', 'validation-result', 'review-complete'].includes(String(row.phase)) && row.learningCompleted !== true) return null;
  if (['entry', 'diagnosis', 'diagnostic-result', 'diagnostic-decision-pending', 'visual', 'worked', 'practice'].includes(String(row.phase)) && row.learningCompleted !== false) return null;
  if (['visual', 'worked', 'practice', 'review-complete', 'retry', 'transfer', 'validation-result'].includes(String(row.phase)) && row.origin === null) return null;
  if (row.origin === 'confirmed-recovery' && row.diagnosticOutcome !== 'confirmed') return null;
  if (row.origin === 'optional-review' && (row.diagnosticOutcome === 'confirmed' || row.learnerState !== null || ['retry', 'transfer', 'validation-result'].includes(String(row.phase)))) return null;
  if (row.phase === 'validation-result' && row.learnerState === null) return null;
  const journey = row as Journey;
  return historyMatches(journey) ? journey : null;
}

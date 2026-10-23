import { parseLinear } from './mathematics.ts';
import { evaluateAnswer } from './evaluation.ts';
import { CONTENT_VERSION, learningAssets, publicQuestion, questions } from '../content/distribution.ts';
import { diagnosticStatus, evidenceFor, reasoningNeedsReview } from './diagnosis.ts';
import { learningTransition, completePractice } from './learning.ts';
import { validationTransition } from './validation.ts';
import { projectMap } from './map.ts';
import { resultExplanationFor } from '../content/results.ts';
import { projectPresentation } from './presentation.ts';
import type { Action, Journey, Observation, PublicJourney, SubmissionIssue } from './model.ts';
export type * from './model.ts';
export { evidenceFor, explanationObservation, reasoningNeedsReview } from './diagnosis.ts';

export function newJourney(): Journey {
  return { version: 2, contentVersion: CONTENT_VERSION, concept: 'distribution', selectedTopic: null, phase: 'entry', origin: null, diagnosticOutcome: null, learningCompleted: false, learnerState: null, attempts: [] };
}

function currentKey(journey: Journey): keyof typeof questions | null {
  if (journey.phase === 'diagnosis') return ['q1', 'q2', 'q3', 'q4'][journey.attempts.filter(a => a.role.startsWith('q')).length] as keyof typeof questions || null;
  if (journey.phase === 'practice' || journey.phase === 'retry' || journey.phase === 'transfer') return journey.phase;
  return null;
}

export function submissionIssue(journey: Journey, questionId: string, raw: string): SubmissionIssue {
  if (journey.attempts.length >= 100) return 'attempt_limit';
  const key = currentKey(journey);
  if (!key || questions[key].id !== questionId) return 'stale_question';
  if (questions[key].format === 'expression' && /[()]/.test(raw) && parseLinear(raw)) return 'expanded_form_required';
  return 'invalid_answer';
}

export function submitAnswer(
  journey: Journey, questionId: string, raw: string,
  at = new Date().toISOString(),
  reasoningAdvice?: { observation: Observation; source: 'curated' | 'gateway' },
): Journey | null {
  const key = currentKey(journey);
  if (!key || questions[key].id !== questionId || !Number.isFinite(Date.parse(at)) || journey.attempts.length >= 100) return null;
  const localResult = evaluateAnswer(key, raw);
  const result = key === 'q3' && localResult === 'insufficient' && !reasoningNeedsReview(raw) && reasoningAdvice?.source === 'gateway' && reasoningAdvice.observation === 'correct'
    ? 'correct' : localResult;
  if (!result) return null;
  const role = questions[key].role;
  const attempts = [...journey.attempts, {
    questionId,
    role,
    answer: raw.trim(),
    observation: result,
    evidence: evidenceFor(role, result),
    at,
    ...(key === 'q3' ? { interpretationSource: result === 'correct' && localResult === 'insufficient' ? 'gateway' as const : 'curated' as const } : {}),
  }];
  const next: Journey = { ...journey, attempts };
  if (journey.phase === 'diagnosis') {
    const status = diagnosticStatus(attempts);
    if (status === null || status === 'probe') return next;
    return { ...next, phase: 'diagnostic-result', diagnosticOutcome: status };
  }
  if (journey.phase === 'practice') return completePractice(next, result);
  return validationTransition(next, result);
}

export function transition(journey: Journey, action: Action): Journey | null {
  if (action === 'reset') return newJourney();
  if (action === 'select-topic' && journey.phase === 'entry') return { ...journey, selectedTopic: 'spl', phase: 'diagnosis' };
  return learningTransition(journey, action);
}

export function publicJourney(journey: Journey): PublicJourney {
  const key = currentKey(journey);
  const availableActions: Action[] = journey.attempts.length >= 100 && key !== null ? ['reset'] : journey.phase === 'entry'
    ? ['select-topic']
    : journey.phase === 'diagnostic-result'
      ? journey.diagnosticOutcome === 'confirmed' ? ['start-recovery'] : ['start-review']
      : journey.phase === 'visual' || journey.phase === 'worked'
        ? ['advance']
        : journey.phase === 'validation-result' && journey.learnerState !== 'understood'
          ? ['reinforce']
          : [];
  return {
    version: 2, contentVersion: journey.contentVersion, concept: 'distribution', selectedTopic: journey.selectedTopic, phase: journey.phase, origin: journey.origin,
    currentQuestion: key ? publicQuestion(questions[key]) : null,
    learningContent: journey.phase === 'visual' ? learningAssets.visual : journey.phase === 'worked' ? learningAssets.worked : null,
    diagnosticOutcome: journey.phase === 'diagnostic-result' || journey.origin ? journey.diagnosticOutcome : null,
    learningCompleted: journey.learningCompleted,
    learnerState: journey.phase === 'validation-result' ? journey.learnerState : null,
    resultExplanation: resultExplanationFor(journey), availableActions,
    attempts: journey.attempts.map(({ questionId, role, answer, at }) => ({ questionId, role, answer, at })),
    map: projectMap(journey),
    operationalStatus: 'implementation-approved-expert-review-pending',
    presentation: projectPresentation(journey),
  };
}

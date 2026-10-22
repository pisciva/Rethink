import { CONTENT_VERSION, questions } from './content.ts';
import {
  evidenceFor,
  submitAnswer,
  transition,
  type Action,
  type Journey,
  type Observation,
  type Phase,
} from './engine.ts';

export type Command = { action: 'submit' | Action; concept: 'distribution'; expectedRevision: number; topicId?: 'spl'; questionId?: string; answer?: string };
const actions = ['submit', 'select-topic', 'advance', 'start-recovery', 'start-review', 'start-validation', 'reinforce', 'reset'];
const phases: Phase[] = ['entry', 'diagnosis', 'diagnostic-result', 'diagnostic-decision-pending', 'visual', 'worked', 'practice', 'review-complete', 'retry', 'transfer', 'validation-result'];
const outcomes = ['confirmed', 'rejected', 'uncertain'];
const learnerStates = ['understood', 'procedural-only', 'needs-reinforcement'];
const observations = ['correct', 'known-error', 'incorrect', 'insufficient'];
const byId = new Map(Object.values(questions).map(q => [q.id, q]));

export function parseCommand(body: Record<string, unknown>): Command | null {
  if (body.grade !== undefined && body.grade !== 10) return null;
  if (body.moduleId !== undefined && body.moduleId !== 'x-linear') return null;
  if (body.concept !== 'distribution' || !actions.includes(String(body.action)) || !Number.isSafeInteger(body.expectedRevision) || Number(body.expectedRevision) < 0 || Number(body.expectedRevision) >= 2147483647) return null;
  if (body.action === 'submit' && (typeof body.questionId !== 'string' || typeof body.answer !== 'string' || body.answer.length > 1200)) return null;
  if (body.action === 'select-topic' && body.topicId !== 'spl') return null;
  return {
    concept: 'distribution', action: body.action as Command['action'], expectedRevision: Number(body.expectedRevision),
    ...(body.action === 'select-topic' ? { topicId: 'spl' as const } : {}),
    ...(body.action === 'submit' ? { questionId: body.questionId as string, answer: body.answer as string } : {}),
  };
}

export function applyCommand(
  journey: Journey, command: Command,
  reasoningAdvice?: { observation: Observation; source: 'curated' | 'gateway' },
): Journey | null {
  return command.action === 'submit'
    ? submitAnswer(journey, command.questionId!, command.answer!, undefined, reasoningAdvice)
    : transition(journey, command.action);
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
      (q.role !== 'q3-reasoning' || !['curated', 'gateway', 'gemini'].includes(String(attempt.interpretationSource)))) return null;
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
  return row as Journey;
}

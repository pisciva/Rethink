import { submitAnswer, transition, type Action, type Journey, type Observation } from '../domain/journey.ts';

export type Command = { action: 'submit' | Action; concept: 'distribution'; expectedRevision: number; topicId?: 'spl'; questionId?: string; answer?: string };
const actions = ['submit', 'select-topic', 'advance', 'start-recovery', 'start-review', 'start-validation', 'reinforce', 'reset'];

export function parseCommand(body: Record<string, unknown>): Command | null {
  const allowed = ['action', 'concept', 'expectedRevision', 'topicId', 'questionId', 'answer'];
  if (Object.keys(body).some(key => !allowed.includes(key))) return null;
  if (body.concept !== 'distribution' || (typeof body.action !== 'string' || !actions.includes(body.action)) || !Number.isSafeInteger(body.expectedRevision) || Number(body.expectedRevision) < 0 || Number(body.expectedRevision) >= 2147483647) return null;
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


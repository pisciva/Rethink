import { type QuestionRole } from '../content/distribution.ts';
import type { Attempt, AttemptEvidence, DiagnosticOutcome, EvidenceCategory, EvidenceDirection, Observation } from './model.ts';

const categoryByRole: Record<QuestionRole, EvidenceCategory> = {
  'q1-target': 'outcome',
  'q2-application': 'transformation',
  'q3-reasoning': 'explanation',
  'q4-trace': 'procedural-trace',
  practice: 'outcome',
  retry: 'outcome',
  transfer: 'outcome',
};

function directionFor(role: QuestionRole, observation: Observation): EvidenceDirection {
  if (role === 'practice' || role === 'retry' || role === 'transfer') return 'neutral';
  if (observation === 'correct') return 'contradictory';
  if (observation === 'known-error') return 'supporting';
  return 'insufficient';
}

export function evidenceFor(role: QuestionRole, observation: Observation): AttemptEvidence {
  return { category: categoryByRole[role], direction: directionFor(role, observation) };
}
/** Conservative guard: explicit uncertainty or conflicting claims cannot establish evidence. */
export function reasoningNeedsReview(raw: string): boolean {
  const text = raw.toLowerCase().replace(/\s+/g, ' ').trim();
  if (/\b(tidak|belum|kurang) (tahu|yakin|paham|mengerti)\b|\bragu(-ragu)?\b|\bapakah\b/.test(text)) return true;
  const claimsCorrectExpansion = /5x/.test(text) && /\b10\b/.test(text)
    && /(setiap suku|semua suku|x.{0,30}(2|dua)|2.{0,30}x)/.test(text);
  const claimsUnchangedConstant = /\b2\b.{0,20}(tetap|tidak dikali)/.test(text);
  return claimsCorrectExpansion && claimsUnchangedConstant;
}

export function explanationObservation(raw: string): Observation {
  const text = raw.toLowerCase().replace(/\s+/g, ' ').trim();
  if (!text || text.length > 1200 || reasoningNeedsReview(raw)) return 'insufficient';
  const negatedMisconception = /bukan hanya|tidak hanya/.test(text);
  if (!negatedMisconception && /hanya.{0,35}(x|variabel)|\b2\b.{0,20}(tetap|tidak dikali)|tidak.{0,20}(angka 2|konstanta)/.test(text)) return 'known-error';
  if (/5x/.test(text) && /\b10\b/.test(text) && /(setiap suku|semua suku|x.{0,30}(2|dua)|2.{0,30}x)/.test(text)) return 'correct';
  return 'insufficient';
}

function coreOutcome(attempts: Attempt[]): DiagnosticOutcome | 'probe' {
  const q1 = attempts.find(a => a.role === 'q1-target')?.observation;
  const q2 = attempts.find(a => a.role === 'q2-application')?.observation;
  const q3 = attempts.find(a => a.role === 'q3-reasoning')?.observation;
  // OI-03: user-approved 23 October 2026. This rejects the examined blocker,
  // never establishes SPL mastery or a C5 learner state.
  if (q1 === 'correct' && q2 === 'correct' && q3 === 'correct') return 'rejected';
  if (q2 === 'known-error' && q3 === 'known-error' && q1 !== 'correct') return 'confirmed';
  if (q2 === 'correct' && q3 === 'correct') return 'rejected';
  return 'probe';
}

export function diagnosticStatus(attempts: Attempt[]): DiagnosticOutcome | 'probe' | null {
  if (attempts.filter(a => ['q1-target', 'q2-application', 'q3-reasoning'].includes(a.role)).length < 3) return null;
  const core = coreOutcome(attempts);
  if (core !== 'probe') return core;
  if (!attempts.some(a => a.role === 'q4-trace')) return 'probe';
  const q1 = attempts.find(a => a.role === 'q1-target')?.observation;
  const q2 = attempts.find(a => a.role === 'q2-application')?.observation;
  const q3 = attempts.find(a => a.role === 'q3-reasoning')?.observation;
  const q4 = attempts.find(a => a.role === 'q4-trace')?.observation;
  return q1 !== 'correct' && q2 === 'known-error' && q3 !== 'correct' && q4 === 'known-error' ? 'confirmed' : 'uncertain';
}

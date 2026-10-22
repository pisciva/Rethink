import { equivalent, parseLinear } from '../math.ts';
import { CONTENT_VERSION, learningAssets, publicQuestion, questions, type PublicQuestion, type QuestionRole } from './content.ts';

export type Phase = 'entry' | 'diagnosis' | 'diagnostic-result' | 'diagnostic-decision-pending' | 'visual' | 'worked' | 'practice' | 'review-complete' | 'retry' | 'transfer' | 'validation-result';
export type DiagnosticOutcome = 'confirmed' | 'rejected' | 'uncertain';
export type LearnerState = 'understood' | 'procedural-only' | 'needs-reinforcement';
export type Observation = 'correct' | 'known-error' | 'incorrect' | 'insufficient';
export type EvidenceCategory = 'outcome' | 'transformation' | 'explanation' | 'procedural-trace';
export type EvidenceDirection = 'supporting' | 'contradictory' | 'insufficient' | 'neutral';
export type AttemptEvidence = { category: EvidenceCategory; direction: EvidenceDirection };
export type Attempt = { questionId: string; role: QuestionRole; answer: string; observation: Observation; evidence: AttemptEvidence; at: string; interpretationSource?: 'curated' | 'gateway' | 'gemini' };
export type SubmissionIssue = 'stale_question' | 'expanded_form_required' | 'invalid_answer';

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
export type Journey = { version: 2; contentVersion: typeof CONTENT_VERSION; concept: 'distribution'; selectedTopic: 'spl' | null; phase: Phase; origin: 'confirmed-recovery' | 'optional-review' | null; diagnosticOutcome: DiagnosticOutcome | null; learningCompleted: boolean; learnerState: LearnerState | null; attempts: Attempt[] };
export type PublicJourney = {
  version: 2;
  contentVersion: string;
  concept: 'distribution';
  selectedTopic: 'spl' | null;
  phase: Phase;
  origin: Journey['origin'];
  currentQuestion: PublicQuestion | null;
  learningContent: typeof learningAssets.visual | typeof learningAssets.worked | null;
  diagnosticOutcome: DiagnosticOutcome | null;
  learningCompleted: boolean;
  learnerState: LearnerState | null;
  resultExplanation: string | null;
  availableActions: Action[];
  attempts: { questionId: string; role: QuestionRole; answer: string; at: string }[];
  map: { explore: 'spl' | null; focus: 'distribution' | null; progress: LearnerState | null };
  operationalStatus: 'draft-ops-01-05';
};

export function newJourney(): Journey {
  return { version: 2, contentVersion: CONTENT_VERSION, concept: 'distribution', selectedTopic: null, phase: 'entry', origin: null, diagnosticOutcome: null, learningCompleted: false, learnerState: null, attempts: [] };
}

function currentKey(journey: Journey): keyof typeof questions | null {
  if (journey.phase === 'diagnosis') return ['q1', 'q2', 'q3', 'q4'][journey.attempts.filter(a => a.role.startsWith('q')).length] as keyof typeof questions || null;
  if (journey.phase === 'practice' || journey.phase === 'retry' || journey.phase === 'transfer') return journey.phase;
  return null;
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

function observation(key: keyof typeof questions, raw: string): Observation | null {
  const question = questions[key];
  const answer = raw.trim();
  if (!answer || answer.length > (key === 'q3' ? 1200 : 160)) return null;
  if (question.format === 'explanation') return explanationObservation(answer);
  if (question.format === 'choice') {
    if (!question.options?.some(option => option.id === answer)) return null;
    return answer === question.expected ? 'correct' : answer === question.knownError ? 'known-error' : 'incorrect';
  }
  if (question.format === 'expression' && /[()]/.test(answer)) return null; // Draft task asks for expanded form.
  const correct = equivalent(answer, question.expected!, question.format);
  if (correct === null) return null;
  if (correct) return 'correct';
  return question.knownError && equivalent(answer, question.knownError, question.format) === true ? 'known-error' : 'incorrect';
}

function coreOutcome(attempts: Attempt[]): DiagnosticOutcome | 'probe' | 'pending' {
  const q1 = attempts.find(a => a.role === 'q1-target')?.observation;
  const q2 = attempts.find(a => a.role === 'q2-application')?.observation;
  const q3 = attempts.find(a => a.role === 'q3-reasoning')?.observation;
  if (q1 === 'correct' && q2 === 'correct' && q3 === 'correct') return 'pending'; // OI-03 remains open.
  if (q2 === 'known-error' && q3 === 'known-error' && q1 !== 'correct') return 'confirmed';
  if (q2 === 'correct' && q3 === 'correct') return 'rejected';
  return 'probe';
}

export function submissionIssue(journey: Journey, questionId: string, raw: string): SubmissionIssue {
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
  const localResult = observation(key, raw);
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
    const coreCount = attempts.filter(a => ['q1-target', 'q2-application', 'q3-reasoning'].includes(a.role)).length;
    if (coreCount < 3) return next;
    const core = coreOutcome(attempts);
    if (core === 'pending') return { ...next, phase: 'diagnostic-decision-pending' };
    if (core !== 'probe') return { ...next, phase: 'diagnostic-result', diagnosticOutcome: core };
    if (!attempts.some(a => a.role === 'q4-trace')) return next;
    const q1 = attempts.find(a => a.role === 'q1-target')?.observation;
    const q2 = attempts.find(a => a.role === 'q2-application')?.observation;
    const q3 = attempts.find(a => a.role === 'q3-reasoning')?.observation;
    const q4 = attempts.find(a => a.role === 'q4-trace')?.observation;
    return { ...next, phase: 'diagnostic-result', diagnosticOutcome: q1 !== 'correct' && q2 === 'known-error' && q3 !== 'correct' && q4 === 'known-error' ? 'confirmed' : 'uncertain' };
  }
  if (journey.phase === 'practice') return result === 'correct' ? { ...next, learningCompleted: true, phase: journey.origin === 'confirmed-recovery' ? 'retry' : 'review-complete' } : next;
  if (journey.phase === 'retry') return result === 'correct' ? { ...next, phase: 'transfer' } : { ...next, phase: 'validation-result', learnerState: 'needs-reinforcement' };
  if (journey.phase === 'transfer') return { ...next, phase: 'validation-result', learnerState: result === 'correct' ? 'understood' : 'procedural-only' };
  return null;
}

export type Action = 'select-topic' | 'advance' | 'start-recovery' | 'start-review' | 'start-validation' | 'reinforce' | 'reset';
export function transition(journey: Journey, action: Action): Journey | null {
  if (action === 'reset') return newJourney();
  if (action === 'select-topic' && journey.phase === 'entry') return { ...journey, selectedTopic: 'spl', phase: 'diagnosis' };
  if (action === 'start-recovery' && journey.phase === 'diagnostic-result' && journey.diagnosticOutcome === 'confirmed') return { ...journey, phase: 'visual', origin: 'confirmed-recovery', learningCompleted: false };
  if (action === 'start-review' && journey.phase === 'diagnostic-result' && journey.diagnosticOutcome !== 'confirmed') return { ...journey, phase: 'visual', origin: 'optional-review', learningCompleted: false };
  if (action === 'advance' && journey.phase === 'visual') return { ...journey, phase: 'worked' };
  if (action === 'advance' && journey.phase === 'worked') return { ...journey, phase: 'practice' };
  if (action === 'reinforce' && journey.phase === 'validation-result' && journey.origin === 'confirmed-recovery' && journey.learnerState !== 'understood') {
    return { ...journey, phase: 'visual', learningCompleted: false, learnerState: null };
  }
  return null;
}

function resultExplanationFor(journey: Journey): string | null {
  if (journey.phase === 'diagnostic-decision-pending') {
    return 'Semua jawaban inti benar. Pemetaan hasil dan kelanjutan belum mendapat keputusan produk final.';
  }
  if (journey.phase === 'diagnostic-result') {
    if (journey.diagnosticOutcome === 'confirmed') return 'Bukti pada tugas yang dinilai mendukung hambatan Sifat Distributif. Lanjutkan ke pemulihan konsep.';
    if (journey.diagnosticOutcome === 'rejected') return 'Bukti pada tugas yang dinilai tidak mendukung hambatan Sifat Distributif. Ini bukan bukti penguasaan seluruh SPL.';
    return 'Bukti untuk menentukan hambatan Sifat Distributif belum cukup. Kamu dapat meninjau konsep secara opsional.';
  }
  if (journey.phase === 'review-complete') {
    return 'Ulasan konsep selesai. Ulasan ini tidak mengubah hasil diagnosis dan tidak membuka validasi pada versi ini.';
  }
  if (journey.phase === 'validation-result') {
    if (journey.learnerState === 'understood') return 'Kamu berhasil menerapkan Sifat Distributif secara mandiri dan pada tugas transfer yang dinilai. Hasil ini tidak menyatakan penguasaan seluruh SPL.';
    if (journey.learnerState === 'procedural-only') return 'Penerapan mandiri berhasil, tetapi tugas transfer Sifat Distributif belum berhasil. Kamu dapat mengulang paket belajar.';
    return 'Independent Retry Sifat Distributif belum berhasil. Transfer tidak diberikan; ulangi paket belajar sebelum mencoba kembali.';
  }
  return null;
}

export function publicJourney(journey: Journey): PublicJourney {
  const key = currentKey(journey);
  const availableActions: Action[] = journey.phase === 'entry'
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
    map: {
      explore: journey.selectedTopic,
      focus: journey.diagnosticOutcome === 'confirmed' ? 'distribution' : null,
      progress: journey.phase === 'validation-result' ? journey.learnerState : null,
    },
    operationalStatus: 'draft-ops-01-05',
  };
}

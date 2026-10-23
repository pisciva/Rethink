import { primaryItems, distributionProbe, learningItems, finalItems, concepts, hints, BANK_VERSION, visibleItem } from './content.ts';
import { equivalent } from '../domain/mathematics.ts';
import { explanationObservation, verifiedReasoningQuote } from '../domain/diagnosis.ts';
import { learningAssets } from '../content/distribution.ts';
import type { Answer, Command, ConceptId, Event, EvidenceStatus, Item, Session, State } from './types.ts';
import type { Observation } from '../domain/model.ts';

export function initialState(): State {
  return { phase: 'entry', selectedTopic: null, diagnosticAnswers: [], diagnosisComplete: false, conceptLearnerState: null, learning: null, finalAttempts: [], hints: [] };
}
export function newSession(): Session { return { version: 1, bankVersion: BANK_VERSION, events: [] }; }

export function evaluateItem(item: Item, raw: string): Observation | null {
  const answer = raw.trim();
  if (!answer || answer.length > (item.format === 'explanation' ? 1200 : 160)) return null;
  if (item.format === 'explanation') return explanationObservation(answer);
  if (item.format === 'choice') {
    if (!item.options?.some(o => o.id === answer)) return null;
    return answer === item.expected ? 'correct' : item.knownErrors?.includes(answer) ? 'known-error' : 'incorrect';
  }
  if (item.format === 'expression' && /[()]/.test(answer)) return null;
  const format = item.format;
  const correct = equivalent(answer, item.expected!, format);
  if (correct === null) return null;
  return correct ? 'correct' : item.knownErrors?.some(error => equivalent(answer, error, format) === true) ? 'known-error' : 'incorrect';
}

export function conceptResults(state: State) {
  return concepts.map(concept => {
    const attributed = state.diagnosticAnswers.filter(a => {
      const item = primaryItems.find(q => q.id === a.questionId) ?? (a.questionId === distributionProbe.id ? distributionProbe : null);
      return item?.attribution === concept.id;
    });
    const supporting = attributed.filter(a => a.observation === 'known-error').map(a => a.questionId);
    const contradictory = attributed.filter(a => a.observation === 'correct').map(a => a.questionId);
    // A correct contextual SPL response is counterevidence, never an extra direct
    // correct item used to claim adequate concept coverage.
    const targetCounterevidence = concept.id === 'distribution' && state.diagnosticAnswers.some(a => a.questionId === primaryItems[0].id && a.observation === 'correct');
    const assessed = attributed.filter(a => a.observation === 'correct' || a.observation === 'known-error');
    let status: EvidenceStatus = 'insufficiently-assessed';
    if (assessed.length >= 2) {
      if (supporting.length >= 2 && contradictory.length === 0 && !targetCounterevidence) status = 'supported';
      else if (contradictory.length >= 2 && supporting.length === 0) status = 'not-supported';
      else if (supporting.length > 0 && (contradictory.length > 0 || targetCounterevidence)) status = 'uncertain';
    }
    return { ...concept, status, coverage: { administered: attributed.length, evaluable: assessed.length, adequate: assessed.length >= 2 },
      priority: status === 'supported' ? 'recommended' : 'optional',
      evidence: { supporting, contradictory, contextualCounterevidence: targetCounterevidence ? [primaryItems[0].id] : [] },
      learnerState: concept.id === 'distribution' ? state.conceptLearnerState : null };
  });
}

export function needsProbe(state: State): boolean {
  return state.diagnosticAnswers.length === 10 && conceptResults(state)[0].status === 'insufficiently-assessed';
}
export function currentItem(state: State): Item | null {
  if (state.phase === 'diagnosis') return state.diagnosticAnswers.length < 10 ? primaryItems[state.diagnosticAnswers.length] : needsProbe(state) ? distributionProbe : null;
  if (state.phase === 'practice' || state.phase === 'retry' || state.phase === 'transfer') return learningItems[state.phase];
  if (state.phase === 'final-assessment') return finalItems[state.finalAttempts.at(-1)?.answers.length ?? 0] ?? null;
  return null;
}

export function nextHint(state: State) {
  if (!['visual', 'worked', 'practice'].includes(state.phase) || !state.learning) return null;
  const stage = state.phase as keyof typeof hints;
  const count = state.hints.filter(h => h.stage === stage && h.cycle === state.learning!.cycle).length;
  return hints[stage][count] ?? null;
}

export function reduceEvent(previous: State, event: Event): State | null {
  if (!Number.isFinite(Date.parse(event.at))) return null;
  const state = structuredClone(previous);
  if (event.adviceQuote !== undefined && (event.action !== 'submit' || currentItem(state)?.id !== primaryItems[2].id)) return null;
  if ((event.hintId !== undefined || event.hintSource !== undefined) && event.action !== 'request-hint') return null;
  switch (event.action) {
    case 'select-topic':
      if (state.phase !== 'entry' || event.topicId !== 'spl') return null;
      return { ...state, selectedTopic: 'spl', phase: 'diagnosis' };
    case 'submit': {
      const item = currentItem(state);
      if (!item || item.id !== event.questionId || typeof event.answer !== 'string') return null;
      let observation = evaluateItem(item, event.answer);
      let source: Answer['source'] = 'curated';
      if (event.adviceQuote !== undefined) {
        if (item.id !== primaryItems[2].id || observation !== 'insufficient' || !verifiedReasoningQuote(event.answer, { label: 'correct', quote: event.adviceQuote })) return null;
        observation = 'correct'; source = 'gateway';
      }
      if (!observation) return null;
      const answer: Answer = { questionId: item.id, answer: event.answer.trim(), observation, source, at: event.at };
      if (state.phase === 'diagnosis') {
        state.diagnosticAnswers.push(answer);
        if (state.diagnosticAnswers.length >= 10 && !needsProbe(state)) {
          state.diagnosisComplete = true; state.phase = 'diagnostic-result';
        }
      } else if (state.phase === 'final-assessment') {
        const attempt = state.finalAttempts.at(-1)!;
        attempt.answers.push(answer);
        if (attempt.answers.length === 5) {
          attempt.score = attempt.answers.filter(a => a.observation === 'correct').length;
          attempt.result = attempt.score >= 3 ? 'passed' : 'not-passed';
          attempt.completedAt = event.at; state.phase = 'final-result';
        }
      } else {
        const learning = state.learning;
        if (!learning || (observation !== 'correct' && observation !== 'incorrect')) return null;
        learning.answers.push(answer);
        if (state.phase === 'practice' && observation === 'correct') {
          learning.completed = true;
          learning.stage = learning.origin === 'confirmed-recovery' ? 'retry' : 'complete';
          state.phase = learning.origin === 'confirmed-recovery' ? 'retry' : 'review-complete';
        } else if (state.phase === 'retry') {
          if (learning.origin !== 'confirmed-recovery' || !learning.completed) return null;
          learning.stage = observation === 'correct' ? 'transfer' : 'complete';
          learning.learnerState = observation === 'correct' ? null : 'needs-reinforcement';
          if (observation !== 'correct') state.conceptLearnerState = 'needs-reinforcement';
          state.phase = observation === 'correct' ? 'transfer' : 'validation-result';
        } else if (state.phase === 'transfer') {
          if (learning.origin !== 'confirmed-recovery' || !learning.completed) return null;
          learning.stage = 'complete';
          learning.learnerState = observation === 'correct' ? 'understood' : 'procedural-only';
          state.conceptLearnerState = learning.learnerState;
          state.phase = 'validation-result';
        }
      }
      return state;
    }
    case 'start-learning': {
      if (!state.diagnosisComplete || event.conceptId !== 'distribution' || state.phase === 'final-assessment') return null;
      if (state.learning && state.learning.stage !== 'complete') {
        state.phase = state.learning.stage; return state;
      }
      state.learning = { origin: conceptResults(state)[0].status === 'supported' ? 'confirmed-recovery' : 'optional-review', stage: 'visual', completed: false, learnerState: null, cycle: (state.learning?.cycle ?? 0) + 1, answers: [] };
      state.phase = 'visual'; return state;
    }
    case 'advance':
      if (!state.learning || (state.phase !== 'visual' && state.phase !== 'worked')) return null;
      state.phase = state.phase === 'visual' ? 'worked' : 'practice';
      state.learning.stage = state.phase; return state;
    case 'show-results':
      if (!state.diagnosisComplete || state.phase === 'final-assessment') return null;
      state.phase = 'diagnostic-result'; return state;
    case 'start-final-assessment': {
      if (!state.diagnosisComplete || state.phase === 'final-assessment' || state.finalAttempts.at(-1)?.result === 'passed') return null;
      if (!state.finalAttempts.length || state.finalAttempts.at(-1)!.result !== null) state.finalAttempts.push({ id: state.finalAttempts.length + 1, answers: [], startedAt: event.at, completedAt: null, score: null, result: null });
      state.phase = 'final-assessment'; return state;
    }
    case 'request-hint': {
      const hint = nextHint(state);
      if (!hint || event.hintId !== hint.id || !['curated', 'gateway'].includes(event.hintSource ?? '')) return null;
      state.hints.push({ stage: state.phase, cycle: state.learning!.cycle, id: hint.id, source: event.hintSource! });
      return state;
    }
    case 'restart-diagnosis':
      // Explicit restart retains topic-assessment history. It cannot erase a pass
      // or grant a prerequisite state; prior diagnostic/learning events remain.
      return { ...initialState(), finalAttempts: state.finalAttempts };
    default: return null;
  }
}

export function parseCommand(body: Record<string, unknown>): Command | null {
  const fields: Record<Command['action'], string[]> = {
    'select-topic': ['topicId'], submit: ['questionId', 'answer'], 'start-learning': ['conceptId'], advance: [], 'show-results': [], 'start-final-assessment': [], 'request-hint': ['message'], 'restart-diagnosis': [],
  };
  if (typeof body.action !== 'string' || !Object.hasOwn(fields, body.action) || !Number.isSafeInteger(body.expectedRevision) || Number(body.expectedRevision) < 0 || Number(body.expectedRevision) >= 2147483647) return null;
  const action = body.action as Command['action'];
  if (Object.keys(body).some(key => !['action', 'expectedRevision', ...fields[action]].includes(key))) return null;
  if (action === 'select-topic' && body.topicId !== 'spl') return null;
  if (action === 'start-learning' && body.conceptId !== 'distribution') return null;
  if (action === 'submit' && (typeof body.questionId !== 'string' || body.questionId.length > 80 || typeof body.answer !== 'string' || body.answer.length > 1200)) return null;
  if (action === 'request-hint' && body.message !== undefined && (typeof body.message !== 'string' || body.message.length > 500)) return null;
  return body as Command;
}

export function replay(session: Session): State | null {
  let state = initialState();
  for (const event of session.events) {
    const next = reduceEvent(state, event);
    if (!next) return null;
    state = next;
  }
  return state;
}
export function readSession(input: unknown): Session | null {
  if (!input || typeof input !== 'object' || Array.isArray(input)) return null;
  const row = input as Record<string, unknown>;
  if (Object.keys(row).some(k => !['version', 'bankVersion', 'events'].includes(k)) || row.version !== 1 || row.bankVersion !== BANK_VERSION || !Array.isArray(row.events) || row.events.length > 500) return null;
  for (const event of row.events) {
    if (!event || typeof event !== 'object' || Array.isArray(event)) return null;
    if ('expectedRevision' in event || 'message' in event) return null;
    const { at, adviceQuote, hintId, hintSource, ...command } = event;
    if (typeof at !== 'string' || !Number.isFinite(Date.parse(at)) || !parseCommand({ ...command, expectedRevision: 0 })) return null;
    if (adviceQuote !== undefined && (typeof adviceQuote !== 'string' || adviceQuote.length > 160)) return null;
    if (hintId !== undefined && typeof hintId !== 'string') return null;
    if (hintSource !== undefined && !['gateway', 'curated'].includes(hintSource)) return null;
  }
  return replay(input as Session) ? input as Session : null;
}

export function append(session: Session, command: Command, metadata: Pick<Event, 'adviceQuote' | 'hintId' | 'hintSource'> = {}, at = new Date().toISOString()): Session | null {
  if (session.events.length >= 500) return null;
  const { expectedRevision: _revision, message: _message, ...fields } = command;
  const event: Event = { ...fields, ...metadata, at };
  const state = replay(session);
  return state && reduceEvent(state, event) ? { ...session, events: [...session.events, event] } : null;
}

export function publicState(state: State) {
  const diagnosticResults = state.diagnosisComplete ? conceptResults(state) : [];
  const distribution = diagnosticResults.find(c => c.id === 'distribution');
  const current = currentItem(state);
  const learning = state.learning;
  const availableActions: Command['action'][] = [];
  if (state.phase === 'entry') availableActions.push('select-topic');
  if (state.diagnosisComplete && state.phase !== 'final-assessment') {
    if (['diagnostic-result', 'review-complete', 'validation-result', 'final-result'].includes(state.phase)) availableActions.push('start-learning');
    if (state.finalAttempts.at(-1)?.result !== 'passed') availableActions.push('start-final-assessment');
    if (state.phase !== 'diagnostic-result') availableActions.push('show-results');
  }
  if (state.phase === 'visual' || state.phase === 'worked') availableActions.push('advance');
  if (nextHint(state)) availableActions.push('request-hint');
  const finalAttempt = state.finalAttempts.at(-1);
  const activity = state.phase === 'diagnosis'
    ? state.diagnosticAnswers.length < 10 ? `Soal ${state.diagnosticAnswers.length + 1} dari 10` : 'Pemeriksaan tambahan · Informasi Sifat Distributif belum cukup'
    : state.phase === 'final-assessment' ? `Asesmen akhir SPL · Soal ${(finalAttempt?.answers.length ?? 0) + 1} dari 5`
    : state.phase === 'final-result' ? 'Hasil asesmen akhir SPL'
    : state.phase === 'entry' ? 'Pilih topik yang tersedia' : 'Pemeriksaan dan belajar konsep';
  const activeHints = learning ? state.hints.filter(h => h.cycle === learning.cycle && h.stage === state.phase).map(h => {
    const hint = Object.values(hints).flat().find(candidate => candidate.id === h.id)!;
    return { id: hint.id, text: hint.text, source: h.source };
  }) : [];
  const learningActive = ['visual', 'worked', 'practice'].includes(state.phase);
  const validationActive = ['retry', 'transfer'].includes(state.phase);
  const stages = [
    { id: 'diagnosis', label: 'Pemeriksaan konsep', state: state.diagnosisComplete ? 'complete' : state.phase === 'entry' ? 'not-started' : 'current' },
    { id: 'learning', label: 'Belajar konsep', state: learning?.completed ? 'complete' : learningActive ? 'current' : state.diagnosisComplete ? 'optional' : 'not-started' },
    { id: 'validation', label: 'Validasi konsep', state: learning?.origin === 'optional-review' || (distribution && distribution.status !== 'supported') ? 'not-applicable' : learning?.learnerState ? learning.learnerState === 'understood' ? 'complete' : 'needs-action' : validationActive ? 'current' : 'not-started' },
    { id: 'final-assessment', label: 'Asesmen akhir SPL', state: state.phase === 'final-assessment' ? 'current' : finalAttempt?.result === 'passed' ? 'complete' : finalAttempt?.result === 'not-passed' ? 'needs-action' : state.diagnosisComplete ? 'optional' : 'not-started' },
  ];
  const practiceIndex = learning?.answers.findLastIndex(a => a.questionId === learningItems.practice.id && a.observation === 'correct') ?? -1;
  const cycleAnswers = practiceIndex >= 0 ? learning!.answers.slice(practiceIndex + 1) : [];
  const retry = cycleAnswers[0]; const transfer = cycleAnswers[1];
  const validation = learning?.origin === 'confirmed-recovery' && learning.completed && learning.learnerState && retry
    ? { retry: retry.observation === 'correct' ? 'passed' : 'not-passed', transfer: transfer ? transfer.observation === 'correct' ? 'passed' : 'not-passed' : 'not-administered' } : null;
  const achievement = learning?.origin === 'confirmed-recovery' && learning.learnerState === 'understood' && distribution?.status === 'supported' &&
    cycleAnswers.length === 2 && retry?.observation === 'correct' && transfer?.observation === 'correct'
    ? { id: `${BANK_VERSION}:${learning.cycle}:${transfer.at}`, concept: 'distribution', earnedAt: transfer.at } : null;
  return {
    version: 3, contentVersion: BANK_VERSION, concept: 'distribution', selectedTopic: state.selectedTopic, phase: state.phase,
    origin: learning?.origin ?? null, currentQuestion: current ? visibleItem(current) : null,
    learningContent: state.phase === 'visual' ? learningAssets.visual : state.phase === 'worked' ? learningAssets.worked : null,
    diagnosticOutcome: distribution ? distribution.status === 'supported' ? 'confirmed' : distribution.status === 'not-supported' ? 'rejected' : 'uncertain' : null,
    diagnosticResults, learningCompleted: learning?.completed ?? false, learnerState: state.conceptLearnerState,
    resultExplanation: state.phase === 'final-result' ? 'Hasil ini berlaku untuk lima soal SPL yang diperiksa. Hasilnya tidak menetapkan pemahaman setiap konsep prasyarat.'
      : state.diagnosisComplete ? 'Hasil setiap konsep dibatasi oleh bukti yang diperiksa. Kamu bisa memilih materi yang tersedia atau langsung mengikuti asesmen akhir SPL.' : null,
    availableActions, attempts: state.diagnosticAnswers.map(({ questionId, answer, at }) => ({ questionId, role: 'primary', answer, at })),
    map: { explore: state.selectedTopic, focus: distribution?.status === 'supported' ? 'distribution' : null, progress: state.conceptLearnerState },
    operationalStatus: 'implementation-approved-expert-review-pending',
    presentation: { stages, activity, context: learningActive || validationActive || state.phase === 'validation-result' || state.phase === 'review-complete' ? learning?.origin ?? null : null, validation, achievement },
    hints: activeHints,
    finalAssessment: { canStart: availableActions.includes('start-final-assessment'), attempts: state.finalAttempts.map(a => ({ id: a.id, startedAt: a.startedAt, completedAt: a.completedAt, answered: a.answers.length, score: a.score, result: a.result })) },
  };
}

import type { PublicQuestion } from '../content/distribution.ts';
import type { LearnerState, Observation } from '../domain/model.ts';

export type ConceptId = 'distribution' | 'like-terms' | 'inverse-equality' | 'signed-numbers' | 'representation';
export type EvidenceStatus = 'supported' | 'not-supported' | 'uncertain' | 'insufficiently-assessed';
export type Phase = 'entry' | 'diagnosis' | 'diagnostic-result' | 'visual' | 'worked' | 'practice' | 'review-complete' | 'retry' | 'transfer' | 'validation-result' | 'final-assessment' | 'final-result';
export type Item = Omit<PublicQuestion, 'role'> & {
  version: string; rubric: 'choice-key' | 'exact-rational' | 'bounded-explanation';
  role: string; tags: ConceptId[]; attribution: ConceptId | null;
  expected?: string; knownErrors?: string[]; evidenceRole: 'context' | 'application' | 'explanation' | 'representation';
};
export type Answer = { questionId: string; answer: string; at: string; observation: Observation; source: 'curated' | 'gateway' };
export type Learning = {
  origin: 'confirmed-recovery' | 'optional-review'; stage: 'visual' | 'worked' | 'practice' | 'retry' | 'transfer' | 'complete';
  completed: boolean; learnerState: LearnerState | null; cycle: number; answers: Answer[];
};
export type FinalAttempt = { id: number; answers: Answer[]; startedAt: string; completedAt: string | null; score: number | null; result: 'passed' | 'not-passed' | null };
export type State = {
  phase: Phase; selectedTopic: 'spl' | null; diagnosticAnswers: Answer[]; diagnosisComplete: boolean;
  conceptLearnerState: LearnerState | null;
  learning: Learning | null; finalAttempts: FinalAttempt[]; hints: { stage: string; cycle: number; id: string; source: 'curated' | 'gateway' }[];
};
export type Command = { action: 'select-topic' | 'submit' | 'start-learning' | 'advance' | 'show-results' | 'start-final-assessment' | 'request-hint' | 'restart-diagnosis'; expectedRevision: number; topicId?: 'spl'; conceptId?: 'distribution'; questionId?: string; answer?: string; message?: string };
export type Event = Omit<Command, 'expectedRevision' | 'message'> & { at: string; adviceQuote?: string; hintId?: string; hintSource?: 'curated' | 'gateway' };
export type Session = { version: 1; bankVersion: string; events: Event[] };

import type { CONTENT_VERSION } from '../content/version.ts';
import type { learningAssets, PublicQuestion, QuestionRole } from '../content/distribution.ts';
import type { JourneyPresentation } from './presentation.ts';

export type Phase = 'entry' | 'diagnosis' | 'diagnostic-result' | 'diagnostic-decision-pending' | 'visual' | 'worked' | 'practice' | 'review-complete' | 'retry' | 'transfer' | 'validation-result';
export type DiagnosticOutcome = 'confirmed' | 'rejected' | 'uncertain';
export type LearnerState = 'understood' | 'procedural-only' | 'needs-reinforcement';
export type Observation = 'correct' | 'known-error' | 'incorrect' | 'insufficient';
export type EvidenceCategory = 'outcome' | 'transformation' | 'explanation' | 'procedural-trace';
export type EvidenceDirection = 'supporting' | 'contradictory' | 'insufficient' | 'neutral';
export type AttemptEvidence = { category: EvidenceCategory; direction: EvidenceDirection };
export type Attempt = { questionId: string; role: QuestionRole; answer: string; observation: Observation; evidence: AttemptEvidence; at: string; interpretationSource?: 'curated' | 'gateway' };
export type SubmissionIssue = 'stale_question' | 'expanded_form_required' | 'invalid_answer' | 'attempt_limit';

export type Journey = { version: 2; contentVersion: typeof CONTENT_VERSION; concept: 'distribution'; selectedTopic: 'spl' | null; phase: Phase; origin: 'confirmed-recovery' | 'optional-review' | null; diagnosticOutcome: DiagnosticOutcome | null; learningCompleted: boolean; learnerState: LearnerState | null; attempts: Attempt[]; prdV2?: unknown };
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
  operationalStatus: 'implementation-approved-expert-review-pending';
  presentation: JourneyPresentation;
};

export type Action = 'select-topic' | 'advance' | 'start-recovery' | 'start-review' | 'start-validation' | 'reinforce' | 'reset';

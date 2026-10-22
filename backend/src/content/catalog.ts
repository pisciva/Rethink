import { CONTENT_VERSION } from './version.ts';

const supported = { diagnosis: 'active', guidedLearning: 'active', validation: 'confirmed-recovery-only' } as const;
const unavailable = { diagnosis: 'unavailable', guidedLearning: 'unavailable', validation: 'unavailable' } as const;

/** C1: subject/topic discovery. A represented topic never grants assessment access. */
export const catalog = {
  version: 2, contentVersion: CONTENT_VERSION, contentStatus: 'implementation-approved-expert-review-pending',
  subjects: [{ id: 'algebra', title: 'Aljabar', topics: [
    { id: 'spl', title: 'Sistem Persamaan Linear', availability: 'active', capabilities: supported,
      concepts: [{ id: 'distribution', title: 'Sifat Distributif', availability: 'active-recovery', capabilities: supported }] },
    { id: 'quadratic', title: 'Persamaan Kuadrat', availability: 'unavailable', capabilities: unavailable, concepts: [] },
  ] }],
  relationships: [{ from: 'distribution', to: 'spl', kind: 'prerequisite' }],
  coverage: { represented: ['spl', 'quadratic', 'distribution'], activelySupported: ['spl', 'distribution'] },
  policy: { topicId: 'spl', concept: 'distribution', maxDiagnosticQuestions: 4,
    optionalReviewValidation: false, checkpointEstablishesMastery: false, foundationAssessmentRequired: false },
};

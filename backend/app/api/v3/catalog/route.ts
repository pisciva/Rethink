import { cors, preflight } from '../../../../src/http/cors.ts';
import { BANK_APPROVED, BANK_VERSION, concepts } from '../../../../src/prdv2/content.ts';

export const dynamic = 'force-dynamic';
export function GET(request: Request) {
  const unavailable = { diagnosis: 'unavailable', guidedLearning: 'unavailable', validation: 'unavailable' };
  const available = { diagnosis: BANK_APPROVED ? 'active' : 'unavailable', guidedLearning: BANK_APPROVED ? 'active' : 'unavailable', validation: BANK_APPROVED ? 'confirmed-recovery-only' : 'unavailable' };
  return cors(request, () => Response.json({
    version: 3, contentVersion: BANK_VERSION, contentStatus: BANK_APPROVED ? 'implementation-approved-expert-review-pending' : 'implementation-review-pending',
    subjects: [{ id: 'algebra', title: 'Aljabar', topics: [
      { id: 'spl', title: 'Sistem Persamaan Linear', availability: BANK_APPROVED ? 'active' : 'unavailable', capabilities: available,
        concepts: concepts.map(c => ({ id: c.id, title: c.title, availability: BANK_APPROVED && c.learningAvailable ? 'active-recovery' : 'represented',
          capabilities: { diagnosis: BANK_APPROVED && c.id !== 'representation' ? 'active' : 'unavailable', guidedLearning: BANK_APPROVED && c.learningAvailable ? 'active' : 'unavailable', validation: BANK_APPROVED && c.learningAvailable ? 'confirmed-recovery-only' : 'unavailable' } })) },
      { id: 'quadratic', title: 'Persamaan Kuadrat', availability: 'unavailable', capabilities: unavailable, concepts: [] },
    ] }],
    relationships: concepts.map(c => ({ from: c.id, to: 'spl', kind: 'prerequisite' })),
    coverage: { represented: ['spl', 'quadratic', ...concepts.map(c => c.id)], activelySupported: BANK_APPROVED ? ['spl', 'distribution', 'like-terms', 'inverse-equality', 'signed-numbers'] : [] },
    policy: { primaryQuestions: 10, maxFollowUps: 1, finalAssessmentQuestions: 5, passingScore: 3, optionalReviewValidation: false, topicResultAssignsConceptStates: false },
  }));
}
export function OPTIONS(request: Request) { return preflight(request, 'GET'); }

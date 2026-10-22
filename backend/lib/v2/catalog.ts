import { curriculumVersion, materials } from '../curriculum.ts';

const unavailable = { diagnosis: 'unavailable', guidedLearning: 'unavailable', validation: 'unavailable' } as const;
const supported = { diagnosis: 'active', guidedLearning: 'active', validation: 'confirmed-recovery-only' } as const;

/** Catalog presence never grants learning access. Only SPL can start a journey. */
export const gradeTenModules = materials.filter(m => m.grade === 10 && m.track === 'general').map(m => {
  const active = m.id === 'x-linear';
  return {
    id: m.id, topicId: active ? 'spl' : m.id, grade: m.grade, title: m.title,
    summary: m.summary, duration: m.duration, track: m.track, gradePlacement: m.gradePlacement,
    availability: active ? 'active' : 'unavailable', locked: !active,
    lockReason: active ? null : 'Belum tersedia dalam MVP.',
    capabilities: active ? supported : unavailable,
    entry: active ? { endpoint: '/api/v2/progress', action: 'select-topic', topicId: 'spl', concept: 'distribution' } : null,
    concepts: active ? [{ id: 'distribution', title: 'Sifat Distributif', availability: 'active-recovery', capabilities: supported }] : [],
  };
});
export const mvpCatalog = {
  version: 2, contentVersion: 'spl-distribution-draft-3', contentStatus: 'draft-ops-04', curriculumVersion,
  grades: [{ id: 10, title: 'Kelas 10', modules: gradeTenModules }],
  // Compatibility projection for existing Swift catalog decoding; new UI uses grades.
  subjects: [{ id: 'algebra', title: 'Aljabar', topics: gradeTenModules.map(m => ({ ...m, id: m.topicId })) }],
  relationships: [{ from: 'distribution', to: 'spl', kind: 'prerequisite' }],
  coverage: { represented: gradeTenModules.map(m => m.topicId), activelySupported: ['spl', 'distribution'] },
  policy: { grade: 10, moduleId: 'x-linear', topicId: 'spl', concept: 'distribution', maxDiagnosticQuestions: 4,
    optionalReviewValidation: false, checkpointEstablishesMastery: false, foundationAssessmentRequired: false },
};

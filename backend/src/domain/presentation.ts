import type { Journey } from './model.ts';

export type StageState = 'not-started' | 'current' | 'complete' | 'optional' | 'not-applicable' | 'needs-action';
export type JourneyPresentation = {
  stages: { id: 'diagnosis' | 'learning' | 'validation'; label: string; state: StageState }[];
  activity: string;
  context: 'confirmed-recovery' | 'optional-review' | null;
  validation: { retry: 'passed' | 'not-passed'; transfer: 'passed' | 'not-passed' | 'not-administered' } | null;
  achievement: { id: string; concept: 'distribution'; earnedAt: string } | null;
};

/** Read-only GAM projection. It never evaluates an answer, changes eligibility or
 * issues a second reward record. HTTP returns it only after a successful save/read. */
export function projectPresentation(journey: Journey): JourneyPresentation {
  const learning = ['visual', 'worked', 'practice'].includes(journey.phase);
  const validation = ['retry', 'transfer', 'validation-result'].includes(journey.phase);
  const nonConfirmed = journey.diagnosticOutcome === 'rejected' || journey.diagnosticOutcome === 'uncertain';
  const diagnosisDone = journey.diagnosticOutcome !== null;
  const stages: JourneyPresentation['stages'] = [
    { id: 'diagnosis', label: 'Pemeriksaan konsep', state: diagnosisDone ? 'complete' : journey.phase === 'entry' ? 'not-started' : 'current' },
    { id: 'learning', label: 'Belajar terarah', state: journey.learningCompleted ? 'complete' : learning ? 'current' : nonConfirmed ? 'optional' : 'not-started' },
    { id: 'validation', label: 'Uji pemahaman', state: journey.origin === 'optional-review' || nonConfirmed ? 'not-applicable'
      : journey.phase === 'validation-result' ? journey.learnerState === 'understood' ? 'complete' : 'needs-action'
      : validation ? 'current' : 'not-started' },
  ];
  const coreDone = new Set(journey.attempts.filter(a => ['q1-target', 'q2-application', 'q3-reasoning'].includes(a.role)).map(a => a.role)).size;
  let activity = 'Pilih topik yang didukung';
  if (journey.phase === 'diagnosis') activity = coreDone < 3 ? `Soal inti ${coreDone + 1} dari 3` : 'Soal inti 3 dari 3 selesai · Pemeriksaan tambahan 1 dari 1';
  else if (journey.phase === 'diagnostic-result') activity = 'Pemeriksaan selesai';
  else if (journey.phase === 'diagnostic-decision-pending') activity = 'Hasil belum tersedia';
  else if (journey.phase === 'visual') activity = 'Memahami konsep · Tahap 1 dari 3';
  else if (journey.phase === 'worked') activity = 'Melihat penerapan · Tahap 2 dari 3';
  else if (journey.phase === 'practice') activity = 'Latihan terbimbing · Tahap 3 dari 3';
  else if (journey.phase === 'review-complete') activity = 'Ulasan opsional selesai · Tanpa validasi';
  else if (journey.phase === 'retry') activity = 'Penerapan mandiri · Tanpa panduan';
  else if (journey.phase === 'transfer') activity = 'Penerapan pada konteks berbeda · Tanpa panduan';
  else if (journey.phase === 'validation-result') activity = 'Hasil validasi Sifat Distributif';

  // Use this validation cycle, never a transfer from an earlier reinforcement cycle.
  const practiceIndex = journey.attempts.findLastIndex(a => a.role === 'practice' && a.observation === 'correct');
  const cycle = practiceIndex < 0 ? [] : journey.attempts.slice(practiceIndex + 1);
  const retry = cycle[0]?.role === 'retry' ? cycle[0] : null;
  const transfer = cycle[1]?.role === 'transfer' ? cycle[1] : null;
  let result: JourneyPresentation['validation'] = null;
  let achievement: JourneyPresentation['achievement'] = null;
  if (journey.phase === 'validation-result' && journey.origin === 'confirmed-recovery' && journey.learningCompleted && retry) {
    if (retry.observation === 'incorrect' && !transfer && journey.learnerState === 'needs-reinforcement') {
      result = { retry: 'not-passed', transfer: 'not-administered' };
    } else if (retry.observation === 'correct' && transfer &&
      ((transfer.observation === 'correct' && journey.learnerState === 'understood') ||
       (transfer.observation === 'incorrect' && journey.learnerState === 'procedural-only'))) {
      result = { retry: 'passed', transfer: transfer.observation === 'correct' ? 'passed' : 'not-passed' };
      if (journey.diagnosticOutcome === 'confirmed' && journey.learnerState === 'understood' && cycle.length === 2) {
        achievement = { id: `${journey.contentVersion}:${practiceIndex}:${transfer.at}`, concept: 'distribution', earnedAt: transfer.at };
      }
    }
  }
  return { stages, activity, context: journey.origin, validation: result, achievement };
}

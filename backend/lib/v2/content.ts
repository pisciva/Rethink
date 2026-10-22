/** Draft assessment assets. OPS-04 mathematics and rubric review is still pending. */
export type QuestionRole = 'q1-target' | 'q2-application' | 'q3-reasoning' | 'q4-trace' | 'practice' | 'retry' | 'transfer';
export type PublicQuestion = { id: string; role: QuestionRole; prompt: string; math?: string; options?: { id: string; text: string }[]; format: 'choice' | 'expression' | 'number' | 'explanation' };
export type Question = PublicQuestion & { expected?: string; knownError?: string };

export const CONTENT_VERSION = 'spl-distribution-draft-3';
export const questions: Record<'q1' | 'q2' | 'q3' | 'q4' | 'practice' | 'retry' | 'transfer', Question> = {
  q1: { id: 'spl-q1', role: 'q1-target', prompt: 'Dalam SPL berikut, bentuk mana yang setara dengan persamaan pertama setelah tanda kurung dihilangkan?', math: '3(x + 2) + y = 15; x + y = 5', format: 'choice', options: [{ id: 'A', text: '3x + 6 + y = 15' }, { id: 'B', text: '3x + 2 + y = 15' }, { id: 'C', text: '3x + 5 + y = 15' }], expected: 'A', knownError: 'B' },
  q2: { id: 'distribution-q2', role: 'q2-application', prompt: 'Hilangkan tanda kurung dan tuliskan bentuk aljabar yang setara.', math: '4(x + 3)', format: 'expression', expected: '4x+12', knownError: '4x+3' },
  q3: { id: 'distribution-q3', role: 'q3-reasoning', prompt: 'Pada bentuk 5(x + 2), jelaskan bagaimana angka 5 digunakan pada suku-suku di dalam kurung dan mengapa.', format: 'explanation' },
  q4: { id: 'distribution-q4', role: 'q4-trace', prompt: 'Lengkapi langkah transformasi ini dengan satu bilangan.', math: '2(x + 4) = 2x + …', format: 'number', expected: '8', knownError: '4' },
  practice: { id: 'distribution-practice', role: 'practice', prompt: 'Bagian pertama sudah diberikan. Lengkapi bilangan yang kosong.', math: '5(x + 2) = 5x + …', format: 'number', expected: '10' },
  retry: { id: 'distribution-retry', role: 'retry', prompt: 'Kerjakan secara mandiri. Hilangkan tanda kurung.', math: '4(x + 5)', format: 'expression', expected: '4x+20' },
  transfer: { id: 'distribution-transfer', role: 'transfer', prompt: 'Tiga kotak masing-masing berisi x pensil biru dan 4 pensil merah. Tuliskan ekspresi total pensil tanpa kurung.', format: 'expression', expected: '3x+12' },
};

export { mvpCatalog as catalog } from './catalog.ts';

export const learningAssets = {
  visual: {
    kind: 'visual', title: 'Satu pengali untuk setiap suku',
    explanation: 'Tiga kelompok yang masing-masing berisi x dan 2 berarti x + x + x = 3x dan 2 + 2 + 2 = 6. Pengali berlaku untuk setiap suku di dalam kurung.',
    groups: 3, termsPerGroup: ['x', '2'], resultTerms: ['3x', '6'],
  },
  worked: {
    kind: 'worked', title: 'Contoh langkah demi langkah', problem: '2(x + 4)',
    steps: [
      { expression: '2 × x = 2x', reason: 'Kalikan pengali dengan suku x.' },
      { expression: '2 × 4 = 8', reason: 'Kalikan pengali yang sama dengan suku 4.' },
      { expression: '2x + 8', reason: 'Gabungkan kedua hasil; nilainya setara dengan bentuk semula.' },
    ],
  },
} as const;

export function publicQuestion(question: Question): PublicQuestion {
  const { expected: _expected, knownError: _knownError, ...visible } = question;
  return visible;
}

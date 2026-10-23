import { questions } from '../content/distribution.ts';
import type { Item, ConceptId } from './types.ts';

export const BANK_VERSION = 'spl-prdv2-proposed-1';
// User approved this exact bank and policy for implementation on 23 October 2026.
// Expert pedagogical/diagnostic acceptance remains separate from this gate.
export const BANK_APPROVED = true;
export const concepts: { id: ConceptId; title: string; learningAvailable: boolean }[] = [
  { id: 'distribution', title: 'Sifat Distributif', learningAvailable: true },
  { id: 'like-terms', title: 'Suku sejenis', learningAvailable: false },
  { id: 'inverse-equality', title: 'Operasi invers dan kesetaraan', learningAvailable: false },
  { id: 'signed-numbers', title: 'Bilangan bertanda', learningAvailable: false },
  { id: 'representation', title: 'Representasi SPL', learningAvailable: false },
];
function retained(key: keyof typeof questions, attribution: ConceptId | null, evidenceRole: Item['evidenceRole']): Item {
  const { knownError, ...question } = questions[key];
  return { ...question, version: BANK_VERSION, rubric: question.format === 'choice' ? 'choice-key' : question.format === 'explanation' ? 'bounded-explanation' : 'exact-rational', tags: ['distribution'], attribution, evidenceRole, knownErrors: knownError ? [knownError] : [] };
}
function choice(id: string, prompt: string, math: string, texts: string[], attribution: ConceptId, error: string | null, evidenceRole: Item['evidenceRole'] = 'application'): Item {
  return { id, version: BANK_VERSION, rubric: 'choice-key', role: 'primary', prompt, math, format: 'choice', options: texts.map((text, index) => ({ id: String.fromCharCode(65 + index), text })),
    expected: 'A', knownErrors: error ? [error] : [], attribution, tags: [attribution], evidenceRole };
}
export const primaryItems: Item[] = [
  retained('q1', null, 'context'), retained('q2', 'distribution', 'application'), retained('q3', 'distribution', 'explanation'),
  choice('spl-primary-q4', 'Bentuk mana yang setara?', '2x + 3x', ['5x', '5x²', '6x'], 'like-terms', 'B'),
  choice('spl-primary-q5', 'Gabungkan suku sejenis. Pilih bentuk yang setara.', '4x + 2 + 3x', ['7x + 2', '9x', '7x² + 2'], 'like-terms', 'B'),
  { id: 'spl-primary-q6', version: BANK_VERSION, rubric: 'exact-rational', role: 'primary', prompt: 'Tentukan nilai x.', math: 'x + 4 = 9', format: 'number', expected: '5', knownErrors: ['13'], tags: ['inverse-equality'], attribution: 'inverse-equality', evidenceRole: 'application' },
  choice('spl-primary-q7', 'Langkah mana yang mempertahankan kesetaraan?', 'x − 3 = 8', ['Tambahkan 3 pada kedua ruas.', 'Tambahkan 3 hanya pada ruas kiri.', 'Tambahkan 3 hanya pada ruas kanan.'], 'inverse-equality', 'B'),
  { id: 'spl-primary-q8', version: BANK_VERSION, rubric: 'exact-rational', role: 'primary', prompt: 'Hitung hasilnya.', math: '−3 + 5', format: 'number', expected: '2', knownErrors: ['-8'], tags: ['signed-numbers'], attribution: 'signed-numbers', evidenceRole: 'application' },
  { id: 'spl-primary-q9', version: BANK_VERSION, rubric: 'exact-rational', role: 'primary', prompt: 'Hitung hasilnya.', math: '2 − (−4)', format: 'number', expected: '6', knownErrors: ['-2'], tags: ['signed-numbers'], attribution: 'signed-numbers', evidenceRole: 'application' },
  choice('spl-primary-q10', 'Dua bilangan berjumlah 10. Bilangan pertama lebih besar 2 dari bilangan kedua. Jika x adalah bilangan pertama dan y bilangan kedua, pilih SPL yang sesuai.', '', ['x + y = 10; x − y = 2', 'x − y = 10; x + y = 2', 'x + y = 10; y − x = 2'], 'representation', null, 'representation'),
];
export const distributionProbe: Item = { ...retained('q4', 'distribution', 'application'), id: 'probe-distribution-trace-1', role: 'follow-up' };
export const learningItems = { practice: retained('practice', null, 'application'), retry: retained('retry', null, 'application'), transfer: retained('transfer', null, 'application') };
export const finalItems: Item[] = [
  choice('spl-final-1', 'Pilih pasangan (x, y) yang memenuhi kedua persamaan.', 'x + y = 7; x − y = 1', ['(3, 4)', '(4, 3)', '(4, 4)'], 'representation', null),
  choice('spl-final-2', 'Pilih pasangan (x, y) yang memenuhi kedua persamaan.', '2x + y = 11; x − y = 1', ['(4, 3)', '(3, 4)', '(5, 1)'], 'representation', null),
  choice('spl-final-3', 'Pilih pasangan (x, y) yang memenuhi kedua persamaan.', '3(x + 1) + y = 14; x + y = 7', ['(3, 4)', '(4, 3)', '(2, 5)'], 'representation', null),
  choice('spl-final-4', 'Pilih pasangan (x, y) yang memenuhi kedua persamaan.', 'x + y = 2; x − y = −6', ['(4, −2)', '(−2, 4)', '(−4, 2)'], 'representation', null),
  choice('spl-final-5', 'Dua buku dan satu pena berharga 11 satuan. Satu buku dan satu pena berharga 7 satuan. Berapa harga buku dan pena?', '', ['Buku 3, pena 4', 'Buku 5, pena 2', 'Buku 4, pena 3'], 'representation', null),
].map((item, i) => ({ ...item, role: 'final-assessment', expected: ['B', 'A', 'C', 'B', 'C'][i], attribution: null, tags: [], knownErrors: [] }));

export function visibleItem(item: Item) {
  return { id: item.id, version: item.version, role: item.role, prompt: item.prompt, ...(item.math ? { math: item.math } : {}), ...(item.options ? { options: item.options } : {}), format: item.format };
}

// Hints contain no solved expression, response evaluation or independent item.
export const hints = {
  visual: [
    { id: 'visual-1', text: 'Apa yang sama pada setiap kelompok dalam gambar?' },
    { id: 'visual-2', text: 'Kalau semua kelompok digabung, bagian mana yang perlu kamu hitung berulang?' },
    { id: 'visual-3', text: 'Bagaimana tiap jenis suku dalam kelompok ikut dihitung saat kelompoknya berulang?' },
  ],
  worked: [
    { id: 'worked-1', text: 'Operasi apa yang dilakukan pada langkah pertama contoh?' },
    { id: 'worked-2', text: 'Apakah pengali pada contoh sudah diterapkan pada setiap suku?' },
    { id: 'worked-3', text: 'Mengapa bentuk sebelum dan sesudah langkah itu tetap setara?' },
  ],
  practice: [
    { id: 'practice-1', text: 'Suku mana yang belum ikut dihitung pada langkah yang kosong?' },
    { id: 'practice-2', text: 'Pengali di luar kurung berlaku pada berapa suku di dalam kurung?' },
    { id: 'practice-3', text: 'Tuliskan dulu operasi untuk bagian yang kosong, lalu hitung sendiri hasilnya.' },
  ],
} as const;

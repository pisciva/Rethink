import type { Journey } from '../domain/model.ts';

export function resultExplanationFor(journey: Journey): string | null {
  if (journey.phase === 'diagnostic-decision-pending') {
    return 'Aturan sesi ini telah diperbarui. Mulai ulang pemeriksaan untuk melanjutkan.';
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


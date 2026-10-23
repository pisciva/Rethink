import { loadJourney, saveJourney } from '../infrastructure/journeys.ts';
import { authenticated, ApiError, jsonBody } from '../infrastructure/supabase.ts';
import { cors, preflight } from './cors.ts';
import { newJourney, publicJourney, submissionIssue, type Journey } from '../domain/journey.ts';
import { applyCommand, parseCommand } from '../application/commands.ts';
import { readJourney } from '../domain/snapshot.ts';
import { interpretReasoning } from '../infrastructure/reasoning.ts';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

function conflict() {
  return Response.json({ error: 'Kemajuan berubah di perangkat lain. Muat ulang sebelum melanjutkan.', code: 'revision_conflict' }, { status: 409 });
}

function resetRequired(revision: number) {
  return Response.json({ error: 'Sesi lama perlu dimulai ulang sebelum melanjutkan.', code: 'reset_required', revision }, { status: 409 });
}

function feedbackFor(previous: Journey, next: Journey, action: string): string | null {
  if (action !== 'submit') return null;
  if (previous.phase === 'diagnosis') return 'Jawaban tersimpan. Lanjutkan pemeriksaan konsep.';
  if (previous.phase === 'practice') {
    if (next.phase === 'practice') return 'Langkah ini belum setara. Periksa apakah pengali diterapkan pada setiap suku, lalu coba lagi.';
    if (next.origin === 'optional-review') return 'Ulasan konsep selesai. Ulasan ini bukan diagnosis terkonfirmasi dan tidak membuka validasi pada versi ini.';
    return 'Latihan terpandu selesai. Hasil pemahaman akan ditentukan oleh penerapan mandiri yang memenuhi syarat.';
  }
  return null; // Validation has no live hints; the final scoped result is in resultExplanation.
}

function submissionFailure(code: string) {
  const messages: Record<string, string> = {
    stale_question: 'Soal ini bukan soal yang sedang aktif.',
    expanded_form_required: 'Tuliskan bentuk tanpa tanda kurung, lalu kirim lagi.',
    invalid_answer: 'Jawaban belum dapat dibaca. Periksa penulisan matematikanya.',
    invalid_transition: 'Tindakan ini tidak sesuai dengan tahap belajar saat ini.',
    attempt_limit: 'Batas teknis jawaban sesi ini tercapai. Mulai ulang sesi jika ingin melanjutkan. Ini bukan hasil penilaian matematika.',
  };
  return Response.json({ error: messages[code] ?? messages.invalid_answer, code }, { status: 400 });
}

export function GET(request: Request) {
  return cors(request, () => authenticated(request, async ({ user }) => {
    const data = await loadJourney(user.id);
    if (!data) {
      return Response.json({ version: 2, revision: 0, journey: publicJourney(newJourney()), updatedAt: null, resetRequired: false });
    }
    const journey = readJourney(data.session);
    if (!journey) {
      return Response.json({ version: 2, revision: data.revision, journey: null, updatedAt: data.updated_at ?? null, resetRequired: true });
    }
    return Response.json({ version: 2, revision: data.revision, journey: publicJourney(journey), updatedAt: data.updated_at ?? null, resetRequired: false });
  }));
}

export function POST(request: Request) {
  return cors(request, () => authenticated(request, async ({ user }) => {
    const command = parseCommand(await jsonBody(request));
    if (!command) throw new ApiError(400, 'Tindakan belajar tidak valid.');
    const currentRow = await loadJourney(user.id);
    if ((currentRow?.revision ?? 0) !== command.expectedRevision) return conflict();

    let current: Journey;
    if (currentRow) {
      const parsed = readJourney(currentRow.session);
      if (!parsed) {
        if (command.action !== 'reset') return resetRequired(currentRow.revision);
        current = newJourney();
      } else {
        current = parsed;
      }
    } else {
      current = newJourney();
    }

    const reasoningAdvice = command.action === 'submit' && current.phase === 'diagnosis' &&
      command.questionId === 'distribution-q3' && publicJourney(current).currentQuestion?.id === command.questionId
      ? await interpretReasoning(command.answer!) : undefined;
    const next = applyCommand(current, command, reasoningAdvice);
    if (!next) {
      return submissionFailure(command.action === 'submit'
        ? submissionIssue(current, command.questionId!, command.answer!)
        : 'invalid_transition');
    }

    // A legacy recovery restart cannot erase the separate PRD v2 topic history.
    const topicHistory = currentRow?.session && typeof currentRow.session === 'object'
      ? (currentRow.session as Record<string, unknown>).prdV2 : undefined;
    if (topicHistory !== undefined) next.prdV2 = topicHistory;
    const saved = await saveJourney(user.id, command.expectedRevision, next);
    if (saved.kind === 'conflict') return conflict();
    return Response.json({ version: 2, revision: saved.revision, journey: publicJourney(next), feedback: feedbackFor(current, next, command.action), updatedAt: saved.updatedAt, resetRequired: false });
  }));
}

export function OPTIONS(request: Request) { return preflight(request, ['GET', 'POST']); }

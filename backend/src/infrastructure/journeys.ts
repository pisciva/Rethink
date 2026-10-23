import { adminDatabase, ApiError } from './supabase.ts';
import type { Journey } from '../domain/model.ts';

type StoredJourney = { session: unknown; revision: number; updated_at?: string };
type SavedJourney = { kind: 'saved'; revision: number; updatedAt: string | null } | { kind: 'conflict' };

/** LC-07 storage adapter. Supabase persists domain outputs; it never determines them. */
export async function loadJourney(userId: string): Promise<StoredJourney | null> {
  const { data, error } = await adminDatabase().from('learning_journeys')
    .select('session,revision,updated_at').eq('user_id', userId).eq('concept', 'distribution').maybeSingle();
  if (error) throw new ApiError(503, 'Kemajuan belum dapat dimuat.');
  return data as StoredJourney | null;
}

export async function saveJourney(userId: string, expectedRevision: number, journey: Journey): Promise<SavedJourney> {
  const { data, error } = await adminDatabase().rpc('save_learning_journey', {
    p_user_id: userId, p_concept: journey.concept, p_expected_revision: expectedRevision, p_session: journey,
  }).single();
  if (error?.message.includes('revision_conflict')) return { kind: 'conflict' };
  if (error || !data) throw new ApiError(503, 'Kemajuan gagal disimpan. Coba lagi.');
  const row = data as { revision: number; updated_at?: string };
  return { kind: 'saved', revision: row.revision, updatedAt: row.updated_at ?? null };
}

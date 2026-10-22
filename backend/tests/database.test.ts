import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { PGlite } from '@electric-sql/pglite';
import { newJourney, submitAnswer, transition } from '../src/domain/journey.ts';
import { readJourney } from '../src/domain/snapshot.ts';
import { userA, userB } from './helpers.ts';

test('FR-X-01/02/03: actual v2 migration protects evidence and enforces revision-safe saves', async t => {
  const db = new PGlite();
  const save = 'select * from public.save_learning_journey($1,$2,$3,$4)';
  try {
    await db.exec(`create role anon; create role authenticated; create role service_role bypassrls;
      create schema auth;
      create table auth.users(id uuid primary key, raw_user_meta_data jsonb default '{}');
      create function auth.uid() returns uuid language sql stable as $$
        select nullif(current_setting('request.jwt.claim.sub', true), '')::uuid $$;
      grant usage on schema auth to authenticated;
      grant execute on function auth.uid() to authenticated;`);
    // A pre-existing table is a test fixture, not a dependency of the new backend.
    await db.exec('create table public.learning_progress(user_id uuid references auth.users(id) on delete cascade, session jsonb, revision integer)');
    await db.exec(await readFile(new URL('../supabase/migrations/202610220001_spl_recovery_journeys.sql', import.meta.url), 'utf8'));
    await db.query('insert into auth.users(id) values ($1),($2)', [userA, userB]);
    const legacy = { concept: 'distribution', stage: 'complete' };
    await db.query('insert into public.learning_progress values($1,$2,1)', [userA, legacy]);
    await db.exec('set role service_role');

    await t.test('legacy website data does not become v2 evidence; v2 saves resume by owner', async () => {
      assert.equal((await db.query('select * from public.learning_journeys')).rows.length, 0);
      const selected = transition(newJourney(), 'select-topic')!;
      const rows = await db.query<{ user_id: string; revision: number; session: unknown }>(save, [userA, 'distribution', 0, selected]);
      assert.equal(rows.rows[0].user_id, userA);
      assert.equal(rows.rows[0].revision, 1);
      assert.deepEqual(readJourney(rows.rows[0].session), selected);
      await db.query(save, [userB, 'distribution', 0, newJourney()]);
      const other = await db.query<{ revision: number; session: unknown }>(
        'select revision,session from public.learning_journeys where user_id=$1 and concept=$2', [userB, 'distribution']);
      assert.equal(other.rows[0].revision, 1);
      assert.deepEqual(other.rows[0].session, newJourney());
      await db.exec('reset role');
      const old = await db.query<{ revision: number; session: unknown }>('select revision,session from public.learning_progress where user_id=$1', [userA]);
      assert.equal(old.rows[0].revision, 1);
      assert.deepEqual(old.rows[0].session, legacy);
      await db.exec('set role service_role');
    });

    await t.test('duplicate creates and competing expected revisions cannot overwrite evidence', async () => {
      await assert.rejects(db.query(save, [userA, 'distribution', 0, newJourney()]), /revision_conflict/);
      const selected = transition(newJourney(), 'select-topic')!;
      const q1 = submitAnswer(selected, 'spl-q1', 'B', '2026-10-22T00:00:00Z')!;
      const results = await Promise.allSettled([
        db.query<{ revision: number; session: unknown }>(save, [userA, 'distribution', 1, q1]),
        db.query<{ revision: number; session: unknown }>(save, [userA, 'distribution', 1, selected]),
      ]);
      const winners = results.filter(r => r.status === 'fulfilled');
      const losers = results.filter(r => r.status === 'rejected');
      assert.equal(winners.length, 1);
      assert.equal(losers.length, 1);
      assert.match(String(losers[0].reason), /revision_conflict/);
      const current = await db.query<{ revision: number; session: unknown }>('select revision,session from public.learning_journeys where user_id=$1', [userA]);
      assert.equal(current.rows[0].revision, 2);
      assert.deepEqual(current.rows[0].session, winners[0].value.rows[0].session);
      assert.ok(readJourney(current.rows[0].session));
      await assert.rejects(db.query(save, [userA, 'distribution', 1, selected]), /revision_conflict/);
    });

    await t.test('invalid save arguments never advance the revision', async () => {
      for (const args of [
        [null, 'distribution', 2, newJourney()], [userA, 'inverse', 2, newJourney()],
        [userA, 'distribution', null, newJourney()], [userA, 'distribution', -1, newJourney()],
        [userA, 'distribution', 2147483647, newJourney()], [userA, 'distribution', 2, null],
        [userA, 'distribution', 2, []], [userA, 'distribution', 2, {}],
        [userA, 'distribution', 2, { ...newJourney(), version: 3 }],
        [userA, 'distribution', 2, { ...newJourney(), concept: 'inverse' }],
      ]) await assert.rejects(db.query(save, args), /invalid_journey/);
      const current = await db.query<{ revision: number }>('select revision from public.learning_journeys where user_id=$1', [userA]);
      assert.equal(current.rows[0].revision, 2);
    });

    await t.test('anonymous and authenticated clients cannot read, forge or delete private journey evidence', async () => {
      await db.exec('reset role');
      const config = await db.query<{ relrowsecurity: boolean }>("select relrowsecurity from pg_class where oid='public.learning_journeys'::regclass");
      assert.equal(config.rows[0].relrowsecurity, true);
      for (const role of ['anon', 'authenticated']) {
        await db.exec(`reset role; set role ${role}`);
        await db.query("select set_config('request.jwt.claim.sub',$1,false)", [userA]);
        for (const owner of [userA, userB]) {
          await assert.rejects(db.query('select * from public.learning_journeys where user_id=$1', [owner]), /permission denied/);
          await assert.rejects(db.query(save, [owner, 'distribution', 0, newJourney()]), /permission denied/);
        }
        await assert.rejects(db.query('update public.learning_journeys set revision=999'), /permission denied/);
        await assert.rejects(db.query('delete from public.learning_journeys'), /permission denied/);
        await assert.rejects(db.query('insert into public.learning_journeys(user_id,concept,session,revision) values($1,$2,$3,1)',
          [userA, 'distribution', newJourney()]), /permission denied/);
      }
      await db.exec('reset role');
      assert.equal((await db.query('select * from public.learning_journeys')).rows.length, 2);
    });

    await t.test('account deletion removes only its own v2 evidence', async () => {
      await db.query('delete from auth.users where id=$1', [userA]);
      const remaining = await db.query<{ user_id: string }>('select user_id from public.learning_journeys');
      assert.deepEqual(remaining.rows.map(row => row.user_id), [userB]);
      assert.equal((await db.query('select * from public.learning_progress where user_id=$1', [userA])).rows.length, 0);
    });
  } finally { await db.close(); }
});

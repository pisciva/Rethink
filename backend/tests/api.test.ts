import { test } from 'node:test';
import assert from 'node:assert/strict';
import { GET, POST, OPTIONS } from '../app/api/v2/progress/route.ts';
import { GET as getCatalog } from '../app/api/v2/catalog/route.ts';
import { newJourney as newJourneyForTest } from '../src/domain/journey.ts';
import { mockSupabase, userA } from './helpers.ts';

const url = 'https://backend.test/api/v2/progress';
const request = (token?: string, body?: unknown) => new Request(url, {
  method: body === undefined ? 'GET' : 'POST',
  headers: { Origin: 'https://learn.example.com', ...(token ? { Authorization: `Bearer ${token}` } : {}), 'Content-Type': 'application/json' },
  body: body === undefined ? undefined : JSON.stringify(body),
});

test('FR-C5-05 and FR-X-03: inconsistent saved results require explicit reset without exposing a learner claim', async () => {
  const mock = mockSupabase();
  try {
    const stored = {
      user_id: userA, concept: 'distribution', revision: 7,
      session: { ...newJourneyForTest(), selectedTopic: 'spl', phase: 'validation-result',
        origin: 'confirmed-recovery', diagnosticOutcome: 'confirmed', learningCompleted: true, learnerState: 'understood' },
    };
    mock.v2Rows.set(`${userA}:distribution`, structuredClone(stored));
    const response = await GET(request('user-a'));
    assert.equal(response.status, 200);
    const current = await response.json();
    assert.equal(current.resetRequired, true);
    assert.equal(current.journey, null);
    assert.equal(current.revision, 7);
    const blocked = await POST(request('user-a', { concept: 'distribution', action: 'advance', expectedRevision: 7 }));
    assert.equal(blocked.status, 409);
    assert.equal((await blocked.json()).code, 'reset_required');
    assert.deepEqual(mock.v2Rows.get(`${userA}:distribution`), stored);
    const reset = await POST(request('user-a', { concept: 'distribution', action: 'reset', expectedRevision: 7 }));
    assert.equal(reset.status, 200);
    const fresh = await reset.json();
    assert.equal(fresh.revision, 8);
    assert.equal(fresh.resetRequired, false);
    assert.equal(fresh.journey.phase, 'entry');
    assert.equal(fresh.journey.learnerState, null);
    assert.equal(fresh.journey.map.progress, null);
  } finally { mock.restore(); }
});

test('FR-X-01/02: a failed persistence write records no answer and the same command can safely be retried', async () => {
  const mock = mockSupabase();
  try {
    assert.equal((await POST(request('user-a', { concept: 'distribution', action: 'select-topic', topicId: 'spl', expectedRevision: 0 }))).status, 200);
    const before = structuredClone(mock.v2Rows.get(`${userA}:distribution`));
    const databaseFetch = globalThis.fetch;
    globalThis.fetch = async (input, init) => {
      const outgoing = new Request(input, init);
      if (new URL(outgoing.url).pathname === '/rest/v1/rpc/save_learning_journey') {
        return new Response(JSON.stringify({ message: 'storage unavailable' }), { status: 503, headers: { 'Content-Type': 'application/json' } });
      }
      return databaseFetch(input, init);
    };
    const command = { concept: 'distribution', action: 'submit', questionId: 'spl-q1', answer: 'B', expectedRevision: 1 };
    const failed = await POST(request('user-a', command));
    assert.equal(failed.status, 503);
    assert.equal('feedback' in await failed.json(), false);
    assert.deepEqual(mock.v2Rows.get(`${userA}:distribution`), before);
    globalThis.fetch = databaseFetch;
    const resumed = await (await GET(request('user-a'))).json();
    assert.equal(resumed.revision, 1);
    assert.equal(resumed.journey.currentQuestion.id, 'spl-q1');
    assert.equal(resumed.journey.attempts.length, 0);
    const retried = await POST(request('user-a', command));
    assert.equal(retried.status, 200);
    const saved = await retried.json();
    assert.equal(saved.revision, 2);
    assert.equal(saved.journey.attempts.length, 1);
    assert.equal(saved.journey.currentQuestion.id, 'distribution-q2');
    assert.match(saved.feedback, /tersimpan/i);
  } finally { mock.restore(); }
});

test('FR-C3-04/08 and FR-X-01/03: guarded Q3 evidence survives API save/resume without leaking judgments', async () => {
  for (const answer of [
    'Saya tidak tahu apakah hanya x yang dikalikan 5.',
    'Bukan hanya x yang dikalikan 5, tetapi angka 2 tetap. Hasilnya 5x+10 untuk setiap suku.',
  ]) {
    const mock = mockSupabase();
    process.env.AI_GATEWAY_API_KEY = 'test-key';
    const databaseFetch = globalThis.fetch;
    let unexpectedRequests = 0;
    globalThis.fetch = async (input, init) => {
      const outgoing = new Request(input, init);
      if (new URL(outgoing.url).hostname !== 'supabase.test') {
        unexpectedRequests++;
        throw new Error('guarded reasoning must not contact a provider');
      }
      return databaseFetch(input, init);
    };
    const post = async (body: unknown) => {
      const response = await POST(request('user-a', body));
      assert.equal(response.status, 200);
      return response.json();
    };
    try {
      await post({ concept: 'distribution', action: 'select-topic', topicId: 'spl', expectedRevision: 0 });
      await post({ concept: 'distribution', action: 'submit', questionId: 'spl-q1', answer: 'A', expectedRevision: 1 });
      await post({ concept: 'distribution', action: 'submit', questionId: 'distribution-q2', answer: '4x+12', expectedRevision: 2 });
      const saved = await post({ concept: 'distribution', action: 'submit', questionId: 'distribution-q3', answer, expectedRevision: 3 });
      assert.equal(saved.revision, 4);
      assert.equal(saved.journey.currentQuestion.id, 'distribution-q4');
      assert.equal(saved.journey.diagnosticOutcome, null);
      assert.equal(saved.journey.learnerState, null);
      assert.equal(saved.journey.map.focus, null);
      assert.equal(saved.journey.map.progress, null);
      const attempt = saved.journey.attempts[2];
      assert.equal(attempt.answer, answer);
      for (const field of ['observation', 'evidence', 'interpretationSource']) assert.equal(field in attempt, false);
      const stored = mock.v2Rows.get(`${userA}:distribution`)!.session as { attempts: { observation: string; interpretationSource: string }[] };
      assert.equal(stored.attempts[2].observation, 'insufficient');
      assert.equal(stored.attempts[2].interpretationSource, 'curated');
      const resumed = await (await GET(request('user-a'))).json();
      assert.equal(resumed.revision, saved.revision);
      assert.deepEqual(resumed.journey, saved.journey);
      assert.equal(unexpectedRequests, 0);
    } finally { mock.restore(); }
  }
});

test('v2 catalog exposes supported scope and draft labels without answer keys', async () => {
  const response = await getCatalog(new Request('https://backend.test/api/v2/catalog'));
  assert.equal(response.status, 200);
  const data = await response.json();
  assert.equal(data.contentStatus, 'implementation-approved-expert-review-pending');
  const spl = data.subjects[0].topics.find((topic: { id: string }) => topic.id === 'spl');
  assert.ok(spl, 'supported SPL entry must exist regardless of catalog ordering');
  assert.equal(spl.concepts[0].id, 'distribution');
  assert.equal(spl.capabilities.diagnosis, 'active');
  assert.equal(spl.capabilities.validation, 'confirmed-recovery-only');
  assert.ok(data.subjects[0].topics.some((topic: { availability: string }) => topic.availability === 'unavailable'));
  assert.deepEqual(data.relationships, [{ from: 'distribution', to: 'spl', kind: 'prerequisite' }]);
  assert.equal(JSON.stringify(data).includes('3x+6'), false);
});

test('v2 progress authenticates, saves with revision, and never exposes live correctness', async () => {
  const mock = mockSupabase();
  try {
    assert.equal((await GET(request())).status, 401);
    const initial = await (await GET(request('user-a'))).json();
    assert.equal(initial.revision, 0);
    assert.equal(initial.journey.phase, 'entry');
    assert.equal(initial.journey.currentQuestion, null);
    const selected = await POST(request('user-a', { concept: 'distribution', action: 'select-topic', topicId: 'spl', expectedRevision: 0 }));
    assert.equal(selected.status, 200);
    assert.equal((await selected.json()).journey.currentQuestion.id, 'spl-q1');
    const command = { concept: 'distribution', action: 'submit', expectedRevision: 1, questionId: 'spl-q1', answer: 'B' };
    const saved = await POST(request('user-a', command));
    assert.equal(saved.status, 200);
    const result = await saved.json();
    assert.equal(result.revision, 2);
    assert.equal(result.journey.currentQuestion.id, 'distribution-q2');
    assert.equal(result.journey.attempts[0].correct, undefined);
    assert.equal(result.journey.learnerState, null);
    assert.equal(result.journey.diagnosticOutcome, null);
    assert.match(result.feedback, /tersimpan/i);
    assert.equal(/benar|salah|setara|belum setara/i.test(result.feedback), false);
    assert.equal((await POST(request('user-a', command))).status, 409);
    assert.equal((await (await GET(request('user-b'))).json()).revision, 0);
    assert.equal((await POST(request('user-a', { ...command, expectedRevision: 2, questionId: 'distribution-q4' }))).status, 400);
    assert.equal((await OPTIONS(new Request(url, { method: 'OPTIONS', headers: { Origin: 'https://learn.example.com', 'Access-Control-Request-Method': 'POST' } }))).status, 204);
    assert.equal(mock.v2Rows.size, 1);
  } finally { mock.restore(); }
});

test('v2 progress asks for an explicit reset when a stored session is stale', async () => {
  const mock = mockSupabase();
  try {
    mock.v2Rows.set(`${userA}:distribution`, {
      user_id: userA, concept: 'distribution', revision: 3,
      session: { ...newJourneyForTest(), contentVersion: 'spl-distribution-draft-2' },
    });
    const current = await (await GET(request('user-a'))).json();
    assert.equal(current.resetRequired, true);
    assert.equal(current.journey, null);
    assert.equal(current.revision, 3);
    const blocked = await POST(request('user-a', { concept: 'distribution', action: 'advance', expectedRevision: 3 }));
    assert.equal(blocked.status, 409);
    assert.equal((await blocked.json()).code, 'reset_required');
    const reset = await POST(request('user-a', { concept: 'distribution', action: 'reset', expectedRevision: 3 }));
    assert.equal(reset.status, 200);
    const after = await reset.json();
    assert.equal(after.resetRequired, false);
    assert.equal(after.journey.phase, 'entry');
    assert.equal(after.revision, 4);
  } finally { mock.restore(); }
});

test('v2 progress returns an explicit format code for an expanded-form task', async () => {
  const mock = mockSupabase();
  try {
    const selected = await POST(request('user-a', { concept: 'distribution', action: 'select-topic', topicId: 'spl', expectedRevision: 0 }));
    assert.equal(selected.status, 200);
    const q1 = await POST(request('user-a', { concept: 'distribution', action: 'submit', expectedRevision: 1, questionId: 'spl-q1', answer: 'A' }));
    assert.equal(q1.status, 200);
    const q2 = await POST(request('user-a', { concept: 'distribution', action: 'submit', expectedRevision: 2, questionId: 'distribution-q2', answer: '4(x+3)' }));
    assert.equal(q2.status, 400);
    assert.equal((await q2.json()).code, 'expanded_form_required');
  } finally { mock.restore(); }
});

test('optional review completion does not imply validation access', async () => {
  const mock = mockSupabase();
  const post = async (body: unknown) => (await POST(request('user-a', body))).json();
  try {
    await post({ concept: 'distribution', action: 'select-topic', topicId: 'spl', expectedRevision: 0 });
    await post({ concept: 'distribution', action: 'submit', expectedRevision: 1, questionId: 'spl-q1', answer: 'B' });
    await post({ concept: 'distribution', action: 'submit', expectedRevision: 2, questionId: 'distribution-q2', answer: '4x+12' });
    await post({ concept: 'distribution', action: 'submit', expectedRevision: 3, questionId: 'distribution-q3', answer: 'Lima dikali ke setiap suku: x menjadi 5x dan 2 menjadi 10.' });
    await post({ concept: 'distribution', action: 'start-review', expectedRevision: 4 });
    await post({ concept: 'distribution', action: 'advance', expectedRevision: 5 });
    await post({ concept: 'distribution', action: 'advance', expectedRevision: 6 });
    const completed = await post({ concept: 'distribution', action: 'submit', expectedRevision: 7, questionId: 'distribution-practice', answer: '10' });
    assert.equal(completed.journey.phase, 'review-complete');
    assert.equal(completed.journey.origin, 'optional-review');
    assert.equal(completed.journey.learnerState, null);
    assert.equal(completed.journey.map.progress, null);
    assert.match(completed.feedback, /tidak membuka validasi/i);
    assert.match(completed.journey.resultExplanation, /tidak membuka validasi/i);
  } finally { mock.restore(); }
});

test('FR-C1-01..05: subject/topic catalog supports only SPL and rejects forged capability requests', async () => {
  const data = await (await getCatalog(new Request('https://backend.test/api/v2/catalog'))).json();
  assert.equal(data.grades, undefined);
  assert.equal(data.subjects[0].id, 'algebra');
  assert.deepEqual(data.subjects[0].topics.filter((topic: { availability: string }) => topic.availability === 'active').map((topic: { id: string }) => topic.id), ['spl']);
  const mock = mockSupabase();
  try {
    for (const extra of [{ topicId: 'quadratic' }, { topicId: 'inverse' }, { moduleId: 'x-quadratic' }, { grade: 10 }, { learnerState: 'understood' }, { mastery: 'understood' }]) {
      const response = await POST(request('user-a', { concept: 'distribution', action: 'select-topic', topicId: 'spl', expectedRevision: 0, ...extra }));
      assert.equal(response.status, 400);
    }
    assert.equal(mock.v2Rows.size, 0);
  } finally { mock.restore(); }
});

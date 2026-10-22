import { test } from 'node:test';
import assert from 'node:assert/strict';
import { GET, POST, OPTIONS } from '../app/api/v2/progress/route.ts';
import { GET as getCatalog } from '../app/api/v2/catalog/route.ts';
import { newJourney as newJourneyForTest } from '../lib/v2/engine.ts';
import { mockSupabase, userA } from './v2-helpers.ts';

const url = 'https://backend.test/api/v2/progress';
const request = (token?: string, body?: unknown) => new Request(url, {
  method: body === undefined ? 'GET' : 'POST',
  headers: { Origin: 'https://learn.example.com', ...(token ? { Authorization: `Bearer ${token}` } : {}), 'Content-Type': 'application/json' },
  body: body === undefined ? undefined : JSON.stringify(body),
});

test('v2 catalog exposes supported scope and draft labels without answer keys', async () => {
  const response = await getCatalog(new Request('https://backend.test/api/v2/catalog'));
  assert.equal(response.status, 200);
  const data = await response.json();
  assert.equal(data.contentStatus, 'draft-ops-04');
  assert.equal(data.subjects[0].topics[0].concepts[0].id, 'distribution');
  assert.equal(data.subjects[0].topics[0].capabilities.diagnosis, 'active');
  assert.equal(data.subjects[0].topics[0].capabilities.validation, 'confirmed-recovery-only');
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
    const command = { concept: 'distribution', action: 'submit', expectedRevision: 1, questionId: 'spl-q1', answer: 'B', mastery: 'understood' };
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
      session: { ...newJourneyForTest(), contentVersion: 'old-bank' },
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
    const q2 = await POST(request('user-a', { concept: 'distribution', action: 'submit', expectedRevision: 2, questionId: 'distribution-q2', answer: '3(x+2)' }));
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
    await post({ concept: 'distribution', action: 'submit', expectedRevision: 2, questionId: 'distribution-q2', answer: '3x+6' });
    await post({ concept: 'distribution', action: 'submit', expectedRevision: 3, questionId: 'distribution-q3', answer: 'Tiga dikali ke setiap suku: x menjadi 3x dan 2 menjadi 6.' });
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

test('grade 10 catalog locks every module except SPL; forged entry cannot bypass it', async () => {
  const data = await (await getCatalog(new Request('https://backend.test/api/v2/catalog'))).json();
  const modules = data.grades[0].modules;
  assert.equal(modules.length, 10);
  assert.deepEqual(modules.filter((m: { locked: boolean }) => !m.locked).map((m: { id: string }) => m.id), ['x-linear']);
  assert.equal(modules.filter((m: { locked: boolean }) => m.locked).length, 9);
  const mock = mockSupabase();
  try {
    for (const extra of [{ topicId: 'inverse' }, { moduleId: 'x-quadratic' }, { grade: 11 }]) {
      const response = await POST(request('user-a', { concept: 'distribution', action: 'select-topic', topicId: 'spl', expectedRevision: 0, ...extra }));
      assert.equal(response.status, 400);
    }
    assert.equal(mock.v2Rows.size, 0);
  } finally { mock.restore(); }
});

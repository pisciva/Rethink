import { test } from 'node:test';
import assert from 'node:assert/strict';
import { GET as root } from '../app/route.ts';
import { GET as health } from '../app/api/health/route.ts';
import { GET as catalog } from '../app/api/v2/catalog/route.ts';
import { GET, POST, OPTIONS } from '../app/api/v2/progress/route.ts';
import { mockSupabase } from './helpers.ts';

const url = 'https://api.test/api/v2/progress';
const native = (body: unknown, token = 'user-a') => new Request(url, {
  method: 'POST', headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' }, body: JSON.stringify(body),
});

test('Swift native requests need no browser Origin; only the recovery APIs are advertised', async () => {
  const mock = mockSupabase();
  try {
    assert.deepEqual((await root().json()).endpoints, ['/api/health', '/api/v2/catalog', '/api/v2/progress']);
    for (const [handler, path] of [[health, '/api/health'], [catalog, '/api/v2/catalog']] as const) {
      const response = await handler(new Request(`https://api.test${path}`));
      assert.equal(response.status, 200);
      assert.equal(response.headers.get('Cache-Control'), 'no-store');
      assert.equal(response.headers.get('Access-Control-Allow-Origin'), null);
    }
    const response = await GET(new Request(url, { headers: { Authorization: 'Bearer user-a' } }));
    assert.equal(response.status, 200);
    assert.equal((await response.json()).journey.phase, 'entry');
    for (const authorization of ['', 'Bearer forged', 'Basic user-a']) {
      assert.equal((await GET(new Request(url, { headers: { Authorization: authorization } }))).status, 401);
    }
  } finally { mock.restore(); }
});

test('FR-X-01/02: malformed, oversized and unsupported native commands create no evidence', async () => {
  const mock = mockSupabase();
  try {
    for (const body of ['{broken', 'null', '[]', JSON.stringify({ answer: 'x'.repeat(5000) })]) {
      const response = await POST(new Request(url, {
        method: 'POST', headers: { Authorization: 'Bearer user-a', 'Content-Type': 'application/json' }, body,
      }));
      assert.equal(response.status, body.length > 4096 ? 413 : 400);
    }
    for (const action of [null, {}, 3, 'unsupported']) {
      assert.equal((await POST(native({ concept: 'distribution', action, expectedRevision: 0 }))).status, 400);
    }
    assert.equal(mock.v2Rows.size, 0);
    assert.equal((await POST(native({ concept: 'distribution', action: 'select-topic', topicId: 'spl', expectedRevision: 0 }))).status, 200);
    for (const answer of ['', 'Z', '<script>']) {
      assert.equal((await POST(native({ concept: 'distribution', action: 'submit', questionId: 'spl-q1', answer, expectedRevision: 1 }))).status, 400);
    }
    const resumed = await (await GET(new Request(url, { headers: { Authorization: 'Bearer user-a' } }))).json();
    assert.equal(resumed.revision, 1);
    assert.equal(resumed.journey.attempts.length, 0);
    assert.equal(resumed.journey.currentQuestion.id, 'spl-q1');
  } finally { mock.restore(); }
});

test('browser CORS is explicit and never replaces native bearer-token authentication', async () => {
  const mock = mockSupabase();
  try {
    const options = (origin: string, method: string, headers = 'authorization,content-type') => new Request(url, {
      method: 'OPTIONS', headers: { Origin: origin, 'Access-Control-Request-Method': method, 'Access-Control-Request-Headers': headers },
    });
    assert.equal((await OPTIONS(options('https://learn.example.com', 'POST'))).status, 204);
    assert.equal((await OPTIONS(options('https://untrusted.example', 'POST'))).status, 403);
    assert.equal((await OPTIONS(options('https://learn.example.com', 'DELETE'))).status, 403);
    assert.equal((await OPTIONS(options('https://learn.example.com', 'POST', 'x-unapproved'))).status, 403);
    assert.equal((await GET(new Request(url, { headers: { Origin: 'https://learn.example.com' } }))).status, 401);
    assert.equal((await GET(new Request(url, { headers: { Origin: 'https://untrusted.example', Authorization: 'Bearer user-a' } }))).status, 403);
    assert.equal(mock.v2Rows.size, 0);
  } finally { mock.restore(); }
});

import { test } from 'node:test';
import assert from 'node:assert/strict';
import { interpretReasoning } from '../lib/v2/reasoning.ts';
import { mockSupabase } from './v2-helpers.ts';

test('Q3 curated evidence needs no provider; unavailable AI is insufficient', async () => {
  const mock = mockSupabase();
  try {
    assert.deepEqual(await interpretReasoning('Hanya x dikalikan tiga, angka 2 tetap.'), { observation: 'known-error', source: 'curated' });
    assert.deepEqual(await interpretReasoning('Aku kurang tahu.'), { observation: 'insufficient', source: 'curated' });
  } finally { mock.restore(); }
});

test('Q3 gateway advice requires a literal bounded quote and cannot invent a diagnosis', async () => {
  const mock = mockSupabase();
  process.env.AI_GATEWAY_API_KEY = 'test-key';
  const answer = 'Angka 3 berlaku pada kedua suku, x dan 2.';
  let value: unknown = { label: 'correct', quote: '3 berlaku pada kedua suku, x dan 2' };
  globalThis.fetch = async () => new Response(JSON.stringify({ choices: [{ finish_reason: 'stop', message: { content: JSON.stringify(value) } }] }));
  try {
    assert.deepEqual(await interpretReasoning(answer), { observation: 'correct', source: 'gateway' });
    value = { label: 'confirmed', quote: answer };
    assert.equal((await interpretReasoning(answer)).observation, 'insufficient');
    value = { label: 'correct', quote: '3 dikalikan setiap suku x dan 2 yang tidak ditulis siswa' };
    assert.equal((await interpretReasoning(answer)).observation, 'insufficient');
    globalThis.fetch = async () => { throw new Error('offline'); };
    assert.equal((await interpretReasoning(answer)).observation, 'insufficient');
  } finally { mock.restore(); }
});

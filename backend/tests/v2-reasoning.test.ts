import { test } from 'node:test';
import assert from 'node:assert/strict';
import { interpretReasoning } from '../lib/v2/reasoning.ts';
import { explanationObservation, newJourney, submitAnswer, transition } from '../lib/v2/engine.ts';
import { mockSupabase } from './v2-helpers.ts';

test('FR-C3-04: uncertainty guard preserves explicit supported reasoning and misconception fixtures', () => {
  assert.equal(explanationObservation('Tiga dikalikan ke setiap suku: x menjadi 3x dan 2 menjadi 6.'), 'insufficient');
  for (const answer of [
    'Lima dikalikan ke setiap suku: x menjadi 5x dan 2 menjadi 10.',
    'Bukan hanya x yang dikali 5: angka 2 juga dikali 5 sehingga menjadi 5x+10.',
    'Tidak hanya x, 2 juga dikalikan 5. Setiap suku memberi hasil 5x+10.',
  ]) assert.equal(explanationObservation(answer), 'correct', answer);
  for (const answer of [
    'Lima hanya dikalikan ke x; angka 2 tetap.',
    'Angka 2 tidak dikalikan 5.',
  ]) assert.equal(explanationObservation(answer), 'known-error', answer);
});

test('FR-C3-04/05/08: explicit uncertainty and conflicting claims remain insufficient despite AI advice', async () => {
  const mock = mockSupabase();
  process.env.AI_GATEWAY_API_KEY = 'test-key';
  let providerCalls = 0;
  globalThis.fetch = async () => { providerCalls++; throw new Error('provider must not override unresolved reasoning'); };
  try {
    for (const answer of [
      'Saya tidak tahu apakah hanya x yang dikalikan 5.',
      'Bukan hanya x yang dikalikan 5, tetapi angka 2 tetap. Hasilnya 5x+10 untuk setiap suku.',
      'Saya belum yakin, 5x+10 karena 5 dikalikan setiap suku.',
    ]) {
      assert.equal(explanationObservation(answer), 'insufficient', answer);
      assert.deepEqual(await interpretReasoning(answer), { observation: 'insufficient', source: 'curated' });
      let journey = transition(newJourney(), 'select-topic')!;
      journey = submitAnswer(journey, 'spl-q1', 'A')!;
      journey = submitAnswer(journey, 'distribution-q2', '4x+12')!;
      journey = submitAnswer(journey, 'distribution-q3', answer, '2026-10-22T00:00:00Z', {
        observation: 'correct', source: 'gateway',
      })!;
      assert.equal(journey.attempts[2].observation, 'insufficient');
      assert.equal(journey.attempts[2].interpretationSource, 'curated');
      assert.equal(journey.diagnosticOutcome, null);
      assert.equal(journey.learnerState, null);
      assert.equal(journey.phase, 'diagnosis');
    }
    assert.equal(providerCalls, 0);
  } finally { mock.restore(); }
});

test('Q3 curated evidence needs no provider; unavailable AI is insufficient', async () => {
  const mock = mockSupabase();
  try {
    assert.deepEqual(await interpretReasoning('Hanya x dikalikan lima, angka 2 tetap.'), { observation: 'known-error', source: 'curated' });
    assert.deepEqual(await interpretReasoning('Aku kurang tahu.'), { observation: 'insufficient', source: 'curated' });
  } finally { mock.restore(); }
});

test('Q3 gateway advice requires a literal bounded quote and cannot invent a diagnosis', async () => {
  const mock = mockSupabase();
  process.env.AI_GATEWAY_API_KEY = 'test-key';
  const answer = 'Angka 5 berlaku pada kedua suku, x dan 2.';
  let value: unknown = { label: 'correct', quote: '5 berlaku pada kedua suku, x dan 2' };
  globalThis.fetch = async (_input, init) => {
    const body = JSON.parse(String(init?.body));
    assert.match(JSON.stringify(body), /5\(x ?\+ ?2\)/);
    assert.equal(JSON.stringify(body).includes('Mengapa 3(x+2)'), false);
    return new Response(JSON.stringify({ choices: [{ finish_reason: 'stop', message: { content: JSON.stringify(value) } }] }));
  };
  try {
    assert.deepEqual(await interpretReasoning(answer), { observation: 'correct', source: 'gateway' });
    value = { label: 'confirmed', quote: answer };
    assert.equal((await interpretReasoning(answer)).observation, 'insufficient');
    value = { label: 'correct', quote: '5 dikalikan setiap suku x dan 2 yang tidak ditulis siswa' };
    assert.equal((await interpretReasoning(answer)).observation, 'insufficient');
    globalThis.fetch = async () => { throw new Error('offline'); };
    assert.equal((await interpretReasoning(answer)).observation, 'insufficient');
  } finally { mock.restore(); }
});

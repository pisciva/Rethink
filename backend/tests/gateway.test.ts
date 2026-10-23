import { test } from 'node:test';
import assert from 'node:assert/strict';
import { aiConfig, DEFAULT_AI_MODEL } from '../src/infrastructure/gateway.ts';
import { interpretReasoning } from '../src/infrastructure/reasoning.ts';
import { mockSupabase } from './helpers.ts';

test('FR-C3-08: model configuration accepts Gateway providers and rejects malformed IDs', () => {
  const mock = mockSupabase();
  try {
    assert.equal(aiConfig().model, DEFAULT_AI_MODEL);
    process.env.AI_GATEWAY_MODEL = '  ';
    assert.equal(aiConfig().model, DEFAULT_AI_MODEL);
    for (const model of ['deepseek/example-model', 'anthropic/example-model', 'google/example-model', 'openai/example-model', 'meta/example-model:v1']) {
      process.env.AI_GATEWAY_MODEL = ` ${model} `;
      assert.equal(aiConfig().model, model);
      assert.equal(aiConfig().valid, true);
    }
    for (const model of ['model-only', 'https://example.com/model', 'provider/model?key=secret', 'provider/model\nother', 'provider/../model', '/model', 'provider/']) {
      process.env.AI_GATEWAY_MODEL = model;
      assert.equal(aiConfig().valid, false, model);
    }
  } finally { mock.restore(); }
});

test('FR-C3-04/08: env-only model switches preserve bounded Q3 evidence and failure handling', async () => {
  const mock = mockSupabase();
  process.env.AI_GATEWAY_API_KEY = 'test-key';
  const answer = 'Angka 5 berlaku pada kedua suku, x dan 2.';
  let calls = 0;
  let status = 200;
  let value: unknown = { label: 'correct', quote: '5 berlaku pada kedua suku, x dan 2' };
  let finishReason = 'stop';
  globalThis.fetch = async (input, init) => {
    calls++;
    assert.equal(input, 'https://ai-gateway.vercel.sh/v1/chat/completions');
    const body = JSON.parse(String(init?.body));
    assert.equal(body.model, process.env.AI_GATEWAY_MODEL);
    assert.equal(body.response_format.type, 'json_schema');
    assert.equal(body.max_tokens, 160);
    assert.equal('temperature' in body, false);
    assert.equal('reasoning' in body, false);
    return new Response(JSON.stringify({ choices: [{ finish_reason: finishReason, message: { content: JSON.stringify(value) } }] }), { status });
  };
  try {
    for (const model of ['anthropic/example-model', 'google/example-model', 'openai/example-model']) {
      process.env.AI_GATEWAY_MODEL = model;
      assert.deepEqual(await interpretReasoning(answer), { observation: 'correct', source: 'gateway' });
    }
    value = { label: 'confirmed', quote: answer };
    assert.deepEqual(await interpretReasoning(answer), { observation: 'insufficient', source: 'curated' });
    value = { label: 'correct', quote: 'invented evidence' };
    assert.equal((await interpretReasoning(answer)).observation, 'insufficient');
    value = { label: 'correct', quote: '5 berlaku pada kedua suku, x dan 2' };
    finishReason = 'length';
    assert.equal((await interpretReasoning(answer)).observation, 'insufficient');
    finishReason = 'stop';
    for (status of [400, 401, 402, 403, 429, 503]) {
      const before = calls;
      assert.deepEqual(await interpretReasoning(answer), { observation: 'insufficient', source: 'curated' });
      assert.equal(calls, before + 1, 'no model or credential retry');
    }
    const before = calls;
    process.env.AI_GATEWAY_MODEL = 'invalid-model';
    assert.equal((await interpretReasoning(answer)).observation, 'insufficient');
    assert.equal(calls, before, 'invalid configuration makes no external call');
    delete process.env.AI_GATEWAY_MODEL;
    delete process.env.AI_GATEWAY_API_KEY;
    assert.equal((await interpretReasoning(answer)).observation, 'insufficient');
    assert.equal(calls, before, 'missing credentials make no external call');
  } finally { mock.restore(); }
});

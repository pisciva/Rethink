import { test } from 'node:test';
import assert from 'node:assert/strict';
import { catalog, CONTENT_VERSION, learningAssets, publicQuestion, questions } from '../lib/v2/content.ts';
import { equivalent, parseLinear } from '../lib/math.ts';
import { newJourney, submitAnswer, transition } from '../lib/v2/engine.ts';

// Independently expanded references for the current draft items, not approved rubrics.
test('FR-C3-02/05: revised core items use distinct expressions and Q3 supplies no Q2 solution', () => {
  assert.equal(CONTENT_VERSION, 'spl-distribution-draft-3');
  assert.equal(catalog.contentVersion, CONTENT_VERSION);
  assert.equal(questions.q2.math, '4(x + 3)');
  assert.equal(equivalent(questions.q2.math!, '4x+12', 'expression'), true);
  assert.match(questions.q3.prompt, /5\(x \+ 2\)/);
  const visible = JSON.stringify(publicQuestion(questions.q3)).replace(/\s+/g, '');
  for (const answer of ['4x+12', '4x+3', '5x+10']) assert.equal(visible.includes(answer), false);
  assert.equal(equivalent('5(x+2)', '5x+10', 'expression'), true);
});

test('FR-C3-02/04 and FR-C5-02/04: draft answer keys match mathematical references', () => {
  const references = [
    [questions.q2, { a: 4, b: 12 }],
    [questions.q4, { a: 0, b: 8 }],
    [questions.practice, { a: 0, b: 10 }],
    [questions.retry, { a: 4, b: 20 }],
    [questions.transfer, { a: 3, b: 12 }],
  ] as const;
  for (const [item, reference] of references) {
    assert.deepEqual(parseLinear(item.expected!), reference, item.id);
  }
  for (const item of [questions.q2, questions.retry]) {
    assert.equal(equivalent(item.math!, item.expected!, 'expression'), true, item.id);
  }
  for (const item of [questions.q4, questions.practice]) {
    const [left, right] = item.math!.replace('…', item.expected!).split('=');
    assert.equal(equivalent(left, right, 'expression'), true, item.id);
  }
  // First SPL equation: 3x + 6 + y = 15. Together with x+y=5, x=2,y=3.
  const holdsAtReferenceSolution = (equation: string) => {
    const [left, right] = equation.replace(/y/g, '(3)').split('=').map(side => parseLinear(side));
    assert.ok(left && right, `unreadable reference equation: ${equation}`);
    return left.a * 2 + left.b === right.a * 2 + right.b;
  };
  for (const equation of questions.q1.math!.split(';')) assert.equal(holdsAtReferenceSolution(equation), true);
  for (const option of questions.q1.options!) {
    assert.equal(holdsAtReferenceSolution(option.text), option.id === questions.q1.expected, option.id);
  }
  for (const item of [questions.q2, questions.q4]) {
    assert.equal(equivalent(item.knownError!, item.expected!, item.format as 'expression' | 'number'), false);
  }
});

test('FR-C4-03/04: repeated groups and worked transformations preserve the expression', () => {
  const visual = learningAssets.visual;
  const group = parseLinear(visual.termsPerGroup.join('+'))!;
  assert.deepEqual(parseLinear(visual.resultTerms.join('+')), {
    a: visual.groups * group.a, b: visual.groups * group.b,
  });
  const worked = learningAssets.worked;
  for (const step of worked.steps) {
    const sides = step.expression.split('=');
    if (sides.length === 2) assert.equal(equivalent(sides[0], sides[1], 'expression'), true);
    else assert.equal(equivalent(step.expression, worked.problem, 'expression'), true);
    assert.ok(step.reason.trim());
  }
});

test('FR-C5-04: linear evaluation handles alternate forms without conflating wrong or unreadable math', () => {
  for (const answer of ['20+4x', '4*x+20', '8x/2+40/2', '4×x+20', '4,0x+20']) {
    assert.equal(equivalent(answer, questions.retry.expected!, 'expression'), true, answer);
  }
  for (const answer of ['4x+5', '4x-20', '20x+4']) {
    assert.equal(equivalent(answer, questions.retry.expected!, 'expression'), false, answer);
  }
  for (const answer of ['', 'x*x', '1/(x-1)', '4x+20/0', 'alert(1)']) {
    assert.equal(equivalent(answer, questions.retry.expected!, 'expression'), null, answer);
  }
});

test('FR-C3-03 and FR-C5-02: public questions omit grading references', () => {
  for (const item of Object.values(questions)) {
    const visible = publicQuestion(item);
    assert.equal('expected' in visible, false, item.id);
    assert.equal('knownError' in visible, false, item.id);
  }
});

test('FR-C5-04/05: unreadable retry and transfer responses establish no learner state', () => {
  let journey = transition(newJourney(), 'select-topic')!;
  for (const [id, value] of [
    ['spl-q1', 'B'], ['distribution-q2', '4x+3'],
    ['distribution-q3', 'Lima hanya dikalikan ke x; angka 2 tetap.'],
  ]) journey = submitAnswer(journey, id, value)!;
  journey = transition(journey, 'start-recovery')!;
  journey = transition(transition(journey, 'advance')!, 'advance')!;
  journey = submitAnswer(journey, 'distribution-practice', '10')!;
  for (const phase of ['retry', 'transfer'] as const) {
    assert.equal(journey.phase, phase);
    const before = structuredClone(journey);
    for (const answer of ['', 'x*x', '4x+20/0', 'I do not know']) {
      assert.equal(submitAnswer(journey, `distribution-${phase}`, answer), null, answer);
      assert.deepEqual(journey, before);
      assert.equal(journey.learnerState, null);
    }
    if (phase === 'retry') journey = submitAnswer(journey, 'distribution-retry', '20+4x')!;
  }
});

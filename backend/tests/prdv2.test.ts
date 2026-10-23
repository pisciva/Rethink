import { test } from 'node:test';
import assert from 'node:assert/strict';
import { primaryItems, finalItems, distributionProbe, learningItems, visibleItem } from '../src/prdv2/content.ts';
import { append, conceptResults, currentItem, evaluateItem, newSession, nextHint, parseCommand, publicState, readSession, replay } from '../src/prdv2/engine.ts';
import type { Command, Event, Session } from '../src/prdv2/types.ts';
import { GET, createHandlers } from '../src/prdv2/http.ts';
import { mockSupabase } from './helpers.ts';

const at = '2026-10-23T07:00:00.000Z';

test('FR-C5-04/09: proposed final answer references satisfy both original SPL equations uniquely', () => {
  const pairs = [ [[3, 4], [4, 3], [4, 4]], [[4, 3], [3, 4], [5, 1]], [[3, 4], [4, 3], [2, 5]], [[4, -2], [-2, 4], [-4, 2]], [[3, 4], [5, 2], [4, 3]] ];
  const checks = [
    (x: number, y: number) => x + y === 7 && x - y === 1,
    (x: number, y: number) => 2 * x + y === 11 && x - y === 1,
    (x: number, y: number) => 3 * (x + 1) + y === 14 && x + y === 7,
    (x: number, y: number) => x + y === 2 && x - y === -6,
    (book: number, pen: number) => 2 * book + pen === 11 && book + pen === 7,
  ];
  for (let i = 0; i < finalItems.length; i++) {
    const valid = pairs[i].map(([x, y], j) => checks[i](x, y) ? String.fromCharCode(65 + j) : null).filter(Boolean);
    assert.deepEqual(valid, [finalItems[i].expected], finalItems[i].id);
  }
});
function run(session: Session, fields: Omit<Command, 'expectedRevision'>, metadata: Pick<Event, 'adviceQuote' | 'hintId' | 'hintSource'> = {}): Session {
  const next = append(session, { ...fields, expectedRevision: 0 }, metadata, at);
  assert.ok(next, JSON.stringify(fields));
  return next;
}
function diagnose(answers: string[] = ['A', '4x+12', '5x+10 karena 5 mengalikan setiap suku x dan 2', 'A', 'A', '5', 'A', '2', '6', 'A']): Session {
  let session = run(newSession(), { action: 'select-topic', topicId: 'spl' });
  for (const answer of answers) session = run(session, { action: 'submit', questionId: currentItem(replay(session)!)!.id, answer });
  return session;
}
function recovery(): Session { return diagnose(['B', '4x+3', '5 hanya untuk x dan 2 tetap', 'A', 'A', '5', 'A', '2', '6', 'A']); }
function learn(session: Session): Session {
  session = run(session, { action: 'start-learning', conceptId: 'distribution' });
  session = run(session, { action: 'advance' });
  session = run(session, { action: 'advance' });
  return run(session, { action: 'submit', questionId: learningItems.practice.id, answer: '10' });
}

test('FR-C3-02: proposed blueprint has exactly ten primaries, separate probe, and no public reference answers', () => {
  assert.equal(primaryItems.length, 10);
  assert.equal(finalItems.length, 5);
  assert.equal(new Set([...primaryItems, distributionProbe, ...finalItems].map(q => q.id)).size, 16);
  assert.ok(distributionProbe.id.startsWith('probe-'));
  for (const item of [...primaryItems, distributionProbe, ...finalItems]) {
    const visible = visibleItem(item);
    assert.equal('expected' in visible, false);
    assert.equal('knownErrors' in visible, false);
    assert.equal('attribution' in visible, false);
    if (item.format !== 'explanation') assert.equal(evaluateItem(item, item.expected!), 'correct', item.id);
  }
  for (const item of finalItems) assert.equal(item.attribution, null);
});

test('FR-C3-01/02/09: diagnosis never ends before ten primary responses or discloses interim evidence', () => {
  let session = run(newSession(), { action: 'select-topic', topicId: 'spl' });
  const answers = ['A', '4x+12', '5x+10 karena setiap suku x dan 2', 'A', 'A', '5', 'A', '2', '6', 'A'];
  for (let i = 0; i < answers.length; i++) {
    const state = replay(session)!;
    assert.equal(state.phase, 'diagnosis');
    assert.equal(publicState(state).diagnosticResults.length, 0);
    assert.equal(publicState(state).diagnosticOutcome, null);
    session = run(session, { action: 'submit', questionId: currentItem(state)!.id, answer: answers[i] });
    assert.ok(readSession(session));
  }
  const state = replay(session)!;
  assert.equal(state.phase, 'diagnostic-result');
  assert.deepEqual(conceptResults(state).map(c => c.status), ['not-supported', 'not-supported', 'not-supported', 'not-supported', 'insufficiently-assessed']);
  assert.equal(state.learning, null);
  assert.ok(publicState(state).availableActions.includes('start-final-assessment'));
});

test('FR-C3-04/05/07: separate rubrics attribute errors and counterevidence per concept', () => {
  const mixed = diagnose(['B', '4x+3', '5 hanya untuk x dan 2 tetap', 'B', 'B', '13', 'A', '-8', '-2', 'B']);
  const results = conceptResults(replay(mixed)!);
  assert.deepEqual(results.map(c => c.status), ['supported', 'supported', 'uncertain', 'supported', 'insufficiently-assessed']);
  assert.equal(results[1].learningAvailable, false);
  assert.equal(results[4].coverage.adequate, false);
  assert.equal(results[4].learnerState, null);
  const targetCounterexample = diagnose(['A', '4x+3', '5 hanya untuk x dan 2 tetap', 'A', 'A', '5', 'A', '2', '6', 'A']);
  assert.equal(conceptResults(replay(targetCounterexample)!)[0].status, 'uncertain');
});

test('FR-C3-06/08: insufficient distribution evidence gets one named follow-up after all ten primaries', () => {
  let session = diagnose(['B', '9x+9', 'Saya belum yakin.', 'A', 'A', '5', 'A', '2', '6', 'A']);
  assert.equal(replay(session)!.phase, 'diagnosis');
  assert.equal(currentItem(replay(session)!)!.id, distributionProbe.id);
  assert.match(publicState(replay(session)!).presentation.activity, /tambahan/);
  session = run(session, { action: 'submit', questionId: distributionProbe.id, answer: '4' });
  assert.equal(replay(session)!.phase, 'diagnostic-result');
  assert.equal(conceptResults(replay(session)!)[0].status, 'insufficiently-assessed');
  assert.equal(append(session, { action: 'submit', expectedRevision: 0, questionId: distributionProbe.id, answer: '4' }), null);
});

test('FR-C3-04/08: persisted AI quote is verified on replay and cannot override uncertainty', () => {
  let session = run(newSession(), { action: 'select-topic', topicId: 'spl' });
  session = run(session, { action: 'submit', questionId: primaryItems[0].id, answer: 'A' });
  session = run(session, { action: 'submit', questionId: primaryItems[1].id, answer: '4x+12' });
  const command: Command = { action: 'submit', expectedRevision: 0, questionId: primaryItems[2].id, answer: 'Angka 5 berlaku pada kedua suku, x dan 2.' };
  const accepted = append(session, command, { adviceQuote: '5 berlaku pada kedua suku, x dan 2' }, at)!;
  assert.ok(readSession(accepted));
  assert.equal(replay(accepted)!.diagnosticAnswers[2].source, 'gateway');
  assert.equal(append(session, command, { adviceQuote: '5 dikali semua suku x dan 2 yang tidak ada' }), null);
  assert.equal(append(session, { ...command, answer: 'Belum yakin, 5 berlaku pada kedua suku, x dan 2.' }, { adviceQuote: '5 berlaku pada kedua suku, x dan 2' }), null);
});

test('FR-C4/FR-C5: optional review cannot produce concept validation or state; open learning skips unavailable concepts', () => {
  let session = diagnose();
  assert.equal(publicState(replay(session)!).presentation.stages.find(stage => stage.id === 'validation')!.state, 'not-applicable');
  assert.equal(append(session, { action: 'start-learning', conceptId: 'like-terms' as 'distribution', expectedRevision: 0 }), null);
  session = learn(session);
  assert.equal(replay(session)!.phase, 'review-complete');
  assert.equal(replay(session)!.learning!.origin, 'optional-review');
  assert.equal(replay(session)!.learning!.learnerState, null);
  assert.equal(append(session, { action: 'submit', questionId: learningItems.retry.id, answer: '4x+20', expectedRevision: 0 }), null);
  session = run(session, { action: 'start-final-assessment' });
  assert.equal(replay(session)!.phase, 'final-assessment');
});

test('FR-C5-01..08: confirmed recovery retains retry/transfer matrix and scaffold-free gates', () => {
  const session = learn(recovery());
  assert.equal(replay(session)!.phase, 'retry');
  assert.equal(nextHint(replay(session)!), null);
  const failed = run(session, { action: 'submit', questionId: learningItems.retry.id, answer: '4x+5' });
  assert.equal(replay(failed)!.learning!.learnerState, 'needs-reinforcement');
  assert.equal(append(failed, { action: 'submit', questionId: learningItems.transfer.id, answer: '3x+12', expectedRevision: 0 }), null);
  assert.equal(replay(run(failed, { action: 'start-learning', conceptId: 'distribution' }))!.phase, 'visual');
  const retry = run(session, { action: 'submit', questionId: learningItems.retry.id, answer: '20+4x' });
  assert.equal(replay(retry)!.phase, 'transfer');
  const procedural = run(retry, { action: 'submit', questionId: learningItems.transfer.id, answer: '3x+4' });
  assert.equal(replay(procedural)!.learning!.learnerState, 'procedural-only');
  const understood = run(retry, { action: 'submit', questionId: learningItems.transfer.id, answer: '12+3x' });
  assert.equal(replay(understood)!.learning!.learnerState, 'understood');
});

test('FR-C4-05/07: passive viewing and unreadable/wrong practice never complete learning', () => {
  let session = run(recovery(), { action: 'start-learning', conceptId: 'distribution' });
  session = run(run(session, { action: 'advance' }), { action: 'advance' });
  assert.equal(replay(session)!.learning!.completed, false);
  for (const answer of ['', 'abc', '10.0.0']) assert.equal(append(session, { action: 'submit', expectedRevision: 0, questionId: learningItems.practice.id, answer }), null);
  session = run(session, { action: 'submit', questionId: learningItems.practice.id, answer: '2' });
  assert.equal(replay(session)!.phase, 'practice');
  assert.equal(replay(session)!.learning!.completed, false);
});

test('FR-C4-09: progressive hints use approved questions and are unavailable during diagnosis or independent assessments', () => {
  let session = recovery();
  assert.equal(nextHint(replay(session)!), null);
  session = run(session, { action: 'start-learning', conceptId: 'distribution' });
  for (let i = 0; i < 3; i++) {
    const hint = nextHint(replay(session)!)!;
    assert.equal(append(session, { action: 'request-hint', expectedRevision: 0 }, { hintId: 'invented-answer', hintSource: 'gateway' }), null);
    session = run(session, { action: 'request-hint' }, { hintId: hint.id, hintSource: 'curated' });
    assert.ok(readSession(session));
  }
  assert.equal(nextHint(replay(session)!), null);
  assert.equal(publicState(replay(session)!).hints.length, 3);
  session = run(session, { action: 'start-final-assessment' });
  assert.equal(nextHint(replay(session)!), null);
  assert.equal(append(session, { action: 'request-hint', expectedRevision: 0 }, { hintId: 'visual-1', hintSource: 'gateway' }), null);
});

for (let score = 0; score <= 5; score++) test(`FR-C5-09/10/11: exactly five final items; score ${score}/5 has independent topic result`, () => {
  let session = run(diagnose(), { action: 'start-final-assessment' });
  for (let i = 0; i < 5; i++) {
    const item = currentItem(replay(session)!)!;
    const answer = i < score ? item.expected! : item.options!.find(o => o.id !== item.expected)!.id;
    session = run(session, { action: 'submit', questionId: item.id, answer });
    assert.ok(readSession(session));
    if (i < 4) {
      assert.equal(replay(session)!.phase, 'final-assessment');
      assert.equal(publicState(replay(session)!).finalAssessment.attempts[0].score, null);
    }
  }
  const state = replay(session)!;
  assert.equal(state.phase, 'final-result');
  assert.equal(state.finalAttempts[0].score, score);
  assert.equal(state.finalAttempts[0].result, score >= 3 ? 'passed' : 'not-passed');
  assert.equal(state.learning, null);
  assert.equal(publicState(state).map.progress, null);
  assert.equal(publicState(state).availableActions.includes('start-final-assessment'), score < 3);
});

test('FR-C5-10/11 and FR-X: topic retry/restart preserves all attempts and independent concept state', () => {
  let session = learn(recovery());
  session = run(session, { action: 'submit', questionId: learningItems.retry.id, answer: '4x+20' });
  session = run(session, { action: 'submit', questionId: learningItems.transfer.id, answer: '3x+12' });
  session = run(session, { action: 'start-final-assessment' });
  for (const item of finalItems) session = run(session, { action: 'submit', questionId: item.id, answer: item.expected === 'A' ? 'B' : 'A' });
  assert.equal(replay(session)!.learning!.learnerState, 'understood');
  const before = structuredClone(replay(session)!.finalAttempts);
  session = run(session, { action: 'start-final-assessment' });
  assert.deepEqual(replay(session)!.finalAttempts.slice(0, 1), before);
  session = run(session, { action: 'submit', questionId: finalItems[0].id, answer: finalItems[0].expected! });
  session = run(session, { action: 'restart-diagnosis' });
  assert.equal(replay(session)!.finalAttempts.length, 2);
  assert.equal(replay(session)!.diagnosticAnswers.length, 0);
  assert.equal(replay(session)!.phase, 'entry');
  assert.ok(readSession(session));
  session = run(session, { action: 'select-topic', topicId: 'spl' });
  for (const item of primaryItems) session = run(session, { action: 'submit', questionId: item.id, answer: item.format === 'explanation' ? '5x+10 karena setiap suku x dan 2' : item.expected! });
  session = run(session, { action: 'start-final-assessment' });
  assert.equal(replay(session)!.finalAttempts.length, 2, 'resume the preserved incomplete attempt, do not create another');
  assert.equal(currentItem(replay(session)!)!.id, finalItems[1].id);
});

test('FR-C4-08/FR-C5-11: revisiting learning cannot erase a valid independent concept result', () => {
  let session = learn(recovery());
  session = run(session, { action: 'submit', questionId: learningItems.retry.id, answer: '4x+20' });
  session = run(session, { action: 'submit', questionId: learningItems.transfer.id, answer: '3x+12' });
  const before = publicState(replay(session)!).presentation.achievement;
  assert.ok(before);
  session = run(session, { action: 'start-learning', conceptId: 'distribution' });
  const state = replay(session)!;
  assert.equal(state.learning!.learnerState, null, 'the new learning cycle has not been validated');
  assert.equal(state.conceptLearnerState, 'understood', 'last valid C5 evidence remains authoritative');
  assert.equal(publicState(state).map.progress, 'understood');
  assert.equal(publicState(state).presentation.achievement, null, 'a new cycle does not create another award');
});

test('FR-X-01..03: interrupted sessions replay exactly and forged commands/history cannot assign states', () => {
  let session = diagnose();
  session = run(session, { action: 'start-final-assessment' });
  session = run(session, { action: 'submit', questionId: finalItems[0].id, answer: 'B' });
  assert.deepEqual(replay(readSession(JSON.parse(JSON.stringify(session)))!), replay(session));
  assert.equal(parseCommand({ action: 'start-learning', conceptId: 'distribution', expectedRevision: 0, learnerState: 'understood' }), null);
  assert.equal(parseCommand({ action: 'request-hint', expectedRevision: 0, hintId: 'practice-3' }), null);
  const forged = structuredClone(session);
  forged.events[0].action = 'start-final-assessment';
  assert.equal(readSession(forged), null);
  const unknown = structuredClone(session) as unknown as { events: Record<string, unknown>[] };
  unknown.events.at(-1)!.observation = 'correct';
  assert.equal(readSession(unknown), null);
  assert.equal(readSession({ ...session, bankVersion: 'old-bank' }), null);
});

test('FR-C5-09: no final assessment before diagnosis; public/auth guards and content review gate', async () => {
  assert.equal(append(newSession(), { action: 'start-final-assessment', expectedRevision: 0 }), null);
  const mock = mockSupabase();
  try {
    assert.equal((await GET(new Request('https://api.test/api/v3/progress'))).status, 401);
    const headers = { Authorization: 'Bearer user-a', 'Content-Type': 'application/json' };
    const active = await GET(new Request('https://api.test/api/v3/progress', { headers }));
    assert.equal(active.status, 200);
    assert.equal((await active.json()).journey.phase, 'entry');
    const disabled = createHandlers(false);
    const response = await disabled.GET(new Request('https://api.test/api/v3/progress', { headers }));
    assert.equal(response.status, 503);
    assert.equal((await response.json()).code, 'content_review_required');
    assert.equal((await disabled.POST(new Request('https://api.test/api/v3/progress', { method: 'POST', headers, body: '{}' }))).status, 503);
    assert.equal(mock.v2Rows.size, 0);
  } finally { mock.restore(); }
});

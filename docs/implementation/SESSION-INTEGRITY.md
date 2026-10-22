# Saved-session evidence integrity — 22 October 2026

> **Current implementation:** recovery modules and equivalent fixtures moved into `backend/src/` and `backend/tests/` during the [23 October rebuild](BACKEND-REBUILD.md). Older paths and test totals below describe the prior revision. Current suite: 50 passing tests; no deployment or final OI/OPS acceptance.

**Status: implemented engineering guard and executed checks; OPS-05 remains Pending.** This documents the existing draft-3 journey and does not approve a final persistence/state-machine specification.

## Scope and source

The approved requirements require preservation of topic, concept, origin and evidence (FR-X-01, PDF p. 80), outcome-gated transitions (FR-X-02, p. 80) and agreement between results and the map (FR-X-03, p. 81). C5 learner states require applicable evaluated retry/transfer evidence (FR-C5-04/05/08, pp. 77–79). The diagnostic collection must retain roles and respect the single-Q4 limit (FR-C3-03/05/06, pp. 67–68).

See [requirements](../prd/requirements.md), [architecture](../technical/architecture.md) and [decisions](../decisions.md). OI-01..03 and OPS-01..05 retain their existing status. No user-facing copy, question bank, new learner state or new learning path is introduced here.

## Defect and implemented behavior

Previously, `readJourney` checked field types and some phase constraints but accepted, for example, a current-version `validation-result` snapshot containing `Understood` with no attempts. It also accepted reordered diagnostic answers or a stored observation inconsistent with its raw answer. GET could consequently project a result lacking supporting history.

The loader now validates that the current-version snapshot is reachable through the existing engine:

1. Start with the existing empty journey and selected-topic context.
2. Validate each stored answer, item order, timestamp, observation and interpretation source through `submitAnswer`.
3. Use only existing non-answer transitions to account for navigation between diagnostic results, visual explanation, worked example, practice and reinforcement.
4. Compare the resulting phase, origin, diagnostic result, completion and learner state with the saved snapshot.

This is an integrity check, not a replacement grade or diagnosis. The stored record is never rewritten by a read. It does not call an AI provider or fetch new evidence. Existing bounded Gateway advice is represented by its stored source and observation; the local guard still applies. Full historical provider quotes are not stored, so this is not independent re-verification of the original AI interpretation.

An inconsistent snapshot returns `null` from the loader. The existing API then returns `resetRequired: true` with no journey/map/result, rejects continuation with `409 reset_required`, and permits the existing explicit reset using the current revision. The record remains unchanged until that reset is acknowledged. This does not claim that inconsistent data proves any learner misunderstanding.

Current valid draft-3 sessions keep their version and continue normally. Older banks retain their existing version-mismatch reset behavior. Future changes to evaluation or transition rules must account for content/policy versioning so a historical session is not silently reinterpreted.

## Existing journey transitions checked for resume

This table records the implementation being checked, not final OPS-05 approval.

| Saved stage | Existing continuation and evidence boundary |
|---|---|
| Entry | Select supported SPL; no assessment or learner state yet. |
| Diagnosis | Q1 → Q2 → Q3, then at most one conditional Q4 under existing rules. |
| Diagnostic result | Confirmed recovery or non-confirmed optional review preserves the recorded outcome and origin. |
| All-correct pending | No invented outcome or continuation; OI-03 remains Open. |
| Visual / worked | Existing linear advancement; no completion or C5 state from navigation. |
| Practice | Mathematical response required; current draft completion rule retained, pending OPS-01/02. |
| Optional review complete | No C5 eligibility; current interim OI-02 direction retained. |
| Retry | Requires eligible completed confirmed recovery; valid failure ends validation without transfer. |
| Transfer | Requires successful retry; no repeated transfer loop. |
| Validation result | Must match the existing approved C5 matrix applied to recorded item evaluations. |
| Reinforcement | Existing package; previous attempts remain historical while current completion and map state are cleared. |

## Executed verification

Windows Node.js 24.18.1; full backend suite **79 passed, 0 failed**, including nested PostgreSQL cases. Production build including TypeScript **PASS**. Commands from `backend/`:

```sh
node --experimental-strip-types --test 'tests/*.test.ts'
node node_modules/next/dist/bin/next build
```

| Scenario | Evidence | Result |
|---|---|---|
| Resume at every existing phase | `tests/v2-progress.test.ts`: all 11 phases, correct/incorrect practice, retry failure, transfer failure/pass, optional review, pending result, Q4 and reinforcement cycles | PASS |
| Missing/contradictory C5 history | Missing retry/transfer/practice, mismatched learner state, premature transfer and optional-review validation snapshots rejected without mutation | PASS |
| Diagnostic history integrity | Reordered/duplicate roles, changed raw answers, unreadable math and mismatched observations rejected | PASS |
| AI and bounded history | Stored Gateway observation/source round-trip; current uncertainty guard and existing 100-attempt bound retained | PASS |
| Corrupted snapshot through API | GET hides unsupported learner claim; continuation requires explicit reset; no automatic stored-data rewrite | PASS |
| Failed persistence write | 503 creates no evidence or success feedback; reload retains prior question/revision; same command can be retried successfully | PASS |
| Real v2 SQL permissions | Actual migration executed in embedded PostgreSQL; anon/authenticated cannot read/write/delete or invoke private save RPC | PASS |
| Revision and ownership isolation | Duplicate creation/stale/competing revision saves cannot overwrite; other owner's progress preserved | PASS |
| Legacy separation and deletion | Legacy rows do not become v2 evidence; v2 writes leave legacy data intact; deleting an account removes only its records | PASS |

Database tests execute the real SQL files in an isolated PGlite instance. The SQL RPC checks its supported storage envelope and optimistic revision, while application validation checks journey semantics. The database tests do not assert that SQL alone adjudicates mathematics or verifies the entire learning state. Competing saves use the embedded database's execution model; they are not a distributed-load benchmark.

## Remaining acceptance work

- **Blocked by pending decision:** final OPS-05 operational schema/transition review; OI-01 diagnostic methodology; OPS-01/02 completion and feedback; OPS-03/04 response handling and mathematics/rubric acceptance; OI-02/03 unresolved branches.
- **Not run:** live Supabase migration/permissions verification, real authenticated device journey, iOS build/runtime, accessibility and learner comprehension studies.
- No SQL schema change, migration execution against a live database, deployment or GitHub push was performed for this slice.
- Existing malformed/inconsistent records will require explicit restart. They are not automatically repaired, merged or interpreted as failed learning.

No approved FR is marked wholly Passed based solely on this engineering verification.

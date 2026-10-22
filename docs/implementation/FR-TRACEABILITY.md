# MVP functional requirement implementation trace

Source: `../prd/requirements.md` (39 approved Must Have FRs). This table records the **active SwiftUI → backend v2 path**, not the older local prototype or the website v1 API. Engineering status below means product acceptance, not whether a code path exists or a unit test passed. “Code present” means an implementation path exists; it does **not** mean the mathematics, product policy, usability, or live release has received final acceptance. The question bank and operational rules remain draft under `../decisions.md`.

| FR | Active implementation evidence | Acceptance dependency | Engineering status |
|---|---|---|---|
| FR-C1-01 | Swift `MathematicsCatalogView`; v2 `catalog` endpoint | Live iOS UX check | Untested |
| FR-C1-02 | Swift subject/topic navigation; v2 subject/topic hierarchy | Live iOS UX check | Untested |
| FR-C1-03 | Catalog capability/availability metadata; Swift `CatalogStore` checks active diagnosis | Availability UX check | Untested |
| FR-C1-04 | Swift `TopicOverviewView` selects SPL; v2 selected topic in journey | End-to-end scenario | Untested |
| FR-C1-05 | Backend accepts only supported `spl`; Swift hides unsupported entry | Unsupported-topic scenario | Untested |
| FR-C2-01 | V2 curated `distribution → spl` relation; Swift map diagram | Mathematical relation review | Untested |
| FR-C2-02 | Swift Explore map uses catalog relation without personal status | Pre-diagnosis UX check | Untested |
| FR-C2-03 | Backend `map.focus` derives from Confirmed only; Swift distinguishes other results | OI-03 for all-correct | Blocked by pending decision |
| FR-C2-04 | Backend `map.progress` derives from C5 result; Swift displays concept state | OI-02; OPS-03/04 | Blocked by pending decision |
| FR-C2-05 | Unsupported/unassessed concepts receive no personal state in v2 | Scenario verification | Untested |
| FR-C3-01 | Supported journey is SPL context, Distributive Property concept only | OPS-04 | Blocked by pending decision |
| FR-C3-02 | Backend Q1 MCQ, Q2 expression, Q3 explanation | OPS-04 mathematical item review | Blocked by pending decision |
| FR-C3-03 | Swift input by format; backend raw attempts with role and question ID | Data/privacy review | Untested |
| FR-C3-04 | Backend bounded math parser, Q3 rubric and optional bounded AI advice | OI-01; OPS-04 rubric review | Blocked by pending decision |
| FR-C3-05 | Backend cross-question rule considers correct, known-error and insufficient evidence | OI-01 reviewed cases | Blocked by pending decision |
| FR-C3-06 | Backend conditional single Q4 procedural trace, never repeats | OI-01; OPS-04 probe review | Blocked by pending decision |
| FR-C3-07 | Draft Confirmed/Rejected/Uncertain rule; all-correct held | OI-01; OI-03 | Blocked by pending decision |
| FR-C3-08 | Q3 AI advice limited to a quoted, guarded item interpretation; backend retains result authority | OI-01 final methodology review | Blocked by pending decision |
| FR-C3-09 | Swift/backend result and scope messages; all-correct pending state | OI-03; user comprehension check | Blocked by pending decision |
| FR-C3-10 | Confirmed Recovery and non-confirmed Optional Review routes | OI-02/03 for unresolved branches | Blocked by pending decision |
| FR-C4-01 | One v2 curated Distributive Property package | OPS-04 content review | Blocked by pending decision |
| FR-C4-02 | Backend stores confirmed-recovery or optional-review origin | OI-02 downstream policy | Blocked by pending decision |
| FR-C4-03 | Swift repeated-group visual uses v2 visual model | Math and accessibility review | Untested |
| FR-C4-04 | V2 worked steps/reasons rendered in Swift | OPS-04 math review | Blocked by pending decision |
| FR-C4-05 | V2 partial practice requires a mathematical response; Swift input | OPS-01 feedback review | Blocked by pending decision |
| FR-C4-06 | Backend enforces Visual → Worked → Practice | End-to-end scenario | Untested |
| FR-C4-07 | Backend tracks completion after draft valid practice rule | OPS-01/02; OI-02 | Blocked by pending decision |
| FR-C4-08 | Completion alone never writes a C5 learner state | Scenario verification | Untested |
| FR-C5-01 | Completed confirmed recovery enters retry; Optional Review cannot | OI-02 final policy; OPS-02 | Blocked by pending decision |
| FR-C5-02 | Unscaffolded retry item rendered from backend | OPS-04 item review | Blocked by pending decision |
| FR-C5-03 | Backend opens distinct contextual transfer only after retry pass | OPS-04 transfer review | Blocked by pending decision |
| FR-C5-04 | Bounded math equivalence parser; invalid input records no evidence | OPS-03/04 | Blocked by pending decision |
| FR-C5-05 | Backend three-state matrix after accepted item results | OPS-03/04; OI-02 | Blocked by pending decision |
| FR-C5-06 | Swift/backend messages scope each state to Distributive Property | User comprehension check | Untested |
| FR-C5-07 | Needs Reinforcement returns to existing package; no new diagnosis | End-to-end scenario | Untested |
| FR-C5-08 | V2 validation writes only supported concept state | Scenario verification | Untested |
| FR-X-01 | Journey stores topic, concept, diagnostic result and learning origin | OPS-05 transition review | Blocked by pending decision |
| FR-X-02 | Backend state machine checks origin, phase and completion before transitions | OI-02/03; OPS-05 | Blocked by pending decision |
| FR-X-03 | Swift result/map read one v2 journey; backend map is a projection | OI-02/03; OPS-05 | Blocked by pending decision |

Verification available in repository: backend unit/API/database tests, Swift Package tests and Xcode build. The current public v2 deployment was checked for catalog, guest authentication, initial progress and SPL topic selection using a temporary guest that was deleted. Newly edited local backend code needs deployment before the public endpoint includes it. SC4 user comprehension and learning-effectiveness claims require separate research and cannot be established by these tests.

## Content and evidence guard verification — 22 October 2026

See [SPL content review](SPL-CONTENT-REVIEW.md) for the item references, reproduced Q3 issues, proposed item revision and outstanding review decisions.

- Executed full backend suite: **63 passed, 0 failed** on Windows Node.js 24.18.1; backend TypeScript check **PASS**. The suite includes embedded PostgreSQL checks, not a live Supabase migration or deployment.
- Added independent mathematical checks for FR-C3-02/04, FR-C4-03/04 and FR-C5-02/04/05, public-answer-key omission checks, and invalid validation-input integrity checks.
- Added a conservative FR-C3-04/05/08 guard and regression fixtures: explicit uncertainty and conflicting constant/expansion claims remain insufficient in local interpretation, provider interpretation and the AI-advice handoff. Final synthesis rules and OI-01 status are unchanged; this is not a complete reviewed language rubric.
- Clarified the repeated-group explanation. Copy ID `learn.visual.groups.explanation`: CONDITIONAL, editorial REVIEW_NEEDED; OPS-04 remains pending.
- Fixed stale test assumptions about SPL catalog position and Windows caption line endings. No product behavior was changed by those test fixes.
- Proposed UX-031: **FAIL** on static review of Q3 disclosing Q2's answer. Proposed UX-057: executed unreadable-input fixtures **PASS**, full response-policy acceptance **BLOCKED BY DECISION** (OPS-03).
- iOS build, simulator/device UX, VoiceOver, comprehension studies, production build and deployment: **NOT RUN**. All FR-level acceptance statuses in the table remain unchanged; passing a fixture is not acceptance of an entire FR.

## Follow-up quality verification — 22 October 2026

Supersedes the prior 63-test run and production-build NOT RUN status for this engineering revision:

- Full backend suite: **65 passed, 0 failed**. TypeScript check: **PASS**. Production build: **PASS** (Windows Node.js 24.18.1).
- Strengthened mathematical fixtures to check the displayed input expressions, completed blanks and SPL options against independent references, rather than only checking answer-key constants.
- Added Q3 guard false-positive fixtures and authenticated API save/resume checks covering insufficient observation persistence, no private judgments in learner responses, unchanged map state and no provider request for guarded input (FR-C3-04/08; FR-X-01/03).
- Built-server smoke checks: health, ten-module catalog, SPL-only active entry, missing-token rejection, browser-origin rejection and allowed preflight **PASS**. The temporary local server was stopped.
- No new user-facing copy or final product policy was introduced in this follow-up. No live authenticated Supabase journey, deployment, iOS build/runtime, accessibility or learner-comprehension study was executed. FR-level acceptance statuses and OI/OPS statuses remain unchanged. See [review details](SPL-CONTENT-REVIEW.md).

## Approved Q2/Q3 revision verification — 22 October 2026

- Scoped approval: [DEC-2026-10-22-Q2Q3](../decisions.md#dec-2026-10-22-q2q3--separate-diagnostic-expressions-and-remove-answer-disclosure). Q2 is `4(x+3)`; Q3 asks for reasoning about `5(x+2)` without providing either expansion. Copy IDs: `diag.item.q2.prompt`, `diag.item.q2.math`, `diag.item.q3.prompt` — CONDITIONAL, APPROVED_FOR_DESIGN for this user-approved draft implementation.
- Updated item references, Q3 local interpretation and AI context, API examples, catalog content version and Swift decoding fixtures. Version is `spl-distribution-draft-3`; IDs are unchanged. This serves FR-C3-02/04/05/08 and FR-X-01..03.
- Full backend suite **66 passed, 0 failed**; production build including TypeScript **PASS**. Explicit draft-2 reset, unsupported inputs, non-confirmed/uncertain paths, single-Q4 limit, validation gates and map/evidence consistency are covered by executed fixtures.
- Proposed UX-030/031 static item checks: **PASS** for core input roles and removal of answer disclosure; learner comprehension and live iOS checks **NOT RUN**. Comprehensive item/rubric acceptance is still **BLOCKED BY DECISION** (OPS-04/OI-01); all FR-level table statuses remain unchanged.
- No deployment or live database migration performed. Swift fixture updates were not executed on Xcode/Swift in this environment.

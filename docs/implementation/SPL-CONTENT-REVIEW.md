# SPL recovery content review — 22 October 2026

> **Current implementation:** recovery modules and equivalent fixtures moved into `backend/src/` and `backend/tests/` during the [23 October rebuild](BACKEND-REBUILD.md). Older paths and test totals below describe the prior revision. Current suite: 50 passing tests; no deployment or final OI/OPS acceptance.

**Status: engineering review and proposed changes; not product or mathematics approval.**

**Current item revision:** the user subsequently approved the Q2/Q3 replacement in this conversation. It is implemented as `spl-distribution-draft-3`; see [DEC-2026-10-22-Q2Q3](../decisions.md#dec-2026-10-22-q2q3--separate-diagnostic-expressions-and-remove-answer-disclosure). This is scoped implementation approval, not full mathematics/rubric acceptance. Earlier findings and test runs below describe the reviewed draft-2 bank; the latest verification is recorded at the end.
Scope: the active `backend/lib/v2/` bank and SwiftUI v2 journey. Source: approved PRD requirements FR-C3-02/04/05/08, FR-C4-01/03/04/05 and FR-C5-02/03/04/05; original PDF pp. 66–74 and 76–77. See [requirements](../prd/requirements.md), [MVP definition](../prd/mvp-definition.md), and [open decisions](../decisions.md). The legacy curriculum bank is outside this review.

## Mathematical reference inventory

These are independently checked algebraic results for existing draft content, not approved assessment criteria.

| Asset | Reference and review finding |
|---|---|
| Q1, `spl-q1` | `3(x+2)+y=15` expands to `3x+6+y=15`: A. With `x+y=5`, the system has `x=2,y=3`. B omits multiplication of the constant; C is incorrect but does not independently establish a specific misconception. |
| Q2, `distribution-q2` | `3(x+2)=3x+6`; `3x+2` is unequal. It repeats Q1's exact expression. |
| Q3, `distribution-q3` | The supplied identity `3(x+2)=3x+6` is correct. Its appearance after Q2 reveals Q2's correct expansion; the prompt does not supply independent evidence of that expansion. |
| Q4, `distribution-q4` | `2(x+4)=2x+8`; blank is 8, not 4. This trace is not independent proof of conceptual explanation. |
| Visual | Three groups of `x+2` give `3x+6`. Clarified prose to explicitly say `x+x+x=3x` and `2+2+2=6`; the earlier “tiga pasang 2” was unclear. Group data and results are unchanged. |
| Worked example | `2×x=2x`, `2×4=8`, hence `2(x+4)=2x+8`; all displayed steps are valid. |
| Partial practice | `5(x+2)=5x+10`; blank is 10. Correct arithmetic does not approve completion/feedback rules. |
| Independent retry | `4(x+5)=4x+20`. A different example from the worked task, with no instructional steps in the question. |
| Transfer | Three boxes each containing `x+4` pencils give `3x+12` pencils. This is a contextual representation change, not only changed numbers. Pedagogical review must still assess whether it provides sufficiently meaningful transfer evidence. |

## Findings requiring review

### R1 — Repeated diagnostic content and answer disclosure

**Dependencies:** OPS-04 and OI-01; FR-C3-02/04/05. Proposed UX-writing scenario UX-031 also concerns hints during diagnostic evidence collection.

Q1 and Q2 use the same `3(x+2)` expansion, and Q3 supplies its correct result. Three response records must not automatically be described as three independent demonstrations. Existing tests check control flow, not diagnostic validity.

**Recommended draft revision for review:** retain Q1, replace Q2 with `4(x+3)` (reference `4x+12`, omitted-constant-multiplier pattern `4x+3`), and ask Q3: “Pada bentuk 5(x + 2), jelaskan bagaimana angka 5 digunakan pada suku-suku di dalam kurung dan mengapa.” Its reference is `5x+10`, with multiplication of both terms explained. This candidate copy is **CONDITIONAL / REVIEW_NEEDED**, not a release-approved item or runtime replacement.

Alternative: keep the repeated expressions but explicitly model dependent evidence. This retains more answer-disclosure risk and requires a reviewed synthesis rule. Neither option closes OI-01.

Before implementation: approve item text, distractors/error patterns, explanation rubric, correlated-evidence handling and content version/resume behavior. A revised bank must update AI context, fixtures and saved-session version checks together; do not silently reinterpret old attempts.

### R2 — Q3 keyword rubric can overstate evidence

**Dependencies:** OI-01 and OPS-04; FR-C3-04/05/08.

Reproduced against `explanationObservation` before the guard fix:

| Response | Observation before fix | Review concern |
|---|---|---|
| `Saya tidak tahu apakah hanya x yang dikalikan 3.` | `known-error` | An explicit uncertainty question is read as an asserted misconception. |
| `Bukan hanya x yang dikalikan 3, tetapi angka 2 tetap. Hasilnya 3x+6 untuk setiap suku.` | `correct` | Internally conflicting reasoning is accepted as correct because of keyword matches. |

These are item interpretations, not direct diagnostic outcomes; other responses and synthesis affect the eventual result. A literal quote from an AI response also does not independently verify mathematical reasoning.

**Recommended proposal:** ambiguous, quoted, negated or internally conflicting claims remain insufficient until a reviewed rubric resolves them. System guardrails should apply to both local interpretation and AI advice; an AI fallback must not bypass an uncertainty guard. Alternative: structured rubric review with human-labelled fixtures before extending free-text interpretation. Test uncertainty, self-correction, negation, arithmetic slips, contradictions and provider failure. Final allocation of authority remains OI-01 Open.

Implemented a conservative engineering guard for these reproduced cases: explicit uncertainty and the combination of a claimed correct expansion with an unchanged constant produce `insufficient`. Both provider interpretation and the journey's AI-advice handoff enforce the guard. A regression test checks all three paths and confirms no diagnostic outcome or learner state is created by the guarded Q3 response. Existing final diagnostic synthesis rules are unchanged. This limited lexical guard is not a complete natural-language rubric; it may defer valid self-corrections containing uncertainty language. General negation, quotation and self-correction handling still require reviewed fixtures. Existing persisted attempts are not reinterpreted or migrated.

### R3 — Evaluation support is narrower than full mathematical equivalence

**Dependencies:** OPS-03/04; FR-C5-04/05.

The bounded evaluator supports linear `ax+b`, including reordered sums, fractions and decimal comma. Expression submissions containing parentheses are rejected by the journey even if mathematically equivalent, under the existing draft expanded-form rule. Unsupported nonlinear or unreadable responses return no evaluation rather than automatically assigning a failed learner state.

**Recommended review:** distinguish a request to enter expanded form from incorrect mathematics; define accepted response forms and user recovery before changing the evaluator. Do not describe the parser as general symbolic verification. Alternative: add a replaceable symbolic evaluator after the accepted-form contract is reviewed.

### R4 — Completion, validation eligibility and persistence remain draft contracts

**Dependencies:** OPS-01/02/05, OI-02/03.

The implementation currently requires a correct practice response to advance; optional review does not open validation; all-correct diagnosis is held pending. These are existing interim directions, not final approved specifications.

Review completion after incorrect practice, feedback/retry rules, optional-review eligibility, all-correct continuation and save/resume transitions before final acceptance. Tests passing for current interim behavior do not resolve these decisions.

## Changes and verification

- Clarified visual copy, linked to `learn.visual.groups.explanation` in the copy bank: CONDITIONAL, editorial REVIEW_NEEDED; OPS-04 remains pending. No item key, question ID, state transition or bank version changed.
- Added `backend/tests/v2-content.test.ts`: independent answer references; visual/step consistency; reordered, fractional and decimal equivalents; incorrect versus unreadable input; omission of private answer keys; invalid retry/transfer submissions preserve the journey without a learner state.
- Targeted content, engine and reasoning checks: **22 passed, 0 failed** on Windows Node.js 24.18.1. The Q3 findings above were separately reproduced; they are not passing rubric acceptance tests.
- Added Q3 guard regression coverage in `backend/tests/v2-reasoning.test.ts`. Corrected two existing test assumptions uncovered by the full run: find SPL by stable ID rather than first catalog position, and accept either LF or CRLF WebVTT headers.
- Follow-up quality review strengthened the mathematical fixtures to verify the actual displayed expressions, completed blanks and SPL distractors against independent references. Added clear-correct and explicit-misconception fixtures to check guard false positives, and authenticated API save/resume checks for guarded Q3 evidence, private observation fields and absence of provider calls.
- Latest full backend suite: **65 passed, 0 failed** on Windows Node.js 24.18.1, using `node --experimental-strip-types --test 'tests/*.test.ts'`. Backend typecheck: **PASS**, using `node node_modules/typescript/bin/tsc --noEmit --incremental false`. Production build: **PASS**, using `node node_modules/next/dist/bin/next build`. These are executed engineering checks, not final product acceptance.
- Built-server smoke checks: **PASS** for health, ten-module catalog, SPL-only active entry, unauthenticated progress rejection (401), disallowed browser origin (403) and allowed preflight (204). Server ran briefly on an isolated local port and was stopped. No authenticated live account or provider request was made. The build emitted an informational warning about ignoring an ancestor lockfile outside the repository; compilation, typechecking and route generation succeeded.
- Proposed UX-writing checks: UX-031 **FAIL** on static review of the current Q3 prompt's disclosure of Q2's answer; UX-057 **PASS** only for the executed unreadable retry/transfer fixtures, with the full accepted-form policy **BLOCKED BY DECISION** (OPS-03). Learner comprehension, VoiceOver, simulator, device, visual and motion checks: **NOT RUN**.
- No live provider call, database migration or deployment was performed. No approved FR is marked fully Passed on the strength of this review.

## Next decision

The R1 Q2/Q3 replacement has now been approved by the user and implemented. Product/pedagogy/engineering review is still needed for a comprehensive R2 ambiguity rubric with labelled fixtures and full OPS-04 bank acceptance. OPS-04, OI-01 and all other existing OI/OPS statuses remain unchanged.

## Latest verification — approved draft-3 items

- Q1 remains the SPL MCQ. Q2 is `4(x+3)`, reference `4x+12`, known-error pattern `4x+3`. Q3 asks how 5 applies to the terms in `5(x+2)` and why, without supplying `4x+12` or `5x+10`. The reference expansion is `5x+10`; local numerical patterns, AI interpretation context and fixtures were synchronized.
- Content version, catalog, API examples and Swift decoding fixtures use `spl-distribution-draft-3`. Existing draft-2 sessions follow the explicit reset-required path and are not regraded. IDs and formats are unchanged.
- Executed full backend suite: **66 passed, 0 failed**. Production build including TypeScript: **PASS**. New regression checks cover absent answer disclosure, correct mathematical references, synchronized AI context and old-version reset; existing uncertain, non-confirmed, Q4 and C5 guard checks pass.
- Proposed UX-030/031 static item checks: **PASS** for revised item roles and absence of supplied expansions. The earlier draft-2 disclosure finding is addressed by the new prompts. Learner comprehension, iOS runtime, accessibility and Swift tests: **NOT RUN**. No deployment or migration was performed.
- Copy IDs: `diag.item.q2.prompt`, `diag.item.q2.math`, `diag.item.q3.prompt`, each CONDITIONAL / APPROVED_FOR_DESIGN for this user-approved draft implementation. No final release or bank/rubric acceptance is claimed.

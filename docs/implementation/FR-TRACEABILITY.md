# MVP functional requirement implementation trace

Source: PRD v2 Product Requirements and Detailed Requirements tabs (43 approved functional requirements), reconciled 23 October 2026. This table records the **active SwiftUI → backend v2 path**, not the older local prototype or website v1 API. Engineering status means product acceptance, not code presence or unit-test success. The current code does not yet implement the complete Q1–Q10, multi-concept, final-assessment v2 target.

**Migration note:** Existing FR-C1..FR-C5 rows below are legacy v1 traceability and remain useful implementation evidence. They are not a complete 43-FR v2 traceability matrix. New v2 requirements require a reviewed ID mapping before acceptance claims.

## Complete PRD v2 traceability matrix

Source: Detailed child tab, selected from Product Requirements in Google Docs and exported 23 October 2026. Status describes repository evidence, not approval.

| FR ID | Requirement title | PRD v2 reference | Target behavior | Relevant documentation | Relevant source code | Status | Verification evidence | Remaining gap/dependency |
|---|---|---|---|---|---|---|---|---|
| FR-C1-01 | Mathematics Catalog Access | Detailed §5.2 | Catalog-first access to represented mathematics subjects | `docs/prd/mvp-definition.md`, `backend/docs/API-V2.md` | `frontend/Rethink/Views/Catalog/MathematicsCatalogView.swift`, `backend/app/api/v2/catalog/route.ts` | Partial | Catalog endpoint/tests exist | Full v2 UX verification |
| FR-C1-02 | Subject & Topic Discovery | Detailed §5.2 | Organize represented content by subject/topic | `docs/prd/mvp-definition.md` | `frontend/Rethink/Views/Catalog/SubjectOverviewView.swift`, `TopicOverviewView.swift`, `backend/lib/v2/catalog.ts` | Partial | Catalog fixtures/tests | Full navigation audit |
| FR-C1-03 | Supported Content Availability | Detailed §5.2 | Distinguish active support from represented/unavailable content | `docs/prd/mvp-definition.md`, `backend/docs/API-V2.md` | `frontend/Rethink/ViewModels/Remote/CatalogStore.swift`, `backend/lib/v2/catalog.ts` | Partial | Unsupported-topic checks | Complete multi-capability availability UX |
| FR-C1-04 | Supported Topic Selection | Detailed §5.2 | Select SPL and preserve topic context | `docs/prd/mvp-definition.md` | `frontend/Rethink/Views/Catalog/TopicOverviewView.swift`, `backend/lib/v2/engine.ts` | Implemented | v2 API/engine tests | Live iOS verification |
| FR-C1-05 | Diagnostic Entry Eligibility | Detailed §5.2 | Start diagnosis only for actively supported topics | `docs/prd/mvp-definition.md`, `backend/docs/API-V2.md` | `backend/lib/v2/catalog.ts`, `backend/app/api/v2/progress/route.ts` | Implemented | Unsupported entry and forged-topic tests | Deployment verification |
| FR-C2-01 | Curated Concept Relationship Representation | Detailed §5.3 | Represent curated topic/concept relationships | `docs/prd/mvp-definition.md`, `docs/technical/architecture.md` | `frontend/Rethink/Services/Map/CuratedConceptMap.swift`, `backend/lib/v2/catalog.ts` | Partial | Catalog/map fixtures | v2 multi-concept relationship coverage |
| FR-C2-02 | Explore Context | Detailed §5.3 | Show conceptual orientation before personal evidence | `docs/prd/mvp-definition.md` | `frontend/Rethink/Views/Map/LearningMapView.swift` | Partial | Existing Explore projection | Live UX/accessibility verification |
| FR-C2-03 | Diagnostic Focus Representation | Detailed §5.3 | Project applicable diagnostic focus; distinguish non-confirmed outcomes | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Views/Map/LearningMapView.swift` | Partial | Map projection tests | v2 per-concept outcomes and all-correct policy |
| FR-C2-04 | Validation-Based Progress Representation | Detailed §5.3 | Project C5 blocker-level outcomes only after valid validation | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Views/Map/LearningMapView.swift` | Partial | Learner-state/map tests | Final-assessment separation and eligibility policy |
| FR-C2-05 | Assessment Coverage & State Integrity | Detailed §5.3 | Do not assign states without applicable evidence | `docs/prd/mvp-definition.md`, `docs/decisions.md` | `backend/lib/v2/progress.ts`, `backend/lib/v2/engine.ts` | Partial | Invalid state guards | Multi-concept coverage model absent |
| FR-C3-01 | Supported Diagnostic Context | Detailed §5.4 | Ten-question SPL assessment with per-concept synthesis; only supported recovery package complete | `docs/prd/mvp-definition.md`, `docs/technical/architecture.md` | `backend/lib/v2/engine.ts`, `backend/lib/v2/content.ts` | Partial | Existing SPL journey tests | Q1–Q10 multi-concept flow missing |
| FR-C3-02 | Ten-Question Primary Diagnostic Blueprint | Detailed §5.4 | Administer reviewed Q1–Q10 with roles, formats, tags, evidence and attribution rules | `docs/prd/mvp-definition.md` | `backend/lib/v2/content.ts`, `frontend/Rethink/Services/Diagnosis/DiagnosticContent.swift` | Missing | Existing content only covers Q1–Q3/Q4 | Approved Q1–Q10 bank/coverage matrix |
| FR-C3-03 | Student Response Collection | Detailed §5.4 | Preserve responses with question role and mathematical context | `docs/technical/architecture.md`, `backend/docs/API-V2.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/ViewModels/Diagnosis/DiagnosisViewModel.swift` | Partial | Attempt persistence/API tests | v2 ten-item response schema |
| FR-C3-04 | Mathematical Evidence Evaluation | Detailed §5.4 | Evaluate outcome, transformation and explanation evidence | `docs/implementation/SPL-CONTENT-REVIEW.md` | `backend/lib/math.ts`, `backend/lib/v2/reasoning.ts`, `frontend/Rethink/Services/Diagnosis/CuratedChoiceValidator.swift` | Partial | Math/reference and guard tests | Complete reviewed rubrics and concept evaluators |
| FR-C3-05 | Cross-Question Evidence Synthesis | Detailed §5.4 | Synthesize supporting, contradictory and insufficient evidence per concept | `docs/prd/mvp-definition.md`, `docs/technical/architecture.md` | `backend/lib/v2/engine.ts`, `backend/lib/v2/reasoning.ts` | Missing | Existing rule handles single concept | Per-concept synthesis engine |
| FR-C3-06 | Bounded AI Conversational Follow-up | Detailed §5.4 | Use separate-ID, purposeful, non-leading probes with termination rule | `docs/prd/mvp-definition.md` | `backend/lib/v2/content.ts`, `backend/lib/v2/engine.ts` | Partial | Existing single-probe tests | v2 probe budget/termination and follow-up contract |
| FR-C3-07 | Evidence-Grounded Diagnostic Outcome | Detailed §5.4 | Emit per-concept status and recommendation priority, not probabilities | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts` | Missing | Existing Confirmed/Rejected/Uncertain tests | Canonical v2 statuses and recommendation fields |
| FR-C3-08 | Bounded AI-Assisted Interpretation | Detailed §5.4 | Constrain AI to evidence, concept and safeguards | `docs/implementation/SPL-CONTENT-REVIEW.md` | `backend/lib/v2/reasoning.ts`, `backend/lib/ai.ts` | Partial | Guard/failure fixtures | v2 multi-concept interpretation contract |
| FR-C3-09 | Diagnostic Result Communication | Detailed §5.4 | Communicate per-concept outcome, scope and limitations | `docs/prd/mvp-definition.md`, `docs/design/UX-WRITING.md` | `frontend/Rethink/Views/Diagnosis/DiagnosticFlowView.swift`, `frontend/Rethink/Views/Remote/JourneyFlowView.swift` | Partial | Existing result presentation | v2 statuses and coverage/priorities |
| FR-C3-10 | Outcome-Based Continuation | Detailed §5.4 | Provide supported next paths without converting non-confirmed evidence | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Views/Diagnosis/DiagnosticFlowView.swift` | Partial | Existing recovery/review branches | Open learning and final assessment route |
| FR-C4-01 | Supported Learning Package | Detailed §5.5 | Provide curated Distributive Property package | `docs/prd/mvp-definition.md`, `docs/implementation/SPL-CONTENT-REVIEW.md` | `backend/lib/v2/content.ts`, `frontend/Rethink/Services/Learning/InterventionContent.swift` | Partial | Content/engine tests | Final content approval |
| FR-C4-02 | Recovery Entry Context | Detailed §5.5 | Preserve confirmed-recovery vs optional-review origin | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Models/Learning/LearningSession.swift` | Implemented | Origin transition/state tests | OI-02 post-review policy |
| FR-C4-03 | Visual Explanation | Detailed §5.5 | Explain Distributive Property concept with curated representation | `docs/prd/mvp-definition.md` | `backend/lib/v2/content.ts`, `frontend/Rethink/Views/Learning/VisualExplanationView.swift` | Partial | Visual/content fixtures | Math/accessibility review |
| FR-C4-04 | Worked Example | Detailed §5.5 | Show valid transformations with meaningful reasoning | `docs/prd/mvp-definition.md` | `backend/lib/v2/content.ts`, `frontend/Rethink/Views/Learning/WorkedExampleView.swift` | Partial | Content/math checks | Final item/content review |
| FR-C4-05 | Active Partial Guided Practice | Detailed §5.5 | Require active student mathematical input | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Views/Learning/GuidedPracticeView.swift` | Partial | Practice input tests | OPS feedback/completion rules |
| FR-C4-06 | Fixed Learning Sequence | Detailed §5.5 | Visual Explanation → Worked Example → Partial Guided Practice | `docs/technical/architecture.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Views/Learning/LearningFlowView.swift` | Implemented | Journey phase tests | Live UX verification |
| FR-C4-07 | Learning Completion & Applicable Handoff | Detailed §5.5 | Record completion and hand off only when applicable | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `backend/lib/v2/progress.ts` | Partial | Completion transition tests | Approved completion/eligibility contract |
| FR-C4-08 | Learning Outcome Claim Boundary | Detailed §5.5 | Lesson completion never equals conceptual understanding | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `backend/lib/v2/progress.ts` | Implemented | State-integrity tests | Full v2 journey verification |
| FR-C4-09 | Contextual Socratic Learning Assistance | Detailed §5.5 | Concept/stage-bounded progressive hints; no final answer; safe fallback | `docs/prd/mvp-definition.md`, `docs/design/UX-WRITING.md` | `backend/lib/chat.ts`, `backend/app/api/chat/route.ts`, `frontend/Rethink/Services/AI/AIServiceInterfaces.swift` | Partial | Existing chat/API tests | Context grounding and independent-item safeguards |
| FR-C5-01 | Validation Context & Eligibility | Detailed §5.6 | Enable concept validation after confirmed recovery completion | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Views/Learning/ValidationIntroView.swift` | Partial | Retry gate tests | Final eligibility and post-review decision |
| FR-C5-02 | Independent Retry | Detailed §5.6 | Curated scaffold-free retry with same structure, new item | `docs/prd/mvp-definition.md` | `backend/lib/v2/content.ts`, `frontend/Rethink/Views/Learning/IndependentRetryView.swift` | Partial | Retry math tests | Approved v2 item bank |
| FR-C5-03 | Conditional Transfer Problem | Detailed §5.6 | Transfer only after retry pass, different representation/context | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Views/Learning/TransferProblemView.swift` | Partial | Transfer gate tests | Approved transfer item/meaningful-difference rubric |
| FR-C5-04 | Validation Response Evaluation | Detailed §5.6 | Evaluate retry/transfer responses against curated criteria | `docs/prd/mvp-definition.md` | `backend/lib/math.ts`, `backend/lib/v2/engine.ts`, `frontend/Rethink/Services/Learning/LocalLearningValidator.swift` | Partial | Invalid/equivalence fixtures | OPS-03 handling and v2 rubrics |
| FR-C5-05 | Evidence-Based Learner State Assignment | Detailed §5.6 | Map valid retry/transfer results to three concept states | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Services/Learning/LearningValidationPolicy.swift` | Implemented | State matrix tests | Complete accepted-form policy |
| FR-C5-06 | Learning Outcome Communication | Detailed §5.6 | Communicate state scoped to Distributive Property | `docs/prd/mvp-definition.md` | `frontend/Rethink/Views/Learning/LearningResultView.swift`, `frontend/Rethink/Views/Remote/JourneyFlowView.swift` | Partial | Model/UI fixtures | Live comprehension/accessibility verification |
| FR-C5-07 | Outcome-Based Continuation | Detailed §5.6 | Needs Reinforcement returns to existing package | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Views/Learning/LearningFlowView.swift` | Implemented | Reinforcement tests | End-to-end live verification |
| FR-C5-08 | Validation Scope & Evidence Integrity | Detailed §5.6 | Do not turn validation failure into new diagnosis or broad mastery | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `backend/lib/v2/progress.ts` | Implemented | State/transition guard tests | Final-assessment separation not complete |
| FR-C5-09 | Topic-Level SPL Final Assessment | Detailed §5.6 | Separate exactly-five-question assessment, available after diagnosis without all blockers | `docs/prd/mvp-definition.md` | No matching v2 final-assessment implementation found; legacy `backend/app/api/assessment/route.ts` is separate | Missing | No v2 implementation/test evidence | Build assessment flow and persistence |
| FR-C5-10 | Final Assessment Passing and Retry | Detailed §5.6 | 3–5 Passed; 0–2 Not Passed; retry preserves attempt history and does not rewrite concept states | `docs/prd/mvp-definition.md` | No matching v2 implementation found | Missing | No v2 test evidence | Scoring, retry, history and API contract |
| FR-C5-11 | Separate Learner States | Detailed §5.6 | Separate lesson completion, concept state, final-assessment completion and topic result | `docs/prd/mvp-definition.md`, `docs/technical/architecture.md` | Existing `backend/lib/v2/engine.ts` has concept state only; no final-assessment state | Partial | Existing concept-state guards | Add distinct topic-assessment state |
| FR-X-01 | Supported Context Continuity | Detailed §5.7 | Preserve topic, concept and learning origin across C3–C5 | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `backend/lib/v2/progress.ts` | Implemented | Journey persistence tests | v2 multi-concept fields |
| FR-X-02 | Outcome-Gated Learning Transitions | Detailed §5.7 | Gate transitions by outcome, origin and completion | `docs/technical/architecture.md` | `backend/lib/v2/engine.ts`, `backend/lib/v2/progress.ts` | Partial | Transition guard tests | Open-learning/final-assessment routes |
| FR-X-03 | Contextual Map & Result Consistency | Detailed §5.7 | Keep topic, diagnostic results and learner states consistent in map/results | `docs/prd/mvp-definition.md` | `backend/lib/v2/engine.ts`, `frontend/Rethink/Views/Map/LearningMapView.swift` | Partial | Projection tests | Per-concept v2 map and final-assessment separation |

**Matrix count:** C1 5 + C2 5 + C3 10 + C4 9 + C5 11 + Cross-capability 3 = **43 requirements**. `FR-C5-09`–`FR-C5-11` appear in the Detailed tab's final C5 extension and are included here.

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

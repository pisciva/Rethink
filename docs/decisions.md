# Rethink — Product Decisions, Open Issues, Operational Specifications & Change Control

> **PRD v2 migration (23 October 2026):** the user explicitly requested the newest PRD and missing features. PRD v2 replaces the single-blocker Q1–Q3 diagnostic scope with ten primary questions and per-concept evidence; it adds contextual Socratic assistance and a separate five-item SPL final assessment. The imported DOCX is preserved unchanged. Existing user-approved rules below remain applicable where v2 does not supersede them; they do not silently approve new item assets, a multi-concept synthesis rubric or a new follow-up budget. See [implementation proposal](implementation/PRD-V2-PLAN.md).

> **Historical source status as of uploaded 133-page documentation:** Approved Overall PRD v1.0 and **39 Approved Must Have functional requirements**; **OI-01–OI-03 OPEN**; **OPS-01–OPS-05 PENDING**. This Markdown does not confer any additional approval. Relevant PDF pages: 17, 50–51, 57, 68–71, 74–84, 89–97, 102–103, 110–117, 127–133.

## Current implementation decisions — 23 October 2026

**PRD v2 bank/rule approval:** the user selected **“Use the proposed bank and rules”** for [PRD-V2-PLAN.md](implementation/PRD-V2-PLAN.md). This approves the ten-question bank, five-question SPL final assessment, conservative per-concept evidence/coverage rules, all-correct mapping, and maximum one curated distribution follow-up for this implementation. The source-controlled bank gate is now enabled locally. Prior sections recording a pending review are historical. This does not claim expert pedagogy/diagnostic accuracy, iOS runtime acceptance or production deployment; Swift's default remains the currently hosted v2 API until rollout.

**DEC-2026-10-23-MVP-COMPLETION — APPROVED FOR IMPLEMENTATION by the user in this development conversation.** Source statuses below describe the original PDF, which remains unchanged. The following later decisions supersede the earlier interim choices for this implementation; they do not establish empirical diagnostic validity, expert content acceptance or learner effectiveness.

| Ref | Current approved implementation rule | Requirements / verification impact |
|---|---|---|
| OI-01 | Current mathematical/evidence system rules retain final diagnostic authority. AI advises only on unclear Q3, with bounded quoted output and conservative insufficient-evidence fallback. | FR-C3-04..08; existing uncertainty, counterevidence, AI-output and Q4 fixtures retained. |
| OI-02 | Optional Review ends without C5 or learner-state update; origin and non-confirmed diagnosis are preserved. | FR-C2-04, FR-C3-10, FR-C4-02/07, FR-C5-01/05, FR-X-01..03; V-X-08. |
| OI-03 | All-correct Q1–Q3 → Rejected for the examined blocker, with Optional Review or catalog continuation; no SPL mastery claim. | FR-C2-03, FR-C3-07/09/10, FR-X-02/03; V-X-07. Old saved pending histories require explicit reset, never silent regrading. |
| OPS-01/02 | Existing linear package; wrong evaluable practice responses remain editable with fixed guidance; valid correct active practice after Visual/Worked completes C4. Technical attempt exhaustion offers explicit reset. | FR-C4-05..08, FR-C5-01. No achievement or C5 state from C4 alone. |
| OPS-03 | Supported equivalent expanded linear forms accepted; unreadable, empty, unsupported/nonlinear and non-expanded submissions remain ungraded, without new evidence/state. Existing input bounds retained. | FR-C5-04/05; invalid/equivalent/format fixtures. |
| OPS-04 | Retain the exact curated bank and bounded rubric listed in [the reviewed proposal](implementation/MVP-COMPLETION.md) for this implementation. | FR-C3-01..08, FR-C4-01/03..05, FR-C5-02..04. Expert pedagogy/language-rubric acceptance remains a separate outstanding review. |
| OPS-05 | Owner-scoped revision-checked Supabase snapshots; reload after uncertain saves, explicit reset of incompatible evidence, preserved identity on temporary outages; branch-aware read-only progress and stable Concept Applied recognition from persisted qualifying C5 evidence. | FR-X-01..03; no new reward write endpoint, permanent award ledger, duplicate notification or UI-created judgment. |
| GAM presentation | Implement the three documented presentation mechanisms under the selected operational rules: branch-aware progress, evidence-bound contextual feedback and a stable result-backed concept-recognition card. | Proposed GAM scenarios are engineering test inputs; no XP, streaks, competition, unapproved curriculum or mastery percentage. |

**Approval evidence:** the user explicitly selected each OI alternative, then selected “Approve these implementation rules” for OPS-01..05 and the described result-backed recognition policy. Full concrete rules and alternatives are in [MVP-COMPLETION.md](implementation/MVP-COMPLETION.md). Approved implementation direction is distinct from passing tests and final release acceptance. No archival source or approved FR wording was rewritten.

## 1. Decision classification and authority

| Status | Interpretation for Codex | Authorization |
|---|---|---|
| **Approved** | Documented baseline product requirement: implement/verify within applicable prerequisites | Product baseline, not implementation proof |
| **Open** | Final product decision explicitly unresolved | Product review (and domain expert input as needed) |
| **Pending** | Operational mechanism/asset or acceptance rule yet to be specified and reviewed | Proposed by engineering/domain teams; review before finalizing |
| **Paper-Proposed** | Previous technical candidate or rationale | Inform engineering; not a binding stack choice |
| **Research Reference** | Methodological reference, not a mechanism mandated for MVP | Engineering/methodology review |
| **Engineering Consideration** | Design freedom: allowed to propose, not automatically approved change in behavior | Engineering decision within approved PRD; escalate product-impacting choices |

All agents must separate **product approval**, **engineering implementation**, **successful testing**, and **empirical learning effectiveness**.

## 2. Open product decision register OI-01–OI-03

### OI-01 — AI Methodology Alignment — **OPEN**

**Question:** What is the final allocation of authority among LLM interpretation/cross-question synthesis, mathematical verification, orchestrator decision rules, and final Confirmed/Rejected/Uncertain policy? Source says bounded AI assistance, curated mathematical support and evidence-grounded conclusions. Paper proposed largely rule-based orchestration/deterministic validation with LLM support; later approved product direction explicitly allows AI-assisted synthesis. The conflict is **not** permission for Codex to invent final autonomy/decision rights.

**Affected:** C3, FR-C3-05/06/07/08, diagnosis D4–D6, LC-04/LC-03, T2, AI safeguards, D2 decision integrity, potentially SC2 and scenario V-X-01.

**Product invariants regardless of decision:** only Distributive Property blocker; Q1–Q3 plus maximum one Q4; preserve raw mathematical observations and alternative explanations; avoid unsupported confirmation; Uncertain valid; no arbitrary numerical “confidence” as calibrated probability; no hidden LLM-generated diagnoses outside supported knowledge.

**Engineering proposal to prepare (not a final decision):** identify deterministic mathematical evaluator boundaries; proposed evidence types and aggregation; explain LLM task and model-output validation; formalize cases supporting/contradicting/no evidence; specify failure/uncertain fallback, reference cases and human mathematical review, plus latency/cost/reliability trade-offs. A deterministic-only policy, LLM-led bounded policy and hybrid policy can be evaluated, but not represented as approved without review.

**Resolution authority:** Product + AI/Math review as source readiness says. **Blocker:** final algorithmic/operational confirmation and relevant acceptance criteria.

### OI-02 — Optional Review Learner-State Behavior — **OPEN**

**Question:** After Rejected or Uncertain diagnosis, Optional Concept Review uses the supported Distributive Property package. May a learner enter C5 validation after such a review? If so, can C5 assign a blocker-level state, and how is the absence of confirmed blocker represented and preserved? Source **does not decide** this.

**Affected:** FR-C2-04, FR-C3-10, FR-C4-02/07, FR-C5-01/05, FR-X-02/03, T3/T5, V-X-08, OPS-05, map state integrity and post-review UX.

**Fixed regardless of decision:** Optional Review never retroactively changes C3 result to Confirmed; review completion does not equal understood; use of the shared curated learning package is permitted; confirmed-recovery completion already qualifies for C5.

**Proposal alternatives (nonbinding):** (A) Review ends in information/return to topic with no C5; (B) optional validation allowed, evidence captured distinctly from confirmed recovery; (C) explicitly gated alternative with qualified map representation. Product review must address UX fairness, learner-state semantics and test scenarios.

**Resolution authority:** Product review. **Blocker:** post-review C5 eligibility, status updates, outcome-specific communication and V-X-08 test expectations.

### OI-03 — All-Correct Diagnostic Outcome Mapping — **OPEN**

**Question:** When Q1–Q3 responses are all correct (and possibly when Q4 would not be useful), what C3 outcome, message, map Focus state and continuation apply? Source rejects automatic inference of SPL mastery and leaves formal mapping undecided.

**Affected:** FR-C2-03, FR-C3-07/09/10, FR-X-02/03, D6–D7, V-X-07, C3 routing/map and SC3.

**Fixed regardless of decision:** all-correct ≠ general topic mastery; diagnosis evaluates only supported Distributive Property; avoid unsupported confirmed blocker. Do not prematurely hardcode all-correct as Rejected, Understood or Confirmed without evidence-based approved rule.

**Proposal for product review:** compare mapping to Rejected vs explicit non-blocker-detected path vs other supported constrained option, including desired feedback and available review/topic-selection actions; establish specific case fixtures.

**Resolution authority:** Product review. **Blocker:** V-X-07 and final related routing/acceptance criteria.

## 3. Pending operational specification register OPS-01–OPS-05

| ID | Source status | Exact unresolved contract | Affected | Required reviewed output |
|---|---|---|---|---|
| **OPS-01** Guided Practice Feedback Mechanics | **PENDING** | How submitted step/reasoning is checked, feedback presented, correction/retry processed | FR-C4-05/07, LC-03/05, L5–L6 | Response rules, wrong-answer treatment, test cases |
| **OPS-02** Guided Learning Completion Criteria | **PENDING** | How participation and stage progression establish completion; what incomplete/incorrect practice means | FR-C4-07, FR-C5-01, L6–L7, V1 | Testable completion and handoff rules |
| **OPS-03** Validation Response Handling | **PENDING** | Valid/incorrect/blank/incomplete/uninterpretable/equivalent response handling | FR-C5-04/05, V3/V5/V6 | Math parsing and grading rubric, “cannot evaluate” handling |
| **OPS-04** Curated Mathematical Items & Rubrics | **PENDING** | Actual approved Q1–Q4 prompts/options, diagnostics error patterns, solutions, visuals, worked examples, active practice, retry, meaningful transfer, accepted forms | FR-C4-01/03–05, FR-C5-02–04, diagnosis D1–D6 | Reviewed item bank with reference solutions, equivalence criteria and versioning |
| **OPS-05** Cross-Capability Transition & State Design | **PENDING** | Session state/hand-offs, eligibility, map projections, interrupted flow consistency and cross-component context | FR-X-01..03, LC-07, T1–T7 | Operational transition matrix/state schema with valid/invalid paths and test suite |

**Warning:** a completed-looking UI does not resolve OPS-01/02; hardcoded question examples do not resolve OPS-04; an invented API schema does not resolve OPS-05. Engineering can prepare drafts marked `PROPOSED`, but reviewers must approve source-affecting semantics.

## 4. Approved decisions already fixed by baseline

1. Primary product position: conceptual recovery rather than general mathematics teaching.
2. One full MVP recovery path: Algebra / SPL → Distributive Property.
3. Catalog-first navigation; topic support communicated truthfully; Hybrid Learning Map Explore/Focus/Progress.
4. Diagnosis Q1 SPL MCQ + Q2 short algebra application + Q3 short explanation, optional Q4 procedural trace/conceptual probe, 4 total maximum.
5. C3 results Confirmed/Rejected/Uncertain; ambiguity must not force confirmation; only supported blocker considered.
6. Guided learning Visual → Worked → Partial guided active practice, fixed sequence, curated package shared with optional review.
7. C5 validation in eligible confirmed recovery uses unscaffolded retry then meaningful transfer only on success; outcome matrix Understood / Procedural Only / Needs Reinforcement.
8. Reinforcement reuses package; no default re-diagnosis on validation failure.
9. Evidence and responsibilities distinct: C3 diagnostic outcomes, C4 instruction/completion, C5 learner states, C2 projection.
10. Future-readiness **without** supporting future features: reusable concept links, support boundaries, separable content/assessment, evidence-bound state.
11. 39 Must Have requirements approved **as obligations**, not necessarily implemented or fully verifiable before dependencies resolved.

## 5. Research assumptions A1–A6 are not approved empirical conclusions

- **A1** prerequisite gaps matter for some difficulties (literature + limited self-report; no objective attribution).
- **A2** users struggle attributing cause (limited evidence).
- **A3** existing assistance may be insufficient (reported friction, not comparative evaluation).
- **A4** willingness to use diagnosis (not directly tested).
- **A5** learning gains from Rethink intervention (not established).
- **A6** perceived value/acceptance of validation (indirect, not directly tested).

Evidence for user behavior or learning should be registered separately from product policy decisions. An AI code assistant cannot “validate” these hypotheses merely by implementing a feature.

## 6. Technology status: source paper proposals, *not* source approvals

| Technology / role | Paper-listed option | Allowed next action |
|---|---|---|
| UI | Flutter | Engineering evaluation; do not assume locked |
| Backend/orchestration | FastAPI | Engineering evaluation |
| Concept relationship store | Neo4j | A simpler representation possible if semantics preserved |
| Learner data | PostgreSQL | Engineering evaluation |
| Mathematical checking | SymPy | Check independently whether alternative yields correct mathematics |
| Structured AI output | Pydantic | Equivalent validated output schemas allowed |
| LLM | DeepSeek-V4.1-Flash | Evaluate current availability, cost, latency, reliability, quality before adoption |
| Math visualization | JSXGraph / SVG / Canvas | UX / math fidelity driven implementation choice |

No finalized database, ERD, endpoints, system prompt, physical cloud architecture, auth model or retention policy is supplied by source. Record engineering technology decisions with impact and verification details; escalate behavioral changes for product approval.

## 7. Change control: how a decision becomes binding

**Decision proposal template** (follow Technical Blueprint source pp. 128–129):

```markdown
## DEC-<id> — <title>
- Related OI/OPS ID:
- Current source status: OPEN / PENDING / APPROVED
- Problem / decision required:
- Approved PRD requirements affected (FR IDs):
- Source pages and text:
- Proposed approach (explicitly nonbinding before approval):
- Alternatives considered:
- Rationale & product impact:
- Tradeoffs, mathematical, UX, reliability and delivery risks:
- Verification cases and observable expected outcomes:
- Owner / review body:
- Final outcome: PROPOSED | APPROVED | REJECTED | DEFERRED
- Approval date and approver: <unfilled until actual review>
- Implementation / source-document links:
```

An approved resolution must update (a) this register, (b) dependent product/technical docs, (c) expected behaviors and acceptance cases, (d) changed implementation/tests. Do not overwrite `source/` archive. Product behavior, learner-state mapping and MVP scope changes require controlled product review even if engineering architecture stays the same.

## 8. Implementation and acceptance dependencies — quick lookup

| Dependency | Roadmap impact | Verification status consequence |
|---|---|---|
| OI-01 | P2, relevant P4–P5 | Final diagnostic decision policy/test outcomes blocked |
| OI-02 | P3–P5 | V-X-08 and relevant state/map routing blocked |
| OI-03 | P2, relevant P4–P5 | V-X-07 and all-correct mapping blocked |
| OPS-01 | P3 / P5 | Guided Practice feedback specifics not final |
| OPS-02 | P3–P5 | Completion eligibility / handoff not final |
| OPS-03 | P4–P5 | Missing/ambiguous/equivalent validation grading not final |
| OPS-04 | P2–P5 | Reviewed mathematical fixtures and validity cannot be assumed |
| OPS-05 | P1–P5 | Operational integration and state-consistency details not final |

Some independent work remains possible: topic catalog data, read-only concept map orientation, presentation shell of curated stages, types/interfaces *proposed* for math evidence, integration scaffolding and test harness design. Dependent outcomes require explicit authority before acceptance.

## 9. Decision log and interim implementation directions

| Date | Change | Status | Evidence |
|---|---|---|---|
| As recorded in uploaded Rethink Documentation | Overall PRD v1.0 and 39 FRs approved | **SOURCE APPROVED** | PDF pp. 17, 52–84, 96–97 |
| As recorded in uploaded Rethink Documentation | OI-01..03 unresolved | **SOURCE OPEN** | PDF pp. 50–51, 57, 103, 127–128 |
| As recorded in uploaded Rethink Documentation | OPS-01..05 await operational definition | **SOURCE PENDING** | PDF pp. 57, 103, 127–129 |
| 18 October 2026, user direction in this development chat | OI-01: AI may advise on unclear Q3 reasoning; mathematical checks and system rules retain final diagnostic authority | **INTERIM IMPLEMENTATION DIRECTION; OI-01 STILL OPEN** | User reply; backend v2 reasoning guard and tests |
| Earlier user direction in this development chat | OI-02: Optional Review does not open C5 for now | **INTERIM IMPLEMENTATION DIRECTION; OI-02 STILL OPEN** | User reply; backend v2 transition/tests |
| Earlier user direction in this development chat | OI-03: hold all-correct as an unresolved result | **INTERIM IMPLEMENTATION DIRECTION; OI-03 STILL OPEN** | User reply; backend v2 pending state/tests |
| Earlier user direction in this development chat | OPS-04: use clearly labeled draft examples until reviewed items/rubrics are supplied | **DRAFT CONTENT; OPS-04 STILL PENDING** | User reply; backend v2 content version/status |
| Earlier user direction in this development chat | Preserve website v1 API while adding v2 for iOS | **ENGINEERING COMPATIBILITY DIRECTION** | User reply; separate v1/v2 routes and storage |

These directions authorize the temporary implementation approach, not final mathematical, UX or product acceptance. The source archive is unchanged; no signed review of OI-01..03 or OPS-01..05 is claimed.

## 10. Grade 10 backend integration — 22 October 2026

User approved retaining the teammate backend as the main backend, using the grade-based catalog, showing all ten grade-10 general modules and activating only SPL. The approved implementation direction is SPL Q1–Q3, at most one Q4, evidence-bounded distributive diagnosis, curated recovery, eligible retry/transfer and distributive-only learner state. The archived v2 implementation is ported into the main backend as `/api/v2/*`; the archive remains unchanged. Legacy website API compatibility remains in force. This serves FR-C1-01..05, FR-C2-01..05, FR-C3-01..10, FR-C4-01..08, FR-C5-01..08 and FR-X-01..03 without claiming complete acceptance.

Earlier interim OI-01/02/03 and draft OPS-04 directions remain unchanged. No mathematical review, empirical validation, build, test, live migration, deployment or Swift integration is claimed. Migration: `backend/supabase/migrations/202610220001_spl_recovery_journeys.sql`. Contract: `backend/docs/API-V2.md`.

## 11. SPL content and evidence review — 22 October 2026

The user directed proceeding with the missing-work priority, starting with mathematical content review. [The engineering review](implementation/SPL-CONTENT-REVIEW.md) records existing draft answer references, repeated Q1–Q3 content, Q3 answer disclosure, reproduced keyword-rubric failures, and concrete alternatives for product/pedagogy/engineering review.

A conservative evidence guard now preserves explicit uncertainty and conflicting constant/expansion claims as insufficient, including across AI-advice handoff. This serves FR-C3-04/05/08's approved evidence boundaries without finalizing OI-01 or approving a full natural-language rubric. Existing stored attempts are not reinterpreted. Repeated-group prose was clarified; no question IDs, answer keys, learning-completion rules, optional-review eligibility or final diagnostic synthesis rules changed.

Full backend suite: 63 tests passed; TypeScript check passed. iOS UX and final product/mathematics acceptance remain unverified. OI-01..03 remain **Open**, OPS-01..05 remain **Pending**. The recommended Q2/Q3 revision and general ambiguity rubric remain **PROPOSED**; no final resolution or approver is recorded.

## DEC-2026-10-22-Q2Q3 — Separate diagnostic expressions and remove answer disclosure

- Related OI/OPS: OPS-04; OI-01/03 and OPS-05 remain relevant but unresolved.
- Source baseline: FR-C3-02/04/05/08, FR-X-01/02/03; original PDF pp. 66–70 and 80–81. This changes draft assets, not approved FR wording.
- Decision: **APPROVED FOR THIS IMPLEMENTATION** by the user in this development conversation, 22 October 2026 (reply “sure” to the proposed replacement).
- Approved scope: retain Q1; use Q2 `4(x+3)` with reference `4x+12` and omitted-constant-multiplier pattern `4x+3`; use Q3 “Pada bentuk 5(x + 2), jelaskan bagaimana angka 5 digunakan pada suku-suku di dalam kurung dan mengapa.” The Q3 reference expansion is `5x+10`, with the multiplier applied to both terms. Update numerical references and AI context together.
- Alternative considered: retain repeated expressions with dependent-evidence modelling. Rejected for this item revision because it retains answer disclosure.
- Rationale: Q2 should collect an application response before Q3 collects reasoning without revealing the Q2 solution. Distinct examples do not prove statistical independence or diagnostic accuracy.
- Engineering implementation: bank version `spl-distribution-draft-3`, same question IDs; old versions use the existing explicit reset-required flow and are not silently regraded. Swift receives question content from the backend; decoding fixtures and API examples were synchronized.
- Verification: 66 backend tests passed; production build (including TypeScript) passed. Checks include core roles, no Q2/result disclosure in Q3, updated item references, AI context, existing outcome branches, and explicit draft-2 session reset.
- Remaining limits: full OPS-04 bank/pedagogical acceptance, comprehensive Q3 natural-language rubric (OI-01), all-correct outcome (OI-03), optional-review validation (OI-02), OPS-01..05 and live iOS/accessibility/comprehension testing remain open/pending. This approval does not close those registers or authorize new outcome rules.
- Implementation: `backend/lib/v2/content.ts`, `engine.ts`, `reasoning.ts`, `catalog.ts`; [review](implementation/SPL-CONTENT-REVIEW.md); [API contract](../backend/docs/API-V2.md).

## 12. Saved-session evidence integrity — 22 October 2026

User direction: read the docs and complete additional unfinished work. Engineering scope: FR-X-01..03, FR-C3-03/05/06/08 and FR-C5-04/05/08. [Session integrity review](implementation/SESSION-INTEGRITY.md) records the reproduced defect and implementation.

The existing loader accepted contradictory/missing histories, including an Understood result with no validation evidence. It now checks current-version snapshots against the existing engine and refuses inconsistent results through the existing explicit reset-required flow. Reads do not rewrite stored records, invoke a provider, assign replacement results or change eligibility. Valid interrupted sessions, Q4, optional review, pending results and reinforcement remain supported. This is an engineering evidence guard, **not a resolution of OPS-05 or a new approved state-machine specification**. Future changes to policy/evaluation must preserve explicit versioning and restart/migration semantics.

Verification: **79 backend tests passed**, including real v2 SQL migration permissions, revision conflicts, legacy separation and account deletion in embedded PostgreSQL. Production build including TypeScript passed. No live migration, deployment, GitHub push, iOS execution or learner study was performed for this slice. OI-01..03 remain Open and OPS-01..05 Pending.

## DEC-2026-10-23-BACKEND — Replace legacy backend with a Swift/Vercel recovery API

- **User-approved implementation direction:** replace the backend with one closer to the documentation; delete the old backend rather than retain an archive; host on Vercel; primarily serve the Swift app. Approval is from the current conversation, not a modification of the source PRD.
- Supersedes the earlier implementation direction to retain the teammate website backend, its grade-based catalog and website v1 compatibility. The replacement uses approved subject/topic entry and removes broad pretest, curriculum, chat, transcript and media services from the active deployment.
- Requirements: C1–C5 (all 39 FRs) and FR-X-01..03 boundaries, original PDF pp. 40–51, 61–84, 104–117. Source FR wording is unchanged.
- Engineering choice: API-only TypeScript/Next.js, Node.js 24.x, prepared for Vercel; Swift URLSession remains the client. Logical architecture components are modules, not separate services. The paper's candidate stack is not a mandate.
- Preserve reviewed recovery helpers, approved draft-3 Q2/Q3 items, conservative uncertainty handling and saved-evidence integrity; separate C1 catalog, C2 projection, C3 interpretation, C4 guidance, C5 validation and adapters. Preserve Swift v2 endpoint/response contracts and valid account-owned recovery rows. Reject client-assigned outcomes/unknown command fields.
- Removal is from the local working tree; Git history retains the committed predecessor. No production service, table, account or live record was deleted. Existing `.env.local` was preserved; no source archive was modified.
- Executed verification: 50 replacement tests passed, production build/TypeScript passed, npm ci offline dry-run passed, 35 prior Swift-facing response snapshots matched before deletion, built-server checks passed and all 12 removed legacy API paths returned 404.
- Vercel CLI is installed but unauthenticated; hosting project selection and connection are required before deployment. No deployment or live migration was performed; no Swift release URL was changed.
- OI-01..03 remain **Open**, OPS-01..05 remain **Pending**. Existing interim directions and the scoped Q2/Q3 approval remain in force. No final rubric, completion or state-machine acceptance is conferred.
- [Implementation/verification report](implementation/BACKEND-REBUILD.md), [native API setup](../backend/SETUP.md), [API contract](../backend/docs/API-V2.md).

## DEC-2026-10-23-SUPABASE — Align Swift with the configured backend project

- User decision in this conversation: use backend project `hhovzaaeolcfynyetabf` and update the Swift app's public configuration. The user separately selected a new Rethink API project on Vercel.
- Updated `frontend/Rethink/App/AppConfig.swift` defaults to the selected project URL and its configured public key. The key was checked as publishable/anon before being written; no backend secret/service-role value was copied into app source or printed.
- `KeychainTokenStore` now namespaces session records by Supabase host, preventing another project's saved guest tokens from being restored/refreshed against the selected project. The old unscoped token record is not automatically migrated or deleted. Existing progress is not transferred across projects, and no live account/data operation was performed.
- Engineering scope: authentication configuration and FR-X context isolation; no C3/C5 policy, new learning path or final OPS-05 resolution.
- Verification: static public-configuration match and secret-exclusion checks passed; existing initializer call sites inspected. Swift/Xcode runtime and Keychain operations were **NOT RUN** in the Windows environment.
- The Vercel CLI still reports no credentials after the sign-in attempt. No project/deployment was created and the Swift API URL was not switched to an invented endpoint. Hosting sign-in is the remaining prerequisite for new-project deployment.

## Hosting execution update — 23 October 2026

Vercel sign-in succeeded as `hansenhalim1`. Created and linked the new `hansens-projects-6e7d42c5/rethink-recovery-api` project; existing Vercel projects are unchanged. Source deployment is in progress. Automatic approval review rejected transfer of existing Supabase/AI configuration to Vercel pending explicit user authorization. No credential transfer was executed. The selected Supabase project returned `404 / PGRST205` for the recovery table; applying the existing migration and enabling anonymous sign-ins remain required. The user has been given the exact migration file and dashboard link. This is infrastructure status, not an OI/OPS resolution or proof of a working hosted recovery flow.

### Hosting execution follow-up

The user explicitly approved transferring the existing Supabase and AI configuration to Production on the new Vercel project. Transfer completed without displaying credentials, with backend secret and AI keys marked sensitive. Production is https://rethink-recovery-api.vercel.app. The fresh cloud build and TypeScript passed. Next.js was upgraded to 16.4.2 to address the audit findings; local production audit and cloud install report zero vulnerabilities, and all 50 replacement tests passed again. The user reported applying the migration; a live recovery-table query passed. Anonymous signup still returns HTTP 422 / `anonymous_provider_disabled`, so the user has been asked to enable/save the setting. No successful guest/save-resume or Swift API cutover is claimed yet. OI/OPS remain unresolved.

### Anonymous-auth recheck — 23 October 2026

After the user reported enabling anonymous sign-ins, two live checks still returned HTTP 422 / `anonymous_provider_disabled` from the selected `hhovzaaeolcfynyetabf` project. Recovery-table availability passed. No synthetic guest was created, and hosted authenticated save/resume remains blocked. Asked the user to confirm the setting persists after refresh in this exact project. Swift API cutover remains pending; no product-policy change was made.

### Hosted guest verification and Swift API cutover — 23 October 2026

After the user enabled and saved Anonymous Sign-Ins in the selected project, the hosted check passed: anonymous signup, authenticated empty journey, SPL selection, Q1–Q3 diagnosis, saved/interrupted resume, stale-revision rejection, confirmed recovery through Visual → Worked → active Practice → Independent Retry → Transfer, and persisted Distributive Property Understood/map projection. The temporary synthetic guest was deleted through the admin API afterward, cascading its own evidence only. Q3 used curated interpretation; no external AI completion or learner-effectiveness claim is made.

Updated `frontend/Rethink/App/AppConfig.swift` default API URL to https://rethink-recovery-api.vercel.app, preserving local environment overrides and the already approved matching Supabase public configuration. This serves FR-X-01..03 infrastructure/context continuity without changing C3/C5 policies. Static configuration checks passed. Xcode/device execution, Keychain runtime and user comprehension remain NOT RUN; OI-01..03 and OPS-01..05 retain their source statuses. Prior hosting/auth blockers above are historical and are now resolved.

### Completion execution and grading integrity — 23 October 2026

Implemented the user-approved OI/OPS rules and GAM projections, visible practice feedback, explicit catalog/map exits, attempt-limit restart, client session refresh/unknown-save guards, source-backed catalog and Release first-launch onboarding. The DEBUG Home shortcut remains available. Current completed implementation and scenario evidence: [MVP-COMPLETION.md](implementation/MVP-COMPLETION.md). The full hosted branch matrix passed, including real guest isolation, refresh and bounded Gateway Q3; both test guests were deleted.

A grading-integrity defect was found during completion: a floating-point tolerance accepted slightly wrong expressions as equivalent. FR-C3-04 / FR-C5-04 now use exact rational arithmetic for supported linear forms. Unsupported adjacent numeric tokens remain ungraded instead of being guessed as multiplication. Previously accepted incompatible near-equal histories require the existing explicit restart, not silent regrading. Current bank expressions are unchanged. The exact-arithmetic production smoke passed and removed its temporary guest; all 57 backend tests and the local build passed. Swift/package/simulator, accessibility and expert pedagogical/rubric acceptance remain NOT RUN.

Final completion deployment: `rethink-recovery-3b3353x58-hansens-projects-6e7d42c5.vercel.app` Ready on the existing production alias, with cloud build/TypeScript PASS and zero audit vulnerabilities. Final backend suite: 57 PASS, 0 FAIL. All synthetic guests from branch and grading-input probes were deleted. Legacy pending outcome emission is removed; old incompatible evidence still requires explicit restart. Remaining work is verification on Mac/device and independent expert/usability acceptance, rather than another implementation-policy approval.

## DEC-2026-10-23-MODEL-CONFIG — Environment-only Gateway model selection

- User request: switching the AI model should require changing Vercel environment configuration only. Engineering scope: FR-C3-08 and its FR-C3-04/05 evidence safeguards; existing OI-01 implementation authority remains unchanged.
- Removed the DeepSeek-only model-ID restriction. `AI_GATEWAY_MODEL` accepts Gateway `provider/model` identifiers; unset/blank retains the existing DeepSeek default. The endpoint and credential remain Vercel AI Gateway. Model selection cannot redirect student input to an arbitrary endpoint.
- Removed explicit temperature/reasoning options, which vary between models. Retained the common Chat Completions JSON-schema contract, output bound, timeout, literal-quote checks and conservative failure handling. Only compatible text/structured-output models available to the team are eligible; syntax validation does not establish availability or diagnostic quality. Model defaults can change latency and output-budget use.
- Model changes require redeployment, no Swift update or code edit. No automatic model/credential fallback, persisted-evidence regrading, new diagnostic authority or additional supported concept. See [model-switch instructions](../backend/SETUP.md#switching-the-ai-model).
- Verification: 59 backend tests PASS, TypeScript check PASS. Added mocked cross-provider request/guard checks and malformed-model, missing-key, access/credit/rate/provider-failure and truncation cases. No paid/live model calls, environment changes, GitHub push or deployment were performed for this slice. Per-model accuracy and production availability remain unverified. No UI or user-facing copy changed.

## DEC-2026-10-23-PRD-V2 — Import latest PRD and prepare missing capabilities

- User direction: pull the newest PRD docs and add missing features. Imported the PRD v2 source/derivatives from `origin/main` at `d107a04`; preserved later implementation approvals and verification reports. V2 supersedes v1's three-primary/single-blocker diagnostic scope, adding ten primary questions, per-concept results, contextual Socratic help and separate five-question topic assessment. Recovery and concept validation remain complete only for distribution.
- New bank, multi-concept evidence thresholds and one-probe deployment budget are a concrete **PROPOSAL, AWAITING IMPLEMENTATION REVIEW**, not approval inferred from the feature request or the old bank decision. [Proposal](implementation/PRD-V2-PLAN.md). The user's pending review question covers those assets/rules; expert content and empirical acceptance remain distinct.
- Independent engineering work is implemented behind a closed source-controlled content gate: v3 API and event replay, separate topic-attempt history within existing owner/revision persistence, guarded contextual hints and Swift opt-in models/screens. Existing default client and production deployment remain on v2. Legacy reset cannot erase new topic history.
- [Execution evidence](implementation/PRD-V2-EXECUTION.md): 84 backend tests PASS, production build/TypeScript PASS, built HTTP smoke PASS and embedded PostgreSQL history/revision checks PASS. New flow tested offline with injected proposed rules; no paid/live AI, cloud deployment or GitHub push. Swift/device/accessibility, expert mathematics/pedagogy, accuracy and user studies NOT RUN. Full 43-FR acceptance remains Untested; new runtime grading remains Blocked by pending decision.

# Rethink — Product Decisions, Open Issues, Operational Specifications & Change Control

> **Source status as of uploaded 133-page documentation:** Approved Overall PRD v1.0 and **39 Approved Must Have functional requirements**; **OI-01–OI-03 OPEN**; **OPS-01–OPS-05 PENDING**. This Markdown does not confer any additional approval. Relevant PDF pages: 17, 50–51, 57, 68–71, 74–84, 89–97, 102–103, 110–117, 127–133.

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

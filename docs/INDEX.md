# Rethink — Documentation Index & Source-of-Truth Map

> **Current implementation reconciliation (23 October 2026):** PRD v2 docs imported from `origin/main` at `d107a04`. The deployed recovery API and its 59-test baseline remain intact. New v2 work, approved bank/rules and test evidence are tracked in [PRD-V2-EXECUTION.md](implementation/PRD-V2-EXECUTION.md) and [PRD-V2-PLAN.md](implementation/PRD-V2-PLAN.md) and the [43-requirement inventory](implementation/PRD-V2-TRACEABILITY.md). Earlier approved implementation rules remain recorded in [decisions.md](decisions.md), with v2 scope changes identified separately.

**Purpose:** This is the front door for Codex. Use selective retrieval; do not paste or ingest the full archive for every task. The linked main files are detailed *working derivatives*, while `source/` preserves all 133 uploaded pages for completeness and dispute resolution.

## Essential files

| Path | Read for | Source PDF coverage |
|---|---|---|
| [`../AGENTS.md`](../AGENTS.md) | Agent operating guardrails, reading order, no-guessing requirements, testing | Derived across entire PDF |
| [`prd/overview.md`](prd/overview.md) | Identity, positioning, problem evidence, users, hypotheses, goals, evaluation, risks, roadmap, governance | Mainly pp. 1–9, 15–39, 89–97 |
| [`prd/mvp-definition.md`](prd/mvp-definition.md) | Exact bounded MVP coverage, C1–C5, diagnostic/learning/validation flows, exclusions | pp. 10–12, 40–51 |
| [`prd/requirements.md`](prd/requirements.md) | Legacy 39-FR v1 traceability; v2 migration delta is indexed in the changelog until full 43-FR reconciliation | Historical derivative |
| [`technical/architecture.md`](technical/architecture.md) | Conceptual/technical logical architecture, LC components, workflows, data/AI/methodology, technical handoff | pp. 85–88, 98–133 |
| [`design/README.md`](design/README.md) | Design folder navigation and document status | Separate design add-ons, not in source PDF |
| [`design/DESIGN.md`](design/DESIGN.md) | **User-provided Rethink visual style reference**: colors, typography, spacing, shape, imagery, motion and CSS/Tailwind tokens | Separate uploaded style guide, 18 Oct 2026; not part of the 133-page PDF |
| [`design/gamification-specification.md`](design/gamification-specification.md) | **PROPOSED** progress, contextual feedback and concept-achievement interaction/engineering specification | Separate gamification proposal, 18 Oct 2026; not an approved new FR |
| [`design/gamification-acceptance-tests.md`](design/gamification-acceptance-tests.md) | Proposed scenario-based gamification tests and OI/OPS approval gates | Separate gamification proposal; not a verified test result |
| [`design/onboarding-specification.md`](design/onboarding-specification.md) | **PROPOSED** onboarding flow, screens, copy, audio, motion, gamification hooks and implementation rules | Separate onboarding proposal; current app has a five-step, activity-gated onboarding |
| [`design/onboarding-audio-script.md`](design/onboarding-audio-script.md) | Proposed Bahasa Indonesia onboarding voiceover script and toggle behavior | Separate onboarding proposal; `onboarding-1a.mp3` and `onboarding-1b.mp3` exist for the first slide; other narration files are future work, with `dummy-audio.mp3` fallback when present |
| [`design/onboarding-acceptance-tests.md`](design/onboarding-acceptance-tests.md) | Proposed onboarding QA scenarios, including anonymous guest activation and content integrity | Separate onboarding proposal; not executed results |
| [`design/UX-WRITING.md`](design/UX-WRITING.md) | **PROPOSED** voice, tone, Indonesian language conventions, terminology, screen copy direction, error/audio/onboarding rules and implementation contract | Separate UX-writing standard; not an approved FR |
| [`design/ux-writing-copy-bank.md`](design/ux-writing-copy-bank.md) | Indonesian copy candidates with stable IDs and usage status (`SAFE-DRAFT`, `CONDITIONAL`, `BLOCKED`, `PREVIEW`) | Proposed copy bank; blocked IDs cannot ship |
| [`design/ux-writing-acceptance-tests.md`](design/ux-writing-acceptance-tests.md) | Proposed UX-writing QA scenarios covering language, diagnosis copy, validation, errors, accessibility and governance | Proposed test suite; not executed results |
| [`decisions.md`](decisions.md) | Approved baseline vs OI-01..03 Open, OPS-01..05 Pending, decision procedures and change log | pp. 17, 50–51, 57, 89–97, 103, 110–117, 127–133 |
| [`source/v2/ReThink Documentation — PRD v2 Draft.docx`](source/v2/ReThink%20Documentation%20%E2%80%94%20PRD%20v2%20Draft.docx) | Local PRD v2 source snapshot | Product PRD sections 1–10; preserve unchanged |
| [`implementation/FR-TRACEABILITY.md`](implementation/FR-TRACEABILITY.md) | Legacy 39-FR implementation mapping plus explicit v2 gap note | Engineering audit; not complete v2 traceability |
| [`PRD_V2_DOCUMENTATION_INVENTORY.md`](PRD_V2_DOCUMENTATION_INVENTORY.md) | Recursive docs inventory and active/legacy/conflict classification | Migration audit |
| [`implementation/SPL-CONTENT-REVIEW.md`](implementation/SPL-CONTENT-REVIEW.md) | Draft SPL mathematical references, evidence guard fixes, executed checks and proposed item/rubric review decisions | Engineering review; OI/OPS approval remains pending |
| [`source/ReThink-Documentation-original.pdf`](source/ReThink-Documentation-original.pdf) | Exact canonical uploaded source including tables, spacing and visual layout | All 133 pages |

## Project in a minute

**Rethink** is a self-directed, AI-assisted mathematics **conceptual recovery** platform. Rather than solving any math problem or teaching an entire curriculum, it attempts to find a **supported** prerequisite conceptual blocker from student evidence, teach that concept with curated scaffolding, and evaluate its independent application and transfer.

**MVP**: Catalog-first Algebra → selectable SPL. Diagnosis uses ten curated primary questions Q1–Q10 for bounded multi-concept screening, per-concept evidence synthesis, and bounded follow-up probes with separate IDs. Results distinguish Supported / Not Supported / Uncertain / Insufficiently Assessed, coverage, priority and content availability. Learning is open after diagnosis; Distributive Property remains the only complete curated package: Visual Explanation → Worked Example → Partial Guided Practice. Concept validation uses Independent Retry → Transfer Problem. Separate SPL Final Assessment has exactly five questions, passes at 3/5, preserves retries, and does not assign prerequisite learner states.

**Source status:** PRD v2 Product Requirements and Detailed Requirements tabs contain **43 approved functional requirements**; PAPER remains research context. `Approved` ≠ built or verified. Runtime implementation remains partial; see [`PRD_V2_MIGRATION_CHANGELOG.md`](PRD_V2_MIGRATION_CHANGELOG.md). Supplemental `design/` documents retain their stated proposed status.

## Design, onboarding, gamification, and UX-writing extensions

These additional documents are **not in the original 133-page PRD PDF**. They extend the repository's *design handoff* without modifying approved requirements:

| Topic | Where to read | Status | Engineering application |
|---|---|---|---|
| Rethink brand/UI appearance | [`design/DESIGN.md`](design/DESIGN.md) | **User-provided visual reference** | Apply tokenized palettes, type, components and motion to new UI; adapt editorial/marketing examples thoughtfully for assessment/learning screens. |
| Onboarding experience | [`design/onboarding-specification.md`](design/onboarding-specification.md) | **PROPOSED** | Build a calm, activity-gated activation flow; anonymous guest is the default activation path; account linking is optional/future. |
| Onboarding audio | [`design/onboarding-audio-script.md`](design/onboarding-audio-script.md) | **PROPOSED** | Optional Bahasa Indonesia voiceover, default on when available, with visible reversible mute; onboarding must remain usable without audio. |
| Onboarding verification | [`design/onboarding-acceptance-tests.md`](design/onboarding-acceptance-tests.md) | **Proposed scenarios** | Test flow, persistence, guest activation, audio, reduced motion, content integrity and accessibility. |
| UX voice & conversation design | [`design/UX-WRITING.md`](design/UX-WRITING.md) | **PROPOSED** | Use the voice, tone, Indonesian conventions, terminology and truth checks; do not copy Gojek slogans or imply affiliation. |
| Indonesian copy bank | [`design/ux-writing-copy-bank.md`](design/ux-writing-copy-bank.md) | **PROPOSED** | Use stable IDs and statuses; `BLOCKED` copy cannot ship; `CONDITIONAL` requires actual state; `PREVIEW` is never a real outcome. |
| UX-writing verification | [`design/ux-writing-acceptance-tests.md`](design/ux-writing-acceptance-tests.md) | **Proposed scenarios** | Test language consistency, diagnosis/validation claims, errors, audio/mute, accessibility and copy governance. |
| Learning-loop Progress Indicator | [`design/gamification-specification.md`](design/gamification-specification.md) PART A | **PROPOSED** | Display actual phase/activity progress, never a fabricated mastery score. |
| Contextual Positive Feedback | Same document, PART B | **PROPOSED**, OPS-01/02/03/04 dependencies | Show status/factual/actionable feedback only at safe assessment points; do not expose diagnostic answers early. |
| Concept Achievement | Same document, PART C | **PROPOSED**, requires valid C5 state; OI-02/OPS-03/04/05 dependencies | Recognize supported `Understood` evidence, not lesson completion or SPL mastery. |
| Gamification verification | [`design/gamification-acceptance-tests.md`](design/gamification-acceptance-tests.md) | **Proposed scenarios** | Test normal, branching, error, repeat/refresh, accessibility, privacy and source-state consistency before proposing release. |

**Governance:** approved PRD/FRs control learning behavior and claims; `design/DESIGN.md` informs appearance; onboarding and gamification docs propose interaction/reward rules; `decisions.md` tracks unresolved OI/OPS constraints. When in conflict, **do not silently override** an approved functional rule with an attractive UX effect. A user-provided style reference is not proof of a full approved screen-level design or accessibility compliance. For the precise guidance, read `AGENTS.md` §4A and §4B.

## Recommended selective reading plans

| Codex task | Minimum files first | Then inspect |
|---|---|---|
| UI catalog, topic support | `AGENTS.md`, `prd/mvp-definition.md`, `prd/requirements.md` C1, `design/DESIGN.md` | `source/06-product-requirements-detailed.md` original pp. 61–63 |
| Visual design, components, typography, responsive styling | `design/README.md`, `design/DESIGN.md`, relevant FRs | App-specific accessibility/layout decisions; source style has editorial landing-page examples, not full learning-screen UX |
| Onboarding implementation | `AGENTS.md`, `design/onboarding-specification.md`, `design/DESIGN.md`, `design/gamification-specification.md` | `design/onboarding-audio-script.md`, `design/onboarding-acceptance-tests.md`, `design/references/onboarding/` |
| UX writing / copy changes | `AGENTS.md`, `design/UX-WRITING.md`, `design/ux-writing-copy-bank.md`, relevant FRs and `decisions.md` | `design/ux-writing-acceptance-tests.md`, `design/DESIGN.md`, source PRD pages for exact meaning |
| Learning-loop progress indicator | `design/gamification-specification.md` PART A, `requirements.md` C2/C3/C4/C5, `decisions.md` | `design/gamification-acceptance-tests.md`, OPS-02/OPS-05 |
| Contextual feedback during learning | `design/gamification-specification.md` PART B, `requirements.md` C3/C4/C5, `decisions.md` | `design/gamification-acceptance-tests.md`, OPS-01/02/03/04 |
| Concept achievement | `design/gamification-specification.md` PART C, `requirements.md` C5, `decisions.md` | `design/gamification-acceptance-tests.md`, OI-02/OPS-03/04/05; do not award from C4 completion |
| Hybrid learning map | `requirements.md` C2 & FR-X, `decisions.md` | Source pp. 64–65, 80–82, 85–88 |
| Q1–Q10 diagnostic flow | `prd/mvp-definition.md` C3, `technical/architecture.md` D1–D7, migration changelog | PRD v2 PRD/Technical Blueprint tabs |
| Mathematical / LLM reasoning | `architecture.md` AI/methodology, `decisions.md` OI-01 / OPS-04 | Source pp. 118–126; prior paper only when available |
| Guided learning | `requirements.md` C4, `mvp-definition.md`, `decisions.md` OPS-01/02/04 | Source pp. 72–75, 111–113 |
| Validation / state mapping | `requirements.md` C5, `decisions.md` OPS-03 / OI-02 | Source pp. 76–80, 113–115 |
| Integration or storage design | `requirements.md` FR-X, `architecture.md` LC-07/contracts, `decisions.md` OPS-05 | Source pp. 80–84, 104–117 |
| Acceptance / release | `overview.md` metrics & AP, `requirements.md` V-X, `decisions.md` | Source pp. 32–39, 82–84, 89–97, 127–133 |

## Source sections and lossless-coverage strategy

This conversion includes **all 133 PDF pages**, grouped into independent, navigable page-numbered transcripts. Machine text extraction has unavoidable limitations (e.g., tables, symbols and page layout), so the **original PDF is also bundled**. Both are needed to substantiate a strict “no missed information” request. Derived documents never erase or overrule the source.

| Source transcript | PDF pages | Original tab/section |
|---|---:|---|
| [`source/00-prd-consolidated-summary.md`](source/00-prd-consolidated-summary.md) | 1–17 | Executive PRD summary (Indonesian) |
| [`source/01-product-overview.md`](source/01-product-overview.md) | 18–22 | Product Overview |
| [`source/02-problem-statement.md`](source/02-problem-statement.md) | 23–31 | Problem Statement & Target Users |
| [`source/03-product-goals.md`](source/03-product-goals.md) | 32–39 | Product Goals & Success Metrics |
| [`source/04-product-scope-mvp.md`](source/04-product-scope-mvp.md) | 40–51 | Product Scope & MVP Definition |
| [`source/05-product-requirements-summary.md`](source/05-product-requirements-summary.md) | 52–57 | Requirements inventory/summary |
| [`source/06-product-requirements-detailed.md`](source/06-product-requirements-detailed.md) | 58–84 | Detailed Product Requirements, verification scenarios |
| [`source/07-product-conceptual-architecture.md`](source/07-product-conceptual-architecture.md) | 85–88 | Conceptual Product Architecture & Scalability |
| [`source/08-product-roadmap.md`](source/08-product-roadmap.md) | 89–92 | Product Roadmap |
| [`source/09-risks-and-dependencies.md`](source/09-risks-and-dependencies.md) | 93–95 | Assumptions, Risks & Dependencies |
| [`source/10-acceptance-governance.md`](source/10-acceptance-governance.md) | 96–97 | Product Acceptance & PRD Governance |
| [`source/11-technical-overview.md`](source/11-technical-overview.md) | 98–103 | Technical Overview & MVP Boundaries |
| [`source/12-technical-components.md`](source/12-technical-components.md) | 104–108 | System Components & Responsibilities |
| [`source/13-technical-workflows.md`](source/13-technical-workflows.md) | 109–117 | Core Processing Workflows |
| [`source/14-data-ai-methodology.md`](source/14-data-ai-methodology.md) | 118–126 | Data, AI & Methodological Foundations |
| [`source/15-readiness-technical-governance.md`](source/15-readiness-technical-governance.md) | 127–133 | Implementation Readiness & Technical Governance |

### Page numbering and audit method

- Page numbers in `source/*.md` are **PDF page indices**, not section-relative printed numbers.
- Source text comes from actual uploaded PDF page-by-page. Native tables are best checked in the bundled PDF. Source diagrams marked `[DIAG-01]`...`[DIAG-04]` are **placeholders in the source**, not finished system diagrams.
- Section headings may continue onto the following PDF page; grouping follows actual source document transitions.
- The **original PDF** contains no complete standalone design requirements tab or final physical backend specification despite the original proposed folder view. A separate `design/DESIGN.md` has since been supplied and preserves the visual style reference; gamification specifications have also been added as **PROPOSED**. Neither is part of the archival PDF or proof that full app-screen interaction design and operational decisions are approved.

## Active PRD v2 requirement registry

C1: 5 · C2: 5 · C3: 10 · C4: 9 · C5: 11 · FR-X: 3 = **43**. See [the v2 inventory](implementation/PRD-V2-TRACEABILITY.md). Imported source approval does not mean all requirements are verified or production rollout is complete.

### Historical v1 registry

| Group | Count | IDs | Owner |
|---|---:|---|---|
| C1 | 5 | FR-C1-01–FR-C1-05 | Learning Entry & Topic Discovery |
| C2 | 5 | FR-C2-01–FR-C2-05 | Hybrid Learning Map |
| C3 | 10 | FR-C3-01–FR-C3-10 | Diagnostic Assessment & Outcomes |
| C4 | 8 | FR-C4-01–FR-C4-08 | Targeted Guided Learning |
| C5 | 8 | FR-C5-01–FR-C5-08 | Knowledge Validation & Learning Outcomes |
| X | 3 | FR-X-01–FR-X-03 | Cross-Capability Integrity |
| **Legacy total** | **39** | Historical v1 registry | **Not the v2 inventory** |

### Cross-cutting reference tags

`G1–G4` product goals · `SC1–SC4` success conditions · `D1–D4` evaluation dimensions · `C1–C5` MVP capabilities · `F1–F4` future-ready constraints · `E1–E5` exclusions · `FR-X-01..03` transition requirements · `IP-01..02` integrity principles · `V-X-01..08` verification cases · `P1–P5` roadmap · `R-01..06` risks · `AP-01..05` acceptance principles · `PG-01..05` governance principles · `OI-01..03` Open decisions · `OPS-01..05` Pending operational details · `LC-01..08` logical components.

## If the source differs from an agent assumption

1. Verify the exact PDF page (linked transcript first, PDF for tables/graphics).
2. Classify the evidence as **approved product baseline**, **source-proposed architecture/technology**, **unresolved decision**, **research evidence**, **inference**, or **engineering option**.
3. Record source page and relevant ID; surface conflict in task output.
4. Avoid silently finalizing open behaviors. Propose an engineering/product review entry in `decisions.md`.

## Delivery status and honest completeness

All PDF pages remain in the source archive. `prd/requirements.md` is the historical 39-FR derivative; PRD v2 has 43 approved functional requirements and requires a future complete ID-by-ID reconciliation. The original PDF remains unchanged. Supplemental design, gamification, onboarding and UX-writing documents retain their proposal statuses. This handoff does not prove implementation or product acceptance.

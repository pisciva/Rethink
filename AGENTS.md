# Rethink — Repository Instructions for Codex and AI Engineering Agents

> **Binding working policy for agents inside this repository.** Read `docs/INDEX.md` before editing product behavior. Source baseline: uploaded *Rethink Documentation* PDF, 133 pages. These instructions are a documentation handoff, **not** new product approval, an implemented codebase, or proof of product readiness.

## 0. Role and operating mandate

You are implementing **Rethink**, an AI-assisted mathematics **conceptual recovery platform**. It is **not** a generic chatbot, general math lesson catalog, broad adaptive tutor, SPL-mastery assessor, or unconstrained misconception classifier. Favor accurate, evidence-bounded end-to-end behavior over aesthetic complexity, speculative adaptation, breadth of coverage, or impressive-but-unsupported claims.

Primary workflow: **Catalog / supported topic → diagnostic Q1–Q3 (optional Q4) → supported diagnosis result → confirmed recovery OR optional review / topic exploration → curated Guided Learning → eligible Knowledge Validation → blocker-level learner state → Learning Map projection**.

The **only complete MVP recovery path**: `Algebra → Sistem Persamaan Linear (SPL) → Distributive Property` as the supported conceptual blocker. SPL is the diagnostic entry topic, *not* the learner-state scope. There are five approved capability groups: `C1` Catalog, `C2` Hybrid Learning Map, `C3` Diagnosis, `C4` Guided Learning, `C5` Knowledge Validation, plus `FR-X` cross-capability rules. The original PDF records **39 approved Must Have FRs**; the approval does **not** mean implementation/verification is complete.

## 1. Required reading / document selection

1. Start with [`docs/INDEX.md`](docs/INDEX.md) for the topic index, source provenance, and coverage map.
2. Read [`docs/prd/overview.md`](docs/prd/overview.md) for product positioning, evidence and research limitations, success criteria, roadmap, and governance.
3. Read [`docs/prd/mvp-definition.md`](docs/prd/mvp-definition.md) for **binding scope** and state constraints.
4. Read [`docs/prd/requirements.md`](docs/prd/requirements.md) for all **39 individually referenced requirements**, source paragraphs and verification bases.
5. Read [`docs/technical/architecture.md`](docs/technical/architecture.md) for **logical**, not fixed physical, architecture and workflows.
6. Read [`docs/decisions.md`](docs/decisions.md) **before designing any dependent behavior**; OI-01..03 are **Open**, OPS-01..05 **Pending** in the source.
7. **For visual/interface design work**, read [`docs/design/README.md`](docs/design/README.md), then [`docs/design/DESIGN.md`](docs/design/DESIGN.md) for the user-provided Rethink visual style reference. It defines brand tokens, typography, components, shape, and motion; it is **not** a complete learning-app interaction/functional specification.
8. **For gamification, progress, feedback, rewards, or achievements**, read [`docs/design/gamification-specification.md`](docs/design/gamification-specification.md) and the relevant test cases in [`docs/design/gamification-acceptance-tests.md`](docs/design/gamification-acceptance-tests.md). Their status is **PROPOSED, not PRD-approved**. Read only applicable sections for the task.
9. **For onboarding work**, read [`docs/design/onboarding-specification.md`](docs/design/onboarding-specification.md), [`docs/design/onboarding-audio-script.md`](docs/design/onboarding-audio-script.md), and applicable scenarios in [`docs/design/onboarding-acceptance-tests.md`](docs/design/onboarding-acceptance-tests.md). Inspect visual references in `docs/design/references/onboarding/`. These are **PROPOSED**, not PRD-approved.
10. **For any user-facing copy**, read [`docs/design/UX-WRITING.md`](docs/design/UX-WRITING.md), use [`docs/design/ux-writing-copy-bank.md`](docs/design/ux-writing-copy-bank.md) by stable ID and status, and use [`docs/design/ux-writing-acceptance-tests.md`](docs/design/ux-writing-acceptance-tests.md) for proposed QA. These are **PROPOSED**, not approved FRs.
11. When disputed or insufficiently specific, inspect the corresponding page in `docs/source/*.md` and, if needed, `docs/source/ReThink-Documentation-original.pdf` (authoritative original PRD presentation). **Never** quietly invent a missing requirement.

**Source precedence when behavior conflicts:** approved Overall PRD v1.0 and approved 39 Product Requirements > proposed Technical Blueprint/architecture implementation suggestions > earlier paper and design/process references. The separately supplied `docs/design/DESIGN.md` governs **visual style choices** as a user-provided design reference, but cannot override product behavior, mathematical correctness, approved FRs, or accessibility. The gamification, onboarding and UX-writing documents are **proposed experience/content additions**, not approved new FRs; they cannot change C3/C5 outcomes or close OI/OPS items. Technological proposals in the paper are **not mandatory final stack decisions**. Derived Markdown is a navigation-and-handoff representation of the PDF, not a new independent product baseline. If the original PDF and this Markdown differ, surface the discrepancy and ask for review instead of silently selecting a preferred interpretation.

## 2. Hard product invariants (never violate)

### Supported coverage and learner claims
- **Represented ≠ Configured ≠ Actively Supported.** Concept graph nodes, maps and placeholders never activate diagnosis, teaching, or validation by their mere existence.
- **Not assessed ≠ not understood**, and **Confirmed blocker ≠ Understood learner state**.
- `Confirmed`, `Rejected`, and `Uncertain` are **diagnostic outcomes** of C3; they are not C5 learner states.
- `Understood`, `Procedural Only`, and `Needs Reinforcement` are **validation-derived learner states**, scoped **only to Distributive Property**, not SPL or general math.
- An answer wrong once is not proof of conceptual gap. Ambiguity / counterevidence must be considered; never fabricate confirmation or numerical confidence.
- Failure of AI, missing reference data, or uninterpretable input is **not** a valid inferred blocker or proof of misunderstanding.

### Diagnostic assessment
- `Q1`: SPL target-performance **MCQ**.
- `Q2`: Distributive Property **short mathematical response**.
- `Q3`: **short conceptual explanation/reasoning**.
- `Q4`: optional, conditional, **one maximum**, either **Procedural Trace** or **Conceptual Probe**. Never perform a repeated probe loop; ≤4 questions total.
- Evaluate outcome, transformation and explanation where available; preserve evidence provenance and separate **observation → interpretation → diagnostic inference**.
- Cross-question synthesis must recognize supporting, contradictory and insufficient evidence; do not count multiple observations from one response as independent evidence by default.
- All-correct diagnostic output mapping remains **OI-03 Open**: do not assign an unapproved outcome/presumption of SPL mastery.

### Guided learning
- Only one curated package: **Visual Explanation → Worked Example → Partial Guided Practice**; sequence is **linear**, no dynamic scaffold selector or LLM-generated curriculum.
- Guided Practice requires **active mathematical input** (at least one relevant response); passively viewing content is insufficient.
- **Confirmed Recovery** and **Optional Concept Review** can use the same package, but keep their origin explicit. Optional Review never retroactively confirms a blocker.
- Guided-learning completion never establishes a C5 state. Feedback mechanism and completion criteria are **OPS-01/02 Pending**.

### Knowledge validation
- After an **eligible completed confirmed recovery**, administer scaffold-free Independent Retry; only if successfully evaluated, administer materially different **Transfer Problem** with the same underlying concept.
- With valid item evaluations: `retry fail → Needs Reinforcement (no transfer)`; `retry pass + transfer fail → Procedural Only`; `retry pass + transfer pass → Understood`.
- Needs Reinforcement routes to the **existing** curated package, no new diagnostic or adaptive remediation loop.
- Missing/ambiguous/uninterpretable/mathematically equivalent response evaluation remains **OPS-03 Pending**; do not treat unresolved evidence as automatic failure.
- Eligibility and learner-state implications **after Optional Review** remain **OI-02 Open**. Do not create an apparently approved post-review validation path.

### Map and state integrity
- C2 **projects** C3 and C5 outputs; does not invent diagnostic or learning judgments.
- Map `Explore` pre-diagnosis: structural orientation without personal weakness labels; `Focus` after diagnosis: confirmed vs non-confirmed distinction; `Progress` after valid C5: evidence-bounded blocker state.
- Preserve selected topic, assessed concept, diagnostic outcome, learning-entry context, completion, and validation evidence consistently across all transitions (`FR-X-01..03`).

## 3. Explicitly unresolved areas — strict anti-hallucination policy

| Ref | Source status | Do **not** silently decide |
|---|---|---|
| OI-01 | OPEN | Final diagnostic decision authority: LLM vs math evaluator vs system orchestration/guardrails |
| OI-02 | OPEN | Validation eligibility and learner-state update following Optional Concept Review |
| OI-03 | OPEN | Final mapping, communication and continuation for all-correct Q1–Q3 pattern |
| OPS-01 | PENDING | Guided Practice feedback, wrong-answer and retry mechanics |
| OPS-02 | PENDING | Exact Guided Learning completion criteria |
| OPS-03 | PENDING | Validation empty/invalid/equivalent/uninterpretable response handling |
| OPS-04 | PENDING | Final approved mathematical question bank, reference solutions, rubrics, error patterns |
| OPS-05 | PENDING | Operational state machine, transition semantics and persistence/handoff detail |

When a task touches an unresolved element: **(a)** identify the dependency by ID, **(b)** implement only approved independent portions, **(c)** propose options/trade-offs and verification without claiming approval, **(d)** request a product/engineering review decision when needed, **(e)** record any approved resolution in `docs/decisions.md` and update affected requirements/tests. Do not block unrelated work.

## 4. Technology governance

Source paper mentions **Flutter, FastAPI, Neo4j, PostgreSQL, SymPy, Pydantic, DeepSeek-V4.1-Flash, JSXGraph / SVG / Canvas**. **All are paper-proposed candidates, not approved stack mandates.** The architecture defines 8 **logical components** (LC-01..08), not 8 microservices. No final DB schema, API schema, AI model, prompt, deployment, authentication flow, or design system is specified by this PDF. Engineering may choose replaceable implementations that preserve product semantics; log material deviations and seek review for behavior-changing decisions.

Avoid inventing opaque model confidence scores. Use curated mathematical references, bounded AI outputs, strong type/schema validation, error handling, and test cases appropriate to whichever approach is approved. A structured AI response is **not** mathematical truth or a valid diagnostic outcome without requisite checks.

## 4A. Visual design and gamification policy (supplemental project documents)

### 4A.1 Document status, ownership, and precedence

| Document | Role | Status / permitted use |
|---|---|---|
| `docs/design/DESIGN.md` | Rethink *visual style reference* supplied separately by the product team | Apply its brand colors, typography, spacing, radii, card/button styles, and motion when implementing UI; **not** permission to change learning behavior or claim design usability is validated. |
| `docs/design/gamification-specification.md` | Three mechanisms: learning-loop progress, contextual positive feedback, concept achievement | **PROPOSED design/engineering extension**, not a change to the approved 39 FRs. Implementation requires the relevant product approval, and any OI/OPS dependencies remain open. |
| `docs/design/gamification-acceptance-tests.md` | Proposed scenario and quality verification inventory | Use as *test-design input*; passing a proposed test does not by itself approve new product behavior or resolve pending decisions. |
| `docs/design/README.md` | Navigation and scope for design additions | Read before selecting design files. |

**Do not confuse visual fidelity with feature authorization.** The original 133-page PRD PDF did not contain a complete standalone app-screen design specification. The subsequently uploaded `DESIGN.md` supplies a **style reference**, not missing approved screen flows, API contracts, or business rules.

### 4A.2 Applying DESIGN.md appropriately

- Reuse the actual user-provided brand vocabulary: pale sky `#ebf5ff` canvas, bone-white `#fafdff` cards, ink `#0a0d12` text, charcoal `#181d27` filled CTAs, blue `#0069e0` emphasis, restrained pastel accent washes, soft rounded geometry, generous spacing, Aeonik headings and Geist UI/body (use documented substitutes when unavailable).
- The source style guide describes a **marketing/editorial site** with 148px hero headings, 3D imagery, marquee and large landing-page sections. Those are **reference patterns**, not mandatory on diagnostic questions, math input, Guided Learning, validation, or mobile flows. Translate the visual system to task-focused learning screens with readable, responsive, accessible density. Don't force giant headings/3D mascots into every assessment surface.
- Preserve UX semantics: accurate progress labels, math notation legibility, focus/keyboard controls, accessible labels, adequate contrast, and reduced-motion handling take priority over decorative fidelity. Flag any token-level contrast or usability problem rather than silently making a learning task inaccessible.
- Don't introduce new colors, typographic hierarchy, shadows, or components casually when existing `DESIGN.md` patterns work; deviations must be explained as accessibility/functional needs or proposed design extensions. Do not redistribute proprietary font files.
- Keep the original uploaded style guide intact; update the design system only through an explicit design review.

### 4A.3 Three gamification mechanisms and hard boundaries

1. **Learning-loop progress** displays journey stage / activity completion; it is **not a mastery percentage**. Q4 is conditional; non-confirmed diagnoses have valid alternate exits. Stage progress may not misrepresent unfinished or inapplicable steps.
2. **Contextual positive feedback** uses factual, evidence-specific, actionable language. No mathematical correctness hint leaks between diagnosis questions. Feedback in C4 must wait on `OPS-01`, `OPS-02`, and `OPS-04` where relevant; C5 grading and response handling depend on `OPS-03/04`.
3. **Concept achievement** is a **proposed recognition layer** triggered only by an applicable, valid C5 `Understood` outcome after successful Independent Retry *and* Transfer Problem. Never grant on topic selection, diagnosis `Confirmed`, C4 completion, UI-only events, uncertain evidence, or an unapproved Optional Review validation path (`OI-02`). The badge does **not** mean SPL mastery.

- Gamification consumes the verified underlying C1–C5/FR-X state; it never adjudicates diagnosis, evaluates math, changes learner state, or becomes a sixth capability.
- Avoid adding XP, coins, streaks, leaderboards, random rewards, timer pressure, adaptive quizzes, or collectible economies without separate reviewed scope approval.
- Presentation/prototype work may proceed independently where safe. Clearly label demonstrations/mocks as non-authoritative if product rules are pending. Only enable new user-facing behavior after required approvals.
- For relevant changes consult the matching `GAM-*` scenarios, then baseline FR tests and `V-X-01..08`; verify duplicate-event, refresh/resume, invalid evidence, partial completion and Optional Review cases. Report **proposed-test** status separately from approved FR verification.

## 4B. Onboarding documentation policy (proposed)

Onboarding is an **activation layer**, not a new C1–C5 capability and not proof of learning. The current app has a five-step, activity-gated onboarding (name, core loop, sample MCQ, chatbot preview, ready). `docs/design/onboarding-*` describe this flow plus proposed audio narration; do not claim per-slide recorded audio or optional account linking is implemented.

Before changing onboarding, read:

- `docs/design/onboarding-specification.md`
- `docs/design/onboarding-audio-script.md`
- `docs/design/onboarding-acceptance-tests.md`
- `docs/design/DESIGN.md`
- `docs/design/gamification-specification.md`
- `docs/design/references/onboarding/`

Hard constraints:

1. **Product truth:** onboarding must present Rethink as an evidence-bounded conceptual recovery platform, not a generic all-topic tutor, homework solver, mastery certifier, or unconstrained chatbot.
2. **No unsupported claims:** do not promise guaranteed improvement, full curriculum coverage, certain diagnosis, mastery, or fixed session duration.
3. **Visual language:** use `DESIGN.md` and the existing asset palette; do not add colors or components casually.
4. **Audio:** optional Bahasa Indonesia companion, default on when an asset is available, with a visible reversible mute toggle (no separate audio-preference slide). Onboarding must be fully usable without audio. No overlapping playback or autoplay after mute.
5. **Gamification:** onboarding may only preview progress, feedback, and achievements. It must not grant real learner states or concept achievements, or imply mastery from preview interaction or C4 completion.
6. **Activation:** the current MVP uses an **anonymous guest session**. Account creation is not a mandatory onboarding gate; account linking is optional/future and must not block the first session.
7. **Content integrity:** non-MVP topic visuals must be labelled as preview/orientation, not supported recovery paths. A preview of diagnosis is not a diagnosis.
8. **Accessibility:** mobile-first, touch-friendly, screen-reader labels, reduced-motion support, readable contrast, and no audio-only instructions.
9. **Evidence status:** report proposed onboarding tests separately from approved FR verification. Do not mark a proposed behavior Passed until it is implemented and executed.
10. **Persistence:** onboarding completion should persist. The explicit `RETHINK_REPLAY_ONBOARDING` testing flag is not release behavior; disable it when testing persistence. The current flow is non-skippable; do not add a skip path without review.

## 4C. UX writing and copy governance (proposed)

Before writing or changing user-facing copy, read `UX-WRITING.md`, the relevant IDs in `ux-writing-copy-bank.md`, and the applicable scenarios in `ux-writing-acceptance-tests.md`.

Hard rules:

1. **Status:** these are **PROPOSED** content standards, not approved FRs. Approved PRD semantics always win.
2. **Voice:** “teman belajar yang cerdas, santai, dan nggak menghakimi.” The voice may be inspired by published Gojek content-design principles, but Rethink must use its own original wording. Do not copy Gojek slogans, campaign lines, jokes, illustrations, or imply affiliation.
3. **Precedence:** clear → truthful → actionable → empathetic → expressive. A friendly line that obscures evidence or implies unearned mastery is a defect.
4. **Stable IDs and statuses:** use the copy bank's stable IDs; `SAFE-DRAFT`, `CONDITIONAL`, `BLOCKED`, and `PREVIEW` have distinct meanings. Never ship `BLOCKED` copy; use `CONDITIONAL` only from the actual state; never present `PREVIEW` as a real diagnosis, learner state, or achievement.
5. **No runtime LLM adjudication:** do not let generated copy choose, soften, or replace C3 diagnostic outcomes or C5 learner states. Messages are data-bound to authorized state.
6. **Terminology integrity:** preserve the locked meanings of `Confirmed`, `Rejected`, `Uncertain`, `Understood`, `Procedural Only`, `Needs Reinforcement`, optional review, retry, and transfer. Do not use “paham”, “menguasai”, or “gagal” to overwrite the approved state model.
7. **OI/OPS gates:** all-correct diagnosis copy (`OI-03`), post-Optional-Review validation (`OI-02`), guided-practice feedback/completion (`OPS-01/02`), ambiguous/equivalent validation responses (`OPS-03`), curated item text (`OPS-04`), and transition/persistence copy (`OPS-05`) remain blocked or conditional until approved.
8. **Error integrity:** distinguish user input, mathematical ambiguity, network failure, unavailable service, and unsupported capability. Never blame the learner for a technical failure. Claim `tersimpan` only after persistence acknowledgment.
9. **Audio/copy sync:** visible text and narration must carry equivalent meaning. Provide on-screen equivalents; mute must stop audio immediately; no overlapping narration. Current onboarding defaults audio on when available, with a visible mute control and no separate audio-preference slide; this default remains a product-review item.
10. **Current onboarding:** five activity-gated steps: name → core-loop taps → sample MCQ → chatbot preview → ready. Do not reintroduce slide pickers, swipe bypass, mandatory account creation, or an audio preference slide without review. Do not imply the sample MCQ is diagnosis or the chatbot is unrestricted.
11. **Current activation:** the app uses an anonymous guest session. Do not write mandatory-account, notification, retention, or duration promises unless the corresponding capability is approved and implemented.
12. **Verification:** report UX-writing tests as `PASS`, `FAIL`, `BLOCKED BY DECISION`, or `NOT RUN`; do not claim a proposed copy standard or a test list as executed evidence.

Copy approval states are editorial workflow labels (`DRAFT`, `REVIEW_NEEDED`, `APPROVED_FOR_DESIGN`, `APPROVED_FOR_RELEASE`, `BLOCKED_BY_DECISION`, `DEPRECATED`), not PRD statuses.

## 5. Required implementation procedure for every task

1. **Scope:** State requested behavior, touched capability IDs and FR IDs; read exact approved requirement wording. For UI work check `docs/design/DESIGN.md`; for user-facing copy check `UX-WRITING.md` and the relevant copy-bank IDs/statuses; for gamification check the applicable proposed design and GAM acceptance tests.
2. **Dependencies:** Consult `docs/decisions.md`; list OI/OPS items gating this task. If a source document and a new task conflict, report the discrepancy.
3. **Design:** Specify accepted, proposed, and unresolved behavior separately. Keep new stack decisions separate from product requirements.
4. **Implement narrowly:** Smallest cohesive vertical slice. Don't build beyond approved MVP or falsify unsupported states to fill UX gaps.
5. **Verify:** Test normal, non-confirmed, uncertain, invalid, interrupted and boundary cases relevant to the task. Include mathematical reference checks, integration transitions and (for gamification) relevant proposed `GAM-*` scenarios, plus visual accessibility/responsiveness checks.
6. **Report:** Files changed; requirements covered; copy IDs/statuses touched; scenarios passed/failed/not tested; assumptions; unresolved blockers; expected next decision. **No claim that untested is verified.**

For code generation, produce tests consistent with source requirement IDs rather than business logic invented by the agent. Keep originals and source provenance intact. Favor pure functions for math/evidence/state mapping, deterministic fixtures, reproducible cases, and explicit domain types.

## 6. Verification and claim governance

- Source success conditions: `SC1` end-to-end path, `SC2` evidence decision integrity, `SC3` outcome continuation, `SC4` separately tested comprehensible UX.
- Source dimensions: `D1` functional, `D2` decision integrity, `D3` usability & interpretability, `D4` learning outcomes. **Never conflate** these dimensions.
- Verification categories: `V-X-01..08`; concrete test fixtures, thresholds, all-correct output and post-review behavior are not final where open dependencies apply.
- Every FR uses statuses **Passed / Failed / Untested / Blocked by pending decision** (engineering-report convention; not a claim this test scheme is source-approved). Keep source `Approved` status separate from implementation/test status.
- Do not claim causal learning gains, population-level diagnostic accuracy, statistical mastery, SPL topic mastery, or broad scale performance from a single demo/test.

## 7. Constraints on documentation changes

- Never edit archival `docs/source/` transcription or source PDF to retrofit newer decisions. Update derivative documents transparently, version the decision record, and link back to source page numbers.
- Do not rewrite approved FRs to make engineering easier. File a change proposal with product impact, alternatives, risks, and verification impact.
- If user asks to update one document, inspect affected dependency docs and note if a cross-document update is necessary.
- Sensitive student response data should be minimized and handled appropriately; this is a general engineering precaution, **not** a source-defined retention policy.
- The original PDF has no complete standalone **Design Requirements** chapter; source-derived UX obligations remain in C1–C5 and FR-X. The separately uploaded `docs/design/DESIGN.md` is now available as a **visual design reference**, not an approved screen-by-screen functional design. `docs/design/gamification-*` are **proposed experience specifications**, not replacements for the missing approved UX decisions.

## 8. First action for a new Codex work session

Read `docs/INDEX.md` and `docs/decisions.md`; state which approved requirement(s) the proposed code change serves. For visual/UI tasks also read `docs/design/README.md` and the relevant parts of `docs/design/DESIGN.md`; for gamification tasks, inspect its proposed specification and acceptance tests. For broad engineering tasks, inventory repository and give a prioritized vertical-slice plan before implementation. Do not require reloading all 133 archival pages unless a disputed detail actually needs them.

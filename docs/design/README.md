# Rethink — Design Documentation Index

> **Status and provenance:** This folder combines a **user-supplied visual style reference** with **PROPOSED onboarding, gamification and UX-writing specifications**. None of these overrides the approved PRD v1.0, 39 functional requirements, or pending OI/OPS decisions. The original PRD PDF remains at `../source/ReThink-Documentation-original.pdf`.

## Files

| File | Description | Status |
|---|---|---|
| [`DESIGN.md`](DESIGN.md) | Rethink **visual style reference** supplied by the project team: pale sky canvas, near-black CTAs, Aeonik/Geist typography, spacing, shape, cards, illustration, animations, CSS and Tailwind variables | **User-provided design reference**; preserved verbatim |
| [`ui-refresh-notes.md`](ui-refresh-notes.md) | Native iOS visual implementation, affected screens and verification scope | Engineering notes, 18 October 2026; no product-policy changes |
| [`onboarding-specification.md`](onboarding-specification.md) | Proposed end-to-end onboarding flow, screen logic, copy direction, audio behavior, gamification hooks, accessibility and implementation rules | **PROPOSED**; not approved new FRs |
| [`onboarding-audio-script.md`](onboarding-audio-script.md) | Proposed Bahasa Indonesia voiceover script, per-screen audio keys, toggle behavior and accessibility guidance | **PROPOSED**; `onboarding-1a.mp3` and `onboarding-1b.mp3` exist for the first slide; other narration files are future work, with `dummy-audio.mp3` fallback when present |
| [`onboarding-acceptance-tests.md`](onboarding-acceptance-tests.md) | Proposed QA scenarios for onboarding flow, anonymous guest activation, audio, motion, content integrity, design and accessibility | **PROPOSED**; test definitions, not executed results |
| [`gamification-specification.md`](gamification-specification.md) | UX and engineering proposal for learning-loop progress, contextual positive feedback, concept achievement; edge cases, copy, model, ownership and dependencies | **PROPOSED**; not approved new FRs |
| [`gamification-acceptance-tests.md`](gamification-acceptance-tests.md) | Proposed tests for gamification, including exceptional outcomes, repeat/reload, state authority, accessibility | **PROPOSED**; test definitions, not executed results |
| [`UX-WRITING.md`](UX-WRITING.md) | Proposed voice, tone, Indonesian language conventions, locked terminology, screen-level copy direction, error/audio/onboarding rules and implementation contract | **PROPOSED**; not approved new FRs |
| [`ux-writing-copy-bank.md`](ux-writing-copy-bank.md) | Indonesian copy candidates with stable IDs and usage status (`SAFE-DRAFT`, `CONDITIONAL`, `BLOCKED`, `PREVIEW`) | **PROPOSED**; blocked IDs cannot ship |
| [`ux-writing-acceptance-tests.md`](ux-writing-acceptance-tests.md) | Proposed UX-writing QA scenarios covering language, diagnosis/validation copy, errors, accessibility and governance | **PROPOSED**; not executed results |

## Reference assets

Onboarding visual references are stored in:

```text
docs/design/references/onboarding/
```

These are inspiration for composition, interaction quality, motion ambition, pacing and emotional tone. They must not be copied blindly. Rethink must preserve its own product truth, approved MVP scope, design system, and accessibility constraints.

## Reading order for Codex

1. `../../AGENTS.md` → `../INDEX.md` → `../decisions.md`.
2. For visual UI work, read the relevant tokens/components from `DESIGN.md` and the specific baseline FRs.
3. For onboarding work, read `onboarding-specification.md`, `onboarding-audio-script.md`, and applicable scenarios in `onboarding-acceptance-tests.md`.
4. For any user-facing copy, read `UX-WRITING.md` and the relevant IDs in `ux-writing-copy-bank.md`; respect each ID's status. Use `ux-writing-acceptance-tests.md` for proposed QA.
5. For progress/feedback/achievements, read the relevant sections of `gamification-specification.md` and applicable scenarios in `gamification-acceptance-tests.md`.
6. For implementation logic, read `../prd/mvp-definition.md`, `../prd/requirements.md`, and `../technical/architecture.md` selectively.
7. If a proposed design conflicts with approved behavior, **do not implement the conflict**. Record the gap and request explicit review.

## Important scope distinction

`DESIGN.md` mostly describes an **editorial/marketing-web style** (for example 148px hero, oversized cards, marquees and decorative 3D objects). Reuse the brand *tokens and visual language* for learning-app screens, but do not force marketing compositions into math assessment workflows. Prioritize clear questions, accessible math input, readable body type, responsive density, understandable feedback, and predictable focus/navigation.

**Approved functional authority:** PRD + 39 FRs in `../prd/`. **Open:** `OI-01..03`; **Pending:** `OPS-01..05`. Onboarding, gamification and UX-writing documents are proposals and do not close them. No achievement from C4 completion; never expose correctness mid-diagnosis, assign mastery to unassessed concepts, or activate Optional Review validation without OI-02 approval. `BLOCKED` copy IDs in the copy bank must not be shipped, and `PREVIEW` copy can never represent a real learner outcome.

The current app uses an **anonymous guest session**; account creation is not required for the first session. Onboarding plans for account linking are optional/future and must not become a mandatory login wall.

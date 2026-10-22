# Rethink — Onboarding Specification

> **Status:** **PROPOSED — not PRD-approved.** This document is a design/engineering proposal, not a new approved functional requirement. Approved PRD v1.0 and the 39 FRs remain authoritative. OI-01..03 and OPS-01..05 remain open/pending.

**Owner:** Product / Design / UX  
**Last updated:** 2026-10-18  
**Companions:** [`onboarding-audio-script.md`](onboarding-audio-script.md), [`onboarding-acceptance-tests.md`](onboarding-acceptance-tests.md), [`DESIGN.md`](DESIGN.md), [`gamification-specification.md`](gamification-specification.md)

## 0. Current implementation snapshot

The current onboarding is a **five-step, activity-gated flow**:

1. **Kenalan** — learner must enter a name before continuing.
2. **Cara kerja** — learner must tap all three steps: Cek → Belajar → Coba.
3. **Cek singkat** — learner must answer one sample multiple-choice math question.
4. **Tanya konsep** — learner must tap a suggested chatbot question to reveal a short answer.
5. **Siap** — final CTA starts the first session.

Implementation details:

- `OnboardingPage`, `OnboardingViewModel`, `OnboardingView`, `OnboardingScenes`.
- `Next` is disabled until the current activity is complete.
- There is no slide picker, no page counter, and no audio-preference slide.
- Audio is optional and played per eligible slide. Slide 1 uses `onboarding-1a.mp3` for the Jimmy intro and `onboarding-1b.mp3` for the name question, with a one-second gap after the intro audio. Slides 2–5 use `onboarding-2.mp3` through `onboarding-5.mp3`; missing files fall back to `dummy-audio.mp3` when present, otherwise the slide is silent. A mute/unmute control sits at the top right without a circular container.
- The current flow is **not skippable** so the activities are actually performed.
- After onboarding, the app activates an **anonymous guest session**; account creation is not required.
- Name is stored locally and used for the Home greeting.
- `AppConfig.replaysOnboardingForTesting` currently replays onboarding on every launch unless `RETHINK_REPLAY_ONBOARDING=0`. This is a testing preference, not a product requirement.

The proposed direction below matches this implementation and leaves account linking as an optional future step.

## 1. Purpose

Onboarding is a short guided activation sequence. It should:

- create a calm, premium first impression;
- explain Rethink as a conceptual recovery platform;
- let the learner act rather than read a feature list;
- reduce uncertainty before the first session;
- remain audio-optional and accessible;
- avoid overclaiming.

## 2. Product alignment

Rethink is an AI-assisted mathematics **conceptual recovery** platform. Onboarding must not frame it as:

- a generic homework solver;
- an all-subject tutor;
- a full curriculum;
- a mastery certification product;
- an unrestricted chatbot.

Onboarding frames Rethink as a place to:

1. check understanding,
2. find a possible prerequisite concept that blocks progress,
3. learn that concept with guided support,
4. validate independent application and transfer,
5. build confidence step by step.

Non-MVP topics, if shown at all, must be labelled as preview/orientation examples.

## 3. Experience principles

- **Calm, premium, human.** Not noisy, corporate, or arcade-like.
- **Action before explanation.** The learner performs a small relevant activity instead of reading a feature list.
- **One idea per screen.** Avoid dense paragraphs.
- **Audio-optional.** Every voice line has an on-screen equivalent; mute is always available.
- **Product integrity.** Completion of onboarding is not learning evidence; preview interactions are not diagnosis or mastery.

## 4. Goals and non-goals

### Goals
1. Explain the core loop simply.
2. Show one realistic sample question.
3. Introduce the concept-focused chatbot.
4. Learn the learner’s preferred name.
5. Lead directly into the first supported session.

### Non-goals
- Full product tutorial.
- Placement test.
- Long survey.
- Mandatory account creation.
- Notification permission.
- Real diagnostic or learner-state assignment.

## 5. Interaction gate model

Each step owns a required action. `Next` remains disabled until the action is complete.

| Step | Required action | Gate |
|---|---|---|
| Kenalan | Enter a name | Trimmed name length ≥ 2 |
| Cara kerja | Tap all three steps | Three steps visited |
| Cek singkat | Choose one math option | Any option selected |
| Tanya konsep | Tap the suggested chatbot question | Chat opened once |
| Siap | None | Always enabled |

Swipe-to-skip and slide pickers are intentionally absent. The back button remains available after step 1.

## 6. Screen flow

Five screens maximum before the first session:

1. Welcome + name
2. Core concept: Cek → Belajar → Coba
3. Sample quick check (MCQ)
4. Chatbot concept explanation
5. Ready

Optional future step (not part of the current flow): account linking from Profile or after meaningful progress.

## 7. Screen specification

### Screen 1 — Welcome + name

**Intro:** `Hai, aku Jimmy! Aku akan membimbing kamu.`  
**Question:** `Siapa nama kamu?`

The two text blocks use the same display style, with a clear vertical gap between Jimmy’s introduction and the name question.

**Activity:** text field `Nama kamu`.

**Why:** makes the experience personal and forces an intentional first action.

**Copy:** helper: `Nama dipakai untuk menyapa kamu.`

**Gate:** non-empty name (minimum two characters).  
**Audio:** short welcome line.  
**Visual:** typewriter intro → gap → typewriter question → text settles → illustration enters → form enters. No fade-in for the text characters.

---

### Screen 2 — Core concept (“Jalur Petualangan”)

**Title:** `Cek, belajar, lalu coba.`

**Activity:** a curved path with three nodes:
1. Cek — collect evidence from answers.
2. Belajar — understand the concept with guidance.
3. Coba — apply it independently.

The learner drags a glowing token from the start point to Cek, then Belajar, then Coba. Each node snaps, lights up, and reveals one short line. Tapping the next node is the accessibility fallback.  
**Gate:** all three nodes visited.  
**Audio:** one short line describing the loop.  
**Constraint:** this is a preview of the product loop; it does not imply mastery or a guaranteed outcome.

---

### Screen 3 — Sample quick check

**Title:** `Contoh cek singkat.`

**Activity:** one multiple-choice math question:

`Bentuk mana yang setara dengan 3(x + 2)?`

Options:
- A. `3x + 6`
- B. `3x + 2`
- C. `3x + 5`

**Gate:** an option is selected. No correctness is revealed.  
**Label:** `CONTOH · BUKAN DIAGNOSIS`.  
**Audio:** short line clarifying that the real evaluation happens in the actual session.  
**Constraint:** this is not a diagnostic item, not a score, and not evidence of mastery.

---

### Screen 4 — Concept chatbot

**Title:** `Tanya konsep, bukan minta jawaban.`

**Activity:** tap the suggested question:

`Kenapa 3(x + 2) = 3x + 6?`

A short assistant answer appears: `Karena 3 dikalikan ke x dan ke 2.`

**Gate:** the question has been tapped once.  
**Audio:** short line explaining that the chatbot helps explain concepts, not replace thinking.  
**Constraint:** do not claim a live unrestricted chatbot, guaranteed answer quality, or replacement of independent reasoning.

---

### Screen 5 — Ready

**Title:** `Siap mulai?`

**Content:** greeting with the learner’s name if available; `Tanpa akun · mode tamu`; a single primary CTA `Mulai`.

**Gate:** always enabled.  
**Action:** complete onboarding and continue to the supported session entry (currently Explore).  
**Audio:** short ready line.  
**Constraint:** do not promise a fixed session duration.

## 8. Copywriting guidelines

Tone: friendly, clear, human, light, confident, not robotic or corporate.

Preferred:
- “nggak apa-apa”
- “pelan-pelan”
- “biar lebih yakin”
- “langkah demi langkah”
- “mulai dari yang paling relevan”

Avoid:
- “Sistem kami akan mengoptimalkan pengalaman pembelajaran Anda.”
- “Platform ini secara komprehensif mendukung kebutuhan edukasional Anda.”
- Guaranteed improvement, mastery, full curriculum coverage, or certain diagnosis.

## 9. Visual design rules

Follow `DESIGN.md` and the asset palette in `Assets.xcassets/Colors`:

- `SkyTint` — canvas (currently `#F6FAFF`, intentionally whiter than the original reference)
- `Paper` — cards
- `Ink` — headings
- `Charcoal` — filled CTA
- `IrisBlue` — accent
- Pastel washes — restrained use only
- `Line` — borders

Keep one dominant visual per screen. Do not fill the screen with paragraphs. Do not add new colors casually. Preserve contrast, tap targets, focus order, and reduced-motion behaviour.

## 10. Interaction and motion

- Back button is available after the first step.
- Forward navigation is button-driven; no swipe bypass.
- Activity feedback is immediate: selected option, visited step, revealed chat answer.
- Use soft entrance, small scale/settle, and restrained progress fill.
- Respect Reduce Motion.
- Do not delay the CTA with long animations.

## 11. Audio strategy

- Audio is optional and played per eligible slide.
- Default is **on** when audio is available; the learner can mute at any time.
- The mute/unmute control sits at the top right and has no decorative circular background.
- Muting stops current playback immediately.
- Each screen has a short voice line from [`onboarding-audio-script.md`](onboarding-audio-script.md).
- No separate audio-preference screen.
- No overlapping playback; audio stops when the app backgrounds.
- The flow must work fully without audio.
- Current assets: `onboarding-1a.mp3` for the Jimmy intro and `onboarding-1b.mp3` for the name question, with a one-second gap after the intro audio. Slides 2–5 use `onboarding-2.mp3` through `onboarding-5.mp3`; missing files fall back to `dummy-audio.mp3` when present, otherwise the slide is silent.

## 12. Gamification hooks

Onboarding may preview:
1. the learning-loop sequence,
2. progress orientation,
3. future recognition language.

But it must not:
- grant XP, streaks, coins, or real achievements;
- assign learner states;
- imply mastery from preview interaction;
- replace the backend C5 validation path.

See [`gamification-specification.md`](gamification-specification.md). That document is **PROPOSED**.

## 13. Technical structure

Current files:

```text
Models/Onboarding/OnboardingPage.swift
ViewModels/Onboarding/OnboardingViewModel.swift
Services/Onboarding/OnboardingAudioController.swift
Services/Onboarding/OnboardingPreferenceStore.swift
Views/Onboarding/OnboardingView.swift
Views/Onboarding/OnboardingScenes.swift
Views/Onboarding/OnboardingMotion.swift
```

Current persisted state:
```text
onboarding.started
onboarding.completed
onboarding.skipped
onboarding.audioEnabled
onboarding.learnerName
onboarding.lastScreen
```

The `Next` gate is derived from `OnboardingViewModel.canAdvance`. Do not bypass it in a new UI path.

## 14. Accessibility

- Complete onboarding without audio.
- Visible mute/unmute with clear label and value.
- Screen-reader labels for back, progress, mute, input, options, and CTA.
- Do not rely on colour alone.
- Support Dynamic Type and reduced motion.
- Large tap targets.
- Keep helper text short and readable.

## 15. Content constraints

Do not claim:
- broad topic support beyond approved/previewed scope;
- guaranteed improvement;
- full curriculum coverage;
- certain diagnosis without evidence;
- fixed session duration;
- that the sample MCQ or chatbot interaction is a real diagnosis.

## 16. Implementation priority

1. Keep the five-step activity gate working.
2. Persist name and completion; keep the testing replay flag explicit.
3. Keep audio per slide with mute and no separate audio screen.
4. Add per-slide audio assets later.
5. Add optional account linking only after product approval.

## 17. Success signals

- learner understands the core loop;
- learner can identify what the sample check is and is not;
- learner reaches the first session;
- no confusion about whether the chatbot replaces their thinking;
- audio can be muted without blocking progress.

These are proposed signals, not proven outcomes.

## 18. Open questions

1. Should audio default on or off for public release? Current implementation: on, with mute.
2. Should onboarding remain non-skippable? Current implementation: yes.
3. Should account linking appear after the first session? Not implemented; optional/future.
4. Should the sample MCQ provide any feedback? Current implementation: no correctness.
5. Should per-slide audio use separate files or one placeholder? Current: one placeholder.

## 19. Reference assets

Visual inspiration is stored in [`references/onboarding/`](references/onboarding/README.md). These are references, not approved screen specifications. Rethink's product truth, design system, and accessibility constraints take precedence.

## Slide 2 revision — user direction, 19 October 2026

The user requested replacing the token activity with an explanation of the learner's friction and Rethink's value, accompanied by Jimmy. Slide 2 now uses existing SAFE-DRAFT copy (`ob.welcome.title/body`, `ob.value.title/body`, `ob.loop.step.1–3`, `ob.current.loop.step.1–3`). It is informational: continuing does not require taps or dragging. This supersedes the three-node activity gate for slide 2 only; the other onboarding gates remain. No learning evidence or state is awarded. The old token narration is suppressed pending a matching recording. Earlier token/drag acceptance scenarios are superseded for this slide; replacement visual and accessibility checks have not been run.

## Slide 3 revision — user direction, 19 October 2026

Replace the single sample MCQ with five draft familiarity examples, following references IMG_8682–8685: Jimmy instruction bubble, expanded active card, three self-report choices, collapsing answered rows, editable answers, and final confirmation. Continue unlocks only after five responses and confirmation. This supersedes the single-MCQ gate for slide 3; it adds no diagnostic or learning evidence. Answers remain in the onboarding view model, including on back navigation, and are not submitted to the backend. Motion respects Reduce Motion. Old sample-MCQ narration is suppressed pending a matching recording. Copy IDs: `ob.familiarity.*` (PREVIEW). Verification status: NOT RUN at the user's request; no build or app launch performed. Prior single-MCQ acceptance expectations require revision.

## Slide 4 revision — user direction, 19 October 2026

Curated chat simulation with Jimmy, two suggested questions, staged replies, a local preparing indicator, and tappable distributive products. Uses 2(x + 4), not the diagnostic item. No free-form chat, backend request, grading, or evidence persistence. Continue unlocks after a complete reply; no understanding claim is made. View model owns reply timing/cancellation; view owns presentation, scrolling, and reduced-motion transitions. Existing onboarding completion semantics remain. Copy: `ob.chat.preview.*` PREVIEW; title uses `ob.visual.title`. Build, runtime, visual, VoiceOver, and motion checks: NOT RUN at the user's request.

### Developer bypass — user direction, 19 October 2026

DEBUG builds expose “Skip dev →” to advance without completing the current activity. On the last slide it exits onboarding without persisting completion or fabricated activity evidence. This explicitly authorized testing shortcut is compiled out of Release; production gates remain unchanged. Verification: NOT RUN per user instruction.

### Slide 3–4 elevation — user direction, 19 October 2026

User explicitly requested stronger card shadows as a visibility exception to DESIGN.md's flat content-card rule. Both slides share a restrained two-layer blue/ink shadow, existing Paper/Sky surfaces, and existing pastel tokens. Slide 3 limits wash accents to PowderBlue/Mint; symbols and labels retain choice meaning without implying grading. No new color assets or learning behavior. Visual verification NOT RUN per user instruction.

### Semantic choices and viewport boundaries — user direction, 19 October 2026

Slide 3 Belum uses a soft red asset; Ragu uses amber; Bisa retains Mint. User explicitly authorizes this semantic-color exception. These are self-report choices, not correct/incorrect grades. Slides 3–4 use screen-width scroll viewports with inset card content and vertical shadow space. Scroll clipping is restored to prevent history/chat from painting over headers or controls. Earlier two-wash and unclipped-scroll guidance is superseded. Verification NOT RUN.

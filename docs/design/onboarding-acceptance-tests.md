# Rethink — Onboarding Acceptance Tests

> **Status:** **PROPOSED — not PRD-approved.** These are test definitions, not executed results. Passing them does not approve new product behavior or resolve OI-01..03 / OPS-01..05.

**Companions:** [`onboarding-specification.md`](onboarding-specification.md), [`onboarding-audio-script.md`](onboarding-audio-script.md)

## 0. Current implementation baseline

Current onboarding is five activity-gated screens:

1. Welcome + name
2. Core concept (three taps)
3. Sample MCQ
4. Concept chatbot (one tap)
5. Ready

Also current:

- `Next` is disabled until the required activity is complete.
- No slide picker, no page counter, no swipe bypass, no skip button.
- Audio is played per slide from one placeholder file; mute/unmute is top right without a circular container.
- After onboarding, the app starts/uses an anonymous guest session.
- Name is saved locally and used in the Home greeting.
- `AppConfig.replaysOnboardingForTesting` can replay onboarding on every launch for testing.

## 1. Flow and activity gates

| ID | Scenario | Expected |
|---|---|---|
| OB-01 | First screen, no name | Next disabled |
| OB-02 | Enter one character | Next remains disabled |
| OB-03 | Enter at least two non-space characters | Next enabled |
| OB-04 | Tap Next on concept screen before tapping all three steps | Next disabled; only visited steps reveal detail |
| OB-05 | Tap Cek, Belajar, Coba | All three expand; Next enabled |
| OB-06 | Quick check with no option selected | Next disabled |
| OB-07 | Select any MCQ option | Selection is highlighted; Next enabled; no correctness claim |
| OB-08 | Chatbot screen before tapping the suggested question | Next disabled |
| OB-09 | Tap the suggested chatbot question | Short answer appears; Next enabled |
| OB-10 | Ready screen | Primary CTA `Mulai` enabled |
| OB-11 | Back button after first screen | Returns to previous screen; activity state remains |
| OB-12 | No slide picker or page counter exists | Only back/progress/mute are present |
| OB-13 | Swipe forward | Does not bypass the activity gate |

## 2. Completion and activation

| ID | Scenario | Expected |
|---|---|---|
| OB-C-01 | Tap `Mulai` | Onboarding completes and the app enters the first-session entry (Explore) |
| OB-C-02 | Completion | Name is saved locally and appears in Home greeting after reload |
| OB-C-03 | Relaunch with `RETHINK_REPLAY_ONBOARDING=0` | Completed onboarding is not shown again |
| OB-C-04 | Relaunch with testing replay enabled | Onboarding is shown again intentionally |
| OB-C-05 | Anonymous guest activation | No email/password or account wall appears |
| OB-C-06 | Optional account linking | Not required for this flow |

## 3. Audio behavior

| ID | Scenario | Expected |
|---|---|---|
| OB-A-01 | Fresh install, audio asset available | Audio preference defaults to on |
| OB-A-02 | Enter each screen | Current screen audio plays when enabled |
| OB-A-03 | Tap mute | Current audio stops immediately; icon changes |
| OB-A-04 | Navigate while muted | No audio plays |
| OB-A-05 | Tap unmute | Current eligible screen audio plays |
| OB-A-06 | Fast page changes | No overlapping playback |
| OB-A-07 | App backgrounds | Audio stops/pauses |
| OB-A-08 | Audio asset missing | Onboarding works; no crash; mute control remains understandable |
| OB-A-09 | Audio preference slide | Does not exist |
| OB-A-10 | Mute button appearance | Top right, no circular background container |

## 4. Interaction and motion

| ID | Scenario | Expected |
|---|---|---|
| OB-I-01 | Tap concept cards | Detail reveals; checkmark appears; animation soft |
| OB-I-02 | Tap rapid multiple times | No duplicate or broken state |
| OB-I-03 | Reduced Motion enabled | No large/sweeping transitions; functionality unchanged |
| OB-I-04 | CTA during animation | No dead lock; action remains usable |
| OB-I-05 | Screen reader | Back, progress, mute, input, options, and CTA have meaningful labels |
| OB-I-06 | Dynamic Type | Content remains readable without clipping the CTA |

## 5. Content integrity

| ID | Scenario | Expected |
|---|---|---|
| OB-X-01 | Read onboarding | No claim of all-topic tutoring, full curriculum, or guaranteed improvement |
| OB-X-02 | Sample MCQ | Clearly labelled as example, not diagnosis |
| OB-X-03 | Chatbot preview | Does not claim unrestricted AI or replacement of thinking |
| OB-X-04 | Progress/achievement language | No XP, streak, coins, mastery percentage, or real achievement granted |
| OB-X-05 | Session duration | No fixed duration promise |
| OB-X-06 | Non-MVP topic visual | If present, labelled as preview/orientation |
| OB-X-07 | Name input | No unnecessary personal data beyond preferred name |

## 6. Design consistency

| ID | Scenario | Expected |
|---|---|---|
| OB-D-01 | Visual inspection | Uses `SkyTint`, `Paper`, `Ink`, `Charcoal`, `IrisBlue` assets |
| OB-D-02 | Typography | One clear title per screen; no dense paragraph blocks |
| OB-D-03 | Cards/buttons | Consistent radii, spacing, and CTA treatment |
| OB-D-04 | Audio control | No decorative circular background; clear icon and state |
| OB-D-05 | Progress | Segmented progress bar; no numbered page picker |
| OB-D-06 | Empty space | Content is balanced and not visually crowded |

## 7. Reporting

Statuses:

```text
PASS
FAIL
BLOCKED
NOT RUN
```

Do not report a proposed feature as PASS until it is implemented and executed. Passing onboarding tests does not establish usability, learning effectiveness, or PRD acceptance.

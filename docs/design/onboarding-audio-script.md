# Rethink — Onboarding Audio Script

> **Status:** **PROPOSED — not PRD-approved.** Current implementation uses `onboarding-1a.mp3` for the Jimmy intro and `onboarding-1b.mp3` for the name question, with a one-second gap after the intro audio ends. Other slides use `onboarding-2.mp3` through `onboarding-5.mp3`, with `dummy-audio.mp3` as fallback when present.

**Language:** Bahasa Indonesia  
**Tone:** warm, clear, calm, human  
**Mode:** optional, default on when audio is available  
**Control:** mute/unmute at the top right, no circular container  
**Companions:** [`onboarding-specification.md`](onboarding-specification.md), [`onboarding-acceptance-tests.md`](onboarding-acceptance-tests.md)

## 1. Audio strategy

Audio is a short companion layer for the five-step onboarding:

1. Welcome + name
2. Core concept
3. Sample quick check
4. Concept chatbot
5. Ready

It supports comprehension and warmth. It must not read every word on screen, overlap between slides, block navigation, or autoplay after the learner mutes it.

There is **no separate audio-preference slide**. The learner controls audio with the mute/unmute button.

## 2. Voice direction

- ramah
- tenang
- jelas
- cerdas tetapi santai
- tidak terlalu cepat
- tidak terlalu formal

Avoid TV-advertising tone, childlike delivery, robotic delivery, long sentences, and exaggerated claims.

## 3. Toggle behaviour

1. A visible mute/unmute control is available on every onboarding screen.
2. Default is **on** when the audio asset is available.
3. Turning audio off stops current playback immediately.
4. Turning audio on plays the current eligible screen’s audio.
5. No overlapping voiceovers.
6. Audio stops when the app backgrounds.
7. Onboarding remains fully usable with audio off.
8. No separate audio selection screen.

Current assets: `onboarding-1a.mp3` for the intro and `onboarding-1b.mp3` for the name question. Slides 2–5 use `onboarding-2.mp3` through `onboarding-5.mp3`; missing files fall back to `dummy-audio.mp3` when it is present, otherwise the slide is silent.

## 4. Per-screen script

### Screen 1 — Welcome + name

**Intro file:** `onboarding-1a.mp3`  
**Intro text:** “Hai, aku Jimmy! Aku akan membimbing kamu.”  
**Question file:** `onboarding-1b.mp3`  
**Question text:** “Siapa nama kamu?”  
**Timing:** after the intro audio ends, wait one second, then show the question and play the question audio. No overlap.

### Screen 2 — Core concept
**Proposed file:** `onboarding-2.mp3`  
**Text:**
“Alurnya sederhana: cek pemahaman, belajar dengan panduan, lalu coba sendiri.”

### Screen 3 — Sample quick check
**Proposed file:** `onboarding-3.mp3`  
**Text:**
“Ini contoh cek singkat. Di sesi nyata, jawabanmu dinilai oleh sistem, bukan di sini.”

### Screen 4 — Concept chatbot
**Proposed file:** `onboarding-4.mp3`  
**Text:**
“Chatbot membantu menjelaskan konsep, bukan menggantikan proses berpikirmu.”

### Screen 5 — Ready
**Proposed file:** `onboarding-5.mp3`  
**Text:**
“Siap? Yuk mulai sesi pertamamu.”

## 5. Forced-activity sync

Audio must not undermine the activity gate:

- Name screen: audio may invite the learner to type a name, but cannot auto-fill it.
- Concept screen: audio may describe the loop, but the learner still taps all three steps.
- Quick check: audio must not reveal the answer or imply correctness.
- Chatbot: audio must not pre-empt the learner’s tap or claim unrestricted AI capability.
- Ready: audio may invite starting; it must not auto-start the session.

## 6. Micro-audio suggestions

Optional:
- soft tap/selection;
- gentle progress fill;
- short chat reveal sound.

Avoid arcade sounds, harsh confirmations, repeated reward noise, and sounds that imply grading or mastery.

## 7. Content configuration

Do not hardcode long script text in views. Use a config with:

```text
screen_id
title
voice_script
audio_file_key
audio_enabled_default_behavior
```

The UI must render fully when audio files are absent.

## 8. Accessibility

- Provide on-screen equivalents for every voice line.
- Mute/unmute has an accessibility label and value.
- Do not rely on audio for essential instructions.
- Respect system audio, silent mode, and backgrounding.
- Audio must not create surprise transitions.

## 9. Implementation status

Current:
- `OnboardingAudioController` loads one local placeholder.
- Audio is played on `begin()` and each page change when enabled.
- Mute button is in `OnboardingView`.

Not implemented:
- Per-screen recorded narration.
- Per-screen audio keys in a content config.
- Detailed audio analytics.

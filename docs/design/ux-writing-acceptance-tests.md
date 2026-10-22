# Rethink — UX Writing Acceptance Tests

> **Status:** PROPOSED content-design QA suite; not evidence that tests have been executed.  
> **Location:** `docs/design/ux-writing-acceptance-tests.md`  
> **Read with:** [`UX-WRITING.md`](UX-WRITING.md), [`ux-writing-copy-bank.md`](ux-writing-copy-bank.md), `../decisions.md`.  
> **Result states:** PASS / FAIL / NOT TESTED / BLOCKED BY DECISION. A copy ID's editorial approval is different from implementation verification.

## 0. Execution rules

Test visual AND accessibility tree names. Use realistic phone widths, large text setting, screen reader, Android/iOS as applicable. For conditional tests, stub authorized C3/C5 state; don't use LLM output to create fake learner state. Treat blocked scenarios as blocked, **not passed**. Record screenshot/evidence and source IDs for each result.

## 1. Language and brand voice

| Test | Expected result |
|---|---|
| UX-001 | Main screens address learner as `kamu` or neutral wording, not inconsistent `Anda/lo/gue`. |
| UX-002 | No “AI ajaib/pasti tahu penyebab/100% akurat” promises. |
| UX-003 | Welcome reads naturally in Indonesian aloud and contains no technical jargon. |
| UX-004 | Headers describe task/state, not empty celebration or unexplained metaphor. |
| UX-005 | All primary CTAs describe an action actually available from that state. |
| UX-006 | Same action label is consistent across screens and accessibility labels. |
| UX-007 | Slang is understandable to grade X–XII participants from diverse backgrounds; no regional-joke dependency. |
| UX-008 | Typographic punctuation/capitalization follows `UX-WRITING.md`. |
| UX-009 | No user-blaming or intelligence-judging statements, even in fail cases. |
| UX-010 | Reviewer distinguishes documented Gojek principles from original Rethink proposals. |

## 2. Onboarding and audio

> **Current implementation note (19 Oct 2026):** the shipped onboarding is five activity-gated steps: name → core-loop taps → sample MCQ → chatbot preview → ready. It has no audio-preference slide, no slide picker, and no skip. Audio is per slide, default on when available, with a top-right mute control. The checks below supplement the older exploratory audio tests.

### 2.1 Current five-step onboarding checks

| Test | Expected result |
|---|---|
| OB-UX-01 | Name screen: two display text blocks (Jimmy intro, then name question) with a visible gap and no extra eyebrow/subtitle/footnote; `Lanjut` disabled until a non-space name of at least two characters is entered. |
| OB-UX-02 | Concept screen: `Lanjut` disabled until the token reaches all three nodes; drag and tap fallback both work; each node snaps, lights up, and reveals its short detail. |
| OB-UX-03 | Sample MCQ: `Lanjut` disabled until an option is selected; no correctness or mastery is shown. |
| OB-UX-04 | Chatbot screen: `Lanjut` disabled until the suggested question is tapped; answer appears after tap. |
| OB-UX-05 | No slide picker, page counter, swipe bypass, or skip control is present. |
| OB-UX-06 | Mute control is at the top right, has no decorative circular container, and exposes a correct accessible label/value. |
| OB-UX-07 | Audio plays per eligible slide when enabled; muting stops it immediately; no audio-preference slide exists. |
| OB-UX-08 | When `Lanjut` is disabled, a short helper explains that the activity must be completed. |
| OB-UX-09 | The sample MCQ is visibly labelled `Contoh · bukan diagnosis`; the chatbot note does not imply unrestricted AI or mastery. |
| OB-UX-10 | Completing the final step saves the name, stores completion, and proceeds to the first-session entry without an account wall. |
| OB-UX-11 | Slide 1 audio: intro cue plays while the Jimmy text renders; after it ends, wait one second, then show the name question and play the question cue; no overlap. |

### 2.2 Exploratory onboarding/audio checks

| Test | Expected result |
|---|---|
| UX-011 | Onboarding previews supported conceptual loop without promising all topics are active. |
| UX-012 | Preview concept achievement visibly labeled as example, never issued to real learner. |
| UX-013 | Onboarding content remains fully understandable when audio disabled. |
| UX-014 | Audio ON/OFF labels, toggle accessible names and actual state agree. |
| UX-015 | Turning audio OFF stops current narration immediately. |
| UX-016 | Navigating screens does not overlap voiceovers. |
| UX-017 | Onscreen text and narration have equivalent meaning without word-for-word duplication. |
| UX-018 | Recording pronunciation of SPL, distributive expression and Indonesian terms reviewed by pedagogical reviewer. |
| UX-019 | No “sesi 4 menit” promise without approved sourced estimate. |
| UX-020 | Account signup or notification message is not shown as guaranteed/required without an approved flow. |
| UX-021 | Skip/close copy makes persistence consequences clear if implementation permits skip/close. |
| UX-022 | Audio failure provides text alternative and does not prevent navigation. |

## 3. Catalog and map

| Test | Expected result |
|---|---|
| UX-023 | Unsupported topics explicitly say “belum tersedia” not “terkunci karena kemampuanmu”. |
| UX-024 | Catalog accurately identifies Algebra → SPL as supported diagnosis entry. |
| UX-025 | Concept map before diagnosis has no personalized weakness/mastery claim. |
| UX-026 | Focus map displays Confirmed only from actual C3 output. |
| UX-027 | Rejected, Uncertain and not assessed are visibly and verbally distinguishable. |
| UX-028 | Progress map never assigns learner state based solely on C4 completion. |
| UX-029 | Unassessed represented concept never receives a false learner label. |

## 4. Diagnosis — high-integrity microcopy

| Test | Expected result |
|---|---|
| UX-030 | Q1/Q2/Q3 instructions match MCQ/short-math/reasoning role. |
| UX-031 | Q1–Q3 collection feedback contains no answer correctness/hints before outcome decision. |
| UX-032 | Progress shows core questions correctly and optional Q4 only when warranted. |
| UX-033 | A Q4 explanation is neutral and does not imply confirmed blocker. |
| UX-034 | `Jawaban tersimpan` appears only after successful persistence acknowledgment. |
| UX-035 | Confirmed copy is bounded to Distributive Property and applicable evidence. |
| UX-036 | Rejected copy does not imply full SPL mastery or absence of other difficulties. |
| UX-037 | Uncertain copy explicitly communicates insufficient/ambiguous/inconsistent evidence without shame. |
| UX-038 | All-correct result copy remains BLOCKED until OI-03 resolved. |
| UX-039 | Service/error state cannot trigger invented blocker conclusion. |
| UX-040 | Student comprehension test distinguishes what Confirmed proves and does NOT prove. |
| UX-041 | Student comprehension test distinguishes Rejected and Uncertain. |
| UX-042 | No exposed model confidence percent without approved calibrated interpretation. |

## 5. Guided learning feedback

| Test | Expected result |
|---|---|
| UX-043 | Visual Explanation describes conceptual relationship, not only formula memorization. |
| UX-044 | Worked Example gives reasoning appropriate to approved curated item. |
| UX-045 | Partial Guided Practice requires student math input; completion text not triggered on passive view. |
| UX-046 | Feedback tells which mathematical step to inspect, never labels student's intelligence. |
| UX-047 | No feedback copy asserts accepted answer before OPS-01/OPS-04 approved rubric. |
| UX-048 | Completion status only after actual approved OPS-02 completion condition. |
| UX-049 | Optional Review copy cannot retroactively present blocker as Confirmed. |
| UX-050 | Completed C4 alone never displays Understood/Procedural Only/Needs Reinforcement. |

## 6. Validation and achievement

| Test | Expected result |
|---|---|
| UX-051 | Independent Retry instructions have no instructional scaffolding or revealed answer. |
| UX-052 | Transfer introduction only shown after valid successful Retry. |
| UX-053 | Failed Retry does not show Transfer as failed; label not administered correctly. |
| UX-054 | Understood copy never says mastery of all SPL. |
| UX-055 | Procedural Only communicates retry success + transfer unsuccessful distinctly. |
| UX-056 | Needs Reinforcement offers existing curated learning, no new blocker diagnosis. |
| UX-057 | Blank/uninterpretable/equivalent math responses not automatically framed as student weakness; OPS-03 gate. |
| UX-058 | Achievement copy appears only after evidence-backed valid C5 Understood plus approval of GAM feature. |
| UX-059 | No duplicate achievement announcements on reload/double click. |
| UX-060 | No achievement after preview, diagnosis, C4 completion, rejected/uncertain, or invalid evidence. |
| UX-061 | Optional Review validation copy remains blocked until OI-02 resolved. |
| UX-062 | Achievement can be understood without decorative illustration/audio. |

## 7. Error and edge-case writing

| Test | Expected result |
|---|---|
| UX-063 | Network offline copy names status and recovery path without false save assurances. |
| UX-064 | Unknown persistence distinguished from confirmed failure/success. |
| UX-065 | Retry CTA rendered only if retry can truly be performed. |
| UX-066 | Evaluator unavailable copy does not blame user or assign C5 fail. |
| UX-067 | Expired session message does not promise resumption unless supported. |
| UX-068 | Loading/saving status accessible to assistive technology with sensible announcement timing. |
| UX-069 | No `Oops!`-only error, no critical humor, no unsupported reassurance. |
| UX-070 | One screen cannot show conflicting `saving` and `saved` semantics simultaneously. |

## 8. Accessibility, localization, rendering and governance

| Test | Expected result |
|---|---|
| UX-071 | Every form field has persistent label/instruction, not placeholder-only. |
| UX-072 | Meaningful states conveyed in text as well as color or sound. |
| UX-073 | Large dynamic text does not truncate diagnostic qualifications or action labels. |
| UX-074 | Icon-only buttons have accurate names in accessibility tree, matching state and action. |
| UX-075 | Audio transcripts/captions are available where narration conveys meaning. |
| UX-076 | Math notation uses accessible rendering/reading strategy in collaboration with math reviewer. |
| UX-077 | Variables are escaped and never interpolate raw untrusted HTML. |
| UX-078 | Every published copy ID has editor/owner, source status, and trigger condition. |
| UX-079 | Every BLOCKED copy has explicit OI/OPS dependency and cannot be shipped silently. |
| UX-080 | Engineering PR enumerates modified IDs, impacted FR IDs, screenshots and test outcomes. |
| UX-081 | Tested students can explain what happened and next action without being asked leading questions. |
| UX-082 | All 3 diagnostic outcome meanings are understood distinctly in user testing; report evidence, not “passed by design”. |
| UX-083 | Students know Understood is bounded to tested Distributive Property, not whole SPL. |
| UX-084 | UI `DESIGN.md` typography/color system is respected without sacrificing comprehension. |

## 9. Review worksheet

```md
Review date:
Build / commit:
Copy IDs changed:
FR IDs affected:
Scenario ID:
Expected result:
Observed result:
Result: PASS / FAIL / NOT TESTED / BLOCKED BY DECISION
Evidence (screenshot/video/recording/test ID):
Related decision OI/OPS:
Reviewer and sign-off:
Follow-up action:
```

**Acceptance principle:** All relevant critical scenarios must have executed evidence before claiming release quality. Visual polish, friendliness and usability are separate from correctness of diagnostic and learner-state behavior.

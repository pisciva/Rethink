# Rethink — Gamification Experience Specification

> **Document ID:** RT-DES-GAM-001  
> **Version:** 0.9 — implementation-ready *proposal*, **NOT approved product baseline**  
> **Date:** 18 October 2026  
> **Owner for approval:** Product + UX + Engineering + Mathematics/Pedagogy review  
> **Placement:** `docs/design/gamification-specification.md`  
> **Companion:** [`gamification-acceptance-tests.md`](gamification-acceptance-tests.md)  
> **Read before use:** [`../../AGENTS.md`](../../AGENTS.md), [`../INDEX.md`](../INDEX.md), [`../prd/requirements.md`](../prd/requirements.md), [`../decisions.md`](../decisions.md)  
> **Priority:** Support current MVP where non-conflicting; any new behavior/release commitment requires product approval.

## 0. Executive implementation contract

Rethink will **propose** a restrained, mastery-oriented gamification layer with exactly three mechanisms:

1. **Learning-loop Progress Indicator (GAM-PROG):** show *where the student is* in an eligible workflow and *which activity has been completed*, without claiming knowledge mastery.
2. **Contextual Positive Feedback (GAM-FDBK):** report factual activity status or evidence-linked, actionable mathematical feedback; never introduce scoring bias, premature correctness disclosure, or unearned praise.
3. **Concept Achievement (GAM-ACH):** recognize success on the *supported independent-retry and transfer assessment*; celebrate a bounded achievement, not universal SPL mastery.

**The three mechanisms NEVER determine or change the underlying assessment outcome.** They must consume information owned by C1–C5, especially C3 diagnostic outcomes, C4 participation/completion, and C5 validation results. Gamification is a **presentation/recognition layer**, not a new diagnostic engine, grading authority, mastery model, or sixth product capability.

### 0.1 Current authority vs proposal

| Classification | Meaning | Illustrations |
|---|---|---|
| **BASELINE / APPROVED** | Exists in the approved 39 FRs / PRD v1.0; binding | 3 core diagnostic items + max 1 conditional probe; C4 fixed visual → worked → practice; C5 retry → conditional transfer; 3 C5 states; C2 is projection only |
| **PROPOSED / DESIGN** | An implementable candidate, **not automatically approved** | Stepper layout; feedback visual style; achievement card; animation; event naming; user-facing microcopy; instrumentation |
| **OPEN / PENDING** | Cannot be quietly resolved by this document | OI-01..03; OPS-01..05; especially Guided Practice feedback, completion, optional-review validation, item scoring and transitions |
| **RESEARCH EVIDENCE** | Informs rationale; not a Rethink effectiveness claim | Meta-analysis and official application documentation in §19 |

**Approval gate:** prior to shipping, product must approve this GAM layer's intended MVP scope and acceptance criteria. For areas blocked by OI/OPS, build only presentational scaffolds or mocks clearly marked non-authoritative; do not ship irreversible behavior based on invented rules.

### 0.2 Non-negotiable constraints

- **Completed activity ≠ concept understood.** A completed C4 sequence must not award an “Understood” achievement.
- **Confirmed blocker ≠ student failed/low intelligence;** it is a bounded C3 inference. Diagnosis is not a competitive game.
- **No correctness-revealing or hint-bearing feedback between Q1/Q2/Q3 or conditional Q4.** Core assessment collects evidence first; approved result feedback comes later.
- **Q4 is conditional** and is **the only optional probe**; do not create a repeating progress-driven probe loop.
- **Transfer is not attempted, failed, or shown as incorrect if Independent Retry fails**; do not visually penalize an unadministered assessment.
- **No concept achievement for Rejected, Uncertain, unassessed content, merely completed Guided Learning, or invalid/unevaluable validation evidence.** Validation after Optional Review is **OI-02 Open**.
- **Math evidence and learner-state semantics outrank celebratory copy, progress graphics and badge visuals.** C2 must never infer a new learner state.
- **No XP, points, coins, avatar purchases, streaks, leaderboard, timed pressure, random prizes, loss aversion or daily grind in this MVP proposal.** Their omission is intentional, not a forgotten requirement.
- **All UI text is age-appropriate, non-shaming, actionable and specific.** No “you are a genius”, no “you mastered the whole topic”, no “your concept is broken”.
- **Any unapproved choice must be tagged `PROPOSED` in code comments/PRs or withheld from implementation** where it changes state or grading.

### 0.3 Scope boundaries and concept identifiers

- App: **Rethink**, self-directed AI-assisted mathematics *conceptual recovery*.
- MVP selectable topic: **Sistem Persamaan Linear (SPL)** under **Aljabar**.
- Only complete supported conceptual recovery target: **Distributive Property**.
- Diagnosis context: direct distributive expression **and** application within SPL.
- Other concepts may appear in catalog/map **without being assessed** and must not be represented as personally understood, misunderstood, or unlocked through gameplay.
- `concept_id`, `topic_id`, `assessment_id`, etc. in examples below are **illustrative field names**, not final database/API contracts. Use existing project identifiers if implemented.

---

## 1. Product purpose, psychological mechanism and outcome boundaries

### 1.1 Why gamification is being added

**Problem hypothesis:** a valid mathematical learning loop can still feel opaque, tedious, or excessively assessment-like. Students need process orientation, evidence-based support, and an interpretable indication of what was demonstrated. This is a UX hypothesis, **not** a confirmed finding that Rethink needs these exact three mechanics.

**Goal:** improve comprehension of the experience and willingness to finish meaningful tasks *without* optimizing for screen time, points, leaderboard position or accidental assessment success.

| Proposed mechanic | Specific job-to-be-done | Safe signal | Should not imply |
|---|---|---|---|
| Progress | “Where am I and what happens next?” | current step, activities legitimately completed, applicable next step | competence/mastery/percent knowledge |
| Contextual feedback | “What did I do, why does it matter, what can I do now?” | saved/unsaved status; validated step result; next action | diagnosis certainty or grading absent evidence |
| Achievement | “What can I demonstrate independently?” | successfully assessed independent retry **and** meaningfully distinct transfer | all-SPL mastery, long-term retention, psychological trait |

### 1.2 Hypotheses and proposed measures

- **H-G1 Orientation:** a clear stepper reduces confusion about the current phase and legitimate next action. Measure stage-location comprehension, task completion without help, wrong-navigation incidents.
- **H-G2 Actionability:** feedback explaining the *relevant mathematical transformation* better supports correction during guided practice than generic “Correct / Incorrect”. Measure successful follow-up revisions and qualitative feedback comprehension; do not equate assisted correction with independent mastery.
- **H-G3 Achievement semantics:** bounded concept achievement makes the meaning of C5 outcomes clearer, not overstated. Measure whether students accurately explain what was tested and what was **not** demonstrated.
- **Guardrail hypotheses:** gamification does not increase unsupported C3/C5 inference, answer leakage, misclassification, or confusion between completion and comprehension.

### 1.3 Avoid false claims

Research on gamification and feedback may show averaged benefits in other settings. It does **not** establish causal learning improvement, increased Rethink retention or validated motivation effects for this product. Implement first; conduct appropriately designed UX and learning-outcome studies to validate claims.

---

## 2. Source-of-truth, ownership and traceability

### 2.1 Which subsystem owns what?

| Existing capability | Owner of underlying fact | Gamification may show | Gamification must not |
|---|---|---|---|
| **C1** Catalog/Topic | Supported topic/availability and selection | selected topic, eligible entry | unlock unsupported topic |
| **C2** Hybrid Learning Map | Curated relationships + projections of C3/C5 | Explore / Focus / Progress badge/status derived from stored facts | invent learner judgments |
| **C3** Diagnosis | Responses, approved diagnostic inference and Confirmed/Rejected/Uncertain | diagnostic item progress; final bounded result copy | alter C3 outcome or reveal correctness early |
| **C4** Guided Learning | Curated sequence, active practice, approved completion | visual/worked/practice stepper and instructional feedback | infer mastery, invent pass thresholds |
| **C5** Knowledge Validation | Valid retry/transfer outcomes and learner state | result message; concept achievement only from legitimate success | grant a badge before valid evidence |
| **FR-X** Coordination | Context continuity, guards, map consistency | consistent state across surfaces | open forbidden transitions |

### 2.2 Relevant approved FRs (not new FRs)

| Gamification design | Baseline trace | Proposed design interpretation |
|---|---|---|
| Catalog/topic progress context | `FR-C1-01..05` | show available SPL context without false support |
| Map orientation & projection | `FR-C2-01..05` | distinguish Explore, Focus, Progress and unassessed state |
| Diagnostic stepper and result | `FR-C3-02/03/06/09/10` | track 3 core items + conditional Q4; no answer leakage; appropriate continuation |
| Bounded feedback | `FR-C3-04/05/07/08`, `FR-C4-05/07/08` | math feedback belongs to curated/prior approved logic, not animation |
| Guided learning stepper | `FR-C4-01..08` | show fixed three stages and completion only under approved OPS-02 |
| Validation messaging & achievement | `FR-C5-01..08` | only based on validly evaluated retry/transfer, not participation |
| Context and consistency | `FR-X-01..03`, `IP-01/02` | same origin/outcome/state across map, result, achievement |

### 2.3 Decision dependencies / blocking matrix

| Issue | Current status from source | Gamification impact | Safe implementation before approval |
|---|---|---|---|
| `OI-01` AI methodology | OPEN | C3 inference ownership and exact result | structural phase UI only; show already-approved outcome if issued; never synthesize own |
| `OI-02` Optional Review and learner states | OPEN | achievements/validation after review | do **not** award from Optional Review or silently enable C5 there |
| `OI-03` All-correct Q1–Q3 | OPEN | result/Focus flow and feedback | avoid inventing “Passed / Understood / Rejected” mapping |
| `OPS-01` Guided Practice feedback | PENDING | correctness/repair microcopy, retry limits | prepare templates; wire only to reviewed evaluator/behavior |
| `OPS-02` Guided Learning completion | PENDING | checkmarks and completion event | distinguish “visited/viewed” vs completed; final completion criteria unresolved |
| `OPS-03` Evaluation of validation inputs | PENDING | eligibility for achievement and state | award only after valid C5 outcome, never on raw text or blanks |
| `OPS-04` Curated items/rubric | PENDING | correct step-level feedback and examples | prototype with **clearly labelled sample questions** only |
| `OPS-05` Transition/state mechanics | PENDING | persistence, resume, result routing, idempotency | design candidate states/events; must be reviewed |

---

## 3. End-to-end experience architecture

**Important:** the screen/state model below is a *candidate UX composition* of approved responsibilities, **not** a replacement operational state machine.

```text
C1 Catalog → Supported SPL entry
  │
  ▼
C3 Diagnosis: Q1 → Q2 → Q3 [→ Q4 only if approved diagnostic policy requires]
  │  [progress = item completion only; NO correctness feedback]
  ▼
C3 Diagnostic Result (Confirmed / Rejected / Uncertain; all-correct OI-03 OPEN)
  ├─ Confirmed → C4 Confirmed Recovery
  │               Visual → Worked → Partial Practice
  │               (stage progress + math-specific practice feedback)
  │               ↓ [C4 completion after OPS-02 approval]
  │               C5 Independent Retry (no scaffold)
  │               ├─ unsuccessful, valid → Needs Reinforcement → same C4 package
  │               └─ successful, valid → C5 Transfer (distinct representation)
  │                                       ├─ unsuccessful → Procedural Only
  │                                       └─ successful → Understood
  │                                                       └─ proposed Concept Achievement
  └─ Rejected / Uncertain → C1 Explore or C4 Optional Review
                            [never infer Confirmed; C5 eligibility OI-02 OPEN]

C2 Hybrid Map at appropriate points:
  Explore = curated structural orientation; Focus = C3 result projection;
  Progress = C5 state projection only when applicable valid evidence exists.
```

**Gamification is downstream** of these decisions; it may not change branch guards to make a journey feel more “complete”.

---

# PART A — LEARNING-LOOP PROGRESS INDICATOR

## 4. Progress information architecture

Do not implement a single percent called `masteryProgress`. Distinguish:

| Dimension | Meaning | Proposed UI | Data owner | Allowed claims |
|---|---|---|---|---|
| **Journey progress** | Which current major phase? | labeled three-phase stepper: Diagnosis → Guided Learning → Validation | C3/C4/C5 + FR-X | workflow position; phases may be inapplicable |
| **Activity progress** | How much of the current activity is done? | Q1/2/3 (+optional Q4), visual/worked/practice checklist | C3 / C4 | response/stage completion only |
| **Learning evidence** | What did valid assessment demonstrate? | C2 Progress map / C5 result | C5 (C2 projection) | bounded Understood/Procedural Only/Needs Reinforcement |

**Never sum these three into one scalar 0–100.** A learner may finish the assessment appropriately but not enter confirmed recovery; a learner may finish Guided Learning but fail retry.

## 5. Visual hierarchy and screen-level proposals

### 5.1 Global journey stepper

- **Location:** immediately below each journey screen's main heading, *only when a multi-step learning context exists*.
- **Style:** compact horizontal labeled stepper on wide layouts, concise vertical/two-line variant on narrow screens. Do not rely solely on dots or color.
- **Labels:** `Pemeriksaan konsep` → `Belajar terarah` → `Uji pemahaman`.
- **States:** `not_applicable`, `not_started`, `current`, `completed`, `needs_action`, `not_available` (proposed presentation vocabulary only).
- **Semantic note:** `completed` refers to *the workflow stage*, **not** mastery; if diagnosis non-confirmed, Guided Learning/Validation may be optional or inapplicable, not “failed”.
- **Interactions:** current stage clickable only if safe; past content may be viewable but re-entry must not erase evidence or create unapproved retakes. Navigation and editing rules must follow C3/C4/OPS-05.
- **No global achievement confetti on mere stage completion.** Optional subtle success check for activity done is acceptable after status confirmed.

### 5.2 Diagnosis item progress (C3)

- Display `Soal inti 1 dari 3`, `Soal inti 2 dari 3`, `Soal inti 3 dari 3`.
- After Q3, system evaluates core evidence. If Q4 required: display `Satu pemeriksaan tambahan diperlukan` and `Pemeriksaan tambahan 1 dari 1`.
- **Do not retroactively change the denominator of the core sequence.** Avoid progressing to “100%” and then dropping to 75% after Q4.
- Core responses must be editable only as authorized by the diagnostic UI flow; no mid-item correctness messages.
- On final submit, status may say `Jawaban terkirim` or `Sedang meninjau respons` only when true. No optimistic claim that mathematical diagnosis succeeded.
- On slow/error AI evaluation: preserve `processing`/`unable_to_process`, retain student context where safe, and display non-diagnostic guidance. Do not convert failure to `Rejected`, `Uncertain` or a confirmed blocker without approved policy.
- A progress element must not advertise “diagnosis accuracy” or a made-up confidence percent.

### 5.3 Guided Learning stepper (C4)

Three **fixed**, order-sensitive conceptual stages:

1. `Memahami konsep` — Visual Explanation.
2. `Melihat penerapan` — Worked Example with explanations of meaningful transformations.
3. `Latihan terbimbing` — Partial Guided Practice with at least one active mathematical response.

**UI distinction:** `viewed` (the student opened the activity), `attempted` (submitted active input), and `completed` (met **OPS-02 approved criteria**) must not be merged. If OPS-02 is unresolved, wire visual previews to `viewed`/`attempted` and label `completion` as unresolved. Merely showing a worked example cannot complete active practice.

On `Needs Reinforcement`, return to the same curated C4 package. A re-entry must not create a new concept achievement, re-confirm the original blocker, or silently reset a learner-state record. Detail of repeating instructional activities is part of OPS-05.

### 5.4 Knowledge Validation progress (C5)

- Display `1. Kerjakan mandiri` and `2. Terapkan pada bentuk berbeda` as conceptual stages.
- Before retry grading is valid, transfer is `not_available`, **not incorrect**.
- After valid retry failure, transfer is `not_administered` / `Tidak dilanjutkan`, with reason framed as next study action, not punishment.
- After valid retry success, transfer becomes available; celebration of *partial* success may use process copy, never the `Understood` badge.
- After valid transfer outcome, display one applicable **C5 source-of-truth learner state**.
- Unreadable, empty or mathematically equivalent submissions are governed by OPS-03/04; do not increment mastery or mark wrong before validated evaluation.

### 5.5 C2 Hybrid Learning Map

- **Explore:** show SPL ↔ curated Distributive Property relationship as an educational map; no colored deficiency/mastery state for this learner.
- **Focus:** after C3, show Confirmed as assessed recovery focus; show Rejected/Uncertain as examination information or optional review without false confirmed blocker.
- **Progress:** project only valid C5 learner state within the assessed concept. `Not assessed` is distinct from `Needs Reinforcement` and from `Uncertain`.
- **Badge coexistence:** a Concept Achievement marker may sit beside an `Understood` state if both point to the **same C5 evidence**, not if it is earned through UX animation or C4 activity.

## 6. Progress state semantics / source truth

| Proposed presentation state | Must derive from | May trigger | Must not trigger |
|---|---|---|---|
| `core_question_in_progress` | saved/current assessment session | active item indicator | any C3 outcome |
| `core_question_submitted` | authoritative save/submit acknowledgement | step completion in item strip | right/wrong hints |
| `additional_probe_available` | approved C3 probe choice | single Q4 indicator | automatically adding multiple probes |
| `diagnosis_result_ready` | C3 finalized outcome | move to result page | assuming recovery branch |
| `guided_stage_viewed` | actual C4 stage access | visited indicator | completed learning status |
| `guided_stage_completed` | approved OPS-02 evidence | stage checkmark | learner state |
| `validation_retry_complete` | valid C5 retry evaluation | conditional next step | transfer pass assumption |
| `validation_transfer_complete` | valid C5 transfer evaluation | C5 result and possibly achievement | SPL mastery claim |
| `concept_achievement_eligible` | C5 valid Understood + eligibility policy | proposed recognition once | C3 or C4 state mutation |

**Authoritative data** takes precedence after refresh, navigation, duplicate events, offline reconnection or tab reopening. Temporary local UI state must never be treated as grading evidence.

## 7. Edge cases and UX behavior for progress

| Edge case | Expected safe design |
|---|---|
| Q4 appears after three questions | Add distinct optional probe substep; don't lower completed 3/3 |
| Q4 not required | Finish core assessment cleanly; don't show a blank failed/locked question |
| Confirmed blocker but learning not started | Diagnosis stage completed, learning current/pending; no `Understood` |
| Rejected / Uncertain | diagnosis completed; show optional review/return route; don't mark mandatory study path incomplete |
| All three answers correct | `OI-03` not decided; avoid inventing a diagnostic state or completion meaning |
| User refreshes mid-stage | reconstruct display from authoritative state; avoid duplicate checkmarks |
| Back navigation | keep correct history and guarded editing behavior; no invented retake |
| API save fails | do not mark item completed or increase progress |
| Assessment pending | show neutral processing and retry/error path; no fabricated conclusion |
| Step is unavailable/unsupported | show `Belum tersedia`, not a merit-based padlock |
| Two devices/tabs | latest server/authoritative state wins; deduplicate if necessary (engineering proposal under OPS-05) |
| Retry failure | no transfer failure / “0 out of 2” stigma; show relevant reinforcement route |
| Optional Review | keep entry context, do not display C5 until OI-02 resolved |

---

# PART B — CONTEXTUAL POSITIVE FEEDBACK

## 8. Feedback model and evidence taxonomy

Use four layers, but only when a source fact exists:

1. **System/status feedback:** factual save, loading, availability, completed task; safe during diagnosis because it does not reveal correctness.
2. **Task feedback:** correct/incorrect/needs-review outcome **after** an evaluator can establish it, at an approved point in the flow.
3. **Process feedback:** *why* a transform or explanation works; selected from a reviewed math-knowledge/rubric package or appropriately constrained generation, not unsourced model guesswork.
4. **Feed-forward:** a specific next student action or sanctioned continuation route.

**Decision hierarchy:** mathematical accuracy → diagnostic validity/assessment fairness → actionable information → tone/visual polish. Generic positive praise is not a substitute for information.

### 8.1 Feedback property checklist

Every feedback candidate must have: `trigger`, `phase`, `source evidence`, `allowed disclosure`, `severity/type`, `copy`, `next action`, `source owner`, `guard/dependency`, `accessibility behavior`, `logging classification`, and `test ID`.

- **Specific:** refer to the observed action, not personality.
- **True:** do not pretend a step is correct or complete when not validated.
- **Actionable:** tell user whether to continue, revise, or re-study.
- **Calibrated:** indicate `indication`, `not enough evidence`, or `within assessed tasks` when necessary.
- **Nonpunitive:** mistakes are evidence for improvement, not sanctions.
- **Concise:** one primary message and at most one optional detail disclosure at a time, except final result summary.
- **Accessible:** do not rely only on icons/color; focus or announce status without surprising jumps.
- **Consistent:** repeated renders of the same result do not generate contradictory messages.

## 9. Feedback disclosure policy by stage

| Stage | Immediate feedback allowed | Correctness-specific feedback | Required boundary |
|---|---|---|---|
| Catalog | available/unavailable, selected topic | none | no “too low level” inference |
| Diagnosis Q1–Q3 | saved, next question, progress | **NO** correctness/hints before finalized diagnostic evaluation | avoid contaminating subsequent evidence |
| Conditional Q4 | why another probe is being requested, saved | **NO** answer-revealing hints during probe | preserve evidence integrity |
| Diagnosis results | finalized C3 outcome and transparent limitations | yes, only insofar as supported by approved decision/output | C3 Confirmed ≠ mastery |
| Visual Explanation | visited stage, explain relationship | curated instructional content is expected | no mastery badge |
| Worked Example | curated reasons for steps | yes as fixed lesson content | must be mathematically reviewed |
| Partial Guided Practice | status and explanatory step feedback **subject to OPS-01/04** | only after reviewed scoring rules | no unapproved number of attempts / completion gates |
| Independent Retry | save/submit status | don't provide live hints/scaffold for assessed task | no leakage before grading |
| Transfer Problem | save/submit status | don't provide a worked solution during assessed task | preserves meaningful transfer |
| Final C5 result | learner state and limits, next sanctioned action | yes, **post-evaluation** and only per approved presentation policy | no comprehensive SPL claim |
| Error/network | unable to save/process | never fabricated math diagnosis | distinguish technical error from student mistake |

**Operational warning:** precise hint timing, practice retry mechanics and when detailed post-validation explanations become available are affected by `OPS-01/02/03/04`. Copy templates here are not approval of those mechanisms.

## 10. Feedback design system — copy and interaction anatomy

**Proposed component anatomy:**

```text
[Semantic icon] [Primary statement: what happened]
                [Short reason tied to observable fact]
                [One allowed next action]
                [Optional “Lihat penjelasan” only when pedagogically valid]
```

Proposed severity/style taxonomy (not a diagnosis label):

- `info` — neutral factual event, status or expectation.
- `success` — verified response or properly completed task; *does not mean mastery by default*.
- `guidance` — explain next step, correction, or practice route.
- `uncertain` — available evidence is insufficient or system cannot conclude.
- `error_system` — technical failure; separate from incorrect mathematics.

Avoid colors alone as the distinguishing characteristic. An “incorrect math response” should ordinarily receive non-shaming `guidance`, not a red punitive banner.

### 10.1 Indonesian copy catalog

The following is **proposed microcopy** requiring UX review and alignment with approved mathematical rubrics.

| ID | Stage / trigger | Proposed student-facing Indonesian copy | Next permitted action | Dependency / no-go |
|---|---|---|---|---|
| `FB-01` | SPL selected | `Kamu memilih Sistem Persamaan Linear. Pemeriksaan akan berfokus pada konsep yang saat ini didukung.` | Mulai pemeriksaan | C1 active-support check |
| `FB-02` | Unsupported topic | `Materi ini belum tersedia untuk pemeriksaan konsep.` | Pilih topik tersedia | never imply ability-lock |
| `FB-03` | Diagn. core response saved | `Jawabanmu tersimpan. Lanjutkan ke soal berikutnya.` | Next Q | no correctness feedback |
| `FB-04` | Diagn. core submission pending | `Jawabanmu sedang diproses.` | Wait / non-destructive retry | don't claim diagnosis ready |
| `FB-05` | Q4 requested | `Kami memerlukan satu jawaban tambahan untuk memperjelas hasil pemeriksaan.` | Q4 only | OI-01; no multiple probes |
| `FB-06` | C3 Confirmed | `Responsmu mendukung adanya hambatan pada sifat distributif. Kamu dapat mempelajari konsep ini secara terarah.` | Confirmed Recovery | no permanent label; OI-01 policy |
| `FB-07` | C3 Uncertain | `Bukti jawabanmu belum cukup untuk menyimpulkan apakah ada hambatan pada sifat distributif.` | Review opsional / kembali | don't convert to Rejected |
| `FB-08` | C3 Rejected | `Pemeriksaan ini tidak mendukung dugaan hambatan pada sifat distributif. Hasil ini bukan penilaian seluruh kemampuan SPL.` | Review opsional / kembali | only if validly Rejected |
| `FB-09` | All-correct pattern | `Pesan hasil untuk pola semua jawaban benar masih menunggu keputusan produk.` | Prototype only; no production copy | `OI-03 OPEN` |
| `FB-10` | Visual stage viewed | `Kamu sudah melihat bagaimana faktor luar kurung berhubungan dengan setiap suku di dalamnya.` | Worked Example | viewed != completed; OPS-02 |
| `FB-11` | Worked stage viewed | `Sekarang kamu sudah melihat alasan di balik langkah-langkahnya. Saatnya mencoba sebagian langkah sendiri.` | Guided Practice | no mastery inference |
| `FB-12` | Practice correct transform | `Tepat. Faktor 3 dikalikan ke kedua suku: 3 × x dan 3 × 2.` | Continue if permitted | example only, OPS-01/04 |
| `FB-13` | Practice partial distribution | `Periksa kembali suku kedua. Faktor di luar kurung berlaku untuk setiap suku di dalam kurung.` | Revise if permitted | based on reviewed observed pattern |
| `FB-14` | Practice ambiguous response | `Jawaban ini belum dapat diperiksa dengan pasti. Pastikan bentuk matematikanya jelas.` | Correct format as permitted | must not assume misconception |
| `FB-15` | C4 completed by approved rule | `Tahap belajar terbimbing selesai. Selanjutnya, coba soal secara mandiri tanpa bantuan.` | C5 only if eligible | OPS-02, OI-02 |
| `FB-16` | Retry submitted | `Jawabanmu sudah dikirim untuk diperiksa.` | Wait for evaluation | no pre-score feedback |
| `FB-17` | Retry valid pass | `Kamu berhasil mengerjakan soal ini tanpa bantuan. Sekarang coba konsep yang sama pada bentuk berbeda.` | Transfer | not `Understood` yet |
| `FB-18` | Retry valid fail | `Pengerjaan mandiri pada soal ini belum berhasil. Kamu dapat mengulang pembelajaran terbimbing.` | Same C4 package | no transfer; no blame |
| `FB-19` | Transfer valid fail | `Kamu berhasil pada pengerjaan mandiri, tetapi belum pada bentuk soal berbeda yang diuji.` | Display Procedural Only | no permanent trait claim |
| `FB-20` | Both valid pass | `Kamu berhasil menerapkan sifat distributif secara mandiri dan pada representasi berbeda yang diuji.` | Show Understood, eligible achievement | blocker-only claim |
| `FB-21` | C5 response cannot be evaluated | `Jawabanmu belum dapat dinilai. Periksa kembali penulisan atau coba lagi jika tersedia.` | approved validation recovery | OPS-03, never auto-fail |
| `FB-22` | Server save failed | `Jawaban belum tersimpan karena gangguan koneksi. Coba kirim lagi.` | Retry save | don't increment stage |
| `FB-23` | LLM/network processing failed | `Hasil pemeriksaan belum tersedia karena kendala teknis.` | safe retry / return | no diagnostic pseudo-outcome |
| `FB-24` | Optional Review entry | `Kamu dapat meninjau sifat distributif tanpa hasil ini dianggap sebagai diagnosis hambatan yang terkonfirmasi.` | Start review | OI-02, no automatic C5 |
| `FB-25` | Achievement issued | `Pencapaian baru: kamu berhasil menerapkan sifat distributif pada asesmen mandiri dan transfer yang diuji.` | View details / continue | only valid Understood |
| `FB-26` | Achievement already issued, re-open | `Pencapaian konsep telah tercatat dari hasil validasi sebelumnya.` | View underlying evidence | no duplicate issuance |

**Policy note:** `FB-09` is a **placeholder for reviewer**, never production copy. `FB-12/13` are **sample expressions** and must be crosschecked against the final OPS-04 curated item bank. If a screen has no defensible actionable copy, use neutral status rather than improvised claims.

### 10.2 Why gamified positive feedback is not generic praise

Do:
- Attribute correctness to observable transformations, e.g., `faktor diterapkan ke setiap suku`.
- Recognize agency and specific work, e.g., `kamu melengkapi langkah ini`.
- Respect uncertainty: `belum dapat disimpulkan`.
- Offer one next action, not forced engagement.

Do not:
- Say `Kamu jenius`, `Kamu pasti bisa semua soal`, `Kamu gagal`, `Selamat, SPL telah dikuasai`.
- Use confetti during a diagnostic error classification or a retry failure.
- Change text according to scores invented by the LLM.
- Reveal correct answers to subsequent assessment items before their completion.
- Reward rapid guessing or repeated submissions.

## 11. Personalization boundary / AI use in feedback

**Safe default:** fixed or rule-selected **curated feedback templates** linked to approved mathematical evidence/rubrics. For the MVP, this is easier to verify than unconstrained AI motivational phrasing.

If AI rephrasing is later proposed:
- AI is a *language renderer*, never grading authority for GAM; its task must have a reviewed evidence payload.
- Inputs must be narrow and only contain required student context; avoid exposing unrelated PII.
- Output must be checked for mathematical consistency, unsupported certainty, unjustified ability labels, answer leakage and excessive length.
- Provide deterministic template fallback when AI output is unusable; do not treat fallback as a change in C3/C5 result.
- No unsourced diagnosis or spontaneous new prerequisite discovery from motivational text.
- **OI-01** still governs boundaries between AI interpretation and C3 decisions.

## 12. Feedback presentation / timing details

- Show status feedback **after confirmed save** or represent `saving` distinctly from `saved`.
- For practice, display corrective feedback only after validated result under approved OPS-01 rules; avoid feedback during answer composition that effectively supplies the answer.
- For C5, maintain a meaningful **scaffold-free assessment** until item submission; show allowed result copy *after* valid grading.
- Avoid stacked congratulatory banners, interruptions between each equation entry or confetti on ordinary correct steps.
- Prefer inline feedback immediately adjacent to the relevant task, and a compact final result card at phase end.
- Announce short asynchronous status via accessible status region; do not repeatedly seize keyboard focus; place explicit next-action buttons in predictable order.
- `loading`/network errors use neutrally distinct messaging from mathematical errors.
- Reopening a completed screen may show result summary; it must not repeat a “new” achievement notification.

---

# PART C — CONCEPT ACHIEVEMENT

## 13. Achievement philosophy, terminology and scope

**Proposal:** a single **earned acknowledgment** with the working title **`Concept Applied: Distributive Property`** (Indonesian label: **`Konsep Berhasil Diterapkan — Sifat Distributif`**). This title is a **design proposal**, not a certified measurement scale or permanent credential.

The achievement's claim is narrow:

> The student successfully completed a valid, scaffold-free Independent Retry and a meaningfully different Transfer Problem assessing Distributive Property within the supported Rethink MVP assessment.

It does **not** mean: mastery of the entire SPL topic, understanding of other prerequisite concepts, long-term retention, diagnostic accuracy outside curated tasks, or universal ability in novel mathematics problems.

### 13.1 Distinguish three representations

| Concept | Source | Meaning | Suggested UX |
|---|---|---|---|
| **Activity completion marker** | approved C4 participation/completion | guided activity done | subtle checkmark, NOT achievement |
| **Learner state** | valid C5 result | Understood / Procedural Only / Needs Reinforcement | state label and explanation |
| **Concept achievement** | recognized valid `Understood` result (proposed rule) | celebratory evidence-linked recognition | optional badge/card triggered once |

No separate `Procedural Master`, `Failed Learner`, `Brave Diagnostician` or badge for being confirmed as having a blocker. A student should not be incentivized to intentionally fail diagnosis to unlock a reward.

## 14. Eligibility and achievement decision table

**The following eligibility rule is PROPOSED, not part of approved PRD.** It *reflects* C5 evidence rather than changing it.

| Origin / condition | C5 status | Achievement proposal | Rationale |
|---|---|---|---|
| C3 Confirmed + C4 completed + valid retry pass + valid transfer pass | `Understood` | **Eligible, issue once** | evidenced independent and transfer performance |
| Confirmed + C4 completed + retry pass + transfer fail | `Procedural Only` | **No** | transfer condition not met |
| Confirmed + C4 completed + retry fail, transfer not administered | `Needs Reinforcement` | **No** | independent application not demonstrated |
| C3 Confirmed only | none | **No** | diagnosis ≠ validation |
| C4 completion only | none | **No** | instructional participation ≠ evidence of mastery |
| C3 Rejected / Uncertain and Optional Review | no C5 | **No** | review alone not confirmatory |
| Optional Review completed then C5 requested | unresolved | **Hold until OI-02** | eligibility/status impact open |
| All Q1–Q3 correct | unresolved C3 mapping | **No** | OI-03 open; no automatic C5 evidence |
| C5 response missing/ambiguous/uninterpretable | no valid decision | **No** | do not convert unknown into pass/fail |
| Unsupported concept visible on map | none | **No** | represented ≠ assessed |
| Previously issued achievement shown again | same prior result | show existing only | avoid repeat rewards |

### 14.1 Achievement lifecycle (design proposal)

- `not_eligible`: no validated source-of-truth evidence.
- `eligible_pending_issuance`: valid qualifying C5 record available; recognition not yet stored/confirmed.
- `issued`: unique recognition persisted/recorded according to approved persistence policy.
- `presented`: client has shown the one-time celebration; a view event only, not evidence.
- `historical`: display an already issued recognition without claiming that all future sessions will necessarily pass.

**No mastery inflation:** “achievement issued” must be derived from C5, not from an animation callback. If system cannot persist the recognition, the C5 learner state can still be displayed accurately; do not claim “badge saved” until true.

### 14.2 Idempotency / retries

Recommended engineering behavior (requires `OPS-05` agreement on persistence semantics):

- Deduplicate recognition by a stable key such as `(learner, concept, achievement_type, qualifying_validation_result_id)`; if product intends one-ever award instead, that policy needs explicit approval.
- Retry of the same API event must not issue multiple rewards or duplicate notifications.
- Two tabs opening the same result must see one authoritative issuance; presentation may be remembered per view session.
- Never create an achievement from local UI flags or a guessed default value while C5 is pending.
- Re-evaluation/correction of a C5 result needs an explicit reconciliation policy; do **not** conceal revoked/corrected evidence or silently erase audit history. Longitudinal mastery policy is not in MVP.
- “Issued once” is a **proposed recognition rule**, not a product-established permanence promise.

## 15. Achievement UX specification

### 15.1 Placement

**Proposed:** show a compact achievement section **below the C5 `Understood` result summary**, after stating assessed concept and evidence. Do not replace the primary learner-state explanation with a trophy card.

Suggested layout:

```text
[Validation result]
Understood — Sifat Distributif
Kamu berhasil pada pengerjaan mandiri dan soal transfer yang diuji.

[Achievement unlocked (only first legitimate issuance)]
◇ Konsep Berhasil Diterapkan — Sifat Distributif
  ✓ Independent Retry: berhasil
  ✓ Transfer Problem: berhasil
  [Lihat yang sudah dibuktikan]

Catatan: hasil ini bukan penilaian penguasaan seluruh Sistem Persamaan Linear.
[Berikutnya: kembali ke topik]
```

- Badge should state **concept, qualifying tasks, limits**, and link to an evidence-based result summary (not necessarily full raw student answers).
- Celebration motion: optional subtle scale/fade (proposal); reduced-motion preference disables decorative motion. Never make animation a blocking step for accessing next action.
- Do not make recognition look like official school grading/certification.
- Do not publicly broadcast achievement or rank students; most target users are teenagers. No share-to-social-by-default.
- Avoid bright red `locked badge` on students in `Needs Reinforcement`; don't shame non-issuance. Simply show their actual next learning option.
- Achievement title should remain meaningful when translated; retain terminology for the supported mathematical concept.

### 15.2 Status variants

| C5 result | Primary card | Secondary recognition | CTA |
|---|---|---|---|
| Understood | `Understood — Sifat Distributif` | eligible achievement card | `Lihat hasil` / `Kembali ke topik` |
| Procedural Only | `Penerapan mandiri sudah berhasil; transfer belum` | **no earned mastery badge** | next available approved action |
| Needs Reinforcement | `Perlu penguatan pada pengerjaan mandiri` | **no negative badge** | `Ulangi pembelajaran` |
| No valid evaluation | neutral pending/unavailable state | nothing | retry technical evaluation per policy |

### 15.3 Interaction details

- Only mark as new/unlocked after successfully acknowledging source qualifying evidence and award persistence (if such persistence is implemented).
- Allow `Lihat detail` to explain **why** earned and **what isn't covered**.
- Recognition should not include an unsupported numeric “mastery percentage”, proficiency percentile or a graded certificate.
- Re-entering result must render the stored achievement correctly without duplicating celebratory side effects.

---

## 16. Proposed data/event view (NOT final APIs or database schema)

Current documentation defines logical data categories, not a physical schema. Code examples below are **nonbinding conceptual shapes**, to be adapted to the project's actual technology under `OPS-05`.

### 16.1 Candidate read model

```ts
// PROPOSED conceptual read-model; do not treat as approved API/ERD.
type GamificationPresentation = {
  selectedTopicId: string;                  // must be supported when starting C3
  activeConceptId: string;                  // e.g. distributive_property (illustrative ID)
  entryOrigin: 'confirmed_recovery' | 'optional_review' | 'diagnosis';
  currentPhase: 'diagnosis' | 'guided_learning' | 'validation' | 'result';
  coreQuestionsSubmitted: number;          // 0..3, authoritative
  conditionalProbe: 'not_required' | 'pending' | 'submitted' | 'not_decided';
  guidedStages: Array<{stage: 'visual' | 'worked' | 'practice';
                       viewed: boolean; completed?: boolean}>; // completed from OPS-02
  diagnosticResult?: 'confirmed' | 'rejected' | 'uncertain';
  retry?: 'not_administered' | 'pending' | 'pass' | 'fail' | 'unevaluable';
  transfer?: 'not_administered' | 'pending' | 'pass' | 'fail' | 'unevaluable';
  learnerState?: 'understood' | 'procedural_only' | 'needs_reinforcement';
  achievement?: {type: 'concept_applied'; sourceValidationResultId: string;
                 issuedAt: string; firstPresentedAt?: string};
};
```

**Important:** this is a `read model`, not a command authorizing state mutation. The `optional_review → validation` route is unresolved under OI-02. Don't model `undefined` learner state as “failed”.

### 16.2 Proposed domain events

| Event name | When emitted | Owner | Subscriber/use | Integrity rule |
|---|---|---|---|---|
| `DiagnosticResponseAccepted` | authoritative response save | C3 | item progress | no correctness reveal |
| `AdditionalProbeRequired` | approved C3 policy selects one Q4 | C3 | Q4 indicator | max one, OI-01 governs rule |
| `DiagnosticResultFinalized` | C3 outcome recorded | C3 | phase result, map Focus | no gamification inference |
| `GuidedStageViewed` | stage actually opened | C4 | visited indicator | not C4 completed |
| `GuidedStageCompleted` | approved criteria met | C4 | checkmark/phase progress | OPS-02 required |
| `GuidedPracticeEvaluated` | practice input scored by approved rubric | C4 / math evaluator | contextual step feedback | OPS-01/04; avoid answer leakage |
| `ValidationRetryEvaluated` | valid C5 retry grading | C5 | gate transfer, process feedback | OPS-03/04 |
| `ValidationTransferEvaluated` | valid transfer grading | C5 | final status | only if retry pass |
| `LearnerStateAssigned` | C5 final state recorded | C5 | result + map Progress | only valid mapping |
| `ConceptAchievementIssued` | proposed recognition persisted | recognition projection of C5 | celebratory card | cannot precede valid Understood |

**Event names are illustrative**: adopt any existing store/queue, callbacks or framework pattern; do not add distributed infrastructure solely for gamification.

### 16.3 Safe data flow

```text
Authoritative C1/C3/C4/C5 facts
  → validation of current stage and eligible route
  → read-only gamification view model
  → progress indicator / feedback component / achievement card
  → optional non-grade presentation telemetry
```

Never let `onAnimationComplete`, `onBadgeClick`, client-side arithmetic or a local checkbox write back a diagnostic result, graded answer or learner state.

### 16.4 Illustrative achievement guard

```ts
// PROPOSED pseudocode — NOT the final state policy.
function eligibleForConceptApplied(input: {
  origin: 'confirmed_recovery' | 'optional_review';
  guidedLearningCompletedUnderApprovedRule: boolean;
  validationResultIsFinalAndValid: boolean;
  conceptId: string;
  learnerState: string | null;
  retry: string | null;
  transfer: string | null;
  optionalReviewPolicyApproved: boolean;
}): boolean {
  if (input.origin !== 'confirmed_recovery') {
    // Do not guess OI-02 behavior.
    return false;
  }
  return input.guidedLearningCompletedUnderApprovedRule
    && input.validationResultIsFinalAndValid
    && input.conceptId === 'distributive_property' // example symbolic identifier
    && input.learnerState === 'understood'
    && input.retry === 'pass'
    && input.transfer === 'pass';
}
```

Do not copy this function blindly: it intentionally **does not settle OI-02**, identifiers and data representations vary, and the issuer must validate an authoritative C5 record instead of trusting raw client input.

## 17. Analytics, evaluation and ethics

### 17.1 Suggested UX/product telemetry (not required MVP reporting)

Use no additional unnecessary identifiable student data. Track only appropriately consented, privacy-reviewed aggregated counters or pseudonymous events. Suggested events:

| Event | Research question | Key fields (non-identifying where possible) |
|---|---|---|
| `progress_step_viewed` | Can users identify current stage? | phase, stage, available flag |
| `progress_step_completed` | Where does abandonment occur? | stage, completion source, duration bucket |
| `feedback_shown` | Which actionable messages are seen? | template ID, phase, severity (no raw answer) |
| `feedback_action_taken` | Do students act on permitted suggestions? | CTA ID, phase |
| `validation_result_viewed` | Do students interpret C5 outcome? | learner-state enum, scope concept |
| `achievement_shown` | Is recognition viewed? | achievement type, concept, first/repeat |
| `achievement_details_opened` | Do they inspect evidence/limits? | type, concept |

Do **not** log raw mathematical explanations, personal identifiers or classroom details merely to analyze reward engagement. Raw responses required for assessment belong to the established evidence system and its separate privacy policy.

### 17.2 Metric layers, reported separately

1. **Functional integrity:** correct state transitions; no false completion; achievement eligibility precision against reviewed scenarios.
2. **UX comprehension:** stage understanding, next-action comprehension, meaning of badge and limits.
3. **Engagement:** supported-session completion, voluntary continuation; not clicks/coins alone.
4. **Educational outcome:** independent retry and transfer performance, and if appropriately designed a pre/post assessment; *not* badge count as a learning outcome.

No arbitrary percentage improvement target or “scientifically proven learning gain” should be asserted without testing.

### 17.3 Test design candidate

- Start with moderated, task-based prototype sessions covering Confirmed, Uncertain, Retry fail, Transfer fail and both-pass routes.
- Ask a student to identify **current stage and next action without prompting**.
- Ask what the achievement proves and specifically whether it establishes mastery of **all SPL**. A correct answer must be bounded to assessed Distributive Property tasks.
- Compare clarity with/without selected UI mechanisms when practical while keeping **necessary pedagogical feedback** available to all participants.
- Observe whether the gamified affordances encourage careless guessing or rushing; if so, revise. This is an observed UX/design issue, not automatically an effectiveness statistic.
- If participants are minors, apply appropriate guardian consent, research ethics and data minimization.

### 17.4 Psychological safety and anti-dark-patterns

- No public ranking of student ability or struggling concepts.
- No threat of losing prior understanding/badge for missing daily engagement; no streak punishments.
- No artificial timeouts or urgency around mathematical reasoning.
- No random reward tied to misdiagnosis, answer speed or number of errors.
- No pressure to invite contacts or share achievement publicly.
- Allow opting out of decorative motion while preserving informational status.
- Always leave a user-respecting stop/return route consistent with approved product behavior.

## 18. Accessibility and content governance

### 18.1 Accessibility requirements — proposed design quality bar

- Each stepper item exposes an accessible label and semantic state, e.g. `Pemeriksaan konsep, langkah aktif`; not color-only.
- Use accessible progress descriptions for nested stage/soal counts; never read “100% mastery” when it measures pages viewed.
- Icons and achievement symbols need adjacent text descriptions.
- Informational status updates should be announced non-intrusively (`role=status`/ARIA live equivalent if web); errors distinct from instructions.
- Respect reduced-motion settings (CSS `prefers-reduced-motion` if web, platform equivalent otherwise).
- Ensure focus order, keyboard interaction, touch target and contrast satisfy applicable accessibility guidelines.
- For mathematical expressions, supply readable text or appropriately structured math semantics; do not make diagrams the only access to meaning.
- Keep animation short, non-blocking and fully skippable; no flashing effects.

### 18.2 Localization and copy review

- Primary proposed language: Indonesian student-friendly text; preserve mathematical terms accurately.
- Define glossary: `konsep`, `sifat distributif`, `pemeriksaan`, `penerapan mandiri`, `soal transfer`, `belum cukup bukti`.
- Avoid describing `Uncertain` as “kamu ragu-ragu”: it refers to the *assessment's evidence*, not the student's personality.
- Review all templates with mathematics subject-matter reviewer and product owner prior to release.
- Maintain versioned copy keys, not scattered hardcoded celebratory strings.

## 19. Research provenance and design rationale

### 19.1 Peer-reviewed research (not product-specific proof)

1. **Sailer & Homner (2020).** *The Gamification of Learning: A Meta-analysis.* Cognitive learning outcomes g≈0.49, motivational g≈0.36 across eligible comparisons; heterogeneous settings/effects. https://doi.org/10.1007/s10648-019-09498-w  
   **Design implication (inference):** gamification may help but should remain subordinate to learning task quality and validation.
2. **Wisniewski, Zierer & Hattie (2020).** *The Power of Feedback Revisited: A Meta-Analysis of Educational Feedback Research.* 435 studies, overall d≈0.48, with important variation linked to feedback information content. https://doi.org/10.3389/fpsyg.2019.03087  
   **Design implication:** favor specific, evidence-linked process feedback over praise-only microcopy.
3. **Hattie & Timperley (2007).** *The Power of Feedback.* Feed Up / Feed Back / Feed Forward framework. https://doi.org/10.3102/003465430298487  
   **Design implication:** pair factual result with relevant goal and actionable next step.
4. **Shute (2008).** *Focus on Formative Feedback.* https://doi.org/10.3102/0034654307313795  
   **Design implication:** timing, specificity and appropriate response to error matter; do not overwhelm.
5. **Law, Jimenez, Kittinger & Lopez (2024).** *A Meta-Analysis of Digital Badges in Learning Environments in Educational Settings.* Finds evidence supporting learning achievement, while effects on motivation are inconclusive. https://eric.ed.gov/?id=EJ1437449  
   **Design implication:** concept achievement should be criteria/evidence-based and its motivational benefit treated as a hypothesis.

### 19.2 Official product design precedents

6. **Khan Academy, 2024/2025**, Streaks and Levels: skill progression and manageable milestones, rather than mere logins. https://blog.khanacademy.org/get-motivated-to-learn-with-khan-academys-new-streaks-and-levels-features/  
   **Adopt idea:** meaningful progress tied to actual learning activity; **do not** copy a weekly streak into single-concept MVP.
7. **Khan Academy, mastery metrics:** differentiation of attempted/familiar/proficient/mastered levels, reflecting much broader assessment design. https://blog.khanacademy.org/why-khan-academy-will-be-using-skills-to-proficient-to-measure-learning-outcomes/  
   **Adopt idea:** evidence-linked progression; **do not** adopt their proficiency levels because Rethink only has bounded C5 states.
8. **Duolingo, Achievements:** celebrates milestones with collectible awards and personal records. https://blog.duolingo.com/achievement-badges/  
   **Adopt idea:** restrained milestone recognition and informative achievement detail; **do not** adopt XP/leaderboard dependencies.
9. **1EdTech Open Badges:** criteria and evidence in portable achievement assertions. https://www.1edtech.org/standards/open-badges  
   **Adopt idea:** make recognition criteria inspectable; **not** a decision to implement credential standards.
10. **W3C WCAG 2.2:** status messages, accessible controls, motion-related guidance. https://www.w3.org/TR/WCAG22/  
    **Adopt idea:** semantic, comprehensible state communication and respectful motion.

### 19.3 Product and source provenance

This design proposal is derived from the current repository's **approved Rethink PRD v1.0, 39 FRs and Technical Blueprint** as represented in `docs/prd/*`, `docs/technical/architecture.md`, `docs/decisions.md`, and the original uploaded PDF in `docs/source/`. It is **not** an approved 40th or 41st functional requirement. All scientific/professional design implications above are interpretations to be validated for Rethink, not proof of its effectiveness.

---

## 20. Delivery plan and approval-ready work breakdown

### Phase 0 — scope and decision review (blocking before final behavior)

- [ ] Product owner confirms whether all three mechanics are **included in MVP** or whether Concept Achievement is deferred.
- [ ] Review `OI-01..03`, `OPS-01..05` dependencies and do not pretend they are settled by UI text.
- [ ] Identify whether existing repository implements C3/C4/C5 state ownership and available events.
- [ ] Confirm terminology and whether UI needs a dedicated design system component library.
- [ ] Obtain mathematics review of any worked example/feedback used in prototype.

### Phase 1 — lowest-risk read-only progress UI

- [ ] Build compact JourneyStepper reading authoritative current phase.
- [ ] Build DiagnosticQuestionCounter with stable 3-core plus conditional Q4 semantics.
- [ ] Build GuidedStageStepper with viewed vs completed distinction (OPS-02 gate).
- [ ] Build ValidationStepper showing transfer as conditional, never as failed when not administered.
- [ ] Build accessible loading/saving/error states and ensure progress does not advance before confirmed persistence.
- [ ] Add consistency test with C2 map and result page (`FR-X-03`).

### Phase 2 — contextual feedback under rubric and timing control

- [ ] Create versioned feedback template catalog (`FB-01..26` above are design candidates).
- [ ] Implement informational status copy safe for diagnostic flow.
- [ ] Await OPS-01/04 for practice scoring, correction and exact hint behavior.
- [ ] Bind practice feedback to reviewed evaluator result and known error-pattern semantics.
- [ ] Enforce no live tutoring/hints in C5 validation tasks.
- [ ] Test ambiguous/technical error behavior separately from math incorrectness.

### Phase 3 — evidence-based achievement after C5 reliability

- [ ] Obtain approval for one concept achievement policy and post-review treatment (OI-02).
- [ ] Bind eligibility to authoritative, validly finalized C5 Understood result.
- [ ] Add bounded result card and detail explanation without SPL overclaim.
- [ ] Persist/deduplicate issuance only under reviewed OPS-05 plan.
- [ ] Optional subtle celebration respecting accessibility and reduced motion.
- [ ] Ensure other learner states receive accurate, non-shaming feedback and next action.

### Phase 4 — acceptance and research

- [ ] Run functional scenarios in [`gamification-acceptance-tests.md`](gamification-acceptance-tests.md), including all branches and error cases.
- [ ] Verify that any dependent OI/OPS acceptance criterion is labeled **blocked** until approved.
- [ ] Conduct small task-based UX sessions measuring stage comprehension and achievement interpretation.
- [ ] Report functional correctness separately from usability and learning effectiveness.
- [ ] Update `docs/decisions.md` only after real review; do not silently edit the 39 approved FRs.

### 20.1 Definition of done for each UI feature

The feature is done only when its reading source is clear, its required transitions match reviewed C1–C5 behavior, its non-happy-path states exist, it contains accurate bounded copy, it is keyboard/screen-reader accessible as applicable, it respects user motion preference, its relevant acceptance cases pass, and any unresolved OI/OPS behavior is still properly blocked or documented. “Looks finished” or “animation works” is not DoD.

### 20.2 Minimal code-review checklist for Codex

1. Which **FR ID(s)** does this UI expose and which OI/OPS ID gates it?
2. Is each displayed assertion traceable to a **source-owned** C3/C4/C5 fact?
3. Can a saved/unsaved race, reload, double click or optional path produce false completion?
4. Is there any answer leakage before diagnostic/validation response finalization?
5. Could a rejected/uncertain/unassessed learner be shown as “weak” or “mastered”?
6. Can a C5 ungraded answer or C4 completion issue an achievement? (**must be impossible**)
7. Does any component assume an undocumented API/model/schema or change selected mathematical content?
8. Are animation, language, semantic labels and assistive-technology behaviors reviewed?
9. Is the test matrix current and are blocked assertions clearly distinguished from passed ones?
10. Does the PR tell reviewers what decisions still require product/math approval?

## 21. Minimal source update instructions for the user's existing repository

**Do not overwrite the user's existing `AGENTS.md`, `docs/INDEX.md`, `docs/prd/requirements.md`, `docs/technical/architecture.md` or `docs/decisions.md` automatically.** Add references instead:

- In `docs/INDEX.md` → Essential files table and selective reading plans:  
  `docs/design/gamification-specification.md` — PROPOSED three-mechanic UX behavior, source ownership, open-dependency gates, copy, events, research; plus `docs/design/gamification-acceptance-tests.md`.
- In `AGENTS.md` → Required reading:  
  `For progress, instructional feedback, recognition or badges, read docs/design/gamification-specification.md and its acceptance tests. They are PROPOSED design, subordinate to approved PRD and open OI/OPS decisions; do not silently change product behavior.`
- In `docs/decisions.md` → Add a **proposal entry, not an approval**, e.g.:  
  `GAM-01 (Proposed) — Add Learning-loop Progress Indicator, Contextual Positive Feedback, and Concept Achievement. Scope/trigger/copy pending Product, UX, Pedagogy, Engineering review. Affected: C2/C3/C4/C5/FR-X, OI-01..03, OPS-01..05. Source: docs/design/gamification-specification.md.`
- Do not create extra FR IDs unless the product owner explicitly approves a requirements-change request with impact analysis.

---

**Document control:** Draft assembled from source-backed Rethink specifications plus external published research and explicit UX/engineering proposals. No pending OI/OPS decision is automatically closed by this document. Any source conflict must be escalated to the product owner with exact FR/decision IDs and before code that relies on that behavior is accepted.

# Rethink — Indonesian UX Copy Bank (id-ID)

> **Status:** DRAFT COPY CANDIDATES, **NOT AUTOMATICALLY RELEASE-APPROVED**.  
> **Read:** [`UX-WRITING.md`](UX-WRITING.md) and `../decisions.md` before wiring strings into UI.  
> **Use:** IDs are reference identifiers for centralized localization, not new requirement IDs.  
> **Notation:** `SAFE-DRAFT` = proposed wording within approved behavioral boundary; `BLOCKED` = requires a named pending decision; `CONDITIONAL` = only show when indicated evidence/state exists; `PREVIEW` = never real diagnostic or mastery state.

## 0. Rules for Codex

- Never issue dynamic diagnostic conclusions by choosing copy templates alone. Use actual authorized C3/C5 state.
- Copy marked `BLOCKED` is **not** released or used to fill unknown business logic.
- All strings are original Rethink drafts; none are asserted to be copied from Gojek.
- Show the exact action the app can perform; if an endpoint is absent, don't render misleading CTA.
- Use sentence case for controls and preserve accessible labels for icon-only actions.

## 1. Onboarding — conversational, concise, aspirational but truthful

> **Current implementation note (19 Oct 2026):** the shipped onboarding is five **activity-gated** steps: name → core-loop taps → sample MCQ → chatbot preview → ready. There is no audio-preference slide, no slide picker, and no skip. Audio is per slide, default on when available, with a top-right mute control.

### 1.1 Current five-step onboarding

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `ob.current.name.title` | Headline | Hai, aku Jimmy! Aku akan membimbing kamu. | SAFE-DRAFT |
| `ob.current.name.question` | Headline | Siapa nama kamu? | SAFE-DRAFT |
| `ob.current.name.field` | Input label | Nama kamu | SAFE-DRAFT |
| `ob.current.name.helper` | Helper | Nama dipakai untuk menyapa kamu. | SAFE-DRAFT |
| `ob.current.loop.title` | Headline | Cek, belajar, lalu coba. | SAFE-DRAFT |
| `ob.current.loop.step.1` | Tap card | Cek — kumpulkan bukti dari jawabanmu. | SAFE-DRAFT |
| `ob.current.loop.step.2` | Tap card | Belajar — pahami konsep dengan panduan. | SAFE-DRAFT |
| `ob.current.loop.step.3` | Tap card | Coba — terapkan sendiri tanpa bantuan. | SAFE-DRAFT |
| `ob.current.loop.hint` | Helper | Geser token ke tiap titik | SAFE-DRAFT |
| `ob.current.check.title` | Headline | Contoh cek singkat. | PREVIEW — not diagnosis |
| `ob.current.check.prompt` | Question | Bentuk mana yang setara dengan 3(x + 2)? | PREVIEW — sample item |
| `ob.current.check.option.a` | Option | 3x + 6 | PREVIEW |
| `ob.current.check.option.b` | Option | 3x + 2 | PREVIEW |
| `ob.current.check.option.c` | Option | 3x + 5 | PREVIEW |
| `ob.current.check.helper` | Helper | Contoh · bukan diagnosis | PREVIEW |
| `ob.current.chatbot.title` | Headline | Tanya konsep, bukan minta jawaban. | SAFE-DRAFT |
| `ob.current.chatbot.opener` | Chat bubble | Tanya aku soal konsepnya. | SAFE-DRAFT |
| `ob.current.chatbot.chip` | Suggested question | Kenapa 3(x + 2) = 3x + 6? | PREVIEW |
| `ob.current.chatbot.answer` | Answer | Karena 3 dikalikan ke x dan ke 2. | PREVIEW |
| `ob.current.chatbot.note` | Helper | Chatbot membantu menjelaskan konsep, bukan menggantikan proses berpikirmu. | SAFE-DRAFT |
| `ob.current.ready.title` | Headline | Siap mulai? | SAFE-DRAFT |
| `ob.current.ready.body` | Body | Tanpa akun · mode tamu | SAFE-DRAFT |
| `ob.current.ready.cta` | CTA | Mulai | SAFE-DRAFT |
| `ob.current.gate.helper` | Helper | Selesaikan aktivitas di atas untuk lanjut. | SAFE-DRAFT |
| `ob.current.audio.mute` | A11y label | Matikan audio / Nyalakan audio | CONDITIONAL — actual state |

### 1.2 Broader exploratory onboarding copy (not the current screen list)

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `ob.welcome.title` | Headline | Pernah nyangkut di tengah soal? | SAFE-DRAFT |
| `ob.welcome.body` | Body | Kadang kita tahu rumusnya, tapi belum paham kapan dipakai. | SAFE-DRAFT |
| `ob.welcome.cta` | CTA | Lihat caranya | SAFE-DRAFT |
| `ob.value.title` | Headline | Yuk, cari bagian yang belum nyambung | SAFE-DRAFT |
| `ob.value.body` | Body | Dari jawabanmu, Rethink mencoba melihat konsep mana yang mungkin perlu diperhatikan. | SAFE-DRAFT |
| `ob.value.cta` | CTA | Lanjut | SAFE-DRAFT |
| `ob.loop.title` | Headline | Cek. Pelajari. Coba sendiri. | SAFE-DRAFT |
| `ob.loop.body` | Body | Ada alur yang jelas, dari cek pemahaman sampai mencoba soal tanpa bantuan. | SAFE-DRAFT |
| `ob.loop.step.1` | Label | Cek pemahaman | SAFE-DRAFT |
| `ob.loop.step.2` | Label | Belajar terarah | SAFE-DRAFT |
| `ob.loop.step.3` | Label | Coba sendiri | SAFE-DRAFT |
| `ob.loop.cta` | CTA | Berikutnya | SAFE-DRAFT |
| `ob.visual.title` | Headline | Biar konsepnya lebih kebayang | SAFE-DRAFT |
| `ob.visual.body` | Body | Lihat penjelasan visual, ikuti contoh, lalu lengkapi langkahnya sendiri. | SAFE-DRAFT |
| `ob.progress.title` | Headline | Setiap langkah punya tujuan | SAFE-DRAFT |
| `ob.progress.body` | Body | Lihat yang sudah selesai. Hasil pemahaman tetap ditentukan lewat soal mandiri. | SAFE-DRAFT |
| `ob.progress.preview.label` | Chip | Contoh tampilan | PREVIEW — not real progress |
| `ob.audio.title` | Headline | Mau ditemani suara? | SAFE-DRAFT |
| `ob.audio.body` | Body | Nyalakan audio kalau ingin mendengarkan panduan. Tanpa audio juga bisa. | SAFE-DRAFT |
| `ob.audio.enable` | CTA | Nyalakan audio | CONDITIONAL — player implemented |
| `ob.audio.disable` | CTA | Tanpa audio | SAFE-DRAFT |
| `ob.audio.on` | Status | Audio panduan aktif | CONDITIONAL — verified enabled |
| `ob.audio.off` | Status | Audio panduan nonaktif | CONDITIONAL — verified disabled |
| `ob.audio.fail` | Error | Audio belum bisa diputar. Kamu tetap bisa lanjut membaca. | CONDITIONAL — actual play failure |
| `ob.skip` | Secondary | Lewati perkenalan | CONDITIONAL — skip enabled |
| `ob.finish.title` | Headline | Siap mulai cek pemahamanmu? | SAFE-DRAFT |
| `ob.finish.body` | Body | Kita mulai dari Sistem Persamaan Linear dan sifat distributif. | SAFE-DRAFT |
| `ob.finish.cta` | CTA | Mulai cek pemahaman | CONDITIONAL — supported entry |
| `ob.account.title` | Headline | Bikin akun dulu? | BLOCKED — account requirement and flow unspecified |
| `ob.account.body` | Body | Akun bisa membantu menyimpan progresmu. | BLOCKED — only if real persistence exists |
| `ob.reminder.title` | Headline | Mau diingatkan buat belajar? | BLOCKED — notifications not approved |
| `ob.duration.body` | Body | Sesi ini sekitar {minutes} menit. | BLOCKED unless empirically measured/configured estimate approved |

## 2. Catalog / learning map (C1/C2)

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `catalog.home.title` | Headline | Mau mulai dari mana? | SAFE-DRAFT |
| `catalog.subject.algebra` | Label | Aljabar | SAFE-DRAFT |
| `catalog.topic.spl` | Label | Sistem Persamaan Linear (SPL) | SAFE-DRAFT |
| `catalog.support.available` | Chip | Cek pemahaman tersedia | CONDITIONAL — capability flag true |
| `catalog.support.unavailable` | Chip | Belum tersedia | CONDITIONAL — capability flag false |
| `catalog.support.unavailable.body` | Body | Topik ini belum punya sesi cek pemahaman di Rethink. | CONDITIONAL |
| `catalog.start.cta` | CTA | Mulai cek pemahaman | CONDITIONAL — topic eligible |
| `catalog.notlocked` | Helper | Belum tersedia bukan berarti kamu belum mampu. | CONDITIONAL — clarify availability |
| `map.explore.title` | Heading | Lihat kaitan antar konsep | SAFE-DRAFT |
| `map.explore.body` | Body | Peta ini menunjukkan hubungan topik dan konsep, bukan nilai kemampuanmu. | SAFE-DRAFT |
| `map.focus.confirmed` | Label | Fokus belajar: sifat distributif | CONDITIONAL — confirmed C3 |
| `map.focus.rejected` | Label | Hambatan yang diperiksa tidak didukung bukti | CONDITIONAL — rejected C3 |
| `map.focus.uncertain` | Label | Hasil pemeriksaan belum pasti | CONDITIONAL — uncertain C3 |
| `map.progress.unassessed` | Status | Belum dinilai | CONDITIONAL — no applicable C5 evidence |
| `map.progress.understood` | Status | Berhasil pada validasi konsep | CONDITIONAL — approved C5 understood |
| `map.progress.procedural` | Status | Perlu latihan pada bentuk soal lain | CONDITIONAL — C5 procedural only |
| `map.progress.reinforcement` | Status | Perlu penguatan | CONDITIONAL — C5 needs reinforcement |
| `map.tooltip.unavailable` | Tooltip | Konsep ini ditampilkan untuk melihat hubungannya, belum untuk didiagnosis. | CONDITIONAL |

## 3. Diagnostic flow (C3) — **no instructional hints during evidence collection**

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `diag.entry.title` | Heading | Kita cek pemahamanmu dulu | SAFE-DRAFT |
| `diag.entry.body` | Body | Jawab sesuai yang kamu pikirkan. Kalau diminta menjelaskan, tulis juga alasannya, ya. | SAFE-DRAFT |
| `diag.question.progress` | Status | Soal {current} dari {total} | CONDITIONAL — saved sequence positions |
| `diag.question.role.q1` | SR/help text | Pilih satu jawaban pada soal Sistem Persamaan Linear. | SAFE-DRAFT |
| `diag.question.role.q2` | SR/help text | Tulis bentuk matematika yang setara. | SAFE-DRAFT |
| `diag.question.role.q3` | SR/help text | Jelaskan alasan di balik langkah matematika ini. | SAFE-DRAFT |
| `diag.answer.placeholder` | Input help | Tulis jawabanmu di sini | SAFE-DRAFT |
| `diag.explanation.placeholder` | Input help | Tulis alasanmu di sini | SAFE-DRAFT |
| `diag.submit` | CTA | Kirim jawaban | SAFE-DRAFT |
| `diag.sending` | Status | Sedang mengirim jawaban | CONDITIONAL — in flight |
| `diag.saved` | Status | Jawaban tersimpan | CONDITIONAL — server acknowledgement |
| `diag.next` | CTA | Soal berikutnya | CONDITIONAL — next exists |
| `diag.probe.title` | Heading | Ada satu pertanyaan tambahan | CONDITIONAL — approved Q4 selected |
| `diag.probe.body` | Body | Satu hal lagi perlu diperiksa sebelum hasilnya disimpulkan. | CONDITIONAL — Q4 triggered |
| `diag.probe.progress` | Status | Pertanyaan tambahan | CONDITIONAL — Q4 |
| `diag.evaluating` | Status | Sedang memeriksa jawabanmu | CONDITIONAL — evaluation running |
| `diag.result.title` | Heading | Hasil cek pemahaman | SAFE-DRAFT |
| `diag.result.confirmed.title` | Heading | Ada hambatan yang didukung bukti | CONDITIONAL — actual Confirmed |
| `diag.result.confirmed.body` | Body | Dari jawaban yang diperiksa, ada bukti yang mendukung hambatan pada sifat distributif. Ini belum menjelaskan semua kesulitan SPL. | CONDITIONAL — actual Confirmed |
| `diag.result.confirmed.cta` | CTA | Pelajari sifat distributif | CONDITIONAL — supported C4 |
| `diag.result.rejected.title` | Heading | Hambatan ini tidak didukung bukti | CONDITIONAL — actual Rejected |
| `diag.result.rejected.body` | Body | Pemeriksaan ini belum mendukung adanya hambatan pada sifat distributif. Konsep lain dan seluruh SPL belum dinilai dari hasil ini. | CONDITIONAL — actual Rejected |
| `diag.result.uncertain.title` | Heading | Hasilnya belum bisa disimpulkan | CONDITIONAL — actual Uncertain |
| `diag.result.uncertain.body` | Body | Bukti dari jawabanmu belum cukup jelas atau belum konsisten untuk menyimpulkan hambatan pada konsep ini. | CONDITIONAL — actual Uncertain |
| `diag.result.review.cta` | CTA | Ulas konsep ini | CONDITIONAL — review offered to non-confirmed |
| `diag.result.explore.cta` | CTA | Kembali ke topik | CONDITIONAL — actual action available |
| `diag.result.scope.note` | Helper | Hasil ini hanya membahas sifat distributif yang diperiksa. | SAFE-DRAFT |
| `diag.result.allcorrect.title` | Heading | Belum ditetapkan | BLOCKED — OI-03 |
| `diag.result.allcorrect.body` | Body | Perlu keputusan produk untuk pola semua jawaban benar. | BLOCKED — OI-03 (dev only) |
| `diag.failure.unavailable` | Error | Hasilnya belum tersedia. Coba lagi nanti. | CONDITIONAL — system unavailable |

## 4. Guided Learning (C4) — active support

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `learn.entry.confirmed.title` | Heading | Yuk, pelajari sifat distributif | CONDITIONAL — Confirmed Recovery |
| `learn.entry.review.title` | Heading | Mau lihat ulang konsep ini? | CONDITIONAL — Optional Review |
| `learn.entry.review.note` | Helper | Ulasan ini tidak berarti kamu punya hambatan yang sudah terkonfirmasi. | CONDITIONAL |
| `learn.steps.progress` | Status | {done} dari 3 tahap belajar selesai | CONDITIONAL — actual completion |
| `learn.visual.title` | Heading | Biar konsepnya lebih kebayang | SAFE-DRAFT |
| `learn.visual.prompt` | Body | Perhatikan bagaimana angka di luar kurung dikalikan ke setiap suku di dalamnya. | CONDITIONAL — reviewed math item |
| `learn.worked.title` | Heading | Coba lihat langkahnya | SAFE-DRAFT |
| `learn.worked.prompt` | Body | Tiap langkah punya alasan. Yuk, ikuti satu per satu. | SAFE-DRAFT |
| `learn.practice.title` | Heading | Sekarang giliran kamu | SAFE-DRAFT |
| `learn.practice.body` | Body | Lengkapi bagian yang kosong sesuai langkah matematikanya. | SAFE-DRAFT |
| `learn.practice.correct` | Feedback | Tepat. Faktor di luar kurung sudah dikalikan ke kedua suku. | BLOCKED — OPS-01 / OPS-04: trigger and item validation |
| `learn.practice.incorrect` | Feedback | Coba lihat lagi: sudah dikalikan ke semua suku di dalam kurung? | BLOCKED — OPS-01 / OPS-04: hint policy |
| `learn.practice.retry` | CTA | Coba langkah ini lagi | BLOCKED — OPS-01 |
| `learn.complete.title` | Heading | Tahap belajar selesai | BLOCKED — OPS-02 completion criteria |
| `learn.complete.body` | Body | Sekarang saatnya mencoba tanpa panduan. | BLOCKED — OPS-02; only eligible confirmed path |
| `learn.complete.cta` | CTA | Coba sendiri | BLOCKED — completion and eligibility gating |
| `learn.complete.notmastery` | Helper | Selesai belajar bukan berarti hasil pemahaman sudah dinilai. | SAFE-DRAFT |

## 5. Knowledge Validation (C5) — evidence-bound and scaffold-free

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `val.retry.title` | Heading | Sekarang coba sendiri | CONDITIONAL — eligible completed Confirmed Recovery |
| `val.retry.body` | Body | Kerjakan tanpa petunjuk dulu, ya. | CONDITIONAL |
| `val.retry.submit` | CTA | Kirim jawaban | CONDITIONAL |
| `val.retry.passed` | Status | Jawaban mandirimu berhasil pada soal ini | CONDITIONAL — item-level success |
| `val.transfer.title` | Heading | Coba di bentuk soal yang berbeda | CONDITIONAL — successful retry only |
| `val.transfer.body` | Body | Konsepnya sama, tapi cara soal ini disajikan berbeda. | CONDITIONAL — approved transfer task |
| `val.transfer.unattempted` | Status | Belum diberikan | CONDITIONAL — retry unsuccessful |
| `val.result.understood.title` | Heading | Kamu berhasil pada dua bentuk soal | CONDITIONAL — valid retry + transfer pass |
| `val.result.understood.body` | Body | Kamu sudah menerapkan sifat distributif secara mandiri pada soal yang diuji. Ini belum berarti semua SPL sudah dikuasai. | CONDITIONAL |
| `val.result.procedural.title` | Heading | Sudah bisa di soal mandiri | CONDITIONAL — retry pass + transfer fail |
| `val.result.procedural.body` | Body | Bentuk soal yang berbeda masih perlu dilatih. Hasil ini hanya berlaku pada konsep yang diuji. | CONDITIONAL |
| `val.result.reinforcement.title` | Heading | Masih ada yang perlu diperkuat | CONDITIONAL — retry fail, not ambiguous |
| `val.result.reinforcement.body` | Body | Kamu bisa mengulang penjelasan dan latihan sifat distributif yang tadi. | CONDITIONAL |
| `val.result.reinforcement.cta` | CTA | Ulangi pembelajaran | CONDITIONAL — supported existing C4 route |
| `val.result.scope` | Helper | Status ini hanya untuk sifat distributif pada soal yang diperiksa. | SAFE-DRAFT |
| `val.response.unknown` | Error | Jawaban ini belum bisa diperiksa. | BLOCKED — OPS-03 exact handling |
| `val.response.retry` | CTA | Perbaiki jawaban | BLOCKED — OPS-03 if supported |
| `val.optional.eligibility` | Status | Belum ditetapkan | BLOCKED — OI-02 (internal placeholder only) |

## 6. Gamification — progress, feedback, concept achievement

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `gam.progress.activity` | Status | {done} dari {total} tahap selesai | CONDITIONAL — actual activity state |
| `gam.progress.next` | Helper | Berikutnya: {next_step} | CONDITIONAL — trusted next step |
| `gam.progress.noevidence` | Helper | Belum ada hasil validasi untuk konsep ini | CONDITIONAL — no C5 result |
| `gam.feedback.saved` | Toast | Oke, jawaban tersimpan | CONDITIONAL — true persisted |
| `gam.feedback.progress` | Toast | Tahap ini selesai. Lanjut ke bagian berikutnya. | CONDITIONAL — approved completion semantics |
| `gam.achievement.preview` | Label | Contoh pencapaian konsep | PREVIEW |
| `gam.achievement.title` | Heading | Pencapaian konsep terbuka! | CONDITIONAL — eligible, committed achievement |
| `gam.achievement.concept` | Subheading | Sifat distributif | CONDITIONAL — evidence-backed concept |
| `gam.achievement.body` | Body | Kamu berhasil di soal mandiri dan soal bentuk berbeda yang diuji. | CONDITIONAL — verified C5 Understood |
| `gam.achievement.scope` | Helper | Pencapaian ini tidak menilai seluruh topik SPL. | CONDITIONAL |
| `gam.achievement.cta` | CTA | Lihat hasilnya | CONDITIONAL — result screen exists |
| `gam.achievement.awaiting` | Status | Hasil validasi belum tersedia | CONDITIONAL — avoid optimistic award |

## 7. System errors, empty/loading, audio/accessibility

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `sys.loading` | Status | Sedang memuat | CONDITIONAL |
| `sys.saving` | Status | Sedang menyimpan jawaban | CONDITIONAL |
| `sys.save.success` | Status | Jawaban tersimpan | CONDITIONAL — ack received |
| `sys.save.unknown.title` | Error | Belum bisa memastikan jawaban tersimpan | CONDITIONAL — unknown persistence |
| `sys.save.unknown.body` | Body | Periksa status jawaban dulu sebelum mengirim ulang. | CONDITIONAL — status checker exists; otherwise revise |
| `sys.network.offline.title` | Error | Koneksi terputus | CONDITIONAL — offline confirmed |
| `sys.network.offline.body` | Body | Jawabanmu belum dipastikan tersimpan. Coba sambungkan internet lalu lanjutkan. | CONDITIONAL — if relevant |
| `sys.service.unavailable.title` | Error | Layanan sedang tidak tersedia | CONDITIONAL — actual outage |
| `sys.service.unavailable.body` | Body | Pemeriksaan belum bisa dilanjutkan sekarang. Coba lagi nanti. | CONDITIONAL |
| `sys.topic.unavailable.title` | Error | Topik ini belum tersedia | CONDITIONAL — unsupported capability |
| `sys.topic.unavailable.body` | Body | Saat ini, cek pemahaman tersedia untuk SPL. | CONDITIONAL — supported scope current |
| `sys.session.expired.title` | Error | Sesi ini sudah berakhir | CONDITIONAL — actual session expired |
| `sys.session.expired.body` | Body | Mulai sesi baru untuk melanjutkan. | CONDITIONAL — restart supported |
| `sys.audio.playfail` | Status | Audio belum bisa diputar. Kamu tetap bisa lanjut membaca. | CONDITIONAL |
| `sys.unknown.title` | Error | Ada kendala saat memuat halaman | CONDITIONAL — actual error |
| `sys.unknown.retry` | CTA | Coba lagi | CONDITIONAL — retry works |
| `sys.unsupported.action` | Error | Fitur ini belum tersedia | CONDITIONAL — truth about scope |
| `sys.empty.map` | Empty state | Belum ada hasil yang bisa ditampilkan di sini | CONDITIONAL — based on evidence state |
| `sys.exit.title` | Dialog | Keluar dari sesi ini? | CONDITIONAL — exit offered |
| `sys.exit.body` | Dialog | Perubahan yang belum tersimpan bisa hilang. | CONDITIONAL — actual behavior verified |
| `sys.exit.cancel` | Button | Tetap di sini | CONDITIONAL |
| `sys.exit.confirm` | Button | Keluar dari sesi | CONDITIONAL |
| `sys.audio.toggle.on.a11y` | Accessible label | Nyalakan audio panduan | CONDITIONAL |
| `sys.audio.toggle.off.a11y` | Accessible label | Matikan audio panduan | CONDITIONAL |

## 8. Forbidden and unsafe combinations

| Mistake | Reason / affected source |
|---|---|
| `Confirmed` result + `Selamat, kamu sudah paham` | C3 cannot assign C5 learner state; FR-C3-07, FR-C4-08 |
| `Rejected` result + `Semua konsep kamu kuat` | Rejected isn't universal mastery; FR-C3-09 |
| `Uncertain` result + `Kamu salah` | Insufficient evidence is valid outcome; FR-C3-07 |
| `Guided Learning selesai` + `Achievement Understood` | No validation evidence; FR-C4-08, FR-C5-05 |
| `Retry gagal` + `Transfer gagal` | Transfer unadministered; FR-C5-03 |
| `Optional Review` + `Langsung validasi` | OI-02 unresolved |
| All core diagnostic answers correct → hardcoded Rejected | OI-03 unresolved |
| Math evaluator unavailable → Needs Reinforcement | OPS-03; no automatic conceptual inference |
| Network request sent → `Jawaban tersimpan` without acknowledgement | FR-X and persistence integrity |
| Onboarding preview event → real concept achievement | Gamification is evidence-bounded |

## 9. Localization release checklist (copy-bank-specific)

- Every rendered ID has an approved owner and a semantic trigger.
- Labels support text expansion and screen readers without truncating essential qualifiers.
- Decision-blocked strings have no production activation path.
- Narration and visible text preserve the same intent in Bahasa Indonesia.
- Correctness and mastery words appear only after valid evaluation.
- All required variable values are trusted and appropriately escaped.
- Student responses and identity are not sent into analytics by default.
- Consistent terminology: `cek pemahaman`, `sifat distributif`, `coba sendiri`, `pencapaian konsep`.


### Slide 3 familiarity preview — requested revision, 19 Oct 2026

These examples record self-reported familiarity only, locally in onboarding memory. They do not grade answers, select a learning level, write backend evidence, or change C3/C5 state. Mathematical examples are draft previews, not the approved question bank.

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `ob.familiarity.intro` | Jimmy bubble | Aku punya 5 contoh soal. Apakah kamu bisa mengerjakannya? | PREVIEW |
| `ob.familiarity.notyet` | Choice | Belum | PREVIEW — self-report, not incorrect |
| `ob.familiarity.unsure` | Choice | Ragu | PREVIEW — self-report, not Uncertain diagnosis |
| `ob.familiarity.familiar` | Choice | Bisa | PREVIEW — self-report, not Understood |
| `ob.familiarity.label` | Disclaimer | Contoh perkenalan · bukan diagnosis | PREVIEW |
| `ob.familiarity.review` | Review | Pilihan sudah sesuai semua? | PREVIEW |
| `ob.familiarity.edit` | Helper | Ketuk contoh di atas kalau ingin mengubah pilihan. Ini bukan penilaian kemampuanmu. | PREVIEW |
| `ob.familiarity.confirm` | CTA | Ya, pilihanku sudah sesuai | PREVIEW |
| `ob.familiarity.confirmed` | Confirmation | Ya, sudah sesuai | PREVIEW |
| `ob.familiarity.item.1` | Draft example | Bisa mengalikan bentuk ini? — 2(x + 4) | PREVIEW |
| `ob.familiarity.item.2` | Draft example | Bisa menyederhanakan bentuk ini? — 3(x + 2) − 2x | PREVIEW |
| `ob.familiarity.item.3` | Draft example | Bisa mencari nilai x? — 2(x + 3) = 3x − 1 | PREVIEW |
| `ob.familiarity.item.4` | Draft example | Bisa mencari nilai x? — 3(x − 2)/4 − (x + 1)/2 = 2 | PREVIEW |
| `ob.familiarity.item.5` | Draft example | Bisa mencari nilai x dan y? — 3(x − 2)/4 − (y + 1)/2 = 2; 2x + 3y = 28 | PREVIEW |

| `ob.familiarity.edit.cta` | CTA | Edit pilihan | PREVIEW — opens example selector |
| `ob.familiarity.edit.title` | Selector title | Pilih soal yang ingin diubah | PREVIEW |
| `ob.familiarity.restart` | CTA | Ulangi semua | PREVIEW — clears only onboarding familiarity responses |
| `ob.familiarity.confirm.all` | CTA | Sudah sesuai semua | PREVIEW — confirms self-report only |

### Slide 4 guided chat preview — user-requested revision, 19 Oct 2026

All `ob.chat.preview.*` copy is PREVIEW: curated local simulation, no AI request or diagnostic/learning-state inference. Headline reuses SAFE-DRAFT `ob.visual.title`. Existing note `ob.current.chatbot.note` remains the intended boundary.

| ID | Component | Draft text | Status |
|---|---|---|---|
| `ob.chat.preview.label` | Header | Simulasi percakapan | PREVIEW |
| `ob.chat.preview.opener` | Jimmy | Ada langkah yang bikin bingung, kita bahas konsep di baliknya. | PREVIEW |
| `ob.chat.preview.concept` | Prompt | Bagaimana cara mengerjakan 2(x + 4)? | PREVIEW |
| `ob.chat.preview.learning` | Prompt | Kalau bingung di langkah seperti ini, Rethink bantu dari mana? | PREVIEW |
| `ob.chat.preview.thinking` | Status | Jimmy menyiapkan contoh… | PREVIEW — only while local reply is pending |
| `ob.chat.preview.explain` | Reply | Angka 2 mengalikan setiap suku di dalam kurung: x dan 4. | PREVIEW |
| `ob.chat.preview.touch` | Helper | Ketuk tiap perkalian untuk melihat bagiannya. | PREVIEW |
| `ob.chat.preview.result` | Reply | Hasilnya digabung menjadi 2x + 8. Ini yang disebut sifat distributif. | PREVIEW |
| `ob.chat.preview.origin` | Reply | Rethink mulai dari jawabanmu untuk mencari konsep yang mungkin perlu diperhatikan. | PREVIEW |
| `ob.chat.preview.support` | Reply | Untuk konsep yang didukung, ada penjelasan visual, contoh, dan latihan dengan panduan. | PREVIEW |
| `ob.chat.preview.boundary` | Reply | Chat ini memperlihatkan cara membahas konsep. Hasil pemahaman tetap perlu dilihat lewat soal mandiri. | PREVIEW |
| `ob.chat.preview.disclaimer` | Label | Contoh penjelasan · bukan diagnosis | PREVIEW |

| `ob.chat.preview.title` | Headline | Bingung saat mengerjakan? Tanya Jimmy! | PREVIEW — curated concept-chat simulation |

| `ob.chat.preview.reasoning` | Follow-up | Kenapa 2 dikalikan ke x dan juga ke 4? | PREVIEW |
| `ob.chat.preview.groups` | Reply | 2(x + 4), artinya ada dua kelompok yang masing-masing berisi x + 4. | PREVIEW |
| `ob.chat.preview.groups.conclusion` | Reply | Jadi, x muncul dua kali dan 4 juga muncul dua kali. Itu sebabnya keduanya dikalikan 2. | PREVIEW |

### Curriculum catalog — user-requested reference layout, 20 Oct 2026

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `catalog.curriculum.count` | Card metadata | {count} subtopik | CONDITIONAL — actual children count |
| `catalog.curriculum.active` | Card metadata | Pemeriksaan tersedia | CONDITIONAL — active backend diagnosis capability for SPL |
| `catalog.curriculum.support` | Card metadata | Konsep pendukung SPL | CONDITIONAL — active distribution concept with SPL entry |
| `catalog.curriculum.unavailable` | Card metadata | Belum tersedia | CONDITIONAL — represented-only material |
| `catalog.curriculum.loading` | Loading | Menyiapkan materi… | CONDITIONAL — loading catalog |
| `catalog.curriculum.pending` | Empty title | Materi sedang disiapkan | CONDITIONAL — no topic metadata |
| `catalog.curriculum.pending.body` | Empty body | Subtopik untuk materi ini belum tersedia. | CONDITIONAL — actual empty list |
| `catalog.curriculum.coverage` | Detail | Materi ini sudah ada di peta kurikulum, tetapi belum tersedia untuk belajar atau pemeriksaan konsep. | CONDITIONAL — represented-only leaf |
| `catalog.curriculum.review` | Detail | Konsep ini dapat ditinjau melalui alur Sistem Persamaan Linear. | CONDITIONAL — distribution, using existing SPL workflow |
| `catalog.curriculum.open` | CTA | Lihat alur pemeriksaan | CONDITIONAL — supported SPL entry exists |
| `catalog.curriculum.open.spl` | CTA | Lihat alur SPL | CONDITIONAL — supported SPL entry exists |
| `catalog.curriculum.locked` | Status | Belum tersedia untuk belajar atau pemeriksaan | CONDITIONAL — no supported entry |

### Curriculum hierarchy clarity — 20 Oct 2026

User requests an explicit visual distinction between material, subtopic, and sub-subtopic. Use **Bagian belajar** as the accessible user-facing name for the deepest catalog level; the backend taxonomy remains unchanged. These are navigation labels, not assessment stages.

| ID | Component | Draft text | Status / condition |
|---|---|---|---|
| `catalog.level.material` | Level label | Materi | SAFE-DRAFT |
| `catalog.level.subtopic` | Level label | Subtopik | SAFE-DRAFT |
| `catalog.level.lesson` | Level label | Bagian belajar | SAFE-DRAFT — deepest catalog level |
| `catalog.level.material.guide` | Guidance | Pilih satu dari {count} subtopik, lalu lihat bagian belajarnya. | CONDITIONAL — actual child count |
| `catalog.level.subtopic.guide` | Guidance | Ada {count} bagian belajar di sini. Pilih bagian untuk melihat detail dan ketersediaannya. | CONDITIONAL — actual child count |
| `catalog.level.lesson.guide` | Guidance | Lihat cakupan bagian belajar ini sebelum mulai. | SAFE-DRAFT |
| `catalog.level.parts` | Card metadata | {count} bagian belajar | CONDITIONAL — actual child count |
| `catalog.level.position` | Accessibility | Posisi: {path} | CONDITIONAL — actual navigation hierarchy |

| `catalog.curriculum.mvp.locked` | Status | Belum tersedia dalam MVP | CONDITIONAL — direct catalog entry locked outside SPL; distribution remains available through its recovery flow |
| `catalog.curriculum.mvp.locked.hint` | Accessibility | Saat ini pemeriksaan hanya tersedia untuk Sistem Persamaan Linear. | CONDITIONAL — current MVP scope |

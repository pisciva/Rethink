# Rethink — UX Writing & Conversation Design Guidelines

> **Status:** PROPOSED / working design standard; requires Product + UX approval before being binding.  
> **Version:** 1.0 · **Prepared:** 19 October 2026  
> **Language:** Indonesian (`id-ID`) · **Audience:** Indonesian high-school students, target profile not yet fully validated.  
> **Placement:** `docs/design/UX-WRITING.md`  
> **Companions:** [`ux-writing-copy-bank.md`](ux-writing-copy-bank.md), [`ux-writing-acceptance-tests.md`](ux-writing-acceptance-tests.md), [`DESIGN.md`](DESIGN.md), [`gamification-specification.md`](gamification-specification.md).  
> **Read before implementation:** `../../AGENTS.md`, `../INDEX.md`, `../prd/requirements.md`, `../prd/mvp-definition.md`, `../decisions.md`.

## 0. Executive contract — read first

**Voice direction:** *Teman belajar yang cerdas, santai, dan nggak menghakimi.* Rethink should sound approachable like a thoughtful Indonesian friend who explains clearly, keeps promises, and respects the learner's judgment. The voice is **inspired by published Gojek content-design approaches, NOT Gojek's internal playbook or a claim of affiliation**. Rethink must develop an original identity, not copy Gojek slogans, trademarked campaign lines, jokes, illustrations, or distinctive example error messages.

**Always:** `clear → truthful → actionable → empathetic → expressive`, in that precedence. A witty line that obscures math evidence is a bad line. A friendly line that implies unearned mastery is a product defect.

- Preserve exact approved domain behavior: MVP `Aljabar → Sistem Persamaan Linear (SPL) → Distributive Property`; C1–C5 and 39 approved Must Have FRs.
- C3 diagnostic outcomes are `Confirmed / Rejected / Uncertain`; C5 learner states are `Understood / Procedural Only / Needs Reinforcement`. UI text is localized but **must not redefine meaning**.
- Diagnosis does not prove every source of learning difficulty; optional review does not confirm a blocker; lesson completion does not grant understanding; a retry pass alone is not Understood.
- Do not finalize open issues OI-01/02/03 or OPS-01..05 through copy; dependent examples are **DRAFT / CONDITIONAL**.
- Do not invent final product features: account systems, persistence guarantees, push notifications, new topic coverage, duration promises, teacher certification, or unsupported proficiency levels.
- Error copy must accurately distinguish user input, math evaluation ambiguity, network failure, and unavailable capabilities. Never blame students for technical failures.
- Onboarding audio, when implemented, uses approved Indonesian scripts, an explicit toggle and synchronized on-screen text. Audio never substitutes for visible instructions or mathematical content.
- Use stable copy IDs and factual event state; avoid improvised runtime LLM copy in diagnosis/validation status messages.

**Normative words in this guide:** MUST = requirement of this *proposed* content standard after adoption; SHOULD = strong suggestion; MAY = option. This guide alone does not revise the approved PRD.

## 1. Research basis: what is verified and what is not

### 1.1 Gojek primary-origin / firsthand materials

| Source | What it actually establishes | Rethink adaptation |
|---|---|---|
| Gojek UX Writers, *Language No Bar: How We Localise UX Copies at Gojek* (2021) | Writers state **Clear, Concise, Helpful**; understand feature purpose, UI, user reaction; localization by intent and cultural context; consumer voice may be casual/witty while business contexts vary; proofreading and research matter. | Separate information quality from friendly voice; test Indonesian terminology with students; vary tone by risk. |
| Galih, *Design with Love: the creative process behind GOJEK redesign* (2018) | Explicit **colloquial, bright, empathetic** voice; copy, imagery and relatable stories coordinated under a unifying theme; humor depends on context. | One cohesive learning metaphor, consistent UI/voice/motion; no jokes during uncertain diagnosis or invalid answers. |
| Galih, *What I Learned from Doraemon in UX Writing* (2018) | A firsthand author's product-writing ideas: **human, helpful, delightful**; writers collaborate through research/design/QA rather than just adding sentences. | Treat UX copy as interaction design; specify flow and remediation, not isolated taglines. |
| Interview with Edwin Mohammad, reported by Dwinawan (2018) | Former Gojek UX-writing lead describes concise, consistent language and editorial review, with collaborative design process. This is an interview, not a current official style policy. | Editorial owner, reviewer, and copy QA gates. |
| Asphalt Aloha — Gojek design principles | Consistency, usability, accessibility, aesthetics as design principles. Not a full content-style guide. | Keep action names, statuses, and visual microcopy consistent and accessible. |

### 1.2 Independent supporting references

- INA Digital Writing Foundation: empathy, clarity/brevity, evidence, inclusivity, Indonesian-language style. INA Digital **mentions** a Gojek UX Writer Playbook but is **not** that playbook and its examples are **not** automatically official Gojek text.
- Microsoft Writing Style: lead with action, be concise, error states explain problem and feasible next step without blaming users.
- WCAG 2.2: consistent identification (3.2.4), labels/instructions (3.3.2), status messages (4.1.3), language accessibility. Apply across mobile and web with platform-appropriate accessibility APIs.

**Research limitations:** no public full version of the internal Gojek UX Writer Playbook was verified; cited Gojek articles date mostly 2018–2021. They inform design patterns and historical practice, **not confirmation of the entire 2026 Gojek brand policy**. Statements marked *RETHINK PROPOSAL* below are our design choices, not quotes or official Gojek mandates.

## 2. Rethink's original content identity

### 2.1 Core promise and voice

**Identity sentence:** *Rethink bantu kamu melihat konsep yang sedang diuji, belajar dengan arah yang jelas, dan tahu apa yang sudah bisa kamu terapkan sendiri.*

**One-liner (public):** “Kalau matematika mulai bikin bingung, cek dulu bagian yang perlu dipahami.” This is a *proposed* invitation, **not** a guarantee the system identifies every cause.

**Our metaphor:** *mencari titik yang belum nyambung*, then *merangkai pemahaman pelan-pelan*. Do not describe a learner's mind as “rusak”, “bodoh”, “lemah”, or “gagal”. Resist the tempting metaphor of “memperbaiki otak” or a permanent label of competence.

**Brand voice pillars:**

1. **Ngobrol, bukan ceramah (conversational):** `kamu`, direct verbs, everyday Indonesian, not slang-heavy.
2. **Optimistis yang realistis (bright):** celebrate observable progress; don't promise guaranteed gains or fake success.
3. **Peka pada situasi (empathetic):** acknowledge friction without assigning blame; offer a relevant next step.
4. **Jelas dan bertanggung jawab (evidence-honest):** explicit scope and uncertainty when diagnosing or validating.

**Voice vs tone:** voice remains consistent across screens; **tone** shifts according to consequences and emotions.

### 2.2 Voice sliders: reference ranges (editorial heuristic, not research metrics)

| Situation | Conversational | Cheerful | Technical precision | Example approach |
|---|---|---|---|---|
| Welcome/onboarding | High | Medium-high | Low-medium | Curious, short, inviting, avoid feature promises |
| Catalog & Explore map | Medium | Medium | Medium | Name topic and availability clearly |
| Diagnosis instructions | Medium | Low | **High** | Calm, neutral, avoid answer hints |
| Confirmed result | Medium | Low | **Very high** | Qualify evidence and supported concept |
| Rejected/Uncertain | Medium | Low | **Very high** | Not a praise or failure screen |
| Guided Learning | High | Medium | **High** | Steps, conceptual explanation and active reasoning |
| Incorrect guided response | Medium | Low | **High** | Point to process, not student ability |
| Validation | Medium-low | Low | **Very high** | Scaffold-free, no premature hints |
| Achievement (after eligible success) | High | High | Medium-high | Celebrate bounded evidence, avoid SPL mastery claim |
| System error, lost connectivity | Medium | Low | High | Identify impact, recovery, reassurance only if true |
| Consent/security/privacy | Low-medium | Low | **Very high** | No jokes, simple terms, informed choice |

## 3. The six writing principles, in priority order

1. **Tepat:** never misstate outcome, coverage, access, promise or mathematical assertion. A misleading warm message is worse than an accurate plain one.
2. **Jelas:** convey *what happened / why relevant / what next* using concrete nouns.
3. **Ringkas:** remove filler, not necessary details. A qualified Uncertain result may be longer than a toast.
4. **Membantu:** every error or blocked step gives the next feasible action; when no fix exists, say so.
5. **Manusiawi:** speak with learner, not about “user”; adapt to frustration or uncertainty; avoid fake empathy.
6. **Berkarakter:** add gentle originality where appropriate, but only after passing 1–5.

**Recommended information hierarchy:** `headline` (one action/state) → `supporting explanation` (meaning/limit) → `primary CTA` (actual next action). On complex cases also add a noncompeting `secondary action`.

### 3.1 Pre-publish truth checks

- What reliable **system state** supports this claim?
- What *exactly* was assessed? What was **not** assessed?
- Is next step possible for this user/session now?
- Does this wording allow an interpretation stronger than the evidence?
- Is there an unapproved OI/OPS decision behind it?
- Would the message still make sense without animation or sound?

## 4. Indonesian language convention (RETHINK PROPOSAL)

| Aspect | Default rule | Exceptions / reasoning |
|---|---|---|
| Address | **kamu** for learner-facing text; avoid `Anda` switching midflow | Legal/formal disclosures may use neutral subject, not mix pronouns arbitrarily |
| App first person | Prefer direct imperative or `Rethink`; `kami` only when organizational responsibility is real | Do not anthropomorphize AI as confidant or human examiner |
| Negation | `nggak` for casual onboarding/emotional text; `belum`, `tidak`, `bukan` for assessment, error and high-stakes statements | `belum` must not mask confirmed failure or falsely imply eventual success |
| “Yuk” | Use sparingly for low-stakes invitation | Not in repeated CTAs, invalid evaluation, consent or critical errors |
| Slang | Light, broadly familiar expressions e.g. `nyangkut`, `pelan-pelan`, `coba lagi` | No `gue/lo`, performative youth slang, trends, inaccessible jokes |
| Tone | Informal but grammatical; readable to grade X–XII and caregivers | Math content uses precise terminology when needed |
| Punctuation | Sentence case headings/CTA; no gratuitous `!!!`, `???`, ellipses | Questions end `?`; one `!` in rare celebration; labels usually no period |
| Emoji | Not required; no emoji as only state signal; conservative usage | Critical result/status never relies on emoji |
| Capitalization | Use `Rethink`, `Sistem Persamaan Linear (SPL)`, `Distributive Property` (curriculum label as used in baseline) consistently | Do not vary naming into `Sifat Distribusi` without terminology mapping/review |
| Language mixing | Prefer Indonesian UI; retain official mathematical/domain label if appropriate | On first meaningful mention explain `Distributive Property (sifat distributif)` if approved by math review |
| Numbers | Numerals for progress (`Soal 2 dari 3`), time only from measured or configured source | No unsourced “4 menit”, “5 menit”, “99% akurat” |
| Button verbs | Verb + useful object (`Mulai pemeriksaan`, `Coba soal berikutnya`) | `Lanjut` permitted when context unmistakable |
| Error titles | Concrete current state (`Jawaban belum tersimpan`) | Avoid unhelpful `Oops!` alone |
| Inclusivity | No stigmatizing labels, stereotypes, guilt, comparative shaming | Don't make ability, age or emotional assumptions from one wrong answer |

### 4.1 Terminology/glossary — locked meanings

| Internal/domain term | Student-facing default | Definition that MUST remain intact |
|---|---|---|
| Diagnosis / asesmen diagnostik | **Cek pemahaman** (entry); **Hasil pemeriksaan** (result) | A targeted investigation; not a full proficiency test |
| Conceptual blocker | **Hambatan pada konsep yang diperiksa** / **bagian konsep yang perlu diperhatikan** | Do not state definitely *why* student struggles |
| Confirmed | **Ada indikasi kuat hambatan pada sifat distributif** (provisional copy) | Supported by sufficient mathematical evidence, not universal certainty; math/content review pending |
| Rejected | **Hambatan ini tidak didukung oleh bukti yang diperiksa** | Doesn't rule out other difficulties; **not** “Kamu pasti sudah paham” |
| Uncertain | **Hasilnya belum bisa disimpulkan** | Evidence insufficient/ambiguous/inconsistent |
| Optional Concept Review | **Ulas konsep (opsional)** | Not retroactive Confirmed diagnosis, validation eligibility still OI-02 |
| Visual Explanation | **Lihat konsepnya** | Visual conceptual explanation, not mere formula |
| Worked Example | **Ikuti contohnya** | Valid mathematical reasoning steps |
| Partial Guided Practice | **Coba dengan panduan** | Requires active mathematical response |
| Independent Retry | **Coba sendiri** | No instructional scaffolding |
| Transfer Problem | **Coba di bentuk soal lain** | Different representation/context, same concept; only after successful retry |
| Understood | **Berhasil menerapkan konsep pada soal yang diuji** | Blocker-level retry + transfer verified; not mastery of all SPL |
| Procedural Only | **Sudah bisa pada soal mandiri, masih perlu latihan pada bentuk lain** | Retry pass; transfer fail (where validly evaluated) |
| Needs Reinforcement | **Konsep ini masih perlu diperkuat** | Retry fail; transfer not administered |
| Learning Map | **Peta belajar** | Explore, focus and progress; cannot independently infer learner state |
| Concept Achievement | **Pencapaian konsep** | Recognition of eligible C5 result only, not generic completion badge |
| Learning progress | **Progres aktivitas** | Completed steps only; not mastery/proficiency score |

**Approval notes:** external/UI labels can be translated and improved through testing, but internal enum semantics and FR requirements remain unchanged. Copy for all-correct diagnosis depends on `OI-03`; post-Optional Review validation depends on `OI-02`.

## 5. Microcopy component rules

### 5.1 Headlines and body

- Headline SHOULD lead with current task/state, preferably 3–9 words (guidance only, not fixed hard limit).
- Body SHOULD communicate one main thought per paragraph, preferably 1–2 short sentences on mobile.
- Avoid expository “Rethink merupakan platform berbantuan AI…” on the first screen; this belongs in About/documentation, not greeting.
- Do not truncate critical diagnostic qualification to fit one line. Allow flexible text sizes and wrapping per `DESIGN.md`.

### 5.2 Buttons & labels

- Primary CTA MUST describe feasible outcome: `Lihat hasil`, `Mulai cek pemahaman`, `Pelajari konsep`, `Ulangi pembelajaran`.
- Secondary CTA describes distinct action, e.g. `Kembali ke topik`, `Nanti saja`, `Lihat penjelasan`.
- Avoid same action labeled `Gas!`, `Next`, `Lanjut`, `Mulai`, `Teruskan` arbitrarily across screens.
- Destructive actions need consequence, e.g. `Keluar dari pemeriksaan?` and verified persistence statement; never assert unsaved answers persist.
- Toggle text describes state & action accessibly: visual label `Audio panduan`, switch value `Aktif/Nonaktif`; accessible control name `Matikan audio panduan` / `Nyalakan audio panduan`.

### 5.3 Form and input prompts

- Specific label (`Nama panggilan`); optionality explicit if optional (`Nama panggilan (opsional)`). Placeholder MUST NOT be the only label.
- No collection of birthday, gender, school, grade, or phone by default without confirmed product need/data review.
- Don't request identity or personal circumstances to determine a mathematical blocker.
- Input validation specifies repair step: `Nama panggilan belum diisi. Isi dulu, ya.` *only if field is truly required*.

### 5.4 Progress labels

- `Soal 2 dari 3 soal inti` only if first 3 always administered; when Q4 needed, clearly introduce `Ada 1 pertanyaan tambahan`.
- `2 dari 3 tahap belajar selesai` is **activity completion**, not evidence of understanding.
- Distinguish `Belum diperiksa`, `Sedang diperiksa`, `Hasil tersedia`, `Belum ada hasil validasi`, not generic `0% paham`.

### 5.5 Notifications, modals and tooltips

- Toast: only terse status; must not carry unique critical information not on page.
- Modal: consequence and choice, not attention-grabbing title or fake urgency.
- Notification permission is a separate decision; do not write messaging that assumes it exists or will improve math grades.
- Tooltip: explain unfamiliar concept in context; include accessible labels; provide non-hover path on mobile.

## 6. Screen-by-screen conversational design (source-aligned)

### 6.1 C1 — Catalog & supported content

**Intent:** locate Algebra/SPL, understand availability, initiate an eligible diagnostic.  
**Possible title:** `Mau mulai dari mana?`  
**Supported topic subtitle:** `Sistem Persamaan Linear (SPL) · Cek pemahaman tersedia`  
**Unavailable topic:** `Materi ini belum bisa diperiksa di Rethink.`  
**CTA:** `Mulai cek pemahaman`  
**Don't:** `Kunci topik ini sampai kamu cukup pintar` or `Semua materi sudah tersedia`.

### 6.2 C2 — Hybrid Learning Map

**Explore:** `Lihat hubungan topik dan konsepnya.` No personalized weak/strong labels before assessment.  
**Focus Confirmed:** `Hasil pemeriksaan mengarah ke sifat distributif.` Explain scope of what was tested.  
**Focus Rejected/Uncertain:** `Konsep ini sudah diperiksa, tetapi belum ada hambatan yang terkonfirmasi.` Where status is Rejected, do not conflate with Uncertain; prefer explicit result detail rather than this generic fallback.  
**Progress:** only show actual C5 learner state, never based on concept map relationship or passive viewing.

### 6.3 C3 — Diagnostic instructions and questions

**Entry:** `Kita cek beberapa cara kamu memakai matematika.`  
**Body:** `Jawab sesuai yang kamu pikirkan. Boleh tulis caranya kalau diminta—itu membantu pemeriksaan jadi lebih jelas.`  
**Progress:** `Soal 1 dari 3` then optional Q4.  
**Submit acknowledgement:** `Jawaban tersimpan. Lanjut ke soal berikutnya.` only after successful persistence.  
**Avoid:** `Benar! Kamu hebat` or hints revealing correct transformations while collecting evidence.  
**Extra probe:** `Ada satu pertanyaan tambahan supaya hasilnya lebih jelas.` This does not promise certainty.

**Confirmed (template):** `Dari jawaban yang kamu berikan, ada bukti yang mendukung hambatan pada sifat distributif. Kita bisa mulai dari konsep itu.` Add tested-scope qualifier and action. Do not claim “pasti sumber semua masalahmu”.  
**Rejected (template):** `Jawabanmu belum menunjukkan hambatan pada sifat distributif yang diperiksa. Ini bukan berarti semua materi SPL sudah kamu kuasai.` Requires case-specific review, not auto-set from correctness count.  
**Uncertain (template):** `Belum bisa dipastikan. Ada jawaban yang belum cukup jelas atau belum sejalan, jadi Rethink belum bisa menyimpulkan hambatan konsep ini.` Does not imply student failed.  
**All correct:** **DO NOT SHIP final outcome copy until OI-03 is approved.**

### 6.4 C4 — Guided Learning

**Visual:** `Kenapa angka di luar kurung dikali ke semuanya?`  
**Worked example:** `Lihat bagaimana tiap langkah saling nyambung.`  
**Practice:** `Sekarang giliran kamu melengkapi langkahnya.`  
**Correct feedback candidate:** `Pas. Angka 3 dikali ke x dan ke 2, jadi hasilnya 3x + 6.`  
**Incorrect feedback candidate:** `Cek bagian +2. Apakah angka 3 sudah dikalikan ke suku itu juga?`  
**Completion candidate:** `Tiga tahap belajar selesai. Berikutnya, cek apa yang sudah bisa kamu kerjakan sendiri.` Only on approved confirmed recovery and OPS-02 completion rules.  
**Important:** feedback and retry mechanics OPS-01; content/rubric OPS-04. Copy cannot choose an evaluation result or define what qualifies as completion.

### 6.5 C5 — Independent Retry, Transfer, outcomes

**Retry intro:** `Sekarang coba sendiri, tanpa petunjuk.`  
**Transfer intro:** `Bagus, kamu berhasil di soal tadi. Sekarang coba konsep yang sama dalam bentuk berbeda.` Show only after successful retry.  
**Understood:** `Kamu berhasil menerapkan sifat distributif sendiri, termasuk pada bentuk soal yang berbeda.` Must cite bounded test context; not all SPL mastery.  
**Procedural Only:** `Kamu berhasil di soal mandiri, tapi belum berhasil di soal dengan bentuk berbeda. Kita belum bisa menyimpulkan pemahamanmu untuk semua bentuk soal.`  
**Needs Reinforcement:** `Masih ada bagian yang perlu diperkuat. Kamu bisa mengulang penjelasan dan latihan yang tadi.` Transfer remains *not administered*, never `transfer gagal`.  
**Uninterpretable input:** `Jawaban ini belum bisa diperiksa.` Provide supported next step only if OPS-03 defines it. Avoid deciding `Needs Reinforcement` automatically.

### 6.6 Gamification presentation

- **Progress:** `2 dari 3 langkah belajar selesai` ≠ `2 dari 3 konsep dikuasai`.
- **Positive feedback:** specific math evidence, not just enthusiastic praise.
- **Achievement:** issue only on valid eligible `Understood` outcome after retry + transfer, per proposed gamification specification; do not award on lesson completion, Rejected/Uncertain, or preview.
- **Achievement copy:** `Pencapaian konsep terbuka: Sifat distributif. Kamu berhasil pada soal mandiri dan soal bentuk berbeda yang diuji.`
- **Preview** (onboarding) needs label `Contoh tampilan`, never a real user result.

## 7. Onboarding, audio and conversational pacing

### 7.1 Narrative arc

1. **Hook:** show a relatable study friction without assuming all errors are conceptual blockers.
2. **Offer:** show evidence-supported checking, not magical certainty.
3. **Demonstrate:** show visual explanation and active practice.
4. **Verify:** show independent retry and a different representation.
5. **Invite:** supported SPL entry, no generic all-topics promise.

**Current implementation note (19 Oct 2026):** the shipped onboarding is **five activity-gated steps** — name, core-loop taps, sample MCQ, chatbot preview, ready. Audio is per slide, default on when available, with a top-right mute control. There is no audio-preference slide, no slide picker, and no skip. The illustrative table below is a broader copy exploration, not the current screen list.

**Illustrative slide sequence and headline ideas (not adopted PRD):**

| Scene | Title | Body | CTA | Voice tone |
|---|---|---|---|---|
| Welcome | `Pernah nyangkut di tengah soal?` | `Kadang kita tahu rumusnya, tapi belum paham kapan dipakai.` | `Lanjut` | Warm, curious |
| Value | `Cari tahu bagian yang perlu dicek` | `Jawabanmu membantu Rethink melihat konsep yang mungkin bikin prosesnya tersendat.` | `Lihat caranya` | Matter-of-fact |
| Loop | `Cek. Pelajari. Coba sendiri.` | `Tiga langkah yang nyambung, supaya kamu tahu apa yang sedang dikerjakan.` | `Lanjut` | Upbeat |
| Visual | `Biar konsepnya lebih kebayang` | `Lihat penjelasan visual, lalu ikuti contoh dan latihan singkat.` | `Coba lihat` | Inviting |
| Result | `Yang penting, ada buktinya` | `Status pemahaman datang dari soal mandiri, bukan dari banyaknya layar yang dibuka.` | `Lanjut` | Measured |
| Audio | `Mau ditemani suara?` | `Audio bisa kamu nyalakan atau matikan kapan saja.` | `Nyalakan audio` / `Tanpa audio` | Gentle |
| Entry | `Siap cek pemahamanmu?` | `Kita mulai dari Sistem Persamaan Linear dan sifat distributif.` | `Mulai cek pemahaman` | Confident |

**No mandatory duration claim** unless actual measurement supports it. No fake personal diagnostic or achievement in onboarding. If authentication is introduced, separately approve flow, copy and data collection; source PRD does not settle it.

### 7.2 Audio-specific writing

- Audio text SHOULD sound natural when spoken; avoid speaking parentheses, IDs, equations as ambiguous linear prose; review mathematical pronunciation with educator.
- Keep spoken text and visible message semantically equivalent; provide captions/transcript for meaningful audio content.
- When audio toggle OFF: immediately stop playback; avoid audio overlap on navigation. User choice is reversible and respected.
- Current onboarding defaults audio **ON when an asset is available**, with a visible mute control and no separate audio-preference screen. This default remains a proposed product decision pending review; if changed to OFF, update the preference default and tests together. Do not falsely label this as a Gojek rule.
- Prefer 1 clear sentence for each preview; reading speed/duration are production estimates to test with real voice recordings.
- `Audio panduan aktif` / `Audio panduan nonaktif` describe state, not moral success or failure.
- Confirm whether sound effects are separately controllable and whether OS silent/reduced-motion preferences must be honored.

## 8. Error, system status and recovery matrix

**Required structure:** `Apa yang terjadi` + `dampaknya (jika penting)` + `langkah yang benar-benar tersedia`. Be empathetic, not apologetic without a plan. If state is unknown, explicitly avoid unsupported save claims.

| State | Suggested title | Detail / available action | Avoid |
|---|---|---|---|
| Network disconnected, save not confirmed | `Koneksi terputus` | `Jawabanmu belum dipastikan tersimpan. Coba sambungkan internet lalu kirim lagi.` | `Semua sudah aman` |
| Network timed out, persistence unknown | `Belum dapat memastikan jawaban tersimpan` | `Periksa statusnya dulu sebelum mengirim ulang.` (only if actual status check exists) | `Jawaban gagal` without evidence |
| Submission succeeded | `Jawaban tersimpan` | `Lanjut ke soal berikutnya.` | `Jawaban benar` |
| Evaluation service unavailable | `Hasilnya belum tersedia` | `Pemeriksaan belum bisa dilanjutkan sekarang. Coba lagi nanti.` | `Kamu belum paham` |
| Ambiguous mathematical response | `Jawaban belum bisa diperiksa` | Only supported correction/retry path after OPS-03 | `Jawaban salah` |
| Unsupported topic | `Belum tersedia untuk topik ini` | `Saat ini, cek pemahaman tersedia untuk SPL.` | `Kamu belum membuka level ini` |
| Duplicate tap / pending send | `Sedang mengirim jawaban` | Show spinner/status; prevent double submission | Two conflicting success toasts |
| Session expired | `Sesi ini sudah berakhir` | Explain resume/restart only if actually supported | `Tenang, semua jawaban aman` without persistence guarantee |
| Audio asset unavailable | `Audio belum bisa diputar` | `Kamu tetap bisa baca dan lanjut tanpa suara.` | Block onboarding |
| Achievement write failure | `Pencapaian belum bisa ditampilkan` | Retry fetch only if evidence remains valid; never mint badge optimistically | `Pencapaian berhasil` before authoritative commit |

### 8.1 Sensitive contexts where humor is prohibited

- Diagnosis status or mathematical misunderstanding; unclear evidence.
- Failed validation; learner distress; accessibility or cognitive burden.
- Lost responses, security/privacy, legal consent, account issues affecting user data.
- Generalization of a single response into student ability or intelligence.

## 9. Tone calibration — before / after

| Too robotic / misleading | Rethink version | Why |
|---|---|---|
| `Silakan melakukan inisiasi asesmen diagnostik.` | `Mulai cek pemahaman` | Clear action |
| `AI kami akan menemukan akar masalahmu.` | `Jawabanmu membantu kami memeriksa konsep yang mungkin berkaitan.` | No guaranteed causal inference |
| `Jawaban Anda salah.` | `Coba periksa langkah saat membuka kurung.` | Process-directed, only in guided practice |
| `Kamu genius!` | `Pas, kedua suku sudah dikalikan dengan benar.` | Evidence-specific |
| `Kamu tidak menguasai SPL.` | `Hasil ini hanya membahas sifat distributif yang diperiksa.` | Scoped claim |
| `Selamat, kamu telah menyelesaikan pembelajaran dan menguasai konsep!` | `Tahap belajar selesai. Berikutnya, coba kerjakan sendiri.` | Separates completion and validation |
| `Oops! Terjadi error.` | `Hasilnya belum bisa ditampilkan. Coba lagi nanti.` | Real status plus action |
| `Kamu kalah, jangan menyerah!` | `Soal ini belum berhasil. Kamu bisa mengulang materi yang sama.` | No competitive framing |
| `Tes gagal!` | `Bukti yang ada belum cukup untuk disimpulkan.` | Uncertainty is valid |
| `Buka semua topik di Rethink!` | `Saat ini, cek pemahaman tersedia untuk SPL.` | Coverage truth |
| `Selamat datang dalam ekosistem AI edukasi terintegrasi.` | `Mau tahu kenapa satu soal terasa susah? Kita cek pelan-pelan.` | Human voice |
| `Daftar agar bisa menyimpan semua data selamanya.` | `Buat akun` plus an accurately scoped benefit if implemented | Avoid unsupported retention promise |

## 10. Editorial process and governance

1. **Context brief** from Product/UX: screen, user state, trigger, user intent, action available, evidence status, FR IDs, unresolved decisions.
2. **Draft** from this guide and canonical copy bank; avoid new synonyms for locked domain states.
3. **Truth review** by Product and math/pedagogy reviewer (C3–C5); design review for readability and visual fit.
4. **Localized comprehension review** with student participants when feasible; ask learner to paraphrase diagnoses/results without prompting.
5. **Implementation** from stable ID + variables, not scattered string literals; namespaced by flow.
6. **QA** for device text expansion, line wraps, accessibility labels, errors, all edge cases and audio/mute.
7. **Change control** records changed copy ID, old/new version, reason, reviewer, impacted tests and source status.

**Copy approval states:** `DRAFT`, `REVIEW_NEEDED`, `APPROVED_FOR_DESIGN`, `APPROVED_FOR_RELEASE`, `BLOCKED_BY_DECISION`, `DEPRECATED`. These are **new editorial workflow proposals**, not statuses prescribed by the 133-page PRD.

### 10.1 Recommended localization object (nonbinding technical illustration)

```json
{
  "id": "diagnosis.result.uncertain.title",
  "locale": "id-ID",
  "text": "Hasilnya belum bisa disimpulkan",
  "purpose": "Show insufficient/ambiguous diagnostic evidence",
  "fr_ids": ["FR-C3-07", "FR-C3-09"],
  "status": "REVIEW_NEEDED",
  "owner": "product-design",
  "source_state": "uncertain",
  "approved_at": null
}
```

Store dynamic math expressions with safe math rendering; avoid untrusted formatted LLM HTML. Variables from trusted app state only (`{topic_name}`, `{current_question}`, `{total_questions}`, `{concept_name}`), escape displayed user input and localize number formats. Never use runtime generation to choose or soften a diagnosis state.

### 10.2 Context brief template

```md
Copy request ID:
Screen / component:
User goal:
What state just happened (system evidence):
Exact FR IDs:
Supported next actions:
OI/OPS dependency:
Length/layout restrictions:
Accessibility / audio:
Draft A / B:
Truth-review note:
Reviewer / approval / date:
```

## 11. Copy quality evaluation and success metrics (proposed)

Use small structured comprehension tasks; ask: “Apa yang baru saja terjadi?”, “Bagian konsep apa yang diperiksa?”, “Apa yang **belum** bisa disimpulkan?”, “Apa yang bisa kamu lakukan selanjutnya?” Report incorrect interpretation of **Confirmed / Rejected / Uncertain** separately from task completion. For validation ask whether `Understood` is being misread as complete SPL mastery. Don't claim learning outcome improvement from pleasant wording.

**Measures:** first-try comprehension, misinterpretation rate, effective CTA choice, error recovery, completion without assistance, perceived clarity, narration-off comprehension, and consistency issue count. Numeric thresholds require separate justification and approval; do not invent efficacy targets.

## 12. Decision-linked cautions

| ID | Writing blocked or conditioned by |
|---|---|
| OI-01 | Who is authorized to issue final C3 diagnosis; explainability/interpretation constraints |
| OI-02 | Optional Review → validation eligibility; achievement/state copy must not imply this path exists |
| OI-03 | All-correct pattern exact diagnosis/result/continuation copy |
| OPS-01 | Guided Practice wrong/correct feedback timing and retry behavior |
| OPS-02 | Exact completion copy / thresholds for Guided Learning |
| OPS-03 | Ambiguous/blank/equivalent validation response messages and allowed resubmission |
| OPS-04 | Question statements, accepted math answers, hints, worked examples |
| OPS-05 | Persistence, resume, interrupted-session and cross-flow handoff copy |

**Review rule:** a nice phrase cannot close these decisions. Escalate to Product + math/engineering for approval and update `docs/decisions.md` only after explicit sign-off.

## 13. Codex implementation contract

- Before UI work, read `docs/INDEX.md`, this file and relevant PRD requirement IDs; inspect `DESIGN.md` for typography/layout contrast and gamification spec for event-to-copy conditions.
- Use [`ux-writing-copy-bank.md`](ux-writing-copy-bank.md) as draft catalog with stable IDs; obey each entry's `status` and never treat `BLOCKED` as release ready.
- Prefer central `id-ID` resource file / typed constants with approved text values; avoid copying content into arbitrary components.
- User-facing messages are **data-bound**: only show `saved` after persistence acknowledgment, `Confirmed` after approved C3 decision, `Understood` after valid C5 mapping.
- Do not label an error as a conceptual weakness. Distinguish unassessed/not available vs assessed/rejected/uncertain.
- Add tests for conditional Q4, non-confirmed branching, retry failure (no Transfer), ambiguous evaluation, optional review, no real achievement in onboarding, audio off, missing network, and duplicate actions.
- In PR descriptions, list exact copy IDs, FR IDs, source status, decision blockers, reviewed alternatives, and test evidence.
- When user asks “make it feel more Gojek”, implement **the principles** (human, clear, useful, context-aware) while retaining **Rethink’s own name, examples, voice and original wording**.

## 14. Research references, provenance and reading order

**Primary / firsthand:**

1. [Gojek UX Writers — Language No Bar: How We Localise UX Copies at Gojek (2021)](https://medium.com/gojekengineering/language-no-bar-how-we-localise-ux-copies-at-gojek-c16d5fefa16e) — contextual localization; Clear / Concise / Helpful; audience-dependent tone; proofreading.
2. [Galih — Design with Love (2018)](https://medium.com/life-at-go-jek/design-with-love-the-creative-process-behind-go-jek-redesign-d0e2338e7f7a) — Colloquial / Bright / Empathetic; big theme and storytelling.
3. [Galih — What I Learned from Doraemon in UX Writing (2018)](https://medium.com/life-at-go-jek/what-i-learned-from-doraemon-in-ux-writing-338b2acf15b4) — Human / Helpful / Delightful; copy is part of design workflow.
4. [Gojek — Asphalt Aloha Design Principles](https://asphalt.gojek.io/pages/principles.html) — consistency, usability, accessibility, aesthetics; design principles, **not** full writing playbook.

**Interviews, independent frameworks, and relevant standards:**

5. [Dwinawan — Interview with Edwin Mohammad, former Lead UX Writer at Gojek (2018)](https://medium.com/insightdesign/ngobrol-tentang-ux-writer-bareng-edwin-mohammad-lead-ux-writer-di-go-jek-c8f85dc78809) — firsthand perspective reported by interviewer; editorial gatekeeping.
6. [INA Digital — Panduan Penulisan](https://design.inadigital.go.id/foundation/writing/) — Indonesian inclusive writing. References an internal Gojek playbook but is not the playbook itself.
7. [Microsoft — Writing style](https://learn.microsoft.com/en-us/windows/apps/design/style/writing-style) — user-friendly, actionable interface and error copy.
8. [W3C — WCAG 2.2: Consistent Identification](https://www.w3.org/WAI/WCAG22/Understanding/consistent-identification.html) — name functional controls consistently.
9. [W3C — WCAG 2.2: Labels or Instructions](https://www.w3.org/WAI/WCAG22/Understanding/labels-or-instructions) — visible input guidance.

**Sources and interpretation disclaimer:** external source descriptions above are paraphrases; all Rethink rules, scripts, strings and numerical word-length targets are newly authored recommendations subject to review. Nothing in this document claims a Gojek endorsement, affiliation, or verified internal 2026 playbook access.

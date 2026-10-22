# Source Transcript — Core Processing Workflows

> **Verbatim-style text extraction** from uploaded PDF pages **109–117**. This is a machine-extracted archival copy, not newly approved specification. PDF tables/line wraps may lose visual structure. Verify against `ReThink-Documentation-original.pdf` when an exact table, figure or label matters.

## Original PDF Page 109

```text
Core Processing Workflows

Section  ini menjelaskan mekanisme pemrosesan utama ReThink berdasarkan kebutuhan produk
yang telah disetujui. Alur dinyatakan dalam bentuk tahapan, aturan keputusan, dan ketergantungan
terbuka agar dapat digunakan sebagai dasar engineering design tanpa menentukan API, struktur
database, atau detail algoritme.

3.1 Diagnostic Assessment & Outcomes

Tujuan: Memperoleh dan mengevaluasi bukti respons matematika untuk menentukan hasil diagnosis
Distributive Property dalam konteks SPL.

A. Workflow Stages

 Stage               Responsible   Processing Responsibility          Expected
                 Component                                  Output

 D1 — Assessment  LC-01, LC-02   Memastikan  SPL merupakan  topik  Konteks
 Initialization                      yang didukung dan memuat blueprint  asesmen   yang
                                       diagnosis yang relevan.                    valid.

 D2   —    Core  LC-02         Menyajikan Q1 Target Performance,  Respons       inti
 Question                    Q2 Prerequisite Application, dan Q3  beserta konteks
 Administration                     Conceptual Reasoning.                 setiap soal.

 D3 — Mathematical  LC-03         Mengevaluasi  respons  berdasarkan  Observasi
 Evidence                                   kriteria matematika dan kategori bukti  matematika
 Evaluation                        yang berlaku.                           tingkat soal.


 D4        —  LC-04        Mempertimbangkan            bukti  Sintesis evidence
 Cross-Question                   pendukung, bukti yang bertentangan,  terhadap
 Evidence Synthesis               dan informasi yang belum cukup.      supported
                                                                                   blocker.

 D5 —  Conditional  LC-02, LC-04   Jika  diperlukan,  menyajikan  paling  Additional
 Diagnostic Probe                  banyak satu Q4 berupa Procedural  diagnostic
                                     Trace   atau   Conceptual   Probe,  evidence.
                                  kemudian    mengevaluasi     bukti
                                   tambahan.

 D6 —  Diagnostic  LC-04,         Menghasilkan  hasil  diagnosis yang  Confirmed,
 Outcome            subject     to  sah  berdasarkan  bukti dan aturan  Rejected,   atau
 Finalization          OI-01         yang berlaku.                          Uncertain.
```

## Original PDF Page 110

```text
D7  —    Result  LC-07, LC-08   Menyampaikan       hasil,     batas  Diagnostic result
 Communication  &                    interpretasinya, dan opsi kelanjutan  dan continuation
 Handoff                          yang diperbolehkan.                    context.

[DIAG-03 — Diagnostic Evidence & Conditional Probe Flow]

Placeholder untuk visualisasi alur Q1–Q3, evaluasi bukti, sintesis, kemungkinan Q4, finalisasi hasil, dan
kelanjutan diagnosis.

B. PRD-Derived Decision Rules

 Rule                     Required Behavior

 D-R01  —   Supported  Diagnosis  hanya  memeriksa  Distributive  Property  sebagai
 Scope                    supported conceptual blocker untuk konteks SPL.

 D-R02  —    Evidence  Satu  kesalahan  atau  satu  pola  respons  tidak  otomatis
 Requirement              mengonfirmasi blocker.

 D-R03 — Cross-Question  Keputusan  mempertimbangkan   bukti  yang  mendukung,
 Evaluation                 bertentangan, atau belum memadai.

 D-R04 —   Conditional  Maksimal satu Q4 diberikan untuk mengklarifikasi kebutuhan
 Probe Limit                  bukti yang relevan.

 D-R05 — Valid Outcomes   Hasil dibatasi menjadi Confirmed, Rejected, atau Uncertain.

 D-R06 —  Conservative  Bukti ambigu, tidak memadai, atau tidak konsisten tidak boleh
 Interpretation             dipaksakan menjadi Confirmed.

 D-R07 —  Bounded  AI  AI tidak dapat menetapkan blocker baru di luar supported
 Interpretation              diagnostic knowledge.

 D-R08   —     Limited  Hasil   diagnosis   tidak  membuktikan  penguasaan   atau
 Diagnostic Claims         ketidakmampuan siswa pada seluruh SPL.


C. Open Dependencies

 Reference    Dependency          Implementation Consequence

 OI-01   —  AI      Methodology  Final   decision   authority,  pembagian   evaluasi
 Open         Alignment             matematika dan  interpretasi  AI,  serta safeguards
                                  memerlukan keputusan lanjutan.

 OI-03   —  All-Correct Diagnostic  Outcome  ketika  seluruh respons  diagnosis benar
 Open       Outcome Mapping     belum boleh ditentukan oleh implementasi.
```

## Original PDF Page 111

```text
OPS-04  —  Curated Mathematical  Butir Q1–Q4, solusi acuan, dan kriteria evaluasi harus
 Pending       Items & Rubrics          disiapkan serta ditinjau.

Komponen assessment, data capture, dan basic mathematical evaluation dapat dirancang tanpa
menganggap dependent diagnostic behavior telah final.

3.2 Guided Learning & Optional Concept Review

Tujuan: Menyajikan intervensi terkurasi untuk Distributive Property melalui urutan pembelajaran
linear yang mempertahankan partisipasi matematika aktif.

A. Workflow Stages

 Stage             Responsible     Processing Responsibility        Expected Output
                Component

 L1 —   Learning  LC-07            Mengidentifikasi         apakah  Learning   context
 Entry Context                      pembelajaran     dimulai     dari  yang       dapat
                                  Confirmed Recovery atau Optional  dibedakan.
                                 Concept Review.

 L2  —   Curated  LC-05         Memuat   paket   pembelajaran  Instructional
 Package Retrieval                      Distributive    Property    yang  package.
                                      didukung.

 L3  —    Visual  LC-05           Menyajikan   representasi   yang  Aktivitas
 Explanation                         menjelaskan makna konsep.         penjelasan
                                                                           konseptual.

 L4  —  Worked  LC-05          Menampilkan   contoh   dengan  Aktivitas
 Example                              transformasi     dan      alasan  demonstrasi
                                   matematika yang relevan.          prosedur     dan
                                                                           reasoning.

 L5  —    Partial  LC-05,  LC-03  Meminta    siswa    melengkapi  Practice  response
 Guided Practice      bila diperlukan   langkah  atau  reasoning  dalam  evidence.
                                            solusi yang dibimbing sebagian.

 L6 —  Learning  LC-05          Menentukan          completion  Completion state.
 Completion                        berdasarkan  kriteria  operasional
 Evaluation                        yang berlaku.

 L7 —   Learning  LC-07          Mengarahkan  pengguna  sesuai  Permitted     next
 Continuation                        konteks masuk, completion, dan  transition.
                                                       eligibility.
```

## Original PDF Page 112

```text
B. PRD-Derived Decision Rules

 Rule                  Required Behavior

 L-R01 —  Supported MVP menyediakan satu curated Guided Learning package untuk
 Package                   Distributive Property.

 L-R02   —    Fixed  Urutan pembelajaran adalah Visual Explanation → Worked Example
 Sequence       → Partial Guided Practice.

 L-R03  —    Active   Partial Guided  Practice memerlukan respons  aktif dari siswa;
 Participation            melihat konten saja tidak memenuhi kebutuhan tersebut.

 L-R04 — No Adaptive  Sistem tidak memilih scaffold atau learning pathway baru secara
 Orchestration           dinamis.

 L-R05 — Entry Context  Optional Concept Review tidak mengubah hasil Rejected atau
 Integrity                Uncertain menjadi Confirmed.

 L-R06 — Completion  Menyelesaikan   pembelajaran   tidak   otomatis  menunjukkan
 Boundary            pemahaman yang tervalidasi.

 L-R07 —  Conditional  Confirmed Recovery yang memenuhi completion dapat berlanjut
 Continuation           ke Knowledge Validation; eligibility setelah Optional Review belum
                          diputuskan.

[DIAG-04 — Guided Learning & Knowledge Validation Transition Flow]

Placeholder untuk visualisasi dua konteks masuk, urutan pembelajaran linear, completion, dan transisi
validasi sesuai eligibility.

C. Open Dependencies

 Reference     Dependency              Implementation Consequence

 OI-02 — Open  Optional          Review  Kelayakan validasi dan dampak learner state
                 Learner-State Behavior       setelah ulasan opsional belum final.

 OPS-01  —  Guided Practice Feedback  Mekanisme   respons,  umpan   balik,  dan
 Pending       Mechanics                penanganan kesalahan perlu ditetapkan.

 OPS-02  —  Guided           Learning  Completion  tidak  boleh  ditentukan  hanya
 Pending        Completion Criteria         berdasarkan asumsi implementasi.

 OPS-04  —  Curated     Mathematical  Materi dan  latihan harus  diperiksa  validitas
 Pending        Items & Rubrics             matematikanya.
```

## Original PDF Page 113

```text
OPS-05  —  Cross-Capability Transition  Handoff    pembelajaran    dan      eligibility
 Pending      & State Design            membutuhkan spesifikasi operasional.


3.3 Knowledge Validation & Learner States

Tujuan: Memvalidasi kemampuan siswa menggunakan Distributive Property secara mandiri serta
membedakan keberhasilan prosedural dari penerapan pada representasi berbeda.

A. Workflow Stages

 Stage                Responsible    Processing Responsibility   Expected Output
                   Component

 V1  —    Validation  LC-07         Memastikan konteks belajar   Eligible       validation
 Eligibility Check                    dan  completion memenuhi  context.
                                       ketentuan validasi.

 V2 —  Independent  LC-06          Menyajikan   soal  dengan  Independent
 Retry Administration                     struktur konsep yang relevan  response.
                                      tanpa scaffolding.

 V3   —     Retry  LC-03          Mengevaluasi      respons  Item-level        retry
 Evaluation                        menggunakan         kriteria  outcome.
                                     matematika yang berlaku.

 V4 —   Conditional  LC-06         Memberikan        Transfer  Transfer response.
 Transfer                            Problem     hanya       jika
 Administration                       Independent Retry berhasil.

 V5  —    Transfer  LC-03          Mengevaluasi    penerapan  Item-level     transfer
 Evaluation                          konsep pada bentuk  atau  outcome.
                                       konteks   yang   berbeda
                                       secara bermakna.

 V6 —  Learner-State  LC-06         Menetapkan   hasil   belajar  Understood,
 Determination                        berdasarkan      kombinasi  Procedural Only, atau
                                                validasi yang sah.           Needs Reinforcement.

 V7  —   Outcome  LC-07, LC-08   Menyampaikan   hasil  dan  Learning outcome dan
 Communication   &                memperbarui   representasi  next-step context.
 Continuation                          progress jika berlaku.


B. PRD-Derived Decision Rules
```

## Original PDF Page 114

```text
Independent       Transfer Problem  Learner State
 Retry

 Gagal               Tidak diberikan    Needs
                                    Reinforcement

 Berhasil            Gagal             Procedural Only

 Berhasil              Berhasil          Understood

Aturan tambahan:

 Rule                   Required Behavior

 V-R01  —   Validation  Knowledge  Validation  dijalankan pada  jalur yang memenuhi
 Eligibility                 prasyarat pembelajaran dan konteks yang disetujui.

 V-R02 — Unscaffolded  Independent   Retry   tidak   menyertakan   bantuan   yang
 Retry                  menggantikan penyelesaian mandiri.

 V-R03 —  Meaningful  Transfer Problem menggunakan  struktur konsep yang sama
 Transfer               dengan  representasi  atau  konteks  yang  berbeda  secara
                        bermakna.

 V-R04 —  Conditional  Transfer Problem tidak diberikan ketika Independent Retry gagal.
 Transfer

 V-R05 —  Approved  Learner state mengikuti matriks tiga kondisi yang disetujui.
 State Mapping

 V-R06 — Reinforcement  Needs Reinforcement mengarahkan siswa kembali ke Guided
 Routing                  Learning package yang sama.

 V-R07   —     No  Kegagalan   validasi   tidak  memulai   diagnosis  baru  atau
 Re-Diagnosis            mengonfirmasi blocker tambahan.

 V-R08  —    Limited  Understood hanya berlaku pada  Distributive Property dalam
 Learning Claims         cakupan validasi yang digunakan, bukan mastery seluruh SPL.

Matriks tiga kondisi berlaku jika setiap respons telah memiliki hasil evaluasi item yang sah. Respons
yang kosong, tidak dapat diinterpretasikan, atau memiliki bentuk matematika ekuivalen memerlukan
penanganan sesuai OPS-03.

C. Open Dependencies

 Reference    Dependency            Implementation Consequence
```

## Original PDF Page 115

```text
OI-02   —  Optional         Review  Jalur validasi setelah Optional Review tidak dapat
 Open          Learner-State Behavior      difinalisasi.

 OPS-02  —  Guided         Learning  Validation   eligibility  bergantung  pada  kriteria
 Pending       Completion Criteria       completion yang berlaku.

 OPS-03  —  Validation     Response  Penanganan respons tidak lengkap, tidak terbaca,
 Pending       Handling                  atau ekuivalen perlu dispesifikasikan.

 OPS-04  —  Curated    Mathematical  Independent   Retry  dan   Transfer  Problem
 Pending       Items & Rubrics          memerlukan item serta referensi matematika yang
                                                      valid.

 OPS-05  —  Cross-Capability            Transisi menuju validasi dan sesudah hasil perlu
 Pending         Transition & State Design    konsisten.


3.4 Cross-Capability Transitions

Tujuan: Mempertahankan  konteks  pembelajaran dan mengoordinasikan perpindahan C1–C5
berdasarkan keputusan yang telah dihasilkan oleh komponen yang berwenang.

A. Transition Workflow

 Transition              Trigger                     Eligibility      /    Required  Owner
                                            Context

 T1 — Learning Entry →  Siswa memilih memulai  Diagnostic capability tersedia  LC-01,
 Diagnosis               diagnosis SPL.           untuk topik yang dipilih.        LC-02,
                                                                     LC-07

 T2 —  Diagnosis →  Diagnostic    outcome  Supported blocker dan result  LC-04,
 Confirmed Recovery    Confirmed.              context sah.                LC-07

 T3 —  Diagnosis →  Rejected atau Uncertain  Tidak    ada    perubahan  LC-07,
 Optional Review       dan   siswa   memilih  retroaktif menjadi Confirmed.  LC-05
                           review.

 T4  —   Confirmed  Guided        Learning  Completion  dan   validation  LC-05,
 Recovery     →   selesai.                        eligibility terpenuhi.            LC-07,
 Validation                                                           LC-06

 T5 — Optional Review  Optional Review selesai.   Eligibility   masih   OI-02  LC-07,
→ Validation                              Open.                    LC-06
```

## Original PDF Page 116

```text
T6 —  Validation →  Independent      Retry  Needs        Reinforcement  LC-06,
 Reinforcement           gagal.                  berdasarkan   evaluasi  yang  LC-07,
                                                      sah.                      LC-05

 T7 —  Outcome →  Diagnostic    outcome  Informasi   dan   evidence  LC-07,
 Learning Map           atau    learner    state  berasal dari komponen yang  LC-08
                             tersedia.               berwenang.

[DIAG-02 — End-to-End Processing & Outcome Branches]

Placeholder untuk visualisasi alur lintas C1–C5, percabangan hasil diagnosis, konteks Optional
Review, validasi kondisional, serta pembaruan Learning Map.

B. Cross-Capability Integrity Rules

 Rule                     Required Behavior

 T-R01   —     Context  Selected topic, supported blocker, diagnostic outcome, dan
 Continuity                   learning entry context tidak boleh tertukar selama transisi.

 T-R02   —     Decision  Transition  Coordinator  tidak  menetapkan  hasil  evaluasi
 Ownership                 matematika, diagnosis, maupun learner state baru.

 T-R03  —    Evidence  Hasil  yang  digunakan  untuk  perpindahan  harus  dapat
 Traceability               dihubungkan dengan konteks dan sumber evidence yang
                                relevan.

 T-R04 — No Implicit State  Confirmed  dan Guided  Learning Completed  tidak  boleh
 Promotion                  diperlakukan sebagai Understood.

 T-R05  —   Supported  Transisi tidak dapat mengaktifkan diagnostic, learning, atau
 Capability Boundary         validation capability yang belum didukung.

 T-R06         —  Transisi yang memerlukan keputusan terbuka  tidak boleh
 Dependency-Aware        dianggap memiliki aturan final.
 Routing


C. Open Dependencies

 Reference            Affected Transition

 OI-01 — Open          T2,  karena  penetapan  diagnostic  outcome  bergantung  pada
                    pembagian otoritas diagnosis yang belum final.

 OI-02 — Open       T5 dan eligibility validasi setelah Optional Review.
```

## Original PDF Page 117

```text
OI-03 — Open         Kelanjutan diagnosis pada pola seluruh jawaban benar.

 OPS-01–OPS-02 —  Penyelesaian Guided Practice dan completion sebelum handoff.
 Pending

 OPS-03–OPS-04 —  Evaluasi respons serta validasi matematika yang digunakan dalam
 Pending                   transisi.

 OPS-05 — Pending    Detail operasional cross-capability transition dan state consistency.


Section 03 — Implementation Boundaries

Processing workflows  ini menetapkan hubungan  perilaku dan tanggung jawab  logis, bukan
pseudocode, API contract, database schema, atau physical architecture.

Engineering bebas mengusulkan pendekatan implementasi selama approved product behavior tetap
terpenuhi, hasil evaluasi dan keputusan dapat ditelusuri, serta keputusan yang belum selesai tidak
diasumsikan telah disetujui.
```

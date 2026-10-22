# Source Transcript — Data, AI & Methodological Foundations

> **Verbatim-style text extraction** from uploaded PDF pages **118–126**. This is a machine-extracted archival copy, not newly approved specification. PDF tables/line wraps may lose visual structure. Verify against `ReThink-Documentation-original.pdf` when an exact table, figure or label matters.

## Original PDF Page 118

```text
Data, AI & Methodological Foundations

Section ini menjelaskan fondasi informasi, aset matematika, metodologi diagnosis, rancangan AI, dan
sumber referensi yang diperlukan untuk mendukung implementasi MVP ReThink.

Setiap pendekatan dibedakan berdasarkan statusnya: PRD-Derived, Paper-Proposed, Research
Reference, atau Engineering Consideration. Section ini tidak menetapkan physical database schema,
API payload, prompt template, maupun pemilihan model AI final.

4.1 Concept, Content & Learner Data Foundations

A. Logical Information Inventory

 Information      Required Information                   Main          Status
 Category                                          Consumers

 Topic & Concept  Subject, topic, concept, relasi prasyarat, dan  LC-01, LC-08  PRD-Derived
 Knowledge        capability availability.


 Diagnostic       Supported blocker, known error patterns,  LC-03, LC-04  PRD-Derived
 Knowledge        interpretive     criteria,   dan    diagnostic
                   coverage.

 Assessment     Q1–Q3,   conditional  Q4,  mathematical  LC-02,        PRD-Derived
 Assets            reference   answers,   dan   assessment  LC-03, LC-04
                  metadata.

 Guided            Visual Explanation, Worked Example, Partial  LC-05, LC-03  PRD-Derived
 Learning Assets  Guided     Practice,    dan    associated
                  mathematical criteria.

 Validation        Independent   Retry,   Transfer   Problem,  LC-06, LC-03  PRD-Derived
 Assets           expected  mathematical   structure,  dan
                    evaluation criteria.

 Learner         Respons   asli,  evaluasi  matematika,  hasil  LC-03–LC-08  PRD-Derived
 Evidence          diagnosis,  participation/completion,  serta  sesuai
                        hasil validasi.                            tanggung
                                                         jawab

 Session     &  Selected topic, supported blocker, learning  LC-02,        PRD-Derived
 Transition         entry context, dan applicable eligibility.      LC-05–LC-08
 Context
```

## Original PDF Page 119

```text
Data inventory tersebut adalah kategori logis, bukan definisi entitas database atau kewajiban
menyimpan seluruh kategori dalam sistem persistence yang berbeda.

B. Concept Coverage & Capability Availability

ReThink harus mempertahankan pembedaan antara konsep yang direpresentasikan, dikonfigurasi,
dan benar-benar didukung.

 Coverage level  Meaning                           Implementation implication

 Represented    Topic/concept      tercatat     dalam  Dapat digunakan sebagai konteks
                knowledge structure.                   katalog atau relasi.

 Configured      Sebagian   metadata    atau    aset  Tidak otomatis berarti diagnostic
                  operasional tersedia.                   recovery dapat dijalankan.

 Actively          Capability  relevan  memiliki cakupan  Dapat menjalankan proses sesuai
 Supported      dan aset yang memenuhi ketentuan.      capability yang didukung.

SPL  menjadi supported  diagnostic  entry  topic, sedangkan  Distributive Property merupakan
satu-satunya conceptual blocker dengan complete recovery coverage pada MVP.

C. Curated Mathematical Asset Package

Untuk membangun satu complete recovery loop, tim perlu menyiapkan aset yang saling konsisten.

 Asset group       Minimum content consideration      Verification concern

 Diagnostic Items    Q1–Q3 dan kandidat Q4 yang sesuai  Peran      diagnostik     dan
                        blueprint                           kebenaran matematika

 Error        Pattern  Pattern   yang   relevan   terhadap  Tidak  menyimpulkan  blocker
 Knowledge            Distributive Property                     dari satu pola ambigu

 Reference Solutions  Expected    answers,    acceptable  Mathematical    validity   dan
 & Rubrics             transformations, reasoning criteria       interpretability

 Guided    Learning  Visual explanation, worked example,  Konsistensi    konsep    dan
 Content                partial guided practice               pedagogi

 Independent Retry    Item mandiri pada struktur konsep  Tidak  memberikan   scaffold
                    yang relevan                         tersembunyi
```

## Original PDF Page 120

```text
Transfer Problem     Konsep sama dengan  representasi  Perbedaan bersifat bermakna,
                      atau konteks berbeda               bukan sekadar angka


OPS-04 masih Pending. Tabel ini mengidentifikasi kebutuhan aset, bukan mengesahkan isi question
bank, rubrik, atau instrumen evaluasi tertentu.

D. Learner Evidence Integrity

Implementasi harus menjaga perbedaan antara raw student response, mathematical observation, AI
interpretation, diagnostic outcome, Guided Learning completion, dan validation learner state.

Hasil pada satu tingkat tidak boleh otomatis dianggap sebagai hasil pada tingkat berikutnya. Data
yang tidak dikumpulkan atau belum dievaluasi juga tidak boleh diubah menjadi kesimpulan bahwa
siswa memiliki conceptual gap.

Representasi learner evidence harus menjaga keterkaitan dengan konsep, tahap asesmen, serta
konteks sesi yang relevan.

4.2 Diagnostic Methodological Foundation

A. Evidence-Centered Design Adaptation

Rancangan diagnosis ReThink menggunakan Evidence-Centered Design (ECD) sebagai referensi
metodologis untuk menghubungkan klaim tentang siswa, bukti yang dapat diamati, dan tugas yang
menghasilkan bukti.

Adaptasi konseptual yang digunakan adalah:

Claim → Evidence → Task → Interpretation → Verification

 ECD-related    ReThink interpretation         Engineering relevance   Status
 construct

 Student Model  Hipotesis mengenai Distributive  Membatasi  klaim  yang  Research
                 Property   sebagai   possible  dapat dihasilkan sistem.   Reference
                   blocker.

 Task Model     Pertanyaan diagnostik dengan  Menentukan   informasi  Research
                peran evidence berbeda.        yang  diharapkan   dari  Reference
                                         Q1–Q4.

 Evidence       Kebenaran,  transformasi, pola  Menjaga     hubungan  Research
 Model           kesalahan,   dan   explanation  observasi      dengan  Reference
                  evidence.                          hipotesis.
```

## Original PDF Page 121

```text
Evidence      Penggabungan     supporting,  Mendukung   penalaran  Paper/Design-Pro
 Synthesis       counterevidence,         dan  diagnosis            lintas  posed
                     insufficient evidence.            pertanyaan.

 Diagnostic      Confirmed,   Rejected,   atau  Menghasilkan hasil yang  PRD-Derived
 Outcome        Uncertain.                         dibatasi approved rules.

 Verification      Evaluasi  keputusan  terhadap  Membantu     menguji  Engineering
                  reference cases.                 diagnostic consistency.    Consideration

ReThink mengadaptasi  prinsip ECD dan  tidak mengklaim mengimplementasikan keseluruhan
statistical measurement model dalam ECD.

B. Pre-Test Question Blueprint

 Question   Diagnostic role           Input type             Expected evidence

 Q1         Target Performance — SPL  Multiple Choice        Outcome pada tugas topik
                                                                    target

 Q2          Prerequisite Application —  Short     Mathematical  Bukti   penerapan    atau
               Distributive Property       Response                transformasi konsep

 Q3        Conceptual Reasoning      Short Explanation         Bukti  reasoning  terhadap
                                                                  transformasi matematika

 Q4         Conditional      Targeted  Procedural  Trace  atau   Klarifikasi  information gap
            Probe                    Conceptual Probe         spesifik

Q1 menggunakan distractor yang dapat dirancang berdasarkan kemungkinan kesalahan matematis
yang bermakna. Q2 dan Q3 memberikan tipe bukti berbeda sehingga diagnosis tidak hanya
bergantung pada jawaban akhir.

Q4 tidak diwajibkan untuk semua siswa dan tidak boleh menjadi probing loop berulang.

Butir  soal, contoh, accepted responses,  serta aturan pemilihan probe tetap membutuhkan
operational specification dan mathematical review.

C. Evidence Evaluation & Interpretation

Evaluasi diagnosis membedakan tiga tingkat informasi:

 Layer           Example                            Limitation

 Observation      Siswa menulis 3(x + 2) = 3x + 2.        Menunjukkan respons yang diamati.
```

## Original PDF Page 122

```text
Interpretation    Respons  konsisten dengan  partial  Belum   membuktikan   adanya
                       distribution.                        miskonsepsi yang menetap.

 Diagnostic         Bukti lintas pertanyaan mendukung  Hanya    dapat    menghasilkan
 Inference         atau tidak mendukung blocker.       keputusan dalam supported scope.

Empat dimensi evaluasi yang dapat digunakan dari rancangan diagnosis sebelumnya adalah
mathematical correctness, error characteristics, conceptual explanation, dan evidence clarity.

Sistem juga perlu mempertimbangkan supporting evidence, counterevidence, dan insufficient
evidence, termasuk penjelasan alternatif untuk kesalahan siswa.

D. Methodological Boundaries

ECD, DINA, cognitive diagnostic multiple-choice design, dan Rule Space merupakan sumber
pemahaman metodologis. ReThink MVP tidak diwajibkan menerapkan model statistik tersebut.

Implementasi tidak boleh menghasilkan probabilitas mastery yang seolah terkalibrasi tanpa landasan
pengukuran yang memadai.

OI-01 — Open: pembagian final diagnostic decision authority.​
OI-03 — Open: all-correct diagnostic outcome mapping.​
OPS-04 — Pending: mathematical items dan evaluation rubrics.

4.3 AI & Mathematical Evaluation Architecture

A. Paper-Proposed Technical Approach

Paper ReThink menggambarkan pendekatan hibrida berupa knowledge graph untuk relasi konsep,
rule-based  orchestration,  deterministic mathematical  validation,  serta LLM  terbatas sebagai
supporting layer.

Pendekatan tersebut menjadi referensi awal engineering design, bukan keputusan  final untuk
physical architecture maupun pemilihan model.

 Responsibility        Paper-proposed          Design boundary
                    approach

 Mathematical           Deterministic    expression  Hasil matematika perlu dapat diverifikasi
 Correctness           checking

 Error          Pattern  Curated   known    error  Tidak bebas menetapkan blocker baru
 Evaluation              patterns
```

## Original PDF Page 123

```text
Reasoning            Context-bounded LLM       Tidak  mengabaikan  evidence  atau
 Interpretation                                     counterevidence

 Diagnostic Outcome    Structured orchestration      Final  decision  allocation  tetap OI-01
                                       Open

 AI Output Handling     Structured         output  Invalid output tidak boleh dianggap hasil
                           validation                  sah

 Guided Learning       Curated        instructional  Tidak   menggunakan   autonomous
                     sequence                   adaptive teaching

 Knowledge Validation   Controlled    retry/transfer  Learner   state  mengikuti  approved
                           rules                        decision matrix


B. Paper-Proposed Technology Register

 Technical role            Technology mentioned  in  Adoption status
                        paper

 Frontend interface            Flutter                     Paper-Proposed — Not Locked

 Backend & orchestration     FastAPI                    Paper-Proposed — Not Locked

 Concept relationships       Neo4j                      Paper-Proposed — Not Locked

 Learner data & metadata    PostgreSQL                Paper-Proposed — Not Locked

 Mathematical evaluation    SymPy                     Paper-Proposed — Not Locked

 AI       structured-output  Pydantic                   Paper-Proposed — Not Locked
 validation

 Language model            DeepSeek-V4.1-Flash via API   Paper-Proposed — Not Locked


 Mathematical visualization   JSXGraph, SVG, atau Canvas  Paper-Listed Candidates — Not
                                                   Locked

Engineering  boleh  merekomendasikan  alternatif  setelah  mengevaluasi   feasibility,  reliability,
compatibility, dan cost. Perbedaan dari rancangan paper dicatat dalam Technical Deviation Register
pada Section 05.

Pemilihan library atau framework alternatif tidak boleh mengubah approved product behavior.

C. AI Responsibilities & Safeguards
```

## Original PDF Page 124

```text
Area            Required consideration                      Status

 Input Context      AI menerima informasi yang relevan terhadap  Paper-Proposed            /
                  supported task dan concept.                    Engineering
                                                                 Consideration

 Mathematical       Interpretasi  atau  feedback  AI  tidak  boleh  PRD-Derived boundary
 Reliability         bertentangan  dengan  referensi  matematika
                 yang valid.

 Diagnostic         AI tidak boleh memperluas supported blockers  PRD-Derived
 Coverage         secara independen.

 Evidence           Interpretasi     harus    mempertimbangkan  PRD-Derived
 Handling          ambiguitas dan counterevidence.

 Output Validation  Output AI perlu diperiksa sebelum digunakan  Paper-Proposed
                    oleh proses berikutnya.

 Failure Handling   Kegagalan  AI  tidak  boleh  diubah  menjadi  Engineering
                   kesimpulan diagnosis yang tampak valid.         Consideration

 Decision         Penanggung   jawab     finalisasi    diagnosis  OI-01 Open
 Authority         memerlukan alignment.


D. Implementation Questions Left to Engineering

Detail yang belum ditentukan meliputi pilihan model AI final, inference strategy, prompt design,
mathematical comparison approach, persistence implementation, output schema, dan API structure.

Engineering dapat mendesain alternatif yang memenuhi kewajiban PRD dan membawa proposal
perubahan yang memengaruhi product behavior untuk ditinjau melalui governance.

4.4 Research References & External Datasets

A. Methodological Reference Registry

 Reference                    Contribution                     ReThink usage status

 Mislevy,  Almond,  dkk. —  Kerangka hubungan student claims,  Adapted
 Evidence-Centered   Design  evidence, dan tasks.                 methodological
 (2003)                                                             reference

 de  la  Torre — Cognitively  Distractor dengan nilai diagnostik.     Question-design
 Based      Multiple-Choice                                      research reference
 Options (2009)
```

## Original PDF Page 125

```text
de  la Torre — DINA Model  Cognitive diagnostic modeling dan  Theoretical reference;
 (2009)                            atribut keterampilan.                 not implemented

 Tatsuoka —  Rule  Space  Pendekatan diagnosis berbasis pola  Theoretical reference;
 (1983)                         respons.                            not implemented

 Bastani et al. (2025)             Risiko  pembelajaran   dari  GenAI  AI/pedagogical
                              tanpa safeguards.                    reference

 Visualization,      Worked  Landasan   pembelajaran   melalui  Instructional
 Examples    &     Transfer  representasi,  contoh,   scaffolding,  methodology
 Literature                  dan penerapan konsep.               references

Referensi lengkap, DOI/URL, dan detail bibliografis harus dicocokkan dengan daftar pustaka paper
serta sumber primer sebelum digunakan sebagai paket handoff final. Registry ini bukan klaim bahwa
semua metode telah diimplementasikan.

B. External Dataset Registry

 Dataset                Information referenced         Potential use       MVP
                                                                              status

 Eedi  Misconceptions  Concept/misconception          Eksplorasi             Deferred
 Graph                    relationships                   concept–blocker      Research
                                                  knowledge

 Eedi MAP               Questions,            student  Contoh reasoning dan  Deferred
                            explanations,    misconception  interpretive evaluation  Research
                             labels

 FoundationalASSIST     Student            responses,  Studi       response  Deferred
                             interactions, skill mapping        patterns        dan  Research
                                                                      skill-related evidence

Dataset eksternal tidak menjadi mandatory dependency untuk menjalankan MVP.

Operational diagnostic knowledge ReThink tetap memerlukan curated assets yang valid untuk
Distributive Property.

C. Reference Adoption & Data Governance

Sebelum menggunakan dataset eksternal untuk training, evaluation, atau penyusunan curated
assets, engineering perlu memeriksa akses, lisensi, cakupan konsep, kualitas label, representativitas,
dan kesesuaian matematis terhadap supported MVP.
```

## Original PDF Page 126

```text
Referensi yang diadopsi  tidak otomatis memperluas diagnostic coverage atau membuktikan
ketepatan diagnosis ReThink.

Katalog sumber dan tautan bibliografis yang telah diverifikasi akan menjadi bagian dari handoff
reference registry, tanpa menambah requirement implementasi baru.

Section 04 — Boundary Statement

Section ini menetapkan fondasi informasi dan referensi teknis yang diperlukan untuk memulai system
design. Dokumen tidak menentukan ERD, database schema, JSON contract, prompt template,
technology selection, atau AI decision algorithm final.

Semua implementasi tetap mengacu pada approved PRD serta approved Technical Blueprint
Sections 01–03.
```

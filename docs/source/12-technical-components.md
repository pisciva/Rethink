# Source Transcript — System Components & Responsibilities

> **Verbatim-style text extraction** from uploaded PDF pages **104–108**. This is a machine-extracted archival copy, not newly approved specification. PDF tables/line wraps may lose visual structure. Verify against `ReThink-Documentation-original.pdf` when an exact table, figure or label matters.

## Original PDF Page 104

```text
System Components & Responsibilities

2.1 Logical System Architecture

Arsitektur konseptual ReThink terdiri atas delapan komponen logis yang mendukung pengalaman
pemulihan konsep secara terintegrasi.

Pemisahan komponen bertujuan memperjelas tanggung jawab pengelolaan konteks pembelajaran,
evaluasi matematika, interpretasi diagnosis, penyajian intervensi, validasi, dan representasi hasil
belajar.

[DIAG-01 — Logical System Architecture Diagram]

Placeholder: Diagram hubungan LC-01–LC-08, termasuk alur utama diagnosis → guided learning →
knowledge validation, dukungan evaluasi matematika, koordinasi transisi, dan proyeksi hasil pada
Hybrid Learning Map.

Status: Pending Diagram Development — setelah seluruh struktur Technical Blueprint disetujui.

Diagram  ini nantinya merepresentasikan logical responsibilities dan information exchange, bukan
microservice boundaries, deployment architecture, atau database topology.

Delapan komponen tidak harus diwujudkan sebagai delapan layanan perangkat lunak terpisah.
Penggabungan atau pemisahan fisik menjadi keputusan engineering, selama kewajiban produk dan
batas tanggung jawab tetap dipenuhi.

2.2 Component Responsibilities

 Component      Primary Responsibility  Required Inputs   Expected      PRD
                                                     Outputs         Reference

 LC-01    —  Menyediakan   katalog  Curated  catalog,  Supported topic  C1, F1–F2
 Learning Entry &  topik, relasi konsep, dan  topic–concept     context     dan
 Catalog           informasi  ketersediaan  relationships,       diagnostic entry
                  dukungan.                 capability              eligibility.
                                                          availability.

 LC-02    —  Mengelola       urutan  Selected    topic,  Assessment     C3
 Assessment     Q1–Q3, maksimal satu  assessment       responses
 Flow Controller  Q4  kondisional,  serta  blueprint,          beserta konteks
                 pengumpulan respons.   question         dan   metadata
                                                    definitions,         relevan.
                                           student
                                            responses.
```

## Original PDF Page 105

```text
LC-03    —  Mendukung             Student            Item-level        C3, C5
Mathematical    pemeriksaan kebenaran  responses,        mathematical
Evaluation        matematika,             curated           observations
Support           transformasi,      dan  mathematical     dan   evaluation
                     interpretasi   terhadap  references,          results.
                  reference criteria.         applicable
                                                 rubrics.

LC-04    —  Menyintesiskan          Mathematical      Confirmed,       C3, OI-01
Diagnostic        diagnostic evidence dan  observations,      Rejected,   atau
Interpretation &  mendukung penentuan  response          Uncertain
Decision          diagnostic    outcome  evidence,         beserta
Support         yang sah.               supported        evidence   basis
                                            diagnostic        yang relevan.
                                        knowledge.

LC-05 — Guided  Mengelola    penyajian  Learning    entry  Participation     C4
Learning         paket    pembelajaran  context,           evidence,
Controller          terkurasi,      respons  supported        completion
                Guided  Practice,  dan  concept,            state,      dan
                  completion.               instructional        learning handoff
                                         package, student  context.
                                                 interactions.

LC-06    —  Mengelola Independent   Eligible   learning  Understood,     C5
Knowledge        Retry, Transfer Problem  context,           Procedural Only,
Validation         kondisional,       dan  validation  items,  atau     Needs
Controller       penetapan      learner  mathematical      Reinforcement.
                     state.                    evaluation results.

LC-07    —  Mempertahankan        Selected    topic,  Transition        FR-X-01–03
Session     &  konteks           serta  diagnostic            eligibility    dan
Transition        mengoordinasikan       outcome,          consistent
Coordination     perpindahan              learning  context,  workflow
                antarkemampuan        completion,        context.
                 berdasarkan     aturan  validation
                yang berlaku.           outcomes.

LC-08    —  Merepresentasikan      Knowledge         Explore,  Focus,  C2
Learning  Map  curated       concept  structure,        dan    Progress
Projection         relationships, diagnostic  capability          representations.
                   focus,           dan   availability,
                 evidence-based          diagnostic
                   progress.
```

## Original PDF Page 106

```text
outcomes,
                                               learner states.

Komponen di atas menjelaskan tanggung jawab konseptual. Definisi data model, API contracts,
storage mechanisms, dan internal implementation tetap menjadi bagian dari engineering design.

Component Design Boundaries

    ●​ LC-03 menghasilkan evaluasi atau observasi matematika, bukan diagnostic conclusion secara
      independen.
    ●​ LC-04 bertanggung jawab secara logis terhadap diagnostic interpretation dan outcome
       coordination; alokasi final decision authority masih mengikuti OI-01.
    ●​ LC-05 mengelola aktivitas serta completion pembelajaran, bukan learner understanding
        status.
    ●​ LC-06 menentukan learner state berdasarkan approved validation rules dan item-level
      evidence yang berlaku.
    ●​ LC-07 mengelola eligibility dan perpindahan, bukan menciptakan diagnostic atau validation
      outcome baru.
    ●​ LC-08 merepresentasikan evidence dan status yang telah ditentukan, bukan melakukan
       diagnosis tersendiri.

2.3 Cross-Component Contracts & Ownership

Pertukaran informasi antarkomponen harus mempertahankan hubungan antara data input, evaluasi
matematika, interpretasi, dan hasil keputusan.

Kontrak pada bagian ini merupakan logical information contracts, bukan API specification atau JSON
schema.

 Information           /  Conceptual    Consumers      Integrity Requirement
 Decision          Owner

 Topic &  Capability  LC-01          LC-02, LC-08    Konsep yang direpresentasikan tidak
 Availability                                           otomatis     menjadi    supported
                                                          diagnostic target.

 Assessment         LC-02          LC-03, LC-04   Raw  student  response,  question
 Responses                                               context,  dan  interpretation  harus
                                                    dapat dibedakan.

 Mathematical       LC-03         LC-04, LC-06     Hasil   item-level   evaluation   tidak
 Evaluation Results                                    otomatis menetapkan diagnosis atau
                                                            learner state.
```

## Original PDF Page 107

```text
Diagnostic           LC-04, subject  LC-05,  LC-07,  Confirmed, Rejected, dan Uncertain
 Outcome             to OI-01       LC-08          hanya   berlaku  pada  supported
                                                        blocker dan evidence yang relevan.

 Learning           LC-05         LC-06, LC-07    Completion  tidak  secara  otomatis
 Participation    &                              membuktikan        pemahaman
 Completion                                                     tervalidasi.

 Validation  Learner  LC-06          LC-07, LC-08     State mengikuti approved three-state
 State                                              mapping.

 Transition Eligibility  LC-07         Workflow         Transisi mengikuti outcome, konteks
                                           controllers      masuk, completion, dan  applicable
                                                                             eligibility rules.

 Learning     Map  LC-08          User-facing      Representasi tidak boleh mengubah
 Representation                     product        makna  diagnostic  outcome  atau
                                           interface          validation state.

Cross-Component Integrity Principles

1. Evidence and Decision Separation

Respons siswa, hasil evaluasi matematika, sintesis evidence, dan keputusan diagnosis harus dapat
dibedakan secara logis.

2. Explicit Decision Ownership

Diagnostic outcomes, Guided Learning completion, dan validation learner states memiliki tanggung
jawab keputusan yang  berbeda. Komponen  lain dapat menggunakan  hasil tersebut tanpa
menetapkan ulang maknanya.

3. Context Continuity

Informasi selected topic, supported conceptual blocker, learning entry context, dan applicable
outcome harus tetap konsisten selama perpindahan antarkemampuan.

4. No Implicit State Promotion

Confirmed diagnosis tidak otomatis menghasilkan Understood. Penyelesaian Guided Learning juga
tidak otomatis menghasilkan learner state dari Knowledge Validation.

5. Dependency-Aware Integration

Perilaku yang bergantung pada OI-01–OI-03 dan OPS-01–OPS-05 harus mempertahankan status
unresolved sampai keputusan atau spesifikasi terkait disetujui.
```

## Original PDF Page 108

```text
Architectural Limitations

Section  ini tidak menetapkan physical service decomposition, database architecture, endpoint
definitions, transport protocols, maupun data persistence technology.

Komponen logis dapat diimplementasikan melalui pendekatan engineering yang berbeda selama
behavioral obligations, evidence boundaries, dan consistency requirements dari approved PRD tetap
terpenuhi.
```

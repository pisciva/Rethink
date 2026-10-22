# Source Transcript — Product Requirements summary, FR inventory, decisions

> **Verbatim-style text extraction** from uploaded PDF pages **52–57**. This is a machine-extracted archival copy, not newly approved specification. PDF tables/line wraps may lose visual structure. Verify against `ReThink-Documentation-original.pdf` when an exact table, figure or label matters.

## Original PDF Page 52

```text
ReThink Summary

                  PRODUCT REQUIREMENTS DOCUMENT

Inventaris Persyaratan

Kelompok                     Rentang ID                    Jumlah

C1 — Akses & Penemuan Topik    FR-C1-01–05                   5

C2 — Hybrid Learning Map       FR-C2-01–05                   5

C3 — Diagnosis & Hasil           FR-C3-01–10                    10

C4 — Pembelajaran Terarah       FR-C4-01–08                   8

C5 — Validasi Pengetahuan       FR-C5-01–08                   8

Lintas Kapabilitas                FR-X-01–03                     3

TOTAL                                                         39


5.1 Kerangka & Konvensi Persyaratan
Setiap  FR  memiliki  ID  stabil,  kewajiban  yang  dapat  diamati,  prioritas,  status  keputusan,
sumber/dependency, dan dasar verifikasi. Seluruh 39 FR aktif berprioritas Must Have dan telah
disetujui pada baseline v1.0. Status Approved tidak berarti implementasi atau pengujian telah selesai;
dependency yang tercatat tetap terbuka.

Prioritas lain (Should Have, Could Have, Won’t Have — MVP) tidak mengesahkan perubahan scope.
Product Design mengatur  interaksi/UX, Technical Documentation mengatur implementasi, dan
spesifikasi konten matematika mengatur butir soal, solusi acuan, serta rubrik. Perubahan kewajiban
produk memerlukan impact review.

5.2 Akses Pembelajaran & Penemuan Topik
C1 mengelola akses, ketersediaan konten, pemilihan topik, dan kelayakan memasuki asesmen; tidak
menetapkan diagnosis atau learner state.

 ID & fokus       Kewajiban fungsional (ringkas)       Dasar verifikasi              Depende
                                                                            ncy
 FR-C1-01​        Menyediakan   titik  masuk  berbasis
                                                         Katalog dapat  diakses; Aljabar Akses    katalog  katalog  untuk   menjelajahi  bidang                   —                                                                      teridentifikasi sebagai bidang.
 matematika       matematika.
 FR-C1-02​        Mengorganisasi  konten  berdasarkan
 Penemuan        bidang dan  topik tanpa mewajibkan  SPL ditemukan di bawah Aljabar.  —
 bidang dan topik   layar terpisah per tingkat.
```

## Original PDF Page 53

```text
Membedakan topik dengan dukungan FR-C1-03​                                                 Status ketersediaan  jelas; tidak
                        aktif    dari    topik   yang   hanya Ketersediaan                                       ada akses palsu ke  fitur yang —
                     direpresentasikan;     topik    tanpa dukungan                                         belum aktif.
                 dukungan dinyatakan belum tersedia.
 FR-C1-04​       Memungkinkan  memilih SPL sebagai
                                                           Pemilihan SPL membuka konteks Pemilihan   topik  topik MVP dan mempertahankannya                   —
                                                            diagnosis SPL yang benar. didukung         sebagai konteks diagnosis.
 FR-C1-05​                 Hanya    topik   dengan   dukungan  SPL dapat memulai  diagnosis; Kelayakan
                    diagnosis  aktif yang dapat memulai  topik  tanpa  dukungan  tidak —
 memulai                  asesmen.                              dapat. diagnosis


5.3 Persyaratan Hybrid Learning Map

C2 hanya merepresentasikan hubungan terkurasi dan evidence yang dihasilkan C3/C5; tidak mengambil
keputusan diagnosis maupun validasi.

 ID & fokus             Kewajiban fungsional (ringkas)                   Dasar verifikasi                       Dependency
 FR-C2-01​
                     Menampilkan relasi matematika terkurasi antara   Relasi  SPL–Distributive Property benar; Relasi       konsep                                                  —                         topik terpilih dan konsep relevan.                 tanpa relasi yang belum diverifikasi.
 terkurasi
                     Menampilkan   orientasi  topik  dan  hubungan   Peta  pra-diagnosis  tidak  memberikan FR-C2-02​                     konsep sebelum evidence diagnosis individual   label   kelemahan   atau  pemahaman — Explore                           tersedia.                                           personal.
                        Merefleksikan    hasil    diagnosis   C3   dan   Confirmed  berfokus pada  Distributive FR-C2-03​                   membedakan    blocker    Confirmed     dari   Property;   hasil  non-confirmed   tidak   OI-03 Focus diagnosis                         Rejected/Uncertain.                                 dilabelkan sebagai kelemahan terbukti.
                     Menampilkan status tingkat blocker yang telah FR-C2-04​                                                        Understood  / Procedural Only  / Needs                        ditentukan C5 setelah Knowledge Validation yang                                        OI-02 Progress tervalidasi                                                   Reinforcement sesuai keluaran C5.                          berlaku.
 FR-C2-05​              Tidak menetapkan status paham, tidak paham,
                                                              Konsep tak diases tetap tanpa learner Integritas   cakupan   atau  blocker Confirmed pada konsep  tanpa                        —
                                                                              state walau tampil di peta.dan state              evidence asesmen.


5.4 Persyaratan Diagnosis & Hasil

C3 bertanggung jawab atas evidence asesmen, interpretasi, outcome diagnosis dan kelanjutan
sesuai outcome. Batas MVP: tiga soal inti dan maksimal satu probe.

ID & fokus         Kewajiban fungsional (ringkas)          Dasar verifikasi                Dependen
                                                                                    cy
FR-C3-01​                 Melakukan  asesmen  dalam  konteks
Konteks                                                   Tidak  ada  diagnosis  blocker                    SPL, hanya mengevaluasi  Distributive                   —
diagnosis                                         tambahan yang belum didukung.                   Property sebagai blocker aktif.didukung
                Memberikan Q1 pilihan ganda performa
FR-C3-02​         SPL; Q2 respons matematika singkat  Seluruh  tiga  soal  inti  tersedia
                                                 — Blueprint Q1–Q3   Distributive  Property; Q3  penjelasan  sesuai fungsi dan formatnya.
                    konseptual.
```

## Original PDF Page 54

```text
Mengumpulkan   respons   menurutFR-C3-03​                                          Respons Q1–Q3 dan Q4 jika ada
                  format   soal  dan  mempertahankanPengumpulan                                          dapat  ditelusuri  ke  soal yang —
                     asosiasi dengan peran soal dan konteksrespons                                                        tepat.
                  matematika.
                    Menilai  outcome,  transformasi,  dan
FR-C3-04​                                                Kategori evidence yang berlaku                   penjelasan  yang  relevan  dari  tiap
 Evaluasi evidence                                            diperiksa tanpa inferensi dari satu —                   respons; satu kesalahan  tidak cukup
matematika                                                         error.                  untuk mengonfirmasi blocker.
                Mempertimbangkan         evidence
FR-C3-05​                                           Kasus       acuan       yang
                mendukung, bertentangan, dan tidak Sintesis      lintas                                            kontradiktif/ambigu tidak dipaksa  OI-01                 cukup dari semua soal yang diberikan
soal                                                   menjadi Confirmed.
                 sebelum menarik kesimpulan.
                Memberikan paling banyak satu probe
FR-C3-06​                     ketika ada kekosongan evidence yang   Total maksimal empat soal; Q4Probe     Q4                                                                      OI-01
                     relevan; bentuk Procedural Trace atau  tidak wajib dan tidak berulang.
kondisional
                  Conceptual Probe.
FR-C3-07​        Menghasilkan  Confirmed,   Rejected,  Kasus    acuan    memetakan
 Hasil   diagnosis  atau    Uncertain    untuk    blocker  outcome secara  sah; evidence  OI-01;
berbasis            Distributive Property sesuai evidence  tidak cukup dapat menghasilkan  OI-03
evidence         dan aturan yang berlaku.                 Uncertain.
FR-C3-08​        Membatasi interpretasi AI pada konsep  AI  tidak  menetapkan  blocker
 Interpretasi    AI  didukung,  respons  siswa,   verifikasi  unsupported atau mengabaikan  OI-01
berbatas         matematika dan safeguard sistem.         guardrail.
FR-C3-09​        Menjelaskan outcome, cakupan konsep  Confirmed, Rejected, Uncertain
Komunikasi  hasil  yang diperiksa, dan keterbatasan; tidak  dibedakan secara jelas dan tidak  OI-03
diagnosis         mengklaim mastery SPL.                 overclaim.
FR-C3-10​        Confirmed  memberi  jalur  recovery;
Kelanjutan         Rejected/Uncertain      menyediakan  Opsi  setelah  diagnosis  cocok  OI-02;
menurut           eksplorasi topik atau Optional Concept  dengan hasil dan konteksnya.      OI-03
outcome         Review tanpa klaim blocker Confirmed.


5.5 Persyaratan Guided Learning Terarah
C4 memiliki paket pembelajaran dan completion, bukan diagnosis atau penetapan learner state.
Paket yang sama dapat diakses melalui dua konteks masuk.

ID & fokus        Kewajiban fungsional (ringkas)        Dasar verifikasi              Dependen
                                                                              cy
FR-C4-01​
                 Menyediakan  satu paket  DistributivePaket                                                     Ketiga komponen tersedia dalam
                    Property:  Visual  Explanation, Worked                            OPS-04pembelajaran                                           paket didukung.
                  Example, Partial Guided Practice. terkurasi
               Membedakan Confirmed Recovery dariFR-C4-02​
                   Optional Concept Review; review tidak  Asal     jalur   dan   outcomeKonteks  masuk                                                                    OI-02
               mengubah  diagnosis  awal  menjadi  diagnostik tetap terlacak.pembelajaran
                  Confirmed.
FR-C4-03​        Menyajikan  ilustrasi  konseptual yang  Representasi visual menjelaskan
 Visual            sah   untuk  hubungan   Distributive  hubungan  matematika dengan  OPS-04
Explanation        Property, bukan hanya rumus.            benar.
```

## Original PDF Page 55

```text
Menyajikan  contoh  terkurasi denganFR-C4-04​                                                     Solusi    sah    dan    alasan
                   transformasi  benar dan  alasan  atas                            OPS-04Worked Example                                           transformasi tersedia.
                  langkah penting.
FR-C4-05​       Meminta   siswa   mengisi   langkah  Minimal satu respons matematika
                                                                                   OPS-01; Partial   Guided  matematika  atau  reasoning  dalam   aktif diperlukan; melihat contoh
                                                                         OPS-04Practice aktif       solusi yang sebagian dibimbing.           saja tidak cukup.
                   Mengikuti Visual Explanation → Worked
FR-C4-06​                                             Urutan selalu sesuai rancangan
                 Example →  Partial Guided  Practice                   —Urutan tetap                                       pada jalur didukung.                  tanpa pemilihan scaffold adaptif.
               Membedakan pembelajaran selesai vs
FR-C4-07​        belum, mempertahankan konsep dan                                OPS-01;
                                                      Handoff    mengikuti     kriteriaCompletion   &  konteks asal untuk handoff; recovery                                OPS-02;                                                       completion dan konteks asal.
handoff          Confirmed yang selesai dapat lanjut ke                                OI-02
                        validasi.
FR-C4-08​          Partisipasi      atau      completion                                                    Tanpa   validasi  berlaku,  tidakBatas klaim hasil  pembelajaran      tidak      otomatis                   —
                                                   muncul tiga learner state C5.
 belajar           membuktikan pemahaman tervalidasi.


5.6 Persyaratan Validasi Pengetahuan & Hasil Belajar
C5 mengevaluasi Independent Retry dan Transfer Problem, lalu menetapkan learner state tingkat
blocker. Tidak melakukan re-diagnosis.

ID & fokus        Kewajiban fungsional (ringkas)        Dasar verifikasi              Dependen
                                                                              cy
FR-C5-01​        Knowledge Validation tersedia setelah  Tidak  terbuka  hanya  karena
Kelayakan        Confirmed Recovery selesai dan terkait  memilih topik atau belum selesai  OI-02
 validasi             Distributive Property.                        belajar.
FR-C5-02​        Memberikan soal Distributive Property
                                                       Siswa       bekerja      tanpa
Independent      tanpa scaffolding; struktur matematika                            OPS-04                                                               petunjuk/solusi yang disiapkan.
Retry               sejenis namun tidak menyalin contoh.
                Hanya setelah retry berhasil; konteks
FR-C5-03​                                                Retry  gagal   tidak  membuka
                   atau   representasi   harus  berbedaTransfer Problem                                               transfer; retry berhasil membuka  OPS-04
                 bermakna,  bukan   sekadar   angka
kondisional                                                   soal transfer.                   pengganti.
                                                                  Hasil item  valid  tersedia untuk
FR-C5-04​         Menilai  setiap  respons  retry/transfer                                                      keputusan state; respons ambigu  OPS-03;
 Evaluasi respons  terhadap kriteria matematika terkurasi
                                                                tidak  otomatis dianggap  salah  OPS-04 validasi          dan menghasilkan hasil item-level.                                                        konsep.
                   Retry gagal → Needs Reinforcement  Ketiga      kombinasi      sahFR-C5-05​
                   (tanpa transfer); retry lulus + transfer  menghasilkan    state    tepat;  OI-02;
Penetapan                   gagal → Procedural Only; keduanya  transfer tidak diberikan saat retry  OPS-03learner state
                       lulus → Understood.                      gagal.
FR-C5-06​       Menyampaikan   state   validasi  dan
                                                           Ketiga hasil dapat dibedakan dan
Komunikasi         artinya   hanya   untuk   Distributive                   —                                                                tidak menyatakan mastery SPL.learner state       Property yang dinilai.
FR-C5-07​
                Needs Reinforcement kembali ke paket  Arah  kelanjutan  sesuai  state
Kelanjutan
                Guided  Learning  yang sama; tanpa  tanpa memulai proses tambahan —menurut  learner                    re-diagnosis atau paket adaptif baru.    yang excluded.
state
```

## Original PDF Page 56

```text
FR-C5-08​         Tidak membuat diagnosis blocker baru   Validasi  hanya  memberi  hasil
Batas   evidence  atau  menelusuri  prasyarat  lain  dari  dalam  cakupan  blocker  yang —
 validasi           kesalahan validasi.                                diuji.


Matriks keputusan C5 (berlaku setelah item-level evaluation yang sah):

 Independent Retry               Transfer Problem               Learner state
 Gagal                          Tidak diberikan               Needs Reinforcement
 Lulus                        Gagal                          Procedural Only
 Lulus                            Lulus                        Understood


5.7 Persyaratan Lintas Kapabilitas

FR-X mengikat konteks, transisi, dan komunikasi hasil antarkapabilitas, tanpa menjadi capability
keenam.

ID & fokus        Kewajiban fungsional (ringkas)        Dasar verifikasi              Dependen
                                                                              cy
FR-X-01​         Mempertahankan  topik  SPL,  konsep  Konteks      tidak      tertukar;
Kontinuitas         Distributive  Property,  serta  konteks  Confirmed   Recovery    tetap  OPS-05
konteks         masuk saat berpindah C3–C5.          berbeda dari Optional Review.
FR-X-02​         Memastikan transisi C3–C5 mematuhi  Rejected/Uncertain         tidak  OI-02;
 Transisi  berbasis  outcome diagnosis, konteks masuk, dan  otomatis  boleh   validasi  atau  OI-03;
outcome           syarat completion pembelajaran.        dianggap recovery Confirmed.    OPS-05
                 Menjaga makna hasil diagnosis, learner  Peta     tidak    menampilkanFR-X-03​                                                                                   OI-02;                    state  tervalidasi, dan Hybrid Learning  Understood    hanya    karena
Konsistensi peta                                                                          OI-03;
              Map tetap sama untuk evidence siswa  diagnosis Confirmed atau belajar& hasil                                                                    OPS-05                 yang sama.                                  selesai.


Prinsip integritas & cakupan verifikasi
IP-01 — Kepemilikan evidence dan learner state: C3 menentukan hasil diagnosis; C4 memiliki
partisipasi/completion; C5 menetapkan learner state berdasarkan validasi; C2 merepresentasikan
evidence tanpa keputusan independen. Diagnosis Confirmed ataupun completion tidak dengan
sendirinya memberikan state C5.

IP-02 — Batas dukungan eksplisit: kehadiran topik pada katalog atau peta relasi tidak membuktikan
aktifnya kemampuan diagnosis, recovery, atau validasi. Konsep tanpa asesmen tidak menerima label
learner state.

V-X-01–V-X-08 merupakan kategori verifikasi integrasi awal, bukan FR baru atau test script lengkap.
Nama kategori sumber dipertahankan sebagai label referensi.

 ID            Skenario referensi                 Fokus verifikasi sumber
                                            Masuk dari SPL, konfirmasi blocker, pembelajaran
 V-X-01         Penyelesaian recovery Confirmed       terkurasi, validasi yang berlaku, hasil tingkat blocker
                                               yang benar
```

## Original PDF Page 57

```text
Rejected dan Uncertain tidak menjadi Confirmed; V-X-02         Kelanjutan diagnosis non-confirmed
                                                hanya kelanjutan yang sesuai
                                            Needs  Reinforcement,  tanpa  Transfer  Problem,
 V-X-03        Independent Retry gagal                                                    kembali ke pembelajaran yang didukung
 V-X-04         Transfer Problem gagal                Procedural Only jika retry berhasil dan transfer gagal
 V-X-05          Validasi berhasil                    Understood hanya jika retry dan transfer berhasil
                                                      Tidak  mengaktifkan  diagnosis,  recovery,  atau
 V-X-06        Batas konsep tanpa dukungan                                                               validasi untuk konsep unsupported
                                          Outcome  dan  kelanjutannya  masih menunggu
 V-X-07         Pola semua jawaban diagnosis benar
                                                OI-03
                                                   Kelayakan validasi dan dampak learner state masih
 V-X-08         Kelanjutan setelah Optional Review                                          menunggu OI-02


Register keputusan dan spesifikasi terbuka

 ID            Status       Pokok keputusan / spesifikasi
                           Pembagian wewenang  interpretasi  AI,  verifikasi matematika, dan batas OI-01       Open
                                 sistem.
 OI-02       Open         Kelayakan validasi dan learner state setelah Optional Concept Review.
 OI-03       Open        Pemetaan outcome ketika seluruh jawaban diagnosis benar.
 OPS-01       Pending      Mekanisme umpan balik Guided Practice.
 OPS-02       Pending         Kriteria completion Guided Learning.
                           Penanganan respons  validasi kosong,  tidak lengkap, tak terbaca, atau
 OPS-03       Pending                                ekuivalen secara matematika.
 OPS-04       Pending        Butir matematika terkurasi, solusi acuan, dan rubrik.
 OPS-05       Pending       Desain operasional transisi dan state lintas kapabilitas.
```

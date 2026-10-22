# Source Transcript — PRD consolidated executive summary

> **Verbatim-style text extraction** from uploaded PDF pages **1–17**. This is a machine-extracted archival copy, not newly approved specification. PDF tables/line wraps may lose visual structure. Verify against `ReThink-Documentation-original.pdf` when an exact table, figure or label matters.

## Original PDF Page 1

```text
ReThink Summary

                  PRODUCT REQUIREMENTS DOCUMENT


01. Gambaran Umum Produk.....................................................................................................................................2
02. Pernyataan Masalah & Pengguna Sasaran.......................................................................................................4
03. Tujuan Produk & Ukuran Keberhasilan.............................................................................................................. 7
04. Cakupan Produk & Definisi MVP.........................................................................................................................9
05. Ringkasan Persyaratan Produk..........................................................................................................................11
06. Dilewati — tercakup dalam Bagian 04–05..................................................................................................... 11
07. Arsitektur Konseptual Produk & Skalabilitas...................................................................................................12
08. Peta Jalan Produk.................................................................................................................................................13
09. Asumsi, Risiko & Ketergantungan.....................................................................................................................14
10. Prinsip Penerimaan Produk & Tata Kelola PRD...............................................................................................15
```

## Original PDF Page 2

```text
01. Gambaran Umum Produk

1.1 Identitas & Posisi Produk

 Atribut                                                Definisi
 Nama produk                                    ReThink
                                                     Platform   Pemulihan  Pemahaman   Konseptual
 Kategori
                                                   Matematika Berbantuan AI
 Domain                                           Pendidikan matematika
                                                  Siswa SMA yang mengalami kesulitan pada topik
 Pengguna utama                                   matematika  tertentu;  profil   ini  masih  perlu
                                                                  divalidasi
 Mode belajar                                          Belajar mandiri dengan dukungan terarah
                                                    Diagnosis   berbasis   bukti →   pembelajaran
 Fokus
                                                       terbimbing → validasi pemahaman
                                                           Interpretasi bukti berbantuan AI dengan otonomi
 Pendekatan AI
                                                  yang dibatasi


1.1.2 Posisi produk

ReThink merupakan platform pemulihan pemahaman konseptual matematika berbantuan AI. Produk
     ini membantu siswa menelusuri kemungkinan hambatan konsep prasyarat berdasarkan bukti
   respons matematika, mempelajari kembali konsep yang relevan melalui intervensi terkurasi, dan
    menilai penerapannya secara mandiri melalui pengerjaan ulang serta soal transfer. Alur tersebut
   menyatukan diagnosis, pembelajaran, dan validasi dalam satu pengalaman yang terarah.
Berbeda dari platform belajar matematika yang mengutamakan cakupan materi luas atau pemberian
   langkah penyelesaian secara umum, ReThink memprioritaskan kedalaman pemulihan pada
   konsep yang benar-benar didukung sistem. AI membantu  interpretasi bukti dalam batas
   pengetahuan dan pemeriksaan matematika yang terkurasi; diagnosis tidak menganggap setiap
    kesulitan sebagai conceptual blocker, dan keberhasilan pada konsep tertentu tidak disamakan
   dengan penguasaan seluruh topik. Struktur konsep memungkinkan perluasan bertahap tanpa
   mengklaim dukungan yang belum tersedia.

1.2 Visi Produk

Menjadikan kesulitan belajar matematika lebih mudah dipahami dan diatasi dengan membantu siswa
   menemukan kemungkinan kesenjangan konsep dasar yang relevan, memulihkan pemahamannya
    melalui pembelajaran terarah, dan menunjukkan kemampuan menerapkan konsep tersebut
   secara mandiri—tanpa menggantikan proses bernalar siswa.

1.3 Deskripsi Produk

Siswa memulai dari katalog topik matematika dan memilih topik yang mendukung diagnosis. Sistem
   mengevaluasi bukti dari respons matematika untuk mempertimbangkan apakah hambatan
   konsep yang didukung dapat dikonfirmasi, ditolak, atau masih belum pasti. Ketika bukti memadai,
   sistem merekomendasikan paket pembelajaran  terarah berupa penjelasan  visual, contoh
    beralasan, dan latihan terbimbing parsial. Hasil latihan mandiri dan soal transfer kemudian
   menjadi dasar status belajar pada konsep yang diperiksa.
```

## Original PDF Page 3

```text
Peta Belajar Hibrida menampilkan  relasi topik–konsep untuk eksplorasi, fokus yang didukung
    diagnosis, serta perkembangan yang didukung bukti validasi. Jika diagnosis tidak mengonfirmasi
   hambatan, siswa tetap dapat mengakses ulasan konsep opsional atau kembali mengeksplorasi
    topik, tanpa sistem menyatakan adanya kelemahan yang belum terbukti.

1.4 Nilai Utama Produk

Nilai ReThink terletak pada keterhubungan tiga aktivitas yang sering ditemui terpisah: diagnosis
   berbasis bukti, pemulihan pemahaman yang relevan, dan penilaian penerapan mandiri.
 Dimensi                                                  Nilai bagi pengguna
                                                  Menjelaskan   kemungkinan  hambatan  konsep
 Kejelasan —  mengetahui  apa  yang  perlu
                                                     berdasarkan bukti respons, bukan sekadar hasil
     ditangani
                                                    benar atau salah.
                                             Mengarahkan  perhatian pada satu konsep yang
                                                    didukung  dan  menyediakan  pembelajaran
 Fokus — memulihkan pemahaman yang relevan
                                                              terstruktur  tanpa  mengharuskan  peninjauan
                                                         materi yang terlalu luas.
                                               Menunjukkan   bukti  penerapan  konsep  tanpa
 Verifikasi —  mengetahui  apa  yang  dapat
                                                       bantuan, termasuk pada representasi soal yang
     diterapkan mandiri
                                                     berbeda.

Manfaat  tersebut  tetap bergantung pada cakupan  diagnosis,  intervensi, dan  validasi yang
   benar-benar tersedia. Jika bukti tidak cukup, sistem menyampaikan ketidakpastian secara
    transparan.

1.5 Diferensiasi Produk

Pembeda ReThink bukan klaim bahwa setiap teknik yang dipakai sepenuhnya baru, melainkan fokus
   pada pemulihan satu hambatan konsep tertentu dan integrasi diagnosis, intervensi, serta validasi
   pemahaman. Pendekatan ini adalah posisi produk yang dituju; keunggulannya atas alternatif lain
   belum dibuktikan secara empiris.
 Aspek pembanding                           Pendekatan ReThink
                                                 Mencari hambatan konsep yang secara matematis Titik awal
                                                          relevan terhadap kesulitan siswa
                                                            Sintesis bukti beberapa respons dengan kesimpulan
 Dasar rekomendasi
                                                  yang dibatasi dan dapat tidak pasti
                                                   Paket konsep terkurasi: visual → contoh beralasan Bentuk bantuan
                         → latihan terbimbing parsial
                                                Independent Retry dan Transfer Problem, bukan
 Cara menilai pemahaman
                                                        penyelesaian konten saja
                                                   Satu jalur utuh yang terverifikasi lebih diutamakan
 Cakupan                                                      daripada banyak topik yang belum didukung


1.6 Prinsip Utama Produk

●​ Bukti sebelum inferensi: Kesimpulan diagnosis dan status belajar harus bersandar pada bukti
   yang teramati; ketidakpastian adalah hasil yang sah.
```

## Original PDF Page 4

```text
●​ Pemulihan di atas keluasan konten: Kualitas dukungan konsep lebih penting daripada banyaknya
    topik yang terlihat.
●​ Penalaran aktif di atas pemberian jawaban: Bantuan tidak boleh menggantikan proses bernalar
   matematika siswa.
●​ Validasi sebelum  klaim pemahaman:  Menyelesaikan  pembelajaran  tidak otomatis  berarti
   memahami konsep.
●​ Otonomi  AI yang  dibatasi:  Interpretasi  AI  dibatasi pengetahuan  terkurasi, pemeriksaan
   matematika, dan pengaman keputusan; pembagian otoritas final masih OI-01.
●​ Struktur dapat  diperluas, cakupan tetap  terkendali: Konsep yang direpresentasikan tidak
   otomatis tersedia untuk diagnosis, intervensi, atau validasi.
```

## Original PDF Page 5

```text
02. Pernyataan Masalah & Pengguna Sasaran

2.1 Latar Belakang Masalah & Bukti

Ringkasan:  Kesulitan  matematika  dapat  berkaitan  dengan  konsep  prasyarat,  tetapi  tidak
   semuakesalahan berasal dari hambatan konsep. Literatur memberi dasar konseptual; survei
    eksploratif 12 siswa memberi indikasi awal berbasis persepsi, bukan pembuktian kausal.

2.1.1 Kesulitan matematika & pengetahuan prasyarat

Konsep matematika saling berkaitan. Kesulitan pada suatu topik dapat berasal dari keterbatasan
   konsep sebelumnya, bukan semata dari topik yang sedang dipelajari. Dari 12 responden survei
    eksploratif, 10 mengaku kadang atau sering kesulitan belajar matematika; 6 mengaitkan sebagian
    kesulitan dengan materi terdahulu yang belum dipahami. Temuan ini bersifat perseptual.

2.1.2 Kesulitan mengatribusikan kesalahan & memahami konsep

Jawaban keliru dapat memiliki beragam penyebab dan jawaban benar belum tentu menunjukkan
   penalaran konseptual. Dalam survei awal, 8/12 kesulitan memahami makna rumus atau konsep,
    7/12 kesulitan saat contoh berbeda dari soal, dan 5/12 dapat mengikuti contoh tetapi kesulitan
   mengerjakan mandiri. Perbedaan kompleksitas atau keakraban soal tetap merupakan penjelasan
    alternatif.

2.1.3 Batas bukti

Survei berskala kecil, tidak representatif, dan menggunakan laporan diri—terutama siswa kelas XI–XII.
    Hasilnya tidak menetapkan prevalensi pada populasi SMA, membuktikan conceptual blocker
   secara objektif, atau menunjukkan efektivitas ReThink. Wawancara dan observasi pengerjaan
    soal diperlukan untuk memperkuat pemahaman penyebab kesulitan.

2.2 Rumusan Masalah Inti

Ringkasan: Ketika siswa kesulitan pada suatu topik, mereka mungkin tidak tahu apakah kesulitan
   tersebut terkait kesenjangan konsep, materi mana yang perlu dipulihkan, dan apakah mereka
   sudah mampu menerapkannya secara mandiri.
 Dimensi masalah                                 Penjelasan
                                                  Siswa dapat menyadari kesulitan tanpa mengetahui
 Sumber kesulitan belum jelas
                                                             kontribusi konsep prasyarat atau faktor lain.
                                                Bantuan yang tersedia dapat menjelaskan prosedur
 Arah pemulihan belum terarah                                                    tanpa menjangkau pemahaman yang relevan.
                                                   Mengikuti contoh  tidak membuktikan penerapan
 Pemahaman mandiri belum pasti                    konsep tanpa bantuan  atau  di bentuk  soal
                                                     berbeda.


2.3 Pengguna Sasaran & Segmentasi

Ringkasan: Sasaran awal adalah siswa SMA yang kesulitan memahami atau menerapkan matematika,
   terutama untuk konteks belajar mandiri. Definisi pengguna dan segmentasi masih bersifat
   sementara dan membutuhkan validasi.
```

## Original PDF Page 6

```text
2.3.1 Pengguna utama

Siswa SMA yang mengalami kesulitan pada topik matematika tertentu dan berpotensi terbantu oleh
   dukungan pemulihan konsep secara mandiri. Mereka tidak harus lebih dulu memahami penyebab
    kesulitan tersebut.

2.3.2 Fokus riset awal

Riset awal mencakup kelas X–XII dengan perhatian pada XI–XII; 11 dari 12 responden awal berasal
    dari kelas XI–XII. Aljabar dipilih sebagai domain pengembangan MVP, bukan karena terbukti
   menjadi kesulitan paling umum.

2.3.3 Dimensi segmentasi sementara

 Dimensi                                      Peran
                                                     Frekuensi  dan  karakter  tantangan  memahami Kesulitan belajar
                                                 konsep atau menerapkan matematika.
                                               Cara mencari, memakai, atau menghindari bantuan
 Perilaku mencari bantuan                                                         saat kesulitan.
                                                      Tingkat   kekhususan   siswa   mengenali   dan Kesadaran masalah (atribut tambahan)
                                                     menjelaskan kesulitannya.

Dimensi tersebut belum membentuk segmen yang telah tervalidasi atau eksklusif satu sama lain.

2.4 Konteks Penggunaan & Perilaku Saat Ini

Ringkasan: Konteks potensial mencakup tertinggal pelajaran maupun menemui soal yang sulit.
    Perilaku mencari bantuan beragam dan tidak menunjukkan secara otomatis preferensi terhadap
   diagnosis berbantuan AI.

2.4.1 Situasi belajar dan pemicu

Konteks awal meliputi kesulitan mengikuti pelajaran kelas dan kesulitan menyelesaikan soal spesifik.
   Pemicu potensial mencakup tidak memahami penjelasan, tugas matematika, persiapan asesmen,
   atau menyadari konsep terdahulu belum kuat; tingkat kepentingan relatifnya belum diketahui.

2.4.2 Perilaku bantuan belajar

Dalam survei 12 siswa, 10 melaporkan bantuan guru/teman/keluarga, 8 materi tertulis atau video, 7
    asisten AI, 6 mencoba secara mandiri, sedangkan les dan melewati soal masing-masing 2.
   Penggunaan  AI  tidak  membuktikan  kepercayaan  terhadap  diagnosis  AI  atau kemauan
   menggunakan ReThink.

2.4.3 Kondisi belajar mandiri

Enam responden melaporkan sekitar 15–30 menit belajar mandiri; tiga tidak memiliki periode tetap.
   Data ini belum menetapkan durasi sesi ReThink. Belajar mandiri berarti mengambil inisiatif, bukan
    belajar tanpa guru atau bantuan lain.
```

## Original PDF Page 7

```text
2.5 Kebutuhan yang Belum Terpenuhi & Peluang

Ringkasan: Ada indikasi kebutuhan kejelasan arah belajar, bantuan yang relevan secara konseptual,
   dan bukti penerapan mandiri. Belum ada bukti yang cukup mengenai permintaan terhadap
   ReThink atau keunggulannya dibanding alternatif.
 Potensi kebutuhan                              Batas interpretasi
                                                  Siswa mungkin membutuhkan penjelasan konsep
 Kejelasan kesenjangan belajar                   mana yang relevan; penyebab kesulitan tidak
                                                    dapat disimpulkan hanya dari persepsi.
                                                Bantuan  perlu  menjelaskan  alasan  matematika;
 Bantuan yang relevan secara konseptual                kesulitan dapat pula disebabkan kompleksitas
                                                       atau konteks soal.
                                                  Siswa mungkin perlu tahu kemampuannya tanpa
 Bukti penerapan mandiri                              bantuan; belum terbukti bahwa mereka bersedia
                                                  melakukan asesmen tambahan.

Peluang produk adalah memberi pengalaman pemulihan yang lebih terarah saat konsep prasyarat
  memang relevan. Peluang tersebut masih hipotesis produk, bukan bukti demand atau efektivitas.

2.6 Asumsi Kritis & Kesenjangan Riset

Ringkasan: Enam asumsi A1–A6 memandu riset lanjutan; semuanya perlu dibaca sesuai kualitas bukti,
   bukan sebagai karakteristik pengguna atau hasil produk yang telah terverifikasi.
 ID                          Asumsi                          Status bukti
                                Kesenjangan            prasyarat  Didukung  literatur dan  indikasi
 A1                                     berkontribusi pada sebagian      laporan      diri;    konfirmasi
                                           kesulitan matematika.                objektif tertunda.
                                 Sebagian  siswa  sulit mengenali                                                                                 Indikasi survei terbatas; evaluasi A2                              sumber  masalah  dan  arah
                                                                                   objektif tertunda.
                                                belajar.
                                 Sebagian     kesulitan    belum
                                                                                 Indikasi   friksi;  persistensi  dan                                          terselesaikan          setelah A3                                                             kecukupan  alternatif  belum                                memakai   bantuan   yang
                                                                                     terbukti.                                            tersedia.
                                 Siswa memahami dan menerima
 A4                              pengalaman        diagnosis  Belum diuji langsung.
                                           terarah.
                                 Pemulihan     terarah     dapat                                                                         Hipotesis  pedagogis;  efektivitas A5                                meningkatkan    penerapan
                                                                      ReThink belum terbukti.
                                  konsep secara mandiri.
                                 Siswa  menilai  bukti  penerapan   Indikasi      tidak      langsung;
 A6                                   mandiri   sebagai   informasi     penerimaan   validasi  belum
                                  yang berguna.                              diuji.

Prioritas   riset:  observasi   kesulitan  matematika,  kebiasaan  mencari  bantuan,  pengujian
   pemahaman/penerimaan pengalaman produk, dan evaluasi hasil belajar secara terpisah. Temuan
    riset tidak otomatis mengubah keputusan produk tanpa peninjauan.
```

## Original PDF Page 8

```text
03. Tujuan Produk & Ukuran Keberhasilan

3.1 Tujuan Produk & Hasil yang Diharapkan

Tujuan ReThink adalah membantu siswa memperoleh arah pemulihan berbasis bukti, mempelajari
   konsep secara terarah, dan memahami apa yang dapat diterapkan tanpa bantuan. Tujuan di
   bawah adalah hasil yang dituju, bukan bukti efektivitas yang sudah dicapai.
 Tujuan                          Penjelasan                         Hasil yang diharapkan
                              Menerjemahkan   bukti  respons  Siswa memahami  kemungkinan
 G1 — Arah pemulihan berbasis      menjadi informasi hambatan      kesulitan  yang  relevan dan
     bukti                          konsep    yang     terukur,       pilihan    kelanjutan    yang
                                    termasuk hasil belum pasti.          tersedia.
                              Memberikan       pembelajaran                                                                  Siswa memperoleh kesempatan
                                  konsep  yang  fokus  sambil G2 — Pemulihan konsep terarah                                  memperkuat pemahaman dan
                                 mempertahankan  penalaran                                                               menerapkan konsep mandiri.
                                                     aktif.
                               Memeriksa   penerapan   tanpa  Siswa    memperoleh     bukti
 G3 —  Evaluasi  pemahaman     bantuan   dan   pengenalan     pemahaman dalam cakupan
     berbasis bukti                      struktur  pada  representasi     asesmen,          termasuk
                                                      lain.                            kebutuhan penguatan.
                                                                  Siswa     dapat     menavigasi
 G4 —  Pengalaman   belajar  Memastikan tujuan diagnosis, alur                                                               pengalaman dan menafsirkan
    mandiri    yang    dapat       belajar, dan batas  arti  hasil                                                                                         hasil  tanpa  pendampingan
    dipahami                           bisa dipahami.                                                                       terus-menerus.


3.2 Definisi Keberhasilan MVP

MVP menargetkan satu jalur pemulihan utuh: topik SPL dengan Distributive Property sebagai blocker
   yang didukung. Keberhasilan fungsional dan  validasi pengalaman pengguna  dinilai secara
    terpisah.
 Kelompok             Kondisi                  Makna penerimaan
                                                        Pemilihan  topik → diagnosis → pembelajaran
                     SC1  —   Jalur   Pemulihan      terarah → validasi mandiri → hasil tingkat
 Fungsional                         Lengkap                      blocker berjalan end-to-end pada skenario
                                                    yang didukung.
                                                       Diagnosis dan validasi sesuai bukti matematika;                    SC2 — Integritas Keputusan Fungsional                                                   tidak    mengonfirmasi    blocker    atau                             Berbasis Bukti
                                              pemahaman di luar dukungan.
                                                      Confirmed/Rejected/Uncertain ditangani secara
 Fungsional          SC3 — Kelanjutan Sesuai Hasil      berbeda; completion belajar tidak disamakan
                                                  dengan pemahaman.
                   SC4   —     Pengalaman  Pengguna memahami diagnosis, alur, hasil, dan Pengalaman
                           Pemulihan  yang  Dapat      keterbatasannya;   dinilai  melalui  pengujian
    pengguna                          Dipahami                  pengguna terpisah.

Interpretasi: SC1–SC3 baru dapat disebut terverifikasi bila semua skenario fungsional wajib di
   cakupan MVP telah dijalankan dan memenuhi kriterianya. Skenario gagal, belum diuji, atau belum
    memiliki expected behavior tidak dapat dianggap lulus. SC4 dilaporkan terpisah; keberhasilan
    fungsional tidak membuktikan usability atau peningkatan hasil belajar.
```

## Original PDF Page 9

```text
3.3 Dimensi & Metrik Keberhasilan

 Dimensi                        Metrik utama                     Indikator pendukung / batas
                                                                   Catat jumlah lulus, gagal, belum
                                    Tingkat kelulusan skenario wajib         diuji;  tingkat kelulusan  tidak
 D1 — Kelengkapan fungsional
                                  yang sudah dijalankan             boleh  menutupi  coverage
                                                                 yang belum lengkap.
                                                                         Insiden konfirmasi blocker tanpa
                                                                                     bukti, penanganan uncertain,
                                  Kesesuaian  keputusan  dengan D2 — Integritas keputusan                                            ketepatan   status    validasi;                                     kasus acuan yang ditinjau
                                                                bukan akurasi pada populasi
                                                         umum.
                                                                Laporkan    terpisah    navigasi,
 D3   —      Usability    &  Keberhasilan   tugas    inti  dan      kesalahan                  tafsir
     interpretabilitas              pemahaman hasil                    diagnosis/status,   serta   isu
                                                                                       usability kritis.
                                                                   Skor cakupan validasi; perubahan
                                Penerapan mandiri dan performa      pre/post  hanya   eksploratif D4 — Bukti hasil belajar                                          transfer                       dengan desain yang tepat dan
                                                                                tidak otomatis kausal.

Pengukuran  harus  menyatakan  cakupan  soal,  kasus,  dan  peserta;  kegagalan  kritis  tidak
   disembunyikan dalam rata-rata. Ambang numerik, metode rinci, dan protokol pengujian tidak
   ditetapkan tanpa justifikasi.

3.4 Batas Keberhasilan & Non-Tujuan

Status Confirmed menunjukkan dukungan bukti atas hambatan konsep yang diperiksa, bukan sebab
    pasti seluruh kesulitan. Understood menunjukkan terpenuhinya kondisi validasi pada tingkat
    blocker, bukan penguasaan  SPL,  retensi jangka panjang, atau  seluruh matematika.  Hasil
    fungsional, usability, dan efektivitas belajar memerlukan bukti berbeda.
 Tidak menjadi syarat MVP                        Penjelasan
                                                     Tidak semua konsep memiliki diagnosis atau paket
 Cakupan kurikulum menyeluruh
                                                       pemulihan.
 Penguasaan penuh topik SPL                          Validasi dibatasi Distributive Property.
                                                     Tidak ada tracing beberapa lapis atau diagnosis per
 Pemulihan adaptif bertingkat                                                      kompetensi.
                                                     Tidak ada kewajiban mengukur pemahaman jangka Bukti retensi longitudinal                                                         panjang.
 Peningkatan matematika umum                    Tidak ada klaim dampak lintas topik/populasi.

Efektivitas pemulihan dalam konsep yang didukung tetap merupakan tujuan riset; pembuktiannya
    terpisah dari kelulusan fungsi MVP.
```

## Original PDF Page 10

```text
04. Cakupan Produk & Definisi MVP

4.1 Pernyataan Cakupan & Batas Produk

MVP ReThink menyediakan satu pengalaman lengkap pemulihan konseptual matematika berbasis
    bukti. Satu topik yang dapat memulai diagnosis adalah Sistem Persamaan Linear (SPL) dalam
    Aljabar; satu hambatan konseptual yang didukung secara utuh adalah Distributive Property,
   termasuk penerapannya secara langsung dan dalam SPL.
Alur: eksplorasi katalog/peta → asesmen diagnostik terarah → hasil diagnosis → pembelajaran
   terbimbing terkurasi jika terkonfirmasi (atau ulasan opsional tanpa klaim diagnosis) → validasi
    tingkat blocker untuk jalur confirmed yang memenuhi prasyarat. Keberadaan konsep di katalog
   atau peta tidak berarti tersedia diagnosis dan validasi.
 Prinsip batas produk                                Implikasi
                                                   Satu  jalur pemulihan lengkap, bukan semua topik
 Cakupan kemampuan terkendali                                                                            aktif.
                                                     Tidak menetapkan kelemahan  atau pemahaman Hasil dibatasi bukti
                                                 konsep yang belum diperiksa.
                                                           Relasi   konsep   reusable   tidak   mengaktifkan
 Siap diperluas secara konseptual
                                            kemampuan di luar MVP.


4.2 Cakupan Matematika & Diagnosis

4.2.1 Materi yang didukung

Distributive Property diperiksa pada  (a) manipulasi ekspresi  aljabar secara langsung dan (b)
   transformasi dalam soal SPL. Keduanya menambah bukti mengenai satu konsep yang sama,
   bukan diagnosis blocker tambahan.

4.2.2 Rancangan asesmen diagnostik

Terdapat tiga soal inti dan paling banyak satu probe kondisional, sehingga jumlah keseluruhan tidak
   melebihi empat soal. Contoh di bawah hanya ilustrasi rancangan, bukan butir final yang telah
    disetujui atau rubrik OPS-04.
 Soal                   Peran dan format       Contoh ilustratif        Batas interpretasi
                                                                       Pilih langkah yang tepat                                                                 Jawaban     benar/salah
                                                     untuk menyelesaikan
                         Performa   target   SPL;                                    sendiri  tidak cukup Q1                                                    sistem     dengan                                    pilihan ganda                                     untuk  menentukan
                                                           2(x+3)  dalam  salah
                                                                                          blocker.                                                         satu persamaan.
                                                                     Menunjukkan                              Aplikasi        prasyarat                                                     Uraikan 3(x + 2) menjadi      transformasi
 Q2                                 terisolasi;   jawaban
                                                    bentuk ekuivalen.           Distributive                            matematika singkat                                                                                      Property.
                                                                 Memberi           bukti
                                                    Jelaskan mengapa 2(x +
                          Alasan       konseptual;                                  eksplanatoris, bukan Q3                                                           3) = 2x + 6 dan bukan                               penjelasan bebas                                 sekadar   ketepatan
                                                      2x + 3.
                                                                                                          hasil.
```

## Original PDF Page 11

```text
Tunjukkan           letak
                                                         transformasi         Hanya    jika   terdapat                          Satu  procedural  trace                                                 pertama yang tidak     kekosongan    bukti Q4 (opsional)                atau     conceptual
                                                          setara        pada     yang           perlu
                           probe                                                        rangkaian   langkah        diklarifikasi.
                                                  yang disediakan.

Kategori bukti yang dapat digunakan meliputi hasil jawaban, transformasi matematika yang terlihat,
   dan penjelasan siswa; tidak seluruh kategori harus muncul di setiap soal. AI dapat membantu
   menafsirkan dan menyintesiskan bukti, tetapi pembagian otoritas keputusan final masih OI-01.

4.2.3 Hasil diagnosis dan batasnya

 Hasil                                   Makna
                                                        Bukti  cukup  mendukung   adanya  hambatan
 Confirmed                                                               Distributive Property sesuai aturan diagnosis.
                                                        Bukti cukup tidak mendukung atau bertentangan
 Rejected                                                dengan hambatan yang diperiksa.
                                                        Bukti kurang, ambigu, atau tidak konsisten untuk Uncertain
                                                    menyimpulkan.

Satu jawaban salah tidak otomatis mengonfirmasi blocker; jawaban benar atau hasil non-confirmed
    tidak berarti tidak ada kesulitan lain. Pemetaan pola semua-jawaban-benar tetap OI-03 Open.

4.3 Kemampuan Produk yang Termasuk MVP

 Kemampuan                                Tanggung jawab inti
                                                   Katalog matematika, pemilihan SPL untuk diagnosis, C1 — Entri Belajar & Penemuan Topik                                                dan penanda dukungan fitur yang tersedia.
                                                     Explore   (orientasi),  Focus  (berdasarkan   bukti
 C2 — Peta Belajar Hibrida                                 diagnosis), Progress (berdasarkan hasil validasi);
                                                             tidak membuat diagnosis independen.
                                            Q1–Q3, maksimal satu Q4, sintesis bukti, keluaran
 C3 — Diagnosis Terarah & Hasil                        Confirmed/Rejected/Uncertain, dan kelanjutan
                                                  yang sesuai.
                                                   Satu paket Distributive Property: penjelasan visual →
                                                   contoh beralasan → latihan parsial aktif; bisa
 C4 — Pembelajaran Terbimbing Terarah                                                     untuk  recovery  terkonfirmasi  atau  ulasan
                                                             opsional.
                                                Independent Retry, lalu Transfer Problem hanya jika
 C5 — Validasi Pengetahuan & Hasil                       retry berhasil; menetapkan status blocker sesuai
                                                                  bukti.

 Independent Retry               Transfer Problem                Status belajar
 Berhasil                             Berhasil                        Understood
 Berhasil                        Gagal                            Procedural Only
 Gagal                             Tidak diberikan                 Needs Reinforcement
```

## Original PDF Page 12

```text
Jika retry gagal, pengguna diarahkan kembali ke paket belajar yang sama, tanpa diagnosis ulang
   otomatis atau remediasi adaptif. Kelayakan validasi sesudah Optional Concept Review tetap
   OI-02 Open.

4.4 Eksklusi, Landasan Masa Depan & Ketergantungan

 Kelompok                                    Ketentuan
                                                     Tidak      mencakup       kurikulum        luas,
                                                            diagnosis/adaptivitas  tingkat  lanjut,  orkestrasi
 E1–E5 — Eksklusi                                           instruksional  dinamis,  asesmen  longitudinal
                                                       komprehensif,  atau  fitur  tutor  chatbot/LMS
                                                            generik.
 F1 — Relasi konsep reusable                   Hubungan topik–konsep dapat digunakan ulang.
                                                    Representasi konsep dipisahkan dari kemampuan F2 — Batas dukungan eksplisit                                                                            aktif.
                                                              Definisi dan paket untuk diagnosis,  belajar, serta
 F3 — Pemisahan definisi asesmen/pemulihan                                                                  validasi tidak saling disamakan.
                                                      Informasi pembelajar hanya didasarkan pada bukti F4 — Status siswa dibatasi bukti                                                  yang terkait.

Keputusan terbuka: OI-01 (metodologi/otoritas AI), OI-02 (validasi setelah ulasan opsional), OI-03
   (kasus seluruh jawaban benar). Detail OPS-01–OPS-05 tetap spesifikasi operasional tertunda,
   bukan tambahan fitur MVP.
```

## Original PDF Page 13

```text
05. Ringkasan Persyaratan Produk

Dokumen persyaratan produk dipisahkan agar daftar kebutuhan fungsional yang rinci tetap mudah
    dicari, dikelola, dan diverifikasi tanpa membuat PRD utama terlalu panjang.
 Kelompok                    Jumlah requirement   Cakupan
 C1  —   Entri   belajar  dan                           Katalog,  topik yang didukung, pembukaan                              5    penemuan topik                                           diagnosis
                                                                Explore, Focus, Progress dan kejujuran status C2 — Peta Belajar Hibrida        5
                                                                   bukti
 C3  —  Asesmen  &   hasil                      Rancangan  soal,  evaluasi  bukti,  keluaran                                10     diagnostik                                                   diagnosis, kelanjutan
 C4 — Pembelajaran terbimbing   8                     Urutan konten, partisipasi aktif, kelanjutan
 C5 — Validasi & hasil belajar      8                         Retry, transfer, dan status belajar sesuai bukti
                                                                   Integritas konteks, transisi, dan representasi Lintas kemampuan              3                                                                  status
                                                   Approved functional requirements pada PRD TOTAL                         39                                                                  v1.0

Ketentuan lintas kemampuan IP-01–IP-02 dan skenario verifikasi awal V-X-01–V-X-08 tetap berlaku.
   Persyaratan pada dokumen terpisah tetap menjadi referensi otoritatif setelah ditautkan dan
    diperiksa konsistensinya dengan baseline.
LINK DOKUMEN PRODUCT REQUIREMENTS LENGKAP:   ReThink Documentation


07. Arsitektur Konseptual Produk & Skalabilitas

7.1 Batas Arsitektur Konseptual

Arsitektur ReThink membedakan secara logis lima domain informasi. Pemisahan ini bukan keputusan
   mengenai tabel database, layanan, atau teknologi tertentu.
 Domain logis                                   Fungsi
                                                          Topik,  konsep,  dan  hubungan  prasyarat  yang Struktur Pengetahuan Konseptual
                                                                  dikurasi.
                                                            Butir  diagnosis,  bukti  yang  dinilai, dan  kriteria Definisi Asesmen                                                                evaluasi.
 Konten Instruksional & Validasi                      Penjelasan, contoh, latihan, serta item retry/transfer.
                                               Penentuan dukungan diagnosis, belajar, atau validasi Ketersediaan Kemampuan                                                     untuk setiap konsep.
                                                            Hasil     diagnosis      individual,     penyelesaian
 Bukti Pembelajar                                                       pembelajaran, dan status validasi.

AR-01 — Pemisahan Domain Informasi Logis: definisi konsep yang reusable, konfigurasi kemampuan,
   dan catatan bukti siswa diperlakukan sebagai jenis informasi berbeda.

7.2 Konten Modular & Aktivasi Kemampuan

 Kondisi konsep                                     Interpretasi
                                             Konsep tercatat dalam struktur konseptual; tidak Direpresentasikan
                                                               berarti tersedia asesmen.
```

## Original PDF Page 14

```text
Terdapat definisi atau paket yang terasosiasi; belum Dikonfigurasi                                                         tentu tersedia bagi siswa.
                                        Kemampuan   tertentu   telah   diaktifkan  secara
 Didukung Aktif                                                                    eksplisit dalam cakupan produk.

AR-02 — Konfigurasi Kemampuan Independen: cakupan diagnosis, pembelajaran, dan validasi dapat
    diperluas secara terpisah tanpa menganggap semuanya otomatis tersedia ketika satu materi
   ditambahkan.

7.3 Prinsip Skalabilitas & Ekstensi

AR-03 — Ekstensi Terkendali dan Berbasis Peninjauan Mutu: hubungan konsep, item asesmen,
    materi, dan kriteria penilaian yang baru harus ditinjau sebelum kemampuan diaktifkan. Prinsip
    skala di sini adalah keluwesan struktur dan keterpeliharaan, bukan bukti kapasitas produksi.
Prinsip tambahan: hubungan konsep reusable dan definisi kemampuan dapat diekstensikan secara
    terpisah. Ini bukan komitmen membangun diagnosis banyak blocker, tracing adaptif, generasi
    pelajaran dinamis, atau konfigurasi teknologi fisik dalam MVP.
```

## Original PDF Page 15

```text
08. Roadmap Produk

8.1 Prioritas Pengembangan Produk

Urutan berikut adalah prioritas perencanaan, bukan gerbang berurutan yang kaku. Pekerjaan dapat
    dilakukan paralel jika ketergantungannya memungkinkan.
 Prioritas                      Fokus                         Luaran yang diharapkan
                                          Entri  katalog, hubungan konsep                                                                                  Entri    belajar   dan    struktur P1 — Fondasi MVP                       terkurasi,         dukungan
                                                                        konseptual yang berfungsi.                                kemampuan, konteks belajar.
                          Q1–Q4  sesuai  batas,  evaluasi                                                             Pengalaman diagnosis SPL untuk
 P2 — Diagnosis                           bukti,   probing,   hasil  dan                                                                                   Distributive Property.                                           kelanjutan.
                                                                   Paket  pembelajaran  Distributive                                  Paket penjelasan  visual, contoh, P3 — Pembelajaran terbimbing                                         Property    yang     dapat
                                             latihan aktif, penyelesaian.                                                                        digunakan.
                                        Retry, transfer kondisional, status  Jalur pemulihan terintegrasi pada
 P4 — Validasi & integrasi                                                belajar, Peta Belajar, transisi.         tingkat blocker.
                                   Pengujian    fungsi,   konsistensi  Bukti    verifikasi,   keterbatasan P5   —      Verifikasi    &
                                     matematika,         integritas       tercatat, kandidat MVP yang    penyempurnaan                                      keputusan, usability.                  diperbaiki.
 Pasca-MVP   —     ekstensi  Kajian penambahan konsep/paket  Usulan perluasan terpisah; bukan
     terkendali                            terkurasi.                      komitmen rilis MVP.


8.2 Ketergantungan & Batas Rilis

 Ketergantungan      Dampak terhadap pekerjaan
 OI-01                 Menyelaraskan otoritas interpretasi dan keputusan diagnosis terutama P2.
 OI-02               Menetapkan kelayakan validasi setelah ulasan opsional pada P3–P5.
 OI-03               Menetapkan pemetaan respons semua benar pada P2 dan integrasi berikutnya.
 OPS-01/02           Mekanisme umpan balik dan kriteria penyelesaian latihan terbimbing.
 OPS-03              Penanganan respons validasi tidak lengkap, tak terinterpretasi, atau ekuivalen.
 OPS-04                  Butir matematika, solusi acuan, dan rubrik yang ditinjau.
 OPS-05               Desain transisi dan konsistensi keadaan lintas kemampuan.

Kesiapan MVP bergantung pada implementasi dan verifikasi persyaratan yang berlaku, bukan hanya
   penyelesaian workstream atau demo. SC1–SC3 diverifikasi melalui skenario fungsional; SC4
    melalui evaluasi pengguna terpisah. Tidak ada tanggal  rilis, durasi sprint, atau janji efektivitas
    belajar yang ditetapkan dalam peta jalan ini.
```

## Original PDF Page 16

```text
09. Asumsi, Risiko & Ketergantungan

9.1 Risiko Kritis MVP & Mitigasi

Risiko berikut adalah potensi kegagalan, bukan cacat implementasi yang sudah terbukti. Mitigasi
    tidak menambah kemampuan MVP.
 ID                  Risiko / dampak                                  Mitigasi
                                                                                   Verifikasi    bukti    lintas    soal,                        Inferensi   diagnosis  tanpa  dukungan   bukti R-01                                                      pengaman  matematika dan
                      menimbulkan konfirmasi blocker salah.                                                                        penyelesaian OI-01.
                        Soal, contoh, atau rubrik tidak valid menghasilkan  Tinjauan matematis konten, solusi R-02
                              hasil yang tidak andal.                         acuan dan OPS-04.
                                                                                   Verifikasi  respons  siswa   aktif, R-03               Latihan menjadi pasif atau completion keliru.
                                                        umpan balik dan OPS-01/02.
                                                                                            Uji evaluasi jawaban dan aturan
 R-04                Penilaian validasi atau pemetaan status salah.            tiga  status  secara  terpisah;
                                                                 OPS-03.
                   Konteks atau keadaan antar kemampuan tidak   Uji    transisi   dan    integritas
 R-05                          konsisten.                                     FR-X-01–03; OPS-05.
                                                                    Pisahkan  pengujian  fungsional,
                    Implementasi    dipakai    untuk   mengklaim R-06                                                                                    usability, dan penelitian hasil                             usability/efektivitas tanpa bukti.                                                                                         belajar.

Tidak ada  penilaian  probabilitas  atau  tingkat keparahan numerik tanpa  bukti. Penyelesaian
   implementasi tidak otomatis menutup risiko.

9.2 Tata Kelola Asumsi & Ketergantungan

A1–A6 mempertahankan status validasi di Bagian 02.6; keputusan OI dan spesifikasi OPS tetap
    dikelola melalui register dan ketergantungan Bagian 08.2. Bukti perlu  dinilai sesuai batas
   metodenya, perubahan keputusan harus dapat ditelusuri, dan risiko yang masih menyisakan
    ketidakpastian tidak dinyatakan selesai tanpa bukti yang relevan.
Ketergantungan hanya membatasi persyaratan dan skenario penerimaan yang terkait; keputusan
   yang belum selesai tidak otomatis membatalkan persyaratan lain yang sudah disetujui.
```

## Original PDF Page 17

```text
10. Prinsip Penerimaan Produk & Tata Kelola PRD

10.1 Prinsip Penerimaan Produk

Penerimaan produk  menilai apakah implementasi MVP memenuhi persyaratan yang  disetujui
   berdasarkan bukti verifikasi yang terdokumentasi dan dapat ditinjau. Persetujuan dokumen,
    selesainya pengembangan, atau demonstrasi alur tunggal tidak sama dengan penerimaan
   implementasi.
 ID                                         Prinsip penerimaan
                                         Suatu  requirement  atau  skenario hanya dapat dianggap AP-01 — Berbasis bukti                                                        terverifikasi jika bukti memenuhi kondisi verifikasinya.
                                     Bedakan kondisi terpenuhi, gagal, dan belum terverifikasi/tidak
 AP-02 — Hasil verifikasi eksplisit                                           dapat dinilai.
                                                Perilaku yang membutuhkan keputusan atau kriteria tertunda
 AP-03     —        Penerimaan                                        belum dapat dinyatakan sepenuhnya  terverifikasi;  hasil    memperhitungkan ketergantungan                                             untuk perilaku yang tak terkait tetap berlaku.
                                        Kesimpulan  penerimaan   ditautkan  pada  requirements, AP-04 — Ketertelusuran bukti
                                                   skenario, dan bukti pendukung.
                                       Penerimaan fungsional bukan bukti efektivitas belajar, retensi,
 AP-05 — Klaim penerimaan dibatasi                                              atau penguasaan matematika luas.

Bagian ini tidak menambah ambang penerimaan numerik, metode pengujian, atau FR baru. SC tetap
   merujuk Bagian 03, sedangkan verifikasi persyaratan merujuk dokumen Product Requirements
    terpisah.

10.2 Penutupan PRD & Tata Kelola Perubahan

PRD merupakan baseline definisi produk yang menjadi rujukan untuk desain produk, desain teknis,
   pengembangan konten matematika, dan verifikasi. Persetujuan PRD tidak membuktikan bahwa
   produk telah dibangun atau diterima.
 ID                                      Prinsip tata kelola
                                      Bagian yang  disetujui menjadi rujukan cakupan dan perilaku
 PG-01 — Otoritas baseline                                           produk.
                                    Keputusan dan spesifikasi yang belum selesai hanya ditutup PG-02 — Item terbuka tetap terbuka                                               melalui review terpisah.
                                    Perubahan material pada scope, diagnosis, status siswa, atau PG-03 — Pengendalian perubahan
                                               kondisi  keberhasilan  memerlukan  analisis dampak  dan     perilaku                                              approval.
 PG-04 —  Keselarasan  spesifikasi  Desain produk, teknis, dan konten harus sejalan dengan approved
    turunan                               requirements.
                                    Perubahan yang disetujui menyebut baseline, desain, dan kriteria
 PG-05 — Revisi dapat ditelusuri                                                      verifikasi terdampak.

Penutupan  baseline  definisi  produk  tidak  menutup  OI-01–OI-03,  OPS-01–OPS-05,  tidak
   memastikan  kelengkapan  implementasi, dan  tidak menetapkan  efektivitas  belajar.  Revisi
    substantif sesudah persetujuan harus memperoleh otorisasi eksplisit.
```

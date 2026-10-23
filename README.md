<div align="center">
  <img src="frontend/Rethink/Resources/Assets.xcassets/AppLogo.imageset/logo.png" width="88" alt="Logo Rethink" />
  <h1>Rethink</h1>
  <p><strong>Temukan hambatannya. Pahami konsepnya. Coba secara mandiri.</strong></p>
  <p>Aplikasi iOS untuk pemulihan pemahaman konsep matematika berbasis bukti.</p>
  <p>
    <img src="https://img.shields.io/badge/iOS-26%2B-111827?style=flat-square&amp;logo=apple&amp;logoColor=white" alt="iOS 26 ke atas" />
    <img src="https://img.shields.io/badge/SwiftUI-MVVM-F05138?style=flat-square&amp;logo=swift&amp;logoColor=white" alt="SwiftUI dan MVVM" />
    <img src="https://img.shields.io/badge/Next.js-16.4.2-111827?style=flat-square&amp;logo=nextdotjs&amp;logoColor=white" alt="Next.js 16.4.2" />
    <img src="https://img.shields.io/badge/Supabase-PostgreSQL-287D59?style=flat-square&amp;logo=supabase&amp;logoColor=white" alt="Supabase PostgreSQL" />
    <img src="https://img.shields.io/badge/Status-In%20Development-806A32?style=flat-square" alt="Status dalam pengembangan" />
  </p>
  <p><a href="#getting-started">Getting Started</a> · <a href="#ios-frontend">Frontend</a> · <a href="#backend-recovery-api">Backend</a> · <a href="#integration-status">Integration Status</a></p>
</div>

---

Rethink membantu siswa memeriksa kemungkinan hambatan konsep saat mengerjakan **Sistem Persamaan Linear (SPL)**, mempelajari konsep melalui materi terkurasi, lalu mencoba menerapkannya tanpa bantuan. Fokus pemulihan lengkap MVP adalah **Sifat Distributif**. Diagnosis, penyelesaian materi, pemahaman konsep, dan hasil tes SPL merupakan informasi yang berbeda.

Repository ini memuat **frontend SwiftUI**, **backend HTTP Next.js**, serta dokumentasi produk. Backend bukan website pembelajaran. Beberapa layar frontend masih berupa prototipe lokal dan belum menggunakan penilaian server.

## Getting Started

| Tujuan | Buka |
|---|---|
| 📱 Mengembangkan aplikasi iOS | [frontend/Rethink.xcodeproj](frontend/Rethink.xcodeproj) dan [panduan frontend](frontend/README.md) |
| ⚙️ Menjalankan API lokal | [panduan backend](backend/README.md) dan [konfigurasi Supabase/Vercel](backend/SETUP.md) |
| 🔗 Menghubungkan alur PRD terbaru | [kontrak HTTP v3](backend/docs/API-V3.md) |
| 📚 Memahami requirement produk | [indeks PRD](docs/prd/README.md) |
| Memahami fitur lokal yang belum terintegrasi | [status dan batas integrasi](#integration-status) |

**Prasyarat:** macOS dan Xcode dengan SDK iOS 26 untuk frontend; Node.js **24.x**, npm, serta proyek Supabase dengan Anonymous Sign-Ins untuk backend. Vercel diperlukan hanya untuk deployment.

```sh
git clone https://github.com/pisciva/Rethink.git
cd Rethink
```

Frontend dan backend memiliki konfigurasi masing-masing. Tidak ada perintah install atau development server bersama di root.

## Learning Experience

### Backend Learning Flow

```text
Pilih SPL → Diagnosis 10 soal → Hasil per konsep
                                  │
                 ┌────────────────┴────────────────┐
                 ↓                                 ↓
       Pilih pembelajaran tersedia          Tes akhir SPL
       Visual → Contoh → Latihan            5 soal · lulus ≥ 3/5
                 ↓                          Ulang jika belum lulus
       Validasi konsep jika memenuhi syarat
       Mandiri → Transfer jika berhasil
                 ↓
       Hasil konsep dan Learning Map
```

- Diagnosis HTTP v3 melakukan screening beberapa kandidat konsep dengan bukti per konsep.
- Hanya distributif yang memiliki paket pembelajaran dan validasi konsep lengkap.
- Satu follow-up distributif dapat diberikan setelah 10 soal bila kondisi aturan implementasi terpenuhi.
- Pengguna boleh mengikuti tes akhir SPL setelah diagnosis tanpa menyelesaikan seluruh konsep yang direkomendasikan.
- Validasi konsep menghasilkan **Understood**, **Procedural Only**, atau **Needs Reinforcement**; hasil tes SPL tetap terpisah.
- Jawaban benar, pelajaran selesai, dan lulus tes topik tidak otomatis membuktikan penguasaan seluruh SPL.

### Integration Status

| Bagian | Kondisi kode saat ini | Batas |
|---|---|---|
| Beranda, profil, navigasi | SwiftUI, native tab bar, akses chatbot layar penuh | Nama/progres tertentu masih dummy untuk desain |
| Katalog kelas 10–12 | 37 materi lokal; hanya SPL dapat dibuka | Daftar ini bukan klaim 37 paket belajar tersedia di API |
| Pre-test dari katalog | 10 soal lokal, jawaban awal pilihan ganda, follow-up statis, audio sistem | Berbeda dari bank server; jawaban hanya dalam sesi; belum dikirim atau dinilai backend |
| Pilihan SPLDV/SPLTV | Halaman fokus tersedia; SPLTV terkunci | Kedalaman konten belum setara dengan seluruh cakupan materi |
| Chatbot mandiri | Balasan simulasi, Stop, chat baru, riwayat lokal | Tidak terhubung ke layanan AI; berbeda dari bantuan Socratic saat belajar |
| Alur recovery remote | `JourneyFlowView` + `JourneyStore` + `APIClient` | Endpoint dipilih melalui konfigurasi; bukan layar pre-test lokal |
| API v2 | Recovery kompatibel dengan client sebelumnya | Diagnosis Q1–Q3 dan maksimal satu Q4 |
| API v3 | Diagnosis Q1–Q10, hasil per konsep, hints, tes akhir SPL | Memakai bank/rules tersendiri yang disetujui untuk implementasi |
| Gamifikasi | Proyeksi hasil berbasis bukti di backend; sebagian indikator UI dummy | Progres aktivitas bukan persentase penguasaan konsep |

> **Penting:** mengaktifkan `RETHINK_PRD_V2=1` mengganti endpoint pada `APIClient`. Flag ini tidak mengubah `SPLPretestView` lokal menjadi asesmen server. Kedua jalur tersebut masih perlu diselaraskan.

## Repository Structure

```text
Rethink/
├── frontend/
│   ├── Rethink.xcodeproj/       # Project aplikasi iOS
│   ├── Package.swift           # Library/test harness DiagnosisCore
│   └── Rethink/
│       ├── App/                # Entry point dan konfigurasi
│       ├── Models/             # Data, kontrak, state per fitur
│       ├── ViewModels/         # State dan interaksi per fitur
│       ├── Views/              # Layar per fitur
│       ├── Services/           # Networking, auth, konten, audio, validasi
│       ├── Components/         # UI bersama dan renderer matematika
│       ├── Resources/          # Asset catalog, gambar, audio
│       ├── Config/             # Info.plist
│       ├── Tests/              # DiagnosisCoreTests
│       └── Reference/          # Referensi visual lokal
├── backend/
│   ├── app/api/                # Route HTTP health, v2, dan v3
│   ├── src/                    # Domain, use case, konten, infrastruktur
│   ├── supabase/migrations/    # SQL penyimpanan journey
│   ├── tests/                  # Unit, API, integritas, embedded PostgreSQL
│   ├── docs/                   # Kontrak API dan setup terkait
│   └── archive/                # Salinan lokal backend lama, bukan runtime aktif
├── docs/                       # PRD, desain, keputusan, catatan implementasi
├── .github/workflows/          # CI backend dan Swift
└── AGENTS.md                   # Pedoman kerja agen dalam repository
```

Cache seperti `.build`, `.swiftpm`, `node_modules`, dan `.next` bukan source aplikasi. `backend/archive/` dapat ada pada workspace lokal, tetapi tidak diperlukan untuk install, build, atau deployment backend aktif.

## iOS Frontend

### Technology & Architecture

| Bagian | Implementasi |
|---|---|
| UI | SwiftUI, target iOS 26.0, Liquid Glass pada kontrol terkait |
| Arsitektur | MVVM dengan subfolder berdasarkan fitur |
| State | `ObservableObject`, `@Published`, environment stores |
| HTTP | `URLSession`, JSON/Codable, async/await |
| Identitas | Supabase guest session melalui HTTP Auth API |
| Token | Keychain, dipisahkan berdasarkan proyek Supabase |
| Matematika | SwiftMath **1.7.3**, melalui Swift Package di project Xcode |
| Media | Asset catalog, PhotosUI, audio onboarding dan speech sistem |
| Test harness | Package `ReThinkDiagnosis`, target `DiagnosisCore` |

**Pembagian tanggung jawab:** View menampilkan UI; ViewModel mengelola state dan aksi; Service menangani I/O atau kebijakan yang dapat dipakai ulang; Model menyimpan struktur data. Penentuan hasil remote tetap milik backend, bukan animasi atau tombol UI.

File awal yang paling berguna:

- [RethinkApp.swift](frontend/Rethink/App/RethinkApp.swift): entry point dan preview.
- [ContentView.swift](frontend/Rethink/Views/App/ContentView.swift): onboarding, pemulihan sesi, tab, presentasi chat.
- [AppConfig.swift](frontend/Rethink/App/AppConfig.swift): URL, public config, feature flags.
- [APIClient.swift](frontend/Rethink/Services/Remote/APIClient.swift): endpoint dan command v2/v3.
- [AuthStore.swift](frontend/Rethink/ViewModels/Remote/AuthStore.swift): guest session dan refresh token.
- [JourneyStore.swift](frontend/Rethink/ViewModels/Remote/JourneyStore.swift): load/save, revision, pergantian identitas, kewajiban reload.

### Xcode Setup

1. Buka `frontend/Rethink.xcodeproj`; gunakan scheme **Rethink**.
2. Biarkan Xcode menyelesaikan dependency SwiftMath.
3. Pilih simulator iOS 26+ atau perangkat yang sesuai. Untuk perangkat fisik, atur signing team sendiri.
4. Atur environment di **Product → Scheme → Edit Scheme → Run → Arguments** bila perlu.

| Environment Swift | Fungsi | Default kode |
|---|---|---|
| `RETHINK_API_BASE_URL` | Base URL backend | `https://rethink-recovery-api.vercel.app` |
| `RETHINK_SUPABASE_URL` | URL Supabase yang sama dengan backend | Public project fallback di `AppConfig.swift` |
| `RETHINK_SUPABASE_PUBLISHABLE_KEY` | Public key Supabase | Public fallback di `AppConfig.swift` |
| `RETHINK_PRD_V2` | `1` memilih HTTP v3 | Tidak aktif; memakai HTTP v2 |
| `RETHINK_SKIP_ONBOARDING` | `0` untuk menguji onboarding pertama di DEBUG | DEBUG langsung ke Beranda; Release mengikuti completion |
| `RETHINK_REPLAY_ONBOARDING` | `1` mengulang onboarding | Tidak aktif |
| `RETHINK_ONBOARDING_PAGE` | Indeks slide untuk preview DEBUG | Tidak diatur |

Untuk simulator di Mac yang sama:

```dotenv
RETHINK_API_BASE_URL=http://localhost:3001
RETHINK_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
RETHINK_SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_KEY
RETHINK_PRD_V2=1
```

Perangkat fisik tidak dapat mengakses server Mac melalui `localhost`; gunakan HTTPS deployment atau alamat LAN yang diizinkan konfigurasi jaringan/ATS. Environment Run scheme bukan konfigurasi rilis produksi. Jangan masukkan Supabase secret key atau AI key ke frontend.

SwiftUI Canvas tersedia pada sejumlah view. Preview tetap membutuhkan kompilasi Xcode dan beberapa layar masih memerlukan environment store atau layanan akun.

## Backend Recovery API

### Technology & Structure

**Node.js 24.x · Next.js 16.4.2 · TypeScript · Supabase JS · PostgreSQL · Vercel AI Gateway**

React 19.2.8 tersedia sebagai dependency Next.js; backend aktif tidak menyediakan website React untuk pengguna.

| Folder | Tanggung jawab |
|---|---|
| `app/api/` | Route entrypoint; delegasi ke handler aplikasi |
| `src/content/` | Katalog, item recovery, versi konten, copy hasil |
| `src/domain/` | Matematika, evidence, diagnosis, belajar, validasi, map, snapshot |
| `src/application/` | Parsing command dan koordinasi aksi recovery |
| `src/infrastructure/` | Supabase, persistence, transport Gateway, interpretasi terbatas |
| `src/http/` | CORS, handler progress, pengakuan persistence |
| `src/prdv2/` | Bank, types, engine/event replay, handler PRD v2 melalui HTTP v3 |

### Local Setup

Dari root repository:

```sh
cd backend
npm ci
cp .env.example .env.local
```

Isi `.env.local`, aktifkan **Anonymous Sign-Ins** di Supabase, lalu terapkan [migration journey](backend/supabase/migrations/202610220001_spl_recovery_journeys.sql) pada proyek yang sama dengan aplikasi. Setelah konfigurasi siap:

```sh
npm run dev
```

API lokal menggunakan **port 3001**. `.env.local` dan credential hanya disimpan secara privat.

| Environment backend | Kebutuhan |
|---|---|
| `SUPABASE_URL` | Wajib untuk auth/persistence; cocok dengan frontend |
| `SUPABASE_PUBLISHABLE_KEY` | Public key proyek; alias lama `SUPABASE_ANON_KEY` didukung |
| `SUPABASE_SECRET_KEY` | Backend only; alias service-role didukung |
| `AI_GATEWAY_API_KEY` | Opsional untuk bantuan AI terbatas; deterministic fallback tersedia |
| `AI_GATEWAY_MODEL` | ID `provider/model`; default berada di `src/infrastructure/gateway.ts` |
| `ALLOWED_ORIGINS` | Daftar origin browser dipisahkan koma; native app tidak perlu Origin |

Bank PRD v2 saat ini memiliki `BANK_APPROVED = true`. Gate ini berada di source, bukan parameter yang boleh ditentukan client. Persetujuan implementasi tidak sama dengan validasi pedagogis instrumen.

### HTTP API

| Endpoint | Metode | Akses | Fungsi |
|---|---|---|---|
| `/` | GET | Publik | Identitas layanan; daftar endpoint root belum merinci seluruh v3 |
| `/api/health` | GET | Publik | Kehadiran konfigurasi, bukan jaminan koneksi DB/provider |
| `/api/v2/catalog` | GET | Publik | Katalog recovery kompatibel |
| `/api/v2/progress` | GET, POST | Bearer token | Journey recovery sebelumnya |
| `/api/v3/catalog` | GET | Publik | Capability dan cakupan screening PRD v2 |
| `/api/v3/progress` | GET, POST | Bearer token | Diagnosis 10 soal, pembelajaran, hints, validasi, tes SPL |

**PRD v2 adalah versi produk; HTTP v3 adalah versi kontrak API.** Detail payload dan semua aksi ada pada [API v2](backend/docs/API-V2.md) dan [API v3](backend/docs/API-V3.md).

Contoh memilih SPL melalui v3, dengan revision dari GET terakhir:

```json
{
  "action": "select-topic",
  "topicId": "spl",
  "expectedRevision": 0
}
```

Client mengirim `Authorization: Bearer <access_token>` dan `Content-Type: application/json`. Revision `0` hanya sesuai untuk journey baru; jangan menggunakannya ulang pada setiap command.

### State Integrity & AI Boundaries

- Backend memverifikasi identitas; client tidak boleh menentukan pemilik, skor, diagnosis, atau learner state.
- `learning_journeys` bersifat service-only. RPC `save_learning_journey` menerapkan revision check secara atomik.
- HTTP v3 menyimpan event topic pada `session.prdV2`, terpisah dari field recovery sebelumnya tetapi berbagi revision.
- `409 revision_conflict` memerlukan reload; riwayat yang tidak konsisten membutuhkan restart eksplisit, bukan regrading diam-diam.
- AI hanya membantu interpretasi reasoning terbatas atau memilih hint terkurasi sesuai tahap. AI tidak bebas menghasilkan diagnosis atau menyelesaikan tes mandiri.
- Kontrak v3 membatasi hint pada tahap visual, worked, dan practice; retry, transfer, serta final assessment tidak menerima hint.
- Riwayat final assessment dipertahankan. Batas teknis v3 adalah 500 event; bukan kebijakan menghapus riwayat otomatis.

### Deployment

Deploy repository yang sama ke Vercel dengan **Root Directory `backend`**, Node.js `24.x`, install `npm ci`, dan build `npm run build`. Isi environment sesuai target Production/Preview, lalu redeploy setelah perubahan konfigurasi.

Dokumen handoff mencatat API di **https://rethink-recovery-api.vercel.app** sudah dideploy dan diperiksa pada 23 Oktober 2026. README ini tidak melakukan verifikasi ulang layanan live. Panduan lengkap: [backend/SETUP.md](backend/SETUP.md).

## Development Checks

Perintah berikut disediakan untuk dijalankan ketika diperlukan; penulisan README ini tidak menjalankannya.

**Backend — dari `backend/`:**

```sh
npm test
npm run typecheck
npm run build
```

**Swift — dari `frontend/`:**

```sh
swift test
xcodebuild -project Rethink.xcodeproj -scheme Rethink \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

Swift Package menguji model/service terpilih, bukan seluruh UI. Backend menggunakan fixtures, mock HTTP, serta embedded PostgreSQL; hasilnya tidak membuktikan efektivitas belajar. [Workflow CI](.github/workflows/recovery.yml) menyiapkan pemeriksaan backend dan Swift, tetapi keberadaan workflow bukan bukti bahwa run terakhir lulus.

<details>
<summary><strong>🛠 Troubleshooting</strong></summary>

| Gejala | Periksa |
|---|---|
| Simulator tidak terhubung | Base URL, port 3001, proses backend, jaringan/ATS |
| Guest session tidak dibuat | Anonymous Sign-Ins, URL/public key, proyek frontend dan backend yang sama |
| `401` | Access token, refresh session, kecocokan proyek Supabase |
| `403` pada browser | `ALLOWED_ORIGINS`; jangan mengatasi auth dengan menonaktifkan token check |
| `409 revision_conflict` | Reload journey sebelum command berikutnya |
| `409 reset_required` | Konfirmasi restart eksplisit; jangan menimpa bukti lama secara otomatis |
| `503` | Konfigurasi auth/storage, migration, atau content gate; bukan jawaban matematika salah |
| Flag v3 aktif tetapi pre-test tidak berubah | Katalog membuka prototipe lokal, bukan `JourneyFlowView` |
| Onboarding tidak muncul di DEBUG | Atur `RETHINK_SKIP_ONBOARDING=0`; pastikan replay/preview sesuai tujuan |
| Riwayat chat berbeda dari progres akun | Riwayat chat demo disimpan lokal, bukan tabel journey server |

</details>

## Documentation & Collaboration

Folder `docs/` menyimpan PRD, desain, keputusan, dan catatan implementasi. Mulai dari [indeks](docs/INDEX.md), [PRD aktif](docs/prd/README.md), dan [pemetaan implementasi PRD v2](docs/implementation/PRD-V2-TRACEABILITY.md). Dokumen historis/proposal memiliki status sendiri; jangan menganggap semua perilaku lama masih aktif.

Untuk kontribusi: gunakan branch terpisah, batasi perubahan sesuai fitur, pertahankan kontrak v2 saat mengubah v3, dan perbarui dokumentasi bila endpoint, konfigurasi, bank soal, atau navigasi berubah. Bug dapat dilaporkan melalui [GitHub Issues](https://github.com/pisciva/Rethink/issues) dengan langkah reproduksi, versi iOS/Xcode, serta pesan error tanpa token/credential.

**Lisensi:** belum ada file `LICENSE` pada root saat README ini ditulis. Jangan mengasumsikan izin redistribusi source atau aset pihak ketiga; dependency dan aset mengikuti ketentuannya masing-masing.

---

<sub>Snapshot dokumentasi: 23 Oktober 2026. Struktur penulisan mengacu pada <a href="https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes">GitHub Docs</a> dan <a href="https://google.github.io/styleguide/docguide/READMEs.html">Google Documentation Guide</a>. Isi teknis diturunkan dari source dan konfigurasi repository, bukan hasil build atau tes baru.</sub>

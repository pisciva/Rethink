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

Rethink membantu siswa memeriksa kemungkinan hambatan konsep saat mengerjakan **Sistem Persamaan Linear (SPL)**, mempelajari konsep melalui materi terkurasi, lalu mencoba menerapkannya tanpa bantuan. Fokus MVP adalah **Sifat Distributif**. Hasil diagnosis, progres belajar, dan nilai tes dicatat terpisah.

Repository ini memuat **frontend SwiftUI**, **backend HTTP Next.js**, serta dokumentasi produk. Beberapa layar frontend masih berupa prototipe lokal dan belum menggunakan penilaian server.

## Getting Started

| Tujuan | Buka |
|---|---|
| 📱 Mengembangkan aplikasi iOS | [frontend/Rethink.xcodeproj](frontend/Rethink.xcodeproj) dan [panduan frontend](frontend/README.md) |
| ⚙️ Menjalankan API lokal | [panduan backend](backend/README.md) dan [konfigurasi Supabase/Vercel](backend/SETUP.md) |
| 🔗 Menghubungkan alur PRD terbaru | [panduan integrasi backend](backend/docs/API-V3.md) |
| 📚 Memahami requirement produk | [indeks PRD](docs/prd/README.md) |
| Melihat status fitur | [status integrasi](#integration-status) |

**Prasyarat:** macOS dan Xcode dengan SDK iOS 26 untuk frontend; Node.js **24.x**, npm, serta proyek Supabase dengan Anonymous Sign-Ins untuk backend. Vercel diperlukan hanya untuk deployment.

```sh
git clone https://github.com/pisciva/Rethink.git
cd Rethink
```

Frontend dan backend memiliki konfigurasi terpisah. Jalankan perintah setup dari folder masing-masing.

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

- Diagnosis memeriksa beberapa konsep prasyarat.
- Hanya distributif yang memiliki paket pembelajaran dan validasi konsep lengkap.
- Satu pertanyaan lanjutan distributif dapat muncul jika bukti belum cukup.
- Pengguna boleh mengikuti tes akhir SPL setelah diagnosis tanpa menyelesaikan seluruh konsep yang direkomendasikan.
- Validasi konsep menghasilkan **Understood**, **Procedural Only**, atau **Needs Reinforcement**; hasil tes SPL tetap terpisah.
- Hasil hanya berlaku pada konsep dan soal yang dinilai.

### Integration Status

| Bagian | Implementasi | Catatan |
|---|---|---|
| Beranda, profil, navigasi | SwiftUI, native tab bar, akses chatbot layar penuh | Nama dan sebagian progres masih dummy |
| Katalog kelas 10–12 | 37 materi lokal; hanya SPL dapat dibuka | Sebagian besar materi belum memiliki konten belajar |
| Pre-test dari katalog | 10 soal lokal, pilihan ganda, pertanyaan lanjutan statis, audio | Berbeda dari bank server; jawaban hanya dalam sesi; belum dikirim atau dinilai backend |
| Pilihan SPLDV/SPLTV | Halaman fokus tersedia; SPLTV terkunci | Konten SPLTV belum tersedia |
| Chatbot | Balasan simulasi, Stop, chat baru, riwayat lokal | Belum terhubung ke AI |
| Alur belajar | `JourneyFlowView` + `JourneyStore` + `APIClient` | Terhubung ke backend melalui APIClient |
| Backend asesmen | Diagnosis Q1–Q10, hasil per konsep, hints, tes akhir SPL | Memakai bank soal dan aturan penilaian server |
| Gamifikasi | Progres dan pencapaian; sebagian indikator UI masih dummy | Progres aktivitas bukan persentase penguasaan konsep |

> **Integrasi:** pre-test dari katalog belum mengirim jawaban ke backend. Alur server tersedia melalui `JourneyFlowView`.

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
│   ├── app/api/                # Route HTTP untuk katalog dan progres
│   ├── src/                    # Domain, use case, konten, infrastruktur
│   ├── supabase/migrations/    # SQL penyimpanan journey
│   ├── tests/                  # Unit, API, integritas, embedded PostgreSQL
│   ├── docs/                   # Kontrak API dan setup terkait
│   └── archive/                # Salinan lokal backend lama, bukan runtime aktif
├── docs/                       # PRD, desain, keputusan, catatan implementasi
├── .github/workflows/          # CI backend dan Swift
└── AGENTS.md                   # Pedoman kerja agen dalam repository
```

Cache tidak masuk source control. `backend/archive/` hanya salinan lokal dan tidak dipakai aplikasi.

## iOS Frontend

### Technology & Architecture

| Bagian | Implementasi |
|---|---|
| UI | SwiftUI, target iOS 26.0, Liquid Glass |
| Arsitektur | MVVM dengan subfolder berdasarkan fitur |
| State | `ObservableObject`, `@Published`, environment stores |
| HTTP | `URLSession`, JSON/Codable, async/await |
| Identitas | Supabase guest session melalui HTTP Auth API |
| Token | Keychain, dipisahkan berdasarkan proyek Supabase |
| Matematika | SwiftMath **1.7.3**, melalui Swift Package di project Xcode |
| Media | Asset catalog, PhotosUI, audio onboarding dan speech sistem |
| Test harness | Package `ReThinkDiagnosis`, target `DiagnosisCore` |

**MVVM:** View menampilkan UI, ViewModel mengelola state dan aksi, Model menyimpan data, dan Service menangani jaringan, penyimpanan, serta aturan belajar.

File utama:

- [RethinkApp.swift](frontend/Rethink/App/RethinkApp.swift): entry point dan preview.
- [ContentView.swift](frontend/Rethink/Views/App/ContentView.swift): onboarding, pemulihan sesi, tab, presentasi chat.
- [AppConfig.swift](frontend/Rethink/App/AppConfig.swift): URL, public config, feature flags.
- [APIClient.swift](frontend/Rethink/Services/Remote/APIClient.swift): koneksi dan pengiriman aksi ke backend.
- [AuthStore.swift](frontend/Rethink/ViewModels/Remote/AuthStore.swift): guest session dan refresh token.
- [JourneyStore.swift](frontend/Rethink/ViewModels/Remote/JourneyStore.swift): progres, revision, dan pemulihan sesi.

### Xcode Setup

1. Buka `frontend/Rethink.xcodeproj`; gunakan scheme **Rethink**.
2. Biarkan Xcode menyelesaikan dependency SwiftMath.
3. Pilih simulator iOS 26+ atau perangkat yang sesuai. Untuk perangkat fisik, atur signing team sendiri.
4. Atur environment di **Product → Scheme → Edit Scheme → Run → Arguments** bila perlu.

| Environment Swift | Fungsi | Default kode |
|---|---|---|
| `RETHINK_API_BASE_URL` | Base URL backend | `https://rethink-recovery-api.vercel.app` |
| `RETHINK_SUPABASE_URL` | URL Supabase yang sama dengan backend | Konfigurasi bawaan di `AppConfig.swift` |
| `RETHINK_SUPABASE_PUBLISHABLE_KEY` | Public key Supabase | Konfigurasi bawaan di `AppConfig.swift` |
| `RETHINK_SKIP_ONBOARDING` | `0` untuk menguji onboarding pertama di DEBUG | DEBUG langsung ke Beranda; Release mengikuti completion |
| `RETHINK_REPLAY_ONBOARDING` | `1` mengulang onboarding | Tidak aktif |
| `RETHINK_ONBOARDING_PAGE` | Indeks slide untuk preview DEBUG | Tidak diatur |

Untuk simulator di Mac yang sama:

```dotenv
RETHINK_API_BASE_URL=http://localhost:3001
RETHINK_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
RETHINK_SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_KEY
```

Perangkat fisik tidak dapat mengakses server Mac melalui `localhost`; gunakan HTTPS deployment atau alamat LAN yang diizinkan konfigurasi jaringan/ATS. Environment Run scheme bukan konfigurasi rilis produksi. Jangan masukkan Supabase secret key atau AI key ke frontend.

SwiftUI Canvas tersedia pada sejumlah view. Preview tetap membutuhkan kompilasi Xcode dan beberapa layar masih memerlukan environment store atau layanan akun.

## Backend Recovery API

### Technology & Structure

**Node.js 24.x · Next.js 16.4.2 · TypeScript · Supabase JS · PostgreSQL · Vercel AI Gateway**

| Folder | Tanggung jawab |
|---|---|
| `app/api/` | Route HTTP |
| `src/content/` | Katalog, item recovery, versi konten, copy hasil |
| `src/domain/` | Matematika, evidence, diagnosis, belajar, validasi, map, snapshot |
| `src/application/` | Validasi dan koordinasi aksi belajar |
| `src/infrastructure/` | Supabase, persistence, transport Gateway, interpretasi terbatas |
| `src/http/` | CORS dan handler progres |
| `src/prdv2/` | Bank, types, engine/event replay, handler asesmen sesuai PRD |

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

Bank soal diaktifkan melalui `BANK_APPROVED` di source backend. Peninjauan pedagogis tetap terpisah dari implementasi.

### Backend Services

| Layanan | Akses | Fungsi |
|---|---|---|
| Health | Publik | Informasi konfigurasi layanan |
| Catalog | Publik | Materi, konsep, dan kemampuan yang tersedia |
| Learning Progress | Sesi pengguna | Membaca serta menyimpan perjalanan belajar |
| Diagnostic Assessment | Sesi pengguna | Mengumpulkan jawaban dan menghasilkan bukti per konsep |
| Learning Assistance | Sesi pengguna | Bantuan bertahap pada pembelajaran yang didukung |
| Final Assessment | Sesi pengguna | Tes akhir SPL dan riwayat percobaan |

Layanan ini menggunakan kontrak progres yang dijelaskan di [panduan integrasi](backend/docs/API-V3.md).

Client mengirim access token sesi dan revision terakhir. Backend memeriksa identitas serta urutan aksi sebelum menyimpan perubahan.

### State Integrity & AI Boundaries

- Backend memverifikasi identitas; client tidak boleh menentukan pemilik, skor, diagnosis, atau learner state.
- `learning_journeys` bersifat service-only. RPC `save_learning_journey` menerapkan revision check secara atomik.
- Riwayat asesmen topik dan hasil pemahaman konsep disimpan terpisah agar hasilnya tidak saling menimpa.
- `409 revision_conflict` memerlukan reload; riwayat yang tidak konsisten membutuhkan restart eksplisit, bukan regrading diam-diam.
- AI membantu membaca alasan siswa dan memilih petunjuk sesuai tahap belajar.
- Petunjuk tersedia saat belajar, bukan saat soal mandiri, transfer, atau tes akhir.
- Riwayat tes akhir disimpan. Sesi dibatasi hingga 500 event.

### Deployment

Deploy repository yang sama ke Vercel dengan **Root Directory `backend`**, Node.js `24.x`, install `npm ci`, dan build `npm run build`. Isi environment sesuai target Production/Preview, lalu redeploy setelah perubahan konfigurasi.

Alamat deployment: **https://rethink-recovery-api.vercel.app**. Panduan: [backend/SETUP.md](backend/SETUP.md).

## Development Checks

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

Swift Package menguji model dan service. Backend menguji logika, HTTP, dan penyimpanan dengan mock serta embedded PostgreSQL. Pemeriksaan otomatis diatur dalam [workflow CI](.github/workflows/recovery.yml). UI dan efektivitas belajar memerlukan pengujian terpisah.

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
| Konfigurasi backend berubah tetapi pre-test tetap lokal | Katalog membuka prototipe lokal, bukan `JourneyFlowView` |
| Onboarding tidak muncul di DEBUG | Atur `RETHINK_SKIP_ONBOARDING=0`; pastikan replay/preview sesuai tujuan |
| Riwayat chat berbeda dari progres akun | Riwayat chat demo disimpan lokal, bukan tabel journey server |

</details>

## Documentation & Collaboration

Folder `docs/` menyimpan PRD, desain, keputusan, dan catatan implementasi. Mulai dari [indeks](docs/INDEX.md), [PRD aktif](docs/prd/README.md), dan [pemetaan implementasi PRD](docs/implementation/PRD-V2-TRACEABILITY.md). Gunakan PRD aktif sebagai acuan perilaku produk.

Untuk kontribusi: gunakan branch terpisah, batasi perubahan sesuai fitur, jaga kompatibilitas kontrak frontend dan backend, dan perbarui dokumentasi bila endpoint, konfigurasi, bank soal, atau navigasi berubah. Bug dapat dilaporkan melalui [GitHub Issues](https://github.com/pisciva/Rethink/issues) dengan langkah reproduksi, versi iOS/Xcode, serta pesan error tanpa token/credential.

**Lisensi:** belum ditetapkan. Dependency dan aset pihak ketiga mengikuti lisensinya masing-masing.

---

<sub>Diperbarui 23 Oktober 2026.</sub>

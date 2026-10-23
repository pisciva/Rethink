# Rethink iOS

![iOS](https://img.shields.io/badge/iOS-26%2B-111827?style=flat-square&logo=apple&logoColor=white) ![SwiftUI](https://img.shields.io/badge/SwiftUI-MVVM-F05138?style=flat-square&logo=swift&logoColor=white)

Frontend SwiftUI untuk Rethink. Target aplikasi **iOS 26.0**, arsitektur **MVVM** dengan folder per fitur, dan dependency **SwiftMath 1.7.3** untuk rumus matematika.

[README utama](../README.md) · [Konfigurasi aplikasi](Rethink/App/AppConfig.swift) · [Kontrak backend terbaru](../backend/docs/API-V3.md)

## Getting Started

1. Buka `Rethink.xcodeproj` dengan Xcode yang menyediakan SDK iOS 26 atau lebih baru.
2. Gunakan scheme `Rethink`; resolve dependency Swift Package.
3. Pilih simulator yang sesuai. Untuk iPhone fisik, tentukan signing team sendiri.
4. Sesuaikan Run environment bila memakai backend lokal atau proyek Supabase berbeda.

```dotenv
RETHINK_API_BASE_URL=http://localhost:3001
RETHINK_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
RETHINK_SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_KEY
RETHINK_PRD_V2=1
```

Backend dan frontend harus memakai proyek Supabase yang sama dengan Anonymous Sign-Ins aktif. Jangan memasukkan secret/service-role key atau AI key ke aplikasi. Simulator pada Mac yang sama dapat memakai localhost; perangkat fisik memerlukan URL yang dapat dijangkau.

## MVVM Structure

| Folder | Isi |
|---|---|
| `Rethink/App` | Entry point dan public configuration |
| `Rethink/Models` | Model per fitur, Codable kontrak remote |
| `Rethink/ViewModels` | State, aksi, auth/catalog/journey stores |
| `Rethink/Views` | Layar per fitur |
| `Rethink/Services` | HTTP, Supabase Auth, Keychain, audio, konten dan kebijakan lokal |
| `Rethink/Components` | Komponen bersama, gaya, matematika, navigasi |
| `Rethink/Resources` | Asset catalog, gambar dan audio |
| `Rethink/Config` | Info.plist |
| `Rethink/Tests/DiagnosisCoreTests` | Regression fixtures model/service |
| `Package.swift` | Test harness `DiagnosisCore`; bukan entry point UI aplikasi |

## Remote Flow & Local Prototypes

**Remote recovery:** `Views/Remote/JourneyFlowView.swift` membaca `JourneyStore` dan command server. `RETHINK_PRD_V2=1` memilih `/api/v3`; default memilih `/api/v2`.

**Prototipe UI lokal:** katalog kelas menggunakan `GradeCourse` dan membuka `SPLPretestView`. Pre-test ini memakai bank 10 soal dari brief desain, pilihan ganda dan pertanyaan lanjutan statis; jawaban hanya tersimpan selama sesi. Bank tersebut belum disinkronkan dengan `backend/src/prdv2/content.ts` dan tidak dinilai oleh server.

Chatbot mandiri memakai `ChatViewModel`: balasan simulasi, proses yang dapat dihentikan, tiga riwayat contoh, serta riwayat di UserDefaults. Ia bukan integrasi tutor Socratic backend. Foto profil juga disimpan lokal. Progres dummy pada kartu/header tidak menjadi bukti penguasaan konsep.

## Onboarding & Previews

- DEBUG membuka Beranda secara default. Gunakan `RETHINK_SKIP_ONBOARDING=0` untuk menguji onboarding pertama.
- `RETHINK_REPLAY_ONBOARDING=1` mengulang onboarding untuk testing.
- `RETHINK_ONBOARDING_PAGE` memilih indeks slide khusus DEBUG.
- Release memakai status completion yang tersimpan.
- `#Preview` tersedia di entry point dan beberapa layar; Canvas tetap melakukan kompilasi dan sebagian view membutuhkan environment store.

## Development Checks

Dari folder `frontend`:

```sh
swift test
xcodebuild -project Rethink.xcodeproj -scheme Rethink \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

Swift Package berplatform macOS 13 untuk core/test harness; itu tidak menurunkan target aplikasi iOS. Pemeriksaan UI, keyboard, Liquid Glass, VoiceOver dan perangkat tetap diperlukan terpisah. Tidak ada build atau tes dijalankan ketika README ini ditulis.

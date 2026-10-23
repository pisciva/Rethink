# Rethink Recovery API

![Node.js](https://img.shields.io/badge/Node.js-24.x-397A36?style=flat-square&logo=nodedotjs&logoColor=white) ![TypeScript](https://img.shields.io/badge/TypeScript-Strict-3178C6?style=flat-square&logo=typescript&logoColor=white) ![Vercel](https://img.shields.io/badge/Deploy-Vercel-111827?style=flat-square&logo=vercel&logoColor=white)

Backend HTTP untuk aplikasi SwiftUI Rethink, menggunakan **Next.js 16.4.2**, **TypeScript**, **Node.js 24.x**, Supabase dan Vercel AI Gateway. Backend aktif bersifat API-only; tidak menyediakan website pembelajaran.

[README utama](../README.md) · [Setup lengkap](SETUP.md) · [API v2](docs/API-V2.md) · [API v3 / PRD v2](docs/API-V3.md)

## Local Setup

Dari `backend/`:

```sh
npm ci
cp .env.example .env.local
```

Isi konfigurasi privat, aktifkan Supabase **Anonymous Sign-Ins**, dan terapkan `supabase/migrations/202610220001_spl_recovery_journeys.sql` pada proyek yang sama dengan frontend. Kemudian:

```sh
npm run dev
```

Server lokal: `http://localhost:3001`. Pada PowerShell, gunakan `Copy-Item .env.example .env.local`; bila diperlukan, panggil `npm.cmd`.

| Variable | Fungsi |
|---|---|
| `SUPABASE_URL` | Proyek auth dan database |
| `SUPABASE_PUBLISHABLE_KEY` | Public project key; alias anon lama didukung |
| `SUPABASE_SECRET_KEY` | Backend-only database access; alias service-role didukung |
| `AI_GATEWAY_API_KEY` | Opsional untuk bounded reasoning/hint selection |
| `AI_GATEWAY_MODEL` | Gateway `provider/model`; default di `src/infrastructure/gateway.ts` |
| `ALLOWED_ORIGINS` | Browser origins dipisahkan koma; native client tidak perlu Origin |

Konfigurasi model mendukung ID provider/model, tetapi akses akun dan kemampuan structured output harus diperiksa terpisah. Kegagalan provider memakai fallback yang dibatasi, bukan diagnosis atau penilaian matematika buatan.

## Project Structure

```text
app/api/             Route HTTP: health, v2 catalog/progress, v3 catalog/progress
src/content/         Item recovery, versi, katalog dan pesan hasil
src/domain/          Math, evidence, diagnosis, belajar, validasi, map, snapshot
src/application/     Command recovery dan koordinasi
src/infrastructure/  Auth Supabase, storage, Gateway dan reasoning guards
src/http/            CORS dan handler progress
src/prdv2/           Bank, types, engine/event replay, handler PRD v2
supabase/migrations/  Schema dan RPC private journey
tests/               Unit/API/HTTP/persistence/embedded PostgreSQL
docs/                Kontrak HTTP
archive/             Salinan lokal historis; dikecualikan dari source aktif
```

`archive/` dapat ada di workspace tertentu dan tidak dibutuhkan untuk runtime. Backend lama untuk kurikulum 37 pelajaran, video/transkrip dan chat umum tidak menjadi API aktif saat ini. Jangan menyalin dokumentasi endpoint lama sebagai kontrak layanan terbaru.

## API Versions & Capabilities

| Kontrak | Cakupan |
|---|---|
| `/api/v2` | Recovery kompatibel: Q1–Q3, maksimal satu Q4, distributif, retry/transfer, hasil konsep |
| `/api/v3` | PRD v2: 10 primary items, per-concept evidence, bounded follow-up, open learning, contextual hints, lima soal final SPL |

`BANK_APPROVED = true` pada `src/prdv2/content.ts` mengaktifkan bank/rules yang disetujui untuk implementasi. Ini tidak membuktikan validitas psikometrik atau penerimaan ahli. Bank UI lokal frontend bukan bank server ini.

Hanya distributif memiliki complete guided-learning/concept-validation package. Representation tetap ditandai dengan cakupan diagnosis tidak memadai. Tes akhir SPL lulus pada 3/5 atau lebih, boleh diulang setelah gagal, dan tidak mengubah seluruh prerequisite menjadi Understood.

## HTTP & Persistence

- Publik: `GET /`, `GET /api/health`, `GET /api/v2/catalog`, `GET /api/v3/catalog`.
- Authenticated: `GET/POST /api/v2/progress` dan `GET/POST /api/v3/progress`.
- Auth menggunakan Supabase Bearer token; native URLSession tidak mengirim Origin.
- Command membawa `expectedRevision` terbaru. Unknown fields dan hasil penilaian buatan client ditolak.
- `learning_journeys` hanya diakses service role; RPC save memakai revision check atomik.
- PRD v2 event history berada di `session.prdV2`. V2/v3 berbagi revision dan tidak boleh menimpa hasil secara buta.
- `409 revision_conflict`: reload. `409 reset_required`: restart eksplisit. Gagal save bukan jawaban salah.
- API v3 membatasi contextual hints ke visual/worked/practice. Tidak ada hint untuk retry, transfer atau final assessment.
- Kesehatan konfigurasi `/api/health` bukan pemeriksaan readiness database atau kualitas provider.

Payload lengkap dan daftar command: [API-V2.md](docs/API-V2.md), [API-V3.md](docs/API-V3.md).

## Deployment & Verification

Vercel: Root Directory **`backend`**, Node.js **24.x**, `npm ci`, `npm run build`, framework Next.js. `vercel.json` mencatat install/build; Root Directory tetap diatur pada Vercel project. Simpan secret di environment backend dan redeploy setelah mengubahnya.

Dokumen implementasi mencatat deployment `https://rethink-recovery-api.vercel.app` dan pemeriksaan hosted pada 23 Oktober 2026. Status live tidak diperiksa ulang saat README ini ditulis.

```sh
npm test
npm run typecheck
npm run build
```

Suite menggunakan mocks dan embedded PostgreSQL. Hasil engineering tidak sama dengan pembuktian ketepatan diagnosis pada populasi siswa. CI ada di `../.github/workflows/recovery.yml`; tidak ada tes, server, build atau deployment dijalankan dalam tugas dokumentasi ini.

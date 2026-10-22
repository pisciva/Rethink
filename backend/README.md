# Rethink Recovery API

API-only Next.js backend for the **Swift iOS app**, deployed on **Vercel** at https://rethink-recovery-api.vercel.app. Active scope: Catalog → SPL diagnosis → Distributive Property recovery → eligible validation → Learning Map.

The old website backend, grade-based curriculum, broad pretest, chat/transcript services and packaged media were removed at the user's request. Git history is the rollback source; no legacy archive is retained in the workspace. Reviewed recovery code, approved Q2/Q3 items, bounded mathematical checking and saved-evidence safeguards were carried into separate modules.

## Run

Requires Node.js 24.x. From `backend/`:

```sh
npm ci
cp .env.example .env.local
# Fill in the Supabase URL, public key and backend-only secret key.
npm run dev
```

API: `http://localhost:3001`. PowerShell: `Copy-Item .env.example .env.local`; use `npm.cmd` if PowerShell blocks npm scripts. Enable Supabase Anonymous Sign-Ins for the Swift guest session and apply the single migration in `supabase/migrations/` before using progress. No old account/profile/curriculum migrations are required.

AI Gateway is optional and only advises on unclear Q3 reasoning. It never generates curriculum or grades independent retry/transfer. Configuration presence is not proof of live provider access.

## Native API

- `GET /api/health`: configuration presence, not a database/provider readiness guarantee.
- `GET /api/v2/catalog`: public subject/topic catalog and explicit capability coverage.
- `GET/POST /api/v2/progress`: Supabase bearer token; account-owned, revision-protected journey.

The `/api/v2` names and Codable journey shape remain compatible with the existing Swift `APIClient`. Native URLSession sends no browser Origin header. Backend secrets stay in Vercel. No website frontend is hosted here.

See [Vercel and Swift setup](SETUP.md), [API contract](docs/API-V2.md) and [architecture/verification](../docs/implementation/BACKEND-REBUILD.md).

## Layout

```text
app/                    HTTP route entrypoints only
src/content/            Catalog, curated draft items and fixed result copy
src/domain/             C2 map; C3 diagnosis; C4 learning; C5 validation;
                        shared evaluation, journey and history checks
src/application/        Command contract and orchestration
src/infrastructure/     Supabase auth/storage and optional bounded AI adapter
src/http/               HTTP, CORS and persistence acknowledgments
supabase/migrations/    Private, account-owned recovery evidence
```

Logical responsibilities are modules, not separate microservices. The stack is an engineering choice, not a claim that the PDF mandates Next.js or a particular AI model.

## Verify

```sh
npm test
npm run typecheck
npm run build
```

Tests use deterministic fixtures, mocked account/provider APIs and isolated embedded PostgreSQL. No live credentials or data writes are required. The user approved the OI-01..03 and OPS-01..05 implementation rules on 23 October 2026, including all-correct Rejected and no C5 after Optional Review. See [completion contract and executed checks](../docs/implementation/MVP-COMPLETION.md). The item bank remains labeled draft pending separate expert mathematical/pedagogical acceptance. Passing engineering checks is not full product/mathematics/usability acceptance.

# Vercel hosting and Swift setup

Vercel hosts stateless HTTP functions; Supabase provides guest identities and durable recovery evidence. State is never saved in function memory or the Vercel filesystem.

## Supabase

1. Choose the **same project** for the API and Swift app; enable **Anonymous Sign-Ins**.
2. Apply `supabase/migrations/202610220001_spl_recovery_journeys.sql`. Supabase supplies `auth.users` and its standard roles; old website migrations are unnecessary.
3. The migration creates private `learning_journeys` and service-only `save_learning_journey`. The backend verifies the guest/user access token before selecting that owner's records. Client roles cannot read/write this table directly.

**Selected project:** the user chose `hhovzaaeolcfynyetabf`. The Swift release fallback now matches the preserved backend public project configuration. Xcode environment overrides still take precedence, so use the same project there. Session records are scoped by project; old guest progress is not automatically migrated between projects.

Existing compatible recovery rows are reused. Obsolete/inconsistent evidence requires explicit restart. No automatic import of legacy website data or deletion of production tables occurs.

## Vercel project

Import the GitHub repository with these settings:

| Setting | Value |
|---|---|
| Root Directory | `backend` |
| Framework | Next.js |
| Node.js | `24.x` |
| Install | `npm ci` |
| Build | `npm run build` |
| Output | Framework default |

`vercel.json` records framework/install/build settings; Root Directory remains a Vercel project setting. Production uses Vercel Functions, not `npm run dev`.

Set environment variables for the intended Production/Preview environment:

| Variable | Use |
|---|---|
| `SUPABASE_URL` | Same project URL as Swift. |
| `SUPABASE_PUBLISHABLE_KEY` | Same public key as Swift. |
| `SUPABASE_SECRET_KEY` | Backend only. Never embed in Swift. |
| `AI_GATEWAY_API_KEY` | Optional bounded Q3 interpretation. Backend only. |
| `AI_GATEWAY_MODEL` | Gateway `provider/model` ID for a text model supporting JSON-schema output. Defaults to `deepseek/deepseek-v4.1-flash-1017` when unset/blank. |
| `ALLOWED_ORIGINS` | Optional browser clients only. Native Swift needs no Origin. |

Redeploy after changing environment variables. Deployment Protection may present a Vercel login page before the API handles a preview request; use an appropriately reachable API domain for the app while keeping Supabase token checks. Do not ship a Vercel bypass secret in the app.

### Switching the AI model

In the Rethink API project's **Settings → Environment Variables**, set `AI_GATEWAY_MODEL` to the exact `provider/model` ID from the [Gateway model catalog](https://vercel.com/ai-gateway/models), select Production (and Preview if needed), then redeploy. The existing Gateway key and Swift app configuration stay the same; no code edit is required. The model must be available to the team and support text Chat Completions with [JSON-schema structured output](https://vercel.com/docs/ai-gateway/sdks-and-apis/openai-chat-completions/structured-outputs). Image, embedding and other incompatible models cannot serve this task.

The transport uses common Gateway parameters and model defaults for temperature/reasoning. Reasoning models can consume the output budget or exceed the five-second Q3 timeout; select a model suitable for short structured responses and evaluate it before release. A valid model ID is not proof of access, remaining credits or response quality. Provider failures, truncation, refusals and invalid advice remain insufficient evidence, with no automatic model/credential fallback. Local math checks, Q3 quote guards and final system authority are unchanged; a model change does not regrade persisted attempts. Fine-tuned endpoints outside the Gateway catalog require a separate integration.

After deployment:

```sh
curl https://YOUR-API.vercel.app/api/health
curl https://YOUR-API.vercel.app/api/v2/catalog
curl -i https://YOUR-API.vercel.app/api/v2/progress
```

Expected: health/catalog JSON and 401 for progress without a token. Configuration flags only report presence, not provider/database readiness. Verify a real guest save/resume in the target environment before switching the distributed app.

## Swift app

Existing implementation: `frontend/Rethink/Services/Remote/APIClient.swift`, `SupabaseAuthClient.swift`, auth/journey stores and Codable models. For Xcode local runs, Edit Scheme → Run → Arguments → Environment Variables:

```dotenv
RETHINK_API_BASE_URL=http://localhost:3001
RETHINK_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
RETHINK_SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_KEY
```

A simulator on the same Mac can reach localhost. A physical iPhone or simulator on another machine needs a reachable address. Use the Vercel HTTPS URL for remote device testing.

Xcode Run environment variables are not a production configuration mechanism. `frontend/Rethink/App/AppConfig.swift` now defaults to `https://rethink-recovery-api.vercel.app` and the matching public Supabase project configuration after the hosted guest save/resume check passed. Scheme environment overrides still take precedence. Run Xcode/device checks before distributing the app.

URLSession sends `Authorization: Bearer <supabase_access_token>`, `Content-Type: application/json`, and no browser Origin header. The existing client supports this:

```swift
let client = APIClient(baseURL: URL(string: "https://YOUR-API.vercel.app")!)
let catalog = try await client.catalog()
let envelope = try await client.journey(token: try await auth.accessToken())
```

Refresh an expired token through the existing auth store; reload after `revision_conflict`; require explicit confirmation for `reset_required`. Only public configuration belongs in the app. A local UI event cannot create a learner state or acknowledge a save.

## Status

Deployed to **https://rethink-recovery-api.vercel.app** in the new `hansens-projects-6e7d42c5/rethink-recovery-api` project. Production variables are configured with explicit user approval. Fresh cloud install/build/TypeScript and 57 tests passed on Next.js 16.4.2 with zero audit vulnerabilities. The selected project exposes the recovery table and anonymous sign-ins now work. A synthetic guest passed authenticated save/interrupted resume, stale-revision rejection, confirmed recovery, retry/transfer and persisted Distributive Property state/map checks; that guest and its evidence were deleted. Swift’s default API URL now points to the new production endpoint. A synthetic bounded Q3 completion also passed against the live AI Gateway and the hosted diagnostic endpoint. iOS runtime remains unverified. See [verification and pending decisions](../docs/implementation/BACKEND-REBUILD.md).

Official hosting references checked during implementation: [Node.js versions](https://vercel.com/docs/functions/runtimes/node-js/node-js-versions), [monorepo roots](https://vercel.com/docs/monorepos), [environment variables](https://vercel.com/docs/environment-variables), [Deployment Protection](https://vercel.com/docs/deployment-protection).

## Swift checks and onboarding

On a Mac with the supported Xcode/iOS SDK installed:

```sh
cd frontend
swift test
xcodebuild -project Rethink.xcodeproj -scheme Rethink -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Run those commands from the repository root before `cd frontend`. The GitHub workflow `.github/workflows/recovery.yml` prepares the same package and simulator compile checks on macOS, alongside backend tests/build. It has not been executed in this Windows workspace.

Release first launch uses the existing onboarding, then persisted completion. DEBUG retains the earlier development shortcut to Home; set `RETHINK_SKIP_ONBOARDING=0` to test first-launch activation. `RETHINK_REPLAY_ONBOARDING=1` and the DEBUG preview page override that shortcut. Test persistence with replay disabled. Missing optional narration remains silent and never blocks navigation. The app now preserves the guest on temporary refresh outages, shares concurrent refresh calls, discards old-identity responses, and requires authoritative reload before resubmitting after uncertain saves. These client behaviors have Swift regression tests prepared; actual execution requires the Mac workflow.

# Workspace layout — 23 October 2026

The active backend is `backend/`: a Swift-focused, API-only Next.js service prepared for Vercel, with C1–C5 domain modules in `src/`. The user explicitly requested removal of the old backend instead of retaining an archive. The earlier 22 October statement about keeping a teammate backend and a local backend archive is superseded.

```text
backend/    Active recovery API, tests, single recovery migration and deployment setup
frontend/   SwiftUI iOS application and Xcode/Swift Package projects
docs/       Product baseline, decisions, design references and engineering verification
```

The broad curriculum/pretest/chat/media backend and its assets are removed. Git commit `69e1d178fb8a8c4cf56a0a237c8dee2c33fc53fa` and earlier history retain the committed predecessor. Reviewed recovery logic and the later saved-session integrity work are carried forward into the replacement. No in-repository legacy archive remains.

Local dependencies/build caches and `.env.local` remain ignored. The local environment file was preserved without printing its values. Source PDF/transcriptions, frontend source and design references were not deleted or rewritten.

Vercel must use `backend` as Root Directory; Swift consumes `/api/v2/catalog` and `/api/v2/progress`. The service has not been deployed and the app's release endpoint has not been switched. See [replacement report](BACKEND-REBUILD.md) and [setup](../../backend/SETUP.md).

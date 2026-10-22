# Workspace layout — 22 October 2026

User-authorized file move only. Main backend: `backend/`. Personal backend snapshot: `backend/archive/RethinkBackend_v2/`. Both retain their `.git` directories and uncommitted files. No merge, reset, staging, migration or deployment was performed.

The Xcode project, application source, Config, Tests, Swift package and local Swift caches move together into `frontend/`. Relative Xcode/Swift package resource paths remain aligned. Product docs move from the app directory into root `docs/`; repository instructions move to root `AGENTS.md`. Existing root docs are retained. Archived docs and source transcriptions are preserved.

The main backend excludes `archive/` from TypeScript discovery, Git additions and Vercel deployment packaging. Root `.gitignore` excludes build caches and local secrets. Remote deployment root settings and Xcode's saved recent-project location may need selecting the new paths; no remote setting was changed.

Static verification: moved-file existence inventory passed for 707 non-cache files; backend Git HEAD file contents were unchanged. No build, test, server, simulator or database action was run, per user preference. API behavior and frontend backend URL are unchanged.

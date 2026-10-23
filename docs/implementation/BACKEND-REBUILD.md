# Recovery backend replacement — 23 October 2026

**Status: API deployed; cloud build, 57 tests and hosted guest recovery/save-resume checks passed. Swift API default updated; iOS runtime not tested.** Approved PRD semantics remain authoritative. The user subsequently approved OI-01..03 and OPS-01..05 implementation rules; see [completion record](MVP-COMPLETION.md). Expert mathematics/pedagogy and iOS acceptance remain separate.

## User direction and scope

The user requested replacing the backend with one closer to the documentation, explicitly permitted deletion of the old backend without an in-repository archive, selected **Vercel hosting**, and specified the **Swift app as the primary client**. This supersedes the earlier implementation direction to retain the teammate website backend, grade-10 module catalog and website v1 compatibility. It does not authorize broader diagnosis, new curricula or new outcome semantics.

The prior backend combined recovery with a broad mixed pretest, a 37-lesson curriculum, chat, transcript providers, video and visualization libraries, and legacy website progress. These were additional implementation scope, not requirements of the approved recovery MVP. The existing newer recovery core already implemented important PRD boundaries; its reviewed mathematics, approved Q2/Q3 revision, uncertainty guard and saved-evidence checks were retained and separated into focused modules rather than discarded.

The replacement supports only Catalog → SPL diagnosis → Distributive Property recovery / optional review → eligible retry and transfer → blocker-level state → Learning Map. No UI-only event or AI-generated text assigns a learner state.

## Active architecture

This is one API-only Next.js deployment. The eight logical components map to modules; they are not eight microservices. TypeScript/Next.js is an engineering choice suited to the selected host. The paper's Flutter/FastAPI/Neo4j/model candidates are not mandatory stack decisions.

| Logical responsibility | Active implementation | Requirements |
|---|---|---|
| LC-01 entry / coverage | `backend/src/content/catalog.ts` | FR-C1-01..05 |
| LC-02 question flow | `domain/journey.ts`, curated `content/distribution.ts` | FR-C3-01..03/06 |
| LC-03 mathematical support | `domain/mathematics.ts`, `domain/evaluation.ts` | FR-C3-04; FR-C5-04 |
| LC-04 diagnostic interpretation | `domain/diagnosis.ts`, bounded `infrastructure/reasoning.ts` | FR-C3-05..10; approved OI-01/03 implementation rules |
| LC-05 curated guidance | `domain/learning.ts`, `content/distribution.ts` | FR-C4-01..08; approved practice/completion rules |
| LC-06 validation | `domain/validation.ts` | FR-C5-01..08 |
| LC-07 orchestration / state | `application/commands.ts`, `domain/journey.ts`, `domain/snapshot.ts`, `infrastructure/journeys.ts` | FR-X-01..03; approved persistence rules |
| LC-08 map / results | `domain/map.ts`, `content/results.ts`, public journey projection | FR-C2-01..05; FR-X-03 |

Domain functions own evidence and outcomes. HTTP handlers authenticate, validate commands, load the owner's snapshot, apply domain behavior, and save using a revision-protected RPC. Storage does not grade math. C2 projects C3/C5 outputs without adding judgments. Optional AI advice is isolated from final state and mathematical validation.

## What changed

- Catalog now follows subject/topic discovery: Algebra → SPL. Another represented topic is explicitly unavailable; it cannot initiate teaching or assessment. The catalog no longer imports a grade/curriculum bank or uses ability-lock labels.
- Only `/api/health`, `/api/v2/catalog`, `/api/v2/progress` and root service metadata remain. The `/api/v2` names are retained for Swift compatibility, not as a legacy website dependency.
- The broad pretest/curriculum/chat/transcript/media APIs, assets, generators/examples and unrelated SQL migrations/tests were removed from the working tree. Existing Git history remains the rollback source.
- One additive recovery migration remains. A fresh Supabase project requires no legacy profile/pretest/curriculum migrations. The existing `learning_journeys` table/RPC name and valid draft-3 sessions remain compatible. No live tables or rows were dropped.
- The command boundary rejects unknown fields, including grade/module/mastery/client-assigned outcomes. Existing Swift commands contain only the accepted fields.
- Learning and validation modules independently reject missing/inconsistent origins and unresolved item evaluations. This tightens invalid internal states without changing valid journey responses or final policy.
- Provider, authentication and persistence adapters are separate from C1–C5 domain modules. Vercel process memory/files are never used as durable learner storage.
- Local `.env.local` contents were preserved. `.env.example` now documents only active settings and uses placeholders. The app's deployed URL/default Supabase project was not silently switched.

The old backend was not deployed over or remotely deleted. No new production URL was invented. A temporary pre-replacement patch outside the repository was retained as an extra recovery aid; no legacy archive remains in the workspace.

## Native and hosting contract

Swift creates/restores a Supabase guest session and sends its access token through URLSession. Native requests omit browser Origin; progress authentication is mandatory. Public/publishable configuration may be in the app, while service and AI keys remain backend-only. The existing Codable result shape and raw enum values are retained.

`backend/vercel.json` records the Next.js framework and reproducible npm install/build commands. The Vercel project must use `backend` as its root and Node.js 24.x. [Setup](../../backend/SETUP.md) documents variables, migration, deployment protection, simulator/device URLs and release configuration. [API contract](../../backend/docs/API-V2.md) documents commands, failures and explicit restart.

A public-configuration check found different Supabase projects. The user selected the existing backend project `hhovzaaeolcfynyetabf`; the Swift fallback URL and verified public key now match. Session Keychain records are scoped by project host so old-project tokens are not reused. No backend secret was embedded and no cross-project progress migration occurred. Static configuration checks passed; Swift/Keychain runtime checks were not run.

Vercel authentication succeeded as `hansenhalim1`. Created and linked `hansens-projects-6e7d42c5/rethink-recovery-api`. Production is **https://rethink-recovery-api.vercel.app**, current deployment `rethink-recovery-3b3353x58-hansens-projects-6e7d42c5.vercel.app`. Existing Vercel projects are unchanged. Source uploads explicitly exclude local environment files. After automatic review initially rejected credential transfer, the user explicitly approved Supabase and AI Production configuration; all six configured active variables were then uploaded, with backend secret/AI keys marked sensitive. Obsolete video/transcript credentials were excluded.

The user applied the migration and enabled/saved anonymous sign-ins in the selected project. Live checks passed: recovery-table availability, anonymous signup, authenticated empty journey, SPL selection, Q1–Q3 diagnosis, saved/interrupted resume, stale-revision rejection, confirmed recovery, active practice, independent retry, transfer and persisted Distributive Property Understood/map projection. The one synthetic guest and its cascading evidence were deleted afterward. This verifies one hosted valid recovery path, not population-level diagnosis or learning effectiveness. Swift’s default API URL in `AppConfig.swift` now points to `https://rethink-recovery-api.vercel.app`; local environment overrides remain supported.

Cloud npm audit exposed Next.js security advisories [GHSA-2464-fhr4-w9xw](https://github.com/advisories/GHSA-2464-fhr4-w9xw) and [GHSA-p3m5-59mp-jv5r](https://github.com/advisories/GHSA-p3m5-59mp-jv5r). Upgraded Next.js from 16.3.8 to pinned 16.4.2 and updated the lockfile. Both local production audit and the fresh cloud install report **zero vulnerabilities**. The historical 50-test suite passed after the security upgrade; the completed feature suite now has 57 passing tests; cloud compilation and TypeScript passed.

## Executed checks

| Check | Result and limit |
|---|---|
| Replacement suite | **57 passed, 0 failed**, including embedded PostgreSQL subtests; Windows Node.js 24.18.1. |
| TypeScript / production build | **PASS**. Build generates only root, health, catalog and progress plus the framework 404 page. |
| Fresh cloud install / audit | **PASS**, Vercel `npm ci`; zero vulnerabilities after Next.js 16.4.2 upgrade. |
| Swift response comparison before deleting old sources | **35 snapshots matched** across confirmed recovery, optional review, uncertain Q4 and all-correct pending. No iOS app was launched. |
| Built-server smoke | **PASS**: subject/topic catalog, SPL-only support, native missing-token rejection, browser origin rejection and allowed preflight. All **12 removed legacy API paths return 404**. Temporary server stopped afterward. |
| Hosted guest path | **PASS**: anonymous authentication, interrupted save/resume, stale revision rejection, confirmed recovery through retry/transfer, persisted concept state/map projection and synthetic guest cleanup. Q3 used curated interpretation; this does not verify an external AI completion. |
| State / evidence boundaries | **PASS**: all 10 active phases plus rejection of obsolete pending histories, invalid/missing/corrupt histories, explicit restart, failed-save retry, one-Q4 limit, optional review exclusion, no learner state from guidance, conditional transfer, three-state matrix. |
| SQL | **PASS** in isolated PGlite: service-only permissions, revisions, account ownership/deletion, and no import/overwrite of a pre-existing legacy table fixture. Live table availability and revision-protected authenticated save/resume also passed. |

Tests belonging solely to deleted curriculum, chat and media features were removed with those implementations. The old 79-test total is historical; the smaller active suite is not evidence that the deleted features remain supported. Public API/invalid-state behavior is checked in `tests/api.test.ts`, `http.test.ts` and `capabilities.test.ts`; no mathematical evaluator or diagnostic policy was declared approved by those tests.

Existing backend copy was moved with its state bindings; approved item copy IDs `diag.item.q2.prompt`, `diag.item.q2.math`, `diag.item.q3.prompt` and `learn.visual.groups.explanation` retain their existing statuses. No new learner-facing copy or gamification feature was introduced. Proposed UX-030/031 item checks remain static checks; user comprehension/accessibility tests were not run.

## Remaining work and decisions

- **Not run:** device/simulator build, new Swift regression suite, Swift Keychain runtime, VoiceOver, motion/visual QA and learner comprehension. One synthetic external AI completion and hosted bounded Q3 handoff passed; broad reliability/accuracy is not established by that check.
- **Approved for implementation:** OI-01..03, OPS-01..05 and the described GAM presentation layer, by explicit user choices. **Still unverified:** expert mathematical/language-rubric/pedagogical acceptance and empirical decision/learning quality.
- Swift API default now uses the verified production endpoint and selected Supabase project. Next: run the app in Xcode/device to verify decoding, guest restoration and UI transitions. Retiring a separate existing production service is a distinct action.

The current FR implementation table separates passing engineering checks from full Untested acceptance; passing a local suite does not establish final mathematical validity, diagnostic accuracy, SPL mastery or learning gains.

## Completed feature follow-up

The [completion report](MVP-COMPLETION.md) supersedes earlier interim-policy and 50-test notes above. All-correct now maps to Rejected; Optional Review cannot open C5. New server-owned progress/validation/recognition projections are consumed by Swift, with visible practice feedback and explicit catalog/map exits. Guest refresh and interrupted-save safeguards, source-backed catalog mapping, release first-launch onboarding and CI preparation are implemented. Live branch checks covered all V-X categories at API level and removed both temporary guests afterward. No iOS execution or expert acceptance is implied.

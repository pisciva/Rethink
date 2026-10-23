# MVP completion work — 23 October 2026

This is an implementation and review record, not a replacement for the archived PRD. The current user request covers the documented MVP and its three proposed presentation mechanisms. It does not authorize expanded curriculum, unrestricted chat, new mastery states or empirical learning claims.

## Inventory and implementation order

1. **FR-X-01..03:** preserve guest identity during temporary refresh failures, serialize token refresh, prevent stale requests crossing accounts, and reconcile interrupted saves before resubmission.
2. **C3 / FR-C2-03:** implement the user's explicit OI decisions below, including all-correct continuation, with saved-evidence compatibility checks.
3. **C2–C5 presentation:** add branch-aware journey progress, explicit recovery/review context, validation evidence summaries and concept recognition derived exclusively from persisted qualifying evidence. Never expose diagnostic hints or validation scaffolds.
4. **C1:** use the actual supported subject/topic catalog, with unavailable represented topics clearly distinguished; do not fabricate a broader curriculum when the API supplies none.
5. **Verification:** backend cases for every applicable V-X category; Swift networking/session/projection tests; a macOS CI workflow for the Swift package. Device usability, VoiceOver and mathematical/pedagogical acceptance remain separate checks.

## Product decisions received in this conversation

- **OI-01:** the user selected current guarded system rules with bounded AI advice. Math/evidence rules retain final authority; AI only advises on unclear Q3. No numerical confidence or AI-issued blocker.
- **OI-02:** the user selected Optional Review ending without validation or a learner-state update.
- **OI-03:** the user selected Rejected for all-correct Q1–Q3, with optional review or catalog continuation and no SPL mastery claim.

These are current product implementation decisions, superseding the earlier interim directions. The original source register remains historical; final math-methodology acceptance is not inferred from the user's choice of authority.

## Approved operational contract

**APPROVED FOR IMPLEMENTATION:** the user selected “Approve these implementation rules” in this conversation on 23 October 2026. Expert mathematical/pedagogical acceptance and empirical validation remain separate. The section below records the reviewed concrete rules.

### OPS-01 — practice response and feedback

Keep one incomplete step, `5(x + 2) = 5x + …`, expecting `10`. Accept supported equivalent numeric forms. An evaluable wrong value remains in Practice with a factual instruction to apply the multiplier to each term. No new lesson is generated. Unreadable/empty input creates no mathematical evidence and stays editable. No answer-revealing feedback appears during diagnosis or validation. Keep the existing technical limit of 100 stored attempts per journey, make exhaustion actionable through explicit restart, and never call exhaustion a failed assessment.

### OPS-02 — completion

Visual → Worked → Practice is linear. Opening a screen is not completion. Advancing through Visual and Worked and submitting one valid correct practice response completes the package. Confirmed recovery then opens Independent Retry; Optional Review ends without C5. C4 completion alone assigns no learner state or achievement.

### OPS-03 — validation inputs

Use the bounded linear-expression evaluator for the item's requested variable `x`. Accept mathematically equivalent expanded expressions, reordered terms, decimal/fraction coefficients and Unicode multiplication/minus forms within supported syntax. Parenthesized expressions do not meet an explicit expanded-form task; show a formatting request and do not grade them as wrong. Blank, invalid, nonlinear, unsupported-variable, division-by-zero, overlong and uninterpretable inputs create no attempt/state and remain editable. Only valid item outcomes enter the approved C5 matrix. Keep the 160-character math / 1200-character explanation limits and 4096-byte request limit.

### OPS-04 — retained bank for this implementation

| Item | Task / reference |
|---|---|
| Q1 | SPL `3(x+2)+y=15; x+y=5`; equivalent first equation is option A, `3x+6+y=15`. B, `3x+2+y=15`, is the configured omission pattern; C is other incorrect evidence. |
| Q2 | Expand `4(x+3)` → `4x+12`; omission pattern `4x+3`. |
| Q3 | Explain the multiplier in `5(x+2)`; both `x` and `2` are multiplied by 5. The prompt supplies no expansion. Current conservative rubric plus bounded quoted AI advice is retained; ambiguous/conflicting prose is insufficient. |
| Q4 | At most one procedural trace, `2(x+4)=2x+…` → `8`; omission pattern `4`. |
| Visual | Three groups containing `x` and `2` → `3x+6`, multiplier applied to each term. |
| Worked | `2(x+4)` → `2x+8`, explaining both products. |
| Practice | `5(x+2)=5x+…` → `10`. |
| Retry | Independently expand `4(x+5)` → `4x+20`. |
| Transfer | Three boxes, each with `x` blue and four red pencils → `3x+12`; contextual representation rather than merely replacing numbers. |

Approval here means use of these assets and bounded forms for this implementation. It does **not** certify diagnostic validity, comprehensive language-rubric coverage, pedagogical effectiveness or causal learning gains; those require reviewed cases and domain/user evidence.

### OPS-05 — session and presentation persistence

Supabase owns authenticated journeys; service-only revision-checked writes are authoritative. Missing/invalid tokens do not expose another owner's progress. Concurrent/stale writes return a conflict and require reload. Technical failures preserve the last known identity and evidence. After an uncertain save outcome, reload before another mutation. Corrupt/obsolete evidence requires explicit reset; no silent regrading. Existing compatible saved histories remain valid; the old all-correct pending history requires explicit restart because the new policy would change its outcome.

Progress is a read-only projection of authoritative phase/evidence, not mastery. A Concept Applied recognition is a stable, non-animated card derived from an already-persisted, valid confirmed-recovery `Understood` result with successful Retry and Transfer. Its identity is tied to that result; repeat GET/view events create no extra reward, write or notification. It is neither a permanent award ledger nor a promise that future attempts will pass. Reset/reinforcement removes the current-result projection when qualifying current evidence no longer applies. There is no independent achievement mutation endpoint. User approval of this proposal would select this simpler evidence-backed recognition policy rather than invent a second reward database.

## Verification report

Current API: **https://rethink-recovery-api.vercel.app**. API deployment is live; all backend feature, exact-grading and malformed-input production checks passed. Current deployment: `rethink-recovery-3b3353x58-hansens-projects-6e7d42c5.vercel.app`. No archived PRD source was modified.

| Implemented feature / files | Requirement coverage | Executed verification |
|---|---|---|
| All-correct → Rejected in `backend/src/domain/diagnosis.ts`; existing optional-review exclusion and guarded AI retained | FR-C3-04..10, FR-C2-03/04, FR-X-02/03 | Unit/API and live V-X-07/08 checks PASS. Old pending snapshots require explicit reset. |
| Exact rational coefficients in `backend/src/domain/mathematics.ts` | FR-C3-04, FR-C5-04/05 | Fraction/decimal equivalence, tiny nonzero-error and unsupported adjacent-token regression checks PASS. Previously incorrectly accepted near-equal stored histories require explicit reset, never silent regrading. |
| `backend/src/domain/presentation.ts`, `tests/presentation.test.ts`; Swift models and `Components/LearningCard.swift` | C2–C5, FR-X-03; proposed GAM P/F/A/X scenarios | Backend projection tests and live validation/result/repeated-read checks PASS. SwiftUI/VoiceOver/motion execution NOT RUN. |
| Visible practice feedback, result evidence, catalog/map exits, explicit technical-limit restart in `Views/Remote/JourneyFlowView.swift`, map/profile/topic views and app navigation | FR-C3-09/10, FR-C4-05/07/08, FR-C5-06/07 | Backend trigger/guard tests PASS; SwiftUI execution NOT RUN. |
| Auth refresh sharing/outage preservation, stale-owner discard, unknown-save reconciliation in remote auth/client/journey stores | FR-X-01..03 | Live owner isolation, token refresh and saved-result resume PASS; new Swift concurrency/network tests prepared, NOT RUN. |
| Actual subject/topic catalog without fabricated fallback curriculum in `CatalogStore.swift` | FR-C1-01..05 | Backend support/forged-command live checks PASS; Swift catalog test expanded, NOT RUN. |
| Release first-launch onboarding, DEBUG-only development shortcut, persisted pre-completion name | Onboarding OB-C scenarios, proposed experience layer | Swift tests updated to the approved informational/five-familiarity/preview-chat revisions, NOT RUN. Missing optional narration remains silent. |
| `.github/workflows/recovery.yml` | Reproducible backend and Swift checks | Backend jobs reproduced locally (57 tests and build PASS); macOS package/simulator workflow prepared, NOT RUN. |

### Backend and hosted checks

- **57 tests passed, 0 failed**, including isolated PostgreSQL permissions, revisions and deletion/legacy-separation fixtures. Local production compilation and TypeScript PASS.
- Live branch matrix PASS: C1 active/unavailable boundaries; missing/invalid tokens; forged/unsupported commands; invalid/non-expanded inputs creating no evidence; all-correct Rejected; Optional Review completed without C5; Uncertain with exactly one Q4; confirmed recovery; all three C5 outcomes; reinforcement using the existing package; concept-scoped map projection and repeat-safe recognition.
- Live saved-result reads, cross-guest ownership isolation, stale revision conflict, actual Supabase refresh and hosted bounded Q3 Gateway interpretation PASS. Two synthetic guests and their cascading test evidence were deleted afterward. The direct synthetic Gateway check returned HTTP 200 with a valid bounded interpretation.
- The exact-arithmetic cloud build passed compilation/TypeScript and a fresh install with zero audit vulnerabilities. Focused production smoke PASS: wrong near-equal practice stays incomplete, exact fractional practice completes, near-equal retry produces Needs Reinforcement with no Transfer/achievement, and exact fractional Retry/Transfer produces persisted Understood with stable recognition. Its synthetic guest was deleted. The final adjacent-token syntax guard also passed live: malformed forms created no evidence/revision change, while an exact fractional answer saved and resumed. That synthetic guest was deleted. The obsolete pending outcome emission has been removed; legacy pending histories still require explicit restart.

### Claims and limits

These checks establish engineering behavior for the approved current implementation and fixtures. They do not establish full product acceptance, population diagnostic accuracy, SPL mastery, empirical learning gains, expert language-rubric/pedagogical acceptance or SC4 comprehensibility. Full FR acceptance remains Untested pending the applicable independent reviews and iOS execution. OI/OPS choices are approved for implementation; those choices are no longer silently treated as unresolved product gates.

Copy IDs: retained diagnostic item IDs and data-bound result/feedback IDs; added `gam.progress.*`, `val.evidence.*`, `gam.achievement.record.title`, `sys.attempt.limit`, `sys.network.connection`, `sys.guest.unavailable`, `sys.reset.evidence`, with reused `gam.achievement.body/scope`, `sys.save.unknown.*` and session/availability strings. New editorial status: REVIEW_NEEDED, conditional on the authorized evidence/state. No BLOCKED all-correct placeholder is used for the live Rejected result. Proposed GAM backend assertions PASS; GAM/UX UI tests and learner-comprehension studies NOT RUN.

Next verification: run `swift test` and the simulator build on the documented Mac workflow, then exercise the app's guest restoration, interrupted saves, all diagnostic/validation branches, Dynamic Type, VoiceOver and reduced motion. Perform the separate expert item/rubric/pedagogy and intended-user comprehension reviews. No additional implementation-policy choice is currently requested.

### Final deployment result

Production deployment `rethink-recovery-3b3353x58-hansens-projects-6e7d42c5.vercel.app` is Ready. Final cloud compilation/TypeScript and fresh install PASS, zero audit vulnerabilities. The production alias remains https://rethink-recovery-api.vercel.app. Last full backend run: 57 PASS, 0 FAIL. Exact-arithmetic and unsupported-syntax live probes passed before the final obsolete-pending branch cleanup; that cleanup passed the full suite and final cloud build. All temporary test guests were deleted. No Swift/Xcode execution or manual expert/usability acceptance has been performed.

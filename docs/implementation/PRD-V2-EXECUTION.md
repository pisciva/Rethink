# PRD v2 local implementation and verification — 23 October 2026

## Result and release boundary

Fetched `origin/main` at `d107a04` and imported the newest PRD docs/source introduced by `ff9818c`. No unrelated remote frontend changes were merged, and the removed legacy backend was not restored. The user requested the v2 scope; the original DOCX/PDF remain unchanged. Earlier implementation approvals and backend verification reports were preserved. The complete 43-ID inventory has a [current engineering mapping](PRD-V2-TRACEABILITY.md).

**Local implementation and bank/rules are enabled.** The user explicitly approved the [concrete bank and policy](PRD-V2-PLAN.md): “Use the proposed bank and rules.” `BANK_APPROVED = true`; the v3 API serves the approved ten-question diagnosis and separate five-question final assessment. The catalog activates the reviewed screening scope and keeps unavailable learning/insufficient representation diagnosis disabled. Existing production and the default Swift API selection remain unchanged. No GitHub push, Vercel deployment, paid AI call or student-data export was performed for this task.

The completed implementation review follows repository `AGENTS.md` §3: “When a task touches an unresolved element” the agent must “request a product/engineering review decision when needed.” The PRD v2 DOCX gives coverage/flows, not the actual ten-item bank, five final items, multi-concept evidence thresholds or final probe budget. Prior approval to retain the old bank does not approve those new assets or thresholds. Review is for implementation use, not a substitute for expert/empirical acceptance.

## Implemented slices

- `backend/src/prdv2/{types,content,engine,http}.ts`: separate versioned topic-session event replay, ten primary items with per-item version, tags, role, rubric and attribution, explicit coverage and canonical per-concept evidence status. Supporting evidence, counterevidence and insufficient coverage remain distinct. Representation has only one item and remains Insufficiently Assessed, not a supported diagnostic capability.
- `/api/v3/catalog` and `/api/v3/progress`: explicit capability gates, authenticated commands, strict field validation, existing owner/revision Supabase persistence and fail-closed incompatible history. New `session.prdV2` history preserves original legacy recovery fields; legacy reset preserves topic history. No database migration needed.
- One separately identified curated distribution follow-up for a named insufficient-evidence condition, only after all ten primary responses. The user-approved maximum is one; this is not represented as a source-defined universal budget.
- Open post-diagnostic learning choice: available distribution package or separate topic assessment. Other concepts remain visible with honest learning availability. Supported recovery vs optional review stays explicit; the latter still cannot enter concept validation.
- Retained linear Visual → Worked → active Practice package and independent Retry → conditional Transfer matrix. Last valid C5 concept state is separate from a new learning cycle; revisiting learning or taking the final assessment cannot manufacture or erase that C5 result. Explicit diagnostic restart resets the current diagnosis/learning projection but keeps original events and all topic attempts.
- Contextual Socratic help: three progressive curated questions per visual/worked/practice stage/cycle. Optional Gateway assistance can select only the allowed current hint; malformed, malicious, out-of-context or unavailable output uses deterministic fallback. No model-generated math answer is displayed. No help or model invocation is permitted on retry, transfer or final assessment. Freeform help messages are not persisted.
- Separate five-item SPL final assessment: score/result disclosed only after all five valid responses, pass at 3/5, retry after Not Passed, incomplete-attempt resume, all attempt history retained. Topic result does not assign concept states or recognition.
- Swift client/model/screen integration: opt-in `RETHINK_PRD_V2=1`, separate command schemas/endpoints, ten-item progress, per-concept results and map projection, contextual help, final result/history, scoped copy and explicit reset explanation. Existing v2 responses continue to decode. New Swift tests cover the schema and endpoint/command separation.

## Executed verification

| Check | Result | Limits |
|---|---|---|
| Full backend suite | **84 Passed, 0 Failed** | Includes existing recovery baseline plus approved v2 behavior via actual enabled route exports and a separately tested disabled gate; not an accuracy/usability study |
| Production build / TypeScript | **Passed** | Both v2 and v3 routes compile; no cloud deployment |
| Built HTTP smoke | **Passed** | Root/health/v2 catalog/v3 catalog: 200 JSON; both progress routes without bearer: 401; v3 active coverage limited to the approved screening scope |
| Actual embedded PostgreSQL migration/RPC | **Passed** | New nested topic history persists under existing owner/revision constraints; duplicate/conflicting writes rejected; client roles denied |
| Final-item mathematical references | **Passed** | Each keyed answer satisfies both original equations; all alternatives checked for unique validity; not expert pedagogical acceptance |
| Final scoring boundaries | **Passed** | Every score 0–5; 0–2 Not Passed, 3–5 Passed; no concept state inferred |
| Persistence / transitions | **Passed** | Save/resume after every primary/final item, interrupted recovery, incomplete final resume, failed saves, invalid/stale commands, independent guest context and legacy-reset preservation |
| AI / evidence guards | **Passed** | Literal Q3 evidence rechecked offline, uncertainty cannot be overridden, fabricated labels/quotes rejected, deterministic hint fallback and no help during independent work |
| Proposed GAM rules | **Passed in backend fixtures** | Existing baseline remains tested; new projection retains concept-only result recognition and branch-aware stage counts; UI not executed |
| Swift package / simulator / device | **Not Run** | Xcode/Swift runtime unavailable in this Windows workspace; tests prepared in existing Mac CI workflow |
| VoiceOver / Dynamic Type / responsive visual QA | **Not Run** | Source uses existing brand components and accessible labels; source review is not runtime verification |
| Expert math/pedagogy and diagnostic accuracy | **Untested** | Engineering reference checks do not establish diagnostic validity, comprehensibility, causal learning gains or mastery |
| Bank/policy activation | **Approved for implementation; enabled locally** | Explicit user reply received; expert acceptance and production rollout remain separate |

## Copy and documentation

New copy is recorded by stable `v2.*` IDs in the [copy bank](../design/ux-writing-copy-bank.md), editorial **REVIEW_NEEDED**, safe drafts/conditions distinguished. Existing approved input/submit and recovery labels are reused. No blocked all-correct placeholder is shipped. Backend semantics/leakage checks pass; proposed UX-writing runtime/comprehension scenarios remain **NOT RUN**. [API contract](../../backend/docs/API-V3.md) covers commands, persistence, gates, model use and testing setup.

Remaining work: run Mac package/simulator/device and UX checks; review content with a domain expert; explicitly deploy/verify the new API before switching the default distributed app. A 500-event technical bound preserves history and refuses further writes; longer-session archival/continuation is an operational extension, not silently implemented history deletion.

## Approval activation follow-up

The user selected “Use the proposed bank and rules.” Enabled the exact reviewed bank and maximum-one-probe policy locally; canonical per-concept outcomes and the all-correct mapping are included in that implementation decision. The full 84-test backend suite passed again through the actual enabled route exports, production build/TypeScript passed, and built HTTP smoke verified the active reviewed catalog, unavailable learning restrictions and 401 authentication guards for both API versions. The separately injected disabled-gate test still passes. The default Swift API and production hosting remain unchanged pending rollout; Mac/device and expert accuracy/pedagogy checks remain unrun.

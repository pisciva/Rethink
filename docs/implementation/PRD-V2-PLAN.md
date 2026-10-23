# PRD v2 implementation plan and proposed operational rules

Current execution: [PRD-V2-EXECUTION.md](PRD-V2-EXECUTION.md). **APPROVED FOR IMPLEMENTATION** by the user on 23 October 2026: “Use the proposed bank and rules.” The bank, conservative per-concept policy, all-correct mapping and one curated follow-up maximum below are enabled locally. Expert pedagogical/accuracy acceptance remains separate.

Source: `origin/main` at `d107a04`, including PRD v2 migration commit `ff9818c`; unchanged local DOCX in `docs/source/v2/`. The user requested pulling the latest PRD and implementing missing features on 23 October 2026. This authorizes the v2 scope over the earlier single-blocker/three-question scope; it does not supply missing mathematical assets or empirical acceptance.

## Source reconciliation

The DOCX §4.2 requires ten primary questions, per-concept synthesis and separately identified bounded follow-up; §4.3 requires a separate five-question final assessment, 3/5 pass, retry and preserved attempts. It explicitly leaves final item assets and certain decision rules unspecified. Incoming derivative files still contain v1 paragraphs (including three outcomes and open issues already resolved for the previous implementation). The DOCX and explicit later user decisions take precedence; archival sources remain unchanged.

Keep the current deployed v2 API and valid saved recovery evidence available. Introduce a separate PRD v2 journey/API with versioned event replay and separately versioned persistence, rather than reinterpreting existing attempts. Do not import unrelated remote frontend edits or restore the removed legacy backend.

## Prioritized vertical slices

1. Persist a topic journey with revision checks, exact replay, isolated owner access and explicit reset. Preserve all final-assessment attempts separately from recovery reset.
2. Serve ten versioned diagnostic items, attribute each observation only through its own rubric, emit per-concept evidence/coverage/priority/availability and project them to the map.
3. Support open choice of the one available learning package, preserve confirmed recovery vs optional review, retain active practice and the existing retry/transfer state matrix.
4. Provide progressive, curated Socratic prompts only within learning, with no answer delivery, diagnosis feedback or independent-assessment help. Treat AI as optional bounded selection/advice; never accept arbitrary generated explanations as mathematical truth.
5. Serve a distinct five-item final assessment after diagnosis; 3/5 pass; retry after failure; preserve attempts and independent concept states.
6. Wire Swift models, API, screens and regression fixtures; record Mac/device checks separately from executed backend checks.

## Bank — approved for implementation

Existing Distributive Property Q1–Q3 and learning/retry/transfer assets are retained. Added items are user-approved engineering assets, not an expert-approved bank.

| Primary | Task | Reference | Attributable concept / known error |
|---|---|---|---|
| Q1 | Existing SPL expansion MCQ | A: `3x+6+y=15` | Distribution context; B omits constant multiplier |
| Q2 | Expand `4(x+3)` | `4x+12` | Distribution; `4x+3` |
| Q3 | Explain multiplier in `5(x+2)` | Existing quoted bounded rubric | Distribution; existing known-error and uncertainty guards |
| Q4 | Simplify `2x+3x` | `5x` | Like terms; `5x^2` as an explicit MCQ distractor |
| Q5 | Simplify `4x+2+3x` | `7x+2` | Like terms; `9x` as an explicit MCQ distractor |
| Q6 | Solve `x+4=9` | `5` | Inverse/equality; `13` |
| Q7 | Equivalent step for `x-3=8` | Add 3 to both sides | Inverse/equality; add only to left |
| Q8 | Evaluate `-3+5` | `2` | Signed numbers; `-8` |
| Q9 | Evaluate `2-(-4)` | `6` | Signed numbers; `-2` |
| Q10 | Translate two quantities totaling 10, first exceeds second by 2 | `x+y=10; x-y=2` | Representation; one item cannot establish adequate diagnostic coverage |

Q1–Q3 keep distinct expressions; later items do not reveal their answers. Concept tags are metadata; attribution is explicit, never copied to every tag.

| Final item | SPL task | Correct result |
|---|---|---|
| FA1 | `x+y=7; x-y=1` | `(4,3)` |
| FA2 | `2x+y=11; x-y=1` | `(4,3)` |
| FA3 | `3(x+1)+y=14; x+y=7` | `(2,5)` |
| FA4 | `x+y=2; x-y=-6` | `(-2,4)` |
| FA5 | Two notebooks and one pen cost 11 units; one notebook and one pen cost 7 | Notebook 4, pen 3 |

Use MCQ answers for the final assessment to avoid inventing a new multivariable free-response parser. All five responses are collected before score disclosure. No concept-level observations are inferred from these scores.

## Evidence and probe rules — approved for implementation

- Keep the previously approved guarded system authority and bounded Q3 AI advice. No calibrated confidence or AI-selected final diagnosis.
- For each adequately covered candidate: two different direct items with matching rubric-specific error evidence and no correct counterevidence → Supported; at least two direct correct observations and no supporting error evidence → Not Supported; mixed sufficient supporting/correct evidence → Uncertain; otherwise → Insufficiently Assessed. A wrong answer outside its known-error rubric is insufficient evidence, not a supported blocker.
- The SPL target item is contextual evidence and counterevidence for distribution; it cannot alone confirm a blocker. Preserve the current distribution policy's correct-target counterevidence guard.
- Optional follow-up is limited to one retained curated distribution trace with a separate `probe-*` ID, only after Q1–Q10 when distribution evidence has a named unresolved gap. This is the user-approved deployment budget, not a number claimed from the v2 source. No unconstrained generated probes. Always terminate afterward, even if inconclusive.
- An all-correct run reports Not Supported for adequately covered concepts and Insufficiently Assessed for the one-item representation screen; no SPL mastery. The user approved this extension of the prior all-correct implementation decision for the new bank.
- Optional Review still ends without concept validation. Topic Final Assessment is available separately after diagnosis regardless of blocker recovery completion.

## Verification and rollout

Implementation decision received: the user approved the exact assets/rules above. The source-controlled bank gate is enabled locally; rollout still requires deployment and client/device verification. Independent expert mathematical/pedagogical acceptance remains distinct. Test all scoring thresholds, interruption/resume at every item, duplicates/conflicts, invalid/unknown fields, unsupported input, separate assessment history, recovery reset, AI failures, answer leakage and owner isolation. No learner study or iOS runtime claim from backend tests.

## Persistence design clarification

The new session uses an event-replayed `prdV2` field inside the existing service-only `learning_journeys.session` JSON object. The original version-2 recovery fields are preserved. Both APIs share the existing owner/revision check, so cross-client writes conflict instead of silently overwriting evidence. A legacy recovery reset preserves the v2 topic-assessment history. No database schema change or new database credential is required.

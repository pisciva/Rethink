# PRD v2 API (HTTP v3)

**Status:** implemented locally; the user approved the bank and rules on 23 October 2026 (“Use the proposed bank and rules”). `BANK_APPROVED` in `src/prdv2/content.ts` is true. Expert pedagogical/accuracy acceptance remains separate. This is a source-controlled release gate, not a request parameter or publicly writable flag. No new production deployment is claimed. Existing `/api/v2/*` continues to serve the previously approved recovery flow.

PRD v2 is the product version; `/api/v3` is the new HTTP contract. These version numbers serve different purposes.

## Catalog

`GET /api/v3/catalog` is public. The response retains the subject/topic/concept structure expected by Swift and adds the candidate prerequisite concepts. Capabilities and active coverage reflect the content gate. Representation has only one screening item and is never advertised as adequately supported diagnosis. Only distribution has a complete learning and concept-validation package.

## Owner-scoped progress

`GET /api/v3/progress` and `POST /api/v3/progress` require a valid Supabase bearer token. The response envelope has `version: 3`, `revision`, `updatedAt`, `resetRequired: false`, optional feedback and `journey`. While gated, authenticated requests return 503 with `code: content_review_required`; unauthenticated requests return 401.

The response journey preserves common Swift presentation fields and adds:

- `diagnosticResults`: concept identity, evidence status, coverage, recommendation priority, learning availability and independently validated learner state. Empty during diagnostic collection.
- `finalAssessment.attempts`: stable attempt number, start/completion timestamps, answered count, score and Passed/Not Passed result. Score/result stay null until all five responses are evaluated.
- `hints`: approved progressive questions for the current learning stage. No independent-assessment hints.

Available commands below carry an integer `expectedRevision`. Unknown fields are rejected; clients cannot supply observations, scores, diagnosis, hint IDs or learner states.

| Action | Additional fields | Gate |
|---|---|---|
| `select-topic` | `topicId: "spl"` | Entry only |
| `submit` | `questionId`, `answer` | Current item only; no ambiguous math guessed as a failure |
| `start-learning` | `conceptId: "distribution"` | Diagnosis complete; preserve confirmed recovery vs optional review |
| `advance` | None | Visual → Worked → Practice only |
| `show-results` | None | After diagnosis; pauses learning, preserves it for resume |
| `start-final-assessment` | None | Diagnosis complete; resumes an incomplete attempt or starts a retry after Not Passed; unavailable after Passed |
| `request-hint` | Optional `message` (maximum 500 characters) | Visual/Worked/Practice only, at most three curated hints per stage/cycle |
| `restart-diagnosis` | None | Explicit new diagnosis/recovery context; retains all topic-assessment attempts and original event history |

Primary diagnosis is exactly ten items. One curated distribution probe may follow if the approved implementation rule identifies insufficient distribution evidence; it has a separate ID and a logged gap condition. This is a user-approved deployment rule, not a probe budget claimed from the PRD source. Unsupported or mixed evidence does not automatically support a blocker.

Concept validation retains Independent Retry → conditional Transfer. Starting/revisiting learning cannot create or erase the last valid C5 result; only new valid concept validation or an explicit diagnosis restart changes that projection. The current learning cycle is separate from the last validated concept state. Optional Review ends without concept validation. The independent topic assessment remains available after diagnosis without requiring all learning.

## Persistence and integrity

The event-replayed PRD v2 session is stored in `learning_journeys.session.prdV2`; the original version-2 recovery fields remain intact. It uses the existing service-only table and atomic revision-checking RPC. No migration is required. All APIs share the revision, so concurrent legacy/new clients must reload on 409 rather than overwrite evidence. The legacy reset handler preserves the topic history.

Events record server timestamps, question IDs and submitted evidence. Q3 Gateway interpretation stores its bounded supporting quote; replay verifies it without calling a model. Hint events store an approved hint ID/source, not arbitrary generated text or the learner's freeform help message. Unknown event fields, incompatible bank versions, impossible event order and invalid quoted advice fail closed. A corrupt topic history is not silently reset or regraded.

There is a 500-event technical bound; exhaustion does not assign a learner result or erase history. An operator-reviewed archival/continuation strategy is needed before supporting sessions beyond that limit.

## Model transport

The existing `AI_GATEWAY_MODEL` configuration remains shared by unclear Q3 interpretation and optional contextual hint selection. The Gateway may select an allowed curated hint; it cannot generate student-visible mathematical answers, assign outcomes or access Independent Retry/Transfer/final-assessment questions. Invalid, malicious, out-of-context, truncated or unavailable model output uses the deterministic current-stage hint. No automatic model/key fallback.

## Swift integration

Use `RETHINK_PRD_V2=1` in the Xcode Run scheme when testing against a deployed or local enabled v3 backend. The default remains the current working v2 API until the new backend is deployed and rollout is verified. `APIClient` chooses the matching catalog/progress endpoints and emits the appropriate command schema. No server secret belongs in Swift. New final-result/evidence/hint models and screens are present; Mac package/simulator/device/accessibility checks are not executed in this Windows workspace.

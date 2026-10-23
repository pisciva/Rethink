# Swift recovery API contract

The `/api/v2` paths preserve the existing Swift client contract. The active service contains only the documented recovery MVP. Responses are not cached.

| Method | Path | Authentication | Purpose |
|---|---|---|---|
| GET | `/` | Public | Service identity and available endpoints. |
| GET | `/api/health` | Public | Configuration presence, not live readiness. |
| GET | `/api/v2/catalog` | Public | Algebra → SPL, supported Distributive Property and unavailable represented topic. |
| GET | `/api/v2/progress` | Supabase bearer | Owner's journey/revision or explicit restart requirement. |
| POST | `/api/v2/progress` | Supabase bearer | Apply one server-validated command. |

The app creates/restores its Supabase guest session directly, then sends `Authorization: Bearer <access_token>`. Native requests omit Origin. Progress requires authentication regardless of Origin.

## Commands and results

```json
{"concept":"distribution","action":"select-topic","topicId":"spl","expectedRevision":0}
```

```json
{"concept":"distribution","action":"submit","questionId":"distribution-q2","answer":"4x+12","expectedRevision":2}
```

Every command requires concept, action and the current integer expectedRevision. Other allowed fields are topicId for selection and questionId/answer for submission. Unknown fields (including grade, moduleId, mastery, learnerState or diagnosis) are rejected. The server never accepts client-assigned assessments.

Other phase-gated actions: start-recovery, start-review, advance, reinforce, reset. start-validation remains recognized but unavailable; the existing draft completion rule opens retry automatically after eligible confirmed recovery. Optional review does not open validation.

Successful responses contain version 2, revision, updatedAt, resetRequired and journey. Journey fields retain the Swift Codable contract: version, contentVersion (`spl-distribution-draft-3`), concept, selectedTopic, phase, origin, currentQuestion, learningContent, diagnosticOutcome, learningCompleted, learnerState, resultExplanation, availableActions, attempts, map, operationalStatus and optional presentation. POST may include fixed data-bound feedback after persistence acknowledgement.

Public attempts contain only questionId, role, raw answer and timestamp. Internal observations, evidence directions, interpretation sources and answer keys are withheld from live feedback. Map only projects C3/C5 results.

## Error and resume contract

| Status | Meaning |
|---|---|
| 400 | Invalid command/fields/JSON/topic/input; submission codes distinguish stale_question, expanded_form_required, invalid_answer, attempt_limit and invalid_transition. |
| 401 | Missing/invalid/expired Supabase token. |
| 403 | Disallowed browser Origin/preflight. |
| 409 revision_conflict | Reload state/revision before continuing. |
| 409 reset_required | Explicit restart required; no silent regrading. |
| 413 | Body over 4,096 bytes. Math answer limit 160 characters, Q3 explanation 1,200. |
| 503 | Account/storage outage or failed save; not a failed math evaluation. |

For an obsolete or inconsistent row, GET returns journey:null, resetRequired:true and the current revision. No read rewrites it. Continuation fails with reset_required; successful explicit reset advances revision and starts an empty journey. No automatic legacy-data merge occurs. After a save failure, reload to establish whether an answer was persisted before resubmission.

## Product gates

Q1 SPL MCQ → Q2 expression → Q3 reasoning → at most one conditional Q4. Approved revised items: Q2 `4(x+3)`; Q3 explanation of `5(x+2)` without its expansion. The user approved the current authority split, curated bank and operating rules for this implementation on 23 October 2026; expert pedagogical/rubric acceptance remains separate.

Confirmed recovery and optional review share Visual → Worked → Active Practice. C4 completion alone never creates a learner state. Eligible recovery opens scaffold-free retry, then materially different transfer only after successful retry. C5 states are scoped only to Distributive Property. All-correct diagnosis now returns Rejected for the examined blocker, permitting optional review or catalog continuation without a mastery claim (approved OI-03). Optional review ends without validation (approved OI-02). OI-01 and OPS-01..05 implementation choices were explicitly approved by the user. See [decisions](../../docs/decisions.md).

## Evidence-backed presentation extension

`journey.presentation` adds read-only `stages`, `activity`, `context`, `validation` and `achievement` fields. Older clients may ignore them; the updated Swift decoder treats the extension as optional. Stage states describe workflow/activity, never mastery percentages. Q4 retains a separate additional-probe count; Optional Review marks validation not applicable.

The `validation` summary is present only at a valid final C5 result, with retry `passed`/`not-passed` and transfer `passed`/`not-passed`/`not-administered`. A retry failure never reports a failed transfer. Summary selection uses the current validation cycle after the latest successful practice, excluding earlier reinforcement evidence.

`achievement` is null except for a consistent confirmed-recovery Understood result supported by successful Retry and Transfer. It contains stable `id`, `concept` and `earnedAt`; it is reconstructed from persisted evidence and repeated reads perform no reward write, notification or new issuance. It is a current-result recognition, not a permanent award ledger or future mastery promise. Reset/reinforcement removes the current projection when applicable.

Current `operationalStatus` and catalog `contentStatus`: `implementation-approved-expert-review-pending`. Item content version stays `spl-distribution-draft-3` because expressions have not changed. Previously stored all-correct pending histories fail consistency replay under the newly approved outcome policy and require explicit reset; they are not silently regraded. Other compatible histories continue to resume. At the 100-attempt technical boundary, submissions return `attempt_limit`, current `availableActions` includes `reset`, and the UI offers explicit restart.

# Rethink learning API v2 — Swift integration contract

This is the additive backend contract for the approved Algebra → SPL → Sifat Distributif MVP. `/api/*` without `/v2` remains the website's legacy API. V2 does not copy or alter legacy progress. Question content and operational rules are **draft**, pending the product/mathematics decisions named below.

## Set up and deployment

1. Apply existing migrations `202610170001` and `202610170002`, then `202610220001_spl_recovery_journeys.sql`. The new table is separate from `learning_progress` and has service-only reads/writes plus atomic revision checks.
2. Deploy the backend with `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `SUPABASE_SECRET_KEY` and `ALLOWED_ORIGINS` as in `SETUP.md`. The Swift app uses the same Supabase project and sends its access token to the backend. It never embeds the secret key. The existing AI Gateway may advise on otherwise unclear Q3 reasoning, but the bounded system rule still decides the diagnostic result while OI-01 remains open.
3. Update website clients separately before retiring v1. There is no automatic merge between anonymous, legacy and v2 sessions.

No migration was applied to a live Supabase project by this repository change.

## Endpoints

| Endpoint | Access | Purpose |
|---|---|---|
| `GET /api/v2/catalog` | Public | Subject, supported/unavailable topic, per-capability availability, concept relationship and draft content status. |
| `GET /api/v2/progress` | Supabase Bearer token | Current public journey and revision. An unused account receives revision `0` in `entry` phase; no question is administered yet. A stored session that cannot be validated (for example after a content-version change) returns `resetRequired: true` with `journey: null`. |
| `POST /api/v2/progress` | Supabase Bearer token | Apply one server-validated learning command and return the saved public journey. When `resetRequired` is true, only `reset` is accepted. |

Send `Content-Type: application/json` and `Authorization: Bearer <access_token>`. Native Swift requests omit `Origin`. All responses use `Cache-Control: no-store` through the CORS wrapper. Catalog entries expose `capabilities` per topic and concept (`diagnosis`, `guidedLearning`, `validation`) so clients do not infer support from graph presence alone.

Select the supported topic first:

```json
{ "concept": "distribution", "action": "select-topic", "topicId": "spl", "expectedRevision": 0 }
```

That returns revision `1` and Q1. A represented unavailable topic such as `quadratics` cannot be selected. Example Q1 submit:

```json
{
  "concept": "distribution",
  "action": "submit",
  "expectedRevision": 1,
  "questionId": "spl-q1",
  "answer": "B"
}
```

Other actions omit `questionId` and `answer`: `start-recovery`, `start-review`, `advance`, `reinforce`, `reset`. Only actions listed by `journey.availableActions` should be shown as primary UI choices; `reset` is an explicit restart operation and is the only command accepted when `resetRequired` is true. `start-validation` is currently never eligible after Optional Review. The server checks every action regardless of client UI.

When a stored session is invalid or uses an older `contentVersion`, `GET` returns:

```json
{ "version": 2, "revision": 3, "journey": null, "updatedAt": "2026-10-18T00:00:00Z", "resetRequired": true }
```

Send `{ "concept": "distribution", "action": "reset", "expectedRevision": 3 }` to create a fresh journey. Other actions return `409` with `code: "reset_required"`.

Example response shape:

```json
{
  "version": 2,
  "revision": 2,
  "updatedAt": "2026-10-18T00:00:00Z",
  "resetRequired": false,
  "journey": {
    "version": 2,
    "contentVersion": "spl-distribution-draft-2",
    "concept": "distribution",
    "selectedTopic": "spl",
    "phase": "diagnosis",
    "origin": null,
    "currentQuestion": {
      "id": "distribution-q2",
      "role": "q2-application",
      "prompt": "Hilangkan tanda kurung dan tuliskan bentuk aljabar yang setara.",
      "math": "3(x + 2)",
      "format": "expression"
    },
    "learningContent": null,
    "diagnosticOutcome": null,
    "learningCompleted": false,
    "learnerState": null,
    "resultExplanation": null,
    "availableActions": [],
    "attempts": [{ "questionId": "spl-q1", "role": "q1-target", "answer": "B", "at": "2026-10-18T00:00:00Z" }],
    "map": { "explore": "spl", "focus": null, "progress": null },
    "operationalStatus": "draft-ops-01-05"
  }
}
```

The response does not expose answer keys, live diagnostic correctness, provisional hypotheses or error-pattern classifications. `currentQuestion` contains the item to render, including Q1 options. `learningContent` contains a structured visual model or explained worked steps only in the corresponding learning phase. A diagnostic submit returns generic saved feedback without correctness; guided practice can return draft process feedback. Use the returned `revision` for the next command and wait for the response before showing a save as complete.

## Phase and evidence rules

- `entry`: topic orientation only. `select-topic` for SPL starts the supported diagnosis; unavailable topics cannot start it.
- `diagnosis`: Q1 multiple choice in SPL → Q2 short mathematical response → Q3 short explanation. If evidence remains insufficient or conflicts, exactly one Q4 procedural trace may follow. No repeated probe loop.
- `diagnostic-decision-pending`: all three core responses correct. OI-03 has no approved outcome or continuation; no diagnosis or mastery is invented.
- `diagnostic-result`: `confirmed`, `rejected` or `uncertain` from a **draft conservative rule**. Confirmed can `start-recovery`; non-confirmed can `start-review` while retaining its original status.
- `visual` → `worked` → `practice`: fixed curated sequence. Practice requires a valid student mathematical response. `learningCompleted` remains false until the draft completion rule is met. Correct practice advances confirmed recovery to `retry`; Optional Review ends at `review-complete` with no validation and no implication that validation will follow. This completion criterion is draft OPS-02.
- `retry`: valid unsuccessful result ends at `validation-result` with `needs-reinforcement`; valid success opens `transfer`. `transfer` failure gives `procedural-only`, success gives `understood`. These C5 states refer only to assessed Sifat Distributif tasks.
- `map.explore` is topic orientation; `map.focus` appears only after confirmed C3; `map.progress` projects only a current `validation-result` C5 state. Guided Learning completion alone never writes understanding, and re-entering learning clears the projected progress state while retaining raw attempts.
- Changing `CONTENT_VERSION` or an item ID invalidates older stored journeys by design. The API returns `resetRequired: true` rather than silently rewriting evidence; the client must explicitly reset.

Invalid, missing, stale-question or mathematically uninterpretable submissions return `400` without adding evidence. The response includes a `code`: `stale_question`, `expanded_form_required` (the answer is mathematically readable but not in the requested expanded form), `invalid_answer`, or `invalid_transition`. `401` means missing/invalid/expired token. `409` with `code: revision_conflict` means refetch and review the newest state before another command; `code: reset_required` means the stored session must be reset. `503` means account/storage is unavailable. A successful save returns `200` and the new revision.

The API stores raw responses plus an internal per-attempt evidence category and direction for auditability; the public projection does not expose answer keys, `observation`, or internal evidence directions.

## Open product and review gates

- **OI-01:** final responsibility split between mathematical evaluation, AI interpretation and diagnostic policy remains open. V2 uses an explicit draft rule for the result. Gemini can advise only on otherwise unclear Q3 reasoning; its quote must match the submitted answer and meet a narrow mathematical guard. Invalid output, missing configuration or provider failure remains insufficient evidence. This temporary implementation does not close OI-01.
- **OI-02:** the product has directed a temporary gate: Optional Review cannot access C5. This does not settle a permanent post-review learner-state policy.
- **OI-03:** all-correct remains pending with no invented mapping.
- **OPS-01/02/03/04/05:** feedback, completion, invalid/equivalent response handling, mathematical assets/rubrics and cross-capability transitions need review. `spl-distribution-draft-2` and `draft-ops-01-05` make this visible in the API.

Before release as a validated assessment, review the Q1–Q4 items, explanatory rubric, C3 decision table, Guided Practice feedback/completion, and C5 invalid-input handling with the product and mathematics owners. Tests prove the implemented draft behavior; they do not approve these rules or establish learning effectiveness.

## Algebra curriculum hierarchy — 19 October 2026

`GET /api/v2/catalog` now adds `subjects[].subtopics` without changing existing `topics[]`, IDs, or the v1 API. The `algebra` subject is labelled Aljabar and contains six branches, each with four leaves:

```text
subjects[algebra]
  subtopics[algebra-foundations]          Fondasi Aljabar
    subtopics[variables-expressions]     Variabel & ekspresi
    subtopics[inverse]                   Operasi invers
    subtopics[distribution]              Sifat distributif
    subtopics[like-terms]                Suku sejenis
```

The other branches are `linear-equations`, `functions-relations`, `polynomials-quadratics`, `exponents-rational`, and `advanced-algebra`. Leaves have `kind: sub-subtopic`; branches have `kind: subtopic` and `availability: navigation-only`. Branch capability flags are unavailable because branches themselves cannot start assessment.

Only `spl` and `distribution` retain active draft capabilities, with `entryTopicId: spl`. Other leaves have `availability: unavailable`, `contentStatus: represented-only`, and all capabilities unavailable. In particular `inverse` from legacy v1 does not become active in v2 merely by appearing here.

`curriculumVersion: 1` and `curriculumRelationships[]` describe 30 `part-of` grouping edges. They are separate from the existing `relationships[]` prerequisite graph. `coverage.represented` now lists all 31 curriculum nodes; `coverage.activelySupported` remains SPL and distribution. No prerequisites, assessments, question banks, personalized mastery, or new recovery paths are inferred from this taxonomy.

This is a backend-only additive change; iOS needs a separate UI/model update to display the nested hierarchy. No database migration, server launch, deployment, or test execution was performed.

## Mathematics parent and future materials — 19 October 2026

Canonical hierarchy is now `disciplines[mathematics].materials[algebra].subtopics[].subtopics[]` (`curriculumVersion: 2`). Existing `subjects[algebra]` remains a compatibility projection. The grouping graph adds Aljabar → Matematika; represented coverage now has 32 nodes. Future materials belong alongside Aljabar, not underneath it.

Prepared migration: `supabase/migrations/202610190001_curriculum_hierarchy.sql` adds four FK-linked tables: `curriculum_subjects`, `curriculum_materials`, `curriculum_subtopics`, `curriculum_sub_subtopics`. It seeds Matematika, Aljabar, six branches and 24 leaves. Parent IDs are indexed; metadata is public-read through RLS, with writes restricted to service_role. Taxonomy tables intentionally carry no diagnostic authority or student evidence.

To add a future material: insert a material referencing `mathematics`, its subtopics, then its leaves. Keep IDs globally unique within each table. Update the static catalog in `lib/v2/curriculum.ts` as well until database-backed catalog loading is implemented. Currently `/api/v2/catalog` still reads curated TypeScript data; this migration does not automatically switch its data source. Apply the migration once, after previous migrations. It has NOT been applied to Supabase, executed, or deployed in this task.

## Grade 10 MVP catalog — 22 October 2026

Use `GET /api/v2/catalog` for the new experience. `grades[0].modules` contains the ten general grade-10 modules, with stable original curriculum IDs. Only `x-linear` is unlocked; its diagnostic topic ID is `spl`. Other modules have `locked: true`, a lock reason, unavailable capabilities and no entry command. Locked entries expose orientation metadata only, not lesson/checkpoint answer keys. `subjects` is a compatibility projection, not a separate learning catalog.

Selecting class 10 is catalog navigation and requires no personal learning judgment. Selecting SPL starts Q1 immediately: no foundation pretest or legacy completion is required. POST progress accepts only concept `distribution` and topic `spl`; optional `grade` and `moduleId`, if supplied, must be 10 and `x-linear`. Other modules cannot create a journey, even with a forged request. No generic checkpoint endpoint exists in v2.

Q1–Q3 are mandatory and at most one Q4 is issued. Confirmed recovery uses visual → worked → active practice → independent retry → transfer only on retry success. Optional review does not open validation. All-core-correct remains `diagnostic-decision-pending` under OI-03, with no mastery assigned. Validation states describe distributive property only. Learning Map is the `journey.map` projection, not a separate inference engine.

Q3 uses `lib/ai.ts` and the main backend's AI_GATEWAY settings. Only otherwise-insufficient explanations may receive bounded correct advice supported by a literal quotation. Failures fall back to insufficient evidence; AI cannot choose diagnosis or learner state. Historical Gemini evidence remains readable for compatibility.

Apply the new additive migration before deploying. It creates `learning_journeys` and its service-only revision-checked RPC; it does not copy legacy completion into recovery evidence. If the archive journey migration was already applied to this same database, the new migration preserves the existing table and replaces the RPC. All old curriculum/assessment/media endpoints remain legacy compatibility APIs with their previous behavior; they are not the new MVP access contract. New clients must use v2. Do not combine legacy checkpoint completion with v2 concept understanding.

Implementation includes ported engine and API regression cases, but no tests, server, build, live AI request, migration or deployment were executed for this revision, per user direction. Mathematical assets remain draft OPS-04. Swift UI integration is a separate task.

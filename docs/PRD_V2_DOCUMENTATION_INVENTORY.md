# Documentation Inventory and Classification

Audit date: 23 October 2026. Classification covers every Markdown/JSON/YAML/Mermaid documentation artifact under `docs/` and `backend/docs/`.

| File | Classification | Audit note |
|---|---|---|
| `docs/INDEX.md` | Updated | Active navigation; points to v2 and legacy boundaries. |
| `docs/PRD_V2_MIGRATION_CHANGELOG.md` | Updated | Migration history and gaps. |
| `docs/decisions.md` | Contains unresolved conflicts | v1 OI/OPS register retained; v2 note added. Reconcile before using as active policy. |
| `docs/design/DESIGN.md` | Active and aligned | Visual reference; not behavioral authority. |
| `docs/design/README.md` | Active and aligned | Design navigation/status. |
| `docs/design/UX-WRITING.md` | Active and aligned | Proposed copy governance; v2 behavior still wins. |
| `docs/design/gamification-acceptance-tests.md` | Historical/legacy | Proposed extension; not approved PRD behavior. |
| `docs/design/gamification-specification.md` | Historical/legacy | Proposed extension; not approved PRD behavior. |
| `docs/design/onboarding-acceptance-tests.md` | Historical/legacy | Proposed onboarding tests. |
| `docs/design/onboarding-audio-script.md` | Historical/legacy | Proposed audio content. |
| `docs/design/onboarding-specification.md` | Historical/legacy | Proposed activation layer. |
| `docs/design/ui-refresh-notes.md` | Historical/legacy | UI proposal, not v2 functional authority. |
| `docs/design/ux-writing-acceptance-tests.md` | Historical/legacy | Proposed copy tests. |
| `docs/design/ux-writing-copy-bank.md` | Historical/legacy | Proposed copy candidates/statuses. |
| `docs/implementation/FR-TRACEABILITY.md` | Updated | Complete 43-FR matrix plus legacy evidence. |
| `docs/implementation/SPL-CONTENT-REVIEW.md` | Contains unresolved conflicts | Draft Q1–Q3 content review; explicitly not v2 Q1–Q10 bank. |
| `docs/implementation/WORKSPACE-STRUCTURE.md` | Active and aligned | Repository structure; no product behavior authority. |
| `docs/prd/mvp-definition.md` | Updated | Active v2 behavioral summary. |
| `docs/prd/overview.md` | Contains unresolved conflicts | v1 product narrative; requires v2 positioning reconciliation. |
| `docs/prd/requirements.md` | Historical/legacy | 39-FR v1 archive, explicitly marked. |
| `docs/prd/README.md` | Updated | Active v2 PRD navigation. |
| `docs/prd/product-overview.md` | Updated | Extracted v2 product identity and principles. |
| `docs/prd/problem-and-users.md` | Updated | Extracted v2 problem/user evidence bounds. |
| `docs/prd/product-goals.md` | Updated | Extracted v2 goals and boundaries. |
| `docs/prd/diagnostic-requirements.md` | Updated | Canonical v2 diagnostic summary. |
| `docs/prd/learning-requirements.md` | Updated | Canonical v2 learning summary. |
| `docs/prd/validation-requirements.md` | Updated | Canonical v2 validation summary. |
| `docs/source/00-prd-consolidated-summary.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/01-product-overview.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/02-problem-statement.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/03-product-goals.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/04-product-scope-mvp.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/05-product-requirements-summary.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/06-product-requirements-detailed.md` | Historical/legacy | Archived 39-FR v1 source; not active v2 authority. |
| `docs/source/07-product-conceptual-architecture.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/08-product-roadmap.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/09-risks-and-dependencies.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/10-acceptance-governance.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/11-technical-overview.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/12-technical-components.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/13-technical-workflows.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/14-data-ai-methodology.md` | Historical/legacy | Archived PAPER methodology; not v2 behavior authority. |
| `docs/source/15-readiness-technical-governance.md` | Historical/legacy | Archived v1 source derivative; preserved unchanged. |
| `docs/source/SOURCE-MANIFEST.json` | Historical/legacy | Archive manifest. |
| `docs/superpowers/plans/2026-10-18-prd-mvp-integration.md` | Historical/legacy | Prior implementation plan; v1 assumptions retained as history. |
| `docs/technical/architecture.md` | Updated | Active v2 logical architecture and gap boundaries. |
| `docs/technical/README.md` | Updated | Active v2 technical navigation. |
| `docs/technical/diagnostic-engine.md` | Updated | Diagnostic orchestration and current gap. |
| `docs/technical/assessment-blueprint.md` | Updated | Q1–Q10 and final assessment boundary. |
| `docs/technical/ai-orchestration.md` | Updated | AI authority and Socratic safeguards. |
| `docs/technical/learning-engine.md` | Updated | Open learning and fixed package sequence. |
| `docs/technical/validation-engine.md` | Updated | Concept/topic validation separation. |
| `docs/technical/data-model.md` | Updated | Logical evidence/state contract. |
| `docs/technical/integration.md` | Updated | Cross-capability handoff contract. |
| `docs/technical/reliability-and-testing.md` | Updated | Verification boundaries. |
| `docs/design/design-principles.md` | Updated | v2 design principles. |
| `docs/design/diagnostic-flow.md` | Updated | v2 diagnostic UI behavior. |
| `docs/design/learning-map.md` | Updated | Explore/Focus/Progress projection. |
| `docs/design/guided-learning-flow.md` | Updated | Guided learning interaction. |
| `docs/design/socratic-tutor.md` | Updated | FR-C4-09 interaction contract. |
| `docs/design/validation-flow.md` | Updated | Concept and SPL assessment flows. |
| `backend/docs/API-V2.md` | Contains unresolved conflicts | Current implementation contract still documents Q1–Q4; must be updated to v2 target or explicitly labeled legacy implementation. |
| `backend/docs/assessment-api.openapi.json` | Contains unresolved conflicts | Legacy assessment API; not v2 final-assessment contract. |
| `backend/docs/chatbot-video-context.md` | Active and aligned | Contextual media assistant, separate from C4 Socratic tutor. |
| `backend/docs/complete-concept-media.md` | Active and aligned | Media implementation reference. |
| `backend/docs/curriculum-api.openapi.json` | Active and aligned | Curriculum API contract; no v2 diagnostic authority. |
| `backend/docs/deepseek-gateway-setup.md` | Active and aligned | AI transport/configuration; does not define product outcome authority. |
| `backend/docs/foundation-pretest.md` | Contains unresolved conflicts | Legacy 24-item foundation pretest; not v2 Q1–Q10 diagnostic. |
| `backend/docs/question-bank-curriculum-review.md` | Contains unresolved conflicts | Legacy/question-bank review; v2 coverage matrix missing. |
| `backend/docs/sma-curriculum-v2.md` | Active and aligned | Curriculum catalog, not diagnostic support. |
| `backend/docs/swift-team-demo.md` | Historical/legacy | Demo handoff; not v2 acceptance evidence. |
| `backend/docs/video-api.openapi.json` | Active and aligned | Video API contract. |
| `backend/docs/video-catalog.example.json` | Active and aligned | Video catalog example. |

## Required follow-up documentation

`backend/docs/API-V2.md`, `backend/docs/foundation-pretest.md`, `backend/docs/question-bank-curriculum-review.md`, and `docs/prd/overview.md` still contain active-looking v1 language. They need a separate contract update or a stronger legacy banner before being used by implementers. This audit does not silently rewrite implementation contracts.

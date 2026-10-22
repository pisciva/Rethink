# Diagnostic Requirements

**Source:** PRD v2 DOCX Section 4.2; Detailed Requirements FR-C3-01–FR-C3-10.

Diagnosis administers exactly ten curated primary questions, Q1–Q10, in the selected SPL context. Questions may carry multiple concept tags. Tags identify evidence opportunities, not automatic blockers. Each item requires role, format, observable evidence, counterevidence, attribution rule, rubric, and version metadata.

After Q1–Q10, bounded conversational follow-up may address a named information gap. Follow-ups use separate probe IDs, approved candidates or reviewed variants, non-leading prompts, mathematical safeguards, and a termination rule. Do not invent a universal probe count where the source leaves the operational budget open.

Synthesize evidence per concept. Report `Supported`, `Not Supported`, `Uncertain`, or `Insufficiently Assessed`. Keep evidence status separate from coverage, learning priority, learning availability, and concept learner state. Never emit arbitrary calibrated-confidence percentages.

Canonical requirement definitions live in [FR-TRACEABILITY](../implementation/FR-TRACEABILITY.md). Technical workflow: [diagnostic engine](../technical/diagnostic-engine.md).

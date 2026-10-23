# Diagnostic Engine

**Source:** PRD v2 Technical Blueprint; PRD v2 Detailed Requirements FR-C3-01–FR-C3-10.

Diagnostic orchestration initializes selected SPL context, serves Q1–Q10, evaluates response evidence, synthesizes evidence per concept, optionally requests a bounded follow-up, and produces per-concept statuses plus learning recommendations.

Separate raw response, mathematical observation, interpretation, evidence status, coverage, priority, availability, and learner state. A concept graph limits candidates; graph presence does not prove a learner blocker. Current `backend/lib/v2/engine.ts` implements the earlier single-concept Q1–Q3/Q4 journey and is therefore partial against this target.

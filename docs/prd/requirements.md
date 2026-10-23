# Legacy v1 requirements archive

> This file preserves the repository's original 39-FR PRD v1 derivative for implementation history. It is **not** the active PRD v2 requirements authority. PRD v2 has 43 approved functional requirements, Q1–Q10 multi-concept screening, bounded follow-up probes, contextual Socratic assistance, and a separate five-question SPL Final Assessment. See [`../PRD_V2_MIGRATION_CHANGELOG.md`](../PRD_V2_MIGRATION_CHANGELOG.md).

# Rethink — Approved Product Functional Requirements: Full 39-Item Registry

> **Scope and provenance:** This file retains the **source original language** of all 39 approved Must Have FRs from detailed source PDF pp. 58–84, with their source verification basis, dependencies and qualifications. Requirements are **approved behavioral obligations**—not implementation proof or approval of open operational choices. Page references use original PDF page indexes, not printed numbering. The archival transcription is at `../source/06-product-requirements-detailed.md` and original PDF at `../source/ReThink-Documentation-original.pdf`.

## 1. Requirement convention and governance

Every requirement in the source records (1) stable ID, (2) requirement statement, (3) priority, (4) decision status, (5) source/dependency, and (6) verification basis. All **39** listed items are `Must Have` and `Approved` at the **behavioral obligation level**, even where the wording explicitly states dependent implementation/acceptance rules remain unresolved. **Approved does not mean built, tested, or accepted.**

Other priority classes (`Should`, `Could`, `Won't — MVP`) are not authority to silently drop an approved item or add new features. Revisions that change observable product behavior require impact review, traceability and appropriate approval. Product design governs detailed UX; engineering design governs physical contracts; curated mathematics content must be separately reviewed.

### Inventory

| Group | Count | Stable identifiers | Scope |
|---|---:|---|---|
| C1 | 5 | FR-C1-01..05 | Catalog, topic availability/entry |
| C2 | 5 | FR-C2-01..05 | Map Explore/Focus/Progress and evidence integrity |
| C3 | 10 | FR-C3-01..10 | Q1–Q4 diagnosis and results |
| C4 | 8 | FR-C4-01..08 | Curated guided learning / completion |
| C5 | 8 | FR-C5-01..08 | Retry/transfer/learning status |
| X | 3 | FR-X-01..03 | Session continuity/transitions/consistency |
| **TOTAL** | **39** | **All source Approved + Must Have** | No sixth group |

**Conflict precedence:** Approved PRD and detailed FR statements first, proposed implementation choices later. Source wording below is evidence; do not treat any summarization as an amendment. Read `../decisions.md` for OI-01..03 and OPS-01..05. `FR-C3-07` does **not** preauthorize a specific all-correct outcome; `FR-C5-05` does **not** preauthorize a rule for unintelligible validation submissions.

## 2. Full functional requirement registry — source wording

## C1 — Learning Entry & Topic Discovery

C1 owns topic access, discovery, availability and eligible entry; it cannot diagnose or infer mastery.

### FR-C1-01 — Mathematics Catalog Access

> **Source:** original PDF p. 61; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must provide a catalog-first entry that enables students to access and explore
represented mathematics subject areas.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved Section 4.1.2 — Supported Product Experience; C1 —
       Learning Entry & Topic Discovery; Catalog-First Entry Product Decision.
- Verification Basis: The mathematics catalog is accessible, and students can identify Algebra
       as a represented subject area.

### FR-C1-02 — Subject & Topic Discovery

> **Source:** original PDF p. 61; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must organize represented mathematics content by subject and topic, allowing students
to identify represented topics within the selected subject area.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved Sections 4.1.2 and 4.2.1; C1 — Learning Entry & Topic
       Discovery.
- Verification Basis: Students can identify Sistem Persamaan Linear within the Algebra subject
       area through the supported catalog structure.

The subject–topic hierarchy defines logical content organization and does not require separate
screens for every level.

### FR-C1-03 — Supported Content Availability

> **Source:** original PDF p. 61; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must distinguish topics with active MVP support from represented topics without active
support and communicate unsupported topics as unavailable.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C1; F2 — Explicit Concept Support Boundaries; Catalog
        Availability Product Decision.
- Verification Basis: Supported and unsupported topics have distinguishable availability
        states. Unsupported topics are communicated as unavailable rather than presented as
       accessible learning or diagnostic experiences.

Unavailable content must not be represented as locked because of the student's ability, progress, or
achievement.

### FR-C1-04 — Supported Topic Selection

> **Source:** original PDF p. 62; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must allow students to select Sistem Persamaan Linear as the supported MVP learning
topic and establish the selected topic as the mathematical context for the subsequent diagnostic
experience.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved Section 4.2.1; C1 — Learning Entry & Topic Discovery; C3 —
       Targeted Diagnostic Assessment & Outcomes.
- Verification Basis: Selecting Sistem Persamaan Linear establishes the intended topic
       context, and the subsequent supported diagnostic experience corresponds to that topic.

Topic selection does not independently establish Distributive Property as a confirmed conceptual
weakness or assign a learner understanding state.

### FR-C1-05 — Diagnostic Entry Eligibility

> **Source:** original PDF p. 62; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must permit diagnostic assessment initiation only for topics with active diagnostic
support and prevent represented but unsupported topics from  initiating an active diagnostic
session.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C1 and C3; F2 — Explicit Concept Support Boundaries; E1
    — Expanded Mathematical Coverage.
- Verification Basis: Sistem Persamaan Linear permits initiation of its supported MVP
       diagnostic assessment. Represented topics without active diagnostic support cannot initiate
      unsupported assessment.

Diagnostic entry eligibility depends on available diagnostic coverage, not catalog presence alone.

## C2 — Hybrid Learning Map

C2 renders curated relationships and C3/C5 evidence; it never creates diagnostic or learner-state judgments.

### FR-C2-01 — Curated Concept Relationship Representation

> **Source:** original PDF p. 63; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must represent curated mathematical relationships between the selected learning topic
and relevant concepts within the supported knowledge structure.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C2 — Hybrid Learning Map; Section 4.2.1; F1 — Reusable
      Concept Relationships.
- Verification Basis: The Learning Map represents the curated relationship between Sistem
      Persamaan Linear and Distributive Property without introducing unsupported or unverified
       prerequisite relationships.
Representing a concept does not establish active diagnostic coverage or prove that the student has
difficulty understanding it.

### FR-C2-02 — Explore Context

> **Source:** original PDF p. 64; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must provide an Explore context that enables students to understand the selected
mathematics  topic's  position  within the represented conceptual  structure before  individual
diagnostic evidence is available.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C2; Section 4.1.2; Hybrid Learning Map Product Decision.
- Verification Basis: Before diagnostic assessment, the map provides topic orientation and
       relevant curated conceptual relationships without assigning individual conceptual
      weaknesses or understanding states.

Explore complements rather than replaces the mathematics catalog.

### FR-C2-03 — Diagnostic Focus Representation

> **Source:** original PDF p. 64; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must communicate the conceptual focus supported by the applicable diagnostic
outcome produced by C3, while distinguishing confirmed conceptual blockers from non-confirmed
outcomes.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C2 and C3; Section 4.1.2; OI-03 — All-Correct Diagnostic
     Outcome Mapping.
- Verification Basis: A Confirmed diagnostic outcome identifies Distributive Property as the
      supported recovery focus. Rejected and Uncertain outcomes do not represent it as a
      confirmed conceptual weakness.

The map may identify the concept examined or available for Optional Concept Review without
implying confirmation.

Pending Dependency — OI-03: Formal mapping and map representation of all-correct diagnostic
response patterns remain unresolved. Such responses must not independently establish topic-level
mastery.

### FR-C2-04 — Validation-Based Progress Representation

> **Source:** original PDF p. 64; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement
The system must reflect applicable blocker-level learning outcomes produced by C5 following
supported Knowledge Validation.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C2 and C5; Section 4.3; F4 — Evidence-Bounded Learner
        State; OI-02 — Optional Review Learner-State Behavior.
- Verification Basis: Following applicable Knowledge Validation, the map reflects the resulting
      Understood, Procedural Only, or Needs Reinforcement outcome for the assessed Distributive
       Property concept.

The map must not assign understanding solely because Guided Learning has been completed.

Pending Dependency — OI-02: Applicability of validation and learner-state updates after Optional
Concept Review remains unresolved.

### FR-C2-05 — Assessment Coverage & State Integrity

> **Source:** original PDF p. 65; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must prevent mathematical concepts without applicable assessment evidence from
being represented as understood, misunderstood, or associated with a confirmed conceptual
blocker.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C2; F2 — Explicit Concept Support Boundaries; F4 —
      Evidence-Bounded Learner State; Section 4.1.3.
- Verification Basis: Unassessed concepts do not receive diagnostic or understanding states,
       regardless of their map presence or mathematical relationship to supported concepts.

A curated concept relationship must not independently count as evidence of student understanding
or difficulty.

## C3 — Targeted Diagnostic Assessment & Outcomes

C3 collects Q1–Q3 plus max one Q4 and returns constrained diagnosis / continuation.

### FR-C3-01 — Supported Diagnostic Context

> **Source:** original PDF p. 66; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must conduct diagnostic assessment in the context of the selected Sistem Persamaan
Linear topic and restrict active conceptual blocker evaluation to Distributive Property.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved Section 4.2.1; C3 — Targeted Diagnostic Assessment &
      Outcomes; F2 — Explicit Concept Support Boundaries; E1 — Expanded Mathematical
      Coverage.
- Verification Basis: A supported diagnostic session evaluates the Distributive Property
       blocker within the selected SPL context without generating unsupported additional blocker
       diagnoses.

Diagnostic coverage does not establish comprehensive SPL proficiency or assess every prerequisite
of SPL.

### FR-C3-02 — Core Diagnostic Question Blueprint

> **Source:** original PDF p. 66; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must administer the three approved core diagnostic questions according to their
assessment roles and response formats:

- Q1 — Target Performance: Multiple-choice question within SPL.
- Q2 — Prerequisite Application: Short mathematical response examining Distributive
       Property.
- Q3 — Conceptual Reasoning: Short explanation examining relevant mathematical
       reasoning.
- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved Section 4.2.2; C3 — Targeted Diagnostic Assessment &
      Outcomes.
- Verification Basis: Every supported core diagnostic assessment includes Q1, Q2, and Q3
       with their corresponding roles and response formats.

The three question roles provide complementary evidence. No single question is designated as
independently sufficient to confirm the supported blocker.

### FR-C3-03 — Student Response Collection

> **Source:** original PDF p. 67; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must collect responses to administered diagnostic questions using their supported
formats and preserve their association with the corresponding question role and mathematical
context for diagnostic evaluation.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C3; Section 4.2.2; F3 — Separable Assessment & Recovery
        Definitions.
- Verification Basis: Submitted responses to Q1, Q2, Q3, and any administered Q4 remain
        attributable to their correct question roles and relevant mathematical context.

This requirement does not prescribe database structure, mathematical normalization technology, or
assessment submission interface design.

### FR-C3-04 — Mathematical Evidence Evaluation

> **Source:** original PDF p. 67; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must evaluate individual diagnostic responses for applicable outcome, transformation,
and explanatory evidence relevant to the supported Distributive Property blocker.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved Section 4.2.2; C3; Evidence Before Inference product
        principle.
- Verification Basis: Individual responses are evaluated using their applicable evidence
       categories. An incorrect answer or isolated error observation is not independently treated as
        sufficient confirmation of a conceptual blocker.

Outcome evidence concerns answer correctness. Transformation evidence concerns observable
mathematical  operations.  Explanatory  evidence  concerns  student-provided  mathematical
reasoning.
Not every evidence category must be available for every question.

This requirement concerns the evaluation of observed responses, not cross-question synthesis or
final diagnostic authority.

### FR-C3-05 — Cross-Question Evidence Synthesis

> **Source:** original PDF p. 68; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must consider relevant supporting, contradictory, and insufficient evidence across
administered  diagnostic questions when  evaluating whether the supported blocker can be
confirmed, rejected, or remains uncertain.

- Priority: Must Have
- Decision Status: Approved — defined behavioral obligation only.
- Source / Dependency: Approved Section 4.2.3; C3; OI-01 — AI Methodology Alignment.
- Verification Basis: Reviewed diagnostic cases demonstrate that conflicting or insufficient
       observations are considered rather than automatically converting an isolated error into
       blocker confirmation.

The process distinguishes observations from diagnostic inference and does not automatically treat
multiple observations from one underlying response as independent evidence.

Pending Dependency —  OI-01:  Final  allocation  of  interpretive  and  diagnostic  decision
responsibilities among  AI,  mathematical  verification,  and  system-level  constraints  remains
unresolved.

### FR-C3-06 — Conditional Targeted Diagnostic Probe

> **Source:** original PDF p. 68; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must support a maximum of one conditional targeted diagnostic probe (Q4) when an
identified information gap requires additional relevant evidence.

The probe must use one approved form:

- Procedural Trace: Examines procedural steps or mathematical transformations.
- Conceptual Probe: Examines reasoning or conceptual understanding relevant to the
      suspected blocker.
- Priority: Must Have
- Decision Status: Approved — defined behavioral obligation only.
- Source / Dependency: Approved Section 4.2.2; C3; OI-01 — AI Methodology Alignment.
- Verification Basis: Supported sessions administer Q1–Q3 and no more than one Q4. Any
       administered Q4 uses one of the approved forms and addresses a relevant information gap.
Q4 is conditional, not mandatory. The maximum assessment length is four questions, with no
repeated probing cycles.

Pending Dependency — OI-01: Operational responsibilities for information-gap interpretation and
probe selection remain to be finalized.

### FR-C3-07 — Evidence-Grounded Diagnostic Outcome

> **Source:** original PDF p. 69; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must produce an applicable diagnostic conclusion about the supported Distributive
Property blocker using the approved categories:

- Confirmed: Evidence sufficiently supports the examined blocker under the applicable
       decision rules.
- Rejected: Evidence sufficiently does not support or contradicts the examined blocker under
       the applicable decision rules.
- Uncertain: Evidence does not justify reliable confirmation or rejection.
- Priority: Must Have
- Decision Status: Approved — defined behavioral obligation only.
- Source / Dependency: Approved Section 4.2.3; C3; OI-01 — AI Methodology Alignment;
      OI-03 — All-Correct Diagnostic Outcome Mapping.
- Verification Basis: Reviewed supported diagnostic cases produce conclusions consistent
       with available evidence and applicable decision rules. Insufficient evidence can result in
       Uncertain instead of unsupported confirmation.

Incorrect performance must not automatically establish a blocker. Correct performance or a
non-confirmed outcome must not establish comprehensive mathematical mastery or prove the
absence of other learning difficulties.

Pending Dependency — OI-01: Final operational decision authority and supporting mechanisms.

Pending Dependency — OI-03: Formal diagnostic outcome mapping for all-correct response
patterns. This requirement does not assign such patterns to Confirmed, Rejected, or Uncertain.

### FR-C3-08 — Bounded AI-Assisted Interpretation

> **Source:** original PDF p. 69; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must constrain AI-assisted diagnostic interpretation to the supported mathematical
concept, available student response evidence, and applicable mathematical and system-level
safeguards.

- Priority: Must Have
- Decision Status: Approved — defined behavioral obligation only.
- Source / Dependency: Approved C3; Bounded AI Autonomy product principle; E2 —
      Advanced Diagnostic Intelligence; OI-01 — AI Methodology Alignment.
- Verification Basis: Diagnostic interpretation does not independently activate unsupported
       blockers, disregard applicable mathematical constraints, or present unsupported inferences
       as established diagnoses.

AI-assisted interpretation may contribute to analyzing student reasoning and synthesizing evidence
within the approved boundaries.

The requirement does not authorize unrestricted diagnostic autonomy, arbitrary misconception
detection, or probabilistic mastery estimation.

Pending Dependency — OI-01: Detailed decision authority and operational acceptance criteria for
AI, mathematical verification, and system constraints remain unresolved.

### FR-C3-09 — Diagnostic Result Communication

> **Source:** original PDF p. 70; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must communicate the applicable diagnostic outcome, examined conceptual scope,
and  relevant  limitations  while  distinguishing confirmed blockers from  rejected or uncertain
interpretations.

- Priority: Must Have
- Decision Status: Approved — defined behavioral obligation only.
- Source / Dependency: Approved C3; Sections 4.1.2 and 4.2.3; OI-03 — All-Correct
       Diagnostic Outcome Mapping.
- Verification Basis: Supported Confirmed, Rejected, and Uncertain results are
        distinguishable, identify the examined scope, and do not make unsupported claims about
      SPL mastery, comprehensive diagnosis, or confirmed weakness.

Communication must remain consistent with the evidence-bounded diagnostic conclusion.

Pending Dependency — OI-03: The outcome-specific message and continuation meaning for
all-correct responses remain unresolved. No topic-level mastery conclusion may be inferred from
the all-correct pattern alone.

### FR-C3-10 — Outcome-Based Continuation

> **Source:** original PDF p. 70; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must provide an appropriate supported continuation following the applicable diagnostic
outcome without presenting a non-confirmed blocker as confirmed.

- Priority: Must Have
- Decision Status: Approved — defined behavioral obligation only.
- Source / Dependency: Approved Section 4.1.2; C3 and C4; OI-02 — Optional Review
       Learner-State Behavior; OI-03 — All-Correct Diagnostic Outcome Mapping where
       applicable.
- Verification Basis: A Confirmed outcome provides access to the supported Distributive
       Property recovery pathway. Rejected and Uncertain outcomes provide available
       topic-exploration or Optional Concept Review continuation without implying
       confirmed-blocker status.

Optional Concept Review may use the supported curated learning package but does not
retroactively confirm the blocker.

Pending Dependency — OI-02: Knowledge Validation eligibility and learner-state implications after
Optional Concept Review.

Pending Dependency — OI-03: Formal outcome-based continuation for all-correct response
patterns.

## C4 — Targeted Guided Learning

C4 presents curated learning content, active participation and completion, not validated understanding.

### FR-C4-01 — Supported Learning Package

> **Source:** original PDF p. 72; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must provide one curated conceptual learning package for Distributive Property within
the approved MVP mathematical scope.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved Section 4.2.1; C4 — Targeted Guided Learning; F3 —
       Separable Assessment & Recovery Definitions.
- Verification Basis: A complete curated Distributive Property package contains the
      supported Visual Explanation, Worked Example, and Partial Guided Practice components.

The requirement does not establish additional recovery packages, comprehensive SPL lessons, or
unrestricted content generation.

### FR-C4-02 — Recovery Entry Context

> **Source:** original PDF p. 72; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must distinguish access to the supported learning package through Confirmed blocker
recovery from access through Optional Concept Review following a non-confirmed diagnostic
outcome.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved Section 4.1.2; C3 and C4; OI-02 — Optional Review
       Learner-State Behavior.
- Verification Basis: Confirmed recovery retains the confirmed Distributive Property context.
       Optional Concept Review retains the non-confirmed diagnostic context without converting
       the originating diagnosis to Confirmed.

Both entry contexts may use the same curated package.

Pending Dependency — OI-02: Downstream Knowledge Validation eligibility and learner-state
implications after Optional Concept Review remain unresolved.

### FR-C4-03 — Visual Explanation

> **Source:** original PDF p. 72; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must provide a curated Visual Explanation that illustrates the conceptual meaning of
Distributive Property and the relevant relationships between its mathematical components.
- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C4; Section 4.3.
- Verification Basis: The explanation uses a mathematically valid conceptual representation to
     show how the distributive relationship applies, rather than presenting only a symbolic
       formula or memorized rule.

Specific presentation formats and example content belong in the supporting content and Product
Design specifications.

### FR-C4-04 — Worked Example

> **Source:** original PDF p. 73; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must provide a curated Worked Example demonstrating the application of Distributive
Property through mathematically valid transformations accompanied by explanations of meaningful
solution steps.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C4; Section 4.3.
- Verification Basis: The example presents a mathematically valid procedure and explains
       relevant transformations, linking conceptual representation with procedural application.

The example must not be limited to displaying the final answer without the reasoning needed to
understand the relevant steps.

### FR-C4-05 — Active Partial Guided Practice

> **Source:** original PDF p. 73; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must provide curated Partial Guided Practice that requires the student to supply
mathematical responses for selected incomplete steps or reasoning within a partially supported
solution.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C4; Section 4.3; Active Reasoning Over Answer Delivery
      product principle.
- Verification Basis: The student must contribute at least one mathematical response to a
      supported incomplete solution step or reasoning task. Merely viewing a completed worked
       solution does not satisfy this requirement.

The practice retains structured instructional assistance while requiring active participation.
Response  input, mathematical feedback, and correction mechanics belong in the applicable
operational and Product Design specifications.

### FR-C4-06 — Fixed Learning Sequence

> **Source:** original PDF p. 74; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must deliver the supported Guided Learning package in the approved instructional
order: Visual Explanation → Worked Example → Partial Guided Practice, without requiring adaptive
scaffold selection or dynamic instructional branching.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C4; Section 4.3; E3 — Adaptive Learning Orchestration.
- Verification Basis: The supported sequence presents the three instructional stages in the
      approved progression without dynamic recovery-path selection or learner-state-driven
       scaffold changes.

This does not prohibit ordinary navigation for reviewing previously presented content.

### FR-C4-07 — Learning Completion & Applicable Handoff

> **Source:** original PDF p. 74; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must distinguish completion of the supported Guided Learning sequence from
incomplete participation and make the applicable concept, learning-entry context, and completion
information available for subsequent product behavior.

- Priority: Must Have
- Decision Status: Approved — defined behavioral obligation only.
- Source / Dependency: Approved C4 and C5; Section 4.3; FR-C4-05; OI-02 — Optional
      Review Learner-State Behavior.
- Verification Basis: Completion is established according to the applicable instructional
      completion requirements, remains associated with Distributive Property and the original
       entry context, and supports Knowledge Validation continuation following completed
       confirmed-blocker recovery.

Completion information is not independent evidence of validated understanding.

Pending Operational Specification: Detailed Guided Practice feedback and completion rules,
including treatment of incorrect attempts, remain to be finalized.

Pending Dependency — OI-02: Optional Concept Review completion does not, by itself, establish
validation eligibility. Whether it may qualify under additional conditions remains unresolved.

### FR-C4-08 — Learning Outcome Claim Boundary

> **Source:** original PDF p. 74; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must not interpret participation in or completion of Guided Learning as independent
evidence that the student has demonstrated validated conceptual understanding.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C4 and C5; F4 — Evidence-Bounded Learner State;
       Validation Before Understanding Claims principle.
- Verification Basis: Completing the instructional sequence without applicable Knowledge
       Validation does not independently assign Understood, Procedural Only, or Needs
       Reinforcement.

This boundary applies to confirmed recovery and Optional Concept Review.

## C5 — Knowledge Validation & Learning Outcomes

C5 grades retry and conditional transfer and assigns scoped learner status; no new diagnosis.

### FR-C5-01 — Validation Context & Eligibility

> **Source:** original PDF p. 76; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must make Knowledge Validation available following completion of the supported
confirmed-blocker recovery pathway and associate validation with the applicable Distributive
Property concept.

- Priority: Must Have
- Decision Status: Approved — confirmed-recovery behavior only.
- Source / Dependency: Approved Section 4.3; C4 and C5; FR-C4-07; OI-02 — Optional
      Review Learner-State Behavior.
- Verification Basis: Completed confirmed-blocker recovery permits the corresponding
        Distributive Property validation. Topic selection or incomplete instructional participation
       alone does not establish validation eligibility.

Pending Dependency — OI-02: Validation eligibility after Optional Concept Review and resulting
learner-state applicability remain unresolved.

### FR-C5-02 — Independent Retry

> **Source:** original PDF p. 76; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must provide a curated Independent Retry requiring the student to apply Distributive
Property without instructional scaffolding, using a problem that preserves the learned mathematical
structure without reproducing the previously completed example.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C5; Section 4.3.
- Verification Basis: An eligible student attempts a relevant Distributive Property problem
       without visual instructional assistance, worked-solution guidance, or partially completed
       solution scaffolds. The item preserves the applicable mathematical structure while differing
      from the earlier example.

Successful  retry provides evidence  of independent  application  within the tested  task, not
independently demonstrated transfer.

### FR-C5-03 — Conditional Transfer Problem

> **Source:** original PDF p. 76; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must administer a curated Transfer Problem only after successful Independent Retry,
using a meaningfully different representation or context while preserving the mathematical concept
being validated.
- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C5; Section 4.3; E4 — Expanded Assessment & Monitoring.
- Verification Basis: Successful Independent Retry permits Transfer Problem; unsuccessful
        retry prevents its administration. The transfer task differs meaningfully from the retry and
      does not simply substitute numbers.

Repeated adaptive transfer-question loops are outside MVP scope.

### FR-C5-04 — Validation Response Evaluation

> **Source:** original PDF p. 77; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must evaluate each administered Independent Retry and Transfer Problem response
against applicable curated mathematical assessment criteria and produce the corresponding
item-level evaluation result for learner-state determination.

- Priority: Must Have
- Decision Status: Approved — defined behavioral obligation only.
- Source / Dependency: Approved C5; Section 4.3; bounded Knowledge Validation approach.
- Verification Basis: Supported, interpretable responses are assessed consistently against
        their mathematical criteria, and resulting item-level success or failure is available for
       learner-state determination.

This requirement evaluates responses; it does not assign learner states.

Pending Operational Specification — Validation Response Handling: Accepted mathematically
equivalent expressions, missing or incomplete responses, and uninterpretable submissions require
explicit evaluation rules.

Responses that cannot be evaluated must not automatically be treated as evidence of conceptual
misunderstanding without an applicable approved rule.

### FR-C5-05 — Evidence-Based Learner State Assignment

> **Source:** original PDF p. 77; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must assign the applicable blocker-level learner state using the following approved
Knowledge Validation rules:

   Independent     Transfer Problem     Learner State
       Retry

 Successful          Successful        Understood
 Successful          Unsuccessful       Procedural Only

 Unsuccessful       Not administered   Needs
                                      Reinforcement


- 
        Priority: Must Have
- Decision Status: Approved — supported validation path.
- Source / Dependency: Approved C5; Section 4.3; F4 — Evidence-Bounded Learner State;
      FR-C5-04; OI-02 where applicable.
- Verification Basis: Each approved combination of validly evaluated item results produces its
      corresponding learner state. Transfer is not administered after unsuccessful Independent
        Retry.

The mapping applies after the relevant validation-item outcomes have been validly established.
Missing or uninterpretable response handling remains subject to FR-C5-04's pending operational
criteria.

Learner states describe supported blocker-level performance and do not establish mastery of SPL.

Pending Dependency — OI-02: Whether this mapping is applicable following Optional Concept
Review remains unresolved.

### FR-C5-06 — Learning Outcome Communication

> **Source:** original PDF p. 78; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must communicate the applicable validation-based learner state and its meaning in
relation to demonstrated performance on Distributive Property without implying broader mastery
than the evidence supports.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C5; C2 — Hybrid Learning Map; Section 4.3; F4 —
      Evidence-Bounded Learner State.
- Verification Basis: Understood, Procedural Only, and Needs Reinforcement are
       distinguishable and explained consistently with applicable validation results.

The interpretations are limited as follows:

- Understood: Successful independent application and transfer within supported tasks.
- Procedural Only: Successful independent retry, without successful transfer in the
       administered task.
- Needs Reinforcement: Unsuccessful independent retry, with transfer not assessed.
Outcomes must not be communicated as comprehensive SPL mastery, permanent learning
classifications, or proof of long-term retention.

### FR-C5-07 — Outcome-Based Continuation

> **Source:** original PDF p. 79; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must provide continuation consistent with the applicable learner state, including access
to the existing  Distributive Property Guided Learning package when the outcome  is Needs
Reinforcement.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C5 and C4; Section 4.3; E3 — Adaptive Learning
       Orchestration; E4 — Expanded Assessment & Monitoring.
- Verification Basis: Needs Reinforcement provides a route to revisit the supported Guided
       Learning package. Procedural Only and Understood can be communicated as completed
        validation outcomes without automatically initiating new diagnoses, adaptive transfer loops,
       or additional recovery packages.

The requirement does not introduce new remediation workflows. Detailed navigation choices for
Procedural Only and Understood may be specified separately within approved product scope.

### FR-C5-08 — Validation Scope & Evidence Integrity

> **Source:** original PDF p. 79; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must restrict Knowledge Validation conclusions to the assessed Distributive Property
concept and must not use unsuccessful validation responses to initiate new conceptual blocker
diagnoses, comprehensive re-diagnosis, or unsupported prerequisite tracing.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C5; F2 — Explicit Concept Support Boundaries; F4 —
      Evidence-Bounded Learner State; E2 and E4.
- Verification Basis: Validation produces only applicable supported concept-level outcomes.
        Failure does not activate a new blocker hypothesis, launch C3 re-diagnosis, or establish an
      unsupported learner state.

Validation tests whether the supported concept can be applied within curated tasks; it does not
independently determine the cause of every unsuccessful response.

## X — Cross-Capability Requirements

FR-X enforces shared context, outcome-gated transitions and map/source consistency; not a sixth capability.

### FR-X-01 — Supported Context Continuity

> **Source:** original PDF p. 80; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must preserve the applicable selected learning topic, supported mathematical concept,
and originating learning context when transferring information between diagnostic assessment,
guided learning, and knowledge validation capabilities.

- Priority: Must Have
- Decision Status: Approved
- Source / Dependency: Approved C1–C5; F2 and F3; FR-C1-04; FR-C3-01; FR-C4-02;
      FR-C4-07; FR-C5-01.
- Verification Basis: Supported integration scenarios retain SPL as the selected topic and
        Distributive Property as the relevant concept, together with the originating diagnostic and
       learning-entry context required by subsequent behavior.

Context continuity distinguishes confirmed recovery from Optional Concept Review where relevant.

The requirement does not prescribe storage structures, session architecture, or API contracts.

### FR-X-02 — Outcome-Gated Learning Transitions

> **Source:** original PDF p. 80; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement
The system must ensure that transitions between diagnostic assessment, guided learning, and
knowledge validation respect the applicable diagnostic outcome, learning-entry context, and
supported instructional completion conditions.

- Priority: Must Have
- Decision Status: Approved — defined transition obligations only.
- Source / Dependency: Approved C3–C5; FR-C3-10; FR-C4-02; FR-C4-07; FR-C5-01; OI-02
      and OI-03.
- Verification Basis: Confirmed Distributive Property recovery permits the supported learning
      pathway and, after applicable completion, Knowledge Validation. Rejected and Uncertain
      outcomes do not automatically establish confirmed recovery or validation eligibility.

Optional Concept Review may reuse the learning package without changing the original diagnostic
conclusion.

Pending Dependency — OI-02: Validation  eligibility and learning-state implications following
Optional Concept Review.

Pending Dependency — OI-03: Outcome and resulting continuation rules for all-correct diagnostic
response patterns.

This requirement does not decide either unresolved behavior.

### FR-X-03 — Contextual Map & Result Consistency

> **Source:** original PDF p. 81; detailed requirement section. **Status:** Approved source obligation, Must Have (specific open dependencies preserved below).

Requirement Statement

The system must maintain consistency between the selected mathematics  topic, applicable
diagnostic outcomes, and available validation-based learner states as communicated through
diagnostic results, learning outcomes, and the Hybrid Learning Map.

- Priority: Must Have
- Decision Status: Approved — defined consistency obligations only.
- Source / Dependency: Approved C1, C2, C3, and C5; FR-C2-03–05; FR-C3-09; FR-C5-06;
       F4; OI-02 and OI-03 where applicable.
- Verification Basis: For the same applicable learner evidence, diagnostic result
      communication and the Learning Map convey compatible diagnostic meanings; validation
        results and the map convey compatible blocker-level learner states without independent or
        conflicting conclusions.

Confirmed diagnostic evidence must not appear as a validated Understood outcome before
applicable Knowledge Validation.

Rejected or Uncertain results must not appear as confirmed weaknesses.
An applicable Procedural Only, Needs Reinforcement, or Understood result must not conflict with
the Learning Map's representation of the same assessed concept.

Pending Dependencies: Representation of all-correct diagnostic outcomes and Optional Review
follow-on states remains subject to OI-03 and OI-02 respectively.

## 3. Cross-capability integrity principles (source IP-01–IP-02)

**IP-01 — Evidence & Learner-State Ownership Integrity:** C3 owns diagnostic conclusions; C4 owns guided learning participation/completion; C5 owns validation learner states; C2 only projects results. Confirmed diagnosis or completed instruction does not by itself establish C5 result.

**IP-02 — Explicit Supported-Capability Boundary:** A topic/concept visible in catalog or map is not automatically diagnosable, recoverable or validatable; unassessed concepts must never receive invented learner states.

Both are source-derived **principles implemented through FRs**, not independent new FRs. See original PDF pp. 56, 81–82.

## 4. Verification scenario references V-X-01..08

These are **preliminary scenario categories, not complete executable test scripts**. Treat unresolved expected behaviors as blocked until their corresponding OI/OPS decisions are approved.

| ID | Scenario | Minimum source-consistent behavior | Prerequisite |
|---|---|---|---|
| **V-X-01** | Confirmed recovery | Supported SPL entry, confirmed blocker, guided package, eligible C5 and scoped result | OI-01, OPS-01/02/04/05 where relevant |
| **V-X-02** | Non-confirmed continuation | Rejected and Uncertain remain non-confirmed; appropriate options | OI-03 if all-correct pattern, OI-02 for downstream review |
| **V-X-03** | Retry failed | Transfer not administered; Needs Reinforcement; same package | Valid graded math items, OPS-03/04 |
| **V-X-04** | Transfer failed | Retry passed, transfer failed → Procedural Only | Valid item evaluation |
| **V-X-05** | Validation passed | Retry and transfer passed → Understood for blocker | Valid item evaluation |
| **V-X-06** | Unsupported content | No active assessment, guided recovery or validation for unsupported concepts | Support-availability configuration |
| **V-X-07** | All core diagnosis responses correct | **Expected outcome pending OI-03**; no auto SPL mastery | OI-03 |
| **V-X-08** | After Optional Concept Review | **C5 access / learner-state semantics pending OI-02** | OI-02 |

See source summary PDF pp. 56–57 and detailed verification pp. 82–84.

## 5. Acceptance approach for implementation engineers

1. Link code/modules/tests to the exact FR ID(s) and original requirement text.
2. Maintain an independent test-status column: **passed / failed / not tested / blocked by decision**. Do not alter source `Approved` status to “implemented.”
3. For C3, include counterevidence/ambiguous inputs and 4-question maximum. For C4, verify active input and correct stage order. For C5, verify conditional transfer and no state from invalid item-level evidence. For FR-X, test origin, continuation, and map agreement.
4. Verify false-support cases: catalog topics without capabilities cannot initiate diagnosis; represented concepts get no learner weakness/state from relationship alone.
5. Any OI/OPS-dependent expected behavior is explicitly blocked, not guessed or claimed complete. Avoid claiming SC1–SC3 fully verified while required scenarios remain blocked.
6. Usability SC4 and causal educational effectiveness D4 are evaluated separately and are not proven by these FR tests.

**Bottom line:** The original wording of all 39 approved behavioral obligations is included above; the original PDF archive remains the ultimate reference for exact layout and any table/text-extraction ambiguity.

## Draft diagnostic item implementation note — 22 October 2026

The user approved replacing the repeated draft Q2/Q3 examples: Q2 `4(x+3)` (reference `4x+12`), Q3 a conceptual explanation of `5(x+2)` without supplying its result. See [DEC-2026-10-22-Q2Q3](../decisions.md#dec-2026-10-22-q2q3--separate-diagnostic-expressions-and-remove-answer-disclosure) and [review](../implementation/SPL-CONTENT-REVIEW.md). This serves FR-C3-02/04/05/08 and FR-X-01..03; it does not amend the source requirement wording or close OI-01..03/OPS-01..05. The bank remains explicitly draft. Old bank sessions require the existing explicit restart rather than regrading old evidence against new items. Engineering verification: 66 backend tests and production build passed; iOS/user acceptance remains untested.

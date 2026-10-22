# Rethink — Product Overview, Goals, Evidence, and Governance

> **Status:** Faithful product/decision synthesis of approved PRD v1.0 + PRD summary. **Source:** PDF pp. 2–9, 15–39, 89–97; exact transcripts at `../source/00-prd-consolidated-summary.md`, `../source/01-product-overview.md`, `../source/02-problem-statement.md`, `../source/03-product-goals.md`, `../source/08-product-roadmap.md`, `../source/09-risks-and-dependencies.md`, and `../source/10-acceptance-governance.md`. If any paraphrase differs, inspect original and raise a correction.

## 1. Product identity

| Attribute | Source-approved positioning / boundary |
|---|---|
| Name | **Rethink** |
| Category | AI-Assisted Mathematics Conceptual Recovery Platform |
| Field | Mathematics education; self-directed recovery support |
| Primary intended users | High-school students struggling to understand/apply mathematics within specific topics; profile provisional, not externally validated |
| MVP selected diagnostic topic | Algebra → **Sistem Persamaan Linear (SPL)** |
| Supported conceptual blocker | **Distributive Property** only (one complete recovery package) |
| Primary value | **Clarity → Focus → Verification** |
| Learning core | Diagnosis → curated Guided Learning → eligible Knowledge Validation |
| AI approach | Evidence-grounded assistance with **bounded autonomy**; precise final authority split **OI-01 Open** |
| Success boundary | Demonstrable **blocker-level** outcome, not mastery of SPL or all mathematics |

**Product positioning:** Rethink uses observable student mathematics responses to investigate a possible relevant *prerequisite conceptual blocker*, provides a curated intervention for that concept if supported, and validates unscaffolded application and transfer. It deliberately prioritizes the **depth, relevance and integrity of a supported recovery loop** over comprehensive curriculum coverage, instant answers or broad conversational AI tutoring. Its distinctive proposition is the *integration and focus* of components, **not** a proven first-of-its-kind method or demonstrated empirical superiority.

**Vision:** Make specific mathematics difficulties easier to understand and address, while keeping the student actively reasoning; transparently communicate when evidence is insufficient. Knowledge graph structures may enable future expansion, but future capacity must not be advertised as active MVP support.

## 2. Core value proposition (source pp. 2–3, 18–22)

1. **Clarity — identify what might be blocking progress:** Diagnosis is evidence based rather than binary marking. Correct or incorrect alone cannot establish conceptual understanding. Confirmed is conditional and bounded; rejection and uncertainty are valid outcomes.
2. **Focus — recover understanding relevant to the difficulty:** Intervene on the supported concept, rather than require a general mathematics course. A recognized blocker informs one curated conceptual recovery package.
3. **Verification — assess independent application:** Independent Retry and Transfer Problem provide evidence of what the learner can do without instructional support and in a different representation; finishing the lesson never means mastery by itself.

### Six product principles

- **Evidence Before Inference:** Observable responses ground both diagnosis and learner status; uncertainty is valid.
- **Recovery Over Content Coverage:** Prefer one correct loop over many superficially available features.
- **Active Reasoning Over Answer Delivery:** Explanation/scaffolding should not replace student reasoning.
- **Validation Before Understanding Claims:** Learning completion is not sufficient evidence.
- **Bounded AI Autonomy:** AI can contribute to interpretation/synthesis but must remain constrained by evidence, math and supported scope; allocation of final decision authority is unresolved OI-01.
- **Scalable Structure, Controlled Coverage:** A listed concept or relationship does not imply active assessment, content or validation support.

## 3. Problem space and evidence limits (source pp. 5–7, 23–31)

### 3.1 Three linked problem dimensions

1. **Unclear underlying difficulties:** Student struggles in a topic, but source may be a weak prerequisite concept or another explanation (complexity, arithmetic slip, representational unfamiliarity, attention, etc.). The product does not assume all errors are conceptual.
2. **Difficulty targeting recovery:** Students may not know which concept to revisit; assistance often shows procedures/examples without addressing a specific unresolved conceptual relationship.
3. **Uncertainty about independent understanding:** Following worked solutions can be possible without successfully applying the underlying mathematical structure unaided, especially when the surface form changes.

### 3.2 Preliminary exploratory survey — exactly what it supports

Source describes a **small, nonrepresentative, self-reported sample of 12 high-school respondents**, predominantly grades XI–XII (**11/12**). These are **initial perceptions**, not objective diagnostic or effectiveness measures.

| Reported finding | Respondents | Permitted interpretation |
|---|---:|---|
| Mathematics sometimes/frequently difficult | 10/12 | Math struggles appear in this sample |
| Previous learning material perceived not fully understood | 6/12 | Perceived possible prerequisite gap, **not measured blocker** |
| Difficulty understanding formula/concept meaning | 8/12 | Concept meaning is a reported friction |
| Difficulty when worked example differs from target question | 7/12 | Example transfer friction, **not evidence of diagnosed transfer failure** |
| Can follow examples but struggle independently | 5/12 | Reported independence problem, not experimental outcome |
| Seek help from teacher/friend/family | 10/12 | Interpersonal assistance used |
| Read/watch learning resources | 8/12 | Instructional media used |
| Use AI tools | 7/12 | AI familiar in this sample, **not acceptance of Rethink** |
| Attempt independently | 6/12 | Independent strategies used |
| Tutoring services | 2/12 | Alternative support reported |
| Sometimes skip problem | 2/12 | Avoidance reported |
| Study 15–30 minutes | 6/12 | Potential session-time consideration, **not fixed product duration** |
| No set independent-study period | 3/12 | Irregular study routines |

**What the survey does *not* prove:** population prevalence, causal link between prerequisite gaps and difficulty, Rethink user acceptance, diagnosis accuracy, improved learning due to product, superiority to alternatives, SPL as most-needed topic, or an optimized session length. The paper provides theoretical grounding; the survey is perception evidence. Math task observation, interviews, concept testing, usability testing and appropriate learning-outcome study have distinct roles.

### 3.3 Target user and segmentation status

- **Primary target hypothesis:** High-school learners encountering mathematics difficulties for specific topics, potentially benefiting from independent conceptual recovery support. They do not need to know that a prerequisite gap exists prior to using Rethink.
- **Initial research focus:** grades X–XII, with emphasis XI–XII and algebra contexts for feasibility; this does not establish a population-level ranking of math difficulties.
- **Segmentation axes:** reported learning difficulty; help-seeking behavior. **Problem awareness** is a supplemental attribute. No mutually exclusive or validated segments were established.
- **Provisional contexts:** *falling behind in class* and *struggling with a specific problem*. Other potential triggers: classroom confusion, homework, exam prep, noticing old concept gaps; their relative importance remains unknown.
- **Opportunity hypothesis:** More targeted recovery when relevant prerequisite understanding is genuinely implicated; user demand and performance superiority remain unproven.

## 4. Critical assumptions A1–A6

| ID | Hypothesis | Evidence state in source | Required next evidence |
|---|---|---|---|
| **A1** | Relevant prerequisite gaps contribute to *some* target user math problems | Literature + preliminary self-report | Math-task observation, interpreted with alternative explanations |
| **A2** | Some learners cannot attribute cause / identify the next concept to study | Limited survey indication | Interviews + task observation |
| **A3** | Existing assistance does not resolve all difficulties | Reported frictions; no comparison proof | Help-seeking investigation / alternatives |
| **A4** | Students understand/accept the targeted diagnostic experience | **Not directly tested** | Concept testing, diagnostic willingness/interpretability tests |
| **A5** | Curated recovery increases independent concept use | **Pedagogical hypothesis; no product effect proof** | Appropriate learning evaluation |
| **A6** | Users value evidence of independent application | Indirect indication only | Interpretability, acceptance/usability research |

Assumptions remain hypotheses even when the product implementation is approved. Implementation is permitted with explicit assumptions; claims of product value must not outrun observed evidence.

## 5. Product goals G1–G4

| Goal | Approved target | User-visible intended outcome |
|---|---|---|
| **G1** Evidence-grounded recovery direction | Translate bounded student evidence into qualified diagnosis and next steps | Learner sees what might be relevant and what is uncertain |
| **G2** Targeted conceptual recovery | Provide a relevant curated intervention, preserving active reasoning | Learner has opportunity to rebuild supported concept |
| **G3** Evidence-based understanding evaluation | Assess independent retry and structural transfer | Learner sees assessed performance and need for reinforcement |
| **G4** Understandable self-directed experience | Make purpose, flow, result and limitations interpretable | Learner can navigate without ongoing human supervision |

These are **goals**, not demonstrated impacts or KPI targets already achieved.

## 6. MVP success conditions (SC1–SC4)

| ID | Classification | Requirement for valid success claim |
|---|---|---|
| **SC1** Complete Supported Recovery Path | Functional | Topic selection → diagnosis → supported guided recovery → eligible validation → blocker outcome, end to end |
| **SC2** Evidence-Grounded Decision Integrity | Functional | Conclusions and C5 states consistent with observed math evidence, reviewed reference cases and constraints |
| **SC3** Appropriate Outcome-Based Continuation | Functional | Confirmed/Rejected/Uncertain and validation states routed without conflation or false mastery claims |
| **SC4** Understandable Core Recovery Experience | **Separate user testing** | Intended users understand diagnosis purpose, progression, result and limitations |

SC1–SC3 require applicable **required** scenarios to be executed and passed; *unexecuted/blocked* scenarios mean full functional verification is not established. SC4 cannot be inferred from a passing technical test. A single successful demo is not acceptance.

### Four distinct measurement dimensions (D1–D4)

- **D1 Functional completeness:** executed required scenario pass rate **plus coverage counts** (passed/failed/untested). Passing 100% of only one executed case does not prove completion.
- **D2 Decision integrity:** agreement on reviewed diagnostic/validation cases; record unsupported confirmations, Uncertain handling and mismatched statuses explicitly. Not a population diagnostic accuracy figure.
- **D3 Usability and interpretability:** separately measure representative task success and interpretation of diagnostic / state meaning; log critical issues and misreadings.
- **D4 Learning outcome evidence:** unscaffolded independent application + transfer performance within supported concepts. Any pre/post data is preliminary and requires appropriate design; does not prove causal benefit on its own.

No numerical thresholds, model sensitivity/specificity, retention KPI, or percentage impact are established by the source. Do not invent targets or combine the dimensions into a composite score.

## 7. MVP claim boundaries and non-goals

- **Confirmed ≠ definitive cause** of the student's entire SPL struggle.
- **Rejected/Uncertain ≠ all mathematics understood** or absence of other difficulties.
- **Understood ≠ whole SPL mastery**, sustained retention, transfer to all possible contexts or broad mathematics gains.
- **Finish Guided Learning ≠ Understood**; C5 evaluates independently.
- Not required: all math curriculum, all SPL lesson content, multi-blocker diagnosis, adaptive multilevel tracing, competency-specific mastery, longitudinal retention, general mathematics improvement.
- The goal of *targeted conceptual improvement* is **not** declared unimportant; its **causal verification** is separate from minimum functional MVP.

## 8. Roadmap P1–P5 (priority groups, not a fixed calendar)

| Priority | Main work | Evidence/deliverable |
|---|---|---|
| **P1 — MVP Foundations** | Catalog entry, curated relations and capability availability, supported context | Usable learning entry and knowledge representation |
| **P2 — Diagnostic Capability** | Q1–Q4 blueprint, evidence evaluation/synthesis, bounded AI, results, routing | Valid supported SPL diagnostic experience |
| **P3 — Guided Learning** | Curated visual/example/practice, active response, completion | Functioning concept recovery package |
| **P4 — Validation & Integration** | Retry, conditional transfer, state mapping, map consistency, transitions | Integrated blocker-level recovery loop |
| **P5 — MVP Verification & Refinement** | Review math, case testing, traceability, usability, defects and limitations | Evidence-backed MVP readiness candidate |
| **Post-MVP** | Evaluate quality-gated concept expansion | **Proposal only**, not committed release |

Workstreams can overlap. No approved sprint length, staffing, release dates or production performance targets appear in this product roadmap. OI/OPS dependencies are in `../decisions.md`.

## 9. Risk register R-01–R-06 (risks, not proven defects)

| Risk | Potential failure | Mitigation/design work consistent with source |
|---|---|---|
| **R-01** | Unsupported blocker confirmation from weak/incorrect synthesis | Case-based evidence verification; math safeguards; resolve OI-01 |
| **R-02** | Invalid mathematical questions, examples or rubrics | Curated item and reference solution review, OPS-04 |
| **R-03** | Learning is passive or completion declared incorrectly | Active practice evidence, define feedback/completion OPS-01/02 |
| **R-04** | Wrong learner-state mapping or invalid validation grading | Three-state matrix testing, OPS-03 |
| **R-05** | Context/state drift between C1–C5 and map | FR-X-01..03, OPS-05 and integration tests |
| **R-06** | Demo incorrectly claimed as usability or learning-effectiveness proof | Separate functional, user, and empirical outcome evaluation |

The source does not quantify risk likelihood or severity. Documentation or partial implementation does not “close” a risk without relevant evidence.

## 10. Acceptance principles AP-01–AP-05 and governance PG-01–PG-05

**AP-01 Evidence Based:** Mark a requirement/scenario verified only with sufficient evidence. **AP-02 Explicit Outcome:** Report met, failed, and not yet verifiable separately. **AP-03 Dependencies Matter:** An open decision prevents *affected* final acceptance, not unrelated progress. **AP-04 Traceability:** Connect the FR, scenario and supporting observations. **AP-05 Claim Boundary:** Functional acceptance ≠ learning gain, long-term retention, broad mastery.

**PG-01 Baseline Authority:** Approved sections govern product scope/behavior. **PG-02 Open Items Stay Open:** OI/OPS require explicit review; PRD approval doesn't close them. **PG-03 Controlled Behavior Change:** Material change of scope, diagnosis, states or success conditions needs impact assessment and approval. **PG-04 Derived Spec Alignment:** UI, technical design and curated math content must match approved requirements. **PG-05 Traceable Revision:** Approved changes name affected baseline elements, technical specs and verification criteria.

### Working implication for Codex

A completed program is not proof that its requirement is approved, a mock is not a verified result, and a passed functional test is not a demonstrated learning benefit. Keep status and provenance explicit, and resolve open product choices through the decision register instead of silently embedding guesses in code.

# Rethink — Gamification Acceptance & QA Test Matrix

> **Document ID:** RT-QA-GAM-001 | **Version:** 0.9 PROPOSED  
> Companion: [`gamification-specification.md`](gamification-specification.md)  
> **Do not mistake test proposal for approved acceptance.** `GATE` means a source decision is unresolved and the corresponding assertion cannot be signed off until reviewed.  
> **Scope:** Learning-loop Progress Indicator (`P`), Contextual Positive Feedback (`F`), Concept Achievement (`A`), Cross-feature Integrity (`X`), accessibility and evaluation (`U`).

## 1. Execution protocol

**Preconditions:** a deterministic test fixture with controlled C3 and C5 outcomes, reviewed mathematical items and expected outcomes; realistic loading/failure fixtures; ability to reset/inspect authoritative session state. When actual C3 outcome logic is unresolved under OI-01, use **mocked but explicit finalized outcome fixtures**, never claim this verifies diagnostic validity.

**Per-test evidence:** case ID, build hash, requirement IDs, mocked or real source event, steps, observed UI, expected UI, result (`PASS`, `FAIL`, `BLOCKED`, `NOT_RUN`), screenshot/recording if useful, reviewer, outstanding OI/OPS ID. `PASS` requires an executed assertion, not a screenshot of a static mock.

**Release rule:** do not mark a blocked case PASS by inventing a policy. Report coverage numerator and denominator separately. Gamification passing tests does not establish learning effectiveness.

## 2. Progress indicator scenarios

| ID | Scenario / stimulus | Expected assertion | Link / gate |
|---|---|---|---|
| `P-01` | Enter supported SPL topic | Stepper shows diagnostic phase and active supported scope, no progress or mastery for unassessed Distributive Property | C1, C2, FR-C1-04 |
| `P-02` | Catalog contains unsupported topic | Topic displayed as unavailable, not merit/ability-locked; cannot start unsupported diagnostic | FR-C1-03/05 |
| `P-03` | Q1 entered, no save | Indicator says core 1/3 in progress; Q1 not yet completed | FR-C3-02/03 |
| `P-04` | Q1 save ACK returned | Only after confirmed save, core progress advances to Q2 | FR-C3-03, OPS-05 GATE persistence |
| `P-05` | Q2/Q3 saved | Counts 2/3 then 3/3 with correct labels; no answer correctness displayed | FR-C3-02/03 |
| `P-06` | Q4 not required | Diagnostic core ends without fourth ghost/failed step | FR-C3-06 |
| `P-07` | Q4 conditionally required | Show *additional probe 1/1*, preserve completed 3/3 core; no falling/oscillating 100→75% meter | FR-C3-06, OI-01 GATE selection |
| `P-08` | Attempt to administer second Q4 | Disallowed; max four administered items | FR-C3-06 |
| `P-09` | Server save fails | Progress does not advance; accurate “not saved” notice | FR-C3-03, OPS-05 GATE |
| `P-10` | Assessment processing pending | Neutral pending indicator; no premature Confirmed/Rejected/Uncertain output | C3; OI-01 |
| `P-11` | Diagnostic Confirmed issued | Diagnosis step complete; guided learning eligible next; no learner state implied | FR-C3-09/10 |
| `P-12` | Diagnostic Uncertain issued | Non-confirmed conclusion and appropriate optional review/return; no red “failed journey” step | FR-C3-09/10 |
| `P-13` | Diagnostic Rejected issued | Non-confirmed conclusion and appropriate continuation; no alleged mastery | FR-C3-09/10 |
| `P-14` | All Q1–Q3 correct | No invented Rejected/Understood/Confirmed mapping or false map Focus | OI-03 GATE, V-X-07 |
| `P-15` | Guided Learning opens | Fixed three stages in correct order: Visual → Worked → Partial Guided Practice | FR-C4-01/06 |
| `P-16` | Visual is viewed | `viewed` not conflated with `completed` if criteria not met | FR-C4-07, OPS-02 GATE |
| `P-17` | Active Guided Practice not attempted | Passive viewing cannot satisfy active practice or mark whole recovery completed | FR-C4-05/07 |
| `P-18` | C4 reaches approved completion | Final C4 completion and C5 eligibility reflect **reviewed** rule only | OPS-02 GATE, FR-C4-07 |
| `P-19` | Retry not evaluated | Transfer not presented as failed or passed; gate not bypassed | FR-C5-03, OPS-03 GATE |
| `P-20` | Valid retry failure | `Needs Reinforcement`; transfer explicitly not administered | FR-C5-03/05/07 |
| `P-21` | Valid retry success | Transfer enabled, no “Understood” until valid transfer success | FR-C5-03/05 |
| `P-22` | Transfer valid fail | Procedural Only, not progress failure of entire student | FR-C5-05/06 |
| `P-23` | Both valid pass | Understood only for Distributive Property | FR-C5-05/06 |
| `P-24` | Reopen/refresh any phase | Authoritative saved state persists/projection reconstructs; no inflation | FR-X-01/03, OPS-05 GATE |
| `P-25` | Optional Review entry from Rejected/Uncertain | Origin remains optional; no new confirmed blocker | FR-C4-02, FR-X-01 |
| `P-26` | Optional Review completed then “go to validation” | Route is **not silently enabled**; exact behavior blocked pending policy | OI-02 GATE, V-X-08 |
| `P-27` | Map before/after C3/C5 | Explore has no personal weakness; Focus projects C3; Progress projects only valid C5 | FR-C2-02..05, FR-X-03 |

## 3. Contextual feedback scenarios

| ID | Scenario / stimulus | Expected assertion | Link / gate |
|---|---|---|---|
| `F-01` | Q1 answer submitted | Saved/pending feedback only; no statement of correctness | C3 assessment integrity |
| `F-02` | Q2 answer submitted | No conceptual hint before diagnosis closes | C3 assessment integrity |
| `F-03` | Q3 explanation submitted | No “correct reasoning” feedback before diagnosis closes | C3 assessment integrity |
| `F-04` | Conditional Q4 active | No hint/reveal that contaminates probe | FR-C3-06, OI-01 |
| `F-05` | C3 Confirmed | Correct qualified “evidence supports” copy and relevant review/recovery next action | FR-C3-07/09 |
| `F-06` | C3 Uncertain | Describes insufficient evidence; not “you don't understand” or false rejection | FR-C3-09 |
| `F-07` | C3 Rejected | Describes lack of support in assessed scope; no SPL mastery claim | FR-C3-09 |
| `F-08` | Visual stage viewed | Encouraging, factual orientation only; no Understood | FR-C4-03/08 |
| `F-09` | Worked Example displayed | Mathematical reason accompanies meaningful steps; no just-answer policy | FR-C4-04, OPS-04 GATE content |
| `F-10` | Practice valid correct answer | Specific mathematically correct feedback, no generic-only praise | FR-C4-05, OPS-01/04 GATE |
| `F-11` | Practice partial distribution error | Feedback addresses reviewed observable transformation; no guess about student's identity/traits | OPS-01/04 GATE |
| `F-12` | Practice ambiguous math text | Does not mark mistaken concept without evaluable evidence | OPS-01/04 GATE |
| `F-13` | Practice repeated wrong attempts | Retry/solution exposure follows approved OPS-01, no AI-improvised loop | OPS-01 GATE |
| `F-14` | Guided completion criteria unmet | “learning completed” message absent | OPS-02 GATE |
| `F-15` | C4 completion verified | Feedback says lesson/activity done and next eligible stage, not concept mastered | FR-C4-07/08 |
| `F-16` | C5 Independent Retry being answered | No real-time visual/worked/partial hints | FR-C5-02 |
| `F-17` | Valid independent retry pass | Correct process-result message and transfer CTA; no badge or Understood yet | FR-C5-03/05 |
| `F-18` | Valid independent retry fail | Non-shaming explanation and same C4 reinforcement route | FR-C5-05/07 |
| `F-19` | Valid transfer fail | Procedural Only interpretation; prior retry acknowledged; not “can't do math” | FR-C5-05/06 |
| `F-20` | Valid both-pass | Understood claim restricted to supported tasks/concept | FR-C5-05/06 |
| `F-21` | C5 submission empty/invalid/uninterpretable | No silent “fail” grade, learner state or badge | OPS-03 GATE |
| `F-22` | Equivalent valid mathematical expression | No false error when OPS-03/04 equivalence rules deem response correct | OPS-03/04 GATE |
| `F-23` | API/network failure | Distinct technical message; not a math-specific result | FR-X-02, OPS-05 GATE |
| `F-24` | Re-render same saved outcome | Copy matches authoritative result, no contradictory messaging | FR-X-03 |
| `F-25` | LLM-generated feedback candidate contains overclaim | Reject output and fall back to reviewed safe template; no fabricated evidence | OI-01, FR-C3-08 |
| `F-26` | Feedback contains multiple possible next actions | Exactly the sanctioned continuation is primary, others optional and accurately labelled | FR-C3-10, FR-C5-07 |

## 4. Concept achievement scenarios

| ID | Scenario / stimulus | Expected assertion | Link / gate |
|---|---|---|---|
| `A-01` | C3 Confirmed alone | No achievement | FR-C3-07, FR-C4-08 |
| `A-02` | C4 completed, no C5 | No achievement / Understood | FR-C4-08 |
| `A-03` | Valid retry fail; transfer not administered | No achievement | FR-C5-05 |
| `A-04` | Retry pass, transfer not yet submitted | No achievement | FR-C5-05 |
| `A-05` | Retry pass, transfer fail | No achievement; Procedural Only remains visible | FR-C5-05 |
| `A-06` | Valid retry pass, valid transfer pass, eligible confirmed recovery | **PROPOSED** single bounded concept achievement issued from final C5 source only | FR-C5-05/06, GAM-01 approval GATE |
| `A-07` | Retry passes with learner state incorrectly marked non-Understood | No badge until mismatch resolved; don't self-author C5 state | FR-X-03 |
| `A-08` | Rejected or Uncertain with Optional Review | No badge based only on review participation | FR-C4-02/08 |
| `A-09` | Optional Review → purported C5 | No unreviewed issuance rule; OI-02 still open | OI-02 GATE |
| `A-10` | Unsupported concept appears in map | No achievement | FR-C2-05 |
| `A-11` | Client sets arbitrary `understood=true` | No award without server-authoritative valid C5 evidence | FR-X-03, proposed security invariant |
| `A-12` | Repeat same issuance request | No duplicate recognition record or multiple notifications | OPS-05 GATE |
| `A-13` | Reload already awarded result | Show historical recognition without repeated newly-earned animation | proposed recognition policy |
| `A-14` | Race between two tabs/devices | Do not double-issue or show inconsistent claims | OPS-05 GATE |
| `A-15` | Award persistence fails | Do not claim award “saved”; C5 result remains accurate | OPS-05 GATE |
| `A-16` | Existing badge shown next to current progress | Both refer to same supported concept and valid evidence; avoid asserting current global mastery | FR-C2-04/05 |
| `A-17` | Badge details opened | Show concept + retry and transfer evidence + explicit boundary “not entire SPL” | FR-C5-06 |
| `A-18` | Achievement animation disabled/reduced motion | Functional status and CTA remain accessible | UX/a11y |
| `A-19` | Confetti callback blocked/fails | No effect on badge issuance, learner state or next action | proposed separation |
| `A-20` | Corrected/invalidated prior C5 result | Do not silently keep a false *current-state* claim; reconciliation requires approved policy | OPS-05 GATE |

## 5. Cross-feature integrity / accessibility / user testing

| ID | Scenario | Expected assertion | Reference |
|---|---|---|---|
| `X-01` | Same C3 result shown on result page/map/progress | Semantically consistent; gamification does not convert Rejected/Uncertain to Confirmed | FR-X-03 |
| `X-02` | Same C5 valid result shown on result/map/badge | `Understood` only when C5 says so; no independent inference | FR-X-03 |
| `X-03` | User changes supported topic during unfinished journey | No concept or evidence cross-contamination; route follows approved policy | FR-X-01/02, OPS-05 GATE |
| `X-04` | Learner attempts direct URL to gated C5 | Eligibility enforced by owner, not a disabled button alone | FR-C5-01, OPS-05 GATE |
| `X-05` | Duplicate event / refresh / back nav | No increment based solely on repeated client callbacks | OPS-05 GATE |
| `X-06` | AI unavailable | No invented diagnosis, learner state or badge | OI-01, FR-C3-08 |
| `X-07` | Normal supported flow plus UI tracking | Analytics cannot alter math outcomes; no reward-driven assessment branching | product invariant |
| `U-01` | Screen reader on progress | Announces active stage and count, not a decorative percent with no meaning | WCAG 2.2 |
| `U-02` | Keyboard-only navigation | Logical focus order, usable stage/action controls, no keyboard trap | WCAG 2.2 |
| `U-03` | High contrast / color vision | State meaning conveyed in text/icons not only colors | WCAG 2.2 |
| `U-04` | Reduced-motion on | Achievement animation absent/reduced while text and CTA remain | WCAG 2.2 |
| `U-05` | Mobile narrow layout | Phase labels, feedback, equations readable with no overlapping CTA | usability |
| `U-06` | Student asked what progress percentage measures | Explains *activity/stage*, not mathematical mastery | UX comprehension |
| `U-07` | Student asked what Concept Applied means | Correctly cites retry + transfer within Distributive Property scope | UX comprehension |
| `U-08` | Student asked “do I master all SPL?” | Correctly answers **no** after reading achievement details | UX comprehension |
| `U-09` | Student sees Procedural Only | Can name independent success, failed transfer, and legitimate next step | UX comprehension |
| `U-10` | Student sees Uncertain | Interprets as insufficient assessment evidence, not a permanent label | UX comprehension |

## 6. Requirement-to-test anchors

| Baseline requirement family | Key gamification tests |
|---|---|
| FR-C1-01..05 | P-01, P-02 |
| FR-C2-01..05 | P-27, X-01, X-02, A-10, A-16 |
| FR-C3-01..10 | P-03..14, F-01..07, X-06 |
| FR-C4-01..08 | P-15..18, P-25..26, F-08..15, A-02 |
| FR-C5-01..08 | P-19..23, F-16..22, A-03..08 |
| FR-X-01..03 | P-24..27, X-01..07 |
| OI-01 | P-07, P-10, F-25, X-06 |
| OI-02 | P-26, A-09 |
| OI-03 | P-14 |
| OPS-01 | F-10..13 |
| OPS-02 | P-16..18, F-14..15 |
| OPS-03 | F-21..22 |
| OPS-04 | F-09..13, F-22 |
| OPS-05 | P-04, P-09, P-24, A-12..15, X-03..05 |

## 7. Reporting template

```md
# Gamification QA Result — <build/tag> — <date>
## Source state
- PRD source: approved 39 Must Have FRs
- Gamification document: PROPOSED / APPROVED by <reviewer/date if applicable>
- Outstanding: OI-01 / OI-02 / OI-03; OPS-01..05 (mark resolved only with evidence)

## Execution
- PASS: ...
- FAIL: ...
- BLOCKED by unresolved decision: ...
- NOT RUN: ...
- Critical regressions: ...
- Verified evidence artifacts: ...

## Claims permitted
- Functional behavior actually tested: ...
- Usability research performed (if any): ...
- Learning outcome evidence separately studied (if any): ...
- Claims NOT permitted: ...

## Product/engineering decisions needed before release
- ...
```

**Reminder:** this test inventory is deliberately more stringent than a quick demo checklist. A failed or unrun critical invariant cannot be described as fully verified. Tests should be adapted to actual implementation language and approved content; no additional scope is authorized merely because a candidate test appears here.

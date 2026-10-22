# Native iOS UI refresh — 18 October 2026

User request: substantially improve the existing app's UI and UX using `DESIGN.md` and all ten images in `Rethink/Reference`. Gamification is outside this change.

## Visual direction

- Daylight sky canvas, paper surfaces, medium-weight editorial headings, dark pill actions.
- Larger existing Illustrations assets, with restrained rotation and generous space.
- Pastel surfaces explain hierarchy: a blue starting point, a lavender subject entry, and a paper map shortcut.
- Native navigation stacks and tab bar. Question screens hide the tab bar to keep attention on the task.
- Shared scalable headings, reusable tags and surfaces, and button press feedback that respects Reduce Motion.
- Catalog composition adapts to the actual backend catalog, including a single represented subject. No extra subjects or supported capabilities are fabricated.

## Color assets and canvas

- The `HomeStyle` palette now references color assets in `Assets.xcassets/Colors` instead of hardcoded RGB values.
- `SkyTint` uses `#F6FAFF` rather than the `DESIGN.md` canvas `#EBF5FF`, following the user's request for a whiter, less blue background. `Paper` remains `#FAFDFF`; the other brand tokens are unchanged.
- This is a visual deviation documented for review, not a product-behavior change.

## Onboarding

The app currently ships a five-step, activity-gated onboarding: name, core loop taps, sample MCQ, chatbot preview, and ready. Audio is played per slide, starting with `onboarding-1a.mp3` (intro) and `onboarding-1b.mp3` (name question); missing slide files fall back to `dummy-audio.mp3` when present. A mute control sits at the top right. There is no slide picker and no audio-preference screen. After onboarding the app activates an anonymous guest session. The proposed audio narration, per-screen files and deeper interaction polish are documented as **PROPOSED** in `onboarding-specification.md`, `onboarding-audio-script.md`, and `onboarding-acceptance-tests.md`.

## Screens and interactions

| Screen | Change | Related PRD |
|---|---|---|
| Home | Clear learning entry/resume, illustrated greeting, responsive subject entry, map shortcut | C1, FR-X |
| Catalog / subject | Illustrated subject tiles and readable supported/unavailable topic rows | C1 |
| Topic | Illustrated orientation, three-step explanation and persistent primary action | C1, C3–C5 orientation |
| Diagnosis / validation | Larger math surface, lettered selection states, labeled answer input, fixed submit action and keyboard dismissal | C3, C5 |
| Learning | Colored repeated-group tiles, numbered worked-example steps, readable result surface | C4 |
| Result | Illustration and clear next actions; server outcome and eligibility remain authoritative | C3, C5, FR-X |
| Map | Three native segmented views for curated relations, diagnostic focus and validation result | C2 |
| Profile / guest | Illustrated session identity, understandable persistence copy, confirmation before resetting progress | FR-X |

Student explanation autocorrect is disabled. Format hints no longer include a concrete example that could reveal the retry answer. No correctness styling appears during diagnosis. Draft content remains labeled; no score, streak, XP, reward or achievement is added.

## Verification scope

Native simulator review uses a separate `Rethink UI Review` device and a disposable local server backed by the existing v2 content/engine. This is a UI fixture, with no external authentication or database writes. Normal app configuration still points to the existing backend; no test URL is committed to application configuration.

Manual checks cover home, topic navigation, question selection, expression entry, explanation entry, submission/result routing and the visual learning stage. Final simulator and generic iOS device builds both passed. Home was inspected at `accessibility-large`; a truncated caption was corrected to wrap, and both final builds include that correction. Other large-text screens and a full VoiceOver traversal remain untested. User-comprehension evaluation is still required before SC4 acceptance can be claimed.

The refresh does not close OI-01–03 or OPS-01–05, approve draft mathematics, or establish learning effectiveness.

## Curriculum pages — 20 October 2026

User requests the supplied course-browser references: horizontal illustrated selectors with a blue selected outline/underline, white rounded cards with a short bottom shadow, centered connecting lines, and left-hand illustrations. This explicitly requested visual treatment supersedes flat/no-border defaults on these catalog pages only. Connectors indicate catalog grouping, not prerequisites or mandatory learning order. No grade/age levels are invented.

`MathematicsCatalogView` shows materials and branch cards; `CatalogSubtopicView` switches among the six branches; `CatalogTopicDetailView` provides details for each of 24 leaves. Existing Home subject links enter this browser as well. Common UI is in `CatalogCurriculumComponents`; `CatalogStore` maps backend hierarchy to existing catalog models. `RemoteCatalog` decodes `disciplines[].materials[]` and legacy `subjects[].subtopics`, preserving older API compatibility.

The foundation illustration uses `FondasiAljabar`. Other cards reuse existing illustration assets; the supplied screenshots' illustrations are not all present as individual assets. No copied third-party course names or unsupported course entries are introduced.

Coverage: FR-C1-01/02/03/05 presentation and navigation; existing FR-C1-04 SPL handoff retained. Availability is explicit; branches can be browsed, but only SPL starts diagnosis. Distribution details route through the supported SPL entry, not a new standalone or post-optional-review validation path. OI/OPS statuses unchanged.

The new six-branch hierarchy requires the updated backend catalog response. An older deployed backend remains readable but exposes only its existing flat topics; no active content is invented locally. No database migration or deployment performed. Build, runtime, screenshot, navigation, and accessibility checks: NOT RUN at user's request. Visual equality with the references is not claimed without rendering.

### Catalog fallback correction — 20 October 2026

The deployed catalog can still return only two legacy topics. Bundle the explicitly requested six-branch/24-leaf curriculum in `CatalogCurriculum`; show it immediately and when hierarchy metadata is absent. Overlay only capabilities actually reported by the legacy backend, with SPL as the sole diagnostic entry. With no response, all bundled leaves remain unavailable for assessment. The new remote hierarchy takes precedence when supplied. This supersedes the earlier dependency on deployment for showing all branches. No build/run performed.

### Hierarchy distinction and motion — 20 October 2026

Material pages now identify the material and show grouping cards with folder marks, numbered subtopic labels, lavender illustration plates and actual child counts. Subtopic pages show a complete breadcrumb, a Subtopik heading, and smaller white cards for Bagian belajar (the sub-subtopic level). Leaf detail pages identify their own level and full hierarchy. This naming translates taxonomy into navigation without implying an assessment, mastery level, or mandatory sequence.

Cards reveal in short staggered fade/slide transitions; selected-category artwork subtly scales, alongside the existing sliding underline and horizontal auto-centering. Reduce Motion reveals content immediately and disables motion. All availability and SPL-only entry guards remain unchanged. No build, run, visual or accessibility tests executed per user instruction.

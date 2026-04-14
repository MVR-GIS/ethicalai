# user-manual — Overlay Module (Reproducible Technical User Manuals)

## Canonical inspiration (required)
Use these as exemplars for style, structure, and maintenance patterns:
- https://r4ds.hadley.nz/
- https://r-pkgs.org/
- https://wesmckinney.com/book/
- https://jjallaire.github.io/visualization-curriculum

## Scope & audience (required)
Confirm early (do not infer):
1) primary audience (beginner / intermediate / expert; role-based personas),
2) expected prior knowledge and prerequisites,
3) primary user goals (what tasks they must accomplish),
4) supported platforms/versions (software versions, OS, dependencies),
5) whether the manual is a living document with ongoing releases.

## Information architecture (required)
- Prefer a task- and concept-layered structure:
  - **Getting started**: fastest path to first success
  - **Core workflows**: the “80% use cases”
  - **How-to guides**: problem/goal oriented (“How do I…?”)
  - **Reference**: complete but concise, searchable sections
  - **Deep dives**: design rationale, internals (optional, clearly separated)
- Keep chapters short and scannable:
  - descriptive headings,
  - one main concept per section,
  - summaries/checklists at the end of major chapters when helpful.
- Maintain strong navigation:
  - consistent terminology,
  - cross-links between concept ↔ how-to ↔ reference.

## Reproducible examples & outputs (required)
- Every code example must be:
  - minimal (smallest working example),
  - runnable in the documented environment,
  - deterministic where randomness is involved (explicit seeding and stable inputs).
- Prefer examples that demonstrate complete workflows for key tasks (not isolated fragments).
- Avoid network calls, unstable APIs, and time-dependent outputs in examples unless explicitly necessary.
  - If unavoidable, label clearly and provide expected output and/or a fallback path.
- Output display rules:
  - show expected output where it aids learning or validation,
  - avoid huge outputs; summarize and link to fuller artifacts when needed.

## Verification expectations for manuals (required)
- Require a verification approach that matches the book’s execution policy (as defined in `quarto-book`):
  - at minimum: render succeeds + cross-references resolve + links are checked,
  - ideally: execute at least the “Getting started” + critical workflow chapters in CI.
- Treat as “release blockers” unless explicitly waived:
  - broken links,
  - broken cross-references,
  - failing code examples in chapters that are supposed to execute,
  - instructions that contradict current software behavior for core workflows.

## Editorial standards (required)
- Use consistent terminology and naming that matches the actual product:
  - function names, argument names, UI labels, commands, file paths.
- Prefer direct, imperative task writing:
  - “Run …”, “Click …”, “Open …”
- Explain “why” only where it prevents common errors or clarifies tradeoffs; keep task sections focused.
- Use callouts intentionally (Note/Warning/Tip):
  - keep them short,
  - make them actionable,
  - avoid duplicating mainline instructions.

## Versioning, change management, and drift control (required)
- Require an explicit docs versioning posture:
  - “always latest” vs versioned per release.
- Require a visible change signal:
  - a “What’s new” page and/or a docs changelog (especially for living manuals).
- When behavior changes, require updating:
  - Getting started/tutorial paths,
  - affected how-to guides,
  - reference sections,
  - and any screenshots/snippets that could drift.
- Prefer “single-source” patterns that reduce drift:
  - reusable snippets/partials for repeated instructions,
  - centralized variables for versions/paths where the tooling supports it.

## Visuals (required)
- Use visuals to clarify workflows and mental models:
  - diagrams for architecture/data flow,
  - screenshots only when necessary.
- Prefer reproducible, code-generated figures when possible.
- If screenshots are required:
  - keep them minimal,
  - ensure they match the current UI/version,
  - avoid embedding sensitive data.

## Accessibility and inclusivity (required)
- Prefer accessible visuals (contrast) and meaningful captions.
- Define jargon on first use; avoid unexplained acronyms.
- Keep code and commands copy/paste-friendly (avoid line wraps that break execution).

## Definition of done for manual work (required)
When planning or reviewing a documentation change, require:
- the user goal it supports,
- where it belongs in the information architecture,
- how it is verified (render/tests/link checks/execution policy),
- what could drift and how drift will be detected.


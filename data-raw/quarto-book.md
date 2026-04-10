# quarto-book — Overlay Module (Quarto Books; HTML-first; executable R/Python)

## Canonical guidance (required)
- Treat the official **Quarto Books** documentation as canonical: https://quarto.org/docs/books/
- When providing advice, prefer Quarto’s documented project model (book projects, `_quarto.yml`, `quarto preview`, `quarto render`) and explicitly note deviations.

## Scope & constraints (required)
Confirm early (do not infer):
1) primary output = **HTML** (assumed unless user says otherwise),
2) computation engines in use (R/knitr, Jupyter/Python, or both),
3) execution policy:
   - what runs locally vs what must run in CI,
   - whether CI has access to needed credentials/data,
4) publishing target (GitHub Pages / Posit Connect / internal web / other),
5) expected update cadence and review workflow (PR review vs direct push).

## Project structure expectations (required)
- Use a Quarto book project rooted at `_quarto.yml` with `project: type: book`.
- Prefer a clear, stable structure:
  - `index.qmd` as the entry point,
  - chapters explicitly ordered in `_quarto.yml`,
  - appendices separated intentionally (if present).
- Keep assets organized and predictable:
  - figures and other static assets in dedicated directories,
  - avoid scattering ad-hoc files across the root.

## Configuration discipline (required)
- Treat `_quarto.yml` as the single source of truth for:
  - book metadata,
  - chapter ordering/navigation,
  - HTML format options,
  - cross-reference and citation settings.
- Reduce duplication:
  - use project-level variables (`_variables.yml` where appropriate) for repeated values.
- Prefer Quarto-native features over custom hacks unless necessary and documented.

## Reproducible computation (required)
Because books include R/Python execution:
- Default to deterministic builds:
  - set seeds where randomness is used,
  - avoid time-dependent output (timestamps) unless intentionally included,
  - avoid reliance on unstated local state.
- Avoid network-dependent examples by default.
  - If network access is required, explicitly mark it and propose a fallback/skip strategy.
- Encourage moving expensive computation out of rendering hot-path when feasible (precompute, cache, or separate pipeline).

## Execution policy & performance (required)
For living documents, **choose and document** one of the execution strategies below. If the user hasn’t chosen yet, present this matrix and ask them to pick.

### Execution strategy decision matrix (required)

| Strategy | Use when | Pros | Cons / risks | Recommended guardrails |
|---|---|---|---|---|
| **A. Always execute on render (CI + local)** | Output must always reflect current code/data; CI can access all inputs; build time acceptable | Highest reproducibility; fewer “works on my machine” issues; strong reviewer confidence | CI can be slow/expensive; failures more frequent; requires stable inputs and secrets management | Deterministic seeds; avoid network calls; cache heavy chunks; keep chapters modular; ensure CI has required system deps |
| **B. Freeze / cache selectively (hybrid)** | Some chapters are heavy/slow; outputs don’t need to change every commit; you still want CI to validate structure | Balances freshness with speed; reduces CI load; allows “peppered” caching for heavy chunks | Risk of stale results if freeze/caches not refreshed; reviewers may not know what was re-run | Clearly label which chapters/sections are frozen; define when/how to refresh; add a periodic “full rebuild” job; document cache invalidation rules |
| **C. Local execution only; commit outputs** | CI cannot run code (secrets, proprietary data, environment constraints); build must be fast; outputs are reviewed as artifacts | Fast CI; works with restricted data; stable published HTML | Highest drift risk (code vs output); harder to guarantee reproducibility; reviewers must trust committed artifacts | Require a documented local build procedure; require a “clean rebuild” checklist; consider scheduled reproducibility runs in a secure environment; log session/package versions used |

**Default recommendation (if user has no preference):** choose **B (Freeze/cache selectively)** for living documents with mixed heavy analysis, then add a periodic full rebuild to detect drift.

## Chunk conventions (required)
- Recommend consistent chunk naming and options across the project:
  - predictable labels,
  - consistent message/warning handling,
  - consistent figure/caption conventions.
- Prefer conventions that keep HTML output clean and reviewer-friendly.

## Citations, cross-references, and navigation (required)
- Prefer Quarto-native citations and bibliography config.
- Require consistent citation style and bibliography settings across the project.
- Use Quarto-native cross-references for sections/figures/tables and keep captions meaningful (supports navigation + audit trail).

## Publishing & “living document” workflow (required)
- Prefer workflows that support frequent updates with confidence:
  - `quarto preview` for local iteration,
  - `quarto render` for reproducible builds.
- For publishing automation:
  - require a clear definition of done (what branch/artifact is deployed),
  - require failure visibility (logs, CI status),
  - ensure the pipeline matches the chosen execution policy.

## Maintainability & reviewability (required)
- Keep chapters small and focused; prefer incremental updates.
- Avoid undocumented custom filters/templates unless:
  - justified,
  - documented (what problem they solve),
  - and tested against rendering regressions.

## When uncertain (required)
- Do not speculate. Ask for missing constraints or point to the relevant Quarto documentation section.
- Provide 3–5 options with tradeoffs, consistent with `chat-manual`.
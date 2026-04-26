# Configure an R package repository to generate SBOM artifacts in CI

Writes a GitHub Actions workflow (`.github/workflows/sbom-r.yml`) that
generates an SBOM using Anchore's SBOM Action (Syft-based), and writes
additional environment metadata (and a copy of `renv.lock`) into
`artifacts/sbom/`.

## Usage

``` r
use_sbom(dest_dir = ".", overwrite = FALSE, quiet = FALSE)
```

## Arguments

- dest_dir:

  Character. Path to the repository root. Defaults to `"."`.

- overwrite:

  Logical. Overwrite an existing workflow file? Defaults to `FALSE`.

- quiet:

  Logical. Suppress informational messages? Defaults to `FALSE`.

## Value

Character vector of written/updated file paths (invisibly).

## Details

This function is intended to be run once during initial repository setup
in an interactive session (similar to the `usethis` pattern).

What this function does:

- Validates that `dest_dir` is an R package root (has `DESCRIPTION`).

- Creates `.github/workflows/` if missing.

- Writes `.github/workflows/sbom-r.yml` (fails if it exists and
  `overwrite = FALSE`).

- Ensures ignore rules:

  - Adds `/artifacts/` to `.gitignore`

  - Adds `^artifacts$` to `.Rbuildignore`

Next steps after running:

- Ensure `reproducibleai` is included in the project's `renv.lock`
  (install it and run
  [`renv::snapshot()`](https://rdrr.io/pkg/renv/man/snapshot.html) if
  needed).

- Commit changes and open a PR to verify the workflow produces an SBOM
  bundle.

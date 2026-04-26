#' Configure an R package repository to generate SBOM artifacts in CI
#'
#' Writes a GitHub Actions workflow (`.github/workflows/sbom-r.yml`) that generates
#' an SBOM using Anchore's SBOM Action (Syft-based), and writes additional
#' environment metadata (and a copy of `renv.lock`) into `artifacts/sbom/`.
#'
#' This function is intended to be run once during initial repository setup in
#' an interactive session (similar to the `usethis` pattern).
#'
#' What this function does:
#' - Validates that `dest_dir` is an R package root (has `DESCRIPTION`).
#' - Creates `.github/workflows/` if missing.
#' - Writes `.github/workflows/sbom-r.yml` (fails if it exists and `overwrite = FALSE`).
#' - Ensures ignore rules:
#'   - Adds `/artifacts/` to `.gitignore`
#'   - Adds `^artifacts$` to `.Rbuildignore`
#'
#' Next steps after running:
#' - Ensure `reproducibleai` is included in the project's `renv.lock`
#'   (install it and run `renv::snapshot()` if needed).
#' - Commit changes and open a PR to verify the workflow produces an SBOM bundle.
#'
#' @param dest_dir Character. Path to the repository root. Defaults to `"."`.
#' @param overwrite Logical. Overwrite an existing workflow file? Defaults to `FALSE`.
#' @param quiet Logical. Suppress informational messages? Defaults to `FALSE`.
#'
#' @return Character vector of written/updated file paths (invisibly).
#'
#' @export
use_sbom <- function(dest_dir = ".",
                     overwrite = FALSE,
                     quiet = FALSE) {
  # Interactive-only (usethis pattern) ----
  if (!interactive()) {
    stop("`use_sbom()` must be run in an interactive R session.", call. = FALSE)
  }

  # Validate inputs ----
  if (!is.character(dest_dir) || length(dest_dir) != 1 || !nzchar(dest_dir)) {
    stop("`dest_dir` must be a non-empty character scalar.", call. = FALSE)
  }
  if (!is.logical(overwrite) || length(overwrite) != 1) {
    stop("`overwrite` must be TRUE/FALSE.", call. = FALSE)
  }
  if (!is.logical(quiet) || length(quiet) != 1) {
    stop("`quiet` must be TRUE/FALSE.", call. = FALSE)
  }

  # Validate R package root ----
  desc_path <- file.path(dest_dir, "DESCRIPTION")
  if (!file.exists(desc_path)) {
    stop(
      "No DESCRIPTION found at: ", desc_path, "\n",
      "`use_sbom()` must be run from an R package project root (or supply `dest_dir`).",
      call. = FALSE
    )
  }

  out_paths <- character(0)

  # Ensure workflow directory exists ----
  workflows_dir <- file.path(dest_dir, ".github", "workflows")
  if (!dir.exists(workflows_dir)) {
    dir.create(workflows_dir, recursive = TRUE, showWarnings = FALSE)
    if (!dir.exists(workflows_dir)) {
      stop("Failed to create directory: ", workflows_dir, call. = FALSE)
    }
    if (!quiet) message("Created directory: ", workflows_dir)
  }

  # Write workflow file ----
  workflow_path <- file.path(workflows_dir, "sbom-r.yml")

  if (file.exists(workflow_path) && !overwrite) {
    stop(
      "Workflow already exists: ", workflow_path, "\n",
      "Set `overwrite = TRUE` to replace it.",
      call. = FALSE
    )
  }

  workflow_yml <- sbom_workflow_template_r()

  writeLines(workflow_yml, con = workflow_path, useBytes = TRUE)
  out_paths <- c(out_paths, workflow_path)
  if (!quiet) message("Wrote: ", workflow_path)

  # Update ignore files ----
  gitignore_path <- file.path(dest_dir, ".gitignore")
  rbuildignore_path <- file.path(dest_dir, ".Rbuildignore")

  out_paths <- c(out_paths, ensure_ignore_line(
    path = gitignore_path,
    line = "/artifacts/",
    quiet = quiet
  ))

  out_paths <- c(out_paths, ensure_ignore_line(
    path = rbuildignore_path,
    line = "^artifacts$",
    quiet = quiet
  ))

  # Guidance ----
  if (!quiet) {
    message("")
    message("Next steps:")
    message("- Ensure `reproducibleai` is included in this project's renv.lock.")
    message("  (If needed: install it, then run `renv::snapshot()`.)")
    message("- Commit the new workflow and ignore-file updates.")
    message("- Open a PR and confirm the 'sbom-r' workflow uploads an SBOM artifact bundle.")
  }

  invisible(unique(out_paths))
}

#' Workflow template for SBOM generation (R packages)
#'
#' Returns the GitHub Actions workflow YAML text used by `use_sbom()`.
#'
#' - Uses Anchore's SBOM Action (Syft-based) to generate an SBOM (default: SPDX JSON).
#' - Writes SBOM-adjacent environment metadata via `reproducibleai::write_sbom_env()`.
#' - Uploads the `artifacts/sbom/` directory as a single artifact bundle with
#'   120-day retention (subject to org/repo policy).
#'
#' @return A single character string containing the YAML workflow.
#' @keywords internal
sbom_workflow_template_r <- function() {
  paste(
    "on:",
    "  push:",
    "    branches: [main]",
    "  pull_request:",
    "",
    "name: sbom-r",
    "",
    "jobs:",
    "  sbom-r:",
    "    runs-on: ubuntu-latest",
    "",
    "    steps:",
    "      - name: Checkout",
    "        uses: actions/checkout@v4",
    "",
    "      - name: Setup R",
    "        uses: r-lib/actions/setup-r@v2",
    "        with:",
    "          use-public-rspm: true",
    "",
    "      - name: Install system dependencies (sf/gdal/proj/geos/etc.)",
    "        run: |",
    "          sudo apt-get update",
    "          sudo apt-get install -y --no-install-recommends \\",
    "            libcurl4-openssl-dev \\",
    "            libssl-dev \\",
    "            libxml2-dev \\",
    "            libfontconfig1-dev \\",
    "            libfreetype6-dev \\",
    "            libharfbuzz-dev \\",
    "            libfribidi-dev \\",
    "            libpng-dev \\",
    "            libtiff5-dev \\",
    "            libjpeg-dev \\",
    "            libgeos-dev \\",
    "            libproj-dev \\",
    "            proj-data \\",
    "            proj-bin \\",
    "            libgdal-dev \\",
    "            gdal-bin \\",
    "            libudunits2-dev \\",
    "            libsqlite3-dev \\",
    "            libicu-dev \\",
    "            make \\",
    "            g++ \\",
    "            git",
    "",
    "      - name: Restore renv",
    "        shell: Rscript {0}",
    "        run: |",
    "          install.packages(\"renv\")",
    "          renv::restore(prompt = FALSE)",
    "",
    "      - name: Generate SBOM (Anchore/Syft)",
    "        uses: anchore/sbom-action@v0",
    "        with:",
    "          path: \".\"",
    "          format: \"spdx-json\"",
    "          output-file: \"artifacts/sbom/sbom.spdx.json\"",
    "          upload-artifact: \"false\"",
    "          dependency-snapshot: \"false\"",
    "",
    "      - name: Write SBOM environment bundle metadata",
    "        shell: Rscript {0}",
    "        run: |",
    "          dir.create(\"artifacts/sbom\", recursive = TRUE, showWarnings = FALSE)",
    "          reproducibleai::write_sbom_env(",
    "            lockfile = \"renv.lock\",",
    "            out_dir = \"artifacts/sbom\",",
    "            overwrite = TRUE",
    "          )",
    "",
    "      - name: Upload SBOM artifact bundle",
    "        uses: actions/upload-artifact@v4",
    "        with:",
    "          name: sbom-${{ github.repository }}-${{ github.sha }}",
    "          path: artifacts/sbom",
    "          retention-days: 120",
    "",
    sep = "\n"
  )
}

#' Ensure a line exists in an ignore file (idempotent append)
#'
#' Creates the file if missing and appends the specified line if not already present.
#'
#' @param path File path to update/create.
#' @param line A single line to ensure is present.
#' @param quiet Logical. Suppress messages.
#'
#' @return The updated file path.
#' @keywords internal
ensure_ignore_line <- function(path, line, quiet = FALSE) {
  stopifnot(is.character(path), length(path) == 1, nzchar(path))
  stopifnot(is.character(line), length(line) == 1, nzchar(line))
  stopifnot(is.logical(quiet), length(quiet) == 1)

  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)

  if (!file.exists(path)) {
    writeLines(c(line, ""), con = path, useBytes = TRUE)
    if (!quiet) message("Wrote: ", path)
    return(path)
  }

  existing <- readLines(path, warn = FALSE)
  if (any(trimws(existing) == trimws(line))) {
    return(path)
  }

  writeLines(c(existing, line), con = path, useBytes = TRUE)
  if (!quiet) message("Updated: ", path)

  path
}

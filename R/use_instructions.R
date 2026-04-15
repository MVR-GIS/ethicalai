#' Write selected instruction modules into a working directory
#'
#' Copies instruction modules shipped with the package (from `inst/instructions/`)
#' into a local folder (default: `dev/instructions`) for reference in
#' reproducible chat sessions. Also writes an entrypoint file
#' (`CHAT_INSTRUCTIONS.md`) describing the selected recipe and read order.
#'
#' @param spec Character vector of module tokens, e.g.
#'   `c("chat-manual", "goals", "r-package")`.
#' @param dest_dir Character. Destination directory (default: "dev/instructions").
#' @param overwrite Logical. Overwrite existing module files? (default: TRUE).
#'   Note: the entrypoint file `CHAT_INSTRUCTIONS.md` is always overwritten.
#' @param write_entrypoint Logical. Write `CHAT_INSTRUCTIONS.md`? (default: TRUE).
#' @param quiet Logical. Suppress informational messages? (default: FALSE).
#'
#' @return Character vector of written file paths (invisibly), including the
#'   entrypoint file when `write_entrypoint = TRUE`.
#'
#' @export
use_instructions <- function(spec,
                             dest_dir = "dev/instructions",
                             overwrite = TRUE,
                             write_entrypoint = TRUE,
                             quiet = FALSE) {
  # Validate inputs ----
  if (missing(spec)) {
    stop("`spec` is required (character vector of module tokens).", call. = FALSE)
  }
  if (!is.character(spec) || length(spec) == 0) {
    stop("`spec` must be a non-empty character vector.", call. = FALSE)
  }
  if (anyNA(spec) || any(!nzchar(trimws(spec)))) {
    stop("`spec` contains missing/empty module tokens.", call. = FALSE)
  }
  if (!is.character(dest_dir) || length(dest_dir) != 1 || !nzchar(dest_dir)) {
    stop("`dest_dir` must be a non-empty character scalar.", call. = FALSE)
  }
  if (!is.logical(overwrite) || length(overwrite) != 1) {
    stop("`overwrite` must be TRUE/FALSE.", call. = FALSE)
  }
  if (!is.logical(write_entrypoint) || length(write_entrypoint) != 1) {
    stop("`write_entrypoint` must be TRUE/FALSE.", call. = FALSE)
  }
  if (!is.logical(quiet) || length(quiet) != 1) {
    stop("`quiet` must be TRUE/FALSE.", call. = FALSE)
  }

  # Normalize and de-duplicate while preserving order ----
  spec <- trimws(spec)
  spec <- spec[!duplicated(spec)]

  # Discover available modules + paths ----
  available_df <- instructions_available(include_path = TRUE)

  missing_mods <- setdiff(spec, available_df$module)
  if (length(missing_mods) > 0) {
    stop(
      "Unknown instruction module(s): ", paste(missing_mods, collapse = ", "),
      "\nAvailable modules: ", paste(available_df$module, collapse = ", "),
      call. = FALSE
    )
  }

  # Ensure destination directory exists ----
  if (!dir.exists(dest_dir)) {
    dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
    if (!dir.exists(dest_dir)) {
      stop("Failed to create destination directory: ", dest_dir, call. = FALSE)
    }
    if (!quiet) message("Created directory: ", dest_dir)
  }

  out_paths <- character(0)

  # Copy module files ----
  for (mod in spec) {
    src <- available_df$path[match(mod, available_df$module)]
    if (!file.exists(src)) {
      stop("Source file missing for module '", mod, "': ", src, call. = FALSE)
    }

    dest <- file.path(dest_dir, paste0(mod, ".md"))
    ok <- file.copy(src, dest, overwrite = overwrite)

    if (!ok) {
      stop(
        "Failed to write instruction file: ", dest,
        if (!overwrite && file.exists(dest)) " (already exists; overwrite=FALSE)" else "",
        call. = FALSE
      )
    }

    out_paths <- c(out_paths, dest)
    if (!quiet) message("Wrote: ", dest)
  }

  # Write entrypoint file (ALWAYS overwrite) ----
  if (write_entrypoint) {
    entry_path <- file.path(dest_dir, "CHAT_INSTRUCTIONS.md")

    # Build filled template pieces
    spec_r <- paste(sprintf("%s", shQuote(spec)), collapse = ", ")
    spec_bullets <- paste0("- ", spec, collapse = "\n")
    file_list <- paste0(
      seq_along(spec), ". `", file.path(dest_dir, paste0(spec, ".md")), "`",
      collapse = "\n"
    )

    # Use dest_dir-relative paths in the entrypoint for portability
    # (Most prompts will reference dev/instructions/... from repo root.)
    file_list <- paste0(
      seq_along(spec), ". `", file.path("dev", "instructions", paste0(spec, ".md")), "`",
      collapse = "\n"
    )

    entry_text <- paste(
      "# Chat instructions for this repository (start here)",
      "",
      "This file is the entrypoint for “instruction modules” that govern a reproducible chat session for this repository.",
      "",
      "## How to start a new chat session",
      "In your first message, specify the target GitHub repository and direct the assistant to follow these instructions.",
      "",
      "Suggested prompt template:",
      "",
      "> Target repo: OWNER/REPO  ",
      "> Read `dev/instructions/CHAT_INSTRUCTIONS.md` and follow the instruction modules listed under “Selected instruction modules (read in order)”.",
      "",
      "## Instruction model used here (base + overlays)",
      "We use a composable instruction system:",
      "",
      "- **Base modules**: cross-cutting rules that apply to all chats (interaction protocol + quality goals).",
      "- **Overlay modules**: domain-specific guidance that applies when relevant (e.g., Quarto books, Shiny golem apps).",
      "",
      "Overlays are intended to be **thin** and should not duplicate the base modules.",
      "",
      "## Selected recipe (this repository)",
      "Selected recipe (R syntax):",
      "",
      "```r",
      paste0("c(", spec_r, ")"),
      "```",
      "",
      "Selected modules (tokens, in order):",
      "",
      spec_bullets,
      "",
      "## Selected instruction modules (read in order)",
      "Read these files in order:",
      "",
      file_list,
      "",
      "## If the assistant cannot read repository files",
      "If the chat platform cannot access repository files, paste the contents of:",
      "1) this file (`CHAT_INSTRUCTIONS.md`), then",
      "2) each of the modules listed above (in order),",
      "into the chat.",
      "",
      sep = "\n"
    )

    writeLines(entry_text, con = entry_path, useBytes = TRUE)

    out_paths <- c(out_paths, entry_path)
    if (!quiet) message("Wrote: ", entry_path)
  }

  invisible(out_paths)
}
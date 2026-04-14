#' Write selected instruction modules into a working directory
#'
#' Copies instruction modules shipped with the package (from `inst/instructions/`)
#' into a local folder (default: `dev/instructions`) for reference in
#' reproducible chat sessions.
#'
#' @param spec Character vector of module tokens, e.g.
#'   `c("chat-manual", "goals", "r-package")`.
#' @param dest_dir Character. Destination directory (default: "dev/instructions").
#' @param overwrite Logical. Overwrite existing files? (default: TRUE).
#' @param quiet Logical. Suppress informational messages? (default: FALSE).
#'
#' @return Character vector of written file paths (invisibly).
#'
#' @export
use_instructions <- function(spec,
                             dest_dir = "dev/instructions",
                             overwrite = TRUE,
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
  if (!is.logical(quiet) || length(quiet) != 1) {
    stop("`quiet` must be TRUE/FALSE.", call. = FALSE)
  }

  # Normalize and de-duplicate while preserving order ----
  spec <- trimws(spec)
  spec <- spec[!duplicated(spec)]

  # Discover available modules + paths ----
  available_df <- instructions_available(include_path = TRUE)

  requested <- spec
  missing_mods <- setdiff(requested, available_df$module)
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

  # Copy files ----
  out_paths <- character(length(requested))

  for (i in seq_along(requested)) {
    mod <- requested[i]

    src <- available_df$path[match(mod, available_df$module)]
    if (!file.exists(src)) {
      # Should not happen, but keep error explicit.
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

    out_paths[i] <- dest
    if (!quiet) message("Wrote: ", dest)
  }

  invisible(out_paths)
}
#' Write SBOM environment bundle metadata for an R package repo
#'
#' Writes a lightweight environment manifest and copies the specified `renv.lock`
#' into an SBOM artifact bundle directory (default: `artifacts/sbom`).
#'
#' This function is intended to be called from CI after `renv::restore()` and SBOM
#' generation steps (e.g., Anchore SBOM Action). It does not generate the SBOM
#' itself; it creates additional evidence that documents the environment associated
#' with the SBOM artifact.
#'
#' Files written:
#' - `<Package>_env_sha-<shortsha>.txt`: environment manifest (Package/Version, git SHA,
#'   R version/platform, timestamp, lockfile hash)
#' - `renv.lock`: copy of the lockfile used
#'
#' @param lockfile Character. Path to `renv.lock` (default `"renv.lock"`).
#' @param out_dir Character. Output directory for the SBOM bundle.
#'   Default `file.path("artifacts", "sbom")`.
#' @param overwrite Logical. Overwrite existing bundle files? Defaults to `TRUE`.
#' @param quiet Logical. Suppress informational messages? Defaults to `FALSE`.
#'
#' @return Character vector of written file paths (invisibly).
#'
#' @export
write_sbom_env <- function(lockfile = "renv.lock",
                           out_dir = file.path("artifacts", "sbom"),
                           overwrite = TRUE,
                           quiet = FALSE) {
  # Validate inputs ----
  if (!is.character(lockfile) || length(lockfile) != 1 || !nzchar(lockfile)) {
    stop("`lockfile` must be a non-empty character scalar.", call. = FALSE)
  }
  if (!is.character(out_dir) || length(out_dir) != 1 || !nzchar(out_dir)) {
    stop("`out_dir` must be a non-empty character scalar.", call. = FALSE)
  }
  if (!is.logical(overwrite) || length(overwrite) != 1) {
    stop("`overwrite` must be TRUE/FALSE.", call. = FALSE)
  }
  if (!is.logical(quiet) || length(quiet) != 1) {
    stop("`quiet` must be TRUE/FALSE.", call. = FALSE)
  }

  # Validate expected files ----
  if (!file.exists("DESCRIPTION")) {
    stop("No DESCRIPTION found in working directory. Run from an R package root.", call. = FALSE)
  }
  if (!file.exists(lockfile)) {
    stop("Lockfile not found: ", lockfile, call. = FALSE)
  }

  # Ensure output dir ----
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
    if (!dir.exists(out_dir)) {
      stop("Failed to create output directory: ", out_dir, call. = FALSE)
    }
    if (!quiet) message("Created directory: ", out_dir)
  }

  # Read DESCRIPTION metadata ----
  pkg <- read_dcf_field("DESCRIPTION", "Package")
  ver <- read_dcf_field("DESCRIPTION", "Version")

  # Determine commit SHA ----
  sha <- Sys.getenv("GITHUB_SHA")
  if (!nzchar(sha)) {
    sha <- try_git_sha()
  }
  sha_short <- if (nzchar(sha)) substr(sha, 1, 7) else "unknown"

  # Hash lockfile (sha256) ----
  lock_hash <- lockfile_sha256(lockfile)

  env_path <- file.path(out_dir, paste0(pkg, "_env_sha-", sha_short, ".txt"))
  lock_copy_path <- file.path(out_dir, "renv.lock")

  if (!overwrite && file.exists(env_path)) {
    stop("Env manifest already exists: ", env_path, " (overwrite=FALSE)", call. = FALSE)
  }
  if (!overwrite && file.exists(lock_copy_path)) {
    stop("Lockfile copy already exists: ", lock_copy_path, " (overwrite=FALSE)", call. = FALSE)
  }

  # Copy lockfile into bundle ----
  ok <- file.copy(lockfile, lock_copy_path, overwrite = overwrite)
  if (!ok) stop("Failed to copy lockfile to: ", lock_copy_path, call. = FALSE)
  if (!quiet) message("Wrote: ", lock_copy_path)

  # Write env manifest ----
  ts_utc <- format(as.POSIXct(Sys.time(), tz = "UTC"), "%Y-%m-%dT%H:%M:%SZ")

  lines <- c(
    paste0("package: ", pkg),
    paste0("version: ", ver),
    paste0("git_sha: ", if (nzchar(sha)) sha else "unknown"),
    paste0("timestamp_utc: ", ts_utc),
    paste0("r_version: ", R.version.string),
    paste0("platform: ", R.version$platform),
    paste0("os: ", Sys.info()[["sysname"]]),
    paste0("release: ", Sys.info()[["release"]]),
    paste0("machine: ", Sys.info()[["machine"]]),
    paste0("renv_lock_sha256: ", lock_hash)
  )

  if (requireNamespace("renv", quietly = TRUE)) {
    lines <- c(lines, paste0("renv_version: ", as.character(utils::packageVersion("renv"))))
  } else {
    lines <- c(lines, "renv_version: (renv not installed in this session)")
  }

  writeLines(lines, con = env_path, useBytes = TRUE)
  if (!quiet) message("Wrote: ", env_path)

  invisible(c(env_path, lock_copy_path))
}

#' Read a field from a DCF file (DESCRIPTION)
#' @keywords internal
read_dcf_field <- function(path, field) {
  d <- tryCatch(
    read.dcf(path),
    error = function(e) stop("Failed to read DCF file: ", path, call. = FALSE)
  )
  if (!field %in% colnames(d)) {
    stop("Field '", field, "' not found in ", path, call. = FALSE)
  }
  val <- trimws(d[1, field])
  if (!nzchar(val)) {
    stop("Field '", field, "' is empty in ", path, call. = FALSE)
  }
  val
}

#' Try to read git SHA from local repository
#' @keywords internal
try_git_sha <- function() {
  if (Sys.which("git") == "") return("")
  out <- tryCatch(
    system2("git", c("rev-parse", "HEAD"), stdout = TRUE, stderr = TRUE),
    error = function(e) character(0)
  )
  if (length(out) == 0) return("")
  sha <- trimws(out[1])
  if (!grepl("^[0-9a-f]{40}$", sha)) return("")
  sha
}

#' Compute sha256 hash of a file
#'
#' Uses `openssl::sha256()` (recommended for portability). This implies `openssl`
#' should be available (Suggests is acceptable if only used in CI / tooling).
#'
#' @keywords internal
lockfile_sha256 <- function(path) {
  if (!requireNamespace("openssl", quietly = TRUE)) {
    stop(
      "Package 'openssl' is required to compute sha256. ",
      "Add it to Suggests or switch to an MD5-based hash.",
      call. = FALSE
    )
  }
  raw <- readBin(path, what = "raw", n = file.info(path)$size)
  unname(openssl::sha256(raw))
}

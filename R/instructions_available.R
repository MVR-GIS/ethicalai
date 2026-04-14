#' List available instruction modules shipped with the package
#'
#' Discovers instruction modules from `inst/instructions/*.md` at runtime.
#'
#' @param include_path Logical; if `TRUE`, return a data.frame with module names
#'   and file paths. If `FALSE` (default), return a character vector of module
#'   names.
#'
#' @return If `include_path = FALSE`, a character vector of module names.
#'   If `include_path = TRUE`, a data.frame with columns `module` and `path`.
#'
#' @export
instructions_available <- function(include_path = FALSE) {
  stopifnot(is.logical(include_path), length(include_path) == 1)

  dir <- system.file("instructions", package = "ethicalai")
  if (!nzchar(dir) || !dir.exists(dir)) {
    # This should not happen if inst/instructions is shipped correctly,
    # but the error message should be explicit.
    stop(
      "No instructions directory found in installed package. ",
      "Expected 'inst/instructions' to be installed and discoverable via system.file().",
      call. = FALSE
    )
  }

  paths <- list.files(dir, pattern = "\\.md$", full.names = TRUE)
  paths <- paths[!grepl("/_", paths)]  # ignore any optional underscore files (_manifest.md, etc.)

  modules <- sub("\\.md$", "", basename(paths))

  # stable ordering
  ord <- order(modules)
  modules <- modules[ord]
  paths <- paths[ord]

  if (!include_path) {
    return(modules)
  }

  data.frame(
    module = modules,
    path = paths,
    stringsAsFactors = FALSE
  )
}
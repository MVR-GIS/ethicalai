#' Recommended instruction compositions ("recipes")
#'
#' Returns a set of recommended instruction module compositions for common
#' workflows. Recipes are expressed as character vectors suitable for passing to
#' `use_instructions(spec = ...)`.
#'
#' Design intent:
#' - Always include base modules: `chat-manual` + `goals`.
#' - Add overlays as needed (e.g., `r-package`, `shiny-golem`, `quarto-book`,
#'   `user-manual`).
#'
#' @param validate Logical; if `TRUE`, validate that referenced modules exist in
#'   `instructions_available()`. Defaults to `TRUE`.
#'
#' @return A named list. Each element is a character vector of module tokens.
#'
#' @export
instructions_recipes <- function(validate = TRUE) {
  stopifnot(is.logical(validate), length(validate) == 1)

  recipes <- list(
    # Base-only
    base = c("chat-manual", "goals"),

    # R packages
    r_package = c("chat-manual", "goals", "r-package"),

    # Shiny apps using golem (golem == package)
    shiny_golem = c("chat-manual", "goals", "r-package", "shiny-golem"),

    # Quarto books
    quarto_book = c("chat-manual", "goals", "quarto-book"),

    # Quarto books that are also technical manuals
    quarto_user_manual = c("chat-manual", "goals", "quarto-book", "user-manual")
  )

  if (validate) {
    avail <- instructions_available()
    missing <- setdiff(unique(unlist(recipes, use.names = FALSE)), avail)

    if (length(missing) > 0) {
      stop(
        "Some recipes reference missing instruction modules: ",
        paste(missing, collapse = ", "),
        call. = FALSE
      )
    }
  }

  recipes
}
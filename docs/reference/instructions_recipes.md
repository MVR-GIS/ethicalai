# Recommended instruction compositions ("recipes")

Returns a set of recommended instruction module compositions for common
workflows. Recipes are expressed as character vectors suitable for
passing to `use_instructions(spec = ...)`.

## Usage

``` r
instructions_recipes(validate = TRUE)
```

## Arguments

- validate:

  Logical; if `TRUE`, validate that referenced modules exist in
  [`instructions_available()`](instructions_available.md). Defaults to
  `TRUE`.

## Value

A named list. Each element is a character vector of module tokens.

## Details

Design intent:

- Always include base modules: `chat-manual` + `goals`.

- Add overlays as needed (e.g., `r-package`, `shiny-golem`,
  `quarto-book`, `user-manual`).

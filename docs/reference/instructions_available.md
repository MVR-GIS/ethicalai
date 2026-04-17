# List available instruction modules shipped with the package

Discovers instruction modules from `inst/instructions/*.md` at runtime.

## Usage

``` r
instructions_available(include_path = FALSE)
```

## Arguments

- include_path:

  Logical; if `TRUE`, return a data.frame with module names and file
  paths. If `FALSE` (default), return a character vector of module
  names.

## Value

If `include_path = FALSE`, a character vector of module names. If
`include_path = TRUE`, a data.frame with columns `module` and `path`.

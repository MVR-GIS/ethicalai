# Ensure a line exists in an ignore file (idempotent append)

Creates the file if missing and appends the specified line if not
already present.

## Usage

``` r
ensure_ignore_line(path, line, quiet = FALSE)
```

## Arguments

- path:

  File path to update/create.

- line:

  A single line to ensure is present.

- quiet:

  Logical. Suppress messages.

## Value

The updated file path.

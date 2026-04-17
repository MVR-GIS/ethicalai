# Write selected instruction modules into a working directory

Copies instruction modules shipped with the package (from
`inst/instructions/`) into a local folder (default: `dev/instructions`)
for reference in reproducible chat sessions. Also writes an entrypoint
file (`CHAT_INSTRUCTIONS.md`) describing the selected recipe and read
order.

## Usage

``` r
use_instructions(
  spec,
  dest_dir = "dev/instructions",
  overwrite = TRUE,
  write_entrypoint = TRUE,
  quiet = FALSE
)
```

## Arguments

- spec:

  Character vector of module tokens, e.g.
  `c("chat-manual", "goals", "r-package")`.

- dest_dir:

  Character. Destination directory (default: "dev/instructions").

- overwrite:

  Logical. Overwrite existing module files? (default: TRUE). Note: the
  entrypoint file `CHAT_INSTRUCTIONS.md` is always overwritten.

- write_entrypoint:

  Logical. Write `CHAT_INSTRUCTIONS.md`? (default: TRUE).

- quiet:

  Logical. Suppress informational messages? (default: FALSE).

## Value

Character vector of written file paths (invisibly), including the
entrypoint file when `write_entrypoint = TRUE`.

# Write SBOM environment bundle metadata for an R package repo

Writes a lightweight environment manifest and copies the specified
`renv.lock` into an SBOM artifact bundle directory (default:
`artifacts/sbom`).

## Usage

``` r
write_sbom_env(
  lockfile = "renv.lock",
  out_dir = file.path("artifacts", "sbom"),
  overwrite = TRUE,
  quiet = FALSE
)
```

## Arguments

- lockfile:

  Character. Path to `renv.lock` (default `"renv.lock"`).

- out_dir:

  Character. Output directory for the SBOM bundle. Default
  `file.path("artifacts", "sbom")`.

- overwrite:

  Logical. Overwrite existing bundle files? Defaults to `TRUE`.

- quiet:

  Logical. Suppress informational messages? Defaults to `FALSE`.

## Value

Character vector of written file paths (invisibly).

## Details

This function is intended to be called from CI after
[`renv::restore()`](https://rdrr.io/pkg/renv/man/restore.html) and SBOM
generation steps (e.g., Anchore SBOM Action). It does not generate the
SBOM itself; it creates additional evidence that documents the
environment associated with the SBOM artifact.

Files written:

- `<Package>_env_sha-<shortsha>.txt`: environment manifest
  (Package/Version, git SHA, R version/platform, timestamp, lockfile
  hash)

- `renv.lock`: copy of the lockfile used

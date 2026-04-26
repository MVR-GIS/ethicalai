# Workflow template for SBOM generation (R packages)

Returns the GitHub Actions workflow YAML text used by
[`use_sbom()`](use_sbom.md).

## Usage

``` r
sbom_workflow_template_r()
```

## Value

A single character string containing the YAML workflow.

## Details

- Uses Anchore's SBOM Action (Syft-based) to generate an SBOM (default:
  SPDX JSON).

- Writes SBOM-adjacent environment metadata via
  [`reproducibleai::write_sbom_env()`](write_sbom_env.md).

- Uploads the `artifacts/sbom/` directory as a single artifact bundle
  with 120-day retention (subject to org/repo policy).

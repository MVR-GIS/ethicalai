# Compute sha256 hash of a file

Uses
[`openssl::sha256()`](https://jeroen.r-universe.dev/openssl/reference/hash.html)
when available (recommended for portability). If `openssl` is not
installed, returns a sentinel string rather than erroring.

## Usage

``` r
lockfile_sha256(path)
```

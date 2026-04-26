test_that("use_sbom() writes workflow + ignore rules", {
  tmp <- withr::local_tempdir()

  # Minimal DESCRIPTION to satisfy validation
  writeLines(
    c(
      "Package: examplepkg",
      "Title: Example",
      "Version: 0.0.1"
    ),
    con = file.path(tmp, "DESCRIPTION")
  )

  out <- withr::with_dir(tmp, {
    use_sbom(dest_dir = ".", overwrite = FALSE, quiet = TRUE)
  })

  expect_type(out, "character")

  wf <- file.path(tmp, ".github", "workflows", "sbom-r.yml")
  expect_true(file.exists(wf))

  wf_txt <- paste(readLines(wf, warn = FALSE), collapse = "\n")
  expect_match(wf_txt, "name: sbom-r", fixed = TRUE)
  expect_match(wf_txt, "anchore/sbom-action@v0", fixed = TRUE)
  expect_match(wf_txt, "output-file: \"artifacts/sbom/sbom.spdx.json\"", fixed = TRUE)
  expect_match(wf_txt, "retention-days: 120", fixed = TRUE)

  expect_true(file.exists(file.path(tmp, ".gitignore")))
  expect_true(file.exists(file.path(tmp, ".Rbuildignore")))

  gi <- readLines(file.path(tmp, ".gitignore"), warn = FALSE)
  expect_true(any(trimws(gi) == "/artifacts/"))

  rbi <- readLines(file.path(tmp, ".Rbuildignore"), warn = FALSE)
  expect_true(any(trimws(rbi) == "^artifacts$"))
})

test_that("use_sbom() errors if workflow exists and overwrite=FALSE", {
  tmp <- withr::local_tempdir()
  writeLines(
    c("Package: examplepkg", "Title: Example", "Version: 0.0.1"),
    con = file.path(tmp, "DESCRIPTION")
  )

  dir.create(file.path(tmp, ".github", "workflows"), recursive = TRUE, showWarnings = FALSE)
  writeLines("existing", con = file.path(tmp, ".github", "workflows", "sbom-r.yml"))

  expect_error(
    withr::with_dir(tmp, use_sbom(overwrite = FALSE, quiet = TRUE)),
    "already exists",
    fixed = FALSE
  )
})

test_that("use_sbom() validates package root", {
  tmp <- withr::local_tempdir()
  expect_error(
    withr::with_dir(tmp, use_sbom(quiet = TRUE)),
    "No DESCRIPTION",
    fixed = FALSE
  )
})

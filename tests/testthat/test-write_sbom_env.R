test_that("write_sbom_env() writes env manifest and lockfile copy (sha256)", {
  skip_if_not_installed("openssl")

  tmp <- withr::local_tempdir()

  writeLines(
    c("Package: examplepkg", "Title: Example", "Version: 0.0.1"),
    con = file.path(tmp, "DESCRIPTION")
  )
  writeLines("{\"R\": {\"Version\": \"4.4.0\"}}", con = file.path(tmp, "renv.lock"))

  withr::local_envvar(GITHUB_SHA = "0123456789abcdef0123456789abcdef01234567")

  out <- withr::with_dir(tmp, {
    write_sbom_env(lockfile = "renv.lock", out_dir = "artifacts/sbom", overwrite = TRUE, quiet = TRUE)
  })

  expect_true(file.exists(file.path(tmp, "artifacts", "sbom", "renv.lock")))

  env_path <- file.path(tmp, "artifacts", "sbom", "examplepkg_env_sha-0123456.txt")
  expect_true(file.exists(env_path))

  env_txt <- paste(readLines(env_path, warn = FALSE), collapse = "\n")
  expect_match(env_txt, "package: examplepkg", fixed = TRUE)
  expect_match(env_txt, "version: 0.0.1", fixed = TRUE)
  expect_match(env_txt, "git_sha: 0123456789abcdef", fixed = FALSE)
  expect_match(env_txt, "renv_lock_sha256: ", fixed = TRUE)
})

test_that("write_sbom_env() errors if lockfile missing", {
  tmp <- withr::local_tempdir()
  writeLines(
    c("Package: examplepkg", "Title: Example", "Version: 0.0.1"),
    con = file.path(tmp, "DESCRIPTION")
  )

  expect_error(
    withr::with_dir(tmp, write_sbom_env(lockfile = "renv.lock", out_dir = "artifacts/sbom", quiet = TRUE)),
    "Lockfile not found",
    fixed = FALSE
  )
})

test_that("use_instructions() writes selected modules to a destination directory", {
  tmp <- withr::local_tempdir()
  dest_dir <- file.path(tmp, "dev", "instructions")

  out <- use_instructions(
    spec = c("chat-manual", "goals"),
    dest_dir = dest_dir,
    quiet = TRUE
  )

  expect_type(out, "character")
  expect_true(all(file.exists(out)))

  expect_equal(
    sort(basename(out)),
    sort(c("chat-manual.md", "goals.md"))
  )

  # Content should match installed sources
  src_dir <- system.file("instructions", package = "ethicalai")
  expect_true(nzchar(src_dir))
  expect_identical(
    readLines(file.path(dest_dir, "chat-manual.md"), warn = FALSE),
    readLines(file.path(src_dir, "chat-manual.md"), warn = FALSE)
  )
})

test_that("use_instructions() validates spec", {
  expect_error(use_instructions(), "`spec` is required", fixed = FALSE)
  expect_error(use_instructions(spec = character()), "non-empty character", fixed = FALSE)
  expect_error(use_instructions(spec = NA_character_), "missing/empty", fixed = FALSE)
  expect_error(use_instructions(spec = "  "), "missing/empty", fixed = FALSE)
})

test_that("use_instructions() errors on unknown modules and prints available modules", {
  expect_error(
    use_instructions(spec = c("does-not-exist"), dest_dir = withr::local_tempdir(), quiet = TRUE),
    "Available modules",
    fixed = FALSE
  )
})

test_that("use_instructions() honors overwrite=FALSE", {
  tmp <- withr::local_tempdir()
  dest_dir <- file.path(tmp, "dev", "instructions")

  # First write
  out1 <- use_instructions(
    spec = c("chat-manual"),
    dest_dir = dest_dir,
    overwrite = TRUE,
    quiet = TRUE
  )
  expect_true(file.exists(out1))

  # Second write should fail if overwrite=FALSE
  expect_error(
    use_instructions(
      spec = c("chat-manual"),
      dest_dir = dest_dir,
      overwrite = FALSE,
      quiet = TRUE
    ),
    "overwrite=FALSE",
    fixed = FALSE
  )
})

test_that("use_instructions() de-duplicates spec while preserving order", {
  tmp <- withr::local_tempdir()
  dest_dir <- file.path(tmp, "dev", "instructions")

  out <- use_instructions(
    spec = c("goals", "goals", "chat-manual"),
    dest_dir = dest_dir,
    quiet = TRUE
  )

  expect_equal(basename(out), c("goals.md", "chat-manual.md"))
})
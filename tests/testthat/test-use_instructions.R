test_that("use_instructions() writes selected modules and CHAT_INSTRUCTIONS.md", {
  tmp <- withr::local_tempdir()
  dest_dir <- file.path(tmp, "dev", "instructions")

  out <- use_instructions(
    spec = c("chat-manual", "goals"),
    dest_dir = dest_dir,
    quiet = TRUE
  )

  expect_type(out, "character")
  expect_true(all(file.exists(out)))

  # Should include module files + entrypoint
  expect_equal(
    sort(basename(out)),
    sort(c("chat-manual.md", "goals.md", "CHAT_INSTRUCTIONS.md"))
  )

  # Content should match installed sources for module files
  src_dir <- system.file("instructions", package = "ethicalai")
  expect_true(nzchar(src_dir))

  expect_identical(
    readLines(file.path(dest_dir, "chat-manual.md"), warn = FALSE),
    readLines(file.path(src_dir, "chat-manual.md"), warn = FALSE)
  )

  # Entrypoint should mention the selected recipe and include module tokens
  entry <- paste(readLines(file.path(dest_dir, "CHAT_INSTRUCTIONS.md"), warn = FALSE), collapse = "\n")
  expect_match(entry, "Selected recipe", fixed = FALSE)
  expect_match(entry, 'c\\("chat-manual", "goals"\\)', perl = TRUE)
  expect_match(entry, "- chat-manual", fixed = TRUE)
  expect_match(entry, "- goals", fixed = TRUE)
  expect_match(entry, "dev/instructions/chat-manual.md", fixed = TRUE)
  expect_match(entry, "dev/instructions/goals.md", fixed = TRUE)
})

test_that("use_instructions() validates spec", {
  expect_error(use_instructions(), "`spec` is required", fixed = FALSE)
  expect_error(use_instructions(spec = character()), "non-empty character", fixed = FALSE)
  expect_error(use_instructions(spec = NA_character_), "missing/empty", fixed = FALSE)
  expect_error(use_instructions(spec = "  "), "missing/empty", fixed = FALSE)
})

test_that("use_instructions() errors on unknown modules and prints available modules", {
  expect_error(
    use_instructions(
      spec = c("does-not-exist"),
      dest_dir = withr::local_tempdir(),
      quiet = TRUE
    ),
    "Available modules",
    fixed = FALSE
  )
})

test_that("use_instructions() honors overwrite=FALSE for modules but always overwrites CHAT_INSTRUCTIONS.md", {
  tmp <- withr::local_tempdir()
  dest_dir <- file.path(tmp, "dev", "instructions")

  # First write
  out1 <- use_instructions(
    spec = c("chat-manual"),
    dest_dir = dest_dir,
    overwrite = TRUE,
    quiet = TRUE
  )
  expect_true(all(file.exists(out1)))

  entry_path <- file.path(dest_dir, "CHAT_INSTRUCTIONS.md")
  expect_true(file.exists(entry_path))
  entry1 <- paste(readLines(entry_path, warn = FALSE), collapse = "\n")

  # Second write with overwrite=FALSE should fail due to module file existing
  # (but we want to confirm entrypoint gets overwritten when module copy succeeds,
  # so we force a different dest_dir on the successful call below)
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

  # Demonstrate always-overwrite behavior for entrypoint:
  # Write a different recipe to same dest_dir, allowing overwrite so module copy succeeds.
  use_instructions(
    spec = c("chat-manual", "goals"),
    dest_dir = dest_dir,
    overwrite = TRUE,
    quiet = TRUE
  )

  entry2 <- paste(readLines(entry_path, warn = FALSE), collapse = "\n")
  expect_false(identical(entry1, entry2))
  expect_match(entry2, 'c\\("chat-manual", "goals"\\)', perl = TRUE)
})

test_that("use_instructions() de-duplicates spec while preserving order", {
  tmp <- withr::local_tempdir()
  dest_dir <- file.path(tmp, "dev", "instructions")

  out <- use_instructions(
    spec = c("goals", "goals", "chat-manual"),
    dest_dir = dest_dir,
    quiet = TRUE
  )

  # module files should be written once each + entrypoint
  expect_equal(
    basename(out),
    c("goals.md", "chat-manual.md", "CHAT_INSTRUCTIONS.md")
  )

  entry <- paste(readLines(file.path(dest_dir, "CHAT_INSTRUCTIONS.md"), warn = FALSE), collapse = "\n")
  expect_match(entry, 'c\\("goals", "chat-manual"\\)', perl = TRUE)
})

test_that("use_instructions(write_entrypoint=FALSE) writes only module files", {
  tmp <- withr::local_tempdir()
  dest_dir <- file.path(tmp, "dev", "instructions")

  out <- use_instructions(
    spec = c("chat-manual", "goals"),
    dest_dir = dest_dir,
    write_entrypoint = FALSE,
    quiet = TRUE
  )

  expect_equal(sort(basename(out)), sort(c("chat-manual.md", "goals.md")))
  expect_false(file.exists(file.path(dest_dir, "CHAT_INSTRUCTIONS.md")))
})
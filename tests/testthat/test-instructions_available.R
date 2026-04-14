test_that("instructions_available() returns character vector of module tokens", {
  mods <- instructions_available()

  expect_type(mods, "character")
  expect_true(length(mods) > 0)

  # should be unique + sorted
  expect_true(!anyDuplicated(mods))
  expect_identical(mods, sort(mods))

  # smoke check that known modules exist (update if you rename modules)
  expect_true(all(c("chat-manual", "goals") %in% mods))
})

test_that("instructions_available(include_path=TRUE) returns module/path data.frame", {
  df <- instructions_available(include_path = TRUE)

  expect_s3_class(df, "data.frame")
  expect_true(all(c("module", "path") %in% names(df)))

  expect_type(df$module, "character")
  expect_type(df$path, "character")

  # Paths should exist and end in .md
  expect_true(all(file.exists(df$path)))
  expect_true(all(grepl("\\.md$", df$path)))

  # module tokens should correspond to filenames
  expect_identical(df$module, sub("\\.md$", "", basename(df$path)))

  # stable ordering
  expect_identical(df$module, sort(df$module))
})

test_that("instructions_available() ignores underscore-prefixed files", {
  # This test is conditional: it only asserts behavior if such a file exists.
  df <- instructions_available(include_path = TRUE)
  has_underscore_file <- any(grepl("/_[^/]*\\.md$", df$path))

  if (has_underscore_file) {
    fail("instructions_available() should ignore underscore-prefixed .md files.")
  } else {
    succeed()
  }
})
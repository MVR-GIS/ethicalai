test_that("instructions_recipes() returns named list of character vectors", {
  rec <- instructions_recipes(validate = FALSE)

  expect_type(rec, "list")
  expect_true(length(rec) > 0)
  expect_true(!is.null(names(rec)))
  expect_true(all(nzchar(names(rec))))

  for (nm in names(rec)) {
    expect_type(rec[[nm]], "character")
    expect_true(length(rec[[nm]]) > 0)
    # discourage duplicates inside a recipe (not strictly required, but good hygiene)
    expect_false(anyDuplicated(rec[[nm]]) > 0)
  }
})

test_that("instructions_recipes(validate=TRUE) references only available modules", {
  rec <- instructions_recipes(validate = TRUE)
  avail <- instructions_available()

  used <- unique(unlist(rec, use.names = FALSE))
  expect_true(all(used %in% avail))
})

test_that("instructions_recipes(validate=TRUE) errors if a recipe references a missing module", {
  # We can't directly inject a bad recipe into instructions_recipes(), so instead
  # we temporarily mask instructions_available() to simulate a missing module.
  local_mocked_bindings(
    instructions_available = function(include_path = FALSE) {
      # Return something that is missing at least one known module token used by recipes
      c("chat-manual", "goals")
    }
  )

  expect_error(
    instructions_recipes(validate = TRUE),
    "missing instruction modules",
    fixed = FALSE
  )
})
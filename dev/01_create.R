# Initialize an R package at the root of an existing git repo.
# Run from: C:/workspace/MVR-GIS/ethicalai

if (!requireNamespace("usethis", quietly = TRUE)) install.packages("usethis")
if (!requireNamespace("fs", quietly = TRUE)) install.packages("fs")
library(usethis)

# Create the package IN PLACE.
usethis::create_package(".", open = FALSE)

# Fill in the basics (edit the placeholders)
usethis::use_description(fields = list(
  Package = "ethicalai",   # must be a valid R package name
  Title   = "ethicalai",
  `Authors@R` = 'person("First", "Last", email = "you@example.com", role = c("aut", "cre"))'
))

# Pick ONE license block
usethis::use_cc0_license()

# Common starter files
usethis::use_readme_rmd()
usethis::use_news_md()
usethis::use_roxygen_md()
usethis::use_testthat()
usethis::use_coverage()
usethis::use_package_doc()

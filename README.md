<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- rmarkdown::render(input="README.Rmd", output_file = "README.md", output_format = "md_document") -->

# reproducibleai

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/MVR-GIS/reproducibleai/graph/badge.svg)](https://app.codecov.io/gh/MVR-GIS/reproducibleai)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle)
[![Project Status:
WIP](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![License:
CC0](https://img.shields.io/badge/license-CC0-blue.svg)](http://choosealicense.com/licenses/cc0-1.0/)
<!-- badges: end -->

## Description

{reproducibleai}

**Core ideas:**

-   make chat sessions reproducible by recording the exact instruction
    modules used,
-   encourage reviewability (clear inputs/outputs and rationale),
-   support an auditable workflow as teams adopt AI tooling.

------------------------------------------------------------------------

## Authors

-   [Michael Dougherty](mailto:Michael.P.Dougherty@usace.army.mil),
    Geographer, Rock Island District, U.S. Army Corps of Engineers
    <a itemprop="sameAs" content="https://orcid.org/0000-0002-1465-5927" href="https://0000-0002-1465-5927" target="orcid.widget" rel="me noopener noreferrer" style="vertical-align:top;">
    <img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" alt="ORCID iD icon" style="width:1em;margin-right:.5em;"/>https://orcid.org/0000-0002-1465-5927</a>

------------------------------------------------------------------------

## Installation

You can install the development version from GitHub with:

    # install.packages("pak")
    pak::pak("MVR-GIS/reproducibleai")

## Quick start

1.  See which instruction modules are available

<!-- -->

    library(reproducibleai)
    instructions_available()
    #> [1] "chat-manual" "goals"       "quarto-book" "r-package"   "shiny-golem" "user-manual"

1.  Use a recommended recipe

<!-- -->

    recipes <- instructions_recipes()
    recipes$r_package
    #> [1] "chat-manual" "goals"       "r-package"

1.  Write instructions into your project

<!-- -->

    use_instructions(recipes$r_package)
    # writes into dev/instructions/ by default

------------------------------------------------------------------------

## Vignettes

    # What vignettes exist for this package?
    vignette(package = "reproducibleai")

## Bug reports

Please open an issue at:
<https://github.com/MVR-GIS/reproducibleai/issues>

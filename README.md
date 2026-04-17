<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- rmarkdown::render(input="README.Rmd", output_file = "README.md", output_format = "md_document") -->

# reproducibleai

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/MVR-GIS/reproducibleai/graph/badge.svg)](https://app.codecov.io/gh/MVR-GIS/reproducibleai)[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle)
[![Project Status:
WIP](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![License:
CC0](https://img.shields.io/badge/license-CC0-blue.svg)](http://choosealicense.com/licenses/cc0-1.0/)

## Description

An R package of tools to help teams adopt a reproducible workflow for
AI-assisted projects. This package contains a set of tools to assist
data science professionals adopt efficient workflows during the early
stages of AI adoption. We hold the opinionated view that the ethical use
of AI requires data scientists to make well-informed, concious decisions
throughout the analysis process. These tools are a work in progress and
designed to help our team experiment with developing new methodologies
for AI-assisted workflows. These tools help to define repeatable
framework of chat instructions between sessions and across teams. Tools
are provided to create a transparent audit trail to evaluate the of AI.

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
    #> Wrote: dev/instructions/chat-manual.md
    #> Wrote: dev/instructions/goals.md
    #> Wrote: dev/instructions/r-package.md
    #> Wrote: dev/instructions/CHAT_INSTRUCTIONS.md
    # writes into dev/instructions/ by default, including CHAT_INSTRUCTIONS.md

------------------------------------------------------------------------

## Vignettes

    # What vignettes exist for this package?
    vignette(package = "reproducibleai")

## Bug reports

Please open an issue at:
<https://github.com/MVR-GIS/reproducibleai/issues>

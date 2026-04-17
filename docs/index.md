# reproducibleai

## Description

{reproducibleai} is an R package of tools to help teams adopt a
reproducible workflow for AI-assisted projects. This package contains a
set of tools to assist data science professionals adopt efficient
workflows during the early stages of AI adoption. We hold the
opinionated view that the ethical use of AI requires data scientists to
make well-informed, conscious decisions throughout the analysis process.
These tools are a work in progress and designed to help our team
experiment with developing new methodologies for AI-assisted workflows.
These tools help to define a repeatable framework of chat instructions
between sessions and across teams. Tools are provided to create a
transparent audit trail to evaluate the use of AI.

**Core ideas:**

- make chat sessions reproducible by recording the exact instruction
  modules used,
- encourage reviewability (clear inputs/outputs and rationale),
- support an auditable workflow as teams adopt AI tooling.

------------------------------------------------------------------------

## Authors

- [Michael Dougherty](mailto:Michael.P.Dougherty@usace.army.mil),
  Geographer, Rock Island District, U.S. Army Corps of Engineers
  [![ORCID iD
  icon](https://orcid.org/sites/default/files/images/orcid_16x16.png)https://orcid.org/0000-0002-1465-5927](https://0000-0002-1465-5927)

------------------------------------------------------------------------

## Installation

You can install the development version from GitHub with:

``` R
# install.packages("pak")
pak::pak("MVR-GIS/reproducibleai")
```

## Quick start

1.  See which instruction modules are available

``` R
library(reproducibleai)
instructions_available()
#> [1] "chat-manual" "goals"       "quarto-book" "r-package"   "shiny-golem" "user-manual"
```

1.  Use a recommended recipe

``` R
recipes <- instructions_recipes()
recipes$r_package
#> [1] "chat-manual" "goals"       "r-package"
```

1.  Write instructions into your project

``` R
use_instructions(recipes$r_package)
# writes into dev/instructions/ by default
```

------------------------------------------------------------------------

## Vignettes

``` R
# What vignettes exist for this package?
vignette(package = "reproducibleai")
```

## Bug reports

Please open an issue at:
<https://github.com/MVR-GIS/reproducibleai/issues>

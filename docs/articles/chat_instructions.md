# Reproducible chat instructions

This vignette shows how to:

- discover which instruction modules are shipped with
  `{reproducibleai}`,
- use recommended compositions (“recipes”),
- write selected instruction files into a local folder
  (e.g. `dev/instructions/`) so future chat sessions are reproducible,
- use the `CHAT_INSTRUCTIONS.md` entrypoint to ensure chats follow the
  intended instruction modules.

## Why instruction modules?

A reproducible chat session needs two things:

1.  **Stable guidance** (what rules the assistant should follow), and
2.  **A local record** of exactly which guidance was used.

[`use_instructions()`](../reference/use_instructions.md) supports (2) by
copying the chosen instruction modules into a known folder.

## List available modules

Use [`instructions_available()`](../reference/instructions_available.md)
to see what modules are installed with the package:

``` r
library(reproducibleai)

instructions_available()
#> [1] "chat-manual" "goals"       "quarto-book" "r-package"   "shiny-golem"
#> [6] "user-manual"
```

If you want the resolved file paths:

``` r
instructions_available(include_path = TRUE)
#>        module
#> 1 chat-manual
#> 2       goals
#> 3 quarto-book
#> 4   r-package
#> 5 shiny-golem
#> 6 user-manual
#>                                                                                                                                                         path
#> 1 C:/Users/B5PMMMPD/AppData/Local/R/cache/R/renv/library/reproducibleai-f2dbcda7/windows/R-4.5/x86_64-w64-mingw32/reproducibleai/instructions/chat-manual.md
#> 2       C:/Users/B5PMMMPD/AppData/Local/R/cache/R/renv/library/reproducibleai-f2dbcda7/windows/R-4.5/x86_64-w64-mingw32/reproducibleai/instructions/goals.md
#> 3 C:/Users/B5PMMMPD/AppData/Local/R/cache/R/renv/library/reproducibleai-f2dbcda7/windows/R-4.5/x86_64-w64-mingw32/reproducibleai/instructions/quarto-book.md
#> 4   C:/Users/B5PMMMPD/AppData/Local/R/cache/R/renv/library/reproducibleai-f2dbcda7/windows/R-4.5/x86_64-w64-mingw32/reproducibleai/instructions/r-package.md
#> 5 C:/Users/B5PMMMPD/AppData/Local/R/cache/R/renv/library/reproducibleai-f2dbcda7/windows/R-4.5/x86_64-w64-mingw32/reproducibleai/instructions/shiny-golem.md
#> 6 C:/Users/B5PMMMPD/AppData/Local/R/cache/R/renv/library/reproducibleai-f2dbcda7/windows/R-4.5/x86_64-w64-mingw32/reproducibleai/instructions/user-manual.md
```

## Use recommended compositions (recipes)

[`instructions_recipes()`](../reference/instructions_recipes.md)
provides opinionated, maintained “known good” compositions.

``` r
recipes <- instructions_recipes()
names(recipes)
#> [1] "base"               "r_package"          "shiny_golem"       
#> [4] "quarto_book"        "quarto_user_manual"

recipes$base
#> [1] "chat-manual" "goals"
recipes$r_package
#> [1] "chat-manual" "goals"       "r-package"
recipes$quarto_user_manual
#> [1] "chat-manual" "goals"       "quarto-book" "user-manual"
```

## Write instructions into a project folder

In a real project, you’ll usually write to `dev/instructions/`:

``` r
use_instructions(c("chat-manual", "goals", "r-package"))
```

For this vignette, we write into a temporary directory so nothing in
your working directory is modified:

``` r
tmp <- tempdir()
dest <- file.path(tmp, "dev", "instructions")

paths <- use_instructions(
  spec = c("chat-manual", "goals", "quarto-book", "user-manual"),
  dest_dir = dest,
  quiet = TRUE
)

paths
#> [1] "C:\\Users\\B5PMMMPD\\AppData\\Local\\Temp\\1\\RtmpEjdDRY/dev/instructions/chat-manual.md"      
#> [2] "C:\\Users\\B5PMMMPD\\AppData\\Local\\Temp\\1\\RtmpEjdDRY/dev/instructions/goals.md"            
#> [3] "C:\\Users\\B5PMMMPD\\AppData\\Local\\Temp\\1\\RtmpEjdDRY/dev/instructions/quarto-book.md"      
#> [4] "C:\\Users\\B5PMMMPD\\AppData\\Local\\Temp\\1\\RtmpEjdDRY/dev/instructions/user-manual.md"      
#> [5] "C:\\Users\\B5PMMMPD\\AppData\\Local\\Temp\\1\\RtmpEjdDRY/dev/instructions/CHAT_INSTRUCTIONS.md"
list.files(dest)
#> [1] "chat-manual.md"       "CHAT_INSTRUCTIONS.md" "goals.md"            
#> [4] "quarto-book.md"       "user-manual.md"
```

You can inspect the written files to confirm what guidance was used:

``` r
cat(readLines(file.path(dest, "chat-manual.md"), warn = FALSE)[1:10], sep = "\n")
#> # chat-manual — Chat Interaction Protocol (Manual / Review-First)
#> 
#> ## Scope: target repository (required)
#> - Operate only on the **explicitly specified** target repository for this chat session.
#> - If no target repo is explicitly provided in the current chat session, **STOP and ask me to specify it** (owner/repo).
#> - Do not guess the repo from usernames, prior chats, or general context.
#> 
#> ## Permissions model (required)
#> ### Allowed actions (read-only)
#> You may use read-only inspection as needed to improve accuracy, including:
```

## The `CHAT_INSTRUCTIONS.md` entrypoint

Once your selected modules have been written to `dev/instructions/`, a
chat session can start from a single entrypoint file:

- `dev/instructions/CHAT_INSTRUCTIONS.md`

The entrypoint file documents: - which instruction modules apply to this
repository, and - the order they should be read/applied.

This “entrypoint” pattern makes it easy to start a new chat session
reproducibly: you refer to **one file**, and that file declares the
selected modules.

## A practical workflow

A typical “start of day” workflow might look like:

1.  Choose a composition:
    - for Quarto technical manuals:
      `c("chat-manual", "goals", "quarto-book", "user-manual")`
    - for Shiny golem apps:
      `c("chat-manual", "goals", "r-package", "shiny-golem")`
2.  Write the modules into the project:
    - `use_instructions(spec)`
3.  Keep the resulting files under version control:
    - commit `dev/instructions/*.md` so reviewers can see exactly what
      guidance governed the chat session.
4.  Start future chat sessions from the entrypoint:
    - “Read `dev/instructions/CHAT_INSTRUCTIONS.md` and follow the
      selected instruction modules.”

## Notes on validation

- [`use_instructions()`](../reference/use_instructions.md) validates
  that requested modules exist.
- If you typo a module name, the error will include the list of
  available modules so you can correct quickly.

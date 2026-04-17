# Saving Copilot chat session history (audit trail)

This vignette demonstrates a reproducible workflow for capturing GitHub
Copilot Chat session history into a project directory to support a
transparent audit trail of AI usage.

Functions covered:

- [`extract_copilot_chat()`](../reference/extract_copilot_chat.md) —
  extract the main chat markdown from a Copilot export `.zip` into a
  dated session file
- [`cleanup_session_backups()`](../reference/cleanup_session_backups.md)
  — remove older backups to prevent `dev/sessions/.backups/` bloat

## Overview of the workflow

A typical workflow looks like:

1.  Export your Copilot Chat session as a `.zip` file.
2.  Run [`extract_copilot_chat()`](../reference/extract_copilot_chat.md)
    to write (or update) a `dev/sessions/YYYY-MM-DD[_topic].md` file.
3.  Re-run the export +
    [`extract_copilot_chat()`](../reference/extract_copilot_chat.md)
    throughout the day; the function will create timestamped backups.
4.  Periodically run
    [`cleanup_session_backups()`](../reference/cleanup_session_backups.md)
    to delete old backups.

## Setup

``` r
library(reproducibleai)
```

## A runnable example (using a synthetic export zip)

To make this vignette runnable without requiring an actual Copilot
export, we generate a tiny zip that mimics the expected structure:

- a markdown file in the **root** of the zip archive (this is what
  [`extract_copilot_chat()`](../reference/extract_copilot_chat.md) looks
  for)

``` r
tmp <- tempdir()

# Create a minimal Copilot-like export zip in a temp folder
export_dir <- file.path(tmp, "copilot_export_example")
dir.create(export_dir, showWarnings = FALSE, recursive = TRUE)

md_path <- file.path(export_dir, "copilot-chat.md")
writeLines(c(
  "# Example Copilot Chat Export",
  "",
  "This is a synthetic chat export used for the vignette.",
  "",
  "- Question: How do I do X?",
  "- Answer: Here's how..."
), md_path)

zip_path <- file.path(tmp, "copilot_export_example.zip")

# zip() works most reliably with relative paths, so temporarily setwd()
old_wd <- getwd()
setwd(export_dir)
utils::zip(zipfile = zip_path, files = basename(md_path))
setwd(old_wd)

file.exists(zip_path)
#> [1] TRUE
```

## Extract a session transcript

In a real project, you’ll typically use `sessions_dir = "dev/sessions"`
(the default). For this vignette, we write into a temp directory so we
don’t modify your project.

``` r
sessions_dir <- file.path(tmp, "dev", "sessions")

session_path <- extract_copilot_chat(
  zip_path = zip_path,
  session_date = "2026-04-14",
  topic = "documentation",
  sessions_dir = sessions_dir,
  backup = TRUE,
  quiet = TRUE
)

session_path
#> [1] "C:\\Users\\B5PMMMPD\\AppData\\Local\\Temp\\1\\RtmpgZUEXi/dev/sessions/2026-04-14_documentation.md"
readLines(session_path, warn = FALSE)[1:6]
#> [1] "# Example Copilot Chat Export"                         
#> [2] ""                                                      
#> [3] "This is a synthetic chat export used for the vignette."
#> [4] ""                                                      
#> [5] "- Question: How do I do X?"                            
#> [6] "- Answer: Here's how..."
```

## Updating the same session (and creating backups)

If you export again later and re-run
[`extract_copilot_chat()`](../reference/extract_copilot_chat.md) for the
same `session_date` + `topic`, the existing file will be overwritten and
a backup will be created in `dev/sessions/.backups/`.

To demonstrate that, we update the synthetic markdown inside the zip and
extract again.

``` r
# Update the synthetic markdown and re-zip
writeLines(c(
  "# Example Copilot Chat Export (updated)",
  "",
  "This simulates a later export from the same day.",
  "",
  "- New item added later in the session."
), md_path)

old_wd <- getwd()
setwd(export_dir)
utils::zip(zipfile = zip_path, files = basename(md_path))
setwd(old_wd)

# Extract again -> should create a backup of the previous session file
session_path2 <- extract_copilot_chat(
  zip_path = zip_path,
  session_date = "2026-04-14",
  topic = "documentation",
  sessions_dir = sessions_dir,
  backup = TRUE,
  quiet = TRUE
)

identical(session_path, session_path2)
#> [1] TRUE
```

List session files and backups:

``` r
list.files(sessions_dir, full.names = FALSE)
#> [1] "2026-04-14_documentation.md"

backup_dir <- file.path(sessions_dir, ".backups")
list.files(backup_dir, full.names = FALSE)
#> [1] "2026-04-14_documentation_backup_20260417_144619.md"
```

## Cleaning up old backups

Over time, repeated exports can create many backups. Use
[`cleanup_session_backups()`](../reference/cleanup_session_backups.md)
to delete backups older than `days_to_keep`.

First, a dry run (no deletion):

``` r
cleanup_session_backups(
  sessions_dir = sessions_dir,
  days_to_keep = 7,
  dry_run = TRUE
)
```

To actually delete eligible backups in a real project:

``` r
cleanup_session_backups(
  sessions_dir = "dev/sessions",
  days_to_keep = 7,
  dry_run = FALSE
)
```

## Recommended project conventions

For a consistent audit trail across projects:

- Store session transcripts in `dev/sessions/`
- Use `YYYY-MM-DD[_topic].md` naming (what
  [`extract_copilot_chat()`](../reference/extract_copilot_chat.md)
  produces)
- Commit `dev/sessions/*.md` to version control when appropriate for
  your org
- Decide on a backup retention policy (e.g., keep 7 or 30 days)
- Periodically run
  [`cleanup_session_backups()`](../reference/cleanup_session_backups.md)
  (or schedule it)

## Troubleshooting

Common issues:

- **“Zip file not found”**: confirm the path is correct and accessible.
- **“No .md file found in zip archive root”**:
  [`extract_copilot_chat()`](../reference/extract_copilot_chat.md)
  expects a markdown file at the root of the zip.
- **Multiple root `.md` files**: the function will use the first one
  (and warn).

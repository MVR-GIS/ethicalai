# Extract GitHub Copilot Chat from Export Zip

Extracts the main chat markdown file from a GitHub Copilot export zip
archive and saves it to dev/sessions/ with date-based naming. Supports
incremental updates throughout the day via backup and timestamp
tracking.

## Usage

``` r
extract_copilot_chat(
  zip_path,
  session_date = Sys.Date(),
  topic = NULL,
  sessions_dir = "dev/sessions",
  backup = TRUE,
  quiet = FALSE
)
```

## Arguments

- zip_path:

  Character. Path to the exported Copilot chat .zip file

- session_date:

  Character or Date. Date for the session (default: today). Format:
  "YYYY-MM-DD" or Date object

- topic:

  Character. Optional topic suffix for filename (default: NULL)

- sessions_dir:

  Character. Path to sessions directory (default: "dev/sessions")

- backup:

  Logical. Create timestamped backup before overwriting? (default: TRUE)

- quiet:

  Logical. Suppress informational messages? (default: FALSE)

## Value

Character. Path to extracted session file (invisibly)

## Details

The function is designed for incremental updates throughout a work
session:

- First call: Creates session file

- Subsequent calls: Overwrites with latest export, creating backup

- Backups stored in dev/sessions/.backups/ with timestamps

- Original filename preserved for easy reference

## Examples

``` r
if (FALSE) { # \dontrun{
# Call multiple times throughout the day - automatically handles updates
extract_copilot_chat("~/Downloads/copilot_export.zip")
# ... work for 2 hours ...
extract_copilot_chat("~/Downloads/copilot_export.zip")  # Creates backup
# ... handle brushfire ...
extract_copilot_chat("~/Downloads/copilot_export.zip")  # Another backup

# Disable backups (not recommended for active sessions)
extract_copilot_chat("~/Downloads/copilot_export.zip", backup = FALSE)

# Specify topic for multi-topic days
extract_copilot_chat(
  "~/Downloads/copilot_export.zip",
  topic = "data_validation"
)
} # }
```

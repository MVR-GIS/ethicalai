# Clean Up Old Session Backups

Removes backup files older than specified number of days to prevent
backup directory bloat.

## Usage

``` r
cleanup_session_backups(
  sessions_dir = "dev/sessions",
  days_to_keep = 7,
  dry_run = FALSE
)
```

## Arguments

- sessions_dir:

  Character. Path to sessions directory (default: "dev/sessions")

- days_to_keep:

  Numeric. Keep backups from last N days (default: 7)

- dry_run:

  Logical. Show what would be deleted without deleting? (default: FALSE)

## Value

Invisible NULL

## Examples

``` r
if (FALSE) { # \dontrun{
# See what would be deleted
cleanup_session_backups(dry_run = TRUE)

# Delete backups older than 7 days
cleanup_session_backups()

# Keep backups from last 30 days
cleanup_session_backups(days_to_keep = 30)
} # }
```

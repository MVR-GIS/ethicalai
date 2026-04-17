

## Specify Chat Instructions
reproducibleai::use_instructions(c("chat-manual", "goals", "r-package"))

## Update AI Chat Artifacts
reproducibleai::extract_copilot_chat(file.path(
  Sys.getenv("USERPROFILE"), "Downloads", "copilot_export.zip")
)


## Update docs
pkgdown::build_site()


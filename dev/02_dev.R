

## Specify Chat Instructions
reproducibleai::use_instructions(c("chat-manual", "goals", "r-package"))

## Start new chat prompt text:
# This session will be based on the `MVR-GIS/reproducibleai`
# repo `main` branch. Read `dev/instructions/CHAT_INSTRUCTIONS.md` 
# and follow the instruction modules listed under "Selected 
# instruction modules (read in order)".

## Update AI Chat Artifacts
reproducibleai::extract_copilot_chat(file.path(
  Sys.getenv("USERPROFILE"), "Downloads", "copilot_export.zip")
)


## Update docs
pkgdown::build_site()


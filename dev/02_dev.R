

## Specify Chat Instructions
ethicalai::use_instructions(c("chat-manual", "goals", "r-package"))

## Update AI Chat Artifacts
ethicalai::extract_copilot_chat(file.path(
  Sys.getenv("USERPROFILE"), "Downloads", "copilot_export.zip")
)



param(
  [string]$ConfigPath
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent (Split-Path -Parent $ConfigPath)
$agents = Get-Content -LiteralPath (Join-Path $root "AGENTS.md") -Raw
$dod = Get-Content -LiteralPath (Join-Path $root "definition-of-done.md") -Raw

@"
# Starter Codex Session

Use these local instructions as the operating contract for this project.

## AGENTS.md
$agents

## Definition of Done
$dod
"@

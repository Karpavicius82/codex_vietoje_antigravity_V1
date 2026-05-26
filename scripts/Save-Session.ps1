param(
  [Parameter(Mandatory=$true)]
  [string]$SessionFile,

  [string]$Task = "",
  [string]$Workflow = "",
  [string]$ProjectPath = "",
  [string]$Outcome = "unknown",
  [string[]]$ChangedFiles = @(),
  [string]$Notes = ""
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$SessionDir = Split-Path -Parent $SessionFile

if (-not (Test-Path -LiteralPath $SessionDir)) {
  New-Item -ItemType Directory -Force -Path $SessionDir | Out-Null
}

$entry = @{
  timestamp    = (Get-Date -Format "o")
  task         = $Task
  workflow     = $Workflow
  projectPath  = $ProjectPath
  outcome      = $Outcome
  changedFiles = $ChangedFiles
  notes        = $Notes
  durationSec  = 0
}

$json = ($entry | ConvertTo-Json -Compress)

Add-Content -LiteralPath $SessionFile -Value $json -Encoding utf8

Write-Host "Session saved to: $SessionFile"
Write-Host "  Task: $Task"
Write-Host "  Outcome: $Outcome"
Write-Host "  Changed files: $($ChangedFiles.Count)"

param(
  [string]$ConfigPath
)

$ErrorActionPreference = "Stop"

function Test-Command {
  param([string]$Name)

  $found = Get-Command $Name -ErrorAction SilentlyContinue
  if ($found) {
    Write-Host "[ok] $Name -> $($found.Source)"
  } else {
    Write-Warning "[missing] $Name"
  }
}

Write-Host "Checking environment..."
Test-Command "powershell"
Test-Command "git"
Test-Command "codex"
Test-Command "node"
Test-Command "npm"
Test-Command "python"
Write-Host "PowerShell version: $($PSVersionTable.PSVersion)"

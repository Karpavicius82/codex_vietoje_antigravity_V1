param(
  [Parameter(Mandatory=$true)]
  [string]$ConfigPath,

  [Parameter(Mandatory=$true)]
  [string]$TaskName
)

$ErrorActionPreference = "Stop"

$config = Get-Content -LiteralPath $ConfigPath -Raw | ConvertFrom-Json
$root = Split-Path -Parent $ConfigPath
$task = $config.tasks.$TaskName

if (-not $task) {
  throw "Unknown task: $TaskName"
}

foreach ($step in $task.steps) {
  if ($step.type -eq "script") {
    $scriptPath = Resolve-Path -LiteralPath (Join-Path $root $step.path)
    Write-Host "Running script: $scriptPath"
    & $scriptPath -ConfigPath $ConfigPath
    continue
  }

  if ($step.type -eq "command") {
    $args = @()
    if ($step.args) {
      $args = $step.args
    }

    Write-Host "Running command: $($step.command) $($args -join ' ')"

    try {
      & $step.command @args
      if ($LASTEXITCODE -ne 0) {
        throw "Command exited with code $LASTEXITCODE"
      }
    } catch {
      if ($step.optional) {
        Write-Warning "Optional step failed: $($_.Exception.Message)"
      } else {
        throw
      }
    }

    continue
  }

  throw "Unsupported step type: $($step.type)"
}

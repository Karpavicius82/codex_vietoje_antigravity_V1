param(
  [Parameter(Mandatory=$true)]
  [string]$ConfigPath
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ConfigPath)) {
  throw "Config file does not exist: $ConfigPath"
}

$config = Get-Content -LiteralPath $ConfigPath -Raw | ConvertFrom-Json

if ($config.version -ne 1) {
  throw "Unsupported config version: $($config.version)"
}

if (-not $config.tasks) {
  throw "Config must define at least one task."
}

foreach ($taskProp in $config.tasks.PSObject.Properties) {
  $taskName = $taskProp.Name
  $task = $taskProp.Value

  if (-not $task.steps -or $task.steps.Count -eq 0) {
    throw "Task '$taskName' has no steps."
  }

  foreach ($step in $task.steps) {
    if ($step.type -notin @("command", "script")) {
      throw "Task '$taskName' has invalid step type: $($step.type)"
    }

    if ($step.type -eq "command" -and -not $step.command) {
      throw "Task '$taskName' has command step without command."
    }

    if ($step.type -eq "script" -and -not $step.path) {
      throw "Task '$taskName' has script step without path."
    }
  }
}

Write-Host "Config is valid."

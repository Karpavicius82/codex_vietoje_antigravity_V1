param(
  [Parameter(Position = 0)]
  [ValidateSet("init", "doctor", "validate", "list", "run", "clean", "status", "help", "board", "summary", "snapshot", "test", "zipscan", "importcheck")]
  [string]$Command = "list",

  [Parameter(Position = 1)]
  [string]$TaskName
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigPath = Join-Path $Root "codex-vietoje.config.json"

function Read-Config {
  if (-not (Test-Path -LiteralPath $ConfigPath)) {
    throw "Missing config: $ConfigPath"
  }

  Get-Content -LiteralPath $ConfigPath -Raw | ConvertFrom-Json
}

switch ($Command) {
  "init" {
    $dirs = @("workspace", "logs", "scripts", "memory", "memory\sessions", "memory\knowledge-base")
    foreach ($dir in $dirs) {
      New-Item -ItemType Directory -Force -Path "$Root\$dir" | Out-Null
    }
    Write-Host "Initialized Codex vietoje Antigravity."
    Write-Host "Created directories: $($dirs -join ', ')"
  }

  "validate" {
    & "$Root\scripts\Test-Config.ps1" -ConfigPath $ConfigPath

    # Also validate system.json and safety.json
    $sysConfig = Join-Path $Root "config\system.json"
    $safeConfig = Join-Path $Root "config\safety.json"

    if (Test-Path -LiteralPath $sysConfig) {
      try {
        Get-Content -LiteralPath $sysConfig -Raw | ConvertFrom-Json | Out-Null
        Write-Host "[ok] system.json is valid JSON."
      } catch {
        Write-Warning "[fail] system.json is invalid: $($_.Exception.Message)"
      }
    }

    if (Test-Path -LiteralPath $safeConfig) {
      try {
        Get-Content -LiteralPath $safeConfig -Raw | ConvertFrom-Json | Out-Null
        Write-Host "[ok] safety.json is valid JSON."
      } catch {
        Write-Warning "[fail] safety.json is invalid: $($_.Exception.Message)"
      }
    }
  }

  "doctor" {
    & "$Root\scripts\Test-Environment.ps1" -ConfigPath $ConfigPath
  }

  "list" {
    $config = Read-Config
    Write-Host ""
    Write-Host "=== Tasks ==="
    $config.tasks.PSObject.Properties | ForEach-Object {
      Write-Host "  $($_.Name) - $($_.Value.description)"
    }
    Write-Host ""
    Write-Host "=== Workflows ==="
    $wfDir = Join-Path $Root "workflows"
    if (Test-Path -LiteralPath $wfDir) {
      Get-ChildItem -Path $wfDir -Filter "*.md" | ForEach-Object {
        Write-Host "  $($_.BaseName)"
      }
    }
    Write-Host ""
    Write-Host "=== Agents ==="
    $agDir = Join-Path $Root "agents"
    if (Test-Path -LiteralPath $agDir) {
      Get-ChildItem -Path $agDir -Filter "*.md" | ForEach-Object {
        Write-Host "  $($_.BaseName)"
      }
    }
    Write-Host ""
    Write-Host "=== Skills ==="
    $skDir = Join-Path $Root "skills"
    if (Test-Path -LiteralPath $skDir) {
      Get-ChildItem -Path $skDir -Directory | Where-Object { $_.Name -ne ".keep" } | ForEach-Object {
        Write-Host "  $($_.Name)"
      }
    }
  }

  "run" {
    if (-not $TaskName) {
      throw "Usage: .\codex-vietoje.ps1 run <task-name>"
    }

    & "$Root\scripts\Invoke-Task.ps1" -ConfigPath $ConfigPath -TaskName $TaskName
  }

  "clean" {
    if (Test-Path -LiteralPath "$Root\logs") {
      Remove-Item -Path "$Root\logs\*" -Force -ErrorAction SilentlyContinue
      Write-Host "Cleaned logs."
    } else {
      Write-Host "No logs directory found."
    }
  }

  "status" {
    Write-Host ""
    Write-Host "=== Codex vietoje Antigravity ==="
    $sysConfig = Join-Path $Root "config\system.json"
    if (Test-Path -LiteralPath $sysConfig) {
      $sys = Get-Content -LiteralPath $sysConfig -Raw | ConvertFrom-Json
      Write-Host "  Version: $($sys.version)"
      Write-Host "  Language: $($sys.language)"
      Write-Host "  Default workflow: $($sys.defaultWorkflow)"
      Write-Host "  Runtime mode: $($sys.codexRuntime.mode)"
    }

    Write-Host ""
    Write-Host "=== Components ==="
    $agentCount = (Get-ChildItem -Path "$Root\agents" -Filter "*.md" -ErrorAction SilentlyContinue).Count
    $wfCount = (Get-ChildItem -Path "$Root\workflows" -Filter "*.md" -ErrorAction SilentlyContinue).Count
    $skillCount = (Get-ChildItem -Path "$Root\skills" -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne ".keep" }).Count
    $templateCount = (Get-ChildItem -Path "$Root\templates" -Filter "*.md" -ErrorAction SilentlyContinue).Count
    $scriptCount = (Get-ChildItem -Path "$Root\scripts" -Filter "*.ps1" -ErrorAction SilentlyContinue).Count
    Write-Host "  Agents: $agentCount"
    Write-Host "  Workflows: $wfCount"
    Write-Host "  Skills: $skillCount"
    Write-Host "  Templates: $templateCount"
    Write-Host "  Scripts: $scriptCount"

    Write-Host ""
    Write-Host "=== Sessions ==="
    $sessionFile = Join-Path $Root "memory\sessions\sessions.jsonl"
    if (Test-Path -LiteralPath $sessionFile) {
      $lines = Get-Content -LiteralPath $sessionFile
      Write-Host "  Total sessions: $($lines.Count)"
      if ($lines.Count -gt 0) {
        $last = $lines[-1] | ConvertFrom-Json
        Write-Host "  Last session: $($last.timestamp) - $($last.task) [$($last.outcome)]"
      }
    } else {
      Write-Host "  No sessions recorded yet."
    }
  }


  "board" {
    & "$Root\scripts\Get-WorkBoard.ps1"
  }

  "summary" {
    & "$Root\scripts\Export-KnowledgeSummary.ps1"
  }

  "snapshot" {
    & "$Root\scripts\Snapshot-System.ps1"
  }

  "test" {
    & "$Root\scripts\Test-System.ps1"
  }

  "zipscan" {
    $zip = if ($TaskName) { $TaskName } else { "D:\SISTEMOS\7. Antigravity2025\GPTdev.ops.Antigravity\gpt_anti-26_test_V3_global_closure_pass7.zip" }
    & "$Root\scripts\Scan-ZipArchive.ps1" -ZipPath $zip -OutputDir "$Root\memory\knowledge-base"
  }

  "importcheck" {
    & "$Root\scripts\Test-ImportCandidates.ps1" -Root $Root
  }
  "help" {
    Write-Host ""
    Write-Host "Codex vietoje Antigravity - Lokali agentine darbo aplinka"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  init      - Initialize directories (workspace, logs, memory)"
    Write-Host "  doctor    - Check local environment (git, node, python, etc.)"
    Write-Host "  validate  - Validate configuration files"
    Write-Host "  list      - List available tasks, workflows, agents, and skills"
    Write-Host "  run       - Run a configured task: .\codex-vietoje.ps1 run <task>"
    Write-Host "  status    - Show system status and recent sessions"
    Write-Host "  board     - Show file-based work-order board"
    Write-Host "  summary   - Export latest knowledge scan summary"
    Write-Host "  snapshot  - Create system snapshot manifest"
    Write-Host "  test      - Run full v0.1 system test"
    Write-Host "  zipscan   - Scan V3/V6 zip without extracting"
    Write-Host "  importcheck - Review latest scan for safe import candidates"
    Write-Host "  clean     - Clean log files"
    Write-Host "  help      - Show this help"
    Write-Host ""
    Write-Host "Quick start:"
    Write-Host "  .\bin\codex-task.ps1 -Task 'Fix login bug' -ProjectPath 'C:\project'"
    Write-Host "  .\bin\codex-task.ps1 -Task 'Add user filter' -DryRun"
    Write-Host ""
  }
}





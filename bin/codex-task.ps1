param(
  [Parameter(Mandatory=$true)]
  [string]$Task,

  [Parameter(Mandatory=$false)]
  [string]$ProjectPath = (Get-Location).Path,

  [Parameter(Mandatory=$false)]
  [ValidateSet("feature", "bugfix", "review", "frontend-qa", "release-prep", "refactor", "debug", "migrate", "security-audit", "hotfix")]
  [string]$Workflow,

  [Parameter(Mandatory=$false)]
  [switch]$DryRun,

  [Parameter(Mandatory=$false)]
  [switch]$AutoWorkflow
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$SystemConfig = Join-Path $Root "config\system.json"
$SafetyConfig = Join-Path $Root "config\safety.json"
$TaskTemplate = Join-Path $Root "templates\task-brief.md"

if (-not (Test-Path -LiteralPath $SystemConfig)) { throw "Missing system config: $SystemConfig" }
if (-not (Test-Path -LiteralPath $SafetyConfig)) { throw "Missing safety config: $SafetyConfig" }
if (-not (Test-Path -LiteralPath $ProjectPath)) { throw "Project path does not exist: $ProjectPath" }

# Auto-detect workflow if not specified
if (-not $Workflow) {
  $selectScript = Join-Path $Root "scripts\Select-Workflow.ps1"
  if (Test-Path -LiteralPath $selectScript) {
    $Workflow = & $selectScript -Task $Task | Select-Object -Last 1
    Write-Host "Auto-selected workflow: $Workflow"
  } else {
    $Workflow = "feature"
    Write-Host "Default workflow: $Workflow"
  }
}

$WorkflowFile = Join-Path $Root "workflows\$Workflow.md"
if (-not (Test-Path -LiteralPath $WorkflowFile)) { throw "Missing workflow: $WorkflowFile" }

$System = Get-Content -LiteralPath $SystemConfig -Raw | ConvertFrom-Json
$Safety = Get-Content -LiteralPath $SafetyConfig -Raw | ConvertFrom-Json
$WorkflowText = Get-Content -LiteralPath $WorkflowFile -Raw
$Template = Get-Content -LiteralPath $TaskTemplate -Raw

# Read project config
$ProjectConfigPath = Join-Path $ProjectPath "project.codex.json"
$ProjectConfigText = if (Test-Path -LiteralPath $ProjectConfigPath) {
  Get-Content -LiteralPath $ProjectConfigPath -Raw
} else {
  "{ `"note`": `"No project.codex.json found. Infer commands from repository files.`" }"
}

# Build the prompt
$Prompt = $Template `
  -replace "\{\{TASK\}\}", $Task `
  -replace "\{\{PROJECT_PATH\}\}", $ProjectPath `
  -replace "\{\{WORKFLOW\}\}", $Workflow

$Prompt = @"
$Prompt

## System Config
``````json
$($System | ConvertTo-Json -Depth 10)
``````

## Safety Config
``````json
$($Safety | ConvertTo-Json -Depth 10)
``````

## Project Config
``````json
$ProjectConfigText
``````

## Workflow
$WorkflowText
"@

# Include agent profile based on workflow
$agentMap = @{
  "feature"        = "implementer"
  "bugfix"         = "debugger"
  "hotfix"         = "implementer"
  "refactor"       = "implementer"
  "review"         = "reviewer"
  "frontend-qa"    = "tester"
  "release-prep"   = "documenter"
  "debug"          = "debugger"
  "migrate"        = "architect"
  "security-audit" = "reviewer"
}

$agentName = $agentMap[$Workflow]
if ($agentName) {
  $agentFile = Join-Path $Root "agents\$agentName.md"
  if (Test-Path -LiteralPath $agentFile) {
    $agentText = Get-Content -LiteralPath $agentFile -Raw
    $Prompt += @"

## Primary Agent Profile
$agentText
"@
  }
}

# Include orchestrator for context
$orchestratorFile = Join-Path $Root "agents\orchestrator.md"
if (Test-Path -LiteralPath $orchestratorFile) {
  $orchestratorText = Get-Content -LiteralPath $orchestratorFile -Raw
  $Prompt += @"

## Orchestrator
$orchestratorText
"@
}

# Include relevant skills
$skillsDir = Join-Path $Root "skills"
if (Test-Path -LiteralPath $skillsDir) {
  $skillDirs = Get-ChildItem -Path $skillsDir -Directory
  foreach ($skillDir in $skillDirs) {
    $skillFile = Join-Path $skillDir.FullName "SKILL.md"
    if (Test-Path -LiteralPath $skillFile) {
      $skillText = Get-Content -LiteralPath $skillFile -Raw
      $Prompt += @"

## Skill: $($skillDir.Name)
$skillText
"@
    }
  }
}

# Include policies
$safetyPolicy = Join-Path $Root "policies\safety.md"
if (Test-Path -LiteralPath $safetyPolicy) {
  $safetyText = Get-Content -LiteralPath $safetyPolicy -Raw
  $Prompt += @"

## Safety Policy
$safetyText
"@
}

$verificationPolicy = Join-Path $Root "policies\verification.md"
if (Test-Path -LiteralPath $verificationPolicy) {
  $verificationText = Get-Content -LiteralPath $verificationPolicy -Raw
  $Prompt += @"

## Verification Policy
$verificationText
"@
}

# Include Definition of Done
$dodFile = Join-Path $Root "definition-of-done.md"
if (Test-Path -LiteralPath $dodFile) {
  $dodText = Get-Content -LiteralPath $dodFile -Raw
  $Prompt += @"

## Definition of Done
$dodText
"@
}

# Include recent sessions if available
$sessionFile = Join-Path $Root "memory\sessions\sessions.jsonl"
if (Test-Path -LiteralPath $sessionFile) {
  $recentSessions = Get-Content -LiteralPath $sessionFile -Tail 3
  if ($recentSessions) {
    $Prompt += @"

## Recent Sessions (last 3)
``````json
$($recentSessions -join "`n")
``````
"@
  }
}

if ($DryRun) {
  $Prompt
  exit 0
}

Write-Host "================================================"
Write-Host " Codex Task Prompt v0.2"
Write-Host "================================================"
Write-Host "Project:  $ProjectPath"
Write-Host "Workflow: $Workflow"
Write-Host "Agent:    $agentName"
Write-Host "================================================"
Write-Host ""
Write-Host "Paste the prompt below into Codex/Antigravity, or wire this script to your API:"
Write-Host "--------------------------------------------------------------------------"
Write-Output $Prompt

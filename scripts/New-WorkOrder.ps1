param(
  [Parameter(Mandatory=$true)]
  [string]$Title,

  [Parameter(Mandatory=$false)]
  [string]$Goal = "",

  [Parameter(Mandatory=$false)]
  [string]$Workflow = "feature",

  [Parameter(Mandatory=$false)]
  [string]$AssignedRole = "orchestrator",

  [Parameter(Mandatory=$false)]
  [ValidateSet("low", "medium", "high", "urgent")]
  [string]$Priority = "medium",

  [Parameter(Mandatory=$false)]
  [string]$Root = ""
)

$ErrorActionPreference = "Stop"
if (-not $Root) { $Root = Split-Path -Parent (Split-Path -Parent $PSCommandPath) }
$Root = (Resolve-Path -LiteralPath $Root).Path

$pending = Join-Path $Root "work-orders\pending"
New-Item -ItemType Directory -Force -Path $pending | Out-Null

$id = "wo-" + (Get-Date -Format "yyyyMMdd-HHmmss") + "-" + ([Guid]::NewGuid().ToString("N").Substring(0, 6))
$path = Join-Path $pending "$id.json"

$order = [ordered]@{
  id = $id
  title = $Title
  goal = $Goal
  workflow = $Workflow
  assignedRole = $AssignedRole
  priority = $Priority
  status = "pending"
  createdAt = (Get-Date).ToString("s")
  updatedAt = (Get-Date).ToString("s")
  source = "manual"
  notes = @()
  artifacts = @()
}

$order | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $path -Encoding UTF8
Write-Host "Created work order: $id"
Write-Host $path

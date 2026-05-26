param(
  [Parameter(Mandatory=$true)]
  [string]$Id,

  [Parameter(Mandatory=$false)]
  [ValidateSet("active", "done")]
  [string]$To = "active",

  [Parameter(Mandatory=$false)]
  [string]$Note = "",

  [Parameter(Mandatory=$false)]
  [string]$Root = ""
)

$ErrorActionPreference = "Stop"
if (-not $Root) { $Root = Split-Path -Parent (Split-Path -Parent $PSCommandPath) }
$Root = (Resolve-Path -LiteralPath $Root).Path

$fromDirs = @("pending", "active", "done") | ForEach-Object { Join-Path $Root "work-orders\$_" }
$sourceFile = $null
foreach ($dir in $fromDirs) {
  $candidate = Join-Path $dir "$Id.json"
  if (Test-Path -LiteralPath $candidate) { $sourceFile = $candidate; break }
}

if (-not $sourceFile) { throw "Work order not found: $Id" }

$targetDir = Join-Path $Root "work-orders\$To"
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
$targetFile = Join-Path $targetDir "$Id.json"

$wo = Get-Content -LiteralPath $sourceFile -Raw | ConvertFrom-Json
$wo.status = $To
$wo.updatedAt = (Get-Date).ToString("s")
if ($Note) {
  $notes = @($wo.notes)
  $notes += [pscustomobject]@{ at = (Get-Date).ToString("s"); text = $Note }
  $wo.notes = $notes
}

$wo | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $targetFile -Encoding UTF8
if ($sourceFile -ne $targetFile) { Remove-Item -LiteralPath $sourceFile -Force }
Write-Host "Moved work order $Id -> $To"

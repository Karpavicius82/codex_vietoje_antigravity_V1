param(
  [Parameter(Mandatory=$false)]
  [ValidateSet("all", "pending", "active", "done")]
  [string]$Status = "all",

  [Parameter(Mandatory=$false)]
  [string]$Root = ""
)

$ErrorActionPreference = "Stop"
if (-not $Root) { $Root = Split-Path -Parent (Split-Path -Parent $PSCommandPath) }
$Root = (Resolve-Path -LiteralPath $Root).Path

$statuses = if ($Status -eq "all") { @("pending", "active", "done") } else { @($Status) }
$rows = @()

foreach ($s in $statuses) {
  $dir = Join-Path $Root "work-orders\$s"
  if (-not (Test-Path -LiteralPath $dir)) { continue }
  foreach ($file in Get-ChildItem -LiteralPath $dir -Filter "*.json" -File -ErrorAction SilentlyContinue) {
    try {
      $wo = Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json
      $rows += [pscustomobject]@{
        Status = $s
        Priority = $wo.priority
        Workflow = $wo.workflow
        Role = $wo.assignedRole
        Id = $wo.id
        Title = $wo.title
        Updated = $wo.updatedAt
      }
    } catch {
      $rows += [pscustomobject]@{
        Status = $s
        Priority = "?"
        Workflow = "?"
        Role = "?"
        Id = $file.BaseName
        Title = "Invalid JSON: $($_.Exception.Message)"
        Updated = ""
      }
    }
  }
}

if ($rows.Count -eq 0) {
  Write-Host "No work orders found for status: $Status"
  exit 0
}

$rows | Sort-Object Status,Priority,Updated | Format-Table -AutoSize

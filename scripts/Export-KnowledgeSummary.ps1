param(
  [Parameter(Mandatory=$false)]
  [string]$Root = "",

  [Parameter(Mandatory=$false)]
  [string]$OutputDir = ""
)

$ErrorActionPreference = "Stop"
if (-not $Root) { $Root = Split-Path -Parent (Split-Path -Parent $PSCommandPath) }
$Root = (Resolve-Path -LiteralPath $Root).Path
if (-not $OutputDir) { $OutputDir = Join-Path $Root "memory\knowledge-base" }
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$latest = Get-ChildItem -LiteralPath $OutputDir -Filter "knowledge-scan-*.json" -File -ErrorAction SilentlyContinue |
  Sort-Object LastWriteTime -Descending |
  Select-Object -First 1

if (-not $latest) { throw "No knowledge-scan JSON found in $OutputDir" }

$data = Get-Content -LiteralPath $latest.FullName -Raw | ConvertFrom-Json
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$out = Join-Path $OutputDir "knowledge-summary-$stamp.md"

$high = @($data | Where-Object { $_.relevance -eq "high" -and $_.category -ne "do-not-import" })
$blocked = @($data | Where-Object { $_.relevance -eq "blocked" -or $_.category -eq "do-not-import" })
$byCategory = $data | Group-Object category | Sort-Object Count -Descending
$bySource = $data | Group-Object source | Sort-Object Name

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# Knowledge Summary $stamp")
$lines.Add("")
$lines.Add("Source scan: ``$($latest.FullName)``")
$lines.Add("")
$lines.Add("## Counts By Source")
foreach ($g in $bySource) { $lines.Add("- ``" + $g.Name + "`` - " + $g.Count) }
$lines.Add("")
$lines.Add("## Counts By Category")
foreach ($g in $byCategory) { $lines.Add("- ``" + $g.Name + "`` - " + $g.Count) }
$lines.Add("")
$lines.Add("## Top Import Candidates")
foreach ($item in ($high | Sort-Object category,size -Descending | Select-Object -First 60)) {
  $lines.Add("- [" + $item.category + "] ``" + $item.path + "``")
}
$lines.Add("")
$lines.Add("## Blocked / Do Not Import")
foreach ($item in ($blocked | Sort-Object path | Select-Object -First 80)) {
  $lines.Add("- ``" + $item.path + "``")
}
$lines.Add("")
$lines.Add("## Practical Next Imports")
$lines.Add("- Convert V26 production/readiness docs into short checklists.")
$lines.Add("- Convert V26 AGX/team ideas into file-based work-orders only.")
$lines.Add("- Keep browser bridge material in research until a browser QA workflow needs it.")
$lines.Add("- Keep nDxnD engine code as research; import only GA/control ideas as documentation.")

$lines | Set-Content -LiteralPath $out -Encoding UTF8
Write-Host "Wrote summary: $out"

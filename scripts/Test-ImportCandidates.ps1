param(
  [Parameter(Mandatory=$false)]
  [string]$Root = "",

  [Parameter(Mandatory=$false)]
  [string]$KnowledgeDir = ""
)

$ErrorActionPreference = "Stop"
if (-not $Root) { $Root = Split-Path -Parent (Split-Path -Parent $PSCommandPath) }
$Root = (Resolve-Path -LiteralPath $Root).Path
if (-not $KnowledgeDir) { $KnowledgeDir = Join-Path $Root "memory\knowledge-base" }

$latest = Get-ChildItem -LiteralPath $KnowledgeDir -File -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -like "knowledge-scan-*.json" -or $_.Name -like "zip-scan-*.json" } |
  Sort-Object LastWriteTime -Descending |
  Select-Object -First 1
if (-not $latest) { throw "No scan JSON found in $KnowledgeDir" }

$data = @(Get-Content -LiteralPath $latest.FullName -Raw | ConvertFrom-Json)
$high = @($data | Where-Object { $_.relevance -eq "high" -and $_.category -ne "do-not-import" })
$blocked = @($data | Where-Object { $_.relevance -eq "blocked" -or $_.category -eq "do-not-import" })
$runtime = @($high | Where-Object { $_.category -eq "runtime-code" })
$automation = @($high | Where-Object { $_.category -eq "automation" -or $_.category -eq "verification" })
$docs = @($high | Where-Object { $_.category -eq "documentation" -or $_.category -eq "configuration" })

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$out = Join-Path $KnowledgeDir "import-check-$stamp.md"

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# Import Check $stamp")
$lines.Add("")
$lines.Add("Scan: ``$($latest.FullName)``")
$lines.Add("")
$lines.Add("## Summary")
$lines.Add("- High relevance: " + $high.Count)
$lines.Add("- Automation / verification: " + $automation.Count)
$lines.Add("- Documentation / configuration: " + $docs.Count)
$lines.Add("- Runtime code candidates: " + $runtime.Count)
$lines.Add("- Blocked: " + $blocked.Count)
$lines.Add("")
$lines.Add("## Recommended Now")
foreach ($item in ($automation + $docs | Sort-Object category,path | Select-Object -First 50)) {
  $p = if ($item.path) { $item.path } else { $item.FullName }
  $lines.Add("- [" + $item.category + "] ``" + $p + "``")
}
$lines.Add("")
$lines.Add("## Avoid For This System")
foreach ($item in (($runtime + $blocked) | Sort-Object category,path | Select-Object -First 50)) {
  $p = if ($item.path) { $item.path } else { $item.FullName }
  $lines.Add("- [" + $item.category + "] ``" + $p + "``")
}
$lines.Add("")
$lines.Add("## Decision")
$lines.Add("Import only short scripts, checklists, schemas, and docs. Do not import runtime code, secrets, build output, databases, or long-running service logic.")

$lines | Set-Content -LiteralPath $out -Encoding UTF8
Write-Host "Wrote import check: $out"



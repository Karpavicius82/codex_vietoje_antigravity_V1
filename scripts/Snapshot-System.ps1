param(
  [Parameter(Mandatory=$false)]
  [string]$Root = "",

  [Parameter(Mandatory=$false)]
  [string]$OutputDir = ""
)

$ErrorActionPreference = "Stop"
if (-not $Root) { $Root = Split-Path -Parent (Split-Path -Parent $PSCommandPath) }
$Root = (Resolve-Path -LiteralPath $Root).Path
if (-not $OutputDir) { $OutputDir = Join-Path $Root "snapshots" }
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$manifest = Join-Path $OutputDir "snapshot-$stamp-manifest.json"
$summary = Join-Path $OutputDir "snapshot-$stamp.md"

$skip = "\\(\.git|node_modules|vcpkg|build|dist|out|snapshots|logs)\\"
$files = Get-ChildItem -LiteralPath $Root -Recurse -File -Force -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName.Replace('/', '\') -notmatch $skip } |
  Select-Object FullName,Length,LastWriteTime

$manifestData = [ordered]@{
  createdAt = (Get-Date).ToString("s")
  root = $Root
  fileCount = @($files).Count
  totalBytes = (@($files) | Measure-Object Length -Sum).Sum
  files = $files
}
$manifestData | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $manifest -Encoding UTF8

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# System Snapshot $stamp")
$lines.Add("")
$lines.Add("Root: ``$Root``")
$lines.Add("Files: " + @($files).Count)
$lines.Add("Manifest: ``$manifest``")
$lines.Add("")
$lines.Add("## Top Level")
Get-ChildItem -LiteralPath $Root -Force | Sort-Object Name | ForEach-Object {
  $lines.Add("- ``" + $_.Name + "``")
}
$lines | Set-Content -LiteralPath $summary -Encoding UTF8

Write-Host "Wrote snapshot manifest: $manifest"
Write-Host "Wrote snapshot summary: $summary"

param(
  [Parameter(Mandatory=$true)]
  [string]$ZipPath,

  [Parameter(Mandatory=$false)]
  [string]$OutputDir = ".\memory\knowledge-base",

  [Parameter(Mandatory=$false)]
  [int]$MaxEntries = 5000
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ZipPath)) { throw "Zip does not exist: $ZipPath" }
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

Add-Type -AssemblyName System.IO.Compression.FileSystem

$skipPattern = "(^|/)(\.git|\.cache|node_modules|vcpkg|build|dist|out|bin|obj|Release|Debug|logs|tmp|temp)(/|$)"
$skipExt = @(".bak", ".db", ".wal", ".shm", ".obj", ".exe", ".dll", ".log", ".pack", ".idx", ".rev", ".zip")
$doNotImportPattern = "api_token|oauth|secret|credential|password|token\.txt|ngrok"
$textExt = @(".md", ".txt", ".json", ".ps1", ".py", ".js", ".ts", ".cpp", ".hpp", ".h", ".proto", ".html", ".yml", ".yaml")

function Get-ZipCategory {
  param([string]$Path, [string]$Ext)
  $p = $Path.ToLowerInvariant()
  if ($p -match $doNotImportPattern) { return "do-not-import" }
  if ($p -match "readme|status|docs/|audit|checklist|summary|notes") { return "documentation" }
  if ($p -match "scripts/|\.ps1$|\.bat$") { return "automation" }
  if ($p -match "test|verify|smoke|regression") { return "verification" }
  if ($p -match "configs?/|\.json$|\.ya?ml$") { return "configuration" }
  if ($p -match "agents|workflows|skills") { return "agent-workflow" }
  if ($p -match "browser|cdp|rest_gate|panel") { return "operator-ui" }
  if ($p -match "src/|tools/|\.cpp$|\.hpp$|\.h$") { return "runtime-code" }
  return "other"
}

function Get-ZipRelevance {
  param([string]$Category, [string]$Path, [bool]$IsText)
  $p = $Path.ToLowerInvariant()
  if ($Category -eq "do-not-import") { return "blocked" }
  if (-not $IsText) { return "low" }
  if ($p -match "verify_closure|test_.*\.ps1|watchdog|readiness|status|runtime\.example|tools_schema|work_order|supervisor|health|smoke") { return "high" }
  if ($Category -in @("documentation", "automation", "verification", "configuration", "agent-workflow")) { return "high" }
  if ($Category -in @("operator-ui", "runtime-code")) { return "medium" }
  return "low"
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$jsonPath = Join-Path $OutputDir "zip-scan-$timestamp.json"
$mdPath = Join-Path $OutputDir "zip-scan-$timestamp.md"

$zip = [IO.Compression.ZipFile]::OpenRead($ZipPath)
try {
  $items = @()
  foreach ($entry in ($zip.Entries | Select-Object -First $MaxEntries)) {
    if ($entry.FullName.EndsWith("/")) { continue }
    $normalized = $entry.FullName.Replace("\", "/")
    $ext = [IO.Path]::GetExtension($normalized).ToLowerInvariant()
    if ($normalized -match $skipPattern) { continue }
    if ($skipExt -contains $ext) { continue }
    if ($entry.Length -gt 1048576) { continue }

    $isText = $textExt -contains $ext
    $category = Get-ZipCategory -Path $normalized -Ext $ext
    $relevance = Get-ZipRelevance -Category $category -Path $normalized -IsText $isText
    $items += [pscustomobject]@{
      zip = $ZipPath
      path = $normalized
      name = [IO.Path]::GetFileName($normalized)
      extension = $ext
      size = $entry.Length
      compressedSize = $entry.CompressedLength
      category = $category
      relevance = $relevance
      isText = $isText
    }
  }
} finally {
  $zip.Dispose()
}

$items | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $jsonPath -Encoding UTF8

$byCategory = $items | Group-Object category | Sort-Object Count -Descending
$high = @($items | Where-Object { $_.relevance -eq "high" })
$blocked = @($items | Where-Object { $_.relevance -eq "blocked" })

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# Zip Scan $timestamp")
$lines.Add("")
$lines.Add("Zip: ``$ZipPath``")
$lines.Add("Entries indexed: " + @($items).Count)
$lines.Add("")
$lines.Add("## Categories")
foreach ($g in $byCategory) { $lines.Add("- ``" + $g.Name + "`` - " + $g.Count) }
$lines.Add("")
$lines.Add("## High-Relevance Entries")
foreach ($item in ($high | Sort-Object category,path | Select-Object -First 120)) {
  $lines.Add("- [" + $item.category + "] ``" + $item.path + "`` (" + $item.size + " bytes)")
}
$lines.Add("")
$lines.Add("## Blocked / Do Not Import")
foreach ($item in ($blocked | Sort-Object path | Select-Object -First 80)) { $lines.Add("- ``" + $item.path + "``") }
$lines.Add("")
$lines.Add("## Rule")
$lines.Add("This scan does not extract files. Use it to decide what to manually summarize or adapt.")

$lines | Set-Content -LiteralPath $mdPath -Encoding UTF8
Write-Host "Wrote JSON: $jsonPath"
Write-Host "Wrote Markdown: $mdPath"

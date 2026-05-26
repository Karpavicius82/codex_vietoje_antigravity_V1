param(
  [Parameter(Mandatory=$false)]
  [string]$Root = ""
)

$ErrorActionPreference = "Stop"

if (-not $Root) { $Root = Split-Path -Parent (Split-Path -Parent $PSCommandPath) }
$Root = (Resolve-Path -LiteralPath $Root).Path
Write-Host "[test-system] Root: $Root"

$requiredFolders = @(
  "agents", "bin", "config", "docs", "policies", "scripts", "skills",
  "templates", "workflows", "memory", "logs", "workspace", "work-orders"
)

foreach ($folder in $requiredFolders) {
  $path = Join-Path $Root $folder
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Missing required folder: $path"
  }
  Write-Host "[ok] folder $folder"
}

$requiredFiles = @(
  "AGENTS.md",
  "README.md",
  "definition-of-done.md",
  "codex-vietoje.ps1",
  "codex-vietoje.config.json",
  "config/system.json",
  "config/safety.json",
  "config/runtime.example.json",
  "config/tools.catalog.json",
  "docs/architecture.md",
  "docs/import-candidates.md",
  "docs/roadmap.md",
  "scripts/Test-Config.ps1",
  "scripts/Test-Environment.ps1",
  "scripts/Scan-KnowledgeSources.ps1",
  "scripts/Invoke-Task.ps1",
  "scripts/New-WorkOrder.ps1",
  "scripts/Get-WorkBoard.ps1",
  "scripts/Move-WorkOrder.ps1",
  "scripts/Export-KnowledgeSummary.ps1",
  "scripts/Snapshot-System.ps1",
  "scripts/Scan-ZipArchive.ps1",
  "scripts/Test-ImportCandidates.ps1",
  "scripts/Convert-V26ToolsSchema.ps1",
  "scripts/Test-PathHygiene.ps1",
  "scripts/Export-V26DocIndex.ps1"
)

foreach ($file in $requiredFiles) {
  $path = Join-Path $Root $file
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Missing required file: $path"
  }
  Write-Host "[ok] file $file"
}

Write-Host "[test-system] Config validation"
& (Join-Path $Root "scripts/Test-Config.ps1") -ConfigPath (Join-Path $Root "codex-vietoje.config.json")

Write-Host "[test-system] CLI validate"
& (Join-Path $Root "codex-vietoje.ps1") validate

Write-Host "[test-system] CLI list"
& (Join-Path $Root "codex-vietoje.ps1") list

Write-Host "[test-system] Scanner smoke test"
$tempOut = Join-Path $env:TEMP ("codex-scan-smoke-" + [Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tempOut | Out-Null
& (Join-Path $Root "scripts/Scan-KnowledgeSources.ps1") -SourcePaths @($Root, (Join-Path $Root "missing-source-for-smoke")) -OutputDir $tempOut -MaxFilesPerSource 75
$scanFiles = Get-ChildItem -LiteralPath $tempOut -File -Filter "knowledge-scan-*" -ErrorAction SilentlyContinue
if (-not $scanFiles -or $scanFiles.Count -lt 2) {
  throw "Scanner smoke test did not produce JSON and Markdown outputs."
}
Write-Host "[ok] scanner smoke output $tempOut"

Write-Host "[test-system] Doctor"
& (Join-Path $Root "codex-vietoje.ps1") doctor

Write-Host "[test-system] PASS"






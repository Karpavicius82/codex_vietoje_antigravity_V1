param(
  [Parameter(Mandatory=$false)]
  [string]$DocsDir = "D:\SISTEMOS\7. Antigravity2025\GPTdev.ops.Antigravity\V26_test_V6\docs",

  [Parameter(Mandatory=$false)]
  [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
if (-not (Test-Path -LiteralPath $DocsDir)) { throw "Docs dir not found: $DocsDir" }
if (-not $OutputPath) {
  $root = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
  $OutputPath = Join-Path $root "docs\research\v26-doc-index.md"
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# V26 Documentation Index")
$lines.Add("")
$lines.Add("Source: ``$DocsDir``")
$lines.Add("Generated: " + (Get-Date).ToString("s"))
$lines.Add("")

foreach ($file in Get-ChildItem -LiteralPath $DocsDir -File -Filter "*.md" | Sort-Object Name) {
  $lines.Add("## " + $file.Name)
  $headings = Select-String -LiteralPath $file.FullName -Pattern '^(#{1,3})\s+(.+)$' -ErrorAction SilentlyContinue
  if (-not $headings) {
    $lines.Add("- No headings found")
    $lines.Add("")
    continue
  }
  foreach ($h in $headings) {
    $level = $h.Matches[0].Groups[1].Value.Length
    $title = $h.Matches[0].Groups[2].Value.Trim()
    $indent = if ($level -eq 1) { "-" } elseif ($level -eq 2) { "  -" } else { "    -" }
    $lines.Add("$indent $title")
  }
  $lines.Add("")
}

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputPath) | Out-Null
$lines | Set-Content -LiteralPath $OutputPath -Encoding UTF8
Write-Host "Wrote V26 doc index: $OutputPath"

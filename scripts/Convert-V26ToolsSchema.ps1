param(
  [Parameter(Mandatory=$false)]
  [string]$SchemaPath = "D:\SISTEMOS\7. Antigravity2025\GPTdev.ops.Antigravity\V26_test_V6\configs\tools_schema.json",

  [Parameter(Mandatory=$false)]
  [string]$OutputPath = "",

  [Parameter(Mandatory=$false)]
  [switch]$WhatIf
)

$ErrorActionPreference = "Stop"
if (-not (Test-Path -LiteralPath $SchemaPath)) { throw "Schema not found: $SchemaPath" }
if (-not $OutputPath) {
  $root = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
  $OutputPath = Join-Path $root "memory\knowledge-base\v26-tools-catalog.generated.json"
}

$raw = Get-Content -LiteralPath $SchemaPath -Raw | ConvertFrom-Json
$tools = @($raw.tools)
$groups = $tools | Group-Object -Property @{Expression={($_.name -split '[\._]')[0]}} | Sort-Object Name

$catalog = [ordered]@{
  source = $SchemaPath
  generatedAt = (Get-Date).ToString("s")
  toolCount = $tools.Count
  groups = @()
}

foreach ($g in $groups) {
  $catalog.groups += [pscustomobject][ordered]@{
    prefix = $g.Name
    count = $g.Count
    tools = @($g.Group | Sort-Object name | ForEach-Object {
      [ordered]@{
        name = $_.name
        description = $_.description
      }
    })
  }
}

if ($WhatIf) {
  $catalog.groups | Select-Object prefix,count | Format-Table -AutoSize
  exit 0
}

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputPath) | Out-Null
$catalog | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
Write-Host "Wrote V26 tools catalog: $OutputPath"



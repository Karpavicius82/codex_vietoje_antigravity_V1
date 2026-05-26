param(
  [Parameter(Mandatory=$true)]
  [string]$ProjectPath
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ProjectPath)) {
  throw "Project path does not exist: $ProjectPath"
}

$result = @{
  projectName = (Split-Path -Leaf $ProjectPath)
  stack = @()
  commands = @{}
  paths = @{ source = @(); tests = @(); docs = @() }
  rules = @()
}

# Detect Node.js
$pkgJson = Join-Path $ProjectPath "package.json"
if (Test-Path -LiteralPath $pkgJson) {
  $pkg = Get-Content -LiteralPath $pkgJson -Raw | ConvertFrom-Json
  $result.stack += "node"
  
  if ($pkg.scripts) {
    $scripts = $pkg.scripts
    if ($scripts.dev) { $result.commands.dev = "npm run dev" }
    if ($scripts.build) { $result.commands.build = "npm run build" }
    if ($scripts.test) { $result.commands.test = "npm test" }
    if ($scripts.lint) { $result.commands.lint = "npm run lint" }
    if ($scripts.typecheck) { $result.commands.typecheck = "npm run typecheck" }
    if ($scripts.start) { $result.commands.start = "npm start" }
  }
  
  $result.commands.install = "npm install"
  
  # Detect TypeScript
  if (Test-Path -LiteralPath (Join-Path $ProjectPath "tsconfig.json")) {
    $result.stack += "typescript"
  }
  
  # Detect frameworks from dependencies
  $allDeps = @{}
  if ($pkg.dependencies) { $pkg.dependencies.PSObject.Properties | ForEach-Object { $allDeps[$_.Name] = $_.Value } }
  if ($pkg.devDependencies) { $pkg.devDependencies.PSObject.Properties | ForEach-Object { $allDeps[$_.Name] = $_.Value } }
  
  if ($allDeps.ContainsKey("next")) { $result.stack += "nextjs" }
  if ($allDeps.ContainsKey("react")) { $result.stack += "react" }
  if ($allDeps.ContainsKey("vue")) { $result.stack += "vue" }
  if ($allDeps.ContainsKey("express")) { $result.stack += "express" }
  if ($allDeps.ContainsKey("fastify")) { $result.stack += "fastify" }
  if ($allDeps.ContainsKey("tailwindcss")) { $result.stack += "tailwind" }
  
  $result.rules += "Read package.json before choosing commands."
}

# Detect Python
$reqTxt = Join-Path $ProjectPath "requirements.txt"
$pyproject = Join-Path $ProjectPath "pyproject.toml"
$pipfile = Join-Path $ProjectPath "Pipfile"
if ((Test-Path -LiteralPath $reqTxt) -or (Test-Path -LiteralPath $pyproject) -or (Test-Path -LiteralPath $pipfile)) {
  $result.stack += "python"
  $result.commands.install = "pip install -r requirements.txt"
  if (Test-Path -LiteralPath $pyproject) {
    $result.commands.install = "pip install -e ."
  }
  $result.rules += "Check for virtual environment before installing."
}

# Detect Go
if (Test-Path -LiteralPath (Join-Path $ProjectPath "go.mod")) {
  $result.stack += "go"
  $result.commands.build = "go build ./..."
  $result.commands.test = "go test ./..."
}

# Detect Rust
if (Test-Path -LiteralPath (Join-Path $ProjectPath "Cargo.toml")) {
  $result.stack += "rust"
  $result.commands.build = "cargo build"
  $result.commands.test = "cargo test"
}

# Detect .NET
$csproj = Get-ChildItem -Path $ProjectPath -Filter "*.csproj" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($csproj) {
  $result.stack += "dotnet"
  $result.commands.build = "dotnet build"
  $result.commands.test = "dotnet test"
}

# Detect common paths
$sourceDirs = @("src", "lib", "app", "source", "cmd", "internal", "pkg")
foreach ($dir in $sourceDirs) {
  if (Test-Path -LiteralPath (Join-Path $ProjectPath $dir)) {
    $result.paths.source += $dir
  }
}

$testDirs = @("tests", "test", "__tests__", "spec", "specs")
foreach ($dir in $testDirs) {
  if (Test-Path -LiteralPath (Join-Path $ProjectPath $dir)) {
    $result.paths.tests += $dir
  }
}

if (Test-Path -LiteralPath (Join-Path $ProjectPath "README.md")) {
  $result.paths.docs += "README.md"
}
if (Test-Path -LiteralPath (Join-Path $ProjectPath "docs")) {
  $result.paths.docs += "docs"
}

# Common rules
$result.rules += "Prefer existing components and utilities."
$result.rules += "Do not touch generated files unless the task requires it."

# Output
$json = $result | ConvertTo-Json -Depth 5
Write-Host "Detected project stack: $($result.stack -join ', ')"
Write-Host ""
Write-Output $json

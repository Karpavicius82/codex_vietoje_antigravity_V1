param(
  [Parameter(Mandatory=$true)]
  [string]$Path,

  [Parameter(Mandatory=$false)]
  [ValidateSet("read", "write", "list", "import")]
  [string]$Operation = "read"
)

$ErrorActionPreference = "Stop"

$normalized = $Path.Replace('/', '\')
$denyDirs = "\\(\.git|node_modules|vcpkg|build|dist|out|bin|obj|Release|Debug|logs|tmp|temp|\.cache|\.venv|venv|__pycache__)\\"
$denyExt = @(".bak", ".db", ".wal", ".shm", ".obj", ".exe", ".dll", ".log", ".pack", ".idx", ".rev")
$denyName = "api_token|oauth|secret|credential|password|token\.txt|private|ngrok"
$ext = [IO.Path]::GetExtension($normalized).ToLowerInvariant()

$result = [ordered]@{
  path = $Path
  operation = $Operation
  decision = "PASS"
  reasons = @()
}

if ($normalized -match $denyDirs) {
  $result.decision = "BLOCK"
  $result.reasons += "Path contains denied generated/runtime directory."
}
if ($denyExt -contains $ext) {
  $result.decision = "BLOCK"
  $result.reasons += "Path extension is denied for import: $ext"
}
if ($normalized.ToLowerInvariant() -match $denyName) {
  $result.decision = "BLOCK"
  $result.reasons += "Path name looks like secret/token/runtime credential material."
}
if ($Operation -in @("write", "import") -and $normalized -match "\\(configs?|conf)\\.*(token|oauth|secret|credential)") {
  $result.decision = "BLOCK"
  $result.reasons += "Write/import into credential-like config path is blocked."
}
if ($result.reasons.Count -eq 0) { $result.reasons += "No hygiene rule blocked this path." }

$result | ConvertTo-Json -Depth 4
if ($result.decision -eq "BLOCK") { exit 2 }

param(
  [Parameter(Mandatory=$true)]
  [string]$Task,

  [string]$Language = "auto"
)

$ErrorActionPreference = "Stop"

# Raktiniai žodžiai pagal workflow
$patterns = @{
  "bugfix"         = @("fix", "bug", "broken", "crash", "error", "fail", "issue", "wrong", "doesnt work",
                        "taisyk", "klaida", "neveikia", "suluzo", "blogai", "sugedo", "suluzus")
  "hotfix"         = @("urgent", "critical", "production", "hotfix", "asap", "down",
                        "skubu", "kritinis", "produkcija", "nukrito")
  "feature"        = @("add", "create", "implement", "new", "build", "make", "introduce",
                        "pridek", "sukurk", "igyvendink", "naujas", "padaryk", "prideti")
  "refactor"       = @("refactor", "clean", "simplify", "reorganize", "extract", "rename", "restructure",
                        "sutvarky", "supaprastink", "iskelk", "pervadink", "pertvarky")
  "review"         = @("review", "check", "audit", "inspect", "look at", "evaluate",
                        "perziurek", "patikrink", "ivertink")
  "debug"          = @("debug", "trace", "investigate", "find why", "root cause", "diagnose",
                        "derink", "issiaiskim", "surask kodel", "diagnozuok")
  "frontend-qa"    = @("ui", "css", "layout", "design", "style", "responsive", "visual", "pixel",
                        "dizainas", "stilius", "isvaizda")
  "release-prep"   = @("release", "deploy", "version", "publish", "ship", "tag",
                        "isleisk", "versija", "paskelbk")
  "migrate"        = @("migrate", "upgrade", "update version", "move to", "switch to",
                        "migruok", "atnaujink", "perkelk")
  "security-audit" = @("security", "vulnerability", "cve", "xss", "injection", "auth",
                        "saugumas", "pazeidziamumas")
}

$taskLower = $Task.ToLower()
$scores = @{}

foreach ($workflow in $patterns.Keys) {
  $score = 0
  foreach ($keyword in $patterns[$workflow]) {
    if ($taskLower -match [regex]::Escape($keyword)) {
      $score++
    }
  }
  if ($score -gt 0) {
    $scores[$workflow] = $score
  }
}

if ($scores.Count -eq 0) {
  Write-Host "Nepavyko automatiskai nustatyti workflow pagal uzduoti."
  Write-Host "Uzduotis: $Task"
  Write-Host ""
  Write-Host "Galimi workflow:"
  Write-Host "  feature        - Nauja funkcija"
  Write-Host "  bugfix         - Klaidos taisymas"
  Write-Host "  hotfix         - Skubus taisymas"
  Write-Host "  refactor       - Kodo pertvarkymas"
  Write-Host "  review         - Kodo perziura"
  Write-Host "  debug          - Derinimas"
  Write-Host "  frontend-qa    - UI kokybe"
  Write-Host "  release-prep   - Isleidimo paruosimas"
  Write-Host "  migrate        - Migracija"
  Write-Host "  security-audit - Saugumo auditas"
  Write-Host ""
  Write-Output "feature"  # Default
  exit 0
}

$best = $scores.GetEnumerator() | Sort-Object -Property Value -Descending | Select-Object -First 1

Write-Host "Workflow auto-detection:"
Write-Host "  Uzduotis: $Task"
Write-Host "  Pasirinktas: $($best.Key) (score: $($best.Value))"

if ($scores.Count -gt 1) {
  Write-Host "  Kiti kandidatai:"
  $scores.GetEnumerator() | Sort-Object -Property Value -Descending | Select-Object -Skip 1 | ForEach-Object {
    Write-Host "    $($_.Key) (score: $($_.Value))"
  }
}

Write-Output $best.Key

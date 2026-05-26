# Codex vietoje Antigravity

Windows-first lokali Codex darbo sistema. Ji skirta ne pakeisti IDE ar sukurti pilna Antigravity klona, o standartizuoti praktini darba su Codex: roles, workflow'ai, skills, policies, scanneris, memory ir patikrinimai.

## Statusas

v0.1 baseline yra uzdaromas kaip stabilus lokalus karkasas.

Palaikoma v0.1:

- Windows + PowerShell naudojimas.
- Agentu roles ir workflow'ai.
- Skills, templates, safety ir verification policies.
- Projekto config pavyzdys.
- Knowledge scanner isoriniams saltiniams.
- Runtime example ir tools catalog dokumentacija.
- Viena sistemine patikra per `scripts/Test-System.ps1`.

Samingai neieina i v0.1:

- autonominis C++/HTTP/MCP runtime;
- web UI;
- automatinis deploy;
- browser extension integracija;
- semantine vector memory;
- automatine keliu Codex procesu orkestracija.

## Greitas startas

```powershell
cd "D:\SISTEMOS\8. Codex\001 Codex vietoje Antigravity"
.\codex-vietoje.ps1 validate
.\codex-vietoje.ps1 doctor
.\codex-vietoje.ps1 list
.\scripts\Test-System.ps1
```

Sugeneruoti starter prompta:

```powershell
.\codex-vietoje.ps1 run starter
```

Paruosti uzduoties prompta projektui:

```powershell
.\bin\codex-task.ps1 -Task "Sutvarkyk login klaida" -ProjectPath "C:\kelias\iki\projekto" -Workflow bugfix
```

## Struktura

```text
agents/                 Agentu roles
bin/                    Papildomi launcheriai
config/                 Sistemos, safety, runtime ir tools catalog configai
docs/                   Architecture, roadmap, import candidates
memory/knowledge-base/  Scannerio indeksai ir santraukos
policies/               Safety ir verification taisykles
scripts/                Testai, scanneris, stack/workflow/session helperiai
skills/                 Specializuotos proceduros
templates/              PR, changelog, session, incident sablonai
work-orders/            Failines darbo eiles skeletas
workflows/              Feature, bugfix, review ir kiti workflow'ai
workspace/              Lokali darbo erdve
```


## Praktines komandos

```powershell
.\codex-vietoje.ps1 board     # darbo lenta
.\codex-vietoje.ps1 summary   # sugeneruoja knowledge scan santrauka
.\codex-vietoje.ps1 snapshot  # sugeneruoja sistemos snapshot manifest
.\codex-vietoje.ps1 test      # pilnas sistemos testas
```

Work-order pavyzdys:

```powershell
.\scripts\New-WorkOrder.ps1 -Title "Patikrinti V26 docs" -Goal "Atrinkti importo kandidatus" -Workflow review -AssignedRole reviewer
.\codex-vietoje.ps1 board
.\scripts\Move-WorkOrder.ps1 -Id "wo-..." -To done -Note "Baigta"
```
## Knowledge scanner

Scanneris indeksuoja pasirinktus saltinius ir ignoruoja triuksma: `.git`, `node_modules`, `vcpkg`, `build`, `logs`, `.db`, `.bak`, `.obj` ir pan.

```powershell
.\scripts\Scan-KnowledgeSources.ps1 `
  -SourcePaths @(
    "D:\SISTEMOS\8. Codex\001 Codex vietoje Antigravity",
    "D:\SISTEMOS\7. Antigravity2025\nDxnD-engine-archive",
    "D:\SISTEMOS\7. Antigravity2025\GPTdev.ops.Antigravity\V26_test_V6"
  ) `
  -OutputDir ".\memory\knowledge-base" `
  -MaxFilesPerSource 3000
```

## Uzdarymo dokumentai

- `docs/architecture.md` - kas sistema yra ir ko nedaro.
- `docs/import-candidates.md` - ka verta skolintis is V26/nDxnD ir ko neliesti.
- `docs/roadmap.md` - v0.1, v0.2, v0.3 ir v1.0 kryptys.

## Definition of Done

Darbas baigtas tik kai:

- pakeitimai susije su uzduotimi;
- nepaliestas nesusijes naudotojo darbas;
- paleisti tinkami testai arba aiskiai nurodyta, kodel jie nepaleisti;
- galutiniame atsakyme pateikta, kas keista ir kaip tikrinta.

## v0.1 closure taisykle

v0.1 laikoma uzdaryta, kai `README.md`, `docs/architecture.md`, `docs/import-candidates.md`, `docs/roadmap.md`, `config/runtime.example.json`, `config/tools.catalog.json` ir `scripts/Test-System.ps1` sutaria del palaikomo sistemos pavirsiaus. Naujos ambicingos funkcijos po to keliauja i roadmap, ne i v0.1.


# Import Candidates

Sis dokumentas apibrezia, ka verta skolintis is senu Antigravity/V26/nDxnD saltiniu ir ko neliesti. Tikslas - ne kopijuoti archyvus, o paimti naudojamas idejas.

## Kopijuoti arba adaptuoti dabar

| Saltinis | Elementas | Veiksmas | Priezastis |
|---|---|---|---|
| V26 | `configs/runtime.example.json` | adaptuoti i `config/runtime.example.json` | Aiskus runtime ribu aprasymas. |
| V26 | `configs/tools_schema.json` | istraukti kategorijas i `config/tools.catalog.json` | Naudinga tools zemelapiui, bet ne visa 117 tools schema. |
| V26 | `docs/ARCHITECTURE.md`, `docs/API.md`, `docs/AGX_BUS*.md` | santrauka i `docs/research/` | Architekturos idejos be C++ runtime kopijavimo. |
| V26 | `docs/V26_PRODUCTION_READINESS_AUDIT.md` | santrauka i research | Gera checklist disciplina. |
| V26 | `test_harvest.ps1`, `scripts/deploy.ps1` | idejas perkelti i `scripts/Test-System.ps1`, ne kopijuoti tiesiogiai | Esami skriptai hardcodinti V26 runtime. |
| nDxnD | `docs/nd_engine_inventory.md` | laikyti kaip research saltini | Sutvarkyta versiju evoliucija. |
| nDxnD | `docs/ndxnd_codex_audit.md` | laikyti kaip research saltini | Naudingos GA/control idejos. |

## Adaptuoti veliau

| Saltinis | Elementas | Kada |
|---|---|---|
| V26 | team/work-order tools | v0.2, kai bus failine darbo eile. |
| V26 | supervisor/session reducer idejos | v0.3, kai bus realus Codex CLI integravimas. |
| V26 | browser bridge tyrimai | tik po stabilaus browser QA poreikio. |
| nDxnD | adaptive mutation / diversity penalty | kai bus vertinamas workflow/subagentu efektyvumas. |
| nDxnD | father/son hierarchy | kai bus realus subagentu routing modelis. |

## Tik tyrimui

- Antigravity extension reverse-engineering.
- gRPC-Web credential bootstrap detalės.
- Living Silicon / HNN / fractal engine kodas.
- C++ Office bridge implementacijos detalės.

## Neliesti / nekopijuoti

- `.git`, `node_modules`, `vcpkg`, `build`, `dist`, `out`.
- `.db`, `.wal`, `.shm`, `.obj`, `.exe`, `.dll`, `.log`, `.bak`.
- `api_token.txt`, OAuth klientai, credentials, secrets.
- V26 hardcodinti deploy skriptai be perrasymo.
- Sugeneruoti runtime backup failai.

## Importo principas

Kiekvienas importas turi atsakyti i klausima: ar tai padeda Codex sistemai geriau planuoti, tikrinti, indeksuoti arba saugiau dirbti? Jei ne - palikti research archyve.

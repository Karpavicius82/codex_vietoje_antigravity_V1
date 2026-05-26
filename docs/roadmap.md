# Roadmap

## v0.1 - baseline closure

Statusas: uzdaroma.

Tikslas: stabilus vietinis Codex darbo karkasas.

Ieinantys elementai:

- agentu roles;
- workflow'ai;
- skills;
- safety ir verification policies;
- runtime example config;
- tools catalog;
- knowledge scanner;
- system test;
- import candidates dokumentas;
- memory/logs/workspace/work-orders katalogu struktura.

Neieina:

- web UI;
- autonominis runtime;
- reali multi-Codex orkestracija;
- deploy pipeline;
- browser extension integracija.

## v0.2 - work-orders

Tikslas: paprasta failine darbo lenta subagentams.

Galimi darbai:

- `New-WorkOrder.ps1`;
- `Get-WorkBoard.ps1`;
- `Complete-WorkOrder.ps1`;
- JSON schema work order objektui;
- `work-orders/pending`, `active`, `done`, `artifacts` workflow.

## v0.3 - Codex CLI integration

Tikslas: launcher'is gali realiai paleisti Codex CLI/API arba paruosti komandinius promptus.

Galimi darbai:

- `codex-vietoje.ps1 run task` su project path;
- prompt/session logging;
- `Save-Session.ps1` integracija;
- workflow auto-selection;
- test command discovery.

## v0.4 - browser and visual QA

Tikslas: frontend workflow patikrinimas per browser.

Galimi darbai:

- dev server detection;
- localhost open/test instructions;
- screenshot notes;
- browser QA checklist.

## v1.0 - orchestrator UI arba runtime

Tikslas: jei v0.x praktiskai pasiteisins, tada verta svarstyti UI arba runtime.

Galimi darbai:

- web dashboard;
- persistent task board;
- subagent pool;
- tools schema execution layer;
- semantic memory.

## Sprendimo taisykle

Jei funkcija nepadeda siandien naudoti Codex tvarkingiau, ji nekeliama i v0.1. Ji eina i roadmap.

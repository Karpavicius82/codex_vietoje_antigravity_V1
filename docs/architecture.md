# Architecture

`Codex vietoje Antigravity` v0.1 yra Windows-first lokali Codex darbo sistema. Ji nera pilnas Antigravity klonas ir neturi savo autonominio runtime. Jos paskirtis - standartizuoti, kaip Codex dirba su projektais, archyvais, agentu rolemis, workflow'ais ir saugumo taisyklemis.

## Sluoksniai

```text
User / Codex session
  -> codex-vietoje.ps1 / bin/codex-task.ps1
  -> config + policies
  -> agents + workflows + skills
  -> scripts
  -> memory / logs / workspace / work-orders
  -> external sources: V26, nDxnD archive, project repositories
```

## Pagrindines dalys

- `codex-vietoje.ps1` - pagrindinis launcher'is: `init`, `doctor`, `validate`, `list`, `run`, `clean`.
- `bin/codex-task.ps1` - uzduoties prompt generatorius pagal workflow ir projekto config.
- `agents/` - roles: orchestrator, architect, implementer, reviewer, tester, debugger, devops, documenter.
- `workflows/` - pakartojami darbo scenarijai: feature, bugfix, review, debug, hotfix, migrate, frontend QA, release prep, security audit.
- `skills/` - specializuotos proceduros: project bootstrap, API changes, frontend QA, git workflow, dependency audit, performance check.
- `policies/` - safety ir verification kontraktai.
- `scripts/` - praktiniai pagalbiniai irankiai: stack detection, workflow selection, session save, knowledge scanner, system tests.
- `memory/knowledge-base/` - sugeneruoti indeksai, scan rezultatai ir kuruotos santraukos.
- `work-orders/` - paprastas failinis darbo eiles modelis ateities subagentu koordinacijai.

## Kas samoningai neieina i v0.1

- Nera autonominio C++/HTTP/MCP runtime.
- Nera web UI.
- Nera automatinio deploy.
- Nera browser extension integracijos.
- Nera semantines vector memory.
- Nera automatines keliu Codex procesu orkestracijos.

## Closure taisykle

v0.1 laikoma uzdaryta, kai sistema gali:

1. paaiskinti save per README ir docs;
2. pasitikrinti per `validate`, `doctor`, `Test-System.ps1`;
3. indeksuoti ziniu saltinius per `Scan-KnowledgeSources.ps1`;
4. tureti aisku importo plana is V26/nDxnD;
5. islaikyti saugumo ir verification kontrakta.

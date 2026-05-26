# V26 Documentation Index

Source: `D:\SISTEMOS\7. Antigravity2025\GPTdev.ops.Antigravity\V26_test_V6\docs`
Generated: 2026-05-26T23:43:14

## AGX_BUS.md
- AGX Bus Architecture — Antigravity V26
  - 1. Overview
  - 2. Pranešimo Struktūra (V26)
    - ✅ Teisingas formatas (V26)
    - ❌ Neteisingas formatas (V25 — nebeveikia)
  - 3. Palaikomi Verb Žodžiai
  - 4. Registruoti Kanalai
  - 5. PowerShell Pavyzdžiai
    - Subscribe
    - Unsubscribe
  - 6. Atsakymų Struktūra
    - Sėkmingas subscribe
  - 7. Dažniausios Klaidos

## AGX_BUS_ARCHITECTURE.md
- AGX Bus Architecture
  - Northbound
  - Core envelope
  - Channels
  - Runtime responsibilities
  - HTTP surface
  - MCP resources
  - Next production steps

## API.md
- API
  - POST /api/sessions
  - POST /api/sessions/{session_id}/messages
  - GET /api/sessions/{session_id}/updates?after_seq=0&limit=100
  - GET /api/runs/{run_id}
  - POST /api/runs/{run_id}/cancel
  - GET /mcp
  - MCP standartiniai metodai
  - MCP tool'ai
  - Legacy MCP metodai
  - Auth
  - Browser current-tab relay
  - GET /mcp/sse?session_id={session_id}

## ARCHITECTURE.md
- Architecture
  - Sluoksniai
  - Recovery
  - Workspaces

## HYGIENE_LAYER.md
- Hygiene Layer — Antigravity V26
  - 1. Ką daro Hygiene Layer
  - 2. Taisyklių Lentelė
    - Skaitymas (`files.read`)
    - Rašymas (`files.write`)
    - Listinimas (`files.list`)
  - 3. Implementacija
  - 4. Testai
- Paleisti higienos testus
- Tikėtina išvestis:
- REZULTATAI: 16 PASSED, 0 FAILED
- VISI HIGIENOS TESTAI PRAEJO - sistema saugi!
    - Testo grupės
  - 5. Auto-Update Sistema
    - cleanup_before_launch.ps1
    - watchdog_auto_build.ps1
    - start_v26_auto.ps1
  - 6. Klaidos Pranešimai

## INTEGRATION_BOOTSTRAP.md
- Integration bootstrap
  - Rekomenduojamas tool paskirstymas
  - Pastaba

## PIN_AUTH_ARCHITECTURE.md
- PIN Authentication Architecture — Antigravity V26
  - 1. Apžvalga
  - 2. Architektūra
  - 3. PIN Manager Komponentai
    - Failų struktūra
    - pin_config.json formatas
  - 4. REST API
    - POST `/api/auth/pin/set`
    - POST `/api/auth/pin/verify`
    - GET `/api/auth/pin/status?session_id=sess_xxx`
    - POST `/api/auth/pin/reset`
  - 5. Jautrios Operacijos
  - 6. Saugumo Parametrai
  - 7. Testai
- Paleisti su auth tokenu
- Paleisti be auth (ANTIGRAVITY_DISABLE_AUTH=1)
  - 8. Dažniausios Klaidos

## REST_GATE_DEPLOYMENT.md
- V26 REST Gate Deployment
  - Būsena
  - Priešdiegiminis validavimas
    - 1. Tikrina, ar egzistuoja būtini failai
    - 2. Tikrina HTTP sveikatą
    - 3. Validuoja rest-gate laukus `/api/runs` atsakyme
    - 4. Pasirinktinai paleidžia smoke testą
  - Paleidimas prieš diegimą
  - Rekomenduojama lokali eiga
  - Kada laikyti, kad paketas paruoštas diegimui
  - Operacinė pastaba

## SUPERVISOR_PLANE_BRINGUP.md
- Supervisor plane bring-up
  - Tikslas
  - Paleidimas
  - Laukiamas rezultatas
  - Kodėl tai svarbu

## SUPERVISOR_PLANE_BRINGUP_V26.md
- Supervisor plane bring-up (V26)
  - Tikslas
  - Paleidimas
  - Laukiamas rezultatas
  - Pastaba apie versijas

## V26_CONTINUATION_CHECKPOINT_2026-03-23.md
- V26 continuation checkpoint — 2026-03-23
  - Purpose
  - Current objective
  - What has already been done
    - Completed commits
  - What is already known and should NOT be rediscovered
    - Runtime version facts
    - Old version mismatches found
    - Contract-sensitive fields intentionally NOT changed yet
  - Confirmed backend architecture direction
  - Mandatory rest-gate rule to implement
  - Exact code touchpoints already identified
  - Next tasks in the correct order
    - Immediate next patch sequence
    - Minimal first hard gate
  - Resume protocol for the next session or next model
  - Working style that must continue
  - If the session crashes again
  - Bottom line

## V26_FRONTEND_REST_GATE_UI_INTEGRATION_2026-03-23.md
- V26 Frontend / UI rest-gate integration contract — 2026-03-23
  - Branch
  - Purpose
  - Backend endpoints to bind from UI
    - 1. Session-level supervisor state
    - 2. Run list summary
    - 3. Optional health indicator
  - Minimum UI behavior required
    - A. Rest countdown banner
    - B. Disable new commands during forced rest
    - C. Re-enable automatically
    - D. Run-level visualization
  - Suggested polling model
    - Session detail view
    - Dashboard / monitor view
  - Countdown calculation
  - UI states to implement
    - Normal
    - Resting
    - Locked
    - Approval waiting
  - Production safety notes
  - Merge / local environment note
  - Cluster note
  - Bottom line

## V26_MULTI_SESSION_SUPERVISOR_CLUSTER_PLAN_2026-03-23.md
- V26 multi-session supervisor, cluster and mandatory rest-gate plan — 2026-03-23
  - Why this document exists
  - What the current runtime already has
  - The real backend problem to solve
  - Required V26 additions
    - 1. Session execution budget
    - 2. Mandatory rest-gate logic
    - 3. Scheduler integration point
    - 4. New queue actions
    - 5. Session supervisor state endpoint
  - 100-session execution model
  - Cluster direction
    - Phase A — single-node, cluster-ready semantics
    - Phase B — shared coordination layer
    - Phase C — cluster governor
  - Why version normalization still matters here
  - Recommended implementation order
  - First concrete backend patch set to build next
  - Bottom line

## V26_PRODUCTION_READINESS_AUDIT.md
- V26 Production Readiness Audit
  - 1. Kryžminio tikrinimo šaltiniai
  - 2. Kas `V26` realiai patvirtinta kode
    - 2.1. Versija ir build identitetas
    - 2.2. HTTP API egzistuoja realiai
    - 2.3. MCP tool paviršius realus, ne vien aprašytas
    - 2.4. Rest-gate laukai realiai iškelti į `/api/runs`
    - 2.5. Supervisor state realiai palaiko rest-gate ir budget patch'us
    - 2.6. Rest-gate operacinis paketas realiai egzistuoja
  - 3. Kas dokumentacijoje sutampa su realia situacija
    - 3.1. README pagrindinis branduolio aprašas daugiausia teisingas
    - 3.2. Rest-gate deployment dokumentai daugiausia atitinka realybę
    - 3.3. Office Word dalis aprašyta pakankamai sąžiningai
  - 4. Kur dokumentacija NESUTAMPA su realia situacija
    - 4.1. `STATUS.md` yra pasenęs ir klaidinantis
    - 4.2. README nepakankamai iškelia supervisor/batch funkcionalumą
    - 4.3. README Office Excel dalis yra pasenusi
    - 4.4. `excel.write_with_backup` dokumentacija dalinai pasenusi
    - 4.5. README struktūra yra nevienalytė
  - 5. Produkcinės rizikos, kurios matosi ne vien iš README, o iš kodo ir skriptų
    - 5.1. Preflight nepatikrina panelės runtime priklausomybės
    - 5.2. Smoke testas neperduoda bearer token į MCP kvietimus
    - 5.3. Repo mastu vis dar yra neužbaigtų produkcinių sričių
  - 6. Produkcinis vertinimas
    - 6.1. Kas yra tiesa šiandien
    - 6.2. Ko negalima teigti
  - 7. Ką būtina pataisyti, jei tikslas – švari produkcinė dokumentacija
    - Pirmo prioriteto pataisos
    - Antro prioriteto pataisos
  - 8. Galutinė išvada

## V26_README_CORRECTIONS.md
- V26 README Corrections
  - 1. MCP ir supervisor funkcionalumas, kurį reikia laikyti veikiančiu
  - 2. HTTP endpointai, kuriuos reikia laikyti kanoniniais
  - 3. `/api/runs` rest-gate santraukos laukai
  - 4. Office Excel statuso korekcija
    - Veikia realiai
    - Dar nėra pilnai production-complete
  - 5. Office Word statuso korekcija
    - Veikia realiai
    - Dar TODO / adapter point
  - 6. Rest-gate deployment korekcija
    - Kas jau yra deployment-ready šiame pjūvyje
    - Ko tai dar savaime neįrodo
  - 7. Produkcinės pastabos, kurias reikia laikyti teisingomis
    - 7.1. Panelės launcher'iui reikia Python
    - 7.2. Preflight to dar netikrina iki galo
    - 7.3. Smoke test auth ribojimas
  - 8. Teisinga viena eilutė apie `V26`
  - 9. Rekomenduojamas dokumentacijos naudojimas dabar

## V26_REST_GATE_PRODUCTION_CHECKLIST_2026-03-23.md
- V26 Rest-Gate Production Checklist (2026-03-23)
  - Scope
  - Backend signals that must exist
  - UI binding contract
  - Operator fallback UI
  - Local run sequence
  - Merge path
  - Deferred work

## V26_SESSION_SUPERVISOR_CODE_TOUCHPOINTS_2026-03-23.md
- V26 session supervisor code touchpoints — 2026-03-23
  - Goal
  - Current baseline
    - Session model is currently too thin
    - Reducer currently owns session/run projections
    - Queue selection is the correct enforcement point
    - Run-level control exists already
    - WorkerHost should stay mostly unchanged
  - Exact files to modify in the first backend patch
    - 1. `src/model/types.hpp`
    - 2. `src/domain/reducer.cpp`
    - 3. `src/domain/reducer.hpp`
    - 4. `src/control/state_encoder.*`
    - 5. `src/control/step_queue.cpp`
    - 6. `src/execution/worker_host.cpp`
    - 7. `src/control/run_registry.cpp`
    - 8. `src/transport/mcp_router.cpp`
    - 9. `src/transport/http_server.cpp`
    - 10. `src/application/service.*`
  - Files that should NOT own the first implementation
    - `src/control/control_kernel.cpp`
    - executor implementations
  - Safest first code order
  - Practical note
  - Bottom line

## V26_SESSION_SUPERVISOR_PATCHSET_SPEC_2026-03-23.md
- V26 session supervisor patchset specification — 2026-03-23
  - Purpose
  - Patchset boundaries
  - New data model
    - SessionSupervisorState
    - Allowed enums
  - Event journal additions
    - Session governance lifecycle
    - Rest-gate lifecycle
    - Queue gating
  - Canonical payloads
    - session_rest_required
    - session_rest_started
    - session_rest_completed
    - run_deferred_by_rest_gate
  - Reducer behavior rules
    - Rule 1 — initialize session supervisor state
    - Rule 2 — track active streak
    - Rule 3 — trigger rest requirement
    - Rule 4 — finish rest
    - Rule 5 — operator lock
  - StateEncoder additions
  - StepQueue hard-gate logic
    - Hard gate predicates
    - Result mapping
  - Supervisor endpoints
    - New MCP tool
    - Optional follow-up write tools
  - HTTP aliases
  - Restart and recovery behavior
  - Minimal test matrix
    - Test 1 — initialization
    - Test 2 — threshold trigger
    - Test 3 — rest completion
    - Test 4 — mixed sessions
    - Test 5 — restart recovery
  - Safe implementation order
  - Bottom line

## V26_SESSION_SUPERVISOR_REDUCER_EVENT_MAPPING_2026-03-23.md
- V26 session supervisor reducer event mapping — 2026-03-23
  - Purpose
  - Why this mapping is needed
  - New SessionState fields assumed by this mapping
  - Default state at session creation
  - Event-to-state mapping
    - 1. `session_supervisor_initialized`
    - 2. `session_priority_changed`
    - 3. `session_operator_lock_changed`
    - 4. `session_budget_state_changed`
    - 5. `session_rest_required`
    - 6. `session_rest_started`
    - 7. `session_rest_completed`
    - 8. `session_rest_gate_cleared`
    - 9. `run_deferred_by_rest_gate`
    - 10. `run_deferred_by_session_budget`
    - 11. `run_deferred_by_operator_lock`
    - 12. `run_deferred_by_cluster_governor`
  - Derived state rules tied to run/job events
    - Rule A — session becomes active
    - Rule B — session active streak continues
    - Rule C — session becomes idle
  - Runnable filtering rules
    - Current filter keeps a run if all are true
    - New session hard filter
  - StepQueue interaction rule
  - Pseudo-code for reducer additions
  - First implementation target
  - Bottom line

## V26_STABILITY_CHECKPOINT_2026-03-23.md
- V26 Production Stability Checkpoint — 2026-03-23
  - Branch
  - Goal
  - Kas šiuo metu stabilizuota
    - 1. Session supervisor modelis
    - 2. Read-only supervisor surfacing
    - 3. Reducer + queue gate
    - 4. Supervisor write path
    - 5. Batch backend primityvai (backend only)
    - 6. CMD operator monitorius
  - Kas sąmoningai laikinai atitraukta dėl stabilumo
    - Batch MCP surfacing
  - Dabartinė rekomenduojama kryptis
    - Pirma
    - Tada
  - Ką daryti toliau po compile-safe bazės
    - Prioritetas A — stabilumas
    - Prioritetas B — controlled batch return
  - Svarbiausias principas

## V26_STATUS.md
- Antigravity Core V26 — Architecture & Status
  - 1. Sistemos Architektūra
  - 2. Testų Rezultatai (2026-03-25)
  - 3. Saugumo Architektūra
    - Autentifikacijos sluoksniai
    - PIN Auth parametrai
  - 4. Ngrok Viešas Tunelis
  - 5. Office Bridge V3 Būsena
  - 6. Deployment
    - Produkcijai (su auth + ngrok)
    - Testavimui (be auth)
    - Logai
  - 7. Žinomos Ribotumo Sritys

## V26_VERSION_NORMALIZATION_AUDIT_2026-03-23.md
- V26 version normalization audit — 2026-03-23
  - Goal
  - Safety rules used for this pass
  - Cross-check findings before edits
    - Canonical V26 runtime markers already present
    - Stale or inconsistent references found
  - Planned incremental commits
  - Notes

## V26_VERSION_NORMALIZATION_STAGE_2_2026-03-23.md
- V26 normalization stage 2 — 2026-03-23
  - New commit in this stage
  - What was changed
    - Safe changes included
  - Why this was done as a new file
  - Current recommended V26 files
  - Remaining work candidates


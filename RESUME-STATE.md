# State — Conv 385 (2026-07-11 ~11:59)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Built PLATO-SEQ Phase 4 in two committed+pushed increments. **4a** — the dependency-graph + registry + provenance foundation: assembles the latent `restoreFrom`/`snapshot`/`capturesTo` edges into a validated, topo-sorted waypoint DAG with a transitive-closure source hash per waypoint, plus two freshness clocks (committed `manifest.generated.json` = Clock 1; gitignored per-machine provenance sidecars = Clock 2). **4b** — `npm run plato:run`, a make-for-waypoints runner that regenerates only STALE/MISSING waypoints in topological order (`--chain`/`--from-waypoint`/`--force`/`--dry-run`). PLATO-SEQ's active work is complete; only the optional, post-launch-gated Phase 4c (agent browser walker) remains.

## Key Context

- **Task backlog is in `CURRENT-TASKS.md`** — do not re-list here. PLATO-SEQ is essentially done (its Ordered entry notes only post-launch 4c remains). New this conv: a `[UXQ]` backlog note (AskUserQuestion clarify tears down the picker — harness UX friction the user flagged; low priority, watch/report-upstream).
- **The new PLATO waypoint system (all committed on `jfg-dev-14`):** `npm run plato:graph -- status|check|generate|stamp` (graph / registry / freshness) + `npm run plato:run` (make-for-waypoints regeneration). Design: `docs/as-designed/plato.md` § "The waypoint graph, registry & provenance". Committed static graph = `tests/plato/snapshots/manifest.generated.json`; per-machine run-state = gitignored `*.prov.json` sidecars.
- **Key semantic:** the API producers **full-replay** from the core seed (in-memory, sub-second) — they don't restore a parent snapshot — so `--from-waypoint` means "regenerate downstream", NOT "restore + continue" (that's the deferred browser-side Phase 4c agent walker).
- **Staleness = transitive-closure source hash:** editing a shared step (e.g. `enroll-student`) marks downstream waypoints STALE (`flywheel-pre-12`/`session-invite`) but not ones whose chain never runs it (`flywheel-pre-9`). Proven by unit test.
- **Provenance is a gitignored JSON sidecar, deliberately NOT an in-DB table** — keeps the `.sqlite` byte-clean for the manual row-identity diff (avoids a `notifications`-style footgun). Decision detail routed to `docs/decisions/06-testing-ci.md`.
- **Baseline (this conv):** all 5 gates green — tsc 0 / astro-check 0 / lint / test **6834** / build ✓ — verified in-conv after Phase 4b.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

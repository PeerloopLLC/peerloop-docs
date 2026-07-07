# State — Conv 369 (2026-07-06 ~20:34)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

A backlog-clearing conv: closed **four** low-priority items — **[BRAND-CASE]** (`PeerLoop`→`Peerloop` casing sweep across 20 UI-copy sites + a hand-edited Matt-sourced logo wordmark SVG, all gates green, kerning Chrome-verified), **[E2E-DOCS]** (reconciled TEST-COVERAGE.md + TEST-E2E.md to the disk truth of 28 files/125 tests), **[DOCGEN-SPEC]** (added §9 generated-docs regen contract to doc-sync-strategy.md), and **[ICN-NS]** as an **audit only** (new `docs/as-designed/icon-system.md` — the rename execution is deferred). Plus task hygiene: deleted [V217-WATCH], parked [MINWIDTH-320]. Four commits: code `39f4def6` + docs `4e68617`/`0d8cef5`/`ccf43d6`, all pushed at this r-end.

## Key Context

- **Backlog:** see `CURRENT-TASKS.md`. No `🔥 Ordered` sequence. Active backlog: **[ICN-NS]** (audit done → execution deferred, now `[Opus]`-tagged), TZ-AUDIT `[Opus]`, HOME/COURSES-FIXES, PLAN-XTRACT, and new **[BRAND-DOCS]** (docs-wide brand-casing sweep, low priority). Parked: RG-PUBLIC, PREFLIP-WT, BROWSER-SMOKE-2B, MINWIDTH-320.
- **ICN-NS is the notable open thread:** `docs/as-designed/icon-system.md` holds the full 4-system audit + a **§5 canonical-system decision (Option A MattIcon-canonical [recommended] / B icons.tsx-canonical / C dedup-names-only)** that needs a user call before any renames. Phase 1 bounded cut (retire near-legacy `icon-paths.ts` = 6 call sites + dedup 3 brand logos) is ready once decided. Also flagged: verify `CloseIcon` vs `XIcon` are the same glyph (icon-system.md §3.4).
- **PREFLIP-WT** is ready to action whenever (user-gated; the port-audit reason cleared; worktree still exists at `~/projects/Peerloop-preflip`). Left parked pending user say-so.
- **BRAND-CASE precedent:** left 29 `PeerLoop` in `src/` by design (12 `PeerLoopFeatures*` code identifiers, the Figma file-name ref, the wordmark SVG group id, general comments, `/old` legacy h1). The r-end docs agent additionally fixed 2 driftCheck docs (`_COMPONENTS.md`, `API-AUTH.md`) that quoted the exact changed literals.
- **Wordmark hand-edit technique** (reusable, see this conv's Learnings): swap one outlined glyph + `<g translate>` re-kern + proportional viewBox/width tighten; verify by HTTP-serving the SVG to Chrome (`file://` blocked).
- **Decisions routed:** BRAND-CASE → `docs/decisions/05-ui-ux-components.md`; ICN-NS → `docs/decisions/01-architecture.md` (both + decision-log + INDEX); TIMELINE got the ICN-NS row.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

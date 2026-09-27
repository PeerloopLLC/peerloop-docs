# State — Conv 456 (2026-09-27 ~12:35)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-17`, docs: `main`

## Summary

CC-infrastructure conv (no code changes). Retired the MEMORY.md auto-memory system (101 detail files → `docs/reference/memory-archive/`, index folded into CLAUDE-OFFLOAD.md § Situational Notes Archive, all skills/scripts de-memoried), then did a coherence-check-driven currency + terseness prune of CLAUDE.md and CLAUDE-OFFLOAD.md, and recorded a page-provenance governance decision. Three feature commits (`c08f144`, `3b8765e`, `870a76a`) plus this end-of-conv bookkeeping commit.

## Key Context

- **Memory system is gone for good.** No `MEMORY.md`, no live memory dir, no `.claude/memory-sync/` mirror — CLAUDE.md §Memory forbids re-creating any. Durable situational detail → `docs/reference/CLAUDE-OFFLOAD.md` or a topic doc; the retired index lives in CLAUDE-OFFLOAD.md § Situational Notes Archive (git-tracked, on-demand, not auto-loaded).
- **Prune decisions this conv:** AskUserQuestion directive fully replaced by A/B (Conv 438) in CLAUDE.md; PlugNmeet dropped — **BBB is the sole video provider**; Key Metrics table removed from OFFLOAD; 9 dead archive-index entries culled + their files `git rm`'d (memory-mirror/dir/sync, pre-flip worktree, `/old` route-migration era).
- **`/old` routing is fully dropped.** Matt formats still valid but fading as Brian takes over the final style. **Brian-era styling is intentionally unattributed** — the 3-marker page-provenance convention (live: 180 markers in `src`, 0 `@brian`) captures Matt-era heritage only; new pages Brian adds stay unmarked, restyled attributed pages keep their existing marker, no `@brian-*` axis by design. Recorded in CLAUDE.md §Page Provenance + `matt-provenance.md §11`.
- **New task `[OLDOC]`** (queued): manual/plan docs still describe the dropped `/old` routing (`url-routing.md`, `plan/route-migration/README.md`, `docs/decisions/*`) — low-urgency doc-currency sweep.
- The pre-existing NEXT-CONV priority note in CURRENT-TASKS.md (`[RHOOKS]`+`[A11Y]` codecheck-warning cleanup) is unchanged and still stands.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

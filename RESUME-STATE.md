# State — Conv 353 (2026-06-30 ~13:14)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread infra conv: executed **[MEM-CAP-ARCH] Phase 1** — re-architected the auto-memory index. The live `MEMORY.md` was rewritten from a flat 82-line list (86% of the 25 KB SessionStart cap) into a **two-tier HOT/COLD structure** (🔥 22 always-on rules first + full, 📇 60 situational entries terse), landing at **71%** with all 82 entries intact and 0 broken links. The architecture was chosen only after a deep discussion that pressure-tested relocating the index to CLAUDE.md (rejected — MEMORY.md's "background context" framing is the right fit for situational recall; CLAUDE.md is for instructions). A `§Memory Index Tiering` section was added to CLAUDE.md recording the **default-COLD write-time rule**.

## Key Context

- **The cap mechanic (confirmed against `code.claude.com/docs/en/memory.md`):** only `MEMORY.md` auto-loads (first 200 lines OR 25 KB, whichever first); the 82 sub-files load on-demand; `@path` imports are CLAUDE.md-only and don't reduce context. Bytes bind before lines. Overflow is silently dropped — HOT-first ordering means the situational COLD tail truncates first, protecting always-on rules.
- **Projection miss (noted honestly):** estimated ~13.5 KB, delivered 18 KB — HOT lines are the longest by design + COLD ran ~150 B not 110 B. User accepted 71%; the durable win is that new entries now default COLD (~150 B vs old ~286 B median), roughly halving per-entry growth.
- **Archive pass moved nothing** — verification found ~0 confidently-dead entries.
- **Decision routed** to `DOC-DECISIONS.md §3` (Claude Code Workflow) + a TIMELINE.md row.
- **Phase 2 (next conv, top of Ordered, [Opus]):** rewrite `/r-prune-memory` to enforce the grammar — default new entries COLD, tier-aware flatten, periodic auto-re-tier. See `CURRENT-TASKS.md`.
- **Baseline NOT re-verified this conv** — code repo untouched + clean all conv; last green was Conv 349.
- For the full task backlog, see `CURRENT-TASKS.md` (do not re-list here).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

# State — Conv 358 (2026-07-02 ~10:30)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Retired the MEMORY.md HOT/COLD two-tier index via **full-collapse** ([MEM-CAP-ARCH]) — consolidated all always-on rules into CLAUDE.md and collapsed MEMORY.md to a single flat situational-recall index (no loss). Then pruned CLAUDE.md ([PRUNE-CLAUDE]) — moved 7 reference sections to CLAUDE-OFFLOAD.md, 344→250 lines. Two docs commits: `90e096b` (full-collapse) + this r-end commit.

## Key Context

- **New memory model (hold this in one sentence):** *CLAUDE.md = all standing rules; MEMORY.md = single flat situational-recall index* (+ a "Rule detail & incident-history" section behind the CLAUDE.md rules). No tiers, no enforcer. CLAUDE.md gained **§Guards** + **§Task Persistence** + 5 in-place rule lines; §Memory Index Tiering was replaced by a single-tier **§Memory** note.
- **The Phase-2 tier-enforcer was retired, not built** — a calibration proved content-keyword auto-re-tiering misfires (2/2 false demotions on the hand-tiered file), and an audit found the HOT tier was a 3-way conflation with **0 pure duplicates** (8 hybrid / 10 unique-rule / 4 situational). Reversal recorded in `DOC-DECISIONS.md §3` (Conv-358; Conv-353 marked superseded).
- **CLAUDE.md is now exactly 250 lines** (at the soft threshold). All 7 pruned §headers were kept as stubs → the memory `§`-references still resolve. If it climbs again, `/r-prune-claude` is the lever.
- **MEMORY.md = single-tier, 66% of the 25 KB cap**, 82 pointers intact (verified: 0 orphans/dupes/broken links).
- For the task backlog, see `CURRENT-TASKS.md` — **Ordered is empty**; pick the next item (e.g. [LAYOUT-SG], [VITE-DEDUP], [TZ-AUDIT], or the low-pri [LAYOUT-DOC]/[LAYOUT-TOGGLE-AFF] Conv-357 follow-ups).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

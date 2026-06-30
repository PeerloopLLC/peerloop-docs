# State — Conv 350 (2026-06-29 ~20:56)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread conv: a **task-persistence architecture decision + Phase-1 build** ([CURTASKS]). Triggered by an r-start premise correction — the machine-local `.scratch/conv-tasks.md` is stale-on-return after multi-conv stints on the other machine — the conv re-examined conv-tasks.md's scope creep and decided to **adopt the sibling spt project's `CURRENT-TASKS.md` model** (decision B): one git-tracked, hand-editable, persistent task store; `RESUME-STATE.md` demoted to narrative-only; `.scratch/conv-tasks.md` retired. Two Explore surveys (spt machinery + peerloop rewire surface) grounded the design. **Phase 1 (design + seed) shipped + committed (`310da50`)** — seeded `CURRENT-TASKS.md` (transitional, not yet wired) + `PLAN § CURTASKS` (DEC-350-1/-2/-3, 5-phase plan, rewire surface). The skill cutover (Phases 2–5) is deferred to a focused conv.

## Completed

- [x] `/r-start` Conv 350 (counter 349→350 pushed `217ac60`; memory synced; stale `.scratch/conv-tasks.md` reconciled 15→13 via git evidence — not a false-halt)
- [x] [CURTASKS] Phase 1 — adopt-decision (B) + seeded `CURRENT-TASKS.md` + `PLAN § CURTASKS` design block. Committed/pushed (docs `310da50`).

## Remaining

CURTASKS is the active multi-conv block; the rest are the carried-forward backlog.

- [ ] [CURTASKS] [Opus] #14 — Phases 2–5 of the CURRENT-TASKS.md migration (the skill cutover). Phase 2 read-path (`/r-start`) + Phase 3 write-path (`/r-end` + `/r-commit` + new `/r-update-tasks`) = the **atomic cutover** (read & write flip together); Phase 4 scripts/config/ancillary; Phase 5 docs/memory + retire `.scratch/conv-tasks.md`. SoT: `PLAN § CURTASKS`.
- [ ] [PLAN-XTRACT] #15 — extract bloated inline PLAN.md blocks to `plan/<slug>/README.md` (PLAN.md = 62K tokens, exceeds the Read-tool limit; forced a Python-splice workaround Conv 350). Low priority.
- [ ] [MEM-CAP-ARCH] [Opus] #3 — MEMORY.md at ~87% of the 25 KB SessionStart cap; architectural fix; do NOT re-run /r-prune-memory.
- [ ] [LAYOUT-SG] #2 — `/course/[slug]` hero inset-vs-full-bleed design call.
- [ ] [VITE-DEDUP] #4 — durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash (workaround `rm -rf node_modules/.vite`).
- [ ] [HOME-FIXES] #5 · [COURSES-FIXES] #6 — deferred per-route fix buckets.
- [ ] [ICN-NS] #7 — icon-namespace cleanup across the two icon systems + MattIcon registry.
- [ ] [TZ-AUDIT] [Opus] #8 — timezone-correctness audit.
- [ ] [DOCGEN-SPEC] #9 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md.
- [ ] [V217-WATCH] #10 — watch the [TERM-GARBLE] upstream CC bug.
- [ ] [PREFLIP-WT] #11 — teardown the preflip worktree (consequential + machine-local; on user say-so).
- [ ] [BROWSER-SMOKE-2B] [Opus] #12 — POST-LAUNCH: evaluate an LLM-driven headless PLATO browser-mode smoke-walk executor; do NOT resurrect Playwright E2E.
- [ ] [RG-PUBLIC] #1 — public/marketing route group sweep (parked until marketing redesign; `/old` keep-set, 404 at root by design).
- [ ] [BRAND-CASE] #13 — app-wide "PeerLoop"→"Peerloop" casing cleanup (45 camelCase instances; verify each isn't intentional before bulk replace; skip the wordmark SVG filename).

## TodoWrite Items

- [ ] #1 [RG-PUBLIC] · #2 [LAYOUT-SG] · #3 [MEM-CAP-ARCH] [Opus] · #4 [VITE-DEDUP] · #5 [HOME-FIXES] · #6 [COURSES-FIXES] · #7 [ICN-NS] · #8 [TZ-AUDIT] [Opus] · #9 [DOCGEN-SPEC] · #10 [V217-WATCH] · #11 [PREFLIP-WT] · #12 [BROWSER-SMOKE-2B] [Opus] · #13 [BRAND-CASE] · #14 [CURTASKS] [Opus] · #15 [PLAN-XTRACT]

## Key Context

- **[CURTASKS] is the headline ongoing work** — task-persistence migration to the spt `CURRENT-TASKS.md` model. Phase 1 (seed + design) done + committed `310da50`. **`CURRENT-TASKS.md` exists at repo root but is TRANSITIONAL — NOT yet wired into skills;** the live workflow still uses `RESUME-STATE.md` + `.scratch/conv-tasks.md` until the Phase 2–3 cutover. Full design + 5-phase plan + rewire surface (8 behavioral files + docs/memory) in `PLAN § CURTASKS`. Decisions DEC-350-1 (adopt B) / -2 (active-only hydration) / -3 (checkpoint-refresh) — also in `DOC-DECISIONS.md` §3.
- **The next `/r-start` runs on the OLD path** (reads this RESUME-STATE, regenerates `.scratch/conv-tasks.md`) — by design; the cutover hasn't landed. Do NOT assume CURRENT-TASKS.md is live yet.
- **Machine cadence:** user works several convs on one machine then switches (346 M4, 347–349 M4Pro, 350 M4). This is why `.scratch/conv-tasks.md` was stale on return — expected, not a bug.
- **Baseline NOT re-verified this conv** — no code touched (code repo clean all conv); last green was Conv 349 (6728/6728, 5 gates), not re-run this conv.
- **Tooling note:** PLAN.md (62K tokens) exceeds the Read tool's limit → can't be Edited normally; use an anchored Python splice, or do [PLAN-XTRACT] #15.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

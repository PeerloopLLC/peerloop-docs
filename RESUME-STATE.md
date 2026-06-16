# State — Conv 293 (2026-06-16 ~17:48)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Skill/shell tooling hardening conv (no Peerloop coding). Two safeguards against the throwaway-session incident where `spt` launched from a Peerloop terminal trampled a concurrent spt session: (1) a **symmetric cross-project launch guard** (`_guard_launch`) added to `~/.zshrc` — `spt`/`peerloop` each refuse to launch when cwd is inside the other project's tree (machine-local, M4Pro only); (2) a **concurrent-session lock** wired into r-start (Step 0) and r-end (Step 8) — `conv-session-lock.sh` (machine-local lock, PID+session-id ownership) halts a second same-machine r-start on ACTIVE, prompts on STALE, self-heals on dead PID. The lock feature is in-repo (syncs via git); the `.zshrc` guard needs hand-application on the M4.

## Completed

- [x] `_guard_launch` symmetric launch guard in `~/.zshrc` (backup `~/.zshrc.bak-conv293`); 8 cases verified incl. Peerloop/Peerloop-preflip boundary
- [x] `.scratch/zshrc-launch-guard-for-M4.md` written for M4 hand-application
- [x] `.claude/scripts/conv-session-lock.sh` (check/acquire/release); 9 paths tested incl. ACTIVE vs real live claude pid
- [x] r-start: pre-computed "Concurrent session check" line + Step 0 guard + HALT Rule
- [x] r-end: Step 8 lock release (owner-checked)
- [x] Live lock acquired for this session (immediate protection)
- [x] Decision routed to DOC-DECISIONS.md §3; 1 TIMELINE entry

## Remaining

**New this conv:**
- [ ] [M4-ZGUARD] (#29) Apply the `_guard_launch` block to the M4's `~/.zshrc` (machine-local; paste block + steps in `.scratch/zshrc-launch-guard-for-M4.md`)

**Route sweep (RTMIG-4) + cross-cutting (carried from Conv 292):**
- [ ] [RG-COURSES] (#10, in_progress) Sweep `/course/[slug]/{[...tab],book,precheckout,success}` (4 routes; route 1 `/courses` swept Conv 292)
- [ ] [RTMIG-4] umbrella (blocked) · [RG-ADMIN] · [RG-PUBPROF] [Opus] (blocked by ROLE-SEMANTICS) · [RG-AUTH] · [ROLE-SEMANTICS] [Opus] · [RG-PROFILE] · [RG-COMMS] · [RG-DISCOVER] · [RG-WORKSPACES] [Opus] ⛔client · [RG-MESSAGES]/[RG-NOTIFS]/[RG-SESSIONS]/[RG-MOD]/[RG-PUBLIC] (deferred)
- [ ] [OLD-PORTED-CLEANUP] · [PREFLIP-WT] · [E2E-MIG] · [E2E-GATE] (blocked by E2E-MIG) · [ICN-NS] · [TZ-AUDIT] [Opus] · [DOCGEN-SPEC] · [V217-WATCH] · [MEM-PRUNE] · [LAYOUT-SG] · [PROV-STAMP-GAPS] · [HOME-FIXES] · [COURSES-FIXES] (open: [FILTERS-RESPONSIVE], [TYPO-REVIEW])

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] · #9 [RG-PROFILE] · #10 [RG-COURSES] (in_progress) · #11 [RG-COMMS] · #12 [RG-DISCOVER] · #13 [E2E-MIG] · #14 [E2E-GATE] · #15 [ICN-NS] · #16 [TZ-AUDIT] [Opus] · #17 [DOCGEN-SPEC] · #18 [V217-WATCH] · #19 [MEM-PRUNE] · #20 [LAYOUT-SG] · #21 [RG-MESSAGES] · #22 [RG-NOTIFS] · #23 [RG-SESSIONS] · #24 [RG-MOD] · #25 [RG-PUBLIC] · #26 [PROV-STAMP-GAPS] · #27 [HOME-FIXES] · #28 [COURSES-FIXES] · #29 [M4-ZGUARD]

## Key Context

- **Session lock (NEW Conv 293):** `~/.claude/projects/<slug>/active-session.lock` (machine-local, NOT in git). r-start Step 0 reads it via `conv-session-lock.sh check` (`CLEAR`/`ACTIVE`/`STALE`); ACTIVE→halt, STALE→prompt yes/no, CLEAR→acquire. r-end Step 8 releases (owner-checked, never clears another terminal's). Self-heals via dead-PID detection. Guards **same-machine** concurrency only; cross-machine still relies on the non-ff push-fail halt.
- **Launch guard (NEW Conv 293):** `_guard_launch` in `~/.zshrc` — machine-local, M4Pro only. [M4-ZGUARD] (#29) tracks applying it on the M4. `.zshrc` is a plain per-machine file (not synced) — two Minis intentionally isolated (user decision).
- **Route sweep SoT (unchanged):** `plan/route-migration/README.md` (8-step process + 14-group checklist) + `tier2-primitive-ledger.md`.
- **Dev/staging dismissibles reappear on reload BY DESIGN** (`ephemeral-dismiss.ts`) — do NOT re-persist (memory `project_ephemeral_dismiss_dev_staging`).
- **MEMORY.md ~84%** of SessionStart cap → **[MEM-PRUNE] (#19) live** — run `/r-prune-memory` (NOT /r-prune-claude). No memory added this conv.
- **Branch:** code on `jfg-dev-14`. `jfg-dev-NN` branches are intentional snapshots — do NOT propose deleting.
- **Commits this conv:** docs only (code repo clean). /r-end commit adds the feature + session docs.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

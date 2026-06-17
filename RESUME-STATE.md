# State — Conv 294 (2026-06-16 ~20:19)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

CC-workflow tooling conv (no Peerloop coding). Built two `.scratch/` re-orientation companions and wired them into the lifecycle skills: (1) **conv-turns.md** — a CC-maintained, newest-first per-turn log capturing each user question **in full** + a **terse** reply (selected-choice value for `AskUserQuestion` picks); seeded fresh each conv by `/r-start` (new Step 7.7) and read as a COLLECT cross-check by `/r-end` (Step 2). (2) **vernacular.md** — a persistent (non-conv-scoped) 3-column acronym glossary (Acronym · Literal meaning · Context/comments), ~38 terms, append-as-we-go. Both disciplines codified in new CLAUDE.md sections. No project tasks were touched — RG-COURSES (#10) stays parked/in_progress.

## Completed

- [x] Built conv-turns.md mechanism (file + CLAUDE.md "Conversation Turn Log" per-turn discipline); CC-maintained + newest-first (user-chosen)
- [x] Corrected scope: question stored in full (verbatim), only reply terse
- [x] Wired conv-turns into `/r-start` (Step 7.7 seed) and `/r-end` (Step 2 COLLECT read)
- [x] Created vernacular.md (3-column, ~38 terms incl. CoW/CD/DOM/DR/WORM/QLINT/DNS/PR; SOP context = RTMIG-4 route-sweep) + CLAUDE.md "Vernacular Glossary" pointer

## Remaining

**New this conv:**
- [ ] [RSTART-DIFFGATE] (#30) Gate `/r-start` Step 2.5 self-update check on whether Step 2's pull actually moved HEAD — `HEAD@{1}` diffs against stale history after a no-op pull, firing a false-positive STALE warning (seen this conv).

**Route sweep (RTMIG-4) + cross-cutting (carried from Conv 293):**
- [ ] [RG-COURSES] (#10, in_progress) Sweep `/course/[slug]/{[...tab],book,precheckout,success}` (routes 2–5; route 1 `/courses` swept Conv 292)
- [ ] [RTMIG-4] umbrella (blocked) · [RG-ADMIN] · [RG-PUBPROF] [Opus] (blocked by ROLE-SEMANTICS) · [RG-AUTH] · [ROLE-SEMANTICS] [Opus] · [RG-PROFILE] · [RG-COMMS] · [RG-DISCOVER] · [RG-WORKSPACES] [Opus] ⛔client · [RG-MESSAGES]/[RG-NOTIFS]/[RG-SESSIONS]/[RG-MOD]/[RG-PUBLIC] (deferred)
- [ ] [OLD-PORTED-CLEANUP] · [PREFLIP-WT] · [E2E-MIG] · [E2E-GATE] (blocked by E2E-MIG) · [ICN-NS] · [TZ-AUDIT] [Opus] · [DOCGEN-SPEC] · [V217-WATCH] · [MEM-PRUNE] · [LAYOUT-SG] · [PROV-STAMP-GAPS] · [HOME-FIXES] · [COURSES-FIXES] (open: [FILTERS-RESPONSIVE], [TYPO-REVIEW]) · [M4-ZGUARD]

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] · #9 [RG-PROFILE] · #10 [RG-COURSES] (in_progress) · #11 [RG-COMMS] · #12 [RG-DISCOVER] · #13 [E2E-MIG] · #14 [E2E-GATE] · #15 [ICN-NS] · #16 [TZ-AUDIT] [Opus] · #17 [DOCGEN-SPEC] · #18 [V217-WATCH] · #19 [MEM-PRUNE] · #20 [LAYOUT-SG] · #21 [RG-MESSAGES] · #22 [RG-NOTIFS] · #23 [RG-SESSIONS] · #24 [RG-MOD] · #25 [RG-PUBLIC] · #26 [PROV-STAMP-GAPS] · #27 [HOME-FIXES] · #28 [COURSES-FIXES] · #29 [M4-ZGUARD] · #30 [RSTART-DIFFGATE]

## Key Context

- **conv-turns.md (NEW Conv 294):** `.scratch/conv-turns.md` — CC-maintained, **newest-first**, one entry/turn: question **in full** + **terse** reply (`▸ chose "X"` for picks). Conv-scoped; `/r-start` Step 7.7 seeds fresh, `/r-end` Step 2 reads it. Discipline in CLAUDE.md § "Conversation Turn Log" (loaded every turn — that's what keeps it current). Gitignored.
- **vernacular.md (NEW Conv 294):** `.scratch/vernacular.md` — 3-column acronym glossary, **persistent across convs** (NOT re-seeded by /r-start), append-as-we-go. Discipline in CLAUDE.md § "Vernacular Glossary". Gitignored.
- **MEMORY.md ~84%** of SessionStart cap → **[MEM-PRUNE] (#19) live** — run `/r-prune-memory` (NOT /r-prune-claude). No memory added this conv.
- **Branch:** code on `jfg-dev-14` (unchanged; clean — no code touched this conv). `jfg-dev-NN` branches are intentional snapshots.
- **Commits this conv:** docs only (CLAUDE.md + r-start/r-end SKILL.md + RESUME-STATE delete + session docs); code repo clean.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

# State — Conv 342 (2026-06-27 ~16:46)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread conv on **[PLATO-REVIVE]** (#14). Took it from scoped-but-untouched to **only the live re-walk remaining**: decided the data strategy (Option C → generate snapshots, after reframing it as a missing-snapshot rather than wrong-persona problem), generated 3 snapshots, fixed a latent `activities` verify bug (expected 7 all-day availability slots; the step creates 5 weekday), re-pointed all 17 nav waypoints to the post-route-flip Sidebar, refreshed instance prose + the `member-directory` expectations (source-grounded, 2 `// LIVE-CONFIRM` deferred), resolved `new-user-pair` as a self-building exception, and refreshed the stale `PLATO-REGISTRY.md`. Verified tsc + PLATO API 10/10 throughout. Four commit pairs + end-of-conv bookkeeping.

## Completed

- [x] [PLATO-REVIVE] Bucket 3 — data strategy → Option C (snapshots); 3 `.sqlite` generated (member-directory/activities/ecosystem); `activities` verify-bug fixed (7→5)
- [x] [PLATO-REVIVE] Bucket 1 — all 17 nav waypoints re-pointed to the Sidebar model (DiscoverSlidePanel→Courses/Members, Dashboard→Learning/Home, UserAccountDropdown→/profile tabs)
- [x] [PLATO-REVIVE] Bucket 2 — stale-route prose fixed; member-directory expectations source-grounded (default Creator filter, exact empty-state copy); 2 `// LIVE-CONFIRM` deferred; "dashboard" wording left as-is
- [x] [PLATO-REVIVE] new-user-pair resolved → stays self-building (no snapshot)
- [x] [PLATO-REVIVE] PLATO-REGISTRY.md refreshed (two-layer model, 8-instance table, 7/8 snapshotted)
- [x] Baseline verified (tsc clean, PLATO API 10/10); commits 57c5e623/8aa90542/ba914c76 (code), 3ec1770/a3689b2/9882862 (docs)

## Remaining

- [ ] [RG-PUBLIC] #1 — public/marketing route group sweep (parked until marketing redesign; `/old` keep-set, 404 at root by design)
- [ ] [LAYOUT-SG] #2 — `/course/[slug]` hero inset-vs-full-bleed design call
- [ ] [MEM-CAP-ARCH] #3 [Opus] — MEMORY.md at ~85% of the 25 KB SessionStart cap (measured 21823/25600 bytes this conv); architectural fix; do NOT re-run /r-prune-memory
- [ ] [VITE-DEDUP] #4 — durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash (workaround `rm -rf node_modules/.vite`)
- [ ] [HOME-FIXES] #5 · [COURSES-FIXES] #6 — deferred per-route fix buckets
- [ ] [E2E-MIG] #7 — migrate E2E (Playwright) tests post-flip
- [ ] [E2E-GATE] #8 — restore the E2E (Playwright) gate. **NEW candidate folded in (Conv 342):** also gate the PLATO instanceFile path (static `Instance:` blocks or a `PLATO_INSTANCE` CI loop) so file-level `verify` drift can't hide — the `activities` 7-vs-5 bug was dormant precisely because those instances never ran as instanceFiles in `npm test`
- [ ] [ICN-NS] #9 — icon-namespace cleanup across the two icon systems + MattIcon registry
- [ ] [TZ-AUDIT] #10 [Opus] — timezone-correctness audit
- [ ] [DOCGEN-SPEC] #11 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md
- [ ] [V217-WATCH] #12 — watch the [TERM-GARBLE] upstream CC bug
- [ ] [PREFLIP-WT] #13 — teardown the preflip worktree (consequential + machine-local; on user say-so)
- [ ] [PLATO-REVIVE] #14 — **only the live re-walk remains.** Drive the open `:4321` server to walk an instance (e.g. member-directory) + resolve the 2 `// LIVE-CONFIRM` markers (role-less-Alex visibility under no filter; exact pagination total) + per-page expectation validation across instances. NOTE: restoring a snapshot into the dev D1 mutates the running dev DB — explicit opt-in. Buckets 1-3 + new-user-pair + registry already DONE (see Completed). SoT: PLAN.md § PLATO-REVIVE.

## TodoWrite Items

- [ ] #1 [RG-PUBLIC] · #2 [LAYOUT-SG] · #3 [MEM-CAP-ARCH] [Opus] · #4 [VITE-DEDUP] · #5 [HOME-FIXES] · #6 [COURSES-FIXES] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [PREFLIP-WT] · #14 [PLATO-REVIVE] (in_progress — live re-walk only)

## Key Context

- **Baseline GREEN this conv** — tsc clean + PLATO API 10/10, re-run after each change. Full `npm test` suite NOT run this conv (changes were confined to `tests/plato/` fixtures + docs; tsc + the directly-affected PLATO API test was the proportionate gate set). Carry-forward suite count unchanged from Conv 341 (6697/6697, not re-verified this conv).
- **PLATO snapshots are gitignored** — the 3 generated `.sqlite` (member-directory/activities/ecosystem) are local-only; they regenerate per-machine from the committed instance files via the API test (`snapshot: true` write-on-pass) or `plato:restore`. On the other machine, pull the instance files then regenerate.
- **Snapshot mechanism** — `snapshot: true` writes `tests/plato/snapshots/{name}.sqlite` only when the instanceFile run PASSES (`plato-scenarios.api.test.ts:400`), serializing the in-memory better-sqlite3 test DB — never the dev D1. Generate a single instance via `PLATO_INSTANCE=<name> npx vitest run tests/plato/api/plato-scenarios.api.test.ts --testNamePattern="run <name>"`.
- **member-directory `// LIVE-CONFIRM` markers** — 2 in-file: (a) does a registered-but-role-less user (Alex) list under "no role filter"? (b) exact pagination total under cleared filters. `/members` defaults to the **Creator** role filter (`MembersFilters.getInitialMemberRoles`); empty-state copy is exactly "No members found matching your criteria." (`MembersDirectory.tsx:186`).
- **Live re-walk preconditions** — use the user's open `:4321` dev server (do NOT spawn a fresh port — Conv 321 precedent). Restoring a snapshot mutates the dev D1 (opt-in). Chrome bridge `javascript_tool` rejects top-level `await` — use `.then()` chains.
- Commits land before this snapshot (Step 6 bookkeeping commit carries Extract/Learnings/Decisions/RESUME-STATE). All PLATO-REVIVE work already committed mid-conv.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

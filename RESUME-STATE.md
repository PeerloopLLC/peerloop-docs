# State — Conv 343 (2026-06-27 ~20:20)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread conv that **CLOSED [PLATO-REVIVE]** (#14). Resolved the 2 member-directory `// LIVE-CONFIRM` markers from source (frontend→API→SQL, no dev-D1 mutation), then the per-page expectation sweep across the other 4 walkthrough instances was reframed (user catch) into a **port-fidelity audit**: 7 "missing UI" findings triaged REDESIGN/REGRESSION/NEVER-EXISTED vs the legacy preflip worktree (`608346a2`) → **0 port regressions** (the Matt port preserved behavior, several components byte-identical). Applied ~50 `expect`/`pageAction` fixes across 5 instances + 2 stale code-comment fixes; surfaced 3 backend-ready UI gaps → new **[PLATO-GAP] #15**. Baseline GREEN (tsc 0, PLATO API 10/10, 4 instanceFiles pass). Committed (code `30da9fa6`, docs `7f680a3`) + this end-of-conv bookkeeping.

## Completed

- [x] [PLATO-REVIVE] member-directory `// LIVE-CONFIRM` markers resolved from source; per-page validation done as a port-audit (0 regressions); ~50 prose fixes + 2 comment fixes; block CLOSED + archived plan/COMPLETED.md #73

## Remaining

- [ ] [RG-PUBLIC] #1 — public/marketing route group sweep (parked until marketing redesign; `/old` keep-set, 404 at root by design)
- [ ] [LAYOUT-SG] #2 — `/course/[slug]` hero inset-vs-full-bleed design call
- [ ] [MEM-CAP-ARCH] #3 [Opus] — MEMORY.md at ~85% of the 25 KB SessionStart cap; architectural fix; do NOT re-run /r-prune-memory
- [ ] [VITE-DEDUP] #4 — durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash (workaround `rm -rf node_modules/.vite`)
- [ ] [HOME-FIXES] #5 · [COURSES-FIXES] #6 — deferred per-route fix buckets
- [ ] [E2E-MIG] #7 — migrate E2E (Playwright) tests post-flip
- [ ] [E2E-GATE] #8 — restore the E2E gate + gate the PLATO instanceFile path. Reinforced Conv 343: activities/ecosystem/member-directory pass as instanceFiles when run manually but aren't static `Instance:` blocks in `npm test`, so file-level `verify` drift can still hide
- [ ] [ICN-NS] #9 — icon-namespace cleanup across the two icon systems + MattIcon registry
- [ ] [TZ-AUDIT] #10 [Opus] — timezone-correctness audit
- [ ] [DOCGEN-SPEC] #11 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md
- [ ] [V217-WATCH] #12 — watch the [TERM-GARBLE] upstream CC bug
- [ ] [PREFLIP-WT] #13 — teardown the preflip worktree (consequential + machine-local; on user say-so). **NOTE (Conv 343):** the preflip worktree (`608346a2`) is the legacy source-of-truth used for PLATO port-audits — keep it until [PLATO-GAP] #15 (which may need legacy comparison) is done
- [ ] [PLATO-GAP] #15 — build 3 backend-ready UI gaps surfaced by PLATO-REVIVE (Follow-wire / creator self-certify UI / homework per-module + file upload). Net-new UI-only builds; backends exist. When built, re-sync the corresponding PLATO `// GAP (Conv 343)` prose (drop the markers)

## TodoWrite Items

- [ ] #1 [RG-PUBLIC] · #2 [LAYOUT-SG] · #3 [MEM-CAP-ARCH] [Opus] · #4 [VITE-DEDUP] · #5 [HOME-FIXES] · #6 [COURSES-FIXES] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [PREFLIP-WT] · #15 [PLATO-GAP]

## Key Context

- **PLATO-REVIVE CLOSED Conv 343** — SoT PLAN.md § PLATO-REVIVE (✅ DONE) + plan/COMPLETED.md #73. Memory saved: `feedback_plato_expect_is_legacy_spec` (a PLATO `expect`/`pageAction` is a frozen functional spec of the legacy pages; triage REDESIGN/REGRESSION/NEVER-EXISTED vs preflip `608346a2` before editing the test — editing it to match a regressed page hides the regression).
- **Baseline GREEN this conv** — tsc 0, PLATO API 10/10, 4 instanceFiles pass. Full `npm test` suite NOT run (changes confined to `tests/plato/` prose + 2 source comments). Carry-forward suite count unchanged from Conv 341 (6697/6697, not re-verified this conv).
- **[PLATO-GAP] #15 detail** — all 3 gaps have working backends, UI-only builds: (1) Follow: `POST/DELETE /api/users/[handle]/follow` + `follows` table exist; copy `CourseFollowButton.tsx`; (2) self-certify: `POST /api/me/courses/[id]/teachers` `isCreatorSelfCert` branch; reuse `handleCertify(course.creator_id)` in the CourseEditor Teachers tab; (3) homework: create API accepts `module_id` (per-module = S); R2 `uploadToR2` + the resources-upload multipart pattern exist (file upload = S/M).
- Commits: code `30da9fa6`, docs `7f680a3` (feature work via /r-commit) + this end-of-conv bookkeeping commit pair (Step 6).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

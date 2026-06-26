# State — Conv 337 (2026-06-26 ~12:36)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Cross-cutting conformance-foundations conv riding RTMIG-4's tail. Closed **XCUT-BACKREF** (admin red-links 0 hits; 32 UserAvatar consumers verified no-overflow), **TA-SKEL** (skeleton px-snap), and the full **SPACING-4PX-SWEEP + SWEEP-SPACING-GREP** (94 arbitrary-`[Npx]` margin/padding/gap sites across 40 files → 39 tokenized + 20 snapped per §170 ties-up; KEEPs preserved; 22 files / 47↔47). The sweep's full-suite run **surfaced 5 PRE-EXISTING test failures** (red since the RG-ADMIN sweep, Convs 332–336 — Conv-336 "all green" was inaccurate) — proven pre-existing via `git stash`, all stale assertions of conformed-away classes; fixed → **suite restored 6737/6737** ([ADMIN-TEST-STALE]). Finally found **PALETTE-FDN #29** (profile status banners) already conformed and marked it resolved in the ledger. 4 commits (3 code + 1 docs), all 6 gates green at close.

## Completed

- [x] [XCUT-BACKREF] verified CLEAN — `text-red-{500,600,700}` 0 hits in src/components/admin; all 32 UserAvatar consumers no overflow (every site uses `shrink-0` or `flex-1 min-w-0`); UserCardCompact confirmed 0-importer dead (→ OLD-PORTED-CLEANUP). Code `1edfac46`.
- [x] [TA-SKEL] TeacherAnalytics StatCard skeleton `w-80`/`w-96` → `w-[80px]`/`w-[96px]` (off-set → 320/384px bug). Code `1edfac46`.
- [x] [SPACING-4PX-SWEEP] + [SWEEP-SPACING-GREP] full arbitrary-`[Npx]` spacing sweep, 22 files (39 on-scale tokenized + 6→8/10→12/28→32 snapped; KEEPs: 2px sub-optical, AnalyticCount comment, AppLayout 88/96 offsets, AdminLayout 220 sidebar). Code `d9ded988`.
- [x] [ADMIN-TEST-STALE] (NEW) fixed 5 pre-existing stale admin tests → conformed classes; **full suite GREEN 6737/6737**. Code `838da44d`.
- [x] [PALETTE-FDN] #29 profile-banner deferral verified already-resolved + migration-ledger updated. Docs `5823442`.

## Remaining

- [ ] [RTMIG-4] #1 (in_progress) — route sweep umbrella, at its **planned stopping point** (all canonical groups swept; only RG-PUBLIC remains, parked-by-decision). SoT `plan/route-migration/README.md`.
- [ ] [RG-PUBLIC] #2 — public/marketing route group, **parked-by-decision** until the marketing redesign (footer root-link 404s accepted; do NOT port/repoint).
- [ ] [LAYOUT-SG] #8 — layout style-guide; one open thread = `/course/[slug]` hero **inset-vs-full-bleed** decision (needs a design call, not a sweep).
- [ ] [MEM-CAP-ARCH] #9 [Opus] — MEMORY.md at 84% of the 25 KB SessionStart cap; **architectural** fix, do NOT re-run /r-prune-memory.
- [ ] [VITE-DEDUP] #10 — durable fix for the Vite SSR "multiple copies of React" cold-start crash (workaround: `rm -rf node_modules/.vite`).
- [ ] [PROV-STAMP-GAPS] #11 — fill pages missing the `@stand-in`/`@matt-source`/`@matt-inspired` provenance marker.
- [ ] [HOME-FIXES] #12 · [COURSES-FIXES] #13 — deferred per-route fix buckets.
- [ ] [E2E-MIG] #14 · [E2E-GATE] #15 — migrate E2E tests post-route-flip + restore the E2E gate.
- [ ] [ICN-NS] #16 — icon-namespace cleanup across the two icon systems + MattIcon registry.
- [ ] [TZ-AUDIT] #17 [Opus] — timezone-correctness audit (recurring `new Date()`; low confidence).
- [ ] [DOCGEN-SPEC] #18 — document the `regen` binding + Step 5c gate in doc-sync-strategy.md (low priority).
- [ ] [V217-WATCH] #19 — watch the [TERM-GARBLE] upstream CC bug for a fix.
- [ ] [M4-ZGUARD] #20 — M4-machine z-index/guard follow-up (thin).
- [ ] [OLD-PORTED-CLEANUP] #21 — delete already-ported `/old/X` copies + dead UserCardCompact/HomeFeed/FeedAllTab/FeedRoleTab.
- [ ] [PREFLIP-WT] #22 — teardown the preflip worktree (`~/projects/Peerloop-preflip` @608346a2 on :4331). Machine-local.
- [ ] [REVIEW-COUNT-SRC] #23 — verify/fix the review-count source (thin).
- [ ] [SESSHIST] #24 — re-wire `SessionHistory.tsx` into `/teaching` OR delete (+ its ~45-case test + barrel line); 0-importer orphan.
- [ ] [SWEEP-FULLTEST] #26 (NEW) — process reminder: run the FULL suite once after broad class-conformance sweeps (className-asserting tests in other files break silently; Conv 337 caught 5 red for ~4 convs). Low priority.

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-PUBLIC] · #8 [LAYOUT-SG] · #9 [MEM-CAP-ARCH] [Opus] · #10 [VITE-DEDUP] · #11 [PROV-STAMP-GAPS] · #12 [HOME-FIXES] · #13 [COURSES-FIXES] · #14 [E2E-MIG] · #15 [E2E-GATE] · #16 [ICN-NS] · #17 [TZ-AUDIT] [Opus] · #18 [DOCGEN-SPEC] · #19 [V217-WATCH] · #20 [M4-ZGUARD] · #21 [OLD-PORTED-CLEANUP] · #22 [PREFLIP-WT] · #23 [REVIEW-COUNT-SRC] · #24 [SESSHIST] · #26 [SWEEP-FULLTEST]

## Key Context

- **Test baseline is GREEN again (6737/6737).** It had been red (5 stale admin tests) since the RG-ADMIN sweep (Convs 332–336) — the Conv-336 "all gates green" claim was inaccurate. Fixed this conv. When the next colour/type sweep changes many components' classes, run the FULL suite once ([SWEEP-FULLTEST] #26) — className-asserting tests in OTHER files break silently.
- **SPACING conformance pattern (reusable):** value-mapped perl transform (`scratchpad/spacing-sweep.pl` was the one-off) — on-scale {4,8,12,16,20,24,32,40,48,64} `[Npx]`→`-N` (pixel-identical via bridge), off-scale snap nearest ties-up (6→8/10→12/28→32), KEEP sub-4px optical + comment-only `[Npx]` + positioning offsets matched to a real element (AppLayout `pt-[88px]`/`pb-[96px]`, AdminLayout `lg:ml-[220px]`). Grep gotcha: `grep -h` strips paths → a downstream `grep -v '/old/'` is INERT; filter paths BEFORE value-extraction.
- **PALETTE-FDN #29 closed-because-stale:** profile-tab status banners were already conformed to warning/success tokens (ledger note was stale). The broader app-wide status-colour gap (~105 legacy amber/yellow/emerald sites) is route-entangled + mostly intentional keeps (Leaderboard medals, stars) → rides the route sweeps, NOT a discrete task.
- **`git stash` proves pre-existence:** stash the working change, run the failing tests on the clean tree; identical failures = not yours.
- **MEMORY.md at 84% of the 25 KB SessionStart cap** — [MEM-CAP-ARCH] #9 [Opus], architectural fix; do NOT re-prune.
- **Commits this conv:** code `1edfac46`/`d9ded988`/`838da44d` + docs `5823442` (via foreground commits), plus the start heartbeat `ab97caa`, `5c70ac1` (RESUME-STATE removal), and the end-of-conv bookkeeping commit pair (this file + Extract/Learnings/Decisions + PLAN/README updates).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

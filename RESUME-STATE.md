# State — Conv 393 (2026-07-13 ~11:16)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 393 closed out `[ORPHAN-BACKLOG]` Category C and the stray dead-`.ts` sweep. Reviewed the 4 "needs-a-look" orphans: **deleted 3** dead (`error/ErrorPage` — superseded by the live `404.astro`; `leaderboard/Leaderboard` + its orphaned `api/leaderboard.ts`; `context-actions/*` never-mounted FAB) and **wired 1** — `invite/ModeratorInvite` turned out to be a LIVE bug, not debris: the admin invite flow emails `/invite/mod/{token}` (RESEND live on staging) but no page existed there, so the link 404'd. Built `src/pages/invite/mod/[token].astro` to fix it (verified live: 200, was 404). Then swept **12 stray dead `.ts`** under `src/components/**` (dead utils/types + dead live-dir barrels), leaving 9 parked-Cat-B barrels and keeping `icon-provenance.ts` (prov:sweep source-of-truth). Component detector 57→53. All 5 gates green throughout (final suite 6534).

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. `[ORPHAN-BACKLOG]` now has only **Category B (52, parked behind `[RG-PUBLIC]`)** + the detector-`/w-codecheck`-wiring open item (gated behind B) remaining. New this conv: `[DEVSRV-KILL]` (low-priority tooling-hygiene backlog item).
- **Dead-code deletion-safety rule (this conv's key learning):** "safe to delete" = **zero importers of ANY kind** (route-reachable + parked-but-type-checked orphan + test), verified by `tsc` — NOT "zero route-reachable importers." A parked Category-B orphan is still type-checked and will dangle `tsc` if you delete something it imports. The `.tsx` orphan detector only reports components; a `.ts` variant is safe ONLY scoped to `src/components/**` (routing-reachability is authoritative there; `src/lib/**` has worker/middleware/config entry points that false-positive).
- **A validated `.ts`-detector approach** exists (reuse the component detector's pages-rooted reachability, scope to `src/components/**`, add an all-importers safety classifier) — productionize it alongside the component-detector `/w-codecheck` wiring when Category B resolves.
- **`icon-provenance.ts` is NOT dead** — it's read-as-a-file by `scripts/prov-sweep.ts` (`npm run prov:sweep`); an import-graph detector flags it but it must be kept (the `.ts` equivalent of a `KNOWN_ORPHANS` allowlist entry).
- **Doc cleanup done this conv:** removed all live references to the deleted leaderboard endpoint/component + the `@components/error/ErrorPage` example across API/test/route docs (7 driftCheck via the docs agent + 3 manual/stale-ref inline fixes: url-routing phantom route, DEVELOPMENT-GUIDE ErrorPage example, DB-API Leaderboard section).
- **Both repos have this conv's commits pushed** (code + docs; end-of-conv commit made in Step 6).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

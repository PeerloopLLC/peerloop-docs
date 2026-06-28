# State — Conv 344 (2026-06-28 ~07:57)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread conv that **built [PLATO-GAP]** (#14, the 3 backend-ready UI gaps surfaced by the Conv-343 PLATO port-audit) — **Gaps A + B + c1** shipped, **c2 deferred**. Gap A (Follow): new `GET /api/users/[handle]/follow` status endpoint + new `UserFollowButton`, wired on `/@handle` (via a new generic `extraActions` slot on the shared `UserCard`) and `/creator/[handle]` (dead placeholder replaced). Gap B (creator self-certify): "Teach this course yourself" banner + "Self-Certify" button in the CourseEditor Teachers tab, reusing `handleCertify` against the existing `isCreatorSelfCert` branch. Gap C/c1 (per-module homework): "Add to a module:" chip row in HomeworkEditor that opens the New Assignment form module-preset. Gap C/c2 (submission file upload) turned out bigger than estimated (schema col + authed download route + access policy) → carved to new task **#15 [PLATO-GAP-C2] [Opus]**. PLATO `// GAP` prose re-synced for built gaps; c2 marker retargeted. **All 5 baseline gates GREEN** (tsc 0 / astro 0 / lint 0 / test 6697/6697 / build ✓) + bug-class gates; **DOM-verified** all 3 surfaces on :4321 (Follow round-trip, self-cert banner, 7 per-module chips). Committed + pushed (code `e64aef53`, docs `a6521db`).

## Completed

- [x] [PLATO-GAP] #14 — built Gaps A (Follow) + B (self-certify) + C/c1 (per-module homework add); PLATO prose re-synced; baseline GREEN; DOM-verified; committed + pushed. c2 carved to #15. Block detail in PLAN.md under PLATO-REVIVE close-out (Conv 344 block).

## Remaining

- [ ] [RG-PUBLIC] #1 — public/marketing route group sweep (parked until marketing redesign; `/old` keep-set, 404 at root by design)
- [ ] [LAYOUT-SG] #2 — `/course/[slug]` hero inset-vs-full-bleed design call
- [ ] [MEM-CAP-ARCH] #3 [Opus] — MEMORY.md at ~87% of the 25 KB SessionStart cap (confirmed this conv); architectural fix; do NOT re-run /r-prune-memory
- [ ] [VITE-DEDUP] #4 — durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash (workaround `rm -rf node_modules/.vite`)
- [ ] [HOME-FIXES] #5 · [COURSES-FIXES] #6 — deferred per-route fix buckets
- [ ] [E2E-MIG] #7 — migrate E2E (Playwright) tests post-flip
- [ ] [E2E-GATE] #8 — restore the E2E gate + gate the PLATO instanceFile path (activities/ecosystem/member-directory pass as instanceFiles when run manually but aren't static `Instance:` blocks in `npm test`, so file-level `verify` drift can still hide)
- [ ] [ICN-NS] #9 — icon-namespace cleanup across the two icon systems + MattIcon registry
- [ ] [TZ-AUDIT] #10 [Opus] — timezone-correctness audit
- [ ] [DOCGEN-SPEC] #11 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md
- [ ] [V217-WATCH] #12 — watch the [TERM-GARBLE] upstream CC bug
- [ ] [PREFLIP-WT] #13 — teardown the preflip worktree (consequential + machine-local; on user say-so). **NOTE:** it is the legacy source-of-truth for PLATO port-audits — keep it until [PLATO-GAP-C2] #15 (which may need legacy comparison) is done
- [ ] [PLATO-GAP-C2] #15 [Opus] — homework submission **file upload** (deferred half of Gap C). Bigger than est: `homework_submissions` stores only `file_url` (no `r2_key`); R2 files served via id-based authed download routes (submissions are private). Needs: schema `r2_key` col + NEW authed submission-file download route + access policy (student owner + creator/assigned teacher) + multipart branch on `POST /api/homework/[id]/submit` (model on resources `index.ts`) + file-input UI in `HomeworkTab.tsx` SubmissionForm (match its LEGACY token style, not Matt). PLATO marker `activities.instance.ts:199` stays live until shipped.

## TodoWrite Items

- [ ] #1 [RG-PUBLIC] · #2 [LAYOUT-SG] · #3 [MEM-CAP-ARCH] [Opus] · #4 [VITE-DEDUP] · #5 [HOME-FIXES] · #6 [COURSES-FIXES] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [PREFLIP-WT] · #15 [PLATO-GAP-C2] [Opus]

## Key Context

- **[PLATO-GAP] built Conv 344** — SoT PLAN.md § PLATO-REVIVE close-out (Conv 344 detail block). Files: `src/pages/api/users/[handle]/follow.ts` (new GET), `src/components/users/UserFollowButton.tsx` (new), `UserCard.tsx` (extraActions slot), `PublicProfile.tsx`, `CreatorProfileHeader.tsx`, `CourseEditor.tsx` (TeachersTab self-cert banner), `HomeworkEditor.tsx` (per-module chips), `users/index.ts`. PLATO prose: `activities.instance.ts` + `ecosystem.instance.ts`.
- **Memory saved this conv:** none new (the conv's learnings/decisions live in the session Extract/Learnings/Decisions, none met the durable-chunk bar).
- **Baseline GREEN this conv** — full `npm test` run: 6697/6697 (400 files); tsc 0, astro 0, lint 0, tailwind 0, build ✓; bug-class gates (datetime/locals.runtime/figma-asset/deleted_at/error-render) clean.
- **Docs maintained:** `docs/reference/API-USERS.md` gained a `GET /api/users/[handle]/follow` section (docs agent). PLATO-REVIVE Block Sequence status cell (PLAN.md line 75) corrected to reflect the A+B+c1 ship.
- **[PLATO-GAP-C2] #15 detail** — see Remaining above; it is now [Opus]-tagged (architectural: schema column + new authed route + access policy).
- Commits: feature work code `e64aef53`, docs `a6521db` (via /r-commit, pushed) + this end-of-conv bookkeeping commit pair (Step 6).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

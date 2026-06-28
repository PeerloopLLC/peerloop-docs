# State — Conv 345 (2026-06-28 ~09:31)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread conv that **built [PLATO-GAP-C2]** (the deferred file-upload half of PLATO Gap C, the last backend-ready gap from the Conv-343/344 PLATO port-audit). Shipped end-to-end: schema columns (`r2_key`/`file_name`/`mime_type`/`file_size` on `homework_submissions`), `@lib/r2` helpers (`generateSubmissionKey` + `getSubmissionDownloadUrl`), a `multipart/form-data` upload branch on `POST /api/homework/[id]/submit` (R2 upload + orphan-cleanup on resubmit), a NEW authed `GET /api/homework/submissions/[id]/download` route (owner/creator/teacher/admin policy), `file_name`+`download_url` in both read endpoints, and the student-side UI (file input + download link in `HomeworkTab`). **DOM-verified live on :4321** — the round-trip (upload→R2→download byte-exact) and the full access matrix (401/403/200) — which **caught and fixed a real cache-leak** (`private, max-age=3600` → `private, no-store` on the per-user-private download). All 5 baseline gates GREEN (tsc 0 / astro 0 / lint 0 / test **6714/6714** / build ✓) + bug-class gates; +17 tests. PLATO GAP marker re-synced; `API-HOMEWORK.md` + `TEST-COVERAGE.md` updated. Committed + pushed (code `8aaaafaf`, docs `78455b7`).

## Completed

- [x] [PLATO-GAP-C2] #14 — homework submission file upload built end-to-end, DOM-verified live (incl. found+fixed `no-store` cache hardening), 5 gates GREEN, committed + pushed. Block detail in PLAN.md PLATO-REVIVE close-out (Conv 345).

## Remaining

- [ ] [RG-PUBLIC] #1 — public/marketing route group sweep (parked until marketing redesign; `/old` keep-set, 404 at root by design)
- [ ] [LAYOUT-SG] #2 — `/course/[slug]` hero inset-vs-full-bleed design call
- [ ] [MEM-CAP-ARCH] #3 [Opus] — MEMORY.md at ~87% of the 25 KB SessionStart cap (re-confirmed Conv 345); architectural fix; do NOT re-run /r-prune-memory
- [ ] [VITE-DEDUP] #4 — durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash (workaround `rm -rf node_modules/.vite`)
- [ ] [HOME-FIXES] #5 · [COURSES-FIXES] #6 — deferred per-route fix buckets
- [ ] [E2E-MIG] #7 — migrate E2E (Playwright) tests post-flip
- [ ] [E2E-GATE] #8 — restore the E2E gate + gate the PLATO instanceFile path (activities/ecosystem/member-directory pass as instanceFiles manually but aren't static `Instance:` blocks in `npm test`)
- [ ] [ICN-NS] #9 — icon-namespace cleanup across the two icon systems + MattIcon registry
- [ ] [TZ-AUDIT] #10 [Opus] — timezone-correctness audit
- [ ] [DOCGEN-SPEC] #11 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md
- [ ] [V217-WATCH] #12 — watch the [TERM-GARBLE] upstream CC bug
- [ ] [PREFLIP-WT] #13 — teardown the preflip worktree (consequential + machine-local; on user say-so). **NOTE:** it is the legacy source-of-truth for PLATO port-audits; PLATO-GAP-C2 is now done, so the keep-until-#15 reason has cleared — re-evaluate when convenient
- [ ] [HW-GRADE-UI] #15 — teacher/creator homework **grading UI**: no React surface consumes the reviewer endpoints (`GET …/submissions` list + `PATCH …/submissions/[subId]` grade). The list endpoint now returns `download_url` (Conv 345), so this UI can surface the authed submission-file download + let teachers grade. The unsurfaced reviewer half of the file-upload feature.
- [ ] [SYNCGAP-FIX] #16 — fix `.claude/scripts/sync-gaps.sh` shared-basename `case` guard: `case "$bn" in $SHARED_BASENAMES_PATTERN)` doesn't treat the expanded `|`s as alternation (bash parses `case` alternation pre-expansion), so NO shared basename matches → false-negatives (missed the Conv-345 `download.test.ts` gap). Fix via per-token loop or `[[ =~ ]]`; verify against the Conv-345 case.

## TodoWrite Items

- [ ] #1 [RG-PUBLIC] · #2 [LAYOUT-SG] · #3 [MEM-CAP-ARCH] [Opus] · #4 [VITE-DEDUP] · #5 [HOME-FIXES] · #6 [COURSES-FIXES] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [PREFLIP-WT] · #15 [HW-GRADE-UI] · #16 [SYNCGAP-FIX]

## Key Context

- **[PLATO-GAP-C2] built Conv 345** — SoT PLAN.md § PLATO-REVIVE close-out (Conv 345 block). Files: `migrations/0001_schema.sql` (+4 cols), `src/lib/db/types.ts`, `src/lib/r2.ts` (generateSubmissionKey/getSubmissionDownloadUrl), `src/pages/api/homework/[id]/submit.ts` (multipart branch), `src/pages/api/homework/submissions/[id]/download.ts` (NEW), `…/submissions/me.ts` + `…/submissions/index.ts` (file metadata), `src/components/learning/HomeworkTab.tsx`. PLATO: `activities.instance.ts`. Docs: `API-HOMEWORK.md`, `TEST-COVERAGE.md`. Commits (already pushed): code `8aaaafaf`, docs `78455b7`.
- **Cache-leak fix (durable):** submission download uses `Cache-Control: private, no-store` (NOT `max-age`) — submissions are per-user private; resources stay `max-age=3600` (enrollment-gated, less sensitive). Decision routed to `docs/decisions/04-auth.md`.
- **Schema-add decision** routed to `docs/decisions/02-database.md` (add 4 cols vs repurpose file_url).
- **Dev-DB drift gotcha:** the local D1 needed an `ALTER TABLE … ADD COLUMN` to verify the schema change live (`CREATE TABLE IF NOT EXISTS` doesn't alter a materialized DB). Production/staging apply fresh. See Learnings.
- **Reviewer UI gap (#15):** the homework reviewer endpoints have NO React consumer; only `HomeworkTab` (student view) exists. The list endpoint now carries `download_url` for when a grading UI is built.
- **Baseline GREEN this conv** — `npm test` 6714/6714 (401 files); tsc 0, astro 0, lint 0, tailwind 0, build ✓; bug-class gates clean. (After the green run, only a 1-line `no-store` change landed, re-confirmed by the affected download test — 28 green.)
- **Memory saved this conv:** none new.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

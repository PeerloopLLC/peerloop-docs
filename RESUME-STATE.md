# State — Conv 346 (2026-06-28 ~10:41)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread conv that **built `[HW-GRADE-UI]`** (teacher-first) — the unsurfaced reviewer half of the homework feature from the PLATO port-audit. Shipped end-to-end: a NEW grading-side assignment-list endpoint `GET /api/teaching/courses/[courseId]/homework` (filling a real backend gap — the only course-assignment list was enrollment-gated to students, unreachable by teachers), a self-contained `HomeworkGradingPanel.tsx`, and a "Homework" tab in `TeacherCourseView` (assignment list → submissions → inline grade form). **DOM-verified the full grade round-trip live on `:4321`** (persisted to D1, seed reverted), all 5 baseline gates GREEN (test 6723/6723, build ✓), +9 tests. Committed + pushed (code `46d32f33`, docs `b7fa740`). At r-end, also resolved `[HW-DOC-PLACE]` (moved the endpoint doc to API-SESSIONS.md to match the `teaching/*` convention + kill a recurring sync-gaps false positive). Creator-side parity deferred → `[HW-GRADE-CREATOR]` #16.

## Completed

- [x] [HW-GRADE-UI] #14 — teacher homework grading UI built end-to-end, DOM-verified live, 5 gates GREEN, committed + pushed. Detail in PLAN.md § PLATO-REVIVE (Conv 346 block).
- [x] [HW-DOC-PLACE] #17 — moved `GET /api/teaching/courses/[courseId]/homework` docs from API-HOMEWORK.md → API-SESSIONS.md (matches teaching/* route-mapping + siblings; cross-ref left in API-HOMEWORK.md); sync-gaps false positive cleared. (Resolved at r-end this conv.)

## Remaining

- [ ] [RG-PUBLIC] #1 — public/marketing route group sweep (parked until marketing redesign; `/old` keep-set, 404 at root by design)
- [ ] [LAYOUT-SG] #2 — `/course/[slug]` hero inset-vs-full-bleed design call
- [ ] [MEM-CAP-ARCH] #3 [Opus] — MEMORY.md at ~87% of the 25 KB SessionStart cap (re-confirmed Conv 346); architectural fix; do NOT re-run /r-prune-memory
- [ ] [VITE-DEDUP] #4 — durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash (workaround `rm -rf node_modules/.vite`)
- [ ] [HOME-FIXES] #5 · [COURSES-FIXES] #6 — deferred per-route fix buckets
- [ ] [E2E-MIG] #7 — migrate E2E (Playwright) tests post-flip
- [ ] [E2E-GATE] #8 — restore the E2E gate + gate the PLATO instanceFile path
- [ ] [ICN-NS] #9 — icon-namespace cleanup across the two icon systems + MattIcon registry
- [ ] [TZ-AUDIT] #10 [Opus] — timezone-correctness audit
- [ ] [DOCGEN-SPEC] #11 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md
- [ ] [V217-WATCH] #12 — watch the [TERM-GARBLE] upstream CC bug
- [ ] [PREFLIP-WT] #13 — teardown the preflip worktree (consequential + machine-local; on user say-so). PLATO port-audits done, so the keep-until reason has cleared — re-evaluate when convenient
- [ ] [SYNCGAP-FIX] #15 — fix `.claude/scripts/sync-gaps.sh` shared-basename `case` guard (alternation parsed pre-expansion → no shared basename matches → false-negatives; missed the Conv-345 download.test.ts gap). Fix via per-token loop or `[[ =~ ]]`; verify against the Conv-345 case. **User deferred to next conv (Conv 346).**
- [ ] [HW-GRADE-CREATOR] #16 — creator-side homework grading parity: thin mount of `HomeworkGradingPanel` onto a creator per-course surface. Reviewer endpoints + the new assignment-list endpoint already permit creator auth, but `TeacherCourseView` is teacher-only and no per-course creator view exists yet — needs a new creator surface (not a rebuild). SoT: PLAN.md § PLATO-REVIVE Conv 346 block.

## TodoWrite Items

- [ ] #1 [RG-PUBLIC] · #2 [LAYOUT-SG] · #3 [MEM-CAP-ARCH] [Opus] · #4 [VITE-DEDUP] · #5 [HOME-FIXES] · #6 [COURSES-FIXES] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [PREFLIP-WT] · #15 [SYNCGAP-FIX] · #16 [HW-GRADE-CREATOR]

## Key Context

- **[HW-GRADE-UI] built Conv 346** — SoT PLAN.md § PLATO-REVIVE (Conv 346 block). Files: `src/pages/api/teaching/courses/[courseId]/homework.ts` (NEW endpoint), `src/components/teachers/workspace/HomeworkGradingPanel.tsx` (NEW), `src/components/teachers/workspace/TeacherCourseView.tsx` (Homework tab), `tests/api/teaching/courses/[courseId]/homework.test.ts` (9 cases). Docs: API-SESSIONS.md (endpoint), API-HOMEWORK.md (cross-ref), TEST-COVERAGE.md. Commits (pushed): code `46d32f33`, docs `b7fa740` + this r-end commit.
- **Auth predicate decision** (routed to `docs/decisions/04-auth.md`): an enumeration/list endpoint must use the SAME auth predicate as the action it feeds — the new endpoint copies the reviewer predicate (creator OR active certified teacher), NOT the lighter `resources.ts` teacher-cert-only predicate.
- **Backend gap learning:** "backend-ready, UI-only" carry-over claims must be verified per-actor incl. the enumeration path (list → detail → action), not just the action endpoints. The reviewer endpoints existed but no teacher-reachable assignment-list did.
- **Chrome-bridge gotcha (NOT yet saved to memory):** coordinate-based `computer left_click` no-op'd on hydrated islands during :4321 verification; native `element.click()` via `javascript_tool` worked (bubbles to React's delegated listener). Candidate to append to `[BRIDGE-MEM]` memory next conv. (Offered to user this conv; not actioned.)
- **`homework_submissions` UNIQUE(assignment_id, student_id)** — one submission per student per assignment; multi-submission tests need distinct students.
- **Baseline GREEN this conv** — `npm test` 6723/6723 (402 files); tsc 0, astro 0, lint 0, tailwind 0, build ✓; bug-class gates clean.
- **Memory saved this conv:** none new (MEMORY.md still at ~87% cap — see #3).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

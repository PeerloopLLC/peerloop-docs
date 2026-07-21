# State — Conv 400 (2026-07-20 ~19:59)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 400 continued the lint/tooling-hygiene arc (Convs 397 RDOC → 398 KNIP → 399 A11Y → **400 RHOOKS**). Adopted `[RHOOKS]` — the full `eslint-plugin-react-hooks@7.1.1` `recommended-latest` set (17 rules) at **warn** in `eslint.config.js` (no new dep, no `overrides` pin; react-hooks already ships the eslint ^10 peer) — then ran a **full triage** of the 105 findings: Batch 1 (6 `static-components` hoists + 4 `immutability` loader-reorders), migrated `useCurrentUser`/`useAuthStatus` to `useSyncExternalStore`, accepted `set-state-in-effect` as a permanent baseline, and converted `TestimonialsBrowse`'s `FilterContent` to a plain element value. **react-hooks 105 → 95; `static-components` + `immutability` fully cleared.** RHOOKS adoption committed mid-conv (code `9ac1a205`, docs `b608c47`); the triage committed at this r-end.

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. `[RHOOKS]` is now an Active/triage row: the linter is adopted + the actionable correctness findings are all fixed; the **remaining 95 warnings are opportunistic-only** (93 `set-state-in-effect` accepted baseline + 1 `purity` + 1 `preserve-manual-memoization`, all leave-at-warn). No standalone RHOOKS sweep is planned.

- **The load-bearing decision: `set-state-in-effect` is an accepted baseline, NOT a to-do list.** ~90 of 95 are correct-for-architecture — idiomatic fetch-on-mount (~49) or deliberate SSR-hydration-safety (~25 client-only reads deferred to an effect; `current-user.ts`/`ThemeToggle` carry explicit "match SSR output" comments). Rewriting them reintroduces SSR/hydration bugs. Kept at warn like `exhaustive-deps`/`[LE-TRIAGE]`; chase only new/egregious cases. Full rationale → `docs/decisions/06-testing-ci.md` § "set-state-in-effect Is an Accepted Baseline".

- **New reusable pattern: `useSyncExternalStore` for client-store hydration hooks** (`src/lib/current-user.ts` is the reference). It fit because the store already had the subscribe fns, a referentially-stable `getSnapshot` (the `setCurrentUser` id+dataVersion dedup guard), and a `getServerSnapshot` (`null`/`'loading'`) matching the prior SSR init. Verify getSnapshot stability BEFORE using it elsewhere — an unstable snapshot infinite-loops.

- **🆕 `origin/brian-July-20` appeared this conv** — a client branch 13 days newer than the `brian-July-7` that `[MERGE-BRIAN-JULY7]` (on hold) assessed. Noted in that task's row: the assessment target has moved; re-scope against `brian-July-20` when it un-holds.

- **Baseline this conv:** lint 0 errors / 195 warnings (95 react-hooks + 100 a11y), tsc 0, astro-check 0 (all re-verified). Full `npm test`/`npm run build` NOT run this conv — the changes are component/lint refactors; 204 targeted tests across the current-user + consumer + TestimonialsBrowse suites pass. `/w-codecheck` for a full-suite confirmation is available if wanted before the next commit.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

# State — Conv 399 (2026-07-20 ~12:45)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 399 executed `[A11Y]` — adopted a permanent accessibility linter. After the user asked me to research the ESLint-10 situation first, the choice landed on **upstream `eslint-plugin-jsx-a11y@6.10.2` + a self-healing package.json `overrides` peer pin** (not the es-tooling fork, which silently drops `.astro` coverage; not Oxlint). Wired at `warn` for `.tsx` (recommended, 100 findings) + `.astro` (0 findings, free via eslint-plugin-astro). All 5 baseline gates green. Committed mid-conv via /r-commit (code `f561cdae`, docs `c26c6b5`), then closed via /r-end.

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. New/changed this conv: `[A11Y]` wiring ✅ done (now the **triage backlog** — 100 `.tsx` warnings to fix incrementally like `[LE-TRIAGE]`); `[DEPEXP]` added (low-priority dep-experiment hygiene note). The three `🔥 Ordered` items stayed gated the whole conv (`[MERGE-BRIAN-JULY7]` hold, `[ORPHAN-BACKLOG]` Cat-B parked, `[PLATO-SEQ]` post-launch) — unchanged going into Conv 400.

- **The load-bearing outcome: a11y linting now exists, at `warn`, and it's self-healing.** `eslint-plugin-jsx-a11y@6.10.2` peer-caps at eslint ^9 but runs fine on our eslint 10; the package.json `overrides` (`{ "eslint-plugin-jsx-a11y": { "eslint": "$eslint" } }`) keeps `npm install`/`npm ci` clean with no flag and **deletes itself** the day upstream ships eslint ^10 (PRs #1079/#1081, stalled ~5mo). This mirrors the `react-hooks@7.1.1` posture we already run.

- **⚠️ The es-tooling fork `eslint-plugin-jsx-a11y-x` is NOT a drop-in — it silently drops `.astro` coverage.** Empirically (npm-alias test) it resolves **0 rules** through eslint-plugin-astro (astro hard-codes upstream's shape + export API), plus it's a young 0.x with an ESM-redesigned config API. If the override ever needs replacing, do NOT reach for the fork without re-checking astro integration.

- **Config gotcha worth remembering:** eslint-plugin-astro's `flat/jsx-a11y-recommended` registers the `jsx-a11y` plugin in an **unscoped** config object, which collides with a `.tsx` jsx-a11y block under ESLint 10 ("Cannot redefine plugin"). Fix (in `eslint.config.js`): `.map()` that one object to `files: ['**/*.astro']`. The `asWarn` helper downgrades a whole rule-set to warn while preserving each rule's options and off-state.

- **`.astro` a11y coverage is not load-bearing now** — our 90 `.astro` files have 0 findings (structural shells; interactive UI is `.tsx`), and Astro's dev-toolbar Audit runtime-checks them. It's wired anyway (free) for future-proofing.

- **Baseline verified GREEN this conv (all 5):** lint (100 warnings / 0 errors), tsc 0, astro-check 0, build 0, test 0 (6540 tests, 214s).

- **npm-state gotcha (see `[DEPEXP]`):** throwaway in-place `npm install` probes polluted resolution and later broke `npm ci` on `@emnapi` optional pins despite a byte-identical committed lockfile. Reconcile via `npm install` + `git restore package-lock.json`, or use a throwaway worktree for dep experiments.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

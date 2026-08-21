# State — Conv 439 (2026-08-20 ~16:51)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Rebuilt `/w-codecheck` around a **two-level safety model** — commit-safety (`npm run codecheck`, fast static, no test/build) vs deploy-safety (`npm run verify` = `codecheck && test && build`, −E2E/PLATO) — and turned `codecheck` into a **reporter** (`scripts/codecheck.mjs`) that runs every static check without short-circuiting and groups findings into 🔴 build-blockers / ⚠️ local quality gates / ℹ️ warnings. Also script-ified the 5 grep gates into the code repo, authored a fresh-machine onboarding doc, cleared small debt, and closed `[GATEPAR]` + `[TZLINT]`.

## Key Context

- **codecheck is a reporter, not a fail-fast gate.** `scripts/codecheck.mjs` runs all checks, categorizes by **build-blocker** (CI gates from `.github/workflows/ci.yml`: lint-errors·typecheck·astro·`lint:tz`·test·build), **local quality gate** (tailwind/icons/tokens/datetime/error-render/env/figma/deleted_at — not in CI), and **warning**. Exit non-zero iff a build-blocker or local gate fails; ESLint warnings alone don't fail it.
- **`npm run verify` is now a true superset** of commit-safety (= `codecheck && test && build`) and remains the authoritative baseline command (CLAUDE.md §Baseline + CLAUDE-OFFLOAD corrected this conv).
- **▶ Conv-440 TOP PRIORITY (option C):** clear the **163 ESLint warnings** = **88 react-hooks (`[RHOOKS]`, already `[Opus]`)** + **75 jsx-a11y (`[A11Y]`)**. Non-blocking (CI's lint passes on warnings). **react-hooks are behavior-sensitive — go carefully, NOT bulk.**
- **How to run codecheck:** `/w-codecheck` (unchanged — now drives the reporter + offers fix-on-demand), or `npm run codecheck` directly from `../Peerloop`.
- **Gate scripts** now live in `../Peerloop/scripts/` (`codecheck.mjs`, `check-datetime.sh`, `check-error-render.sh`, `check-env-access.sh`, `check-figma-assets.sh`, `codecheck-deleted-at.mjs` — moved from the docs repo).
- **Gotchas banked this conv:** `eslint src/` exits 0 on warnings; `spawnSync` maxBuffer=1 MB truncates `eslint -f json` (embeds source) → 64 MB, and parse **stdout only** (stderr corrupts the JSON); `check-tailwind-v4.sh` `[--x]` value-ref vs `[--x:val]` property-assignment (colon distinguishes); `size-16`→`size-icon-16` for the icon axis.
- New reference docs (both `manual`): `docs/reference/CODECHECK.md`, `docs/reference/NEW-MACHINE-SETUP.md`.
- A stray `aaa` file (env-template copy) was deleted from the code repo this conv.
- For the task backlog, see `CURRENT-TASKS.md` (git-tracked).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence (Conv-440 priority = `[RHOOKS]` + `[A11Y]`) and this narrative for context.

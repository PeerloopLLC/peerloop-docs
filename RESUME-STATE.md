# State — Conv 402 (2026-07-21 ~11:40)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 402 promoted the de-risked **Astro 6.3.7 → 7.1.3** migration onto `jfg-dev-14` (adapter `@astrojs/cloudflare` 13→14, `@astrojs/react` 5→6, **vite 7→8**, plus test-tooling minors) with a single config change (`compressHTML: true` pin). It's validated green at every level: 5 gates (6540 tests), live dev SSR smoke, a `dev:staging` remoteBindings smoke against staging D1, **and** a member-directory PLATO browser-run in real Chromium — all clean. Also **finished `[NPMVULN]`** (the 7 remaining advisories are all dev-only; audit-0 isn't cleanly reachable, so accepted as documented residual) and **scoped `[AAP]`** (dev-only, production-clean, still leaking on v7).

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. `[ASTRO7]` + `[NPMVULN]` are in ✅ Completed-this-conv; new `[MMB]` (triage the member-card "Monitoring" role badge — NOT migration-related) is in the Unordered backlog.

- **Task MCP tools (TaskCreate/List/Update/Get) were down the ENTIRE conv** ("No matching deferred tools found"). All task state was driven by hand-editing `CURRENT-TASKS.md` (the durable store). If still down next conv, keep driving task state from `CURRENT-TASKS.md` directly — the MCP tools are only the active-in-flight layer.

- **The Astro 7 stack is on `jfg-dev-14` only.** The 4 conv commits (code `91a0e8a6`; docs `15b5fa6`/`7bb37ff`/`02f1511`) + this r-end commit are pushed to `origin/jfg-dev-14`. Whether/when to merge `jfg-dev-14` elsewhere is an open user decision (out of scope this conv). `[MERGE-BRIAN-JULY7]` remains ON HOLD.

- **`[NPMVULN]` deferred lever:** a coordinated `wrangler@4.112 + @cloudflare/workers-types@^5` bump clears the wrangler audit chain (the clean in-range wrangler bump ERESOLVE-failed on the workers-types v5 peer-major); jsdom/eslint/astro bumps clear the rest. Bundle into a future CF-types/dep-upgrade conv.

- **`[AAP]` stays OPEN/WATCH:** root cause on v7 = `node_modules/astro/dist/vite-plugin-astro/compile.js:22` (absolute `compileProps.filename`); dev-only, production client bundle verified clean. Re-probe after future astro upgrades (`curl http://localhost:4321/ | grep -oE 'src="[^"]*ClientRouter[^"]*"'`).

- **Astro 7 dev = background daemon** (`npm run dev` returns immediately; stop with `npx astro dev stop`; per-request logs via `astro dev logs`, not launcher stdout). `docs/reference/astrojs.md` version tables updated to the v7 stack.

- **Baseline this conv:** tsc 0, astro-check 0, lint 0-err/195-warn, build clean, 6540 tests pass, npm audit 7 (all dev-only) — verified in-conv on the v7 stack.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

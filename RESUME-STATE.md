# State — Conv 401 (2026-07-21 ~08:51)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 401 did two things. **[NPMVULN]** — triaged the 21 npm-audit advisories and cleared the only **2 production-runtime-reachable** chains (resend→svix→uuid, astro→devalue) via a lockfile-only, in-range `npm update` (resend 6.10.0→6.17.2, devalue 5.7.1→5.8.2); prod-runtime attack surface now **0**, audit 21→17, all 5 gates green (6540 tests). **[ASTRO7]** — assessed Astro 6.3.7→7.1.3 and ran a throwaway-worktree de-risk: the full v7 stack (astro 7.1.3 + adapter 14 + react-int 6 + **vite 8.1.5**) builds, type-checks, and passes all 6540 tests with **zero code changes**; the migration is deferred to its own conv with the promotion steps captured.

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. Both this conv's tasks stay Active: `[NPMVULN]` (prod done; ~17 dev-only advisories deferred — mostly retired by the v7 upgrade) and `[ASTRO7]` (de-risk DONE/green, promotion pending).

- **`[ASTRO7]` is de-risked and ready to promote in its own conv.** Remaining steps: (a) pin `compressHTML: true` in `astro.config.mjs` (v7 flips default `true`→`'jsx'`); (b) live dev + staging SSR smoke (vite-8 `optimizeDeps` / the fragile `[DSSR-SCOPE]` area not build-exercised) + re-probe the `[AAP]` ClientRouter abs-path leak (v7 may fix it — PLAN.md `[AAP]` now cross-references this); (c) apply the bump set to `jfg-dev-14` + 5 gates + commit. Full assessment + exact install cmd + de-risk results in `.scratch/astro7-assessment.md`, also summarized durably in the `[ASTRO7]` CURRENT-TASKS row. The v7 upgrade also subsumes most of the `[NPMVULN]` dev-tail (audit 17→7 on v7).

- **Promotion bump set (measured, no peer conflicts):** astro 7.1.3, @astrojs/cloudflare 14.1.4, @astrojs/react 6.0.1, @tailwindcss/vite 4.3.3, vitest 4.1.10, @vitest/ui 4.1.10, @astrojs/check 0.9.9 (vite 8 arrives transitively). Node OK (v7 floor 22.12; we run 22.19).

- **Environmental note:** the Task MCP tools (TaskCreate/List/Update/Get) disconnected mid-conv; task state was maintained by hand-editing `CURRENT-TASKS.md` (the persistent store). If those tools are still down next conv, keep driving task state from `CURRENT-TASKS.md` directly.

- **Baseline this conv:** tsc 0, astro-check 0, lint 0-err/195-warn, build clean, 6540 tests pass — re-verified in-conv both on the current stack and on the v7 worktree. Code committed `5ead39da`; docs `ac7bf50` / `e17c386` + this r-end commit.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

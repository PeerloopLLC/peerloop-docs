# State — Conv 348 (2026-06-28 ~13:56)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread conv: **deployed the current code to STAGING.** Started from `/r-start` (backlog of 12 carried-forward tasks), then pivoted entirely to a staging deploy of `jfg-dev-14` HEAD (`8cc4ce7e`) — 167 commits / the full Matt redesign + PLATO + homework + promote-pipeline ahead of the prior staging point (Conv 261, `92e1929b`). Prepared (5 gates GREEN, test 6726/6726; wrote `docs/reference/staging-deploy-runbook.md`), added a file-upload homework seed sample (`sub-sarah-n8n`), then executed the full deploy: destructive `db:setup:staging:feeds` → app Worker `6553c1cb` → cron Worker `e5a75e73` → R2 attachment object. Browser-verified the homework file-upload feature end-to-end (creator grading UI renders the `workflow.json` download chip; authed download 200). Staging only — prod cutover remains gated. All committed/pushed at this r-end.

## Completed

- [x] [STG-DEPLOY] — Prepared + DEPLOYED jfg-dev-14 to staging (`peerloop-staging.brian-1dc.workers.dev`); destructive feeds-level DB convergence; app `6553c1cb` + cron `e5a75e73`; homework file-upload seed sample + R2 object; browser-verified end-to-end. SoT: `plan/deployment/README.md` § DEPLOYMENT.STAGING-DEPLOY.
- [x] Wrote `docs/reference/staging-deploy-runbook.md` (linear runbook) + cross-links (cloudflare.md, plan/deployment/README.md).
- [x] Added + validated `sub-sarah-n8n` file-upload homework submission in `migrations-dev/0001_seed_dev.sql`.

## Remaining

- [ ] [RG-PUBLIC] #1 — public/marketing route group sweep (parked until marketing redesign; `/old` keep-set, 404 at root by design)
- [ ] [LAYOUT-SG] #2 — `/course/[slug]` hero inset-vs-full-bleed design call
- [ ] [MEM-CAP-ARCH] #3 [Opus] — MEMORY.md at ~87% of the 25 KB SessionStart cap; architectural fix; do NOT re-run /r-prune-memory
- [ ] [VITE-DEDUP] #4 — durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash (workaround `rm -rf node_modules/.vite`)
- [ ] [HOME-FIXES] #5 · [COURSES-FIXES] #6 — deferred per-route fix buckets
- [ ] [ICN-NS] #7 — icon-namespace cleanup across the two icon systems + MattIcon registry
- [ ] [TZ-AUDIT] #8 [Opus] — timezone-correctness audit
- [ ] [DOCGEN-SPEC] #9 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md
- [ ] [V217-WATCH] #10 — watch the [TERM-GARBLE] upstream CC bug
- [ ] [PREFLIP-WT] #11 — teardown the preflip worktree (consequential + machine-local; on user say-so)
- [ ] [BROWSER-SMOKE-2B] #12 [Opus] — POST-LAUNCH: evaluate an LLM-driven executor that runs PLATO browser-mode walkthroughs headlessly as a periodic smoke-walk. Do NOT resurrect Playwright E2E. SoT: `docs/decisions/06-testing-ci.md`.

## TodoWrite Items

- [ ] #1 [RG-PUBLIC] · #2 [LAYOUT-SG] · #3 [MEM-CAP-ARCH] [Opus] · #4 [VITE-DEDUP] · #5 [HOME-FIXES] · #6 [COURSES-FIXES] · #7 [ICN-NS] · #8 [TZ-AUDIT] [Opus] · #9 [DOCGEN-SPEC] · #10 [V217-WATCH] · #11 [PREFLIP-WT] · #12 [BROWSER-SMOKE-2B] [Opus]

## Key Context

- **Staging is LIVE on jfg-dev-14** (`peerloop-staging.brian-1dc.workers.dev`): app Worker `6553c1cb`, cron `e5a75e73`, D1 reset+reseeded at feeds level, R2 homework attachment object present. This is the first staging deploy past Conv 261. **Prod cutover still gated** (DEPLOYMENT.PROD + DEPLOYMENT.DB-SYNC untouched — NEVER deploy:prod for features). SoT: `plan/deployment/README.md`.
- **Staging deploy procedure:** `docs/reference/staging-deploy-runbook.md` (linear how-to). Key gotcha: pre-launch schema edits land in already-tracked `0001_schema.sql`, so `migrations apply` won't re-apply them → converging staging needs a **destructive `db:setup:staging:feeds`** (wipes staging data; reproducible). `[RS]` orphan-table FK-block risk did NOT recur this conv but is latent.
- **dev-login is BLOCKED on staging** (`/api/auth/dev-login` 404 — guarded on `import.meta.env.DEV`, false in a prod build). The `[BRIDGE-MEM]` dev-login island-verify path is dev/`:4321` only; staging auth-gated UI needs a real password login (CC can't type passwords → user-assisted handoff). Decided NOT to save to memory this conv (user declined at r-end checkpoint) — candidate for next conv.
- **Browser side effects (this machine's Chrome):** Guy Rymberg left logged in on staging; cleared stale `peerloop_was_logged_in`/`peerloop_expired_identity` (Amanda) localStorage that was breaking the login-modal render.
- **MEMORY.md at ~87% of the 25 KB SessionStart cap** — `[MEM-CAP-ARCH]` #3 (architectural fix, NOT /r-prune-memory).
- **Baseline GREEN this conv** — `npm test` 6726/6726 (402 files); tsc 0, astro 0/0/0, eslint 0, tailwind 0, build ✓ 6.8s; 5 bug-class greps PASS.
- **Decisions routed** (Conv 348): destructive staging-DB convergence + dedicated staging-deploy runbook → `docs/decisions/08-deployment-infra.md` + decision-log + INDEX. TIMELINE entry added (first full staging deploy of the Matt redesign).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

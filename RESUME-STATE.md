# State — Conv 365 (2026-07-05 ~13:53)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Two standalone fixes shipped, committed, and pushed — no PLAN block advanced. **VITE-DEDUP:** added `resolve.dedupe: ['react','react-dom']` to `astro.config.mjs` and repaired a cold-start esbuild dependency-scan failure (two `.astro` frontmatter comments with literal `<script>`/`→` tokens) that had been silently defeating the Conv-177 `[DSSR-SCOPE]` optimizeDeps pre-scan on every cold start. **AUTHBUG:** root-caused (via a 3-agent read-only fan-out) and fixed the intermittent "press Sign in, modal closes, but stays in visitor mode" bug across 10 files + 2 regression tests.

## Key Context

- **Backlog:** see `CURRENT-TASKS.md` — VITE-DEDUP + AUTHBUG now in ✅ Completed; remaining active backlog = ICN-NS, TZ-AUDIT[Opus], DOCGEN-SPEC, BRAND-CASE, HOME-FIXES, COURSES-FIXES, PLAN-XTRACT, E2E-DOCS + 4 Parked. No 🔥 Ordered sequence set.
- **AUTHBUG fix is trigger-agnostic:** login success is now authoritative — `refreshCurrentUser()` returns `boolean`, Login/Signup gate modal-close on real auth and reload-fallback from the already-set cookies on failure; all 3 explicit-logout handlers clear client auth state (`clearCurrentUser(true)` / inline `removeItem`); `/api/me/full` is `no-store`; `SmartFeed` refetches on login-success. Decision detail routed to `docs/decisions/04-auth.md` this conv.
- **Commits (all pushed, jfg-dev-14):** `3cefeb59` VITE-DEDUP, `ee1964b5` AUTHBUG. All 5 gates were green this conv (6761 tests) at the AUTHBUG commit; live-verified `/api/me/full` now serves `cache-control: no-store`.
- **Open (low-value):** the exact AUTHBUG *delay trigger* (cache-replay vs cookie-propagation vs Worker cold start) was not runtime-confirmed — the fix doesn't depend on which one fired. DevTools "login-200 → me/full-401" repro would pin it if ever wanted.
- **VITE gotcha for future recall:** if a cold-start `astro dev` log shows `Skipping dependency pre-bundling`, check `.astro` frontmatter comments for literal `<script>`/`<style>` tokens or non-ASCII arrows — the esbuild scanner mis-extracts them (Learnings.md this conv).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

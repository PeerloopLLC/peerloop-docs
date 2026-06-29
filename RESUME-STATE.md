# State — Conv 349 (2026-06-29 ~12:52)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread conv: a **public-profile family architecture sweep** (RG-PUBPROF surfaces), driven by an investigative arc that started from "where are /visitor, /creator, /teacher called?" and ended with four shipped, committed+pushed pieces. (1) **[PROF-MERGE]** folded the standalone `/visitor` into an auth-aware `/profile` (bare `/profile` now public; settings sub-tabs gated via new `PROTECTED_SUBPATHS_ONLY`) + introduced the app's first `noindex` mechanism (BaseHead/AppLayout prop) on account/auth surfaces. (2) **[SPOKE-COMMERCE]** reframed `/creator` + `/teacher` from "deep profile views" to **commercial entry surfaces** (identity=`/@handle` vs commerce=spokes; full storefront deferred to Phase 2 per client scope) + gave the creator page the "View Courses" CTA it lacked. (3) **[HUB-SSR]** server-rendered `/@[handle]` via a new shared `fetchPublicProfileData` loader (endpoint refactored to a thin wrapper), making the most-linked profile indexable. (4) **[PROF-PARITY]** unified container width (`max-w-4xl`) + spoke title/brand-casing metadata. All four are committed + pushed; baseline GREEN (6728/6728, 5 gates) re-run after each.

## Completed

- [x] [PROF-MERGE] /visitor → auth-aware /profile + noindex infra + PROTECTED_SUBPATHS_ONLY middleware. Committed/pushed (code 7a74abd9, docs 17d9c25). DOM-verified on :4321.
- [x] [SPOKE-COMMERCE] /creator + /teacher reframed as commercial entry surfaces; creator "View Courses" CTA + courses-lead reorder; decision recorded. Committed/pushed (code 8afccc60, docs 8acea4b).
- [x] [HUB-SSR] SSR /@[handle] via shared fetchPublicProfileData loader (lib/ssr/loaders/users.ts); endpoint thin-wrapper (contract preserved 17/17). Committed/pushed (code 09aa1c3e). curl-verified raw SSR HTML.
- [x] [PROF-PARITY] hub max-w-3xl→4xl; spoke titles `{name} — Role`; "PeerLoop"→"Peerloop" casing. Committed/pushed (code abba7a1c).
- [x] r-end follow-ups: fixed stale API-USERS.md response example ([API-USERS-DOC]); added 2 decisions to docs/decisions/INDEX.md; docs-agent fixed 4 stale /profile statements in url-routing.md.

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
- [ ] [BROWSER-SMOKE-2B] #12 [Opus] — POST-LAUNCH: evaluate an LLM-driven headless PLATO browser-mode smoke-walk executor; do NOT resurrect Playwright E2E. SoT: `docs/decisions/06-testing-ci.md`
- [ ] [BRAND-CASE] #17 — app-wide "PeerLoop"→"Peerloop" casing cleanup (45 camelCase instances in src/ UI copy vs canonical 168); verify each isn't intentional stylization before bulk replace; skip the wordmark SVG filename

## TodoWrite Items

- [ ] #1 [RG-PUBLIC] · #2 [LAYOUT-SG] · #3 [MEM-CAP-ARCH] [Opus] · #4 [VITE-DEDUP] · #5 [HOME-FIXES] · #6 [COURSES-FIXES] · #7 [ICN-NS] · #8 [TZ-AUDIT] [Opus] · #9 [DOCGEN-SPEC] · #10 [V217-WATCH] · #11 [PREFLIP-WT] · #12 [BROWSER-SMOKE-2B] [Opus] · #17 [BRAND-CASE]

## Key Context

- **Profile family is now coherent + documented** (decision: `docs/decisions/01-architecture.md` "Identity vs Commerce" + "Consolidate /visitor into /profile"; `decision-log.md`; `url-routing.md`): `/@handle` = identity (SSR + **indexable**); `/creator` + `/teacher` = commercial entry surfaces (storefront = **Phase 2**); `/profile` = auth-aware account hub (absorbed `/visitor`, **noindex**); `/admin` + `/mod` = operational consoles (no public profile, by design).
- **New infra patterns this conv:** `noindex?: boolean` prop (BaseHead→AppLayout, the app's first robots control) applied to `/profile`+`/login`+`/signup`+private/not-found profiles; `PROTECTED_SUBPATHS_ONLY = ['/profile']` middleware list (bare path public, sub-paths gated — inverse of PROTECTED_EXACT); shared SSR `fetchPublicProfileData` loader (`src/lib/ssr/loaders/users.ts`) powering BOTH the API endpoint and the SSR hub.
- **Baseline GREEN this conv** — `npm test` 6728/6728 (402 files) run 4×; tsc/astro 0/0/0, eslint clean, build ✓. Endpoint test 17/17 after the api/users refactor.
- **All work committed + pushed on `jfg-dev-14`** (code HEAD `abba7a1c`; docs gets the r-end bookkeeping commit at close). Staging NOT re-deployed this conv; prod cutover still gated.
- **[BRAND-CASE] #17 deferred** — 45 app-wide "PeerLoop" camelCase instances (Sidebar, CourseDetail, HowItWorks, Button, FeedPost…) vs canonical "Peerloop".
- **MEMORY.md still ~87% of the 25 KB cap** ([MEM-CAP-ARCH] #3, architectural fix — NOT /r-prune-memory).
- **Browser side effect:** user left **logged out on the `:4321` dev server** (verifying the logged-out `/profile` required it; identity not captured to auto-restore). Restore via `POST /api/auth/dev-login {email}` if needed.
- **Tooling note:** the Chrome-bridge `javascript_tool` returns empty `{}` for async-IIFE bodies (with `await`); use a **synchronous last-expression read**, and `curl` raw HTML for definitive SSR verification (browser DOM masks SSR-vs-client-fill).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

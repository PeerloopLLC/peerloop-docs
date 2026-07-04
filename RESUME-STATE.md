# State — Conv 363 (2026-07-04 ~16:55)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Login/visitor-UX conv — three threads, all committed to `jfg-dev-14` and deployed to staging (final version `95b5887a`). **[PROF500]** fixed a `/profile` 500 on staging (the `users` table was missing `nav_layout` — schema drift because base `0001_schema.sql` is edited in place and staging was never reset since Conv 356; fixed by a full `db:setup:staging:booking` + `db:seed:feeds:staging` reseed + a `try/catch` guard on the profile account query). **[VBAR]** replaced the undismissable visitor Home `StickySignupBar` with dismissable in-feed `SignupCtaCard`s (interleaved every 4 items) + a persistent **Sign up / Log in** affordance in the Sidebar bottom cluster (desktop + mobile drawer). **[THEME-CS]** marked the `/profile` dark-mode toggle "coming soon". All verified (PROF500 phone-confirmed; VBAR SSR + staging smoke; THEME-CS dev-visual).

## Key Context

- **Backlog:** see `CURRENT-TASKS.md`. One new pending item this conv: **[E2E-DOCS]** — reconcile E2E test counts across TEST-COVERAGE.md + TEST-E2E.md (pre-existing drift the r-end docs agent flagged; low priority). No 🔥 Ordered sequence set.
- **New patterns:** `withSignupCta()` render-time interleave in `SmartFeed` for visitor-only cards + `ephemeral-dismiss` (persists in prod, always-shows in dev/staging BY DESIGN); `comingSoon` prop pattern for parking an incomplete control (disabled + badge, effect no-ops) while keeping the component for revival.
- **Decisions this conv (in `docs/decisions/` 05-ui + 08-deploy):** reseed-over-surgical-ALTER for staging schema drift; VBAR Option A (in-feed cards + chrome sign-up) supersedes the Conv 258/267/270 persistent-bar design; `nav_layout` toggle deliberately left logged-in-only (visitors have no user record + it's SSR-resolved); dark mode parked as a coming-soon logged-in bonus (Matt pages use tokens, not `dark:` — dark mode was dropped in the porting).
- **Gotchas learned:** `node --check` misses browser-global collisions (`const chrome` vs `window.chrome`); the staging seed chain differs from local (`:booking` does NOT seed feeds on staging); `dev-login` is `import.meta.env.DEV`-gated so can't script an authed staging session; python `http.server` serves without charset → mojibake in local test harnesses (not a real bug).
- `jfg-dev-14` carries this conv's commits (f4f541bd, b4b6b93c, f7ecccc7 code; already pushed). The end-of-conv bookkeeping commit lands in Step 6.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

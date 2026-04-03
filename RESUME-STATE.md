# State — Conv 083 (2026-04-03 ~15:14)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 083 fixed two STUMBLE-AUDIT carried-forward issues (dev seed passwords, admin page auth guard), then activated the PLATO `seed-dev` scenario — validated it (first run, all passing), created an instance with snapshot support, built `plato:seed` (local) and `plato:seed:staging` (remote) npm scripts, and produced a comparative analysis of PLATO seed vs SQL seed for staging testers. Decision: PLATO seed is the default for staging.

## Completed

- [x] Dev seed passwords standardized to `Password1` across 19 files (both repos)
- [x] Admin auth guard added to `AdminLayout.astro` — protects all 13 admin pages
- [x] PLATO `seed-dev` scenario validated (53 API steps + 48 SqlTopUp + 44 verifications)
- [x] `seed-dev.instance.ts` created with `snapshot: true`
- [x] `plato:seed` npm script (local D1 restore)
- [x] `plato:seed:staging` npm script + `plato-seed-staging.js` (remote D1 via sqlite3 dump)
- [x] Fixed `plato-restore.js` testNamePattern double-execution bug
- [x] PLATO vs SQL seed comparative analysis for staging testers

## Remaining

### Carried Forward
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)

### Docs Gaps
- [ ] PLATO-GUIDE.md file tree stale — missing instance files added since guide was written
- [ ] migrations.md missing PLATO seed path cross-reference (two parallel seed paths undocumented)

### PLATO Seed Polish
- [ ] PLATO seed Stripe accounts show `pending` — testers may see "Connect Stripe" prompts on creator pages

## TodoWrite Items

- [ ] #1: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #2: Broken route: /course/[slug]/certificate — page doesn't exist
- [ ] #5: PLATO-GUIDE.md file tree is stale — missing instance files added since guide was written
- [ ] #6: migrations.md missing PLATO seed path cross-reference
- [ ] #7: PLATO seed Stripe accounts show pending — testers may see Connect Stripe prompts

## Key Context

- **Password:** All dev/test accounts now use `Password1` everywhere (SQL seeds, mock-data, E2E, PLATO personas)
- **PLATO seed-dev:** 1324KB snapshot, ~146KB SQL dump. Covers 10 users, 6 courses, 14 sessions, full enrichment data. All data API-validated.
- **Two parallel seed paths:** `plato:seed*` (PLATO, UUID IDs) and `db:setup:*` (SQL, hardcoded IDs). Incompatible — SQL overlays (Stripe, booking) can't reference PLATO UUIDs.
- **Staging decision:** PLATO seed chosen for 3 core testers. `plato:seed:staging` script ready but not yet run against staging D1.
- **Admin guard:** In `AdminLayout.astro` — single enforcement point. Uses `getSession()` + `roles.includes('admin')`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

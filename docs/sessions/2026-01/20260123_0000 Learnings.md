# Session 70 Learnings - 2026-01-23

## L1: better-sqlite3 Has No macOS Version Requirement

**Context:** Initially assumed MBA-2017 couldn't run integration tests because it can't run wrangler's local D1 emulation (requires macOS 13.5+).

**Learning:** better-sqlite3 is a pure Node.js native module that compiles on any platform Node supports. The macOS 13.5+ restriction only applies to Cloudflare's workerd runtime, not to better-sqlite3.

**Impact:** ALL tests (including integration tests) now run on BOTH MacMini and MBA-2017. Test coverage is equal across machines.

**Applied:** Updated test infrastructure to remove MBA-2017 restrictions for better-sqlite3 tests.

---

## L2: Cloudflare Pages Uses `[env.preview]` Not `[env.staging]`

**Context:** Tried to configure separate D1 databases for preview vs production deployments.

**Learning:** Cloudflare Pages recognizes specific environment names in wrangler.toml:
- Top-level bindings → Production (main branch)
- `[env.preview]` → Preview deployments (all other branches)
- `[env.staging]` → Only for CLI commands, not Pages deployments

**Impact:** Must use `[env.preview]` for preview deployments to use staging database.

**Applied:** Updated wrangler.toml with both `[env.preview]` (for Pages) and `[env.staging]` (for CLI).

---

## L3: Use `wrangler pages download config` Before Modifying wrangler.toml

**Context:** Cloudflare docs warn to download current config before enabling wrangler.toml management for Pages.

**Learning:** Running `wrangler pages download config --project-name <name>` retrieves the actual bindings configured in Cloudflare's dashboard. This revealed that preview deployments were missing `[env.preview]` and using production database!

**Impact:** Always sync with Cloudflare's state before making wrangler.toml changes for Pages projects.

**Applied:** Downloaded config, discovered missing preview bindings, merged our additions.

---

## L4: D1 REST Client Should Not Have Hardcoded Database ID

**Context:** The D1 REST API fallback for MBA-2017 had production database ID hardcoded.

**Learning:** Hardcoded defaults are dangerous for database connections. MBA-2017 could accidentally write to production if developer forgets to configure staging.

**Impact:** Changed to require explicit `D1_DATABASE_ID` in `.dev.vars` with no fallback default.

**Applied:** Updated `src/lib/db/d1-rest.ts` to require env var, added warning if production ID detected.

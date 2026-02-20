# Session 70 Decisions - 2026-01-23

## D1: Two-Database Strategy for D1

**Decision:** Create separate D1 databases for production vs staging/preview.

**Options Considered:**
1. Single database for everything (current state)
2. Two databases: production + staging (chosen)
3. Three databases: production + staging + development

**Rationale:**
- Production data must be protected from dev/preview writes
- Genesis cohort will have real students soon
- MBA-2017 dev and preview deployments should share staging
- Three databases is overkill for current scale

**Implementation:**
- `peerloop-db` (production) - main branch only
- `peerloop-db-staging` (staging) - preview deploys, MBA-2017, QA

---

## D2: In-Memory SQLite for All Test Machines

**Decision:** Use better-sqlite3 for test database on ALL machines, not just MacMini.

**Options Considered:**
1. MacMini-only test DB, MBA-2017 mock-only (original plan)
2. Both machines use better-sqlite3 (chosen)
3. Both machines use remote D1 for tests

**Rationale:**
- better-sqlite3 has no macOS version requirement
- D1 IS SQLite under the hood - same behavior
- Fast (in-memory) and isolated (fresh per suite)
- Equal test coverage on both machines

**Implementation:**
- `canUseTestDB()` returns true for all machines
- Removed MBA-2017 skip logic for integration tests

---

## D3: Require Explicit D1_DATABASE_ID for REST Fallback

**Decision:** Remove hardcoded database ID from D1 REST client.

**Options Considered:**
1. Hardcode production ID as default (dangerous)
2. Hardcode staging ID as default (safer but unclear)
3. Require explicit env var, fail if missing (chosen)

**Rationale:**
- Fail-safe: missing config = no connection, not production write
- Intentional: developer must consciously choose database
- Auditable: clear what's configured on each machine

**Implementation:**
- `D1_DATABASE_ID` required in `.dev.vars` for MBA-2017
- Warning logged if production ID is used
- Clear error message if env var missing

---

## D4: Database Environment Markers for Verification

**Decision:** Add `environment` marker to platform_stats table in each database.

**Options Considered:**
1. Check user counts (unreliable - same seed data)
2. Check database ID somehow (not exposed to app)
3. Add explicit marker record (chosen)

**Rationale:**
- Unambiguous identification
- Survives data changes
- Simple query to verify
- Created `/api/debug/db-env` endpoint to check

**Implementation:**
- Staging: `platform_stats.environment = 'staging'`
- Production: `platform_stats.environment = 'production'`

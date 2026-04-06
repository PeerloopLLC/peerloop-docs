# Database Migration Strategy

## Overview

Peerloop uses a split migration strategy to ensure production safety while enabling rich test data for development.

## Directory Structure

```
migrations/              # PRODUCTION-SAFE (applied to all environments)
├── README.md
├── 0001_schema.sql      # Complete database schema
├── 0002_seed_core.sql   # Essential data only
├── 0003_fix_session_times.sql  # Append Z suffix to bare session times (Conv 002)
└── 0004_feed_activity_index.sql  # Feed activity D1 index for unread counts + cross-feed queries (Conv 017)

migrations-dev/          # DEV ONLY (never applied to production)
├── README.md
├── 0001_seed_dev.sql    # Test data for development
├── 0002_seed_stripe.sql # Stripe sandbox account IDs (opt-in)
└── 0003_seed_booking_test.sql  # Booking test scenario (opt-in)

scripts/seed-feeds.mjs   # Stream.io + D1 feed_activities seed (Conv 018)
tests/plato/             # PLATO API-driven seed (local only, see § PLATO Seed)
```

## Core vs Dev Seed

### Core Seed (`migrations/0002_seed_core.sql`)

Applied to ALL environments including production:

| Data | Purpose |
|------|---------|
| Topics & Tags | Required for course tagging and discovery |
| Feature flags | System configuration |
| Platform stats | Initial values (zeroed) |
| Admin user | Initial platform access (`admin@peerloop.com`) |
| The Commons | System community (with cover image) |
| FAQ entries | Public help content |
| Team members | About page |

### Dev Seed (`migrations-dev/0001_seed_dev.sql`)

Applied ONLY to local and staging:

| Data | Purpose |
|------|---------|
| Test users | Various roles for testing |
| Test courses | Full course content |
| Test communities | Community features testing |
| Test enrollments | Payment/progress testing |
| Test sessions | Scheduling testing |

## Quick Reference: Full Database Setup

### SQL Seed Chain (additive levels)

| Level | Local | Staging | Seeds |
|-------|-------|---------|-------|
| Base | `db:setup:local` | `db:setup:staging` | core |
| + Dev | `db:setup:local:dev` | `db:setup:staging:dev` | core + dev |
| + Stripe | `db:setup:local:stripe` | `db:setup:staging:stripe` | core + dev + stripe |
| + Booking | `db:setup:local:booking` | `db:setup:staging:booking` | core + dev + stripe + booking |
| + Feeds | `db:setup:local:feeds` | `db:setup:staging:feeds` | core + dev + stripe + booking + Stream feeds |

All commands prefixed with `npm run`. Each level chains through the previous one (additive). The Stripe seed (`migrations-dev/0002_seed_stripe.sql`) links dev users to real Stripe test-mode Express accounts, required for testing checkout/enrollment flows. The Feeds seed (`scripts/seed-feeds.mjs`) creates Stream.io activities + D1 `feed_activities` rows for smart feed testing.

### PLATO Seed (parallel path — local only)

PLATO generates seed data by running API scenarios through the test framework, not via SQL files. It produces a complete, relationship-consistent database state (users, courses, enrollments, sessions, certifications) that has been validated through the full API layer.

| Command | Environment | What it does |
|---------|-------------|--------------|
| `plato:seed` | Local D1 | Restores `seed-dev` snapshot into local wrangler D1 |
| `db:seed:plato` | In-memory (test) | Runs seed-dev scenario via API runner |

**PLATO data is local-dev only.** PLATO and SQL seed data use different IDs and are incompatible — they cannot be merged into the same database. Staging uses only the SQL seed chain above. The `plato:seed:staging` script exists but should not be used (staging uses SQL seeds for consistency with production data shapes).

## npm Commands

### Development (Local)

```bash
# Production-like setup (schema + core seed only)
npm run db:setup:local

# Dev setup with test data
npm run db:setup:local:dev

# Dev + Stripe sandbox accounts
npm run db:setup:local:stripe

# Dev + Stripe + booking test scenario
npm run db:setup:local:booking

# Dev + Stripe + booking + Stream feeds
npm run db:setup:local:feeds

# PLATO seed (parallel path — incompatible with SQL seeds)
npm run plato:seed

# Individual operations
npm run db:migrate:local    # Apply migrations only
npm run db:seed:local       # Apply dev seed only
npm run db:reset:local      # Reset database
npm run db:studio:local     # Open DB browser
```

### Staging

```bash
# Production-like setup (schema + core seed only)
npm run db:setup:staging

# Dev setup with test data
npm run db:setup:staging:dev

# Dev + Stripe sandbox accounts
npm run db:setup:staging:stripe

# Dev + Stripe + booking test scenario
npm run db:setup:staging:booking

# Dev + Stripe + booking + Stream feeds
npm run db:setup:staging:feeds

# NOTE: No PLATO seed for staging — PLATO data is local-dev only

# Individual operations
npm run db:migrate:staging
npm run db:seed:staging
npm run db:reset:staging
npm run db:studio:staging
```

### Production (SAFEGUARDED)

```bash
# Apply migrations (requires confirmation)
npm run db:migrate:prod

# BLOCKED commands (will error)
npm run db:seed:prod     # ← ERROR: Dev seed blocked
npm run db:reset:prod    # ← ERROR: Reset blocked
```

## Safety Measures

### 1. Confirmation Script

`npm run db:migrate:prod` requires typing "production" to proceed:

```
╔═══════════════════════════════════════════════════════════════╗
║  ⚠️   PRODUCTION DATABASE OPERATION                           ║
╠═══════════════════════════════════════════════════════════════╣
║  You are about to modify the PRODUCTION database.            ║
║  This affects REAL USER DATA.                                ║
╚═══════════════════════════════════════════════════════════════╝

Type "production" to confirm, or anything else to abort:
```

### 2. Blocked Commands

These commands explicitly fail to prevent accidents:
- `db:seed:prod` - Dev seed cannot be applied to production
- `db:reset:prod` - Production reset is blocked

### 3. Directory Separation

Dev seed is in a completely different directory (`migrations-dev/`), so it's never in the migration path for production.

## Testing Production Flows Locally

To test what a fresh production install looks like:

```bash
npm run db:setup:local
```

This applies:
- ✅ Schema
- ✅ Core seed (topics, tags, admin, The Commons)
- ❌ Dev seed (not applied)

You can then manually test:
- User signup flow
- Creator application
- Course creation
- Community creation

## Migration Workflow

### Adding Schema Changes

1. Edit `migrations/0001_schema.sql` directly
2. Use `DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))` for timestamp columns (not `datetime('now')`)
3. Reset local database: `npm run db:setup:local:dev`
4. Test thoroughly
5. Commit changes

### Adding Core Data

For data that production needs (new topics/tags, feature flags):
1. Edit `migrations/0002_seed_core.sql`
2. Test with `npm run db:setup:local` (production-like, no dev seed)

### Adding Test Data

For development/testing data:
1. Edit `migrations-dev/0001_seed_dev.sql`
2. Test with `npm run db:setup:local:dev`

### Timestamp Freshness (Conv 059)

Dev seed data contains hardcoded timestamps (originally from 2024). Rather than updating every INSERT, a `TIMESTAMP FRESHNESS` section at the end of `0001_seed_dev.sql` uses `strftime()`-relative UPDATEs to shift time-sensitive records to recent dates on every `db:setup:local:dev` run.

**Two parts:**
- **Part A — Feed Activities:** 28 INSERT rows with `strftime('%Y-%m-%dT%H:%M:%fZ', 'now', '-Xh')` timestamps distributed across Smart Feed time windows (6h, 24h, 72h, 14d, 30d)
- **Part B — Booking/Availability:** UPDATE sweep for sessions, invites, overrides, intro sessions, notifications, credits, and contacts

**Design principle:** Keep original INSERTs as narrative documentation of test data relationships. The append-only UPDATE sweep at the end adjusts only the functionally time-sensitive records. This is self-adjusting — no manual date maintenance needed.

## Remote Reset Caveats

**Known issue (Session 359):** The `reset-d1.js` script drops tables but not standalone indexes on remote D1. If the batch drop fails partway through (FK constraint error from circular dependencies), some tables survive. When those tables are then dropped individually, their indexes become orphaned in `sqlite_master`. The next migration then fails with `index already exists` on `CREATE INDEX` statements that lack `IF NOT EXISTS`.

**Three notification indexes** use `CREATE INDEX` without `IF NOT EXISTS` in the schema — these are the most common failure point:
- `idx_notifications_user_id`
- `idx_notifications_user_read`
- `idx_notifications_created`

**Recovery:** See CLAUDE.md "D1 Database Reset" section for the manual recovery procedure (drop indexes, drop tables in 3 dependency-ordered batches, clear `d1_migrations`, re-apply).

**Root causes to fix:**
1. `reset-d1.js` should drop indexes before tables
2. Schema should use `CREATE INDEX IF NOT EXISTS` consistently (3 notification indexes don't)

---

## Post-Launch Migration Strategy

After production launch, schema changes become incremental:

```
migrations/
├── 0001_schema.sql         # Initial schema (frozen)
├── 0002_seed_core.sql      # Core data (frozen)
├── 0003_fix_session_times.sql  # Fix session times (actual)
├── 0004_feed_activity_index.sql  # Feed activity index (actual)
├── 0005_add_feature_x.sql  # Incremental change (example)
└── ...
```

Development seed remains separate and continues to be maintained.

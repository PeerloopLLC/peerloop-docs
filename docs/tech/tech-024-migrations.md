# tech-024: Database Migration Strategy

## Overview

Peerloop uses a split migration strategy to ensure production safety while enabling rich test data for development.

## Directory Structure

```
migrations/              # PRODUCTION-SAFE (applied to all environments)
├── README.md
├── 0001_schema.sql      # Complete database schema
└── 0002_seed_core.sql   # Essential data only

migrations-dev/          # DEV ONLY (never applied to production)
├── README.md
└── 0001_seed_dev.sql    # Test data for development
```

## Core vs Dev Seed

### Core Seed (`migrations/0002_seed_core.sql`)

Applied to ALL environments including production:

| Data | Purpose |
|------|---------|
| Categories | Required for course creation |
| Feature flags | System configuration |
| Platform stats | Initial values (zeroed) |
| Admin user | Initial platform access (`admin@peerloop.com`) |
| The Commons | System community |
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

## npm Commands

### Development (Local)

```bash
# Full setup with test data
npm run db:setup:local

# Production-like setup (no test data)
npm run db:setup:local:clean

# Individual operations
npm run db:migrate:local    # Apply migrations only
npm run db:seed:local       # Apply dev seed only
npm run db:reset:local      # Reset database
npm run db:studio:local     # Open DB browser
```

### Staging

```bash
# Full setup with test data
npm run db:setup:staging

# Production-like setup
npm run db:setup:staging:clean

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
npm run db:setup:local:clean
```

This applies:
- ✅ Schema
- ✅ Core seed (categories, admin, The Commons)
- ❌ Dev seed (not applied)

You can then manually test:
- User signup flow
- Creator application
- Course creation
- Community creation

## Migration Workflow

### Adding Schema Changes

1. Edit `migrations/0001_schema.sql` directly
2. Reset local database: `npm run db:setup:local`
3. Test thoroughly
4. Commit changes

### Adding Core Data

For data that production needs (new categories, feature flags):
1. Edit `migrations/0002_seed_core.sql`
2. Test with `npm run db:setup:local:clean`

### Adding Test Data

For development/testing data:
1. Edit `migrations-dev/0001_seed_dev.sql`
2. Test with `npm run db:setup:local`

## Post-Launch Migration Strategy

After production launch, schema changes become incremental:

```
migrations/
├── 0001_schema.sql         # Initial schema (frozen)
├── 0002_seed_core.sql      # Core data (frozen)
├── 0003_add_feature_x.sql  # Incremental change
├── 0004_add_column_y.sql   # Incremental change
└── ...
```

Development seed remains separate and continues to be maintained.

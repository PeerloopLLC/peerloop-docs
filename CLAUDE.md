# CLAUDE.md

This file provides guidance to Claude Code when working in the Peerloop dual-repo architecture.

## Dual-Repo Architecture

Peerloop uses two sibling repositories:

```
~/projects/
├── peerloop-docs/    ← CC home (this repo) + Obsidian vault
│   ├── .claude/      # All CC configuration, commands, hooks
│   ├── CLAUDE.md     # This file (full project guidance)
│   ├── docs/         # Sessions, reference, tech, pagespecs
│   ├── research/     # Specifications, schemas, stories
│   └── RFC/          # Client change requests
│
└── Peerloop/         ← Code repo (added via --add-dir)
    ├── src/          # Application code
    ├── tests/        # Test suite
    ├── scripts/      # Build & utility scripts
    ├── migrations/   # Database SQL
    └── ...           # Config files, package.json, etc.
```

**Launch pattern:** `cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop`

**Path conventions:**
- Docs, research, RFC, planning files → local paths (e.g., `docs/tech/...`, `research/DB-SCHEMA.md`)
- Code, tests, scripts, config → prefixed paths (e.g., `../Peerloop/src/...`)
- npm/npx commands → `cd ../Peerloop && npm run ...`

**Symlinks in code repo** (for build-time dependencies):
- `Peerloop/docs → ../peerloop-docs/docs`
- `Peerloop/research → ../peerloop-docs/research`

---

## Session Startup Hooks

**Global hook** (runs for all projects via `~/.claude/settings.json`):

### Machine Detection (`~/.claude/hooks/detect-machine.sh`)
Detects the development machine and displays capabilities/constraints. Writes machine name to `~/.claude/.machine-name` for use by `/q-commit` and `/q-timecard`.

| Machine | D1 Local | D1 Remote | R2 Local | R2 Remote | Notes |
|---------|:--------:|:---------:|:--------:|:---------:|-------|
| MacMiniM4-Pro | ✅ | ✅ | ✅ | ✅ | Full functionality |
| MacMiniM4 | ✅ | ✅ | ✅ | ✅ | Full functionality |

**Project hooks** (Peerloop-specific via `.claude/settings.json`):

### Resume State Check (`.claude/hooks/check-resume-state.sh`)
Detects `RESUME-STATE.md` at session start and displays its contents.

If you see resume state information in the session context, respond to the user with:
- Summary of the saved state
- The 4 options: `/q-resume`, view full file, delete, or ignore

This prevents stale resume states from being forgotten after `/compact`.

## Test Suite Workflow

**CRITICAL: When running the full test suite, follow this workflow:**

1. **Run once and capture failures** to a file:
   ```bash
   cd ../Peerloop && npm test 2>&1 | tee /tmp/test-output.txt
   ```

2. **Extract failing tests** into a structured list:
   ```bash
   grep -E "FAIL.*test\.(ts|tsx)" /tmp/test-output.txt | sort -u > /tmp/failing-tests.txt
   ```

3. **Present results to user** before proceeding:
   - Show the count of failures
   - List the failing test files
   - Wait for user instruction on how to proceed

4. **Fix tests individually**, running only that specific test:
   ```bash
   cd ../Peerloop && npm test -- --testNamePattern="TestName" 2>&1 | tail -15
   ```

5. **Do NOT re-run the full suite** until all identified failures are fixed.

**Why this matters:**
- Full test suite takes ~2 minutes
- Running it repeatedly wastes time and context
- Fixing tests one-by-one with targeted runs is efficient

## Project Overview

**Peerloop** (formerly Alpha Peer) is a peer-to-peer learning platform that solves the "2 Sigma Problem" by making 1-on-1 tutoring affordable and scalable through a learn-teach-earn flywheel.

### The Flywheel Model
- Student enrolls and learns from a Student-Teacher (S-T)
- Student completes course → S-T recommends → Creator certifies
- Student becomes Student-Teacher → teaches new students → earns 70% commission
- Cycle repeats, creating self-sustaining teaching capacity

### Key Metrics
| Metric | Target |
|--------|--------|
| Course Completion Rate | ≥75% (vs 15-20% MOOC average) |
| Student-to-Teacher Conversion | 10-20% |
| Genesis Cohort | 60-80 students, 4-5 courses |
| Timeline | 4 months |
| Budget | $75,000 |

## Technology Stack

| Layer | Technology | Notes |
|-------|------------|-------|
| Meta-framework | Astro.js | React islands, SSG/SSR |
| UI Framework | React.js | Component library |
| Styling | TailwindCSS | Utility-first CSS |
| Hosting/Edge | Cloudflare | Pages, Workers, R2, D1 |
| Database | Cloudflare D1 | SQLite-based |
| Auth | Custom JWT | Session management |
| Payments | Stripe Connect | 85/15 split, payouts |
| Activity Feeds | Stream.io | Feeds only (not chat) |
| Video | VideoProvider Interface | BBB/PlugNmeet abstraction |
| Email | Resend | Transactional email |
| File Storage | Cloudflare R2 | S3-compatible |

### Development Machines

| Name | Machine | D1 Support | R2 Support |
|------|---------|------------|------------|
| `MacMiniM4-Pro` | Mac Mini M4 Pro (64GB) | Local + Remote | Local + Remote |
| `MacMiniM4` | Mac Mini M4 (24GB) | Local + Remote | Local + Remote |

Both machines have identical, full capabilities. See `docs/tech/tech-013-devcomputers.md` for details.

## Development Commands

All code commands run from the code repo:

```bash
# Install dependencies
cd ../Peerloop && npm install

# Start development server
cd ../Peerloop && npm run dev

# Build for production
cd ../Peerloop && npm run build

# Preview production build
cd ../Peerloop && npm run preview

# Type checking
cd ../Peerloop && npx tsc --noEmit

# Linting
cd ../Peerloop && npm run lint
```

## Database Migrations

**Migration Strategy:** Split seed files for production safety. See `docs/tech/tech-024-migrations.md`.

```
../Peerloop/migrations/              # PRODUCTION-SAFE (applied everywhere)
├── 0001_schema.sql                  # Table definitions
└── 0002_seed_core.sql               # Essential data (categories, admin, The Commons)

../Peerloop/migrations-dev/          # DEV ONLY (local + staging only)
└── 0001_seed_dev.sql                # Test data (users, courses, etc.)
```

**Commands:**
```bash
# Local dev (with test data)
cd ../Peerloop && npm run db:setup:local

# Local production-like (test fresh install flows)
cd ../Peerloop && npm run db:setup:local:clean

# Production (SAFEGUARDED - requires confirmation)
cd ../Peerloop && npm run db:migrate:prod
```

**Blocked Commands (for safety):**
- `npm run db:seed:prod` - Dev seed CANNOT be applied to production
- `npm run db:reset:prod` - Production reset is blocked

**Schema Changes:**
- Edit `../Peerloop/migrations/0001_schema.sql` directly - it's the authoritative schema
- Post-launch: Add incremental `0003_*.sql` migrations for production upgrades

**Testing:**
- Test DB uses better-sqlite3 (works on all machines)
- Applies migrations fresh each run
- `cd ../Peerloop && npm run test` validates schema automatically

### Schema Mismatch During Testing

**CRITICAL: The schema is NOT finalized.** When writing tests, if you encounter ANY discrepancy between:
- Test expectations vs schema
- Endpoint code vs schema
- Non-existent tables/columns referenced in code

**You MUST STOP and ask the user.** Do NOT assume the schema is correct. Do NOT silently fix the endpoint to match the schema.

**Present options to the user:**
```
Schema/Code Discrepancy Detected
────────────────────────────────
Location: [endpoint or test file]
Issue: [describe the mismatch]

Current schema says: [X]
Code/test expects: [Y]

Options:
1. Fix the schema to match the code's design intent
2. Fix the code/test to match current schema
3. Discuss the design intent first
```

**Examples of discrepancies to flag:**
- FK references wrong table (e.g., `REFERENCES users(id)` vs `REFERENCES student_teachers(id)`)
- Code references non-existent table or column
- Test expects columns that don't exist
- Column types or constraints don't match usage

**Let the user decide** - the schema is still evolving. Often the code represents the intended design and the schema needs updating.

**If extending schema:** Edit `../Peerloop/migrations/0001_schema.sql` directly, update `../Peerloop/migrations/0002_seed_core.sql` if needed.

### D1 Database Reset

To reset a D1 database and re-apply migrations fresh:

```bash
# Local D1
cd ../Peerloop && npm run db:reset:local && npm run db:migrate:local

# Staging D1 (Cloudflare)
cd ../Peerloop && npm run db:reset:staging && npm run db:migrate:staging

# Production D1 (Cloudflare) - use with caution!
cd ../Peerloop && npm run db:reset:remote && npm run db:migrate:remote
```

**How it works:**
- **Local:** Deletes SQLite files in `../Peerloop/.wrangler/state/v3/d1/` (simplest approach)
- **Remote:** Parses `0001_schema.sql` for FK relationships, drops tables in dependency order (children before parents)

**Why dependency order?** D1 enforces `foreign_keys=ON` at the platform level and doesn't allow `PRAGMA foreign_keys=OFF`. Using `PRAGMA defer_foreign_keys=ON` doesn't help with DROP TABLE. The only reliable approach is to drop child tables before parent tables.

## Project Structure

```
~/projects/
├── peerloop-docs/                    # CC home + Obsidian vault
│   ├── .claude/                      # CC configuration
│   │   ├── commands/                 # 22 slash command files
│   │   ├── hooks/                    # Session hooks
│   │   ├── settings.json             # Permissions & hook config
│   │   ├── config.json               # Project config
│   │   └── plans/                    # CC plans
│   ├── CLAUDE.md                     # This file
│   ├── PLAN.md                       # Current & pending work
│   ├── COMPLETED_PLAN.md             # Completed work
│   ├── DECISIONS.md                  # Architecture decisions
│   ├── BEST-PRACTICES.md             # Coding standards
│   ├── SESSION-INDEX.md              # Session log index
│   ├── USER-STORIES-MAP.md           # User stories overview
│   ├── SITE-MAP.md                   # Site map
│   ├── ORIG-PAGES-MAP.md             # Original page architecture
│   ├── docs/
│   │   ├── reference/                # CLI, API, testing docs
│   │   ├── tech/                     # Technology decisions
│   │   ├── sessions/                 # Development session logs
│   │   ├── pagespecs/                # Page design specs
│   │   ├── pages/                    # Page metadata
│   │   └── guides/                   # How-to guides
│   ├── research/                     # Specifications & schemas
│   │   ├── GOALS.md                  # Mission & success metrics
│   │   ├── USER-STORIES.md           # All user stories (370+)
│   │   ├── DB-SCHEMA.md              # Database entities
│   │   ├── DB-API.md                 # Internal API endpoints
│   │   ├── REMOTE-API.md             # External service APIs
│   │   ├── COMPONENTS.md             # UI component library
│   │   ├── run-001/                  # Implementation scenario
│   │   └── stories/                  # User stories by role
│   └── RFC/                          # Client change requests
│
└── Peerloop/                         # Code repo (via --add-dir)
    ├── CLAUDE.md                     # Minimal pointer to docs repo
    ├── src/                          # Application source
    │   ├── components/               # React components
    │   ├── pages/                    # Astro pages
    │   ├── layouts/                  # Page layouts
    │   ├── lib/                      # Utility functions
    │   ├── services/                 # External service integrations
    │   └── styles/                   # Global styles
    ├── public/                       # Static assets
    ├── tests/                        # Test suite
    ├── e2e/                          # End-to-end tests
    ├── scripts/                      # Build & utility scripts
    ├── migrations/                   # Production DB migrations
    ├── migrations-dev/               # Dev-only seed data
    ├── docs → ../peerloop-docs/docs          # Symlink
    ├── research → ../peerloop-docs/research  # Symlink
    └── [config files]                # package.json, wrangler.toml, etc.
```

## Key Roles

| Role | Description |
|------|-------------|
| Student | Learner progressing through courses |
| Student-Teacher (S-T) | Certified graduate who teaches peers (70% commission) |
| Creator | Course author who certifies S-Ts (15% royalty) |
| Admin | Platform operations and oversight |
| Moderator | Community moderation |

## Research Reference

All specifications live in `research/`. Use this guide to find what you need:

### What Are We Building?

| Need | Look In |
|------|---------|
| Project goals & success metrics | `research/GOALS.md` |
| User stories (all 370+) | `research/USER-STORIES.md` |
| User stories by role | `research/stories/stories-*.md` (admin, creator, student, etc.) |
| MVP scope (144 P0 stories) | `research/run-001/SCOPE.md` |

### How Should It Look/Work?

| Need | Look In |
|------|---------|
| **Routes & navigation** | `docs/tech/tech-021-url-routing.md` - **Source of truth for routes** |
| Page specs (JSON) | `../Peerloop/src/data/pages/**/*.json` - Runtime data for PageSpecView |
| Page specs (MD) | `docs/pagespecs/**/*.md` - Detailed design documentation |
| UI components | `research/COMPONENTS.md` |
| Feature breakdown by block | `research/run-001/features/features-block-*.md` |
| Original page architecture | `ORIG-PAGES-MAP.md` - Pre-Twitter UI pivot reference |

**Note:** The original `PAGES-MAP.md` was renamed to `ORIG-PAGES-MAP.md` after the client moved to a Twitter-like UI/UX. Route information is now maintained in `docs/tech/tech-021-url-routing.md`.

### Data & APIs

| Need | Look In |
|------|---------|
| Database schema | `research/DB-SCHEMA.md` |
| Internal API endpoints | `research/DB-API.md` |
| External service APIs | `research/REMOTE-API.md` (Stripe, Stream, PlugNmeet, Resend) |

### Technology Decisions

| Need | Look In |
|------|---------|
| Why we chose a technology | `docs/tech/tech-NNN-*.md` |
| Technology comparisons | `docs/tech/comp-NNN-*.md` |
| Integration patterns | `docs/tech/tech-NNN-*.md` (code examples section) |

### Implementation

| Need | Look In |
|------|---------|
| Current & pending work | `PLAN.md` (root) |
| Completed work | `COMPLETED_PLAN.md` (root) |
| Block-by-block features | `research/run-001/features/` |
| Infrastructure features | `research/run-001/features/features-infrastructure.md` |

### Client Change Requests (RFCs)

| Need | Look In |
|------|---------|
| **RFC index & status** | `RFC/INDEX.md` - **Lookup table for all RFCs** |
| Source document | `RFC/CD-XXX/CD-XXX.md` |
| Actionable checklist | `RFC/CD-XXX/RFC.md` |

## RFC System

Client-driven change requests are tracked in the `RFC/` folder.

**Structure:**
```
RFC/
├── INDEX.md           # Lookup table (status, item counts)
└── CD-XXX/
    ├── CD-XXX.md      # Source: raw client input
    └── RFC.md         # Actionable checklist with checkboxes
```

**Workflow:**
1. Client provides note/directive
2. Run `/q-add-client-note` to analyze and create RFC
3. Check off items in `RFC.md` as implemented
4. Update status in `RFC/INDEX.md` when complete

**When working on an RFC:**
- Read `RFC/INDEX.md` to find open RFCs
- Check `RFC/CD-XXX/RFC.md` for pending items
- Mark checkboxes as completed during implementation

## Technology Documentation

**Location:** `docs/tech/`

Each software/service in the tech stack has a dedicated doc (e.g., `tech-007-posthog.md`).

### When Working with a Technology

1. **Check the tech doc first** - Before implementing, read `docs/tech/tech-NNN-*.md` for:
   - Why it was chosen (decision rationale)
   - Known caveats or limitations
   - Integration patterns and code examples
   - Pricing considerations

2. **Update the doc** - When you discover:
   - New caveats or gotchas
   - Better integration patterns
   - Version-specific issues
   - Performance considerations
   - Useful tips or workarounds

### Tech Doc Format

Each doc includes:
- Overview and why chosen
- Comparison with alternatives
- Features relevant to PeerLoop
- Integration code examples
- Pricing
- References to official docs

## Block Sequence

| Block | Focus | Key Deliverables |
|-------|-------|------------------|
| 0 | Foundation | Auth, database schema, navigation shell |
| 1 | Course Display | Homepage, course browse, creator profiles |
| 2 | Enrollment | Payment, checkout, enrollment management |
| 3 | Dashboards | Student, S-T, Creator dashboards |
| 4 | Video Sessions | VideoProvider, booking, session room |
| 5 | Community Feed | Stream.io integration, posts, reactions |
| 6 | Certifications | Certificate issuance, verification |
| 7 | S-T Management | Availability, earnings, students |
| 8 | Admin Tools | User/course/payout management |
| 9 | Notifications | Email + in-app notifications |

## Documentation Reference

**Location:** `docs/reference/`

Living documentation maintained via `/q-docs` (standard) and `/q-local-docs` (project-specific).

### Standard Docs (portable across projects)

| File | Purpose | When to Update |
|------|---------|----------------|
| `CLI-QUICKREF.md` | Command index (start here) | Any npm script or API change |
| `CLI-REFERENCE.md` | Detailed npm script docs | Script added/changed |
| `CLI-TESTING.md` | Test command details | Test commands changed |
| `CLI-MISC.md` | Setup & installation | Environment/setup changes |
| `API-REFERENCE.md` | REST API & database patterns | Endpoints or DB patterns changed |
| `TEST-COVERAGE.md` | Test file inventory | Tests added/removed |
| `DEVELOPMENT-GUIDE.md` | Dev patterns & conventions | New patterns established |

### Project-Specific Docs (via `/q-local-docs`)

| Location | Purpose | When to Update |
|----------|---------|----------------|
| `docs/tech/*.md` | Technology decisions | Package changes, caveats |
| `research/run-001/pages/*.md` | Page specifications | Page design changes |
| `research/DB-SCHEMA.md` | Database design | Schema changes |

**Related project docs:**
- `PLAN.md` - Current & pending work (docs repo root)
- `COMPLETED_PLAN.md` - Completed work (docs repo root)
- `ORIG-PAGES-MAP.md` - Original page architecture (pre-Twitter UI pivot)
- `research/` - Specifications & design docs

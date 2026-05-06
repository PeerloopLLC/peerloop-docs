# Documentation Index

Navigation index for the Peerloop docs/ tree. CLAUDE.md is for behavioral rules; this file is for finding things.

> Created Conv 150 by relocating §Research Reference, §Documentation Reference, and the full §Project Structure tree out of CLAUDE.md. CLAUDE.md retains a top-level repo summary and pointers; the detail lives here.

---

## Repo Layout

```
~/projects/
├── peerloop-docs/                    # CC home + Obsidian vault
│   ├── .claude/                      # CC configuration
│   │   ├── commands/                 # (empty — all migrated to skills/)
│   │   ├── skills/                   # w-* skills (Peerloop-specific) + r-* skills (Conv lifecycle)
│   │   ├── hooks/                    # Session hooks
│   │   ├── settings.json             # Permissions & hook config
│   │   ├── config.json               # Project config
│   │   └── plans/                    # CC plans
│   ├── CLAUDE.md                     # Behavioral rules + project context
│   ├── PLAN.md                       # Current & pending work
│   ├── COMPLETED_PLAN.md             # Completed work
│   ├── DOC-DECISIONS.md              # Docs-repo decisions & conventions
│   ├── CONV-INDEX.md                 # Conversation log index (Conv 001+)
│   ├── SESSION-INDEX.md              # Session log archive (Sessions 0-393)
│   ├── TIMELINE.md                   # Project milestone timeline (inflection points)
│   └── docs/
│       ├── INDEX.md                  # This file — navigation index
│       ├── DECISIONS.md              # Peerloop application decisions
│       ├── GLOSSARY.md               # Official terminology
│       ├── POLICIES.md               # Platform behavior policies (access control, business rules)
│       ├── reference/                # CLI, API, testing, DB docs (+ DB-GUIDE, DB-API, REMOTE-API)
│       ├── as-designed/              # Architecture & design docs (+ run-001/, orig-pages-map, route-stories)
│       ├── requirements/             # Goals, user stories, RFCs, client docs
│       │   ├── rfc/                  # Client change requests (CD-XXX/)
│       │   └── stories/              # User stories by role
│       ├── sessions/                 # Development session logs
│       └── guides/                   # How-to guides
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
    └── [config files]                # package.json, wrangler.toml, etc.
```

---

## Specifications & Requirements

### Terminology

| Need | Look In |
|------|---------|
| **Official terminology (source of truth)** | `docs/GLOSSARY.md` — identity hierarchy, domain terms, naming conventions, ambiguous terms (§7) |

For the historical TERMINOLOGY rename (Sessions 346-356, ~960 files) including pre-rename commit hashes for diff comparisons, see `TIMELINE.md` § "TERMINOLOGY Rename Boundary".

### What Are We Building?

| Need | Look In |
|------|---------|
| Project goals & success metrics | `docs/requirements/GOALS.md` |
| User stories (all 370+) | `docs/requirements/USER-STORIES.md` |
| User stories by role | `docs/requirements/stories/stories-*.md` (admin, creator, student, etc.) |
| **Route→story mapping (402 stories)** | `docs/as-designed/route-stories.md` — **Canonical route-to-story assignment** |
| MVP scope (144 P0 stories) | `docs/as-designed/run-001/SCOPE.md` |

### How Should It Look/Work?

| Need | Look In |
|------|---------|
| **Routes & navigation** | `docs/as-designed/url-routing.md` — **Source of truth for routes** |
| UI components | `docs/reference/_COMPONENTS.md` |
| Feature breakdown by block | `docs/as-designed/run-001/_features-block-*.md` |
| Original page architecture (pre-Twitter UI pivot) | `docs/as-designed/orig-pages-map.md` |

### Data & APIs

| Need | Look In |
|------|---------|
| Database schema (SQL source of truth) | `../Peerloop/migrations/0001_schema.sql` |
| Database design rationale | `docs/reference/DB-GUIDE.md` |
| Internal API endpoints | `docs/reference/DB-API.md` |
| External service APIs | `docs/reference/REMOTE-API.md` (Stripe, Stream, PlugNmeet, Resend) |

---

## Technology & Architecture

| Need | Look In |
|------|---------|
| Why we chose a vendor/service | `docs/reference/*.md` (vendor docs merged here) |
| Vendor comparisons | `docs/reference/comp-*.md` |
| Integration patterns / code examples | `docs/reference/*.md` |
| Architecture & design patterns | `docs/as-designed/*.md` |
| Skills 2 system & drift tools | `docs/as-designed/skills-system.md` |
| Docs sync strategy & registry | `docs/as-designed/doc-sync-strategy.md` — `.claude/config.json.docsRegistry` schema + 4-category classification |

---

## Platform Policies & Decisions

| Need | Look In |
|------|---------|
| Platform behavior policies | `docs/POLICIES.md` — Access control, business rules, user capabilities |
| Architecture & implementation decisions | `docs/DECISIONS.md` |
| Docs-repo conventions | `DOC-DECISIONS.md` |

---

## Implementation Tracking

| Need | Look In |
|------|---------|
| Current & pending work | `PLAN.md` (root) |
| Completed work | `COMPLETED_PLAN.md` (root) |
| Project milestone timeline | `TIMELINE.md` (root) — inflection points, not routine work |
| Block-by-block features | `docs/as-designed/run-001/` (files prefixed with `_features-`) |
| Infrastructure features | `docs/as-designed/run-001/_features-infrastructure.md` |
| RUN-001 block sequence (project arc) | `docs/as-designed/run-001/SCOPE.md` § "Block Arc" |

---

## Client Change Requests (RFCs)

| Need | Look In |
|------|---------|
| **RFC index & status** | `docs/requirements/rfc/INDEX.md` — **Lookup table for all RFCs** |
| Source document | `docs/requirements/rfc/CD-XXX/CD-XXX.md` |
| Actionable checklist | `docs/requirements/rfc/CD-XXX/RFC.md` |

For the RFC processing workflow (when a client provides a note), see CLAUDE.md § RFC System.

---

## Living Documentation (maintained by /r-end)

The `/r-end` skill's docs agent maintains the following reference docs (scripts in `.claude/skills/r-end/scripts/` and `.claude/scripts/`).

### Reference Docs

| File | Purpose | When to Update |
|------|---------|----------------|
| `docs/reference/CLI-QUICKREF.md` | Command index (start here) | Any npm script or API change |
| `docs/reference/CLI-REFERENCE.md` | Detailed npm script docs | Script added/changed |
| `docs/reference/CLI-TESTING.md` | Test command details | Test commands changed |
| `docs/reference/BROWSER-TESTING.md` | Chrome MCP vs Playwright comparison | Browser testing approach changed |
| `docs/reference/CLI-MISC.md` | Setup & installation | Environment/setup changes |
| `docs/reference/API-REFERENCE.md` | REST API & database patterns | Endpoints or DB patterns changed |
| `docs/reference/TEST-COVERAGE.md` | Test file inventory | Tests added/removed |
| `docs/reference/DEVELOPMENT-GUIDE.md` | Dev patterns & conventions | New patterns established |

### Project-Specific Docs

| Location | Purpose | When to Update |
|----------|---------|----------------|
| `docs/reference/*.md` (vendor), `docs/as-designed/*.md` | Technology & architecture docs | Package changes, caveats, design patterns |
| `docs/as-designed/run-001/_*.md` | Page specifications | Page design changes |
| `docs/reference/DB-GUIDE.md` | Database design rationale | Schema design changes |

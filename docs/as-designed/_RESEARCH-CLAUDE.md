# CLAUDE.md

**Version:** v7
**Last Updated:** 2025-12-26

> **Version History:** Increment version when substantive changes occur (new phases, changed workflows, new commands). Minor edits (typos, formatting) don't require version bump.

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a research and planning repository for **Alpha Peer**, a web application in the pre-development phase. The project uses iterative research, documentation, and decision tracking to prepare for eventual handoff to implementation. There is no code to build, lint, or test.

## Repository Structure

```
MyResearch/
├── Alpha-Peer/           # Main project folder
│   ├── STRUCTURE.md      # Master guide for organization (check first!)
│   ├── GOALS.md          # Mission statement & goals (from client docs)
│   ├── USER-STORIES.md   # All user stories (from client docs)
│   ├── DIRECTIVES.md     # Constraints & restrictions for RUN phase
│   ├── SPECS.md          # Technical specs for handoff (final scenario)
│   ├── DB-SCHEMA.md      # Database entities, fields, relationships
│   ├── PAGES.md          # Page inventory with data requirements
│   ├── COMPONENTS.md     # Reusable UI component library
│   ├── API.md            # API quick reference (index by HTTP method)
│   ├── DB-API.md         # Internal endpoints with DB-SCHEMA references
│   ├── REMOTE-API.md     # External service endpoints (Stripe, Stream, etc.)
│   ├── client-docs/      # Client-provided materials (don't modify originals)
│   ├── docs/reference/   # Technology research (tech-NNN-*.md, comp-NNN-*.md)
│   ├── scenarios/        # SPECS.md variants (sc-NNN-*-SPECS.md) - legacy
│   ├── runs/             # RUN phase execution tracking (run-NNN/)
│   ├── user-stories/     # Detailed story files (story-NNN-*.md)
│   ├── docs/sessions/    # Session logs by month (YYYY-MM/)
│   ├── prompts/          # Commands and prompt templates
│   ├── learnings/        # Knowledge capture (learning-NNN-*.md)
│   ├── decisions/        # Decision records (decision-NNN-*.md)
│   └── .claude/commands/ # Project-specific slash commands (r-*)
└── file_holding/         # Temporary staging for file processing
```

**Important:** Launch Claude Code from `Alpha-Peer/` folder, not `MyResearch/`.

## Key Conventions

### ID Numbering (all support up to 999)
| Prefix | Format | Example | Tracked In |
|--------|--------|---------|------------|
| CD- | CD-NNN | CD-001 | client-docs-index.md |
| GO- | GO-NNN | GO-001 | GOALS.md |
| US- | US-[Role]NNN | US-A001, US-S015 | USER-STORIES.md |

**User Story Role Codes:** A=Admin, C=Creator, S=Student, T=Teacher, E=Employer, V=Video/Session, P=Platform

### File Naming
- Numbers use zero-padded 3 digits: `001`, `002`, etc.
- Lowercase with hyphens for filenames
- Date format: YYYY-MM-DD (ISO 8601)
- Session files use timestamp: `docs/sessions/2025-11/2025-11-25_14-30-00 Learnings.md`

### Before Creating Files
Always check `Alpha-Peer/STRUCTURE.md` for:
- Current numbering state for each category
- Correct folder location
- Naming pattern to follow

After creating numbered files, update the "Current State" section in STRUCTURE.md.

## Slash Commands

Commands are split between two locations:
- **`~/.claude/commands/`** - User-level `/q-*` commands (available in all projects)
- **`Alpha-Peer/.claude/commands/`** - Project-specific `/r-*` commands

### `/q-*` Commands (Session & Git) - User-level

| Command | Purpose |
|---------|---------|
| `/q-resume` | Analyze PLAN.md and show current progress to resume work |
| `/q-update` | Update PLAN.md with current progress (run frequently) |
| `/q-end-session` | Full end-of-session workflow (learnings, prompts, optional commit) |
| `/q-commit` | Stage and commit all changes with descriptive message |
| `/q-learnings` | Document session learnings and insights |
| `/q-prompts` | Save all user prompts from session for future reference |
| `/q-timestamp` | Get current date/time (utility, called by other commands) |
| `/q-pare` | Optimize CLAUDE.md by moving content to OFFLOAD.md |

### `/r-*` Commands (Research & Documentation) - Project-level

| Command | Purpose |
|---------|---------|
| `/r-add-client-doc` | Process client document(s) from file_holding |
| `/r-add-software` | Research software/service from URL, create tech doc |
| `/r-add-user-story` | Add a single user story with proper numbering |
| `/r-add-directive` | Add constraint/restriction for scenario generation |
| `/r-research-tech` | Research a specific technology |
| `/r-compare-tech` | Compare two technologies for a use case |
| `/r-create-story` | Create a new user story |
| `/r-update-specs` | Update SPECS.md with recent work |
| `/r-log-decision` | Document a decision with rationale |
| `/r-status` | Show current project status |
| `/r-review` | Review and suggest improvements to a file |
| `/r-sync-structure` | Update STRUCTURE.md by scanning folders |
| `/r-list` | List files in a specific project folder |

---

## Project Phases

This project progresses through two main phases: **Gather** and **Run**.

### Phase: GATHER (Current)

The Gather phase collects all information needed to create comprehensive technical specifications. This is an iterative process of accumulating and organizing requirements.

**Inputs during Gather:**
| Input Type | Command | Updates |
|------------|---------|---------|
| Client documents | `/r-add-client-doc` | GOALS.md, USER-STORIES.md, client-docs-index.md, DB-SCHEMA.md, PAGES.md, COMPONENTS.md, DB-API.md |
| Software/services | `/r-add-software <url>` | PLAN.md, docs/reference/*.md |
| User stories | `/r-add-user-story` | USER-STORIES.md |
| Directives | `/r-add-directive` | DIRECTIVES.md |

**Key files that grow during Gather:**
- `GOALS.md` - Mission, goals, success metrics (from client docs)
- `USER-STORIES.md` - All user stories with priorities (370+ stories)
- `DIRECTIVES.md` - Constraints and restrictions for RUN phase
- `DB-SCHEMA.md` - Database entities, fields, relationships (from client docs with data samples)
- `PAGES.md` - Page inventory with data requirements (from user stories and mockups)
- `COMPONENTS.md` - Reusable UI components (from pages and data structures)
- `API.md` - API quick reference index (by HTTP method)
- `DB-API.md` - Internal endpoints with DB-SCHEMA table references
- `REMOTE-API.md` - External service endpoints (Stripe, Stream, PlugNmeet, Resend)
- `PLAN.md` - Phases, tasks, technology inventory
- `/docs/reference/` - Tech docs for each software/service evaluated
- `/client-docs/` - Original client materials with index

**Gather workflow:**
1. Add client documents → extracts goals and user stories
2. Add software/services → creates research docs, maps to user stories
3. Add individual user stories → as gaps are discovered
4. Research fills gaps → identifies what services are needed for which stories
5. Analyze documents for architecture implications → updates DB-SCHEMA.md, PAGES.md, COMPONENTS.md, DB-API.md

**Architecture document updates during Gather:**
- When processing client docs with data samples (like database schemas), update DB-SCHEMA.md
- When identifying new pages from user stories or mockups, update PAGES.md
- When pages reveal reusable UI patterns, update COMPONENTS.md
- When user stories imply backend operations, update DB-API.md (internal) or REMOTE-API.md (external services)

**Gather is complete when:**
- All client documents processed
- All required/optional services researched
- User stories mapped to technologies
- Architecture documents (DB-SCHEMA, PAGES, COMPONENTS, DB-API, REMOTE-API) populated
- Gaps identified and addressed
- Ready to create SPECS.md scenarios

### Phase: RUN

The Run phase transforms gathered information into actionable technical specifications through a collaborative, checkpoint-based process.

**Run Structure:**

Each run is tracked in `/runs/run-NNN/` with:
- `run-NNN.md` - Inputs, parameters, decisions, rationale
- `scenario.md` - Generated SPECS.md for this run
- `review-notes.md` - Client feedback and discussion
- `assets/` - Run-specific decision documents

**Run Lifecycle (Checkpoint-Based):**

```
Phase 1: INPUTS      → Create run folder, specify parameters
    ↓
● Checkpoint ●       → "Ready to generate?"
    ↓
Phase 2: GENERATE    → Produce scenario.md
    ↓
● Checkpoint ●       → "Review this section?"
    ↓
Phase 3: REVIEW      → Client reviews, provides feedback
    ↓
● Checkpoint ●       → "Approve or revise?"
    ↓
Phase 4: DECIDE      → Approve, reject, or iterate
```

**Two-Tier Knowledge System:**

| Location | Contains | Example |
|----------|----------|---------|
| `docs/reference/*.md` | **Global knowledge** - Features, pricing, limitations | "BBB needs 16GB RAM" |
| `run-NNN/assets/*.md` | **Run-specific** - How that knowledge applies to this run | "Using BBB because of timeline" |

- New learnings during a run should update global research files
- Run-specific decisions and trade-offs go in assets folder

**Run Workflow:**
1. Create run folder with `run-NNN.md` specifying inputs
2. **Consult research files** in `/docs/reference/*.md` for technologies in scope
3. **Snapshot questions state** - Document all open questions and assumptions
4. Generate `scenario.md` based on inputs + GATHER materials + research
5. **Create run-specific assets** in `assets/` documenting key decisions
6. Review with client, document feedback in `review-notes.md`
7. Record decisions and rationale in run file
8. Update status in `runs/RUN-INDEX.md`
9. If approved: copy scenario to `/runs/approved/SPECS.md` then to root `SPECS.md`

**Questions State Tracking:**

Each run captures the state of all open questions at run time:
- Which questions are Open, Deferred, or Resolved
- What assumption is made for each open question
- Impact of each assumption on the generated scenario

This enables future runs to compare what changed when questions get answered.

**Key Principles:**
- Runs are **collaborative** - pause at checkpoints for discussion
- Runs are **traceable** - every decision linked to inputs and rationale
- Runs are **iterative** - create new runs when assumptions change
- Later client docs override earlier ones when information contradicts
- Goal is to **minimize custom development time** by leveraging existing services

**Conflict Resolution (Document Precedence):**
- CD-004 overrides CD-003 overrides CD-002 overrides CD-001
- More recent documents reflect more current client thinking
- When in doubt, note the conflict and ask for clarification

**Run Scenarios:**

| Scenario | Description | Custom Dev | Third-Party Services |
|----------|-------------|------------|---------------------|
| `sc-001-fully-custom` | **Baseline** - No major SaaS | Maximum | Cloudflare, npm packages only |
| `sc-002-*` | Required services (Stream + BBB) | Medium | Mix of required + optional |
| `sc-NNN-*` | Additional scenarios as needed | Varies | Different trade-offs |

**Run is Complete When:**
- Client has reviewed scenario
- Client has approved or requested new run
- If approved: scenario copied to root `SPECS.md`
- Architecture documents finalized for selected scenario
- Ready for implementation handoff

### Page Flow Documentation (Added in RUN-001)

During RUN-001, we discovered the need for detailed page-by-page documentation to properly evaluate the scenario. This led to creating comprehensive page flow documents.

**Page Documentation Structure:**

```
runs/run-NNN/pages/
├── PAGES-INDEX.md           # Schema definition + page registry
├── page-CODE-name.md        # Individual page documentation
└── ...
```

**Page Codes:** Each page has a 3-4 letter code (e.g., HOME, CBRO, CDET) for:
- Concise cross-referencing between pages
- Compact Mermaid diagrams
- Quick reference in discussions

**Page File Schema:** Each page file documents:
- Purpose, URL, Access level, Priority
- Connections (incoming + outgoing navigation)
- Data requirements (DB entities and fields)
- UI sections with elements
- User stories fulfilled
- States & variations
- Mobile considerations
- Error handling
- Analytics events
- **Server Integration** (for pages calling external services)

**Page Categories:**
- Public pages (11): Visitor-accessible
- Authenticated pages (21): Logged-in users
- Role-specific pages (3): Creator, Admin, Moderator
- Admin SPA screens (7): CRUD interfaces within Admin SPA

### Feature Flags System (Added 2025-12-26)

All features are documented and architected upfront. Feature flags control what's enabled in each release - nothing is "out of scope" until explicitly flagged off.

**Database-Driven Flags:**
```sql
features (
  id TEXT PRIMARY KEY,       -- 'video_sessions', 'newsletters'
  name TEXT,                 -- Display name
  enabled BOOLEAN,           -- Global on/off
  allowed_roles TEXT[],      -- ['student', 'creator'] or ['*']
  requires TEXT[]            -- Dependencies on other features
)
```

**Client-Side Pattern:**
```typescript
// On app load: fetch features + user roles
// On page render: check canAccess('feature_id')
function canAccess(featureId: string): boolean {
  const feature = features[featureId];
  if (!feature?.enabled) return false;
  if (feature.allowed_roles.includes('*')) return true;
  return feature.allowed_roles.some(role => user.roles.includes(role));
}
```

**Key Documents:**
- `runs/run-001/FEATURE-FLAGS.md` - All 21 feature flags with dependencies
- `DB-SCHEMA.md` - Features table and related tables

**Technology Decisions:**
- Video Sessions: PlugNmeet
- Community Feed: Stream.io
- Course Chat: Custom WebSocket (Cloudflare Durable Objects)
- Payments: Stripe Connect
- Email: Resend

### Baseline/Overlay Model for Pages

To handle page variations across runs, we use a layered approach:

**Problem Solved:** Pages might differ between scenarios (some pages removed, sections changed, tech-specific details). Copying everything to each run creates duplication; keeping everything shared prevents run-specific variations.

**Solution: Base + Overlay**

```
Alpha-Peer/
├── baseline/                    # Created AFTER first run approval
│   ├── PAGES-CATALOG.md         # All possible pages with codes
│   ├── pages/                   # Stable parts only
│   └── DB-SCHEMA.md             # Full logical schema
│
├── runs/
│   └── run-NNN/
│       ├── pages/               # FULL detail for this run
│       └── schema-scope.md      # Which tables are in scope
│
└── output/                      # Composite for handoff (generated)
```

**Workflow:**
1. **RUN-001:** Create full page documentation in `runs/run-001/pages/`
2. **After approval:** Extract stable parts to `baseline/` folder
3. **Future runs:** Start with baseline, add overlay for differences
4. **Final output:** Merge baseline + approved run overlay

**What Goes Where:**

| Location | Contains |
|----------|----------|
| Baseline | Stable: page codes, names, URLs, core purpose, core data entities |
| Run Overlay | Variable: which pages in scope, sections included, tech-specific details |
| Output | Composite: complete documentation for implementation |

---

## Evolution of GATHER/RUN Approach

This section documents how the project methodology evolved, for context in future sessions.

### Why GATHER/RUN?

The project started with client documents containing requirements, mockups, and decisions. Rather than immediately writing SPECS.md, we needed a structured way to:
1. **Accumulate** information from multiple sources (34+ client documents)
2. **Research** technology options and trade-offs
3. **Generate** different scenarios based on technology choices
4. **Iterate** when assumptions change or new information arrives

This led to the two-phase approach:
- **GATHER:** Collect and organize all inputs
- **RUN:** Transform inputs into actionable specifications

### Why RUNs Instead of Direct SPECS.md?

Early attempts to write SPECS.md directly revealed problems:
- Open questions blocked progress
- Technology decisions affected multiple sections
- Client feedback required significant rewrites
- No way to compare alternatives

The RUN concept solves these by:
- **Snapshotting state:** Each run captures the questions state at that moment
- **Isolating decisions:** Run-specific assets document trade-offs
- **Enabling comparison:** Multiple runs can be compared
- **Supporting iteration:** Bad runs don't pollute good work

### How RUN-001 Shaped the Approach

RUN-001 (the first run) was used to:
1. Generate `scenario.md` - 14-section technical specification
2. Create run-specific assets for key decisions
3. **Establish the page flow documentation pattern** - 42 pages/screens
4. Define the page schema and code system
5. Plan the baseline/overlay model for future runs

This first run became the template for how runs work and what they produce.

---

## Workflow Notes

- **Client docs are read-only** - Reference them but don't modify originals
- **SPECS.md is the handoff document** - Update it as decisions are made
- **Architecture docs accumulate** - DB-SCHEMA, PAGES, COMPONENTS, DB-API, REMOTE-API grow during GATHER, finalize during RUN
- **Trace decisions to sources** - Link back to research, client docs, or learnings
- **file_holding/ is temporary** - Files staged here get processed and moved
- **Scenarios for comparison** - `/scenarios/` holds SPECS.md variants for client review

### Capturing Review Decisions (Added 2025-12-26)

When client decisions are made during review sessions (not via formal documents), they should still be captured for traceability:

1. **Create a virtual CD document** (e.g., CD-034) summarizing all decisions
2. **Extract goals** from implied requirements → GOALS.md
3. **Extract user stories** from user interactions → role-specific story files
4. **Update technical docs** (DB-SCHEMA, DB-API, pages, etc.)
5. **Cross-check** to ensure nothing was missed

This ensures all features can be traced back to a source document, even when decisions bypass the normal `/r-add-client-doc` workflow.

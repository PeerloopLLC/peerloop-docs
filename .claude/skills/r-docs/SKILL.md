---
name: r-docs
description: Update all project documentation
argument-hint: "[--recreate] - use conv artifacts for context"
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# Update Project Documentation

Execute at the end of a conv to update documentation affected by this conversation's changes.

**Dual-repo note:** In Peerloop's dual-repo layout, doc paths are local but code paths use `../Peerloop/` prefix. Adjust `find` and `git diff` commands accordingly.

---

## Live Context (auto-detected)

### What Changed
!`${CLAUDE_SKILL_DIR}/scripts/detect-changes.sh 2>/dev/null || echo "(change detection unavailable — use conv context)"`

### Documentation Gaps
!`${CLAUDE_SKILL_DIR}/scripts/sync-gaps.sh 2>/dev/null || echo "(gap detection unavailable — check manually)"`

### Tech Doc Sweep
!`${CLAUDE_SKILL_DIR}/scripts/tech-doc-sweep.sh 2>/dev/null || echo "(tech sweep unavailable — check manually)"`

### Development Environment
!`${CLAUDE_SKILL_DIR}/scripts/dev-env-scan.sh 2>/dev/null || echo "(dev env scan unavailable)"`

### Project Config
!`cat .claude/config.json 2>/dev/null || echo "(no config.json found — using defaults)"`

---

## Action Plan

Work through these steps in order. Skip any step where the Live Context shows no relevant changes.

1. **Fix documentation gaps** — The sync-gaps report lists concrete mismatches (undocumented scripts, routes, tests). Fix these first — they're the most deterministic.
2. **Review flagged tech docs** — The tech-doc-sweep report names specific vendor/architecture docs that may be stale. Skim each and update if needed.
3. **Walk the Change Detection Matrix** — For each category of changed files (from the "What Changed" report), check the matrix below and update the corresponding docs.
4. **Run remaining checklists** — Checklists 4-9 cover areas the scripts can't fully automate (patterns, policies, specs). Apply only those triggered by this conv.
5. **Review dev environment** — If the dev-env-scan flagged machine mentions, check if `docs/architecture/devcomputers.md` needs updating.

**If Live Context says "(unavailable)":** Fall back to conv context and work through all checklists manually.

---

## Arguments

**`--recreate`** (optional): When starting a new conv, gather extra context from recent conv artifacts.

When `$ARGUMENTS` contains `--recreate`, also read:
1. Most recent conv files (Learnings, Decisions, Dev) from `docs/sessions/YYYY-MM/`
2. Recent git commits beyond what detect-changes.sh captured

---

## Progress Tracking

**When called from `/r-eos`:** Update the existing "Run /r-docs" item when complete.

**When called standalone:** Add these to TodoWrite:
- Fix documentation gaps (from sync-gaps report)
- Review flagged tech docs (from tech-doc-sweep report)
- Walk change detection matrix for remaining areas
- Run applicable checklists (4-9)

Mark each `in_progress` when starting, `completed` when done.

---

## Change Detection Matrix

Use the **What Changed** report as primary input. This table maps change categories to their target docs:

| If You Changed... | Update These Docs |
|-------------------|-------------------|
| npm scripts in package.json | `docs/reference/CLI-QUICKREF.md`, relevant `docs/reference/CLI-*.md`, `docs/reference/SCRIPTS.md` |
| Script files in scripts/ | `docs/reference/SCRIPTS.md` |
| CLI options or commands | `docs/reference/CLI-QUICKREF.md`, relevant `docs/reference/CLI-*.md` |
| API endpoints (src/pages/api/) | API-*.md (see Route Mapping below), `docs/reference/CLI-QUICKREF.md` |
| Database patterns (src/lib/db/) | `docs/reference/API-DATABASE.md`, `docs/reference/DEVELOPMENT-GUIDE.md` |
| Auth patterns (src/lib/auth/) | `docs/reference/DEVELOPMENT-GUIDE.md` |
| Test files added/modified | `docs/reference/TEST-COVERAGE.md` |
| Phase/stage subtasks completed | *Run `/r-update-plan`* |
| New coding patterns/conventions | `docs/reference/DEVELOPMENT-GUIDE.md` |
| Framework component patterns | `docs/reference/DEVELOPMENT-GUIDE.md` |
| Skills or commands (.claude/) | CLAUDE.md (if user-facing) |
| **Page routes or navigation** | `docs/architecture/url-routing.md` — **Source of truth for routes** |
| **Page links or inter-page navigation** | `docs/architecture/page-connections.md` — Re-run `scripts/route-matrix.mjs` |
| Package versions or new packages | `docs/vendors/*.md` |
| Technology config or caveats | `docs/vendors/*.md` or `docs/architecture/*.md` |
| Machine-specific workaround | `docs/architecture/devcomputers.md` |
| **Access control or capability rules** | `docs/POLICIES.md` — Platform behavior policies |
| Page specifications | `research/run-001/pages/page-*.md` |
| Feature scope | `research/run-001/SCOPE.md` |
| Database schema design | `research/DB-GUIDE.md` |

---

## API Route Mapping

Peerloop API docs are split by route prefix. The authoritative mapping is in `${CLAUDE_SKILL_DIR}/scripts/route-mapping.txt` (shared with sync-gaps.sh). Summary:

| Route Prefix | Document In |
|--------------|-------------|
| `/api/auth/*` | `API-AUTH.md` |
| `/api/courses/*` | `API-COURSES.md` |
| `/api/users/*`, `/api/creators/*` | `API-USERS.md` |
| `/api/enrollments/*`, `/api/me/*` (except communities) | `API-ENROLLMENTS.md` |
| `/api/checkout/*`, `/api/stripe/*`, `/api/webhooks/*` | `API-PAYMENTS.md` |
| `/api/sessions/*`, `/api/teachers/*` | `API-SESSIONS.md` |
| `/api/homework/*`, `/api/submissions/*` | `API-HOMEWORK.md` |
| `/api/stats`, `/api/categories`, `/api/topics`, `/api/health/*` | `API-PLATFORM.md` |
| `/api/admin/*` | `API-ADMIN.md` |
| `/api/communities/*`, `/api/me/communities/*`, `/api/feeds/*` | `API-COMMUNITY.md` |
| `/api/recommendations/*` | `API-RECOMMENDATIONS.md` |
| Database helpers (`@lib/db`) | `API-DATABASE.md` |

All API docs live in `docs/reference/`. `API-REFERENCE.md` is the index.

---

## CLI Detail Files

| File | Commands Covered |
|------|------------------|
| `docs/reference/CLI-REFERENCE.md` | dev, build, db:*, cf:*, format, lint |
| `docs/reference/CLI-TESTING.md` | test, test:*, e2e |
| `docs/reference/CLI-MISC.md` | nvm, npm install, environment setup |

---

## Update Checklists

**Checklists 1-3** (CLI, API, Tests) are handled by the sync-gaps script. Use these only as fallback if the script was unavailable, or for formatting/quality details the script can't check.

### 1-3. CLI / API / Tests (script-covered)

If sync-gaps ran: act on its output. If not:
- CLI: compare `package.json` scripts against `docs/reference/CLI-QUICKREF.md`
- API: compare `src/pages/api/` routes against `docs/reference/API-*.md` (use route mapping above)
- Tests: compare `tests/` files against `docs/reference/TEST-COVERAGE.md`

### 4. Development Patterns Changed

**File:** `docs/reference/DEVELOPMENT-GUIDE.md`

**Triggers:**
- New database access patterns in `src/lib/db/`
- New auth utilities in `src/lib/auth/`
- New framework component patterns
- New API endpoint patterns
- Type safety conventions changed
- Testing strategy updates
- Environment variable additions

**If triggered:** Add new section with code examples and file locations.

### 5. Technology Documentation

**Already handled by the Tech Doc Sweep report.** If the sweep flagged docs, review and update them. If it was unavailable:
- Check if any packages were added/upgraded in `package.json`
- Check if tech configuration changed
- Find or create the relevant doc in `docs/vendors/` or `docs/architecture/`

### 6. Specification Documents

**Location:** `research/run-001/`

**If page design, features, or user flows changed:**
- Update relevant `page-*.md` or `SCOPE.md`

### 7. Database/API Design

**Location:** `research/`

**If database tables, fields, relationships, or API designs changed:**
- Update `research/DB-GUIDE.md` or `research/DB-API.md`

### 8. Platform Policies

**File:** `docs/POLICIES.md`

**If access control, capability rules, revocation behavior, or prescriptive business logic changed:**
- Add or update the relevant policy section
- These are prescriptive: if code contradicts a policy, the code is the bug

### 9. Page Connections

**File:** `docs/architecture/page-connections.md` (auto-generated)

**If pages, routes, or navigation links changed:**
- Re-run: `cd ../Peerloop && node scripts/route-matrix.mjs`
- Review the diff for unexpected changes

### 10. Development Environment

**Already handled by the dev-env-scan in the Live Context section above.** If it flagged machine mentions, review the conv files and update `docs/architecture/devcomputers.md` if new capabilities or workarounds were documented.

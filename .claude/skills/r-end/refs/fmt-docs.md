# Format Rules: Documentation Updates

Shared reference for the docs agent. Defines the change detection matrix, script paths, and update checklists.

---

## Scripts to Run

Run these scripts and act on their output. All paths are relative to the docs repo:

| Script | Path | Purpose |
|--------|------|---------|
| detect-changes.sh | `~/projects/peerloop-docs/.claude/skills/r-end/scripts/detect-changes.sh` | What changed in this conv |
| sync-gaps.sh | `~/projects/peerloop-docs/.claude/scripts/sync-gaps.sh` | Documentation gaps |
| tech-doc-sweep.sh | `~/projects/peerloop-docs/.claude/scripts/tech-doc-sweep.sh` | Stale tech docs |
| dev-env-scan.sh | `~/projects/peerloop-docs/.claude/skills/r-end/scripts/dev-env-scan.sh` | Dev environment changes |

---

## Scope (Conv 200 policy — read first)

You maintain **only `driftCheck` docs**. Everything else (`manual`, `archival`,
`generated`) is editorial or tool-owned and OUT OF SCOPE for this agent.

- Resolve any doc's category: `node ~/projects/peerloop-docs/.claude/scripts/docs-registry.mjs doc-category <relpath>`.
- **"No docs needed updating" is a valid and common outcome.** Most convs touch
  no drift-check docs. Do not manufacture edits.
- Update a drift-check doc's *prose* only when this conv made its stated scope
  *wrong* — not because a new pattern *could* be documented. Speculative
  "add a section" appends are the over-maintenance this policy removed.
- Several matrix rows below point at `manual` docs (`DEVELOPMENT-GUIDE.md`,
  `POLICIES.md`, vendor docs). Those rows are **editorial-only**: skip them
  unless the user explicitly asked for that doc to change this conv.

## Action Plan

> **Report drift-check gaps only.**
> If you find undocumented endpoints, scripts, or tests in a `driftCheck` doc's
> domain and won't fix them now — **report them** so the main context can
> TaskCreate them. Do NOT report gaps against `manual`/`archival`/vendor docs
> ("this vendor doc is stale" is by design, not a gap).

Work through these steps in order. Skip any step where no relevant changes occurred.

1. **Fix documentation gaps** — The sync-gaps report lists concrete mismatches (undocumented scripts, routes, tests). Fix these first — they're the most deterministic.
2. **Review flagged tech docs** — The tech-doc-sweep report names specific vendor/architecture docs that may be stale. Skim each and update if needed.
3. **Walk the Change Detection Matrix** — For each category of changed files (from the detect-changes report), check the matrix below and update the corresponding docs.
4. **Run remaining checklists** — Checklists 4-10 cover areas the scripts can't fully automate. Apply only those triggered by this conv.
5. **Review dev environment** — If the dev-env-scan flagged machine mentions, check if `docs/as-designed/devcomputers.md` needs updating.

---

## Change Detection Matrix

| If You Changed... | Update These Docs |
|-------------------|-------------------|
| npm scripts in package.json | `docs/reference/CLI-QUICKREF.md`, relevant `docs/reference/CLI-*.md`, `docs/reference/SCRIPTS.md` |
| Script files in scripts/ | `docs/reference/SCRIPTS.md` |
| CLI options or commands | `docs/reference/CLI-QUICKREF.md`, relevant `docs/reference/CLI-*.md` |
| API endpoints (src/pages/api/) | API-*.md (see Route Mapping below), `docs/reference/CLI-QUICKREF.md` |
| Database patterns (src/lib/db/) | `docs/reference/API-DATABASE.md` (driftCheck); `DEVELOPMENT-GUIDE.md` *(manual — editorial only)* |
| Auth patterns (src/lib/auth/) | `docs/reference/DEVELOPMENT-GUIDE.md` *(manual — editorial only; skip)* |
| Test files added/modified | `docs/reference/TEST-COVERAGE.md` |
| Phase/stage subtasks completed | *(handled by update-plan agent — do NOT touch PLAN.md)* |
| New coding patterns/conventions | `docs/reference/DEVELOPMENT-GUIDE.md` *(manual — editorial only; skip)* |
| Framework component patterns | `docs/reference/DEVELOPMENT-GUIDE.md` *(manual — editorial only; skip)* |
| Skills or commands (.claude/) | CLAUDE.md (if user-facing) |
| **Page routes or navigation** | `docs/as-designed/url-routing.md` — **Source of truth for routes** |
| **Page links or inter-page navigation** | `docs/as-designed/page-connections.md` — Re-run `scripts/route-matrix.mjs` |
| Package versions or new packages | `docs/reference/*.md` |
| Technology config or caveats | `docs/reference/*.md` or `docs/as-designed/*.md` |
| Machine-specific workaround | `docs/as-designed/devcomputers.md` |
| **Access control or capability rules** | `docs/POLICIES.md` *(manual — editorial only; update deliberately, not auto)* |
| Page specifications | `docs/as-designed/run-001/pages/page-*.md` |
| Feature scope | `docs/as-designed/run-001/SCOPE.md` |
| Database schema design | `docs/reference/DB-GUIDE.md` |

---

## API Route Mapping

Peerloop API docs are split by route prefix. The authoritative mapping is in `~/projects/peerloop-docs/.claude/scripts/route-mapping.txt`.

| Route Prefix | Document In |
|--------------|-------------|
| `/api/auth/*` | `API-AUTH.md` |
| `/api/courses/*` | `API-COURSES.md` |
| `/api/users/*`, `/api/creators/*` | `API-USERS.md` |
| `/api/enrollments/*`, `/api/me/*` (except communities) | `API-ENROLLMENTS.md` |
| `/api/checkout/*`, `/api/stripe/*`, `/api/webhooks/*` | `API-PAYMENTS.md` |
| `/api/sessions/*`, `/api/teachers/*` | `API-SESSIONS.md` |
| `/api/homework/*`, `/api/submissions/*` | `API-HOMEWORK.md` |
| `/api/stats`, `/api/topics`, `/api/tags`, `/api/health/*` | `API-PLATFORM.md` |
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

**Checklists 1-3** (CLI, API, Tests) are handled by the sync-gaps script. Use only as fallback if the script was unavailable.

### 4. Development Patterns Changed *(manual — editorial only)*

**File:** `docs/reference/DEVELOPMENT-GUIDE.md` — category `manual`.

**Conv 200 policy:** this agent does NOT auto-append to DEVELOPMENT-GUIDE. It is
a reference that's updated *deliberately* by the user/main context when an
existing documented pattern becomes wrong — not speculatively expanded every
conv that introduces a new pattern. **Skip unless explicitly asked.**

### 5. Technology Documentation *(vendor docs are manual — mostly skip)*

The Tech Doc Sweep is now category-gated: it only flags `driftCheck` docs
(architecture docs in `docs/as-designed/`), never vendor docs. If the sweep
flags an architecture doc whose scope is genuinely wrong, update it. Vendor docs
(`stripe.md`, `stream.md`, etc.) are snapshots — the vendor's site is canonical;
do not maintain them here. Do NOT create a new doc that duplicates a vendor's
own documentation.

### 6. Specification Documents

**Location:** `docs/as-designed/run-001/`

**If page design, features, or user flows changed:** Update relevant `page-*.md` or `SCOPE.md`.

### 7. Database/API Design

**Location:** `docs/reference/`

**If database tables, fields, relationships, or API designs changed:** Update `docs/reference/DB-GUIDE.md` or `docs/reference/DB-API.md`.

### 8. Platform Policies *(manual — editorial only)*

**File:** `docs/POLICIES.md` — category `manual`.

POLICIES is prescriptive (if code contradicts a policy, the code is the bug), so
it changes *deliberately* when the user decides a rule changed — not as an
automatic side effect of this agent. **Skip unless explicitly asked** to record
a policy change this conv.

### 9. Page Connections

**File:** `docs/as-designed/page-connections.md` (auto-generated)

**If pages, routes, or navigation links changed:** Re-run: `cd ../Peerloop && node scripts/route-matrix.mjs`. Review the diff for unexpected changes.

### 9b. Route ↔ API Map

**Files:** `docs/as-designed/route-api-map.md` (auto-generated) + `tests/plato/route-map.generated.ts`

**If API endpoints, fetch calls, or page components changed:** Re-run: `cd ../Peerloop && node scripts/route-api-map.mjs`. This regenerates both the Markdown reference doc and the TypeScript lookup used by PLATO browser-runs. Review the diff — new API calls or changed nav paths may need attention.

### 10. Development Environment

**If the dev-env-scan flagged machine mentions:** Review conv files and update `docs/as-designed/devcomputers.md` if new capabilities or workarounds were documented.

---

## Important Constraint

**Do NOT touch PLAN.md or plan/COMPLETED.md.** Those files are managed exclusively by the update-plan agent.

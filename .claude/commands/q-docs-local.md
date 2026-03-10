---
description: Project-specific docs (extends /q-docs)
argument-hint: ""
---

# Peerloop Documentation Updates

**Extends:** `/q-docs` (run that first for standard checks)

**Configuration** (features, paths) comes from `.claude/config.json`.

This skill handles Peerloop-specific documentation not covered by the standard `/q-docs` checks.

---

## Change Detection Matrix

| If You Changed... | Update These Docs |
|-------------------|-------------------|
| API endpoints | See **API Route Mapping** below |
| **Page routes or navigation** | `docs/architecture/url-routing.md` ← **Source of truth for routes** |
| **Page links or inter-page navigation** | `docs/architecture/page-connections.md` ← Re-run `scripts/route-matrix.mjs` |
| Package versions or new packages | `docs/vendors/*.md` |
| Technology configuration | `docs/vendors/*.md` or `docs/architecture/*.md` |
| Discovered tech caveat/gotcha | `docs/vendors/*.md` or `docs/architecture/*.md` |
| Machine-specific workaround | `docs/architecture/devcomputers.md` |
| **Access control or capability rules** | `docs/POLICIES.md` ← Platform behavior policies |
| Page specifications | `research/run-001/pages/page-*.md` |
| Feature scope | `research/run-001/SCOPE.md` |
| Database schema design | `research/DB-GUIDE.md` |

---

## API Route Mapping

Peerloop API docs are split by route prefix. Use this table to find the right file:

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

`API-REFERENCE.md` serves as the index linking to all split files.

---

## Files to Monitor

| File/Pattern | Purpose | When to Update |
|--------------|---------|----------------|
| `docs/POLICIES.md` | Platform behavior policies (access control, business rules) | Access control changes, capability rules, revocation behavior |
| `docs/architecture/page-connections.md` | Inter-page navigation map (auto-generated) | New pages, changed links, navigation restructuring → re-run `scripts/route-matrix.mjs` |
| `docs/vendors/*.md`, `docs/architecture/*.md` | Technology decisions & integration patterns | Package changes, new tech, caveats discovered |
| `docs/architecture/devcomputers.md` | Machine-specific config & workarounds | Session files mention `MacMiniM4-Pro` or `MacMiniM4` |
| `docs/vendors/comp-*.md` | Technology comparisons | Evaluated new alternatives |
| `research/run-001/pages/*.md` | Page specifications | Page design changes |
| `research/run-001/SCOPE.md` | MVP feature scope | Scope changes |
| `research/DB-GUIDE.md` | Database entity design | Schema changes |
| `research/DB-API.md` | Planned API endpoints | API design changes |

---

## Update Checklist

### 1. Technology Documentation

**Location:** `docs/vendors/` (vendor/library docs) and `docs/architecture/` (architecture docs)

**Check if any of these occurred:**
- [ ] Added new package to package.json?
- [ ] Upgraded existing package version?
- [ ] Changed technology configuration?
- [ ] Discovered limitation or gotcha?
- [ ] Found better integration pattern?

**If YES:**
- Find or create the relevant doc in `docs/vendors/` or `docs/architecture/`
- Update relevant sections (version, caveats, patterns)

---

### 2. Specification Documents

**Location:** `research/run-001/`

**Check if any of these occurred:**
- [ ] Changed page design or behavior?
- [ ] Added/removed features from scope?
- [ ] Modified user flows?

**If YES:**
- Update relevant `page-*.md` or `SCOPE.md`

---

### 3. Database/API Design

**Location:** `research/`

**Check if any of these occurred:**
- [ ] Added new database tables or fields?
- [ ] Changed entity relationships?
- [ ] Designed new API endpoints?

**If YES:**
- Update `DB-SCHEMA.md` or `DB-API.md`

---

### 4. Platform Policies

**File:** `docs/POLICIES.md`

**Check if any of these occurred:**
- [ ] Changed access control gates or permission checks?
- [ ] Established rules about what users/roles can or cannot do?
- [ ] Changed revocation, suspension, or capability behavior?
- [ ] Made business logic decisions that should be prescriptive?

**If YES:**
- Add or update the relevant policy section in `docs/POLICIES.md`
- These are prescriptive: if code contradicts a policy, the code is the bug

---

### 5. Page Connections

**File:** `docs/architecture/page-connections.md` (auto-generated)

**Check if any of these occurred:**
- [ ] Added new pages or routes?
- [ ] Changed navigation links between pages?
- [ ] Added/removed sidebar or navbar items?

**If YES:**
- Re-run: `cd ../Peerloop && node scripts/route-matrix.mjs`
- Review the diff for unexpected changes

---

### 6. Development Environment (Auto-Scan)

**File:** `docs/architecture/devcomputers.md`

**Scan session files for machine name mentions:**

```bash
# Get current month for session folder
MONTH=$(date '+%Y-%m')

# Scan this session's files for machine names
grep -l -E "(MacMiniM4-Pro|MacMiniM4)" docs/sessions/$MONTH/*.md 2>/dev/null
```

**If matches found:**
- Review the matched session files
- Check if they document new workarounds or machine-specific behavior
- Update `docs/architecture/devcomputers.md` if:
  - [ ] New capability noted for `MacMiniM4-Pro` or `MacMiniM4`
  - [ ] D1 local/remote behavior documented
  - [ ] Cloudflare/Wrangler compatibility noted

**Standard machine names** (from DEVELOPMENT-GUIDE.md):
| Name | Machine |
|------|---------|
| `MacMiniM4-Pro` | Mac Mini M4 Pro (64GB) |
| `MacMiniM4` | Mac Mini M4 (24GB) |

---

### 7. Tech Doc Sweep (Dynamic)

**Purpose:** Catch domain code changes that should be reflected in a corresponding vendor or architecture doc. Unlike section 1 (which triggers on package/config changes), this sweep triggers on **any code change** and dynamically discovers relevant docs.

**How to run:**

#### Step 1: Discover all vendor and architecture docs

```bash
ls docs/vendors/*.md docs/architecture/*.md
```

#### Step 2: Build a topic index

For each doc, read the **first line** (title) to extract the topic keyword. Build a lookup of filename → topic.

#### Step 3: Identify code files changed this session

Use session context (files edited, endpoints added/modified, libs changed). If context is unclear:

```bash
cd ../Peerloop && git diff --name-only HEAD~1
```

#### Step 4: Match changed code against tech docs

For each changed code file, check if any vendor/architecture doc's topic is relevant. Use these heuristics:

| Code file pattern | Likely topic keywords |
|-------------------|-----------------------|
| `**/webhooks/bbb*`, `**/video/*`, `**/sessions/*/join*` | bigbluebutton, bbb, video, session |
| `**/webhooks/stripe*`, `**/stripe/*`, `**/checkout/*`, `**/enrollment*` | stripe, payment, enrollment |
| `**/feeds/*`, `**/communities/*`, `**/stream*` | stream, feed, community |
| `**/email*`, `**/emails/*` | resend, email |
| `**/auth/*`, `**/lib/auth*` | auth |
| `**/booking*`, `**/sessions/*`, `**/availability*` | booking, session, availability, calendar |
| `**/*.astro`, `**/layouts/*` | astro |
| `migrations/*` | migration |
| `wrangler.toml`, `**/lib/db/*` | cloudflare, d1 |
| `**/ratings/*`, `**/rating*` | rating, feedback |

If a doc's topic overlaps with a changed code path, flag it for review.

#### Step 5: For each flagged tech doc

Skim the doc (focus on File Map, Integration Patterns, and endpoint/function listings) and check:
- [ ] Does the doc reflect the new/changed endpoints or functions?
- [ ] Should a new section be added (e.g., healing pattern, caveat, architecture note)?
- [ ] Is the File Map still accurate?

**Skip if:** The change is purely internal (refactor with identical behavior) and the doc already accurately describes the system.

#### Step 6: Report

List which docs were checked and whether any needed updates:

```
Doc Sweep:
  ✅ docs/vendors/bigbluebutton.md — updated (healing section added)
  ✅ docs/architecture/session-booking.md — updated (completeSession, file map)
  ⬚ docs/vendors/stripe.md — not affected
```

---

## Notes

- This file is project-specific and should be customized per project
- Standard docs (CLI-*, API-*.md, TEST-COVERAGE, etc.) are handled by `/q-docs`
- API docs are split by route prefix (API-AUTH.md, API-ADMIN.md, etc.) - see `/q-docs` for routing
- Add new entries to the Change Detection Matrix as project evolves
- Doc sweep (section 7) is dynamic — no maintenance needed when new docs are added

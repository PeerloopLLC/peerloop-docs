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
| **Page routes or navigation** | `docs/tech/tech-021-url-routing.md` ← **Source of truth for routes** |
| Package versions or new packages | `docs/tech/tech-NNN-*.md` |
| Technology configuration | `docs/tech/tech-NNN-*.md` |
| Discovered tech caveat/gotcha | `docs/tech/tech-NNN-*.md` |
| Machine-specific workaround | `docs/tech/tech-013-devcomputers.md` |
| Page specifications | `research/run-001/pages/page-*.md` |
| Feature scope | `research/run-001/SCOPE.md` |
| Database schema design | `research/DB-SCHEMA.md` |

---

## API Route Mapping

Peerloop API docs are split by route prefix. Use this table to find the right file:

| Route Prefix | Document In |
|--------------|-------------|
| `/api/auth/*` | `API-AUTH.md` |
| `/api/courses/*` | `API-COURSES.md` |
| `/api/users/*`, `/api/creators/*` | `API-USERS.md` |
| `/api/enrollments/*`, `/api/me/*` | `API-ENROLLMENTS.md` |
| `/api/checkout/*`, `/api/stripe/*`, `/api/webhooks/*` | `API-PAYMENTS.md` |
| `/api/sessions/*`, `/api/student-teachers/*` | `API-SESSIONS.md` |
| `/api/homework/*`, `/api/submissions/*` | `API-HOMEWORK.md` |
| `/api/stats`, `/api/categories`, `/api/health/*` | `API-PLATFORM.md` |
| `/api/admin/*` | `API-ADMIN.md` |
| `/api/communities/*`, `/api/feeds/*` | `API-COMMUNITY.md` |
| Database helpers (`@lib/db`) | `API-DATABASE.md` |

`API-REFERENCE.md` serves as the index linking to all split files.

---

## Files to Monitor

| File/Pattern | Purpose | When to Update |
|--------------|---------|----------------|
| `docs/tech/tech-*.md` | Technology decisions & integration patterns | Package changes, new tech, caveats discovered |
| `docs/tech/tech-013-devcomputers.md` | Machine-specific config & workarounds | Session files mention `MacMiniM4-Pro` or `MacMiniM4` |
| `docs/tech/comp-*.md` | Technology comparisons | Evaluated new alternatives |
| `research/run-001/pages/*.md` | Page specifications | Page design changes |
| `research/run-001/SCOPE.md` | MVP feature scope | Scope changes |
| `research/DB-SCHEMA.md` | Database entity design | Schema changes |
| `research/DB-API.md` | Planned API endpoints | API design changes |

---

## Update Checklist

### 1. Technology Documentation

**Location:** `docs/tech/`

**Check if any of these occurred:**
- [ ] Added new package to package.json?
- [ ] Upgraded existing package version?
- [ ] Changed technology configuration?
- [ ] Discovered limitation or gotcha?
- [ ] Found better integration pattern?

**If YES:**
- Find or create `tech-NNN-[technology].md`
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

### 4. Development Environment (Auto-Scan)

**File:** `docs/tech/tech-013-devcomputers.md`

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
- Update `docs/tech/tech-013-devcomputers.md` if:
  - [ ] New capability noted for `MacMiniM4-Pro` or `MacMiniM4`
  - [ ] D1 local/remote behavior documented
  - [ ] Cloudflare/Wrangler compatibility noted

**Standard machine names** (from DEVELOPMENT-GUIDE.md):
| Name | Machine |
|------|---------|
| `MacMiniM4-Pro` | Mac Mini M4 Pro (64GB) |
| `MacMiniM4` | Mac Mini M4 (24GB) |

---

## Notes

- This file is project-specific and should be customized per project
- Standard docs (CLI-*, API-*.md, TEST-COVERAGE, etc.) are handled by `/q-docs`
- API docs are split by route prefix (API-AUTH.md, API-ADMIN.md, etc.) - see `/q-docs` for routing
- Add new entries to the Change Detection Matrix as project evolves

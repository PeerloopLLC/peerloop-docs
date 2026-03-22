# Docs Reorganization Map

**Date:** 2026-03-09 (Session 362)
**Purpose:** Old-path → new-path lookup for interpreting session logs and historical references.

Session logs before this date use old paths. Consult this map to find current file locations.

## Folder Changes

| Old Folder | New Folder | Contents |
|------------|-----------|----------|
| `docs/tech/` | `docs/vendors/` | External service/library decisions |
| `docs/tech/` | `docs/architecture/` | Internal design patterns & decisions |
| `docs/reference/` | `docs/reference/` | Unchanged |
| `docs/guides/` | `docs/guides/` | Unchanged |
| `docs/sessions/` | `docs/sessions/` | Unchanged |

## docs/tech/ → docs/vendors/ (19 files)

| Old Path | New Path |
|----------|----------|
| `docs/tech/tech-001-bigbluebutton.md` | `docs/vendors/bigbluebutton.md` |
| `docs/tech/tech-002-stream.md` | `docs/vendors/stream.md` |
| `docs/tech/tech-003-stripe.md` | `docs/vendors/stripe.md` |
| `docs/tech/tech-004-resend.md` | `docs/vendors/resend.md` |
| `docs/tech/tech-005-tailwindcss.md` | `docs/vendors/tailwindcss.md` |
| `docs/tech/tech-006-plugnmeet.md` | `docs/vendors/plugnmeet.md` |
| `docs/tech/tech-007-posthog.md` | `docs/vendors/posthog.md` |
| `docs/tech/tech-008-sentry.md` | `docs/vendors/sentry.md` |
| `docs/tech/tech-009-react-big-calendar.md` | `docs/vendors/react-big-calendar.md` |
| `docs/tech/tech-010-auth-libraries.md` | `docs/vendors/auth-libraries.md` |
| `docs/tech/tech-011-cloudflare.md` | `docs/vendors/cloudflare.md` |
| `docs/tech/tech-012-cloudinary.md` | `docs/vendors/cloudinary.md` |
| `docs/tech/tech-016-astrojs.md` | `docs/vendors/astrojs.md` |
| `docs/tech/tech-017-reactjs.md` | `docs/vendors/reactjs.md` |
| `docs/tech/tech-019-charting.md` | `docs/vendors/charting.md` |
| `docs/tech/tech-025-google-oauth.md` | `docs/vendors/google-oauth.md` |
| `docs/tech/tech-029-cloudflare-kv.md` | `docs/vendors/cloudflare-kv.md` |
| `docs/tech/tech-030-react-day-picker.md` | `docs/vendors/react-day-picker.md` |
| `docs/tech/comp-001-cloudflare-vs-vercel.md` | `docs/vendors/comp-cloudflare-vs-vercel.md` |

## docs/tech/ → docs/architecture/ (13 files)

| Old Path | New Path |
|----------|----------|
| `docs/tech/tech-013-devcomputers.md` | `docs/architecture/devcomputers.md` |
| `docs/tech/tech-014-data-fetching.md` | `docs/architecture/data-fetching.md` |
| `docs/tech/tech-015-dev-setup.md` | `docs/architecture/dev-setup.md` |
| `docs/tech/tech-018-messaging.md` | `docs/architecture/messaging.md` |
| `docs/tech/tech-020-state-management.md` | `docs/architecture/state-management.md` |
| `docs/tech/tech-021-url-routing.md` | `docs/architecture/url-routing.md` |
| `docs/tech/tech-022-ratings-feedback.md` | `docs/architecture/ratings-feedback.md` |
| `docs/tech/tech-024-migrations.md` | `docs/architecture/migrations.md` |
| `docs/tech/tech-026-env-vars-secrets.md` | `docs/architecture/env-vars-secrets.md` |
| `docs/tech/tech-027-auth-sessions.md` | `docs/architecture/auth-sessions.md` |
| `docs/tech/tech-028-image-handling.md` | `docs/architecture/image-handling.md` |
| `docs/tech/tech-031-availability-calendar.md` | `docs/architecture/availability-calendar.md` |
| `docs/tech/tech-032-session-booking.md` | `docs/architecture/session-booking.md` |

## Merged Files

| Old Path | Merged Into |
|----------|------------|
| `docs/tech/CACHE.md` | `docs/architecture/state-management.md` (structural guard section added) |

## Other Moved Files

| Old Path | New Path |
|----------|----------|
| `docs/SCHEMA-DIAGRAM.md` | `docs/architecture/schema-diagram.md` |

## Root Files Moved

| Old Path | New Path |
|----------|----------|
| `DECISIONS.md` | `docs/DECISIONS.md` |
| `GLOSSARY.md` | `docs/GLOSSARY.md` |
| `POLICIES.md` | `docs/POLICIES.md` |
| `BEST-PRACTICES.md` | `docs/reference/BEST-PRACTICES.md` |
| `ORIG-PAGES-MAP.md` | `docs/architecture/orig-pages-map.md` |
| `PAGE-CONNECTIONS.md` | `docs/architecture/page-connections.md` |
| `ROUTE-STORIES.md` | `docs/architecture/route-stories.md` |
| `SITE-MAP.md` | `docs/architecture/site-map.md` |
| `USER-STORIES-MAP.md` | `research/user-stories-map.md` |

## Root Files Unchanged

| File | Reason |
|------|--------|
| `CLAUDE.md` | CC configuration, must be root |
| `PLAN.md` | Active work tracking |
| `COMPLETED_PLAN.md` | Companion to PLAN.md |
| `CURRENT-BLOCK-PLAN.md` | Cross-session persistence |
| `SESSION-INDEX.md` | Session tracking |
| `DOC-DECISIONS.md` | Meta-doc about docs repo (formerly PLAYBOOK.md) |

---

## Reorg 2: Standardized Folder Names (2026-03-22)

**Purpose:** Align peerloop-docs folder naming with cross-project standard (matching prod-helpers convention).

### Folder Changes

| Old Folder | New Folder | Notes |
|------------|-----------|-------|
| `docs/architecture/` | `docs/as-designed/` | 20 files moved |
| `docs/vendors/` | `docs/reference/` | 19 files merged into existing reference/ |
| `docs/guides/` | `docs/guides/` | Unchanged |
| `docs/sessions/` | `docs/sessions/` | Unchanged |

### Root File Renames

| Old Path | New Path |
|----------|----------|
| `PLAYBOOK.md` | `DOC-DECISIONS.md` |

### Session File Timestamp Normalization

All 698 session files renamed to compact `YYYYMMDD_HHMM {Type}.md` format.
24 files skipped (bare session numbers like `259 Decisions.md`, no date to extract).

| Old Format | Example | New Format |
|------------|---------|------------|
| `YYYY-MM-DD_HH-MM-SS` | `2025-12-16_16-18-47 Dev.md` | `20251216_1618 Dev.md` |
| `YYYY-MM-DD HH.MM` | `2026-02-01 09.08 Decisions.md` | `20260201_0908 Decisions.md` |
| `YYYY-MM-DD_HHMM` | `2026-03-01_0725 Decisions.md` | `20260301_0725 Decisions.md` |
| `YYYYMMDD-HHMM` | `20260206-1319 Decisions.md` | `20260206_1319 Decisions.md` |

### docs/architecture/ → docs/as-designed/ (20 files)

| Old Path | New Path |
|----------|----------|
| `docs/architecture/*.md` | `docs/as-designed/*.md` |

Files: auth-sessions, availability-calendar, data-fetching, dev-setup, devcomputers, env-vars-secrets, feeds, image-handling, messaging, migrations, orig-pages-map, page-connections, ratings-feedback, route-stories, schema-diagram, session-booking, session-room, skills-system, state-management, url-routing

### docs/vendors/ → docs/reference/ (19 files merged)

| Old Path | New Path |
|----------|----------|
| `docs/vendors/*.md` | `docs/reference/*.md` |

Files: astrojs, auth-libraries, bigbluebutton, charting, cloudflare, cloudflare-kv, cloudinary, comp-cloudflare-vs-vercel, google-oauth, plugnmeet, posthog, react-big-calendar, react-day-picker, reactjs, resend, sentry, stream, stripe, tailwindcss

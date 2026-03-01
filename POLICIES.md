# POLICIES.md

This document defines **platform behavior policies** — the rules governing user capabilities, access control, and business logic. These are product decisions that guide implementation.

For architectural/implementation decisions, see `DECISIONS.md`. For docs-repo conventions, see `PLAYBOOK.md`.

**Last Updated:** 2026-03-01 Session 319 (Creator access control policies)

---

## How This Document Works

- **Prescriptive:** These policies define what the code SHOULD do. If code contradicts a policy, the code is the bug.
- **Organized by Domain:** Grouped by feature area (creators, payments, etc.)
- **Dates Included:** Each policy shows when it was established and which session
- **Latest Wins:** If a newer policy contradicts an older one, only the newer policy appears here

---

## 1. Creator Access Control

### Creator Permission vs Creator State
**Date:** 2026-03-01 (Session 319)

There are two distinct concepts for "is creator":

| Concept | Source | Meaning |
|---------|--------|---------|
| **Permission** (`can_create_courses` flag) | Set by admin approval | User MAY create courses |
| **State** (has existing courses) | Derived from data | User HAS created courses |

These are used differently depending on the action:

| Action Type | Gate | Rationale |
|-------------|------|-----------|
| **Create** new course or community | Permission only (`can_create_courses = 1`) | Only users with active permission can create new resources |
| **View/manage** dashboard, course list, earnings, communities, analytics | Permission OR State (`can_create_courses = 1 OR has_courses`) | Users must be able to access their existing content regardless of current permission status |

### Creator Revocation Policy
**Date:** 2026-03-01 (Session 319)

When an admin revokes a creator's permission (`can_create_courses = 0`):

- **Blocked:** Creating new courses, creating new communities
- **Retained:** Full access to existing courses and communities — viewing, editing, managing S-Ts, viewing analytics, managing earnings, managing community moderators
- **Mechanism:** Existing course/community endpoints use ownership checks (Pattern D: `creator_id = userId`), which are unaffected by the permission flag

### Admin Course Creation for Users
**Date:** 2026-03-01 (Session 319)

When admin creates a course on behalf of a user (`POST /api/admin/courses`), the target user must have `can_create_courses = 1`. The admin cannot override this — they must first grant the permission, then create the course. This is an intentional safeguard against accidentally creating content for revoked creators.

### Creator Course Limit (Future)
**Date:** 2026-03-01 (Session 319)

New creators should have a default limit on total courses they can create (proposed default: 3). Admin can adjust the limit per user. This is tracked as deferred item COURSE-LIMIT in PLAN.md.

### Analytics Empty State
**Date:** 2026-03-01 (Session 319)

When a creator has zero courses, the analytics page (`/creating/analytics`) shows a friendly empty state with a link to create their first course, rather than firing analytics API calls that would return empty data. The course count is checked client-side before making analytics requests.

---

## 2. Email Sending

### Verified Sending Domain
**Date:** 2026-03-01 (Session 319)

All transactional email is sent from `Peerloop <noreply@send.peerloop.com>` via Resend. The sending domain is `send.peerloop.com` (verified subdomain), not the root `peerloop.com`. The from address is centralized in `src/lib/email.ts`.

See `docs/tech/tech-004-resend.md` for domain setup details and the misleading error message caveat.

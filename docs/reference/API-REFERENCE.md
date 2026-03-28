# API Reference

Complete documentation for all API endpoints and database access patterns. For CLI commands, see [CLI-QUICKREF.md](CLI-QUICKREF.md).

---

## Quick Reference

| Document | Routes | Description |
|----------|--------|-------------|
| [API-AUTH.md](API-AUTH.md) | `/api/auth/*` | Authentication, OAuth, sessions |
| [API-COURSES.md](API-COURSES.md) | `/api/courses/*` | Course listing, details, reviews, curriculum, resources, availability summary |
| [API-USERS.md](API-USERS.md) | `/api/users/*`, `/api/creators/*` | User and creator profiles, user search |
| [API-ENROLLMENTS.md](API-ENROLLMENTS.md) | `/api/enrollments/*`, `/api/me/*` | Enrollments, progress, dashboards |
| [API-PAYMENTS.md](API-PAYMENTS.md) | `/api/checkout/*`, `/api/stripe/*`, `/api/webhooks/*` | Payments, Stripe Connect, webhooks |
| [API-SESSIONS.md](API-SESSIONS.md) | `/api/sessions/*`, `/api/session-invites/*`, `/api/teachers/*` | Video sessions, booking, availability, instant session invites |
| [API-HOMEWORK.md](API-HOMEWORK.md) | `/api/homework/*`, `/api/submissions/*` | Assignments, submissions, grading |
| [API-MESSAGES.md](API-MESSAGES.md) | `/api/conversations/*` | Direct messaging, conversations |
| [API-PLATFORM.md](API-PLATFORM.md) | `/api/stats`, `/api/topics`, `/api/tags`, `/api/health/*`, `/api/certificates/*`, `/api/debug/*` | Platform data, topics, tags, marketing, health checks, certificate verification, debug |
| [API-ADMIN.md](API-ADMIN.md) | `/api/admin/*` | Admin CRUD operations (requires admin role) |
| [API-COMMUNITY.md](API-COMMUNITY.md) | `/api/communities/*`, `/api/me/communities/*`, `/api/feeds/*`, `/api/stream/*`, `/api/flags` | Communities, feeds, Stream.io token, content flagging |
| [API-RECOMMENDATIONS.md](API-RECOMMENDATIONS.md) | `/api/recommendations/*` | Personalized course & community recommendations |
| [API-DATABASE.md](API-DATABASE.md) | `@lib/db` | D1 query helpers, pagination |

---

## Overview

| Category | Base Path | Description |
|----------|-----------|-------------|
| Authentication | `/api/auth/*` | User auth, OAuth, sessions |
| Courses | `/api/courses/*` | Course listing, details, reviews, curriculum, resources, availability summary |
| Creators | `/api/creators/*` | Creator listing, profiles |
| Users | `/api/users/*` | User listing, profiles, search |
| Messages | `/api/conversations/*` | Direct messaging between users |
| Enrollments | `/api/enrollments/*`, `/api/me/enrollments` | Enrollment listing, progress tracking |
| Creator Dashboard | `/api/me/creator-dashboard` | Creator dashboard aggregated data |
| Creator Earnings | `/api/me/creator-earnings` | Creator 15% royalty earnings |
| Creator Analytics | `/api/me/creator-analytics/*` | Creator analytics charts and metrics |
| Teacher Dashboard | `/api/me/teacher-dashboard` | Teacher dashboard aggregated data |
| Teacher Course Detail | `/api/teaching/courses/[courseId]` | Per-course teacher view (stats, students, sessions, reviews) |
| Teacher Course Resources | `/api/teaching/courses/[courseId]/resources` | Course materials with module grouping (teacher-specific) |
| Sessions | `/api/sessions/*` | Session booking, join, rating (BBB integration) |
| Homework | `/api/homework/*`, `/api/submissions/*` | Assignments, submissions, grading |
| Resources | `/api/resources/*` | File downloads from R2 storage |
| Checkout | `/api/checkout/*` | Stripe Checkout sessions |
| Stripe Connect | `/api/stripe/*` | Connected account management |
| Webhooks | `/api/webhooks/*` | External service webhooks (Stripe, BBB) |
| Teachers | `/api/teachers/*` | Teacher listing, availability, reviews |
| Reviews | `/api/reviews/*` | Review responses (Teacher/Creator reply to reviews) |
| Communities | `/api/communities/*` | Community listing, detail, members, moderators, resources |
| Feeds | `/api/feeds/*` | Stream.io activity feeds (townhall, instructor, course) |
| Platform | `/api/stats`, `/api/topics`, `/api/tags`, `/api/testimonials`, `/api/leaderboard` | Platform data, topics, tags, rankings |
| Onboarding | `/api/me/onboarding-profile` | Member onboarding profile and topic interests |
| Recommendations | `/api/recommendations/*` | Personalized course & community recommendations |
| Certificates | `/api/certificates/[id]/verify` | Public certificate verification |
| Stories | `/api/stories`, `/api/stories/[id]` | Success stories |
| Health | `/api/health/*` | System health checks (D1, R2, KV) |
| Admin | `/api/admin/*` | Admin CRUD operations (requires admin role) |
| Database | `@lib/db` | D1 query helpers |

**Important:** All data APIs require D1 database connectivity. If D1 is unavailable, APIs return `503 Service Unavailable` (no mock data fallback). Use `/api/health/db` to verify connectivity.

---

## Error Response Format

All API errors follow this format:

```json
{
  "error": "Human-readable error message"
}
```

---

## Authentication Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Client    │────▶│  /register  │────▶│   Create    │
│             │     │  or /login  │     │   Session   │
└─────────────┘     └─────────────┘     └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  Set JWT    │
                    │  Cookies    │
                    └─────────────┘
                           │
                           ▼
┌─────────────┐     ┌─────────────┐
│  Subsequent │────▶│  /session   │──▶ Returns user data
│  Requests   │     │  (validate) │    or { authenticated: false }
└─────────────┘     └─────────────┘
```

# Feature Flags Registry

**Created:** 2025-12-26
**Purpose:** Define all feature flags for controlling feature visibility and rollout.

---

## Overview

Feature flags control which functionality is enabled in each build. The system works as follows:

1. **Database Table:** `features` stores all flags with enabled/disabled state and allowed roles
2. **App Load:** Client fetches enabled features on initial load
3. **Page Render:** Each page checks `canAccess(featureId)` before rendering flagged components
4. **Role + Flag:** Both user's roles AND feature flag must allow access

---

## Database Schema

```sql
CREATE TABLE features (
  id              TEXT PRIMARY KEY,        -- 'video_sessions', 'newsletters'
  name            TEXT NOT NULL,           -- Display name
  description     TEXT,                    -- What it does
  enabled         BOOLEAN DEFAULT false,   -- Global on/off
  allowed_roles   TEXT[] NOT NULL,         -- ['student', 'creator'] or ['*']
  block           INTEGER,                 -- Implementation block (0-9)
  requires        TEXT[],                  -- Other feature IDs this depends on
  created_at      TIMESTAMP DEFAULT NOW(),
  updated_at      TIMESTAMP DEFAULT NOW()
);
```

---

## Client-Side Usage

```typescript
// App context provides:
const { features, user } = useAppContext();

// Helper function:
function canAccess(featureId: string): boolean {
  const feature = features[featureId];
  if (!feature?.enabled) return false;
  if (feature.allowed_roles.includes('*')) return true;
  return feature.allowed_roles.some(role => user.roles.includes(role));
}

// In components:
{canAccess('course_chat') && <ChatButton />}
{canAccess('newsletters') && <NewsletterNav />}
```

---

## Feature Flag Definitions

### Legend

| Field | Description |
|-------|-------------|
| **ID** | Database key, used in `canAccess()` |
| **Name** | Human-readable name |
| **Description** | What this feature enables |
| **Pages** | Page codes where this flag is checked |
| **Services** | External services used |
| **DB Tables** | Tables this feature requires |
| **Roles** | Which roles can access when enabled |
| **Requires** | Other feature flags this depends on |
| **Block** | Implementation block (0-9, or POST) |

---

## Core Features (Always Enabled)

These are foundational features that cannot be disabled.

### AUTH
| Field | Value |
|-------|-------|
| **ID** | `auth` |
| **Name** | Authentication |
| **Description** | Login, signup, password reset, session management |
| **Pages** | LGIN, SGUP, PWRS |
| **Services** | Resend (verification emails) |
| **DB Tables** | users, password_reset_tokens |
| **Roles** | `['*']` |
| **Requires** | - |
| **Block** | 0 |

### COURSES_BROWSE
| Field | Value |
|-------|-------|
| **ID** | `courses_browse` |
| **Name** | Course Browsing |
| **Description** | View courses, creators, search, filter |
| **Pages** | HOME, CBRO, CDET, CRLS, CPRO |
| **Services** | - |
| **DB Tables** | courses, users, course_categories |
| **Roles** | `['*']` |
| **Requires** | - |
| **Block** | 1 |

### ENROLLMENT
| Field | Value |
|-------|-------|
| **ID** | `enrollment` |
| **Name** | Course Enrollment |
| **Description** | Purchase courses, Stripe checkout, enrollment records |
| **Pages** | CDET (enroll button), SDSH |
| **Services** | Stripe (Checkout) |
| **DB Tables** | enrollments, transactions, payment_splits |
| **Roles** | `['*']` (authenticated) |
| **Requires** | `auth`, `courses_browse` |
| **Block** | 2 |

---

## Toggleable Features

### VIDEO_SESSIONS
| Field | Value |
|-------|-------|
| **ID** | `video_sessions` |
| **Name** | Video Tutoring Sessions |
| **Description** | Book and join 1-on-1 video sessions with Student-Teachers |
| **Pages** | SBOK, SROM, SDSH (upcoming), TDSH (upcoming) |
| **Services** | PlugNmeet, Resend (reminders) |
| **DB Tables** | sessions, session_attendance, availability, session_resources |
| **Roles** | `['student', 'student_teacher']` |
| **Requires** | `enrollment` |
| **Block** | 4 |

### HOMEWORK
| Field | Value |
|-------|-------|
| **ID** | `homework` |
| **Name** | Homework & Assignments |
| **Description** | Create, assign, submit, and review homework assignments |
| **Pages** | CCNT (homework tab), CDET (homework section), CDSH (pending reviews) |
| **Services** | Cloudflare R2 (file attachments) |
| **DB Tables** | homework_assignments, homework_submissions |
| **Roles** | `['student', 'student_teacher', 'creator']` |
| **Requires** | `enrollment` |
| **Block** | 4 |

### COMMUNITY_FEED
| Field | Value |
|-------|-------|
| **ID** | `community_feed` |
| **Name** | Community Feed |
| **Description** | Social feed, posts, likes, follows, instructor feeds |
| **Pages** | FEED, IFED, CPRO (follow button) |
| **Services** | Stream.io |
| **DB Tables** | posts, follows, instructor_followers, post_interactions |
| **Roles** | `['*']` (authenticated) |
| **Requires** | `auth` |
| **Block** | 5 |

### MESSAGING
| Field | Value |
|-------|-------|
| **ID** | `messaging` |
| **Name** | Direct Messaging |
| **Description** | Send messages between users |
| **Pages** | MSGS |
| **Services** | - (internal WebSocket or polling) |
| **DB Tables** | messages, conversations |
| **Roles** | `['*']` (authenticated) |
| **Requires** | `auth` |
| **Block** | 5 |

### ST_SYSTEM
| Field | Value |
|-------|-------|
| **ID** | `st_system` |
| **Name** | Student-Teacher System |
| **Description** | ST certification, applications, teaching, earnings |
| **Pages** | STDR, STPR, TDSH, SDSH (cert section) |
| **Services** | Stripe Connect (payouts) |
| **DB Tables** | student_teachers, certificates, payouts |
| **Roles** | `['student', 'student_teacher', 'creator']` |
| **Requires** | `enrollment`, `video_sessions` |
| **Block** | 6 |

### CREATOR_TOOLS
| Field | Value |
|-------|-------|
| **ID** | `creator_tools` |
| **Name** | Creator Tools |
| **Description** | Creator dashboard, studio, course management, earnings |
| **Pages** | CDSH, STUD, CMST, CSES, CEAR |
| **Services** | Stripe Connect (payouts) |
| **DB Tables** | courses, payment_splits, payouts |
| **Roles** | `['creator']` |
| **Requires** | `auth` |
| **Block** | 7 |

### ADMIN_PANEL
| Field | Value |
|-------|-------|
| **ID** | `admin_panel` |
| **Name** | Admin Panel |
| **Description** | Platform administration, user management, payouts |
| **Pages** | ADMN, AUSR, ACRS, AENR, ASES, ACRT, APAY, ACAT, MODQ |
| **Services** | Stripe (admin payout processing) |
| **DB Tables** | All tables (admin access) |
| **Roles** | `['admin']` |
| **Requires** | `auth` |
| **Block** | 8 |

### NOTIFICATIONS
| Field | Value |
|-------|-------|
| **ID** | `notifications` |
| **Name** | Notifications |
| **Description** | In-app notifications, notification preferences |
| **Pages** | NOTF, SETT (notification prefs) |
| **Services** | - |
| **DB Tables** | notifications, notification_preferences |
| **Roles** | `['*']` (authenticated) |
| **Requires** | `auth` |
| **Block** | 9 |

### PROFILE_SETTINGS
| Field | Value |
|-------|-------|
| **ID** | `profile_settings` |
| **Name** | Profile & Settings |
| **Description** | Edit profile, account settings, availability |
| **Pages** | PROF, SETT |
| **Services** | Stripe Connect (payout settings), Resend (email change) |
| **DB Tables** | users, availability |
| **Roles** | `['*']` (authenticated) |
| **Requires** | `auth` |
| **Block** | 9 |

### CREATOR_ANALYTICS
| Field | Value |
|-------|-------|
| **ID** | `creator_analytics` |
| **Name** | Creator Analytics |
| **Description** | Detailed course analytics, student insights |
| **Pages** | CANA |
| **Services** | - |
| **DB Tables** | enrollments, sessions, module_progress |
| **Roles** | `['creator']` |
| **Requires** | `creator_tools` |
| **Block** | 9 |

---

## Post-MVP Features

These features are fully documented and architected but flagged off initially.

### COURSE_CHAT
| Field | Value |
|-------|-------|
| **ID** | `course_chat` |
| **Name** | Course Chat |
| **Description** | Real-time chat within courses |
| **Pages** | CCNT (chat button), CHAT |
| **Services** | Custom WebSocket (Cloudflare Durable Objects) |
| **DB Tables** | chat_messages, chat_rooms |
| **Roles** | `['student', 'student_teacher']` |
| **Requires** | `enrollment` |
| **Block** | POST |

### SUMMON_HELP
| Field | Value |
|-------|-------|
| **ID** | `summon_help` |
| **Name** | Summon Help |
| **Description** | Request help from available STs while learning |
| **Pages** | CCNT (summon button), HELP |
| **Services** | Custom WebSocket |
| **DB Tables** | help_requests, user_availability |
| **Roles** | `['student']` |
| **Requires** | `course_chat`, `goodwill_points` |
| **Block** | POST |

### GOODWILL_POINTS
| Field | Value |
|-------|-------|
| **ID** | `goodwill_points` |
| **Name** | Goodwill Points System |
| **Description** | Earn/spend points for platform actions |
| **Pages** | SDSH (points display), FEED (promote), HELP (spend) |
| **Services** | - |
| **DB Tables** | goodwill_points, goodwill_transactions |
| **Roles** | `['*']` (authenticated) |
| **Requires** | `auth` |
| **Block** | POST |

### NEWSLETTERS
| Field | Value |
|-------|-------|
| **ID** | `newsletters` |
| **Name** | Creator Newsletters |
| **Description** | Creators send newsletters to subscribers |
| **Pages** | CNEW, STUD (nav item) |
| **Services** | Resend |
| **DB Tables** | newsletters, newsletter_subscribers, newsletter_tiers |
| **Roles** | `['creator']` |
| **Requires** | `creator_tools` |
| **Block** | POST |

### LEADERBOARD
| Field | Value |
|-------|-------|
| **ID** | `leaderboard` |
| **Name** | Leaderboard |
| **Description** | Gamification leaderboards |
| **Pages** | LEAD |
| **Services** | - |
| **DB Tables** | leaderboard_entries, achievements |
| **Roles** | `['*']` (authenticated) |
| **Requires** | `goodwill_points` |
| **Block** | POST |

### SUB_COMMUNITIES
| Field | Value |
|-------|-------|
| **ID** | `sub_communities` |
| **Name** | Sub-Communities |
| **Description** | Topic-based community spaces |
| **Pages** | SUBCOM |
| **Services** | Stream.io (additional feeds) |
| **DB Tables** | sub_communities, sub_community_members |
| **Roles** | `['*']` (authenticated) |
| **Requires** | `community_feed` |
| **Block** | POST |

### POST_PROMOTION
| Field | Value |
|-------|-------|
| **ID** | `post_promotion` |
| **Name** | Post Promotion |
| **Description** | Spend goodwill points to boost posts to main feed |
| **Pages** | FEED, IFED |
| **Services** | Stream.io |
| **DB Tables** | promoted_posts, goodwill_transactions |
| **Roles** | `['*']` (authenticated) |
| **Requires** | `community_feed`, `goodwill_points` |
| **Block** | POST |

### INTRO_SESSIONS
| Field | Value |
|-------|-------|
| **ID** | `intro_sessions` |
| **Name** | Free Intro Sessions |
| **Description** | Book free introductory sessions (CD-029) |
| **Pages** | CDET (intro button), SBOK (intro flow) |
| **Services** | PlugNmeet |
| **DB Tables** | sessions (is_intro flag) |
| **Roles** | `['*']` (authenticated) |
| **Requires** | `video_sessions` |
| **Block** | POST |

---

## Feature Dependencies Graph

```
auth
├── courses_browse
│   └── enrollment
│       ├── video_sessions
│       │   ├── st_system
│       │   └── intro_sessions
│       ├── homework
│       └── course_chat
│           └── summon_help
├── community_feed
│   ├── sub_communities
│   └── post_promotion
├── messaging
├── creator_tools
│   ├── creator_analytics
│   └── newsletters
├── admin_panel
├── notifications
├── profile_settings
└── goodwill_points
    ├── summon_help
    ├── leaderboard
    └── post_promotion
```

---

## MVP Release Configuration

For MVP launch, enable these flags:

```sql
UPDATE features SET enabled = true WHERE id IN (
  'auth',
  'courses_browse',
  'enrollment',
  'video_sessions',
  'homework',
  'community_feed',
  'messaging',
  'st_system',
  'creator_tools',
  'admin_panel',
  'notifications',
  'profile_settings'
);
```

Remaining flags (`course_chat`, `summon_help`, `goodwill_points`, `newsletters`, `leaderboard`, `sub_communities`, `post_promotion`, `intro_sessions`, `creator_analytics`) stay disabled until ready.

---

## API Endpoint

```typescript
// GET /api/features
// Returns only enabled features with their allowed_roles

{
  features: {
    auth: { enabled: true, allowed_roles: ['*'] },
    video_sessions: { enabled: true, allowed_roles: ['student', 'student_teacher'] },
    newsletters: { enabled: false, allowed_roles: ['creator'] }
  }
}
```

---

## Admin UI (Future)

ADMN page could include a Feature Flags management screen:

| Feature | Enabled | Roles | Actions |
|---------|---------|-------|---------|
| Video Sessions | ✓ | student, student_teacher | Toggle, Edit Roles |
| Newsletters | ✗ | creator | Toggle, Edit Roles |

---

## Document History

| Date | Changes |
|------|---------|
| 2025-12-26 | Initial creation with 20 feature flags |
| 2025-12-26 | Brian Review: Added HOMEWORK feature flag (MVP), updated VIDEO_SESSIONS to include session_resources |

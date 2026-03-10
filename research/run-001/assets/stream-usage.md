# Stream.io Usage Decisions - RUN-001

> **⚠️ MIGRATED:** This content has been integrated into `docs/vendors/stream.md` (2026-01-19).
> This file is kept for historical reference. For current information, see the tech doc.

**Created:** 2025-12-24
**Migrated:** 2026-01-19 → `docs/vendors/stream.md`
**Related Global Research:** `docs/vendors/stream.md`

---

## Decision: Feeds Only (Not Chat)

RUN-001 uses Stream.io for **Activity Feeds only**, not for Chat or Video.

### Rationale

| Factor | Decision |
|--------|----------|
| DIR-002 | MUST-USE Stream for activity feeds |
| CD-008 | Brian clarified "feeds only" from Stream |
| Chat | Build custom (simpler, lower cost, more control) |
| Video | VideoProvider interface (BBB/PlugNmeet) |

---

## Stream Products Assessment

**From stream.md (docs/vendors/):**

| Product | Using? | Rationale |
|---------|--------|-----------|
| **Activity Feeds** | ✅ Yes | Community feed, course feeds, instructor feeds |
| **Chat** | ❌ No | Build custom - simpler for 1:1 messaging |
| **Video** | ❌ No | BBB/PlugNmeet handles video |

---

## Feed Types in RUN-001

### Main Community Feed
- **Purpose:** Platform-wide activity (Town Hall)
- **Stream Feed Type:** Flat or Aggregated
- **Access:** All authenticated users
- **Content:** Announcements, promoted posts, platform updates

### Course Feed
- **Purpose:** Course-specific discussion
- **Stream Feed Type:** Flat
- **Access:** Enrolled students + certified Teachers + Creator
- **Content:** Q&A, tips, progress updates, announcements

### Instructor Feed
- **Purpose:** Creator's community across all their courses
- **Stream Feed Type:** Aggregated
- **Access:** Anyone who purchased any course from this instructor
- **Content:** Cross-course announcements, community building
- **Source:** CD-024

### User Timeline
- **Purpose:** Personalized feed of followed content
- **Stream Feed Type:** Timeline (aggregated from follows)
- **Access:** Own user only
- **Content:** Posts from followed users, courses, creators

### Notification Feed
- **Purpose:** User-specific alerts
- **Stream Feed Type:** Notification
- **Access:** Own user only
- **Content:** Mentions, replies, session reminders, approvals

---

## Integration Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   React App     │────▶│   Stream SDK    │────▶│   Stream API    │
│   (Astro)       │     │   (Client)      │     │   (Cloud)       │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │
         ▼
┌─────────────────┐
│   Our Backend   │───── Sync follows, generate tokens
│   (Workers)     │
└─────────────────┘
```

### Token Flow
1. User authenticates with our backend
2. Backend generates Stream user token (server-side)
3. Client connects to Stream with token
4. Stream SDK handles real-time updates

---

## Pricing Impact

**From stream.md (docs/vendors/):**

| Tier | MAU | Price | Genesis Cohort Fit |
|------|-----|-------|-------------------|
| Maker | Up to 100 | Free | ✅ Initial testing |
| Startup | Up to 10,000 | ~$499/mo | ✅ Genesis (60-80 students) |

**RUN-001 Estimate:**
- Genesis Cohort: 60-80 students + 4-5 creators + Teachers
- Expected MAU: ~100-150
- **Recommendation:** Start on Maker (free), upgrade to Startup at launch

---

## User Stories Covered

| Story ID | Story | Stream Feature |
|----------|-------|----------------|
| US-S025 | X.com-style algorithmic feed | Activity Feeds |
| US-P002 | "My Community" feed | Timeline Feed |
| US-S036-S041 | Feed interactions | Reactions, comments |
| US-S070 | Instructor feed access | Instructor Feed |
| US-C037-C038 | Creator feed management | Feed posting |

---

## What We're NOT Using Stream For

> **⚠️ Messaging Decision Under Review:** The custom messaging assumption is being re-evaluated. See `docs/architecture/messaging.md` for full comparison. Client decision pending.

| Feature | Alternative | Rationale | Status |
|---------|-------------|-----------|--------|
| 1:1 Messaging | Custom (Cloudflare D1 + Workers) | Simpler, lower cost | ⏳ Under Review |
| Group Chat | Custom or defer | Not MVP priority | ⏳ Under Review |
| Video | VideoProvider (BBB/PlugNmeet) | Education-focused | ✅ Confirmed |
| Real-time Chat | WebSockets via Cloudflare | More control | ⏳ Under Review |

---

## Implementation Notes

### React SDK Components (from tech-002)
```jsx
import { StreamApp, FlatFeed, NotificationDropdown } from 'react-activity-feed';
import 'react-activity-feed/dist/index.css';

// In Astro page
<StreamApp apiKey={apiKey} appId={appId} token={userToken}>
  <FlatFeed feedGroup="course" feedId={courseId} />
</StreamApp>
```

### Feed Groups to Create
| Group | Purpose |
|-------|---------|
| `user` | Personal timeline |
| `course` | Course-specific feed |
| `instructor` | Instructor community |
| `notification` | User notifications |
| `townhall` | Platform-wide feed |

---

## Open Questions (from tech-002)

| Question | RUN-001 Decision |
|----------|------------------|
| Expected MAU at Genesis? | ~100-150 (free tier OK) |
| All roles need feed access? | Yes, all authenticated users |
| Student-to-student in feed? | Yes, within course feeds |
| Feed organization? | Per course + per instructor + platform |

---

## References

- `docs/vendors/stream.md` - Full Stream research
- `CD-008` - "Feeds only" clarification
- `CD-024` - Instructor feed access model
- [Stream Activity Feeds Docs](https://getstream.io/activity-feeds/docs/)

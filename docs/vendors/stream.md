# tech-002: Stream

**Type:** Chat, Activity Feeds, Video Platform
**Status:** ✅ SELECTED - Feeds Only (2025-12-26)
**Research Date:** 2025-11-30, Updated 2026-01-20
**Source:** https://getstream.io/

---

## Overview

Stream is a SaaS platform providing APIs and SDKs for building chat, activity feeds, and video features. It offers pre-built React components with extensive customization options.

## Products Available

Stream offers three distinct products:

| Product | Description | Relevance to Alpha Peer |
|---------|-------------|------------------------|
| **Chat** | Real-time messaging | HIGH - Messaging between users |
| **Activity Feeds** | Social-style feeds | MEDIUM - Community feeds |
| **Video & Audio** | Video calling, livestreaming | LOW - BBB handles this |

## Stream Chat

> **Decision Pending:** See `docs/architecture/messaging.md` for comparison of Stream Chat vs Custom (Workers + D1) for PeerLoop messaging. Client decision required.

### Key Features
| Feature | Description | Relevant User Stories |
|---------|-------------|----------------------|
| Real-time Messaging | Instant message delivery | US-S016, US-S019, US-C017, US-T008 |
| Typing Indicators | Show when users are typing | Enhanced UX |
| Message Reactions | Emoji reactions on messages | Enhanced UX |
| Threads/Replies | Organized conversations | US-S019 |
| File/Image Upload | Share attachments | US-V003 |
| User Presence | Online/offline status | Enhanced UX |
| Unread Counts | Badge notifications | US-P004 |
| Push Notifications | Mobile alerts | Future mobile |
| Message Search | Find past conversations | P2 |
| Moderation | Content filtering | US-S017 safety |
| Custom Fields | Extend user/message data | Flexible integration |

### React SDK Components
```javascript
// Stream Chat provides pre-built React components:
import {
  Chat,
  Channel,
  ChannelHeader,
  MessageList,
  MessageInput,
  Thread,
  Window,
} from 'stream-chat-react';
```

### Channel Types
| Type | Description | Alpha Peer Use |
|------|-------------|---------------|
| messaging | 1:1 private chat | Student ↔ Teacher |
| team | Group conversations | Study groups |
| livestream | Many viewers, few posters | Announcements |
| commerce | Customer support style | Support tickets |
| gaming | High-volume, low-latency | Not applicable |

### Authentication Model
```javascript
// Users connect with JWT tokens generated server-side
const client = StreamChat.getInstance('api_key');
await client.connectUser(
  { id: 'user-id', name: 'User Name', image: 'avatar.jpg' },
  'server_generated_token'
);
```

## Stream Activity Feeds

### Key Features
| Feature | Description | Relevant User Stories |
|---------|-------------|----------------------|
| Following System | Follow users/topics | US-S025 |
| Notification Feeds | Activity notifications | US-P002 |
| Aggregation | Group similar activities | Enhanced UX |
| Personalization | Custom feed algorithms | US-S025 |
| Reactions | Likes, comments | Community engagement |

### Feed Types
- **Flat Feeds:** Chronological activity streams
- **Aggregated Feeds:** Grouped activities (e.g., "5 people liked your post")
- **Notification Feeds:** User-specific alerts

### Alpha Peer Community Use Case
```
Creator posts update →
  Followers see in their feed →
    Students can react/comment →
      Creator gets notification
```

## Stream Video

**Note:** BigBlueButton is required for video, so Stream Video is likely NOT needed.

| Feature | BBB Coverage | Stream Video |
|---------|-------------|--------------|
| Video calls | Yes | Also yes |
| Screen sharing | Yes | Yes |
| Recording | Yes | Yes |
| Education focus | Yes (purpose-built) | General purpose |
| Pricing | Self-host | Per-minute fees |

**Recommendation:** Skip Stream Video; use BigBlueButton as required.

## Pricing

Stream uses usage-based pricing with free tiers for development.

### Chat Pricing (Estimated)
| Tier | MAU | Price |
|------|-----|-------|
| Maker | Up to 100 | Free |
| Startup | Up to 10,000 | ~$499/month |
| Growth | Up to 100,000 | Custom |
| Enterprise | Unlimited | Custom |

### Activity Feeds Pricing
| Tier | Updates/Month | Price |
|------|---------------|-------|
| Free | 3M | Free |
| Growth | Custom | Custom |

**Note:** Contact Stream sales for exact pricing; rates change frequently.

## User Story Coverage

### Directly Addresses
| Story ID | Story | Stream Product |
|----------|-------|----------------|
| US-S016 | Student message teachers | Chat |
| US-S019 | Private messaging system | Chat |
| US-C017 | Creator message students | Chat |
| US-T008 | Teacher message students | Chat |
| US-A010 | Admin message teachers | Chat |
| US-A011 | Admin message students | Chat |
| US-S025 | X.com-style algorithmic feed | Activity Feeds |
| US-P002 | "My Community" feed | Activity Feeds |
| US-P004 | Messages section | Chat |

### Partially Addresses
| Story ID | Story | Gap |
|----------|-------|-----|
| US-S017 | Student-to-student messaging (tricky) | Needs moderation rules |
| US-C021 | Community hubs with forums | Feeds + custom UI needed |

### Does NOT Address
| Story ID | Story | Alternative |
|----------|-------|-------------|
| US-A012 | Email to potential students | Email service needed |
| US-V* | Video/session stories | BigBlueButton |

## Integration Considerations

### Pros
- Pre-built React components
- Handles real-time infrastructure
- Scales automatically
- Strong moderation tools (addresses US-S017 safety concern)
- 99.999% uptime SLA
- ~9ms API response times
- Supports 5M+ users per channel

### Cons
- Recurring SaaS costs
- Data lives on Stream servers
- Pricing can scale quickly with users
- Lock-in to Stream's data model
- **Node.js SDK incompatible with Cloudflare Workers** (see Caveats below)

### React/Astro Integration
```javascript
// Astro page with Stream Chat React component
---
// astro page (server-side)
import ChatWrapper from '../components/react/ChatWrapper';
---

<ChatWrapper client:load apiKey={import.meta.env.STREAM_API_KEY} />
```

```jsx
// React component
import { StreamChat } from 'stream-chat';
import { Chat, Channel, MessageList, MessageInput } from 'stream-chat-react';
import 'stream-chat-react/dist/css/v2/index.css';

export default function ChatWrapper({ apiKey, userToken, userId }) {
  const [client] = useState(() => StreamChat.getInstance(apiKey));

  useEffect(() => {
    client.connectUser({ id: userId }, userToken);
    return () => client.disconnectUser();
  }, []);

  return (
    <Chat client={client}>
      <Channel>
        <MessageList />
        <MessageInput />
      </Channel>
    </Chat>
  );
}
```

## Recommendations

1. **Use Stream Chat for all messaging** - Covers US-S016, US-S019, US-C017, US-T008, US-A010, US-A011
2. **Evaluate Activity Feeds for community** - Good fit for US-S025, US-P002, US-C021
3. **Skip Stream Video** - BigBlueButton is required and more cost-effective
4. **Plan moderation strategy** - Critical for US-S017 (student-to-student messaging)
5. **Budget for growth** - Free tier for development, plan for paid tier at launch

## Open Questions

- [x] What's the expected MAU for chat at Genesis Cohort launch? → ~100-150 (free tier)
- [x] Will all 6 user roles need chat access? → Yes, all authenticated users
- [x] Should student-to-student chat be gated? → Yes, within course feeds only
- [x] How should community feeds be organized? → Per course + per instructor + platform-wide

---

## Caveats

### Node.js SDK Incompatible with Cloudflare Workers (2026-01-19)

**Problem:** The `getstream` Node.js SDK uses `http.Agent` which is not available in Cloudflare Workers/Pages runtime. Even with `nodejs_compat_v2` and `enable_nodejs_http_modules` compatibility flags, Cloudflare's `http.Agent` is a stub implementation that doesn't satisfy the SDK's constructor requirements.

**Symptoms:**
- Code works locally (both Node adapter and local workerd)
- Fails on actual Cloudflare Pages deployment with `http.Agent is not a constructor`

**Solution:** Use Stream's REST API directly with `fetch()` and `jose` for JWT authentication instead of the SDK. See `src/lib/stream.ts` for the edge-compatible implementation.

**Affected packages:**
- `getstream` (Activity Feeds SDK) - Incompatible, removed
- `@stream-io/node-sdk` - Likely incompatible (same pattern)
- `stream-chat` (client-side) - Should work (browser SDK)

### Use v2 SDK, Not v3 (2026-01-19)

**Problem:** Stream's v3 SDK (`@stream-io/node-sdk`, `@stream-io/feeds-react-sdk`) is not yet integrated with the Stream Dashboard. Feed groups created in the dashboard are not recognized by v3.

**Symptoms:**
- "Feed group with ID 'townhall' not found" errors
- Dashboard explicitly states v3 is not yet integrated

**Solution:** Use the v2 `getstream` package instead of v3 SDKs. The v2 SDK has full dashboard support and more documentation.

**Note:** This caveat may become obsolete if:
1. Stream updates their dashboard for v3
2. Cloudflare Workers gains full Node.js compatibility (making SDK usable again)

### Stream API Requests Need Explicit Timeout (Conv 020)

**Problem:** `streamFetch()` in `src/lib/stream.ts` had no timeout. A hanging Stream response (network issue, rate limit, slow enrichment query) hangs the entire Worker request indefinitely — no error, no fallback, unrecoverable even with Ctrl+C in dev.

**Solution:** Added 10-second `AbortController` timeout to all `streamFetch()` calls. The Smart Feed enrichment pipeline's existing try/catch catches the abort error and falls back to D1-only data (metadata without engagement counts).

**Pattern:** Always use `AbortController` with external API calls in edge/worker environments where there's no global request timeout.

Currently moot since we use REST API directly, but relevant if SDK approach is revisited.

---

## API Reference (Activity Feeds)

### Server-Side SDK Setup

**Package:** `@stream-io/node-sdk`

```typescript
import { StreamClient } from "@stream-io/node-sdk";

const client = new StreamClient(
  process.env.STREAM_API_KEY,
  process.env.STREAM_API_SECRET
);
```

### Token Generation ✅ RESOLVED

Tokens are JWT-based, generated server-side, passed to client.

```typescript
// Generate user token (server-side only)
const token = client.generateUserToken({
  user_id: "user_123",           // Required: your user's ID
  validity_in_seconds: 3600      // Optional: 1 hour default
});

// Token includes automatically:
// - user_id: the authenticated user
// - iat: issued-at timestamp
// - exp: expiration time
```

**Token Provider Pattern (for PeerLoop):**
```typescript
// POST /api/stream/token
export async function POST(request: Request) {
  // 1. Verify PeerLoop JWT from request
  const user = await verifyAuth(request);

  // 2. Generate Stream token for this user
  const streamToken = client.generateUserToken({
    user_id: user.id,
    validity_in_seconds: 24 * 60 * 60  // 24 hours
  });

  // 3. Return to client
  return Response.json({ token: streamToken });
}
```

**Token Revocation:**
```typescript
// Revoke all tokens for a user (e.g., on logout, password change)
await client.updateUsersPartial({
  users: [{
    id: "user_123",
    set: { revoke_tokens_issued_before: new Date() }
  }]
});

// Revoke all tokens app-wide (emergency)
await client.updateApp({ revoke_tokens_issued_before: new Date() });
```

### Client-Side SDK Setup

**Package:** `@stream-io/feeds-react-sdk`

```typescript
import { FeedsClient } from "@stream-io/feeds-react-sdk";

const client = new FeedsClient(process.env.NEXT_PUBLIC_STREAM_API_KEY);
await client.connectUser(
  { id: "user_123", name: "John Doe", image: "avatar.jpg" },
  userToken  // from your /api/stream/token endpoint
);
```

### Feed Types & Groups

| Feed Group | Purpose | PeerLoop Usage |
|------------|---------|----------------|
| `user` | User-created content | Personal posts |
| `timeline` | Following aggregation | Personalized feed |
| `notification` | User alerts (max 100) | Mentions, replies |
| `foryou` | Popular content prioritized | Discovery feed |

**PeerLoop Feed Groups (configured in Stream Dashboard):**
| Group | Feed ID Pattern | Access |
|-------|-----------------|--------|
| `townhall` | `townhall:main` | All users (global read) - Main community feed |
| `course` | `course:{courseId}` | Enrolled users only - Course discussions |
| `instructor` | `instructor:{userId}` | Course purchasers - Creator updates |
| `user` | `user:{userId}` | Owner + followers |
| `notification` | `notification:{userId}` | Owner only |
| `timeline` | `timeline:{userId}` | Personalized following feed |
| `timeline_aggregated` | `timeline_aggregated:{userId}` | Grouped activity view |

### Core API Operations

#### Create/Access Feed
```typescript
const feed = client.feeds.feed("course", courseId);
await feed.getOrCreate({
  user_id: userId,
  data: {
    name: "Course Discussion",
    visibility: "private"
  }
});
```

#### Add Activity
```typescript
await feed.addActivity({
  type: "post",                    // Activity type
  text: "Welcome to the course!",  // Content
  user_id: userId,                 // Author
  // Custom fields:
  attachments: ["https://..."],
  course_id: courseId
});
```

#### Read Activities
```typescript
const response = await feed.getOrCreate({
  user_id: userId,
  limit: 20
});
const activities = response.activities;

// Pagination
const nextPage = await feed.getOrCreate({
  user_id: userId,
  next: response.next,
  limit: 20
});
```

#### Target to Multiple Feeds (TO field)
```typescript
// Post to course feed AND notify instructor
await courseFeed.addActivity({
  type: "question",
  text: "How do I...?",
  user_id: studentId,
  to: [`notification:${instructorId}`]  // Also sends notification
});
```

#### Reactions & Comments
```typescript
// Add reaction (server-side with getstream v2 SDK)
// IMPORTANT: userId goes in 4th param (options), not 3rd param (data)
await client.reactions.add(
  "like",                    // kind: "like", "love", "celebrate"
  activityId,                // activity ID
  {},                        // data (empty object if no custom data)
  { userId: session.userId } // options with userId
);

// Remove reaction - filter first, then delete
const reactions = await client.reactions.filter({
  activity_id: activityId,
  kind: "like",
});
const userReaction = reactions.results.find((r) => r.user_id === userId);
if (userReaction) {
  await client.reactions.delete(userReaction.id);
}

// Add comment
await client.addComment({
  object_id: activityId,
  comment: "Great question!"
});
```

**Caveats (2026-01-19, updated 2026-01-20):**
- `reactions.add()` method signature: `(kind, activityId, data, options)` - userId must be in options (4th param), not data (3rd param)
- `reactions.filter()` - querying with `user_id` + `activity_id` + `kind` together may not work as expected; filter by `activity_id` + `kind` first, then find user's reaction in results

**REST API Caveats (2026-01-20):**
- **No server-side filtering by custom fields:** Stream doesn't support filtering activities by custom fields (like `courseId` or `instructorId`) on the server. For per-course or per-instructor feeds, either use separate feed groups (`course:{id}`) or fetch more than needed and filter client-side.
- **Reaction filtering requires path-based endpoints, NOT query params:**
  - WRONG: `/reaction/?activity_id=xxx&kind=comment` (silently returns ALL reactions)
  - CORRECT: `/reaction/activity_id/{activity_id}/{kind}/`
  - Other formats: `/reaction/reaction_id/{id}/{kind}/`, `/reaction/user_id/{id}/{kind}/`
- **Enriched feeds require `/enrich/feed/` endpoint:**
  - `/feed/...` returns basic activities without `reaction_counts`
  - `/enrich/feed/...` returns enriched activities with `reaction_counts`, `own_reactions`
- **Reaction count parameters:** Use `with_reaction_counts=true` (snake_case with `with_` prefix), NOT `reactions[counts]=true`
- **`reaction_counts` only counts top-level:** Nested child reactions (replies) are counted separately in each reaction's `children_counts`

### Ranked Feeds (Algorithmic Ordering)

**Added:** 2026-02-04 (Session 180)

Stream supports custom ranking formulas to control activity ordering. Ranked feeds are **not available on free plans** — requires paid tier.

**Basic Setup:**
```json
{
  "score": "decay_linear(time) * popularity ^ 0.5",
  "defaults": {
    "popularity": 1
  }
}
```

**Available Scoring Variables:**

| Variable Type | Examples | Notes |
|---------------|----------|-------|
| **Time decay** | `decay_linear(time)`, `decay_gauss(time)` | Newer = higher score |
| **Custom fields** | `popularity`, `is_pinned`, `priority` | Any field added to activity |
| **Reaction counts** | `likes`, `comments` | Engagement metrics |
| **Analytics** | `analytics_clicks` | Enterprise plans only |
| **External params** | `external.w_topic` | Passed at query time |

**Common Ranking Formulas:**

| Goal | Formula |
|------|---------|
| Chronological | `decay_linear(time)` |
| Reddit-style viral | `decay_gauss(time) * log(likes + 0.5*comments + 1)` |
| Pinned at top | `decay_linear(time) + is_pinned` (with `is_pinned` default 0) |
| Boosted/promoted | `decay_gauss(time) ^ (1/promoted)` |
| Topic weighted | `decay_linear(time) * (w_ann * is_announcement + w_course * is_course_post)` |

**Personalized Feeds (External Parameters):**

Pass user-specific weights at query time for per-user personalization:

```typescript
// Define formula with external keyword
// "score": "decay_linear(time) * (external.w_announcements * is_announcement + external.w_courses * is_course_post)"

// Query with user preferences
const response = await feed.get({
  limit: 25,
  ranking_vars: {
    w_announcements: 10,  // User wants announcements prioritized
    w_courses: 5,
  }
});
```

**CRITICAL LIMITATION: No Date Filtering with Ranked Feeds**

| Capability | Chronological Feed | Ranked Feed |
|------------|-------------------|-------------|
| `limit` | ✅ | ✅ |
| `offset` | ✅ | ✅ |
| `id_lt` (older than) | ✅ | ❌ **Not supported** |
| `id_gt` (newer than) | ✅ | ❌ **Not supported** |

**You cannot combine ranked feeds with date range filtering.** Queries like "top posts since yesterday" are not possible server-side with ranked feeds.

**Workarounds:**
1. **Aggressive time decay** — Old posts score near zero (soft filter, not hard cutoff)
2. **Two-phase query** — Fetch chronologically with `id_gt`, sort client-side
3. **D1 hybrid** — Use D1 for date filtering, Stream for content retrieval

**References:**
- [Custom Ranking Docs](https://getstream.io/activity-feeds/docs/node/custom_ranking/)
- [External Ranking Parameters](https://getstream.io/activity-feeds/docs/node/personalized_ranking/)
- [Example Ranking Methods](https://getstream.io/blog/getting-started-ranked-feeds-getstream-io/)

### Following System

```typescript
// User's timeline follows a course feed
const timeline = client.feeds.feed("timeline", userId);
await timeline.follow("course", courseId);

// Unfollow
await timeline.unfollow("course", courseId);
```

**Permission Rules:**
- Users can follow any feed
- Users can only create follows FROM their own feeds
- Example: `timeline:john` can follow `course:123`, but can't make `course:123` follow anything

### Permissions & Access Control

**Default Permission Behaviors:**

| Permission Type | Behavior |
|-----------------|----------|
| Owner access | User can read/write feeds matching their ID |
| Global read | Any user can read (e.g., `user` group default) |
| Global write | Any user can write (requires explicit config) |
| Follow-based read | Can read feeds you follow |

**PeerLoop Permission Strategy:**

| Feed Group | Read | Write | Config Needed |
|------------|------|-------|---------------|
| `townhall` | Global | Admins only | Request global read from Stream |
| `course` | Enrolled only | Enrolled users | **Server-side gating** |
| `instructor` | Purchasers only | Creator only | **Server-side gating** |
| `notification` | Owner only | System only | Default |

**Important:** Stream cannot enforce "only enrolled users" - we must gate this server-side:

```typescript
// POST /api/feeds/course/:courseId/activities
export async function POST(request: Request, { params }) {
  const user = await verifyAuth(request);

  // Check enrollment in OUR database
  const enrolled = await db.enrollments.findFirst({
    where: { userId: user.id, courseId: params.courseId }
  });

  if (!enrolled) {
    return Response.json({ error: "Not enrolled" }, { status: 403 });
  }

  // User is enrolled - proxy to Stream
  const feed = serverClient.feeds.feed("course", params.courseId);
  await feed.addActivity({ ...body, user_id: user.id });
}
```

### Real-Time Updates

**Client-side subscription:**
```typescript
const feed = client.feed("course", courseId);
await feed.getOrCreate({ watch: true });  // Enable real-time

feed.state.subscribe((state) => {
  // Called when activities change
  console.log("New activities:", state.activities);
});
```

**Server-side webhooks:**
Configure in Stream Dashboard to receive all feed events:
```json
{
  "feed": "course:123",
  "app_id": "your_app",
  "new": [{ "id": "...", "type": "post", ... }],
  "deleted": [],
  "published_at": "2025-12-26T10:00:00Z"
}
```

### React Components

```jsx
import { FeedsProvider, FlatFeed, NotificationFeed } from "@stream-io/feeds-react-sdk";

function App() {
  return (
    <FeedsProvider client={client}>
      {/* Course feed */}
      <FlatFeed feedGroup="course" feedId={courseId} />

      {/* Notifications dropdown */}
      <NotificationFeed />
    </FeedsProvider>
  );
}
```

---

## PeerLoop Integration Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   React Client  │────▶│  Stream Cloud   │     │   PeerLoop API  │
│   (Astro)       │     │   (Feeds)       │     │   (Workers)     │
└────────┬────────┘     └─────────────────┘     └────────┬────────┘
         │                       ▲                        │
         │                       │                        │
         └───────────────────────┼────────────────────────┘
                                 │
                    Token generation & access control
```

**Flow:**
1. User logs in → PeerLoop issues JWT
2. Client calls `/api/stream/token` with PeerLoop JWT
3. Backend verifies JWT, generates Stream token
4. Client connects to Stream with token
5. For gated feeds (course/instructor): client calls our API, we verify access, proxy to Stream

---

## Database Sync Requirements

We need to sync these relationships to our DB:

| Event | Stream Action | PeerLoop DB Update |
|-------|---------------|-------------------|
| User enrolls in course | Follow `course:{id}` | Create enrollment record |
| User drops course | Unfollow `course:{id}` | Update enrollment status |
| User buys from Creator | Follow `instructor:{id}` | Already tracked via purchase |
| New post in course | Activity created | Optional: cache for search |

---

## References

### Official Documentation
- [Stream Activity Feeds Overview](https://getstream.io/activity-feeds/)
- [Activity Feeds Documentation](https://getstream.io/activity-feeds/docs/)
- [Node.js Quick Start](https://getstream.io/activity-feeds/docs/node/)
- [Feeds API - Node.js](https://getstream.io/activity-feeds/docs/node/feeds/)
- [Tokens & Authentication (JavaScript)](https://getstream.io/activity-feeds/docs/javascript/tokens-and-authentication/)
- [Targeting with TO Field](https://getstream.io/activity-feeds/docs/node/targeting/)

### Permissions & Security
- [Feeds Permission Policies and JWT tokens](https://support.getstream.io/hc/en-us/articles/360042760574-Feeds-Permission-Policies-and-JWT-tokens)
- [How to create Private and Public content](https://support.getstream.io/hc/en-us/articles/4404428844183-How-to-create-Private-and-Public-content-with-Stream-Feeds)
- [How to set up private Feed Groups](https://support.getstream.io/hc/en-us/articles/1500006211181-How-to-set-up-private-Feed-Groups-with-Stream-Feeds)
- [Stream Security](https://getstream.io/security/)

### React SDK
- [React Activity Feeds SDK](https://getstream.io/activity-feeds/docs/react/)
- [Stream Chat React Docs](https://getstream.io/chat/docs/react/)

### Other Resources
- [Stream Pricing](https://getstream.io/pricing/)
- [Feeds V3 Architecture Blog](https://getstream.io/blog/feeds-v3-architecture/)
- [Real-time Notification Feed API](https://getstream.io/activity-feeds/notification-feeds/)

---

## PeerLoop Integration

*Migrated from `research/run-001/assets/stream-usage.md` (2026-01-19)*
*Updated: 2026-02-05 (Session 193) — environment setup, feed group updates*

### Decision: Activity Feeds Only

PeerLoop uses Stream for **Activity Feeds only**, not for Chat or Video.

| Product | Using? | Rationale |
|---------|--------|-----------|
| **Activity Feeds** | ✅ Yes | Community feed, course feeds |
| **Chat** | ❌ No | Custom D1-based messaging (see `docs/architecture/messaging.md`) |
| **Video** | ❌ No | PlugNmeet handles video (see `docs/vendors/plugnmeet.md`) |

**Source:** CD-008 ("feeds only" clarification)

### Environment Setup

| Environment | Stream App Name | App ID | Secrets Location |
|-------------|----------------|--------|------------------|
| Local dev | DEV (Getstream Message) | `1457190` | `.dev.vars` |
| CF Preview | DEV (Getstream Message) | `1457190` | CF Dashboard |
| CF Production | PROD (brianpeerloop) | `1456912` | CF Dashboard |

**Note:** Local dev and CF Preview share the same DEV app. Production uses a separate PROD app.

#### Environment Variables

See [env-vars-secrets.md](../architecture/env-vars-secrets.md) for the full environment variable reference and deployment workflow.

| Variable | Secret? | Where it lives | Purpose |
|----------|:-------:|----------------|---------|
| `STREAM_API_KEY` | No | `.dev.vars` + `wrangler.toml [vars]` | Client-side feed SDK initialization |
| `STREAM_APP_ID` | No | `.dev.vars` + `wrangler.toml [vars]` | App identifier for SDK |
| `STREAM_API_SECRET` | **Yes** | `.dev.vars` / `.secrets.cloudflare.*` | Server-side token generation and feed management |

**Dev vs Production:** Stream uses separate apps (not just separate keys). The DEV app (`1457190`) and PROD app (`1456912`) have independent feed groups, data, and dashboard configurations. All three values change between environments.

### Feed Types

| Feed | Purpose | Stream Type | Access |
|------|---------|-------------|--------|
| **Main Community Feed** | Platform-wide activity (Town Hall / The Commons) | Flat | All authenticated users |
| **Course Feed** | Course-specific discussion | Flat | Enrolled students + certified Teachers + Creator |
| **Community Feed** | User communities | Flat | Community members |
| **User Timeline** | Personalized aggregated feed of followed content | Aggregated | Own user only |
| **Notification Feed** | User-specific alerts | Notification | Own user only |

**Feed Group Configuration (Stream Dashboard):**

| Group | Type | Feed ID Pattern | Purpose |
|-------|------|-----------------|---------|
| `townhall` | flat | `townhall:main` | The Commons — platform-wide community feed |
| `course` | flat | `course:{courseId}` | Per-course discussions |
| `community` | flat | `community:{communityId}` | User communities |
| `timeline` | aggregated | `timeline:{userId}` | User's personalized feed |
| `notification` | notification | `notification:{userId}` | User alerts |

**Note:** PROD app has an extra `user` feed (flat) from client testing — not used by code.

**Removed:** `instructor` feed group was removed (Feb 2026, Session 190). Use `community` feed instead.

### Follow Relationships

```
timeline:{userId}
  ├── follows → townhall:main
  ├── follows → course:{enrolledCourseId}
  └── follows → community:{joinedCommunityId}
```

When a user enrolls in a course or joins a community, their timeline automatically follows the corresponding feed. This powers the `/feed` page aggregated timeline.

### Key Implementation Files

| File | Purpose |
|------|---------|
| `src/lib/stream.ts` | Edge-compatible REST API client (replaces Node SDK) |
| `src/pages/api/feeds/townhall.ts` | Townhall feed API |
| `src/pages/api/feeds/course/[slug].ts` | Course feed API |
| `src/pages/api/feeds/community/[slug].ts` | Community feed API |

### Explicit Feed Creation Model (2026-01-20, updated 2026-02-05)

Course Discussion Feeds are **not auto-created**. Creators must explicitly enable them, which provides resource control and signals commitment to moderate.

**Note:** Instructor feeds were originally part of this model but were **removed** in Session 190 (Feb 2026). The `community` feed group replaced this use case.

**Database Flags:**

| Table | Columns | Purpose |
|-------|---------|---------|
| `courses` | `discussion_feed_enabled`, `discussion_feed_created_at` | Course discussion feed opt-in |

**API Endpoints:**

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/courses/[slug]/discussion-feed` | GET, POST | Check/toggle course discussion |

**Flow:**
1. Creator visits Course Studio settings
2. Toggles "Enable Discussion Feed"
3. On first enable: Stream feed is created, `discussion_feed_created_at` set
4. On disable: DB flag set false (Stream data preserved for re-enable)
5. Frontend checks `feedEnabled` in API response, shows "Not Available" UI if disabled

**Benefits:**
- Not every course needs discussion (resource control)
- Creator intent (opt-in signals commitment to moderate)
- Stream costs (only create feeds that will be used)
- Progressive disclosure

**See:** `docs/DECISIONS.md` - "Explicit Feed Creation Model (Stream.io)"

### Token Flow

1. User authenticates with PeerLoop backend
2. Backend generates Stream user token (server-side)
3. Client connects to Stream with token
4. Stream SDK handles real-time updates

```typescript
// Token endpoint: POST /api/stream/token
export async function POST(request: Request) {
  const user = await verifyAuth(request);

  const streamToken = streamClient.generateUserToken({
    user_id: user.id,
    validity_in_seconds: 24 * 60 * 60  // 24 hours
  });

  return Response.json({ token: streamToken });
}
```

### Pricing Impact

| Tier | MAU | Price | Genesis Cohort Fit |
|------|-----|-------|-------------------|
| Maker | Up to 100 | Free | ✅ Initial testing |
| Startup | Up to 10,000 | ~$499/mo | ✅ Genesis (60-80 students) |

**Estimate:** Genesis Cohort = 60-80 students + 4-5 creators + Teachers = ~100-150 MAU

**Recommendation:** Start on Maker (free), upgrade to Startup at launch.

### User Stories Covered

| Story ID | Story | Stream Feature |
|----------|-------|----------------|
| US-S025 | X.com-style algorithmic feed | Activity Feeds |
| US-P002 | "My Community" feed | Timeline Feed |
| US-S036-S041 | Feed interactions | Reactions, comments |
| US-S070 | Instructor feed access | Instructor Feed |
| US-C037-C038 | Creator feed management | Feed posting |

### What We're NOT Using Stream For

| Feature | Alternative | Status |
|---------|-------------|--------|
| 1:1 Messaging | Stream Chat OR Custom | ⚠️ Decision Pending |
| Group Chat | Stream Chat OR Custom | ⚠️ Decision Pending |
| Video | PlugNmeet | ✅ Confirmed |

**Messaging Decision:** See `docs/architecture/messaging.md` for full comparison.

### Questions Resolved

| Question | Resolution |
|----------|------------|
| Expected MAU at Genesis? | ~100-150 (free tier OK) |
| All roles need feed access? | Yes, all authenticated users |
| Student-to-student in feed? | Yes, within course feeds only |
| Feed organization? | Per course + per instructor + platform |

### Source Documents

- CD-008 - "Feeds only" clarification
- CD-024 - Instructor feed access model

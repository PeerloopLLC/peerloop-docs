# PeerLoop - Server Architecture

**Version:** v1
**Last Updated:** 2025-12-26
**Status:** RUN-001 Amendment - Step 1
**Dependencies:** hosting-decisions.md, tech-002 through tech-006

> This document defines the server-side architecture for PeerLoop, including the Cloudflare stack, route structure, middleware, service integrations, and environment configuration.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              CLOUDFLARE EDGE                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐   │
│   │  Cloudflare      │     │   Cloudflare     │     │   Cloudflare     │   │
│   │  Pages (Astro)   │────▶│   Workers (API)  │────▶│   D1 (SQLite)    │   │
│   │                  │     │                  │     │                  │   │
│   │  - Static pages  │     │  - /api/* routes │     │  - 37+ tables    │   │
│   │  - SSR pages     │     │  - Middleware    │     │  - Edge-native   │   │
│   │  - React islands │     │  - Auth          │     │                  │   │
│   └──────────────────┘     └────────┬─────────┘     └──────────────────┘   │
│                                     │                                        │
│   ┌──────────────────┐              │              ┌──────────────────┐     │
│   │   Cloudflare     │              │              │   Cloudflare     │     │
│   │   R2 (Storage)   │◀─────────────┼─────────────▶│   KV (Cache)     │     │
│   │                  │              │              │                  │     │
│   │  - Avatars       │              │              │  - Sessions      │     │
│   │  - Course files  │              │              │  - Rate limits   │     │
│   │  - Recordings    │              │              │  - Token cache   │     │
│   └──────────────────┘              │              └──────────────────┘     │
│                                     │                                        │
└─────────────────────────────────────┼────────────────────────────────────────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              │                       │                       │
              ▼                       ▼                       ▼
    ┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐
    │    PlugNmeet     │   │    Stream.io     │   │     Stripe       │
    │    (Video)       │   │    (Feeds)       │   │   (Payments)     │
    │                  │   │                  │   │                  │
    │  - Rooms         │   │  - Activity      │   │  - Checkout      │
    │  - Recordings    │   │  - Notifications │   │  - Connect       │
    │  - Webhooks      │   │  - Real-time     │   │  - Transfers     │
    └──────────────────┘   └──────────────────┘   └──────────────────┘
              │                       │                       │
              ▼                       ▼                       ▼
    ┌──────────────────┐
    │     Resend       │
    │    (Email)       │
    │                  │
    │  - Transactional │
    │  - React Email   │
    │  - Webhooks      │
    └──────────────────┘
```

---

## Project Structure

```
peerloop/
├── src/
│   ├── pages/              # Astro pages (SSR + static)
│   │   ├── index.astro
│   │   ├── courses/
│   │   ├── dashboard/
│   │   └── api/            # API route handlers
│   │       ├── auth/
│   │       ├── users/
│   │       ├── courses/
│   │       ├── sessions/
│   │       ├── payments/
│   │       ├── feeds/
│   │       ├── stream/
│   │       ├── video/
│   │       └── webhooks/
│   │
│   ├── components/         # UI components
│   │   ├── astro/          # Astro components
│   │   └── react/          # React islands
│   │
│   ├── lib/                # Shared libraries
│   │   ├── db/             # D1 database utilities
│   │   │   ├── client.ts
│   │   │   ├── schema.ts
│   │   │   └── migrations/
│   │   │
│   │   ├── auth/           # Authentication
│   │   │   ├── jwt.ts
│   │   │   ├── middleware.ts
│   │   │   └── password.ts
│   │   │
│   │   ├── adapters/       # Service adapters
│   │   │   ├── video/
│   │   │   │   ├── interface.ts       # VideoProvider interface
│   │   │   │   └── plugnmeet.ts       # PlugNmeet implementation
│   │   │   ├── feeds/
│   │   │   │   ├── interface.ts       # FeedProvider interface
│   │   │   │   └── stream.ts          # Stream.io implementation
│   │   │   ├── payments/
│   │   │   │   ├── interface.ts       # PaymentProvider interface
│   │   │   │   └── stripe.ts          # Stripe implementation
│   │   │   └── email/
│   │   │       ├── interface.ts       # EmailProvider interface
│   │   │       └── resend.ts          # Resend implementation
│   │   │
│   │   ├── webhooks/       # Webhook handlers
│   │   │   ├── plugnmeet.ts
│   │   │   ├── stripe.ts
│   │   │   ├── resend.ts
│   │   │   └── stream.ts
│   │   │
│   │   └── utils/          # Utilities
│   │       ├── validation.ts
│   │       ├── rate-limit.ts
│   │       └── response.ts
│   │
│   └── emails/             # React Email templates
│       ├── verification.tsx
│       ├── password-reset.tsx
│       ├── booking-confirmation.tsx
│       └── session-reminder.tsx
│
├── public/                 # Static assets
├── astro.config.mjs        # Astro configuration
├── wrangler.toml           # Cloudflare Workers config
└── package.json
```

---

## Cloudflare Stack Components

### Cloudflare Pages

**Purpose:** Host Astro application (static + SSR)

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import cloudflare from '@astrojs/cloudflare';
import react from '@astrojs/react';

export default defineConfig({
  output: 'server',
  adapter: cloudflare({ mode: 'directory' }),
  integrations: [react()],
});
```

**Capabilities:**
- Static pages (landing, course catalog)
- SSR pages (dashboards, authenticated content)
- React islands (interactive components)
- API routes via `/src/pages/api/*`

### Cloudflare Workers

**Purpose:** API endpoints, middleware, service proxies

All `/api/*` routes run as Workers at the edge.

**Free Tier:** 100K requests/day
**Pro Tier:** 10M requests/month ($20)

**Limitations:**
- 128MB memory limit
- V8 runtime (not Node.js) - some npm packages won't work
- CPU time limits (50ms free, 30s paid)

### Cloudflare D1

**Purpose:** SQLite database at edge

**Genesis Cohort:** Sufficient for 60-80 students
**Migration Path:** D1 → Neon/Supabase Postgres → Dedicated

```typescript
// src/lib/db/client.ts
import { drizzle } from 'drizzle-orm/d1';
import * as schema from './schema';

export function getDb(env: Env) {
  return drizzle(env.DB, { schema });
}
```

### Cloudflare R2

**Purpose:** File storage (S3-compatible)

| Content Type | Location | Notes |
|--------------|----------|-------|
| User avatars | `/avatars/{userId}` | Small files, CDN-served |
| Course thumbnails | `/courses/{courseId}/thumbnail` | CDN-served |
| Course materials | `/courses/{courseId}/materials/*` | PDFs, docs |
| Session recordings | `/recordings/{sessionId}/*` | Replicated from PlugNmeet |

**Key Advantage:** Free egress (no bandwidth charges)

### Cloudflare KV

**Purpose:** Key-value store for sessions, caching

| Use Case | Key Pattern | TTL |
|----------|-------------|-----|
| Session tokens | `session:{sessionId}` | 24 hours |
| Rate limit counters | `rate:{ip}:{endpoint}` | 1 minute |
| Stream token cache | `stream_token:{userId}` | 1 hour |
| Video room cache | `room:{sessionId}` | 2 hours |

---

## Route Structure

### Public Routes

| Route | Method | Purpose |
|-------|--------|---------|
| `/api/auth/signup` | POST | Create account |
| `/api/auth/login` | POST | Authenticate |
| `/api/auth/reset-password` | POST | Request password reset |
| `/api/auth/verify-email` | POST | Verify email token |
| `/api/courses` | GET | List courses |
| `/api/courses/:id` | GET | Course details |
| `/api/categories` | GET | Course categories |
| `/api/creators` | GET | List creators |
| `/api/teachers` | GET | List Teachers |

### Authenticated Routes

| Route | Method | Purpose |
|-------|--------|---------|
| `/api/auth/logout` | POST | End session |
| `/api/auth/refresh` | POST | Refresh token |
| `/api/users/:id` | GET/PATCH | Profile |
| `/api/users/:id/follow` | POST/DELETE | Follow user |
| `/api/enrollments` | GET | User's enrollments |
| `/api/courses/:id/enroll` | POST | Initiate enrollment |
| `/api/sessions` | GET/POST | Sessions |
| `/api/sessions/:id/join` | POST | Get join URL |
| `/api/earnings` | GET | User earnings |
| `/api/notifications` | GET | User notifications |

### Token Generation Routes

| Route | Method | Purpose |
|-------|--------|---------|
| `/api/stream/token` | POST | Generate Stream.io token |
| `/api/video/token` | POST | Generate PlugNmeet join token |

### Service Proxy Routes

| Route | Method | Purpose |
|-------|--------|---------|
| `/api/video/room` | POST | Create PlugNmeet room |
| `/api/video/room/:id/status` | GET | Check room status |
| `/api/feeds/course/:id` | GET/POST | Course feed (gated) |
| `/api/feeds/instructor/:id` | GET | Instructor feed (gated) |
| `/api/payments/connect/onboard` | POST | Start Stripe Connect |
| `/api/payments/connect/status` | GET | Connect account status |

### Webhook Routes

| Route | Method | Sender |
|-------|--------|--------|
| `/api/webhooks/plugnmeet` | POST | PlugNmeet server |
| `/api/webhooks/stripe` | POST | Stripe |
| `/api/webhooks/resend` | POST | Resend |
| `/api/webhooks/stream` | POST | Stream.io (if configured) |

### Admin Routes

| Route | Method | Purpose |
|-------|--------|---------|
| `/api/admin/users` | GET | List users |
| `/api/admin/payouts` | GET/POST | Manage payouts |
| `/api/admin/analytics` | GET | Platform metrics |

---

## Middleware

### Request Flow

```
Request
   │
   ▼
┌──────────────────┐
│  Rate Limiting   │  ← Check KV counters
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│    Validation    │  ← Zod schema validation
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Authentication  │  ← JWT verification (if protected route)
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   Authorization  │  ← Role/permission checks
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│     Handler      │  ← Business logic
└────────┬─────────┘
         │
         ▼
Response
```

### Authentication Middleware

```typescript
// src/lib/auth/middleware.ts
import { verifyJwt, JwtPayload } from './jwt';

export async function requireAuth(request: Request, env: Env): Promise<JwtPayload> {
  const authHeader = request.headers.get('Authorization');

  if (!authHeader?.startsWith('Bearer ')) {
    throw new Response(JSON.stringify({ error: 'Unauthorized' }), {
      status: 401,
      headers: { 'Content-Type': 'application/json' }
    });
  }

  const token = authHeader.slice(7);
  const payload = await verifyJwt(token, env.JWT_SECRET);

  // Optional: Check token not revoked in KV
  const revoked = await env.KV.get(`revoked:${payload.jti}`);
  if (revoked) {
    throw new Response(JSON.stringify({ error: 'Token revoked' }), { status: 401 });
  }

  return payload;
}

export async function optionalAuth(request: Request, env: Env): Promise<JwtPayload | null> {
  try {
    return await requireAuth(request, env);
  } catch {
    return null;
  }
}
```

### Rate Limiting Middleware

```typescript
// src/lib/utils/rate-limit.ts
interface RateLimitConfig {
  maxRequests: number;
  windowSeconds: number;
}

const RATE_LIMITS: Record<string, RateLimitConfig> = {
  '/api/auth/signup': { maxRequests: 5, windowSeconds: 60 },
  '/api/auth/login': { maxRequests: 10, windowSeconds: 60 },
  '/api/auth/reset-password': { maxRequests: 3, windowSeconds: 3600 },
  'default': { maxRequests: 100, windowSeconds: 60 },
};

export async function checkRateLimit(
  request: Request,
  env: Env,
  endpoint: string
): Promise<void> {
  const config = RATE_LIMITS[endpoint] || RATE_LIMITS.default;
  const ip = request.headers.get('CF-Connecting-IP') || 'unknown';
  const key = `rate:${ip}:${endpoint}`;

  const current = parseInt(await env.KV.get(key) || '0');

  if (current >= config.maxRequests) {
    throw new Response(JSON.stringify({ error: 'Rate limit exceeded' }), {
      status: 429,
      headers: {
        'Content-Type': 'application/json',
        'Retry-After': String(config.windowSeconds)
      }
    });
  }

  await env.KV.put(key, String(current + 1), {
    expirationTtl: config.windowSeconds
  });
}
```

### Validation Middleware

```typescript
// src/lib/utils/validation.ts
import { z, ZodSchema } from 'zod';

export async function validateBody<T>(
  request: Request,
  schema: ZodSchema<T>
): Promise<T> {
  const body = await request.json();
  const result = schema.safeParse(body);

  if (!result.success) {
    throw new Response(JSON.stringify({
      error: 'Validation failed',
      details: result.error.flatten()
    }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' }
    });
  }

  return result.data;
}

// Example schemas
export const signupSchema = z.object({
  name: z.string().min(2).max(100),
  email: z.string().email(),
  password: z.string().min(8),
  role: z.enum(['student', 'creator'])
});

export const loginSchema = z.object({
  email: z.string().email(),
  password: z.string()
});
```

---

## Service Adapters

### Adapter Pattern

Each external service is abstracted behind an interface, allowing future replacement without changing application code.

```
┌────────────────────┐
│  Application Code  │
└─────────┬──────────┘
          │ uses interface
          ▼
┌────────────────────┐
│  Provider Interface│  ← VideoProvider, FeedProvider, etc.
└─────────┬──────────┘
          │ implements
          ▼
┌────────────────────┐
│ Concrete Adapter   │  ← PlugNmeetAdapter, StreamAdapter, etc.
└─────────┬──────────┘
          │ calls
          ▼
┌────────────────────┐
│  External Service  │  ← PlugNmeet API, Stream API, etc.
└────────────────────┘
```

### VideoProvider Interface

```typescript
// src/lib/adapters/video/interface.ts
export interface CreateRoomOptions {
  sessionId: string;
  title: string;
  scheduledStart: Date;
  scheduledEnd: Date;
  maxParticipants?: number;
  enableRecording?: boolean;
  moderatorId: string;
}

export interface Room {
  roomId: string;
  meetingUrl: string;
  expiresAt?: Date;
}

export interface Participant {
  userId: string;
  name: string;
  role: 'moderator' | 'attendee';
  avatarUrl?: string;
}

export interface JoinToken {
  token: string;
  joinUrl: string;
}

export interface RoomStatus {
  isActive: boolean;
  participantCount: number;
  recordingActive: boolean;
}

export interface VideoProvider {
  createRoom(options: CreateRoomOptions): Promise<Room>;
  deleteRoom(roomId: string): Promise<void>;
  getJoinToken(roomId: string, participant: Participant): Promise<JoinToken>;
  getRoomStatus(roomId: string): Promise<RoomStatus>;
}
```

### PlugNmeet Adapter

```typescript
// src/lib/adapters/video/plugnmeet.ts
import { VideoProvider, CreateRoomOptions, Room, Participant, JoinToken, RoomStatus } from './interface';
import crypto from 'crypto';

export class PlugNmeetAdapter implements VideoProvider {
  private baseUrl: string;
  private apiKey: string;
  private apiSecret: string;
  private webhookUrl: string;

  constructor(config: { baseUrl: string; apiKey: string; apiSecret: string; webhookUrl: string }) {
    this.baseUrl = config.baseUrl;
    this.apiKey = config.apiKey;
    this.apiSecret = config.apiSecret;
    this.webhookUrl = config.webhookUrl;
  }

  private generateSignature(body: string): string {
    return crypto
      .createHmac('sha256', this.apiSecret)
      .update(body)
      .digest('hex');
  }

  private async request<T>(endpoint: string, body: object): Promise<T> {
    const bodyStr = JSON.stringify(body);
    const response = await fetch(`${this.baseUrl}/auth${endpoint}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'API-KEY': this.apiKey,
        'HASH-SIGNATURE': this.generateSignature(bodyStr),
      },
      body: bodyStr,
    });

    const data = await response.json();
    if (!data.status) {
      throw new Error(data.msg || 'PlugNmeet API error');
    }
    return data;
  }

  async createRoom(options: CreateRoomOptions): Promise<Room> {
    const result = await this.request<{ room_info: { room_id: string; room_sid: string } }>('/room/create', {
      room_id: options.sessionId,
      max_participants: options.maxParticipants || 2,
      metadata: {
        room_title: options.title,
        webhook_url: this.webhookUrl,
        logout_url: `${process.env.APP_URL}/sessions/${options.sessionId}/complete`,
        room_features: {
          allow_webcams: true,
          allow_screen_share: true,
          mute_on_start: false,
          recording_features: {
            is_allow: options.enableRecording ?? true,
            enable_auto_cloud_recording: options.enableRecording ?? true,
          },
          chat_features: { is_allow: true },
          whiteboard_features: { is_allow: true },
        },
      },
    });

    return {
      roomId: result.room_info.room_id,
      meetingUrl: `${this.baseUrl}`,
    };
  }

  async deleteRoom(roomId: string): Promise<void> {
    await this.request('/room/endRoom', { room_id: roomId });
  }

  async getJoinToken(roomId: string, participant: Participant): Promise<JoinToken> {
    const result = await this.request<{ token: string }>('/room/getJoinToken', {
      room_id: roomId,
      user_info: {
        user_id: participant.userId,
        name: participant.name,
        is_admin: participant.role === 'moderator',
        user_metadata: {
          profile_pic: participant.avatarUrl,
          record_webcam: true,
        },
      },
    });

    return {
      token: result.token,
      joinUrl: `${this.baseUrl}/?access_token=${result.token}`,
    };
  }

  async getRoomStatus(roomId: string): Promise<RoomStatus> {
    const result = await this.request<{ is_active: boolean }>('/room/isRoomActive', {
      room_id: roomId,
    });

    return {
      isActive: result.is_active,
      participantCount: 0, // Not available in isRoomActive response
      recordingActive: false,
    };
  }
}
```

### FeedProvider Interface

```typescript
// src/lib/adapters/feeds/interface.ts
export interface FeedActivity {
  id?: string;
  type: string;
  text: string;
  userId: string;
  courseId?: string;
  attachments?: string[];
  to?: string[];
}

export interface FeedProvider {
  generateToken(userId: string, validitySeconds?: number): string;
  addActivity(feedGroup: string, feedId: string, activity: FeedActivity): Promise<string>;
  getActivities(feedGroup: string, feedId: string, options?: { limit?: number; offset?: string }): Promise<FeedActivity[]>;
  follow(feedGroup: string, feedId: string, targetGroup: string, targetId: string): Promise<void>;
  unfollow(feedGroup: string, feedId: string, targetGroup: string, targetId: string): Promise<void>;
}
```

### Stream Adapter

```typescript
// src/lib/adapters/feeds/stream.ts
import { StreamClient } from '@stream-io/node-sdk';
import { FeedProvider, FeedActivity } from './interface';

export class StreamAdapter implements FeedProvider {
  private client: StreamClient;

  constructor(apiKey: string, apiSecret: string) {
    this.client = new StreamClient(apiKey, apiSecret);
  }

  generateToken(userId: string, validitySeconds = 86400): string {
    return this.client.generateUserToken({
      user_id: userId,
      validity_in_seconds: validitySeconds,
    });
  }

  async addActivity(feedGroup: string, feedId: string, activity: FeedActivity): Promise<string> {
    const feed = this.client.feed(feedGroup, feedId);
    const result = await feed.addActivity({
      actor: activity.userId,
      verb: activity.type,
      object: activity.text,
      foreign_id: activity.id,
      to: activity.to,
      course_id: activity.courseId,
      attachments: activity.attachments,
    });
    return result.id;
  }

  async getActivities(
    feedGroup: string,
    feedId: string,
    options?: { limit?: number; offset?: string }
  ): Promise<FeedActivity[]> {
    const feed = this.client.feed(feedGroup, feedId);
    const response = await feed.get({
      limit: options?.limit || 20,
      id_lt: options?.offset,
    });

    return response.results.map((a: any) => ({
      id: a.id,
      type: a.verb,
      text: a.object,
      userId: a.actor,
      courseId: a.course_id,
      attachments: a.attachments,
    }));
  }

  async follow(feedGroup: string, feedId: string, targetGroup: string, targetId: string): Promise<void> {
    const feed = this.client.feed(feedGroup, feedId);
    await feed.follow(targetGroup, targetId);
  }

  async unfollow(feedGroup: string, feedId: string, targetGroup: string, targetId: string): Promise<void> {
    const feed = this.client.feed(feedGroup, feedId);
    await feed.unfollow(targetGroup, targetId);
  }
}
```

### PaymentProvider Interface

```typescript
// src/lib/adapters/payments/interface.ts
export interface CheckoutOptions {
  enrollmentId: string;
  courseId: string;
  studentId: string;
  courseName: string;
  priceInCents: number;
  instructorType: 'creator' | 'teacher';
  creatorId: string;
  teacherId?: string;
  successUrl: string;
  cancelUrl: string;
}

export interface PaymentProvider {
  createCheckoutSession(options: CheckoutOptions): Promise<{ url: string; sessionId: string }>;
  createConnectedAccount(userId: string, email: string, role: string): Promise<string>;
  createOnboardingLink(accountId: string, returnUrl: string, refreshUrl: string): Promise<string>;
  createTransfer(options: {
    amount: number;
    destinationAccountId: string;
    transferGroup: string;
    sourceTransaction?: string;
    metadata?: Record<string, string>;
  }): Promise<string>;
  reverseTransfer(transferId: string): Promise<void>;
  getAccountStatus(accountId: string): Promise<{ payoutsEnabled: boolean; status: string }>;
}
```

### EmailProvider Interface

```typescript
// src/lib/adapters/email/interface.ts
import { ReactElement } from 'react';

export interface SendEmailOptions {
  to: string | string[];
  subject: string;
  react?: ReactElement;
  html?: string;
  text?: string;
  replyTo?: string;
  tags?: { name: string; value: string }[];
  scheduledAt?: Date;
}

export interface EmailProvider {
  send(options: SendEmailOptions): Promise<{ id: string }>;
  sendBatch(emails: SendEmailOptions[]): Promise<{ ids: string[] }>;
}
```

### Resend Adapter

```typescript
// src/lib/adapters/email/resend.ts
import { Resend } from 'resend';
import { EmailProvider, SendEmailOptions } from './interface';

export class ResendAdapter implements EmailProvider {
  private client: Resend;
  private fromAddress: string;

  constructor(apiKey: string, fromAddress: string) {
    this.client = new Resend(apiKey);
    this.fromAddress = fromAddress;
  }

  async send(options: SendEmailOptions): Promise<{ id: string }> {
    const { data, error } = await this.client.emails.send({
      from: this.fromAddress,
      to: options.to,
      subject: options.subject,
      react: options.react,
      html: options.html,
      text: options.text,
      reply_to: options.replyTo,
      tags: options.tags,
      scheduled_at: options.scheduledAt?.toISOString(),
    });

    if (error) {
      throw new Error(`Email send failed: ${error.message}`);
    }

    return { id: data!.id };
  }

  async sendBatch(emails: SendEmailOptions[]): Promise<{ ids: string[] }> {
    const { data, error } = await this.client.batch.send(
      emails.map((e) => ({
        from: this.fromAddress,
        to: e.to,
        subject: e.subject,
        react: e.react,
        html: e.html,
        text: e.text,
        reply_to: e.replyTo,
        tags: e.tags,
      }))
    );

    if (error) {
      throw new Error(`Batch send failed: ${error.message}`);
    }

    return { ids: data!.map((d: any) => d.id) };
  }
}
```

---

## Webhook Architecture

### Webhook Handler Pattern

All webhooks follow a consistent pattern:

1. **Signature Verification** - Validate the request is from the expected sender
2. **Idempotency Check** - Prevent duplicate processing
3. **Event Routing** - Dispatch to appropriate handler
4. **Database Update** - Update our data
5. **Side Effects** - Trigger notifications, replications, etc.
6. **Acknowledge** - Return 200 OK

### Webhook Overview

| Service | Endpoint | Events | DB Impact |
|---------|----------|--------|-----------|
| PlugNmeet | `/api/webhooks/plugnmeet` | participant_joined/left, room_finished, recording_proceeded | session_attendance, sessions |
| Stripe | `/api/webhooks/stripe` | checkout.session.completed, charge.refunded, transfer.paid, account.updated | enrollments, transactions, payment_splits, users |
| Resend | `/api/webhooks/resend` | email.bounced, email.complained, email.failed | users (email status) |
| Stream | `/api/webhooks/stream` | (optional - real-time via client) | - |

### PlugNmeet Webhook Handler

```typescript
// src/lib/webhooks/plugnmeet.ts
import { getDb } from '../db/client';

interface PlugNmeetEvent {
  event: string;
  room: { sid: string; identity: string; name: string };
  participant?: { sid: string; identity: string; name: string };
  recording_info?: { file_path: string; file_size: number };
}

export async function handlePlugNmeetWebhook(event: PlugNmeetEvent, env: Env) {
  const db = getDb(env);

  switch (event.event) {
    case 'participant_joined':
      // Track attendance start
      await db.insert(sessionAttendance).values({
        id: crypto.randomUUID(),
        sessionId: await lookupSessionByRoomId(db, event.room.identity),
        userId: event.participant!.identity, // PeerLoop user ID
        joinedAt: new Date(),
      });
      break;

    case 'participant_left':
      // Track attendance end
      await db.update(sessionAttendance)
        .set({
          leftAt: new Date(),
          durationSeconds: sql`ROUND((julianday('now') - julianday(joined_at)) * 86400)`,
        })
        .where(and(
          eq(sessionAttendance.sessionId, await lookupSessionByRoomId(db, event.room.identity)),
          eq(sessionAttendance.userId, event.participant!.identity),
          isNull(sessionAttendance.leftAt)
        ));
      break;

    case 'room_finished':
      // Mark session complete
      await db.update(sessions)
        .set({ status: 'completed', endedAt: new Date() })
        .where(eq(sessions.plugnmeetRoomId, event.room.identity));

      // Trigger post-session emails
      await triggerSessionCompleteEmails(db, event.room.identity);
      break;

    case 'recording_proceeded':
      // Replicate to R2 and update session
      const r2Url = await replicateRecordingToR2(event.recording_info!, env);
      await db.update(sessions)
        .set({ recordingUrl: r2Url })
        .where(eq(sessions.plugnmeetRoomId, event.room.identity));
      break;
  }
}
```

### Stripe Webhook Handler

```typescript
// src/lib/webhooks/stripe.ts
import Stripe from 'stripe';
import { getDb } from '../db/client';

export async function handleStripeWebhook(request: Request, env: Env) {
  const stripe = new Stripe(env.STRIPE_SECRET_KEY);
  const signature = request.headers.get('stripe-signature')!;
  const body = await request.text();

  const event = stripe.webhooks.constructEvent(
    body,
    signature,
    env.STRIPE_WEBHOOK_SECRET
  );

  const db = getDb(env);

  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object as Stripe.Checkout.Session;
      const { enrollment_id, course_id, student_id, instructor_type, creator_id, teacher_id } =
        session.metadata!;

      // Create enrollment
      await db.update(enrollments)
        .set({ status: 'enrolled', enrolledAt: new Date() })
        .where(eq(enrollments.id, enrollment_id));

      // Create transaction record
      await db.insert(transactions).values({
        id: crypto.randomUUID(),
        enrollmentId: enrollment_id,
        amountCents: session.amount_total!,
        stripePaymentId: session.payment_intent as string,
        status: 'completed',
        paidAt: new Date(),
      });

      // Create payment splits (async - transfers happen later)
      await createPaymentSplits(db, {
        enrollmentId: enrollment_id,
        amountCents: session.amount_total!,
        instructorType: instructor_type as 'creator' | 'teacher',
        creatorId: creator_id,
        teacherId: teacher_id,
      });

      // Auto-follow course and instructor feeds
      await autoFollowOnEnrollment(db, env, student_id, course_id, creator_id);
      break;
    }

    case 'account.updated': {
      const account = event.data.object as Stripe.Account;
      await db.update(users)
        .set({
          stripeAccountStatus: account.capabilities?.transfers === 'active' ? 'active' : 'pending',
          stripePayoutsEnabled: account.payouts_enabled,
        })
        .where(eq(users.stripeAccountId, account.id));
      break;
    }

    case 'charge.refunded': {
      const charge = event.data.object as Stripe.Charge;
      // Handle refund - reverse transfers
      await processRefund(db, stripe, charge.id);
      break;
    }

    case 'transfer.paid': {
      const transfer = event.data.object as Stripe.Transfer;
      await db.update(paymentSplits)
        .set({ status: 'paid', paidAt: new Date() })
        .where(eq(paymentSplits.stripeTransferId, transfer.id));
      break;
    }
  }
}
```

### Resend Webhook Handler

```typescript
// src/lib/webhooks/resend.ts
import { getDb } from '../db/client';

interface ResendEvent {
  type: string;
  created_at: string;
  data: {
    email_id: string;
    from: string;
    to: string[];
    subject: string;
    tags?: { name: string; value: string }[];
  };
}

export async function handleResendWebhook(event: ResendEvent, env: Env) {
  const db = getDb(env);
  const recipientEmail = event.data.to[0];

  switch (event.type) {
    case 'email.bounced':
      // Mark email as invalid
      await db.update(users)
        .set({ emailStatus: 'bounced' })
        .where(eq(users.email, recipientEmail));
      break;

    case 'email.complained':
      // User marked as spam - opt out of marketing
      await db.update(users)
        .set({ marketingOptOut: true })
        .where(eq(users.email, recipientEmail));
      break;

    case 'email.failed':
      // Log for investigation
      console.error('Email delivery failed:', event.data);
      break;
  }
}
```

---

## Token Provider Endpoints

### Stream Token Generation

```typescript
// src/pages/api/stream/token.ts
export async function POST({ request, locals }: APIContext) {
  const user = await requireAuth(request, locals.env);

  const stream = new StreamAdapter(
    locals.env.STREAM_API_KEY,
    locals.env.STREAM_API_SECRET
  );

  const token = stream.generateToken(user.id, 24 * 60 * 60); // 24 hours

  return new Response(JSON.stringify({ token }), {
    headers: { 'Content-Type': 'application/json' }
  });
}
```

### Video Join Token Generation

```typescript
// src/pages/api/video/token.ts
import { PlugNmeetAdapter } from '@/lib/adapters/video/plugnmeet';

export async function POST({ request, locals }: APIContext) {
  const user = await requireAuth(request, locals.env);
  const { sessionId } = await request.json();

  // Verify user is participant in this session
  const db = getDb(locals.env);
  const session = await db.query.sessions.findFirst({
    where: or(
      and(eq(sessions.id, sessionId), eq(sessions.studentId, user.id)),
      and(eq(sessions.id, sessionId), eq(sessions.teacherId, user.id))
    ),
    with: { enrollment: { with: { course: true } } }
  });

  if (!session) {
    return new Response(JSON.stringify({ error: 'Not authorized' }), { status: 403 });
  }

  const video = new PlugNmeetAdapter({
    baseUrl: locals.env.PLUGNMEET_URL,
    apiKey: locals.env.PLUGNMEET_API_KEY,
    apiSecret: locals.env.PLUGNMEET_API_SECRET,
    webhookUrl: `${locals.env.APP_URL}/api/webhooks/plugnmeet`,
  });

  const { token, joinUrl } = await video.getJoinToken(session.plugnmeetRoomId!, {
    userId: user.id,
    name: user.name,
    role: user.id === session.teacherId ? 'moderator' : 'attendee',
    avatarUrl: user.avatarUrl,
  });

  return new Response(JSON.stringify({ token, joinUrl }), {
    headers: { 'Content-Type': 'application/json' }
  });
}
```

---

## Environment Configuration

### Required Environment Variables

```bash
# Cloudflare (auto-set in Pages/Workers)
CLOUDFLARE_ACCOUNT_ID=xxx
CLOUDFLARE_API_TOKEN=xxx

# D1 Database (bound in wrangler.toml)
# Accessed via env.DB

# R2 Storage (bound in wrangler.toml)
# Accessed via env.R2

# KV Namespace (bound in wrangler.toml)
# Accessed via env.KV

# Application
APP_URL=https://peerloop.com
JWT_SECRET=xxx
JWT_EXPIRY=86400  # 24 hours

# PlugNmeet
PLUGNMEET_URL=https://video.peerloop.com
PLUGNMEET_API_KEY=xxx
PLUGNMEET_API_SECRET=xxx

# Stream.io
STREAM_API_KEY=xxx
STREAM_API_SECRET=xxx

# Stripe
STRIPE_SECRET_KEY=xxx
STRIPE_WEBHOOK_SECRET=xxx
STRIPE_PUBLISHABLE_KEY=xxx  # client-side

# Resend
RESEND_API_KEY=xxx
RESEND_FROM_ADDRESS=PeerLoop <[email protected]>
```

### wrangler.toml

```toml
name = "peerloop"
compatibility_date = "2024-01-01"

[site]
bucket = "./dist"

[[d1_databases]]
binding = "DB"
database_name = "peerloop-db"
database_id = "xxx"

[[r2_buckets]]
binding = "R2"
bucket_name = "peerloop-assets"

[[kv_namespaces]]
binding = "KV"
id = "xxx"

[vars]
APP_URL = "https://peerloop.com"
JWT_EXPIRY = "86400"
RESEND_FROM_ADDRESS = "PeerLoop <noreply@mail.peerloop.com>"

# Secrets (set via wrangler secret put)
# JWT_SECRET, PLUGNMEET_API_SECRET, STREAM_API_SECRET, STRIPE_SECRET_KEY, etc.
```

### Type Definitions

```typescript
// src/env.d.ts
interface Env {
  // Cloudflare Bindings
  DB: D1Database;
  R2: R2Bucket;
  KV: KVNamespace;

  // Application
  APP_URL: string;
  JWT_SECRET: string;
  JWT_EXPIRY: string;

  // PlugNmeet
  PLUGNMEET_URL: string;
  PLUGNMEET_API_KEY: string;
  PLUGNMEET_API_SECRET: string;

  // Stream
  STREAM_API_KEY: string;
  STREAM_API_SECRET: string;

  // Stripe
  STRIPE_SECRET_KEY: string;
  STRIPE_WEBHOOK_SECRET: string;
  STRIPE_PUBLISHABLE_KEY: string;

  // Resend
  RESEND_API_KEY: string;
  RESEND_FROM_ADDRESS: string;
}
```

---

## Error Handling

### Standard Error Response Format

```typescript
interface ErrorResponse {
  error: string;
  code?: string;
  details?: Record<string, any>;
}

// HTTP Status Codes
// 400 - Validation errors, bad requests
// 401 - Unauthorized (not logged in)
// 403 - Forbidden (logged in but not allowed)
// 404 - Resource not found
// 409 - Conflict (duplicate, etc.)
// 429 - Rate limit exceeded
// 500 - Internal server error
```

### Error Helper

```typescript
// src/lib/utils/response.ts
export function errorResponse(
  status: number,
  error: string,
  details?: Record<string, any>
): Response {
  return new Response(
    JSON.stringify({ error, ...(details && { details }) }),
    {
      status,
      headers: { 'Content-Type': 'application/json' }
    }
  );
}

export function jsonResponse<T>(data: T, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json' }
  });
}
```

---

## Security Considerations

### Authentication
- JWT tokens with short expiry (24h)
- Refresh token rotation
- Token revocation via KV store

### Webhook Security
- **PlugNmeet:** HMAC-SHA256 signature verification
- **Stripe:** `stripe.webhooks.constructEvent()` verification
- **Resend:** Verify webhook source (IP allowlist or signature)

### Rate Limiting
- Per-IP rate limits on sensitive endpoints
- Stricter limits on auth endpoints

### Input Validation
- Zod schemas for all request bodies
- Sanitize user-generated content before storage

### Access Control
- Role-based access (Student, Creator, Teacher, Admin, Moderator)
- Resource ownership checks
- Server-side feed gating for Stream.io

---

## Logging & Monitoring

### Cloudflare Analytics
- Request metrics
- Error rates
- Response times

### Application Logging

```typescript
// Structured logging for Workers
function log(level: 'info' | 'warn' | 'error', message: string, data?: Record<string, any>) {
  console.log(JSON.stringify({
    level,
    message,
    timestamp: new Date().toISOString(),
    ...data
  }));
}
```

### Key Metrics to Track
- Authentication success/failure rates
- Payment conversion rates
- Session completion rates
- Webhook processing times
- Error rates by endpoint

---

## References

### Cloudflare Documentation
- [Cloudflare Pages](https://developers.cloudflare.com/pages/)
- [Cloudflare Workers](https://developers.cloudflare.com/workers/)
- [Cloudflare D1](https://developers.cloudflare.com/d1/)
- [Cloudflare R2](https://developers.cloudflare.com/r2/)
- [Cloudflare KV](https://developers.cloudflare.com/kv/)

### Service Documentation
- [PlugNmeet API](https://www.plugnmeet.org/docs/api/intro)
- [Stream.io Activity Feeds](https://getstream.io/activity-feeds/docs/)
- [Stripe Connect](https://docs.stripe.com/connect)
- [Resend API](https://resend.com/docs)

### Related Project Documents
- `docs/tech/tech-002-stream.md` - Stream.io details
- `docs/tech/tech-003-stripe.md` - Stripe Connect details
- `docs/tech/tech-004-resend.md` - Resend details
- `docs/tech/tech-006-plugnmeet.md` - PlugNmeet details
- `runs/run-001/assets/hosting-decisions.md` - Hosting decisions
- `DB-SCHEMA.md` - Database schema
- `API.md` - API endpoints

---

## Document History

| Version | Date | Changes |
|---------|------|---------|
| v1 | 2025-12-26 | Initial server architecture (RUN-001 Amendment Step 1) |

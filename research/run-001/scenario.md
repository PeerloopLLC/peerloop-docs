# PeerLoop - Technical Specification

**Scenario:** RUN-001
**Generated:** 2025-12-24
**Status:** Draft
**Base:** sc-002 (Stream feeds + VideoProvider interface)

---

## Run Lineage

| Field | Value |
|-------|-------|
| Run ID | RUN-001 |
| Base Scenario | sc-002 |
| Generated | 2025-12-24 |

### Source Versions

| Document | Version | Date |
|----------|---------|------|
| GOALS.md | v3 | 2025-12-24 |
| USER-STORIES.md | v8 | 2025-12-24 |
| DIRECTIVES.md | v1 | 2025-11-30 |
| DB-SCHEMA.md | v1 | 2025-12-24 |
| PAGES.md | v1 | 2025-12-23 |
| COMPONENTS.md | v1 | 2025-12-23 |
| API.md | v1 | 2025-12-23 |

**Lineage Status:** ✅ Current

---

## 1. Executive Summary

### What We're Building

**PeerLoop** is a peer-to-peer learning platform that solves the "2 Sigma Problem" by making 1-on-1 tutoring affordable and scalable through a learn-teach-earn flywheel.

### The Flywheel

```
Student enrolls ($450)
    ↓
Student learns from Student-Teacher
    ↓
Student completes → S-T recommends → Creator certifies
    ↓
Creator approves payout → 85/15 split via Stripe
    ↓
Student becomes Student-Teacher → Teaches new students
    ↓
Cycle repeats 🔄
```

### Key Metrics

| Metric | Target |
|--------|--------|
| Course Completion Rate | ≥75% (vs 15-20% MOOC average) |
| Student-to-Teacher Conversion | 10-20% |
| Genesis Cohort | 60-80 students, 4-5 courses |
| Timeline | 4 months |
| Budget | $75,000 |

### Pricing Model (from CD-033)

- **Single price point per course** - Course price = S-T price (no Teacher premium)
- **Revenue split:** 85% to creator/S-T, 15% to platform
- **Any-time refunds** - Students can exit and get refund at any time

---

## 2. Technology Stack

### Confirmed Stack (from DIRECTIVES.md)

| Layer | Technology | Directive | Notes |
|-------|------------|-----------|-------|
| **Video Conferencing** | VideoProvider Interface | DIR-001 | BBB/PlugNmeet/Daily.co - selection deferred |
| **Activity Feeds** | Stream.io | DIR-002 | Feeds only (not chat) |
| **Hosting/Edge** | Cloudflare | DIR-003 | Pages, Workers, R2, D1 |
| **UI Framework** | React.js | DIR-006 | Component library |
| **Styling** | TailwindCSS | DIR-005 | Utility-first CSS |
| **Meta-framework** | Astro.js | DIR-004 | React islands, SSG/SSR |
| **Payments** | Stripe | CD-020 | Connect for payouts |

### Recommended Additions

| Layer | Technology | Rationale |
|-------|------------|-----------|
| **Database** | Cloudflare D1 (SQLite) | Aligns with Cloudflare preference, low cost |
| **Auth** | Custom JWT | Simple, no vendor lock-in |
| **File Storage** | Cloudflare R2 | S3-compatible, no egress fees |
| **Email** | Resend or Cloudflare Email | Transactional email |
| **Calendar** | TBD (Open Question) | Cal.com vs custom vs Google |

### VideoProvider Interface

Video platform is abstracted behind an interface (defined in API.md):

```typescript
interface VideoProvider {
  createRoom(options: CreateRoomOptions): Promise<Room>;
  deleteRoom(roomId: string): Promise<void>;
  getJoinUrl(roomId: string, participant: Participant): Promise<string>;
  startRecording(roomId: string): Promise<RecordingId>;
  stopRecording(recordingId: string): Promise<RecordingUrl>;
  getRecording(recordingId: string): Promise<RecordingUrl>;
  getRoomStatus(roomId: string): Promise<RoomStatus>;
}
```

**Compliant providers:** BigBlueButton, PlugNmeet, Daily.co

---

## 3. Scope & User Stories

### MVP Scope: 144 P0 Stories

| Role | P0 Count | Key Capabilities |
|------|----------|------------------|
| Visitor/Guest | 11 | Browse, signup, login |
| Admin | 16 | Onboard creators, process refunds, monitor |
| Creator | 12 | View students, approve certs/payouts/S-Ts |
| Student | 36 | Enroll, learn, book sessions, progress |
| Student-Teacher | 12 | Set availability, teach, earn 70% |
| Employer/Funder | 0 | (P1 - not MVP) |
| Session (System) | 4 | BBB integration, recording |
| Platform | 51 | Auth, payments, notifications, feed |
| Moderator | 2 | Delete posts, flagged queue |

### Block Sequence

| Block | Weeks | What's Built |
|-------|-------|--------------|
| **Block 1** | 4-5 | Core flywheel: enroll, pay, sessions, basic messaging |
| **Block 2** | 4-5 | Community feed, profiles, certifications |
| **Block 3** | 4-6 | Full features, polish, admin tools |
| **Buffer** | 2 | Testing, bug fixes |
| **Total** | 14-18 | Launch: April-May 2026 |

### Feature Removal Strategy

Timeline is fixed at 4 months. If scope exceeds timeline, features are removed (not timeline extended). Removal priority (remove last first):

1. Goodwill points system (Block 2+)
2. Feed companion UI
3. AI chat in feed
4. Group sessions
5. Homework system
6. Newsletter features

---

## 4. User Personas & Journeys

### 7 Human Personas

| Persona | Story Prefix | Journey Summary |
|---------|-------------|-----------------|
| **Visitor** | US-G | Browse → Sign up → Become Student |
| **Student** | US-S | Enroll → Learn → Complete → Become S-T |
| **Student-Teacher** | US-T | Set availability → Teach → Earn 70% → Recommend certs |
| **Creator** | US-C | Create course → Approve S-Ts → Approve certs → Earn 15% |
| **Admin (Brian)** | US-A | Onboard creators → Monitor → Refunds → 3-4 hrs/week |
| **Moderator** | US-M | Delete posts → Ban users → (Post-MVP) |
| **Employer** | US-E | Pay for employee → Track progress → (P1) |

### Enrollment Flow (from CD-033)

1. Student finds course, clicks to view details
2. Clicks **Enroll** button
3. Sees **S-T availability calendar** with dots on available dates
4. Sees **S-T list with available times** below calendar
5. Click S-T for detail OR click time to book
6. **"Schedule Later"** button available
7. After purchase: access to course feed + booking rights

---

## 5. Architecture Overview

### System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Client (Browser)                         │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    Astro.js + React                          ││
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐││
│  │  │  Pages   │ │Components│ │  Stream  │ │  VideoProvider   │││
│  │  │  (SSG)   │ │ (React)  │ │   SDK    │ │    (BBB/etc)     │││
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────────┘││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Cloudflare Edge                              │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────────────────┐ │
│  │    Pages     │ │   Workers    │ │          R2              │ │
│  │   (Static)   │ │    (API)     │ │    (File Storage)        │ │
│  └──────────────┘ └──────────────┘ └──────────────────────────┘ │
│                          │                                       │
│                          ▼                                       │
│                   ┌──────────────┐                              │
│                   │      D1      │                              │
│                   │   (SQLite)   │                              │
│                   └──────────────┘                              │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
       ┌──────────┐    ┌──────────┐    ┌──────────┐
       │  Stripe  │    │  Stream  │    │VideoProvider│
       │(Payments)│    │ (Feeds)  │    │(BBB/etc) │
       └──────────┘    └──────────┘    └──────────┘
```

### Data Flow

1. **Static pages** served from Cloudflare Pages (Astro SSG)
2. **API requests** handled by Cloudflare Workers
3. **Database** is Cloudflare D1 (SQLite at edge)
4. **Files** stored in Cloudflare R2
5. **Feeds** managed by Stream.io SDK
6. **Video** abstracted through VideoProvider interface
7. **Payments** processed via Stripe Connect

---

## 6. Database Schema (Reference)

Full schema defined in `DB-SCHEMA.md`. Key entities:

### Core Entities

| Entity | Purpose | Key Fields |
|--------|---------|------------|
| `users` | All users (multi-role) | id, email, name, handle, role flags |
| `courses` | Course catalog | id, creator_id, title, price_cents, level |
| `enrollments` | Student-course relationship | user_id, course_id, status, enrolled_at |
| `sessions` | 1-on-1 tutoring sessions | id, student_id, teacher_id, video_room_id |
| `certificates` | Completion/teaching certs | user_id, course_id, type, issued_at |

### Payment Entities

| Entity | Purpose | Key Fields |
|--------|---------|------------|
| `transactions` | Payment records | id, enrollment_id, amount_cents, stripe_id |
| `payment_splits` | Revenue distribution | transaction_id, recipient_id, amount, type |
| `payouts` | Stripe Connect payouts | id, user_id, amount, status |
| `refunds` | Refund records | id, transaction_id, reason, processed_at |

### Feed Entities (Stream-managed)

| Entity | Purpose | Notes |
|--------|---------|-------|
| `posts` | Feed posts | Managed by Stream.io |
| `follows` | User follows | Synced to Stream |
| `course_follows` | Course follows | Synced to Stream |

---

## 7. Pages (Reference)

Full inventory in `PAGES.md`. Summary:

### Page Count: 27

| Category | Count | Examples |
|----------|-------|----------|
| Public | 10 | Homepage, Course Browse, Course Detail, Login |
| Authenticated | 14 | Dashboard, Feed, Messages, Session Booking |
| Role-Specific | 3 | Creator Studio, Admin Dashboard, Moderator Queue |

### Key Pages for MVP

| Page | URL | Priority |
|------|-----|----------|
| Homepage | `/` | P0 |
| Course Browse | `/courses` | P0 |
| Course Detail | `/courses/:slug` | P0 |
| Login/Signup | `/login`, `/signup` | P0 |
| Dashboard | `/dashboard` | P0 |
| Session Booking | `/courses/:id/book` | P0 |
| Session Room | `/session/:id` | P0 |
| My Community (Feed) | `/community` | P0 |

---

## 8. Components (Reference)

Full library in `COMPONENTS.md`. Key component categories:

| Category | Components | Purpose |
|----------|------------|---------|
| Cards | CourseCard, CreatorCard, STCard, SessionCard | List/grid displays |
| Profile | ProfileHeader, QualificationsList, ExpertiseTags | User profiles |
| Course | LearningObjectives, Curriculum, LevelBadge | Course detail |
| Feed | PostComposer, PostCard, FeedFilters | Stream integration |
| Session | AvailabilityCalendar, BookingFlow, VideoEmbed | Scheduling/video |

---

## 9. API Endpoints (Reference)

Full API in `API.md`. Key endpoint groups:

| Group | Endpoints | Purpose |
|-------|-----------|---------|
| Auth | `/auth/*` | Signup, login, logout, reset |
| Users | `/users/*` | Profiles, follow, S-T directory |
| Courses | `/courses/*` | Browse, detail, enroll |
| Sessions | `/sessions/*` | Book, cancel, join |
| Payments | `/payments/*` | Checkout, split, payout, refund |
| Feed | `/feed/*` | Posts (via Stream SDK) |
| Admin | `/admin/*` | User management, analytics |

### Webhook Integrations

| Service | Webhooks | Purpose |
|---------|----------|---------|
| Stripe | `checkout.session.completed`, `payout.*` | Payment events |
| VideoProvider | `room.ended`, `recording.ready` | Session events |
| Stream | `message.new`, `reaction.new` | Feed events |

---

## 10. Third-Party Integrations

### Stream.io (Feeds)

| Feature | Usage |
|---------|-------|
| Activity Feeds | Main community feed, course feeds, instructor feeds |
| Follow System | User follows, course follows |
| Feed Types | Timeline, Notification, Aggregated |
| React SDK | `@stream-io/react-activity-feed` |

**NOT using Stream for:** Chat (build custom), Video (use VideoProvider)

### Stripe (Payments)

| Feature | Usage |
|---------|-------|
| Checkout | Course enrollment payments |
| Connect | Creator/S-T payouts (Express accounts) |
| Webhooks | Payment confirmation, payout status |
| Split Payments | 85/15 platform split |

### VideoProvider (BBB/PlugNmeet/Daily.co)

| Feature | Usage |
|---------|-------|
| Video Rooms | 1-on-1 tutoring sessions |
| Screen Sharing | Collaborative learning |
| Recording | Session recordings |
| Webhooks | Session end, recording ready |

**Implementation:** Adapter pattern - implement `VideoProvider` interface for chosen platform.

---

## 11. Non-Functional Requirements

### Performance

| Metric | Target |
|--------|--------|
| Page Load (LCP) | < 2.5s |
| Time to Interactive | < 3.5s |
| API Response (p95) | < 500ms |
| Session Join | < 5s |

### Scalability

| Metric | Initial Target |
|--------|----------------|
| Concurrent Users | 500 |
| Sessions/Week | 60 |
| Courses | 10 |
| Total Users | 1,000 |

### Security

- HTTPS everywhere
- JWT authentication with refresh tokens
- Rate limiting on auth endpoints
- Input validation/sanitization
- Stripe PCI compliance (hosted checkout)
- No PII in logs

### Monitoring

- Cloudflare Analytics
- Error tracking (Sentry or similar)
- Stripe Dashboard for payments
- Stream Dashboard for feeds

---

## 12. Assumptions & Open Items

### Assumptions Made

| Topic | Assumption | Source |
|-------|------------|--------|
| Feed Technology | Stream.io confirmed | DIR-002 |
| Bluesky | Not using (Stream preferred) | Question #1, #8 |
| Profile Default | Public | Question #10 |
| Certificates | Single type for MVP | Question #9 |
| Group Sessions | Excluded from MVP (1:1 only) | Question #17 |
| Homework | Excluded from MVP | Question #20 |
| Moderators | Post-MVP | CD-032 |
| Newsletter | Excluded from MVP | Question #5, #7 |
| AI Assistant | Excluded from MVP | Question #6 |

### Open Items for Implementation

| Item | Decision Needed | Impact |
|------|-----------------|--------|
| Calendar System | Cal.com vs custom vs Google | Booking flow |
| Video Provider | BBB vs PlugNmeet vs Daily.co | Cost, hosting |
| Email Provider | Resend vs Cloudflare Email | Notifications |
| Course Completion | Exact criteria | Certification flow |

### Questions Still Open

21 questions remain open in QUESTIONS-FOR-BRIAN.md. See `run-001.md` for full status table with assumptions made for each.

---

## 13. Implementation Notes

### Block 1 Focus (Weeks 1-5)

1. **Core Auth** - Signup, login, password reset
2. **Course Catalog** - Browse, detail, basic CRUD
3. **Enrollment** - Payment via Stripe, enrollment record
4. **Session Booking** - Availability, calendar, booking
5. **Video Integration** - VideoProvider adapter, join session
6. **Basic Messaging** - 1-on-1 messages (not full feed yet)

### Block 2 Focus (Weeks 6-10)

1. **Community Feed** - Stream.io integration
2. **Profiles** - Full profile pages, follow system
3. **Certifications** - Issue, verify, display
4. **S-T Application** - Apply, approve workflow
5. **Earnings Dashboard** - View earnings, pending payouts

### Block 3 Focus (Weeks 11-16)

1. **Admin Tools** - User management, analytics
2. **Creator Studio** - Course editing, curriculum
3. **Polish** - UX improvements, edge cases
4. **Testing** - E2E tests, load testing

---

## 14. Handoff Checklist

Before implementation begins, confirm:

- [ ] Video provider selected (or confirm interface-first approach)
- [ ] Calendar system selected
- [ ] Cloudflare account setup (Pages, Workers, D1, R2)
- [ ] Stripe account setup (Connect enabled)
- [ ] Stream.io account setup
- [ ] Domain configured (peerloop.com on Cloudflare)
- [ ] Development environment documented

---

**End of Scenario**

*Generated by Claude Code for RUN-001*
*Source: /runs/run-001/run-001.md*

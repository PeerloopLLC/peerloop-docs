# Helpers Inventory

Source of truth: `../Peerloop/src/lib/`

This document inventories the shared helper modules. For API endpoints, see `API-*.md` docs. For component patterns, see `BEST-PRACTICES.md`.

---

## Environment & Infrastructure

| File | Key Exports | Purpose |
|------|-------------|---------|
| `env.ts` | `getEnv()`, `requireEnv()` | Centralized env var access (Cloudflare → process.env fallback) |
| `db/index.ts` | `getDB()`, `queryAll()`, `queryFirst()` | D1 database access + typed query helpers |
| `db/types.ts` | All DB interfaces | TypeScript types matching schema tables |
| `r2.ts` | `getR2()`, `getR2Optional()` | R2 storage bucket access |
| `clock.ts` | `getNow()` | Abstracted clock for testability |
| `timezone.ts` | `localToUTC()`, `utcToLocal()`, `formatForDisplay()` | Timezone conversion (server-side) |
| `version.ts` | `getVersion()` | App version from build-time define |
| `webhook-auth.ts` | `verifyBBBWebhook()` | BBB webhook JWT verification |

## Auth & Users

| File | Key Exports | Purpose |
|------|-------------|---------|
| `auth/` | `setAuthCookies()`, `clearAuthCookies()`, `getAuthUser()` | JWT session management |
| `current-user.ts` | `getCurrentUser()`, `useCurrentUser()`, `refreshCurrentUser()` | Client-side user state (read-only cache) |
| `auth-modal.ts` | `showAuthModal()` | Trigger auth modal from any component |

## Business Logic

| File | Key Exports | Purpose |
|------|-------------|---------|
| `enrollment.ts` | `createEnrollment()`, `getEnrollmentStatus()` | Enrollment lifecycle |
| `enrollment-guards.ts` | `checkEnrollmentGuards()` | Pre-enrollment validation (creator, active teacher, etc.) |
| `availability.ts` | `countAvailableSlots()`, `isSlotWithinAvailability()`, `windowToUtc()` | Teacher availability calculations (incl. midnight-spanning windows) |
| `booking.ts` | `createBooking()` | Session booking flow |
| `ratings.ts` | `updateTeacherRating()`, `updateCourseRating()` | Rating aggregation |
| `onboarding.ts` | `getOnboardingStatus()` | Onboarding flow state |

## External Services

| File | Key Exports | Purpose |
|------|-------------|---------|
| `stripe.ts` | `getStripeFromLocals()`, `getStripe()` | Stripe client initialization |
| `stream.ts` | `getStreamClient()` | Stream.io feed client |
| `email.ts` | `sendEmail()` | Resend email integration |
| `video/` | `VideoProvider` interface | BBB/PlugNmeet abstraction |

## UI & Client

| File | Key Exports | Purpose |
|------|-------------|---------|
| `icon-paths.ts` | Icon path registry | SVG paths for Astro `<Icon>` component |
| `toast.ts` | `showToast()` | Toast notification system |
| `request.ts` | `apiFetch()` | Typed fetch wrapper for API calls |
| `mock-data.ts` | Various mock factories | Dev/test data generation |
| `useCanMessage.ts` | `useCanMessage()` | Hook: can current user message target user? |

## Data & Feeds

| File | Key Exports | Purpose |
|------|-------------|---------|
| `feed-activity.ts` | `trackFeedActivity()` | Feed visit/engagement tracking |
| `smart-feed/` | Smart feed scoring | Personalized feed ranking (CQRS: Stream writes, D1 reads) |
| `messaging.ts` | `getConversations()`, `sendMessage()` | Direct messaging helpers |
| `notifications.ts` | `getUnreadCount()`, `markAsRead()` | Notification management |

## SSR

| File | Key Exports | Purpose |
|------|-------------|---------|
| `ssr/` | Extracted SSR functions | Testable server-side logic (extracted from .astro frontmatter) |
| `user-data-version.ts` | `getUserDataVersion()` | Cache-busting version for user data |

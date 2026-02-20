# tech-008-sentry.md

**Service:** Sentry
**Type:** Error Tracking / Application Monitoring
**Website:** https://sentry.io/
**Source:** Technology decision session (2025-12-26)
**Status:** SELECTED (2025-12-26)

---

## Overview

Sentry is the industry-standard error tracking platform, used by over 4 million developers and 100,000+ organizations including Disney, Slack, and Cloudflare. It provides code-level observability with intelligent error grouping, source maps, and real-time alerting.

**Key Value Proposition:**
- Industry standard with massive community (40,000+ GitHub stars)
- Intelligent error grouping (reduces noise)
- Source map support for minified code
- Works natively with Cloudflare Workers/Pages
- Open-source SDKs for all platforms

---

## Why Sentry for PeerLoop

### Decision Context

Evaluated against: **LogRocket** and **Highlight.io**

| Criterion | Sentry | LogRocket | Highlight.io |
|-----------|--------|-----------|--------------|
| Error tracking | Excellent | Good | Good |
| Session replay | No | Yes | Yes |
| Pricing | $29/mo+ | $99/mo+ | Varies |
| Cloudflare support | Proven (CF uses it) | Limited | Limited |
| Maturity | 10+ years | Newer | Newest |

### Why Sentry Won

1. **Best-in-class Error Tracking** - Intelligent grouping, stack traces, source maps
2. **No Overlap with PostHog** - PostHog handles session replays; Sentry focuses on errors
3. **Cloudflare Uses Sentry** - Proven compatibility with our stack
4. **Cost Effective** - $29/mo vs LogRocket's $99/mo
5. **Free Tier** - Covers MVP development phase

### Complementary to PostHog

| Tool | Purpose |
|------|---------|
| **Sentry** | Error tracking, stack traces, alerting |
| **PostHog** | Analytics, session replays, A/B testing |

No duplication - each tool does what it's best at.

---

## Pricing

| Tier | Errors/Month | Cost |
|------|--------------|------|
| Developer | 5,000 | Free |
| Team | 50,000 | $29/mo |
| Business | 100,000+ | $89/mo+ |

**Free Tier Covers:**
- 5,000 errors/month
- 1 user
- Core error tracking features

---

## Features for PeerLoop

### Error Tracking
- **Automatic capture** - Unhandled exceptions, promise rejections
- **Intelligent grouping** - Similar errors grouped together
- **Stack traces** - Full call stack with source maps
- **Breadcrumbs** - User actions leading to error
- **Context** - User info, browser, device, URL

### Source Maps
- Upload source maps during build
- See original TypeScript/React code in stack traces
- Essential for debugging production issues

### Alerting
- Real-time error notifications
- Slack/email integration
- Alert rules (frequency, new issues only)

### Performance Monitoring
- Transaction tracing
- API latency tracking
- Database query performance

---

## Integration

### SDK Installation

```bash
npm install @sentry/astro @sentry/react
```

### Astro Configuration

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import sentry from '@sentry/astro';

export default defineConfig({
  integrations: [
    sentry({
      dsn: 'YOUR_SENTRY_DSN',
      sourceMapsUploadOptions: {
        project: 'peerloop',
        authToken: process.env.SENTRY_AUTH_TOKEN,
      },
    }),
  ],
});
```

### React Error Boundary

```typescript
// src/components/ErrorBoundary.tsx
import * as Sentry from '@sentry/react';

export const ErrorBoundary = Sentry.withErrorBoundary(
  ({ children }) => children,
  {
    fallback: <ErrorFallback />,
    showDialog: true,
  }
);
```

### Manual Error Capture

```typescript
import * as Sentry from '@sentry/react';

// Capture exception
try {
  await riskyOperation();
} catch (error) {
  Sentry.captureException(error, {
    tags: { feature: 'enrollment' },
    extra: { courseId, userId },
  });
}

// Capture message
Sentry.captureMessage('Payment processed', {
  level: 'info',
  tags: { payment: 'stripe' },
});
```

### Cloudflare Workers

```typescript
// For API routes / Workers
import * as Sentry from '@sentry/cloudflare';

export default {
  async fetch(request, env, ctx) {
    Sentry.init({
      dsn: env.SENTRY_DSN,
    });

    try {
      return await handleRequest(request);
    } catch (error) {
      Sentry.captureException(error);
      return new Response('Internal Error', { status: 500 });
    }
  },
};
```

### User Identification

```typescript
// After login
Sentry.setUser({
  id: user.id,
  email: user.email,
  username: user.handle,
});

// On logout
Sentry.setUser(null);
```

---

## Source Maps Upload

### GitHub Actions Integration

```yaml
# .github/workflows/deploy.yml
- name: Upload Source Maps
  run: npx @sentry/cli sourcemaps upload ./dist
  env:
    SENTRY_AUTH_TOKEN: ${{ secrets.SENTRY_AUTH_TOKEN }}
    SENTRY_ORG: peerloop
    SENTRY_PROJECT: peerloop-web
```

### Wrangler Build Hook

```javascript
// wrangler.toml
[build]
command = "npm run build && npx @sentry/cli sourcemaps upload ./dist"
```

---

## Alerting Configuration

### Recommended Alert Rules

| Alert | Condition | Action |
|-------|-----------|--------|
| New Issue | First occurrence of error | Slack + Email |
| Regression | Previously resolved error returns | Slack + Email |
| Spike | >10 errors in 5 minutes | Slack |
| Payment Errors | Tag: feature=payment | Email (high priority) |
| Auth Errors | Tag: feature=auth | Email (high priority) |

### Slack Integration

```
Settings → Integrations → Slack
- Connect workspace
- Choose #peerloop-errors channel
- Configure alert routing
```

---

## Error Tagging Strategy

Consistent tagging helps filter and prioritize errors:

```typescript
Sentry.setTags({
  feature: 'enrollment',      // enrollment, auth, session, payment
  role: 'student',            // student, st, creator, admin
  environment: 'production',  // development, staging, production
});
```

---

## Comparison: Sentry vs LogRocket

| Aspect | Sentry | LogRocket |
|--------|--------|-----------|
| Primary focus | Error tracking | Session replay |
| Error grouping | Excellent | Good |
| Session replay | No | Yes (core feature) |
| Pricing | $29/mo | $99/mo |
| Self-hosting | Available | No |
| Cloudflare | Proven | Limited |

**Decision:** Sentry for errors + PostHog for replays = better than LogRocket alone.

---

## User Stories Covered

| Area | How Sentry Helps |
|------|------------------|
| Debug production errors | Stack traces with source maps |
| Monitor payment failures | Tagged alerts for payment feature |
| Track auth issues | Real-time alerting on auth errors |
| Performance issues | Transaction tracing |
| User-reported bugs | Link error to user context |

---

## References

### Official Documentation
- [Sentry Website](https://sentry.io/)
- [Astro Integration](https://docs.sentry.io/platforms/javascript/guides/astro/)
- [React SDK](https://docs.sentry.io/platforms/javascript/guides/react/)
- [Cloudflare Workers](https://docs.sentry.io/platforms/javascript/guides/cloudflare-workers/)
- [Source Maps](https://docs.sentry.io/platforms/javascript/sourcemaps/)

### Comparisons
- [Sentry vs LogRocket](https://sentry.io/from/logrocket/)
- [Sentry Alternatives](https://signoz.io/comparisons/sentry-alternatives/)

### Pricing
- [Pricing Page](https://sentry.io/pricing/)

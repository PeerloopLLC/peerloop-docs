# tech-007-posthog.md

**Service:** PostHog
**Type:** Product Analytics / Session Replays / Feature Flags / A/B Testing
**Website:** https://posthog.com/
**Source:** Technology decision session (2025-12-26)
**Status:** SELECTED (2025-12-26)

---

## Overview

PostHog is an open-source, all-in-one product analytics platform. It bundles analytics, session replays, A/B testing, and feature flags into one platform, eliminating the need for separate tools.

**Key Value Proposition:**
- All-in-one platform vs multiple point solutions
- Generous free tier (1M events/month)
- Self-hostable for data sovereignty
- Transparent, usage-based pricing

---

## Why PostHog for PeerLoop

### Decision Context

Evaluated against: **Mixpanel** and **Plausible**

| Criterion | PostHog | Mixpanel | Plausible |
|-----------|---------|----------|-----------|
| Product analytics | Yes | Yes | No (web only) |
| Session replays | Yes | No | No |
| Feature flags | Yes | No | No |
| A/B testing | Yes | Limited | No |
| Self-hostable | Yes | No | Yes |
| Free tier | 1M events | Limited | None |

### Why PostHog Won

1. **PMF Metrics Coverage** - Funnels, cohorts, retention analysis for tracking student-to-teacher conversion, course completion rates
2. **Session Replays** - Debug UX issues without separate tool (vs LogRocket)
3. **Feature Flags Included** - A/B testing for experiments (used alongside custom D1 flags for core features)
4. **Generous Free Tier** - 1M events/month covers MVP phase
5. **Cloudflare Compatible** - Works with edge deployments

### What We're NOT Using PostHog For

- **Core feature flags** - Using custom D1 for reliability (no external dependency)
- PostHog flags reserved for **A/B experiments** that can gracefully fail

---

## Pricing

| Tier | Events/Month | Cost |
|------|--------------|------|
| Free | 1M | $0 |
| Growth | 1M+ | ~$0.00031/event |

**Startup Program:** $50,000 in credits available

**Transparency Note:** Each feature (analytics, replays, flags) is priced independently. Most startups (90%) use PostHog for free.

---

## Features for PeerLoop

### Product Analytics
- **Event tracking** - Custom events for key actions
- **Funnels** - Enrollment → Payment → First Session → Completion
- **Cohorts** - Segment by role, course, engagement level
- **Retention** - Track student return rates
- **User paths** - Visualize navigation flows

### Session Replays
- Watch real user sessions
- Identify UX friction points
- Debug issues with context
- Filter by user properties, errors, or pages

### Feature Flags (for A/B Testing)
- Gradual rollouts (10% → 50% → 100%)
- User targeting by properties
- Built-in analytics on flag performance
- **Note:** Use for experiments only; core features use D1 flags

### PMF Metrics to Track

| Metric | PostHog Feature |
|--------|-----------------|
| Course completion rate (≥75%) | Funnel: enroll → complete |
| Student-to-teacher conversion (10-20%) | Cohort: students who became Teachers |
| Session booking rate | Event tracking + funnel |
| User retention | Retention analysis |
| Feature adoption | Event counts by feature |

---

## Integration

### SDK Installation

```bash
npm install posthog-js
```

### React/Astro Setup

```typescript
// src/lib/posthog.ts
import posthog from 'posthog-js';

export const initPostHog = () => {
  if (typeof window !== 'undefined') {
    posthog.init('YOUR_PROJECT_API_KEY', {
      api_host: 'https://app.posthog.com',
      capture_pageview: true,
      capture_pageleave: true,
    });
  }
};

// Identify user after login
export const identifyUser = (userId: string, properties: Record<string, any>) => {
  posthog.identify(userId, properties);
};

// Track custom event
export const trackEvent = (event: string, properties?: Record<string, any>) => {
  posthog.capture(event, properties);
};
```

### Key Events to Track

| Event | When | Properties |
|-------|------|------------|
| `course_viewed` | Course detail page | courseId, creatorId |
| `enrollment_started` | Click enroll | courseId, price |
| `enrollment_completed` | Payment success | courseId, paymentId |
| `session_booked` | Session confirmed | sessionId, teacherId |
| `session_completed` | Session ended | sessionId, duration, rating |
| `lesson_completed` | Mark lesson done | courseId, lessonId, progress |
| `certificate_earned` | Certification issued | courseId, certificateId |
| `became_teacher` | Role upgraded | courseId |

### Feature Flag Usage (A/B Experiments Only)

```typescript
// Check experiment variant
if (posthog.isFeatureEnabled('new_checkout_flow')) {
  // Show new checkout
} else {
  // Show control
}

// Get multivariate flag
const variant = posthog.getFeatureFlag('homepage_hero');
// Returns: 'control' | 'variant_a' | 'variant_b'
```

---

## Comparison: PostHog vs Mixpanel

| Aspect | PostHog | Mixpanel |
|--------|---------|----------|
| Best for | Technical product teams | Non-technical product teams |
| Setup | More complex, flexible | Easier, opinionated |
| Data ownership | Self-host option | Cloud only |
| Pricing | Transparent, usage-based | Can be unpredictable at scale |
| Session replays | Included | Separate tool needed |
| Feature flags | Included | Not available |

---

## Self-Hosting Option

PostHog can be self-hosted for full data control:

```bash
# Docker Compose
git clone https://github.com/PostHog/posthog.git
cd posthog
docker-compose up
```

**When to Self-Host:**
- Data sovereignty requirements
- High event volumes (cost savings)
- Custom retention policies

**For MVP:** Cloud hosted is recommended for simplicity.

---

## User Stories Covered

| Story | How PostHog Helps |
|-------|-------------------|
| Track PMF metrics | Funnels, cohorts, retention |
| Debug UX issues | Session replays |
| A/B test new features | Feature flags |
| Measure course completion | Event tracking + funnels |
| Track conversion rates | Cohort analysis |

---

## References

### Official Documentation
- [PostHog Website](https://posthog.com/)
- [React Integration](https://posthog.com/docs/libraries/react)
- [Feature Flags Guide](https://posthog.com/docs/feature-flags)
- [Session Replay Docs](https://posthog.com/docs/session-replay)

### Comparisons
- [PostHog vs Mixpanel](https://posthog.com/blog/posthog-vs-mixpanel)
- [Best Open Source Analytics Tools](https://posthog.com/blog/best-open-source-analytics-tools)
- [Best Plausible Alternatives](https://posthog.com/blog/best-plausible-alternatives)

### Pricing
- [Pricing Page](https://posthog.com/pricing)
- [Startup Program](https://posthog.com/startups)

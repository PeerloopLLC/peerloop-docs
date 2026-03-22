# Hosting & Infrastructure Decisions - RUN-001

> **⚠️ MIGRATED:** This content has been integrated into `docs/reference/cloudflare.md` (2026-01-19).
> This file is kept for historical reference. For current information, see the tech doc.

**Created:** 2025-12-24
**Updated:** 2025-12-26
**Migrated:** 2026-01-19 → `docs/reference/cloudflare.md`
**Related Global Research:** `docs/reference/comp-cloudflare-vs-vercel.md`

---

## Decision: Cloudflare Stack

RUN-001 uses **Cloudflare** as the primary hosting platform per DIR-003.

### Stack Summary

| Layer | Service | Rationale |
|-------|---------|-----------|
| **Static Hosting** | Cloudflare Pages | Fast, free tier generous |
| **API/Backend** | Cloudflare Workers | Near-zero cold starts |
| **Database** | Cloudflare D1 (SQLite) | Edge-native, low cost |
| **File Storage** | Cloudflare R2 | S3-compatible, free egress |
| **Auth** | Custom JWT | Simple, no vendor lock-in |
| **Email** | Resend ✅ | Developer-friendly, React Email support (revisit Cloudflare Email post-MVP) |
| **Calendar** | Custom built ✅ | With Google/Apple calendar export |

---

## Why Cloudflare over Vercel

**From comp-001-cloudflare-vs-vercel.md:**

| Factor | Cloudflare | Vercel | Winner |
|--------|------------|--------|--------|
| Cost at Scale | Lower | Higher per-request | Cloudflare |
| Free Tier | Commercial use OK | Hobby = personal only | Cloudflare |
| Cold Starts | ~0ms | 100ms-1s | Cloudflare |
| R2 Egress | Free | Paid | Cloudflare |
| Dashboard/DX | Good | Excellent | Vercel |
| Edge Network | 330+ cities | 100+ regions | Cloudflare |

**RUN-001 Decision:** Cloudflare wins on cost and performance, which are critical for a bootstrapped MVP.

---

## Cost Projection

**From comp-001:**

| Phase | Users | Cloudflare Est. | Vercel Est. |
|-------|-------|-----------------|-------------|
| Genesis Cohort | 60-80 | ~$0 (free tier) | $20/mo (must use Pro) |
| Growth | 1,000 | ~$20/mo | $40-60/mo |
| Scale | 10,000 | ~$20-50/mo | $100-200/mo |

**RUN-001 Budget:** Plan for $0-20/month for hosting infrastructure.

---

## Cloudflare Services Used

### Cloudflare Pages
- **Purpose:** Host Astro static pages + SSR
- **Config:** `@astrojs/cloudflare` adapter
- **Free Tier:** 500 builds/month, unlimited bandwidth

```javascript
// astro.config.mjs
import cloudflare from '@astrojs/cloudflare';

export default defineConfig({
  output: 'server',
  adapter: cloudflare({ mode: 'directory' }),
});
```

### Cloudflare Workers
- **Purpose:** API endpoints, BBB proxy, token generation
- **Free Tier:** 100K requests/day
- **Pro:** 10M requests/month for $20

**API Endpoints via Workers:**
- `/api/auth/*` - Authentication
- `/api/users/*` - User management
- `/api/courses/*` - Course operations
- `/api/sessions/*` - Session booking
- `/api/video/*` - VideoProvider proxy

### Cloudflare D1
- **Purpose:** SQLite database at edge
- **Fit:** Good for MVP scale (60-80 students)
- **Limitation:** May need migration to Postgres at scale

**Migration Path:**
```
D1 (MVP) → Neon/Supabase Postgres (Growth) → Dedicated (Scale)
```

### Cloudflare R2
- **Purpose:** File storage (avatars, course materials)
- **Key Advantage:** Free egress (no bandwidth charges)
- **S3-Compatible:** Easy migration if needed

**Storage Use Cases:**
| Content | Location | Notes |
|---------|----------|-------|
| User avatars | R2 | Small files, frequent reads |
| Course thumbnails | R2 | CDN-served |
| Course PDFs | R2 or external links | Per CD-019 |
| Video recordings | PlugNmeet + R2 ✅ | Store on PlugNmeet, replicate to R2 for redundancy |

### Cloudflare KV
- **Purpose:** Session tokens, rate limiting, caching
- **Pattern:** Fast key-value lookups at edge

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    Cloudflare Edge                              │
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │    Pages     │    │   Workers    │    │       R2         │  │
│  │   (Astro)    │◀──▶│    (API)     │◀──▶│   (Storage)      │  │
│  └──────────────┘    └──────────────┘    └──────────────────┘  │
│         │                   │                                   │
│         │                   ▼                                   │
│         │            ┌──────────────┐                          │
│         │            │      D1      │                          │
│         └───────────▶│   (SQLite)   │                          │
│                      └──────────────┘                          │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
       ┌──────────┐    ┌──────────┐    ┌──────────┐
       │  Stripe  │    │  Stream  │    │   BBB/   │
       │          │    │          │    │PlugNmeet │
       └──────────┘    └──────────┘    └──────────┘
```

---

## Environment Setup

### Required Cloudflare Resources
1. **Account:** Free tier sufficient for Genesis
2. **Domain:** peerloop.com configured in Cloudflare
3. **Pages Project:** Linked to GitHub repo
4. **Workers:** API routes
5. **D1 Database:** Created and bound
6. **R2 Bucket:** Created and bound
7. **KV Namespace:** For sessions/caching

### Environment Variables
```bash
# Cloudflare
CLOUDFLARE_ACCOUNT_ID=xxx
CLOUDFLARE_API_TOKEN=xxx

# D1 Database
D1_DATABASE_ID=xxx

# R2 Storage
R2_BUCKET_NAME=peerloop-assets
R2_ACCESS_KEY_ID=xxx
R2_SECRET_ACCESS_KEY=xxx

# External Services
STRIPE_SECRET_KEY=xxx
STREAM_API_KEY=xxx
STREAM_API_SECRET=xxx
VIDEO_PROVIDER_URL=xxx
VIDEO_PROVIDER_SECRET=xxx
```

---

## Limitations & Mitigations

| Limitation | Impact | Mitigation |
|------------|--------|------------|
| D1 SQLite (not Postgres) | Limited SQL features | Keep schema simple, migrate later if needed |
| Workers V8 (not Node.js) | Some npm packages won't work | Use compatible packages, polyfills |
| Workers 128MB memory | Large operations may fail | Offload to external services |
| D1 row limits | May hit at scale | Monitor, plan migration path |

---

## Future Migration Path

If Cloudflare becomes limiting:

1. **Database:** D1 → Neon Postgres (Vercel-friendly) or Supabase
2. **Hosting:** Pages → Vercel (change Astro adapter)
3. **Storage:** R2 → S3 or Vercel Blob
4. **API:** Workers → Vercel Functions

**Migration Effort:** Medium - Astro adapters make it manageable.

---

## Questions Resolved ✅ (2025-12-26)

| Question | Resolution |
|----------|------------|
| Existing accounts? | Assume new Cloudflare account |
| Node.js packages needed? | Minimize, use Workers-compatible |
| Recording storage? | PlugNmeet + replicate to R2 |
| Cost vs DX priority? | Cost (bootstrapped MVP) |
| Email provider? | Resend |
| Calendar system? | Custom built with Google/Apple export |

---

## Post-MVP Considerations

| Service | Current | Consider Post-MVP | Rationale |
|---------|---------|-------------------|-----------|
| Email | Resend | Cloudflare Email Service | Native Workers integration, no API keys, auto DNS config. Currently in private beta - revisit when GA. |

---

## References

- `docs/reference/comp-cloudflare-vs-vercel.md` - Full comparison
- [Cloudflare Pages Docs](https://developers.cloudflare.com/pages/)
- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Cloudflare D1 Docs](https://developers.cloudflare.com/d1/)
- [Cloudflare R2 Docs](https://developers.cloudflare.com/r2/)

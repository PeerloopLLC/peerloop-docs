# comp-001: Cloudflare vs Vercel

**Type:** Deployment Platform Comparison
**Status:** Cloudflare PREFERRED, Vercel ALTERNATIVE
**Research Date:** 2025-11-30
**Sources:**
- https://developers.cloudflare.com/pages/
- https://vercel.com/docs

---

## Overview

Both platforms provide modern deployment infrastructure for Astro/React applications. This comparison evaluates them for Alpha Peer's needs.

## Quick Comparison

| Factor | Cloudflare | Vercel |
|--------|------------|--------|
| **Free Tier** | Generous | Generous |
| **Pricing Model** | Usage-based | Usage-based + seat |
| **Edge Network** | 330+ cities | 100+ regions |
| **Astro Support** | Native adapter | Native adapter |
| **Serverless Runtime** | Workers (V8 isolates) | Functions (Node.js) |
| **Cold Starts** | Near-zero | Variable |
| **Enterprise Features** | Yes | Yes |

## Pricing Comparison

### Cloudflare Pages/Workers

| Tier | Price | Includes |
|------|-------|----------|
| **Free** | $0 | 500 builds/month, 100K Workers requests/day, unlimited bandwidth |
| **Pro** | $20/month | Unlimited builds, 10M Workers requests/month |
| **Enterprise** | Custom | SLA, support, advanced features |

**Key Cost Factors:**
- Workers requests: $0.50 per million after included
- KV storage: $0.50/million reads, $5/million writes
- R2 storage: $0.015/GB/month (egress free)

### Vercel

| Tier | Price | Includes |
|------|-------|----------|
| **Hobby** | $0 | 1M edge requests, 100GB bandwidth, personal use only |
| **Pro** | $20/user/month | 10M edge requests, 1TB bandwidth, commercial use |
| **Enterprise** | Custom | SLA, SSO, advanced support |

**Key Cost Factors:**
- Edge requests: $2/million after included
- Bandwidth: $0.15/GB after included
- Function invocations: $0.60/million after included
- ISR writes: $4/million after included

### Cost Projection for Alpha Peer

| Scenario | Cloudflare | Vercel |
|----------|------------|--------|
| **Genesis Cohort** (3 creators, ~50 users) | ~$0 (Free tier) | ~$0 (Hobby insufficient for commercial) → $20/month Pro |
| **Growth** (1000 MAU) | ~$20/month | ~$40-60/month |
| **Scale** (10,000 MAU) | ~$20-50/month | ~$100-200/month |

**Note:** Vercel's Hobby tier prohibits commercial use, so Alpha Peer would need Pro from launch.

## Technical Comparison

### Edge Runtime

| Feature | Cloudflare Workers | Vercel Edge Functions |
|---------|-------------------|----------------------|
| Runtime | V8 isolates | V8 isolates |
| Cold Start | ~0ms | ~0ms |
| CPU Time | 10-50ms (free), more on paid | 30s max |
| Memory | 128MB | 128MB |
| File System | No (use KV/R2) | No |
| Node.js APIs | Limited (via polyfills) | Limited |

### Serverless Functions

| Feature | Cloudflare Workers | Vercel Functions |
|---------|-------------------|------------------|
| Runtime | V8 (JavaScript/WASM) | Node.js, Python, Go, Ruby |
| Cold Start | Near-zero | 100ms-1s typical |
| Duration | 30s-unlimited (paid) | 10s (free), 60s-900s (paid) |
| Node.js | Polyfilled, some limitations | Full support |

### Astro Integration

**Cloudflare:**
```javascript
// astro.config.mjs
import cloudflare from '@astrojs/cloudflare';

export default defineConfig({
  output: 'server',
  adapter: cloudflare({
    mode: 'directory', // or 'advanced'
  }),
});
```

**Vercel:**
```javascript
// astro.config.mjs
import vercel from '@astrojs/vercel';

export default defineConfig({
  output: 'server',
  adapter: vercel({
    webAnalytics: { enabled: true },
  }),
});
```

### Storage & Databases

| Need | Cloudflare | Vercel |
|------|------------|--------|
| Key-Value | KV (global, eventual consistency) | Edge Config, KV (via partner) |
| Object Storage | R2 (S3-compatible, free egress) | Blob Storage |
| SQL Database | D1 (SQLite at edge) | Postgres (via Neon/Supabase) |
| Caching | Cache API (native) | ISR, Edge Middleware |

### Alpha Peer Storage Considerations

| Data Type | Recommended | Service |
|-----------|-------------|---------|
| User sessions | KV or Redis | Cloudflare KV / Upstash |
| Course content | Object storage | Cloudflare R2 / Vercel Blob |
| User data | PostgreSQL | External (Supabase, Neon, PlanetScale) |
| Chat data | Stream (SaaS) | Stream handles storage |
| Video recordings | BBB server | External to deployment platform |

## Ecosystem Comparison

### Cloudflare Ecosystem
- **Pages:** Static + SSR hosting
- **Workers:** Edge functions
- **KV:** Key-value storage
- **R2:** Object storage (S3-compatible)
- **D1:** SQLite database
- **Queues:** Message queues
- **Email Routing:** Email handling
- **Turnstile:** CAPTCHA alternative
- **Web Analytics:** Privacy-focused analytics

### Vercel Ecosystem
- **Hosting:** Static + SSR
- **Functions:** Serverless compute
- **Edge Middleware:** Request interception
- **Blob Storage:** File storage
- **KV:** Key-value (partner integrations)
- **Postgres:** Database (partner integrations)
- **Web Analytics:** Built-in analytics
- **Speed Insights:** Performance monitoring
- **AI SDK:** Native AI integration

## Developer Experience

| Factor | Cloudflare | Vercel |
|--------|------------|--------|
| CLI | `wrangler` | `vercel` |
| Local Dev | `wrangler dev` | `vercel dev` |
| Preview Deploys | Yes | Yes (excellent) |
| Git Integration | GitHub, GitLab | GitHub, GitLab, Bitbucket |
| Dashboard | Good | Excellent |
| Logs/Monitoring | Workers Analytics | Better observability |
| Documentation | Good | Excellent |

## Alpha Peer-Specific Considerations

### Why Cloudflare Might Be Better

1. **Cost at Scale:** Lower per-request pricing
2. **R2 for Recordings:** Free egress for BBB recording storage
3. **Edge Performance:** 330+ locations vs 100+
4. **Workers for BBB API:** Edge proxy for API calls
5. **Turnstile:** Bot protection without CAPTCHAs

### Why Vercel Might Be Better

1. **Developer Experience:** More polished dashboard
2. **Preview Deploys:** Better PR preview workflow
3. **AI Features:** If adding AI beyond BBB transcription
4. **Node.js Compatibility:** Fewer edge runtime limitations
5. **Observability:** Better built-in monitoring

### Integration with Required Services

| Service | Cloudflare | Vercel |
|---------|------------|--------|
| **BigBlueButton** | Workers proxy API calls | Functions proxy API calls |
| **Stream Chat** | Works (client-side SDK) | Works (client-side SDK) |
| **Stream Feeds** | Works (client-side SDK) | Works (client-side SDK) |

Both platforms work equally well with Stream (client-side) and BBB (server-side proxy needed on both).

## Recommendation

### Primary: Cloudflare

**Rationale:**
1. Better long-term cost efficiency
2. R2 for potential recording storage (free egress)
3. Near-zero cold starts for API proxies
4. Growing ecosystem aligns with Astro direction
5. Turnstile for abuse prevention

### Fallback: Vercel

**When to Consider:**
- Team strongly prefers Vercel DX
- Need Node.js-specific packages
- Want integrated AI features
- Preview deploy workflow is critical

### Hybrid Approach (Advanced)

Could use both:
- **Cloudflare:** API proxies (Workers), static assets, R2 storage
- **Vercel:** Main Astro app with complex SSR needs

*Not recommended for initial development due to complexity.*

## Migration Path

If starting with Cloudflare but needing Vercel later:

1. Astro's adapter system makes switching straightforward
2. Change adapter in `astro.config.mjs`
3. Update environment variables
4. Adjust any Cloudflare-specific code (KV, R2)

## Open Questions

- [ ] Does the team have existing Cloudflare or Vercel accounts?
- [ ] Are there Node.js packages required that don't work in Workers?
- [ ] Will recordings be stored on deployment platform or BBB server?
- [ ] What's the priority: cost optimization vs developer experience?

---

## References

- [Cloudflare Pages Documentation](https://developers.cloudflare.com/pages/)
- [Cloudflare Workers Documentation](https://developers.cloudflare.com/workers/)
- [Vercel Documentation](https://vercel.com/docs)
- [Astro Cloudflare Adapter](https://docs.astro.build/en/guides/deploy/cloudflare/)
- [Astro Vercel Adapter](https://docs.astro.build/en/guides/deploy/vercel/)

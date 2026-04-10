# tech-003: Astro.js

**Type:** Web Framework (Meta-Framework)
**Status:** PREFERRED (Client Leaning)
**Research Date:** 2025-11-30
**Source:** https://astro.build/

---

## Overview

Astro is a JavaScript web framework optimized for building fast, content-driven websites. It uses a server-first architecture with an "Islands" approach to partial hydration, delivering minimal JavaScript to the browser.

## Core Philosophy

| Principle | Description |
|-----------|-------------|
| **Server-First** | Render on server, hydrate selectively |
| **Zero JS by Default** | No JavaScript unless explicitly needed |
| **Islands Architecture** | Interactive components as isolated "islands" |
| **Framework Agnostic** | Use React, Vue, Svelte, etc. together |

## Key Features

### Performance
- **63% of Astro sites achieve good Core Web Vitals** (vs 27% for Next.js)
- Automatic unused JavaScript stripping
- Built-in image optimization
- Minimal client-side runtime

### Developer Experience
| Feature | Description |
|---------|-------------|
| File-based Routing | Pages in `/src/pages/` auto-routed |
| Content Collections | TypeScript-validated markdown/MDX |
| View Transitions | Smooth page morphing |
| Middleware | Server-side request handling |
| Actions | Form handling and mutations |
| SSR + SSG | Static and server rendering modes |

### Framework Integration
Astro supports multiple UI frameworks simultaneously:
- React (via `@astrojs/react`)
- Vue
- Svelte
- Preact
- Solid
- Lit

## React Integration

### Installation
```bash
npx astro add react
```

This installs:
- `@astrojs/react`
- `react`
- `react-dom`
- TypeScript types

### Configuration
```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import react from '@astrojs/react';

export default defineConfig({
  integrations: [react()],
});
```

### Client Directives
Control when React components hydrate:

| Directive | Behavior |
|-----------|----------|
| `client:load` | Hydrate immediately on page load |
| `client:idle` | Hydrate when browser is idle |
| `client:visible` | Hydrate when component enters viewport |
| `client:media` | Hydrate at specific media query |
| `client:only="react"` | Client-only, no SSR |

```astro
---
import ReactComponent from '../components/ReactComponent.jsx';
---

<!-- Static by default -->
<ReactComponent />

<!-- Interactive when visible -->
<ReactComponent client:visible />

<!-- Interactive immediately -->
<ReactComponent client:load />
```

### Children Caveat
Children passed from Astro to React are strings by default:
```javascript
// If library expects React nodes, enable:
export default defineConfig({
  integrations: [react({ experimentalReactChildren: true })],
});
```

## Alpha Peer Architecture Fit

### Suitable For
| Use Case | Astro Approach |
|----------|---------------|
| Course catalog pages | Static generation (SSG) |
| Creator profiles | Static with dynamic islands |
| Dashboard | React islands with `client:load` |
| Marketing pages | Pure static, zero JS |
| Blog/content | Content Collections |

### Islands Strategy for Alpha Peer
```
┌─────────────────────────────────────────────────────────────┐
│                     ASTRO PAGE (Static HTML)                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │ Navigation   │  │ Course Card  │  │ Creator Profile  │  │
│  │ (Static)     │  │ (Static)     │  │ (Static)         │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           STREAM CHAT (React Island)                │   │
│  │           client:load - Full React hydration        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           CALENDAR BOOKING (React Island)           │   │
│  │           client:visible - Hydrate when seen        │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Deployment

### Cloudflare Pages (Preferred)
```javascript
// astro.config.mjs
import cloudflare from '@astrojs/cloudflare';

export default defineConfig({
  output: 'server', // or 'hybrid'
  adapter: cloudflare(),
});
```

### Vercel (Alternative)
```javascript
// astro.config.mjs
import vercel from '@astrojs/vercel';

export default defineConfig({
  output: 'server',
  adapter: vercel(),
});
```

## Caveats

### React 19 SSR on Cloudflare Workers

When using React 19 with the Cloudflare adapter, server-side rendering fails with:
```
ReferenceError: MessageChannel is not defined
```

**Cause:** `@astrojs/cloudflare` aliases `react-dom/server` → `react-dom/server.browser` at build time (in its `astro:build:setup` hook). The `.browser` variant requires `MessageChannel`, which Cloudflare Workers don't have.

**Upstream Fix:** [Astro PR #12996](https://github.com/withastro/astro/pull/12996) and [Adapters PR #506](https://github.com/withastro/adapters/pull/506) removed the problematic alias. Both merged Jan 2025, but the fix shipped in `@astrojs/cloudflare` **v13 beta** (Astro 6 era), NOT in the v12 stable line we use.

**Current Workaround:** Our `astro.config.mjs` overrides the adapter's alias:

```javascript
// astro.config.mjs
vite: {
  resolve: {
    // Override adapter's react-dom/server.browser → use .edge instead
    // See: https://github.com/withastro/astro/issues/12824
    alias: import.meta.env.PROD && {
      'react-dom/server': 'react-dom/server.edge',
    },
  },
},
```

**Note:** Only applies in production builds (`import.meta.env.PROD`). Development uses the standard module.

#### Why This Workaround Is Fragile

The adapter sets its alias in `astro:build:setup`, which runs AFTER our initial config. The adapter code at `node_modules/@astrojs/cloudflare/dist/index.js:190-195` does:

```javascript
// Adapter's astro:build:setup hook
if (Array.isArray(vite.resolve.alias)) {
  vite.resolve.alias = [...vite.resolve.alias, ...aliases]; // array: appends
} else {
  // Object: OVERWRITES our key with .browser
  vite.resolve.alias[alias.find] = alias.replacement;
}
```

Since our alias is an object (`{ 'react-dom/server': '...' }`), the adapter hits the `else` branch and overwrites our `.edge` with `.browser`. However, **the workaround still works in practice** — verified by checking the build output (`dist/_worker.js/`) which contains `react-dom-server.edge.production.js`. The likely reason: Vite's alias resolution order means our earlier-registered alias is checked first.

**Verified:** Session 215 (2026-02-16) — production build contains `.edge`, not `.browser`.

#### When to Remove This Workaround

Remove the `alias` from `astro.config.mjs` when BOTH conditions are met:
1. `@astrojs/cloudflare` v13+ is stable (no longer beta)
2. The adapter no longer aliases `react-dom/server` → `react-dom/server.browser`

To verify: check `node_modules/@astrojs/cloudflare/dist/index.js` for `react-dom/server.browser`. If absent, the workaround can be removed.

**Related:**
- [Astro Issue #12824](https://github.com/withastro/astro/issues/12824) — Closed, fix in v13 beta
- [Astro PR #12996](https://github.com/withastro/astro/pull/12996) — Removed ssr.external from React integration
- [Adapters PR #506](https://github.com/withastro/adapters/pull/506) — Removed alias from Cloudflare adapter
- [React Issue #31827](https://github.com/facebook/react/issues/31827)
- See also: `docs/reference/reactjs.md` and `docs/reference/cloudflare.md`

### Cloudflare Adapter wrangler.toml

The `@astrojs/cloudflare` adapter reads configuration from `wrangler.toml`. Key settings:

```toml
compatibility_date = "2024-12-01"
compatibility_flags = ["nodejs_compat_v2"]  # Recommended for React SSR
pages_build_output_dir = "./dist"
```

Use `nodejs_compat_v2` for better Node.js API support in the Workers runtime.

### Cloudflare Adapter Remote Bindings (adapter 13+)

Under `@astrojs/cloudflare@13`, the legacy `platformProxy` option **no longer exists**. The adapter's `Options` interface now only picks `auxiliaryWorkers | configPath | inspectorPort | persistState | remoteBindings` from `@cloudflare/vite-plugin`'s `PluginConfig`. Remote bindings (connecting `astro dev` to remote D1/R2/KV instead of local emulation) are controlled by two orthogonal mechanisms:

```javascript
// astro.config.mjs
adapter: cloudflare({
  imageService: 'passthrough',
  remoteBindings: process.env.USE_STAGING_DB ? true : undefined,
}),
```

- `remoteBindings: true` — top-level adapter option, forwarded to `@cloudflare/vite-plugin`. Enables remote binding connections for `astro dev`.
- `CLOUDFLARE_ENV=preview` — environment variable read by `@cloudflare/vite-plugin` to select the corresponding `[env.*]` section of `wrangler.toml`. There is no adapter-level equivalent; set it at the CLI (in the npm script).

**Peerloop usage:** `npm run dev:staging` sets `USE_STAGING_DB=1 CLOUDFLARE_ENV=preview` to connect the local dev server to the staging D1 + R2 bindings for bug reproduction. `USE_STAGING_DB` gates the adapter option; `CLOUDFLARE_ENV` picks `[env.preview]` from `wrangler.toml`.

**Auth note:** Remote bindings authenticate via cached wrangler OAuth tokens (`~/.wrangler/config/`), not `CLOUDFLARE_API_TOKEN`. This works from any process, including non-interactive environments.

**See:** `astro.config.mjs`, `package.json` `dev:staging` script, docs/DECISIONS.md (Session 236, Conv 101 adapter 13 migration)

## Considerations for Alpha Peer

### Pros
- Excellent performance for course catalog/discovery
- React integration for complex interactive features
- Flexible SSR/SSG hybrid approach
- Growing ecosystem and community
- First-class Tailwind CSS support
- Native Cloudflare adapter

### Cons
- Less mature than Next.js for complex apps
- Some React patterns need adaptation
- SSR state management differs from Next.js
- Fewer tutorials for enterprise patterns

### When Astro Might NOT Be Ideal
- Heavy real-time interactivity across entire page
- Complex client-side routing requirements
- Deep React ecosystem dependencies (e.g., heavy use of React Query throughout)

## Comparison with Next.js

| Factor | Astro | Next.js |
|--------|-------|---------|
| Performance (CWV) | 63% good | 27% good |
| JS Bundle Size | Minimal | Larger |
| React Integration | Excellent | Native |
| Learning Curve | Moderate | Well-documented |
| Enterprise Adoption | Growing | Established |
| Cloudflare Support | Native adapter | Limited |
| Vercel Support | Good | Excellent |

## Recommendation

**Astro is a good fit for Alpha Peer** because:
1. Course catalog/discovery benefits from static generation
2. Interactive features (chat, calendar) work well as islands
3. Performance is critical for user retention
4. Cloudflare deployment preferred (native adapter)
5. React integration handles complex UI needs

### Suggested Architecture
- **SSG:** Course pages, creator profiles, marketing
- **SSR:** Dashboard, authenticated pages
- **Client Islands:** Chat, calendar, video launch, earnings dashboard

## Open Questions

- [ ] How much of the app requires real-time reactivity?
- [ ] Will there be a mobile app requiring shared React components?
- [ ] What's the team's familiarity with Astro vs Next.js?

---

## Version History

| Date | Package | From | To | Notes |
|------|---------|------|----|-------|
| 2026-02-16 | `astro` | 5.17.1 | 5.17.2 | Proxy Host header fix for SSR |
| 2026-02-16 | `@astrojs/node` | 9.5.2 | 9.5.3 | Patch |
| 2026-02-16 | Adapter config | — | — | Added `imageService: 'passthrough'` and explicit `session` driver |
| 2026-04-10 | `astro` | 5.18.1 | 6.1.5 | PACKAGE-UPDATES Phase 2a (Conv 101) — major version bump |
| 2026-04-10 | `@astrojs/cloudflare` | 12.6.13 | 13.1.8 | PACKAGE-UPDATES Phase 2a — drops `platformProxy`, adds `remoteBindings`, removes `locals.runtime.env` |
| 2026-04-10 | `@astrojs/react` | 4.4.2 | 5.0.3 | PACKAGE-UPDATES Phase 2a — React 19 `server.edge` upstream fix |
| 2026-04-10 | `@cloudflare/workers-types` | (transitive) | ^4.20260410.1 | Re-added as explicit dev dep (adapter 13 stopped pulling it in transitively) |
| 2026-04-10 | Transitive | vite 6.4.2 → 7.3.2, `@vitejs/plugin-react` 4.7.0 → 5.2.0, `@cloudflare/vite-plugin` 1.31.2 (new) | | |

### Current Versions (Conv 101)

| Package | Version | Notes |
|---------|---------|-------|
| `astro` | 6.1.5 | Latest stable |
| `@astrojs/cloudflare` | 13.1.8 | Adapter 13 — uses `@cloudflare/vite-plugin`, removes `locals.runtime.env` |
| `@astrojs/react` | 5.0.3 | React plugin 5 — fixes React 19 `server.edge` issue upstream |
| `@cloudflare/workers-types` | ^4.20260410.1 | Explicit dev dep (Conv 101) |
| `vite` | 7.3.2 | Transitive bump from adapter 13 + react plugin 5 |

### Adapter Configuration

```javascript
// astro.config.mjs — adapter options
cloudflare({
  imageService: 'passthrough',  // Suppress sharp warning, no image optimization
})
```

Valid `imageService` values: `'passthrough'` | `'cloudflare'` | `'compile'` | `'custom'`

---

## References

- [Astro Documentation](https://docs.astro.build/)
- [Astro React Integration](https://docs.astro.build/en/guides/integrations-guide/react/)
- [Astro Cloudflare Adapter](https://docs.astro.build/en/guides/deploy/cloudflare/)
- `docs/as-designed/auth-sessions.md` — JWT vs Astro Sessions decision
- `docs/as-designed/image-handling.md` — Image handling (no-op / passthrough)
- `docs/reference/cloudflare-kv.md` — KV namespace for SESSION binding

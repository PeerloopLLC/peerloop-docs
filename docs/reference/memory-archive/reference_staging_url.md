---
name: reference-staging-url
description: "Staging deployment URL — peerloop-staging.brian-1dc.workers.dev — not derivable from wrangler.toml which only has `<account>` placeholder"
metadata: 
  node_type: memory
  type: reference
  originSessionId: c806262d-fea7-4781-9326-325080f0d2b1
---

Peerloop staging deployment URL: **`https://peerloop-staging.brian-1dc.workers.dev`**

- Cloudflare account slug: `brian-1dc`
- Worker name: `peerloop-staging` (per `wrangler.toml` `env.staging.name`)
- Backed by D1 binding `peerloop-db-staging` (database_id `605f1ab8-62cc-4934-a2fd-d828e188f50e`)
- Same shared BBB Blindside server as dev/prod (`peerloop.api.rna1.blindsidenetworks.com`)

`wrangler.toml` only writes `<account>` as a placeholder in its comment ("Staging Worker URL: peerloop-staging.<account>.workers.dev"), so the actual URL must be supplied at runtime from this memory or the user.

Production URL is on a custom domain — not the worker default URL. (Confirm with user if needed; tentatively not workers.dev.)

---
name: reference_playwright_headless_browser_fallback
description: "When the claude-in-chrome bridge can't reach the local dev server, drive Playwright headless + dev-login instead"
metadata: 
  node_type: memory
  type: reference
  originSessionId: e585e11d-a9dc-4c48-a011-f55e61b3a825
  modified: 2026-07-24T21:47:06.172Z
---

[BRIDGE-UNREACHABLE] The claude-in-chrome bridge's Chrome can refuse EVERY connection to the local dev server (`ERR_CONNECTION_REFUSED` on both `127.0.0.1:4321` AND `localhost:4321`, fresh tab too) while `curl` gets `200` on both — the bridge Chrome routes loopback away (a proxy in its profile). Rebinding + `.vite` cache clear + fresh tab do NOT fix it. Conv 413: burned ~8 turns fighting the bridge before switching.

**Fallback = headless Playwright (self-serve, DOM-truth + screenshots at exact widths):**
- `playwright` (1.59) + chromium are already installed in the code repo.
- Auth: `await ctx.request.post('http://127.0.0.1:4321/api/auth/dev-login', { data: { email } })` sets the cookie in the context (dev-only route, `import.meta.env.DEV`-gated). David = `david.r@example.com`.
- Then `page.setViewportSize({width,height})` → `page.goto(url,{waitUntil:'networkidle'})` → `page.evaluate(...)` / `page.screenshot(...)`. Faithfully reproduces sidebar-collide (real viewport → real `lg:` sidebar toggle).
- **Run the script from INSIDE `~/projects/Peerloop`** (ESM resolves `playwright` from its node_modules; a scratchpad `.mjs` throws `ERR_MODULE_NOT_FOUND`). Write a temp `_hero-probe.mjs` at repo root, `node` it, `rm` after. Screenshots → session scratchpad.

**Dev-server gotchas (Conv 413):** `astro dev` runs as a DAEMON now (`astro dev stop` / `astro dev logs` — SSR/request logs go to `astro dev logs`, NOT launch stdout) and binds IPv6 `[::1]` only by default → a normal Chrome (IPv4 `127.0.0.1`) can't connect; `npm run dev -- --host 127.0.0.1` fixes it for a real browser (did NOT fix the bridge — its problem is the proxy, deeper). Related but distinct: [[reference_chrome_bridge_island_stale_cache]] (stale island STATE, not unreachable server); [[feedback_persistent_dev_server_4321]] (ephemeral dev server); [[feedback_dom_truth_over_screenshots]].

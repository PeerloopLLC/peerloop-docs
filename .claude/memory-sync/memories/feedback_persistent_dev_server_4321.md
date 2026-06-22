---
name: feedback-persistent-dev-server-4321
description: "User keeps a logged-in dev server on :4321 open across convs for CC's browser DOM-verification — reuse it, don't spawn a new one"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d18e8f11-f8b1-4393-95d4-759a68a72f49
---

For browser DOM-verification, **reuse the dev server the user keeps running on `http://localhost:4321`** — they leave it open (logged in, with existing teacher/member tabs) across multiple convs specifically for CC to use. Do NOT `npm run dev` a fresh server on another port and navigate to it.

**Why:** Conv 321 — I spawned my own `astro dev` (it landed on :4324 since 4321 was taken) and the navigate to :4324 was **denied by the user**. The user then clarified: *"using the existing Port 4321. I leave it open for you to use over multiple convs."* The 4321 server runs the same working tree, so on-disk edits are live there via HMR — a separate server buys nothing and adds friction.

**How to apply:** When a task needs browser verification — dev-login on :4321 (`POST /api/auth/dev-login {email}` per [[reference_chrome_bridge_island_stale_cache]]), create a fresh MCP tab (don't reuse the user's existing tabs), navigate to the target route on :4321, settle-then-read. If I accidentally start my own server, stop it (`lsof -ti :<port> | xargs kill`). This is distinct from the [[project_preflip_worktree_reference]] worktree on :4331 (a different, on-demand reference server). Pairs with [[feedback_dom_truth_over_screenshots]] for the verification method.

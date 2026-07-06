---
name: feedback-persistent-dev-server-4321
description: "No persistent dev server anymore — user creates dev servers situationally; when CC needs browser verification it spins up an EPHEMERAL one on-demand and tears it down when done"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d18e8f11-f8b1-4393-95d4-759a68a72f49
---

**There is NO long-running dev server to assume anymore.** As of Conv 366 (2026-07-06) the user retired the always-open `:4321` server; dev servers are now created **situationally**. Do NOT assume `http://localhost:4321` is up, logged-in, or reusable — it usually isn't.

**When a task needs browser DOM-verification and nothing is running: CC spins up its own EPHEMERAL server on-demand, then kills it when the verification (or the conv) is done.** Never leave it running. (User's explicit choice, Conv 366 — over "ask you to start it" and "check then ask".)

**Why:** The old policy (Conv 321) was "reuse the persistent :4321 the user leaves open across convs." That's reversed. And the reason ephemeral servers MUST be torn down: a CC-launched `npm run dev` (via `run_in_background`) is a harness-tracked background shell owned by the **`claude` CLI process, not the conversation**. `/clear` wipes context but does NOT kill or un-track it — so it survives across cleared convs, keeps holding its port for hours, and makes `/quit` warn "a background task (shell) is running." (Conv 366 incident: a dev server launched in a since-cleared context ran 22h on the same CLI process, PID chain zsh→npm→`astro dev`, and blocked a clean `/quit`.)

**How to apply:**
- Need browser verification → start `cd ~/projects/Peerloop && npm run dev` on-demand (it grabs :4321 if free, else falls back). Do the work, then **kill it before ending**: `lsof -ti :<port> | xargs kill` (or kill the whole npm/node tree). Treat teardown as part of the task, not an afterthought.
- Dev-login flow unchanged: `POST /api/auth/dev-login {email}` per [[reference_chrome_bridge_island_stale_cache]]; create a fresh MCP tab, navigate, settle-then-read.
- If you find an orphaned CC-owned dev server from a prior cleared conv (parent = the long-lived `claude` CLI process), it's safe to kill by PID — surface it rather than leaving it.
- Distinct from the [[project_preflip_worktree_reference]] worktree on :4331 (separate on-demand reference server). Pairs with [[feedback_dom_truth_over_screenshots]] for the verification method.

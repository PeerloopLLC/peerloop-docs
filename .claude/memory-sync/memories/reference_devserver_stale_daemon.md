---
name: reference_devserver_stale_daemon
description: "[DEVSRV-STALE] astro dev daemon fails three distinct ways — tell them apart by curl's response (000 / 500 / stale content), never by reading code."
metadata: 
  node_type: memory
  type: reference
  originSessionId: 552b0867-6641-432d-9293-f94cd4bfcef3
  modified: 2026-07-26T23:05:39.791Z
---

The `astro dev` daemon survives across conversations and has bricked itself **four times** (Convs 414,
415, 417, 418, 420). Each time the first instinct was to suspect a code defect; each time it was the
server. **`npm run build` staying clean is the tell that it is never the code.**

Distinguish the three variants by what `curl http://localhost:4321/` does — that single probe
identifies which one you have:

| `curl` says | Variant | Cause | Recovery |
|---|---|---|---|
| **`000`**, but `lsof -ti:4321` returns PIDs | **Bound-but-dead** | `npm install` ran *while* the server was up, bricking its in-memory miniflare module runner | `npx astro dev stop`, restart |
| **HTTP 500**, `The file does not exist at ".../node_modules/.vite/deps_ssr/<dep>.js?v=<hash>"` | **Stale Vite dep-optimizer cache** | New imports added across files; the pre-optimized dep no longer matches | `npx astro dev stop` → `rm -rf node_modules/.vite` → restart |
| **HTTP 200 with old content** (e.g. `/matt` or `/discover` resolving — both dissolved in the Conv-197 route flip) | **Stale content** — *never fully root-caused* | Stale daemon, the pre-flip worktree bound to 4321, or Brave's localhost cache | Verify with `curl …/matt` → 404 = server is current, so it's the browser: hard-refresh / private window |

**Teardown: `npx astro dev stop`, not `kill <pids>`.** The daemon has first-class `stop` / `status` /
`logs` subcommands (`astro dev --help`), and `stop` reports the pid it killed — it satisfies
`[DEVSRV-KILL]`'s scope-to-PID requirement without guessing from `lsof`.

⚠️ A restarted daemon binds **`[::1]` only** — use `localhost:4321`, never `127.0.0.1:4321`. See
[[reference_playwright_headless_browser_fallback]].

The 500 variant is not confined to exotic routes: Conv 420 saw it take out `/` itself. Related:
[[feedback_persistent_dev_server_4321]] (no persistent server — ephemeral on demand),
[[project_wrangler_exact_pin_miniflare_dedupe]] (the version-skew class of dev-tooling breakage).

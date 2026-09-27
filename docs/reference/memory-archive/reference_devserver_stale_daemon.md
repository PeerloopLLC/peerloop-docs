---
name: reference_devserver_stale_daemon
description: "[DEVSRV-STALE] astro dev daemon fails three distinct ways — tell them apart by curl's response (000 / 500 / stale content), never by reading code. All three now root-caused (Conv 429)."
metadata: 
  node_type: memory
  type: reference
  originSessionId: 552b0867-6641-432d-9293-f94cd4bfcef3
  modified: 2026-07-28T23:13:31.437Z
---

The `astro dev` daemon survives across conversations and has bricked itself **four times** (Convs 414,
415, 417, 418, 420). Each time the first instinct was to suspect a code defect; each time it was the
server. **`npm run build` staying clean is the tell that it is never the code.**

## Why it survives at all (root explanation — Conv 429)

**In astro 7, `astro dev` daemonizes itself.** `npm run dev` prints its pid, writes a lock at
`.astro/dev.json`, and **returns exit 0 immediately** — it is not a foreground process you Ctrl-C.
So *every* conv that runs `npm run dev` and does not explicitly stop it **leaves a daemon running**.
The "stale daemon persists across sessions" symptom is not an anomaly; it is the default. This is why
[[feedback_persistent_dev_server_4321]]'s "ephemeral, killed when done" needs an explicit teardown step
— nothing tears it down for you.

The lock records what teardown needs: `{pid, port, url, background, startedAt}`.

## Triage: one `curl http://localhost:4321/` identifies the variant

| `curl` says | Variant | Cause | Recovery |
|---|---|---|---|
| **`000`**, but `lsof -ti:4321` returns PIDs | **Bound-but-dead** | `npm install` ran *while* the server was up, bricking its in-memory miniflare module runner | `npx astro dev stop`, restart |
| **HTTP 500**, `The file does not exist at ".../node_modules/.vite/deps_ssr/<dep>.js?v=<hash>"` | **Stale Vite dep-optimizer cache** | New imports added across files; the pre-optimized dep no longer matches | `npx astro dev stop` → `rm -rf node_modules/.vite` → restart |
| **HTTP 200 with old content** (`/matt` or `/discover` resolving — both dissolved in the Conv-197 route flip) | **Stale content — ✅ ROOT-CAUSED Conv 429**, see below | A **pre-flip-worktree** server bound to 4321 | Kill it by pid (it has no lock); confirm with the fingerprint below |

## The stale-content variant, root-caused (Conv 429)

`~/projects/Peerloop-preflip` runs **astro 6.3.7**, which has **no `stop` / `status` / `logs` /
`--background` subcommands at all** — they are astro-7 only. Two consequences, both success-shaped
failures:

1. **`npx astro dev stop` in the preflip worktree STARTS a server.** astro 6 silently ignores the
   unknown `stop` argument and runs `astro dev` — binding **:4321** with **pre-flip code**. A command
   typed to tear a server *down* stands the old site *up* on the main port. Reproduced Conv 429.
2. **The main repo cannot see or stop it.** Locks are per-directory *and* per-major-version, so with
   preflip serving :4321 the main repo's `npx astro dev status` still reports **"No dev server is
   running."** and writes no lock. The tooling actively tells you nothing is running.

**Fingerprint it in one call** — pre-flip vs current, by route:

| route | pre-flip | current |
|---|---|---|
| `/matt` | **200** | 404 (dissolved Conv 197) |
| `/discover` | **200** | 404 (dissolved Conv 331) |
| `/old/dashboard` | **404** | 200 — the `/old/*` namespace was *created by* the flip |

`/old/*` 404ing while `/matt` resolves is the decisive tell: no current build can produce that pair.
Preflip is documented to run on **:4331** ([[project_preflip_worktree_reference]]); on :4321 it is
always an accident.

## Teardown

**`npx astro dev stop`, never a port-based kill.** It reads `.astro/dev.json` and reports the pid it
killed. Verified Conv 429 against the exact `[DEVSRV-KILL]` failure: with a foreign process squatting
:4321 our server fell back to :4322, and `stop` killed **our 4322 pid**, sparing both the squatter and
Chrome.

🔴 **`lsof -ti:PORT` does not return "the server" — it returns every process with a connection on that
port, including the user's Chrome.** Measured Conv 429: `lsof -ti:4321` returned the dev server *and*
Chrome's NetworkService pid. `kill $(lsof -ti:4321)` would kill the browser used for live verification.
Conv 393's recorded `lsof -ti :4321 | grep 'astro dev'` cannot help — `lsof -ti` emits bare pids, so
that grep matches nothing. A PreToolUse rule in `.claude/hooks/guard-dangerous-bash.sh` now escalates
`lsof` + `kill` in one command to an interactive ask (Conv 429).

Recovery for a daemon with **no** lock (astro 6 / preflip): `lsof -i:4321` to read the **COMMAND
column**, identify the `node` pid that is LISTENing, and kill that pid only.

⚠️ A restarted daemon binds **`[::1]` only** — use `localhost:4321`, never `127.0.0.1:4321`. See
[[reference_playwright_headless_browser_fallback]].

The 500 variant is not confined to exotic routes: Conv 420 saw it take out `/` itself. Related:
[[feedback_persistent_dev_server_4321]] (no persistent server — ephemeral on demand),
[[project_wrangler_exact_pin_miniflare_dedupe]] (the version-skew class of dev-tooling breakage),
[[project_preflip_worktree_reference]] (the :4331 worktree that causes the stale-content variant).

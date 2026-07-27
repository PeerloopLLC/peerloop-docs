---
name: reference_playwright_headless_browser_fallback
description: "The Chrome bridge DOES reach the local dev server — use localhost, never 127.0.0.1; Playwright headless is a fallback, not the default"
metadata: 
  node_type: memory
  type: reference
  originSessionId: e585e11d-a9dc-4c48-a011-f55e61b3a825
  modified: 2026-07-27T22:58:48.921Z
---

[BRIDGE-OK-USE-LOCALHOST] **The bridge is NOT unreachable.** Conv 424 re-tested the Conv-413 premise
from a clean start and the bridge rendered the app fully (`Home | Peerloop`, islands hydrated,
authenticated session). Use **`http://localhost:4321`** — never `127.0.0.1:4321`, which is refused
because `astro dev` binds IPv6 **`[::1]` only**, so nothing is listening on the IPv4 literal.

**The old "proxy in its profile" diagnosis is DISPROVEN.** The decisive discriminator: point the
bridge at a throwaway IPv4-bound server (`python3 -m http.server 4399 --bind 127.0.0.1`) — it loads
fine. The bridge handles IPv4 loopback; the dev server simply isn't on it. A server-side bind was
misattributed to the browser.

**How the misdiagnosis happened — the trap to avoid:** `navigate` returns a **success-shaped** result
(`"Navigated to http://127.0.0.1:4321/"`) even when the tab actually lands on
`chrome-error://chromewebdata/` with `ERR_CONNECTION_REFUSED`. The failure is invisible unless you
**read the page afterwards** (`javascript_tool` → `location.href` / `document.title`). So retries look
identical to successes and the browser looks dead. Always confirm a navigation by reading `location.href`
— a `chrome-error://` URL is the tell.

The superseded note also contradicted itself (claimed `curl` 200 on *both* loopback literals while also
stating the `[::1]`-only bind — impossible simultaneously; today `curl 127.0.0.1:4321` = `000`).
Observations taken under *different* server binds had been written up as if simultaneous. Lesson: when
a memo's own two claims can't both hold, re-measure before trusting either. See [[feedback_retest_task_premise_before_executing]].

**[BRIDGE-HIDDEN-TAB] The bridge tab is `visibilityState: "hidden"` whenever the Chrome window is not
foregrounded — and Chrome then (a) makes programmatic **smooth** scrolling a NO-OP and (b) throttles
React re-renders.** Conv 425: `scrollBy({left:300})` moved 300px while `scrollBy({left:300,
behavior:'smooth'})` moved **0**, and a button's `disabled` prop never flipped after a state change.
Both read as product bugs; both were harness artifacts. Check `document.visibilityState` /
`document.hasFocus()` before believing either. `computer left_click` wins `hasFocus` but does **not**
clear `hidden`. The way through: verify the **handler**, not the animation — monkey-patch the target
method to record its args (`el.scrollBy = (o) => { calls.push(o); return orig({...o, behavior:'instant'}) }`),
click, then assert the call args + the instant-mode effect. Anything depending on animation completion or
a throttled re-render stays UNVERIFIED — say so rather than claiming it works.

**Playwright headless = genuine FALLBACK (not the default).** Still the right tool for exact-width
screenshots / scripted DOM truth without a human in the loop:
- `playwright` (1.59) + chromium already installed in the code repo.
- Auth: `await ctx.request.post('http://localhost:4321/api/auth/dev-login', { data: { email } })` sets the
  cookie in the context (dev-only route, `import.meta.env.DEV`-gated). David = `david.r@example.com`.
- Then `page.setViewportSize({width,height})` → `page.goto(url,{waitUntil:'networkidle'})` → `page.evaluate(...)` / `page.screenshot(...)`.
- **Run the script from INSIDE `~/projects/Peerloop`** (ESM resolves `playwright` from its node_modules; a
  scratchpad `.mjs` throws `ERR_MODULE_NOT_FOUND`). Write a temp `_probe.mjs` at repo root, `node` it, `rm` after.
- But prefer the bridge when a human should *look* at the result — measurement can't see "technically
  correct but looks wrong".

**Dev-server gotchas (still true):** `astro dev` runs as a DAEMON (`astro dev stop` / `astro dev status` /
`astro dev logs` — SSR/request logs go to `astro dev logs`, NOT launch stdout, and `npm run dev` returns
exit 0 immediately). Binds `[::1]` only; `npm run dev -- --host 127.0.0.1` rebinds if some tool truly needs IPv4.
Related: [[reference_chrome_bridge_island_stale_cache]] (stale island STATE, not unreachable server);
[[reference_devserver_stale_daemon]]; [[feedback_persistent_dev_server_4321]]; [[feedback_dom_truth_over_screenshots]].

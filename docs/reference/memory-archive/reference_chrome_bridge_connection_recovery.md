# [BRIDGE-CONNECT] Chrome bridge won't connect — recovery ritual

**Symptom:** `mcp__claude-in-chrome__*` tools (esp. `tabs_context_mcp`) return
`"Browser extension is not connected. Please ensure the Claude browser extension is
installed and running… logged into claude.ai with the same account…"`.

**Machine context:** Recurs on **MacMiniM4Pro** (the user's report: "occasionally CC
doesn't connect and it's only through various closing/opening, connect/disconnect of
the extension and seemingly random actions that we get it working"). The user runs
**Brave as the daily browser and keeps Chrome exclusively for the bridge** — so a
"not connected" almost always means the Chrome-side extension link is down, not a code
problem.

**Recovery ritual (cheapest → most disruptive):**
1. **Confirm you are SIGNED IN to the Claude extension inside Chrome** (same claude.ai
   account as this CC session). ← **This was the actual cause in Conv 450** — the user
   simply wasn't signed into the extension; signing in fixed it immediately.
2. `/chrome` (slash command) enables the feature **on the CC side only** — it does NOT
   establish the extension handshake. Running it alone and expecting a connection is a
   red herring.
3. Toggle the extension's connection (disconnect → reconnect) so it re-handshakes with
   this CC session; click into it.
4. Close and reopen Chrome; restart Chrome if the extension was just installed.

**CC discipline:** don't spam `tabs_context_mcp` — it burns attempts and the user has
to fiddle Chrome-side regardless. **Try ~2×, then STOP and hand back** with the ritual
above; resume only when the user says it's reconnected. (Rabbit-hole guard, browser
tools.)

**Sibling bridge memory (different failure modes):**
- `reference_chrome_bridge_island_stale_cache.md` — [BRIDGE-MEM] client-gated islands
  need dev-login + hard-nav + settle; [STALE-301] stale cache in the user's browser.
- `reference_playwright_headless_browser_fallback.md` — [BRIDGE-OK-USE-LOCALHOST]
  always `localhost:4321`; [BRIDGE-OFFSCREEN-WINDOW].
- `reference_responsive_iframe_harness.md` — [MINWIDTH] exact-size same-origin iframe
  for mobile testing (media queries key off the iframe). Used Conv 450 to confirm
  /courses·/communities·detail pages are mobile-clean at 375px (0 overflow).

(Conv 450 — during the Brian brian-sep-05 import mobile-verification sweep.)

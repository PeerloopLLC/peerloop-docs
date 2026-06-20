---
name: reference_chrome_bridge_island_stale_cache
description: "/chrome bridge verification of client-gated islands — stale peerloop_user_cache causes wrong-role first-paint; use dev-login + settle-then-read DOM-truth, not poll-and-break"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 7aa3d46d-1fdd-4a89-82fc-76959d8a6b93
---

Verifying **client-gated React islands** (self-gating on the current-user store — e.g. `ProgressionNudge`, ROLE-STUDIOS Phase 4 nudges) through the /chrome bridge has a specific trap, evidenced Conv 258.

**The trap — stale `localStorage['peerloop_user_cache']` first-paint.** On the first navigation after switching users, the island hydrates from the *cached previous user's* classification, renders, then the fresh `/api/auth/session` refetch re-classifies and corrects the DOM. Observed: after switching amanda→guy, guy-rymberg (teacher+creator) briefly showed amanda's S→T "Become a Teacher" banner on Home before it vanished. This is the concrete instance behind `[BRIDGE-MEM]` and an extension of the live-DOM-diverges-from-served-HTML caveat (the divergence here is *transient hydration*, not VT).

**Reliable method:**
1. **Switch users via `POST /api/auth/dev-login {email}`** (dev-only, `import.meta.env.DEV`-gated; the PLATO mechanism). Lowercases email. All seed users password `Peerloop2` but dev-login needs none. Confirm with `GET /api/auth/session`.
2. **Hard `navigate()`** to each surface (full reload, re-runs SSR + re-inits store) — not client-side VT nav.
3. **Settle-then-read:** wait ~1.5–1.8s AFTER navigate, THEN query the DOM once. Do **NOT** "poll and break on first `[data-nudge]` sighting" — that races the stale-cache window and yields false positives.
4. **DOM-truth marker:** every `ProgressionNudge` variant emits `data-nudge="student-to-teacher"|"teacher-to-creator"`; read that + `getBoundingClientRect().height>0` for visibility. See [[feedback_dom_truth_over_screenshots]].
5. **Confirm eligibility against D1 first** (`enrollments.status='completed'`, `teacher_certifications.is_active=1` keyed on `user_id`, `courses.creator_id`) so you know the expected result before reading the DOM.

**Real-usage implication (not just a test artifact):** a user whose cache is stale vs. their session (e.g. a freshly-certified teacher whose `peerloop_user_cache` still says student) can see a brief wrong-role nudge flash, because `authStatus` resolves to `authenticated` immediately from cache rather than waiting for fresh classification. Tracked `[NUDGE-CACHE-FLASH]`; candidate fix = gate nudges on a "classification fresh" signal, not just `authStatus !== 'loading'`.

Bridge connection caveat unchanged: 2 local Chrome extensions (Peerloop2 / "Peerloop chrome") — `list_connected_browsers` then `switch_browser` to pick. See [[plato-context]], [[plato-context]].

**Browser reservation on M4Pro (Conv 311) — Brave is personal, Chrome is the bridge target.** The user runs **Brave** for ALL personal/daily browsing; the **Google Chrome app is reserved EXCLUSIVELY for `/chrome` bridge testing**. Corollary the user stated: *"if you see Chrome running it is serving pages to a Claude Code session on this computer."* Two consequences for bridge work: (1) `list_connected_browsers` can transiently list the user's **Brave** (the Claude extension is present there too, and at the pid level Brave is `/Applications/Brave Browser.app/...` — distinct from Chrome's `/Applications/Google Chrome.app/...`, so they ARE tellable apart). **Never drive or kill the Brave instance** — it's the user's live, tab-loaded daily browser. (2) The legitimate bridge target is **Google Chrome only**; if it's not running, *wait for the user to start it*, then `list_connected_browsers` again and select the Chrome entry. Do NOT propose killing a long-lived Brave process as a "rogue/zombie" cleanup — Conv 311 burned a long detour nearly treating the active personal Brave as a kill target (no LaunchAgent/login-item spawns it; it just stays open).

**Transport break after a Claude Code re-login (Conv 310, verified-observation).** If the user re-authenticates Claude Code mid-session, the Chrome MCP *transport* can go dead: `mcp__claude-in-chrome__tabs_context_mcp` returns "Browser extension is not connected" **even though the `/chrome` slash-command reports connected** (the slash-command sees the extension; the MCP tool call goes through the broken transport). A **full Chrome quit+reopen does NOT fix it** — this rules out Chrome; the broken link is CC-side. Suspected-but-unverified fix: restart Claude Code (the user chose commit-and-defer instead of testing it). Practical rule: don't loop on `tabs_context` retries or burn Chrome restarts — if a re-login preceded the failure, fall back to commit-and-defer or a Playwright DOM-truth check (drives its own chromium, no bridge).

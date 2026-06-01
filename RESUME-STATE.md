# State — Conv 231 (2026-06-01 ~11:00)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Setup/scoping conv for the **precheckout page** (Matt's "Purchase Course" frame `558:15067`),
part of MATT-DESIGN-PUSH Phase 5 / `[MATT-EXEC-PG2]` Enroll family. No code written. Caught
M4Pro up 13 convs (pull 217→230). Established the legacy-vs-Matt flow difference (legacy
"Enroll" → straight to Stripe; Matt inserts a Peerloop pre-checkout review page first).
Named the segment **"precheckout"**; **parked** the route-shape decision (separate route vs
"Buy" SubNav tab vs overlay) keyed on addressability. **Registered Figma MCP on M4Pro** —
OAuth pending a session restart, which is why this conv wrapped.

## Completed

- [x] Caught M4Pro up 13 convs (pull 217→230); started Conv 231; memory mirror→live synced
- [x] Started dual dev servers: :4321 (live `jfg-dev-13-matt`) + :4331 (pre-flip ref `608346a2`); Chrome bridge tabs 1855525866 (:4321) + 1855525867 (:4331)
- [x] Identified Matt frame `558:15067` ("Purchase Course") + status `723:14935` for the precheckout page
- [x] Named the URL segment "precheckout" (not "enroll"/"checkout")
- [x] Registered Figma MCP server on M4Pro (`claude mcp add`); OAuth + restart pending

## Remaining

- [ ] **Resume precheckout work** (next conv, after Figma OAuth): probe `558:15067`/`723:14935` live; resolve route shape via addressability audit (Stripe `cancel_url` / notification deep-link / abandoned-cart resume → does anything land on precheckout via URL?); trace the legacy direct-to-Stripe enroll trigger the new page must hand off to. Tracked under [MATT-EXEC-PG2] #9.
- [ ] **Complete Figma MCP OAuth on M4Pro** — after relaunch: `/mcp` → figma → Authenticate → sign in with Peerloop-workspace account → Allow.

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus]
- [ ] #2: [PRIM-DOC] Document primitive-definition + pre-primitive tier (matt-provenance.md §12)
- [ ] #3: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] #4: [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] #5: [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell [Opus]
- [ ] #6: [E2E-MIG] Re-point Playwright e2e onto new root routes
- [ ] #7: [E2E-GATE] Structural-change tier + goto-target resolver [Opus]
- [ ] #8: [PREFLIP-WT] Tear down Peerloop-preflip reference worktree + peerloop-ref alias
- [ ] #9: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll + Session families + 5 routes) [Opus]
- [ ] #10: [MATT-EXEC-EXT] Phase 6 lazy extrapolation primitives [Opus]
- [ ] #11: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* returns blank 15-byte 200 instead of redirect [Opus]
- [ ] #12: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via Figma MCP (M4-pinned) [Opus]
- [ ] #13: [MATT-EXEC-GRD] Phase 7 graduate design-system docs at block close
- [ ] #14: [SHOWMORE] Show-More affordance on Teachers + Reviews tabs
- [ ] #15: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants
- [ ] #16: [ICN-NS] Converge ~204 legacy icon usages onto MattIcon registry
- [ ] #17: [HOWTOREG-ICN] How-to-register-an-icon doc for MattIcon registry
- [ ] #18: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #19: [MFRD-LOOKUP] Maintain Matt frames-ready-for-dev lookup
- [ ] #20: [TXTBTN] Extract TextButton primitive on Rule-of-Three
- [ ] #21: [SETTINGS-WATCHER] Find process rewriting settings.local.json on M4Pro
- [ ] #22: [PROFILE-PRIM-SWEEP] Tier-2 remainder of profile sweep (PAUSED) [Opus]
- [ ] #23: [PRIM-COURSES-DISMISS] Vet/primitivize /courses Dismiss button
- [ ] #24: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route yet)
- [ ] #25: [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] #26: [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] #27: [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] #28: [BAK-ARTIFACT] Track down what creates stray .bak files in code repo
- [ ] #29: [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference
- [ ] #30: [GARBLE-WATCH] Re-test TERM-GARBLE when upstream fixes parallel tool-result delivery
- [ ] #31: [HOME-FEEDSHUB-VIS] Visitor/public variant of FeedsHub on `/`
- [ ] #32: [REND-DEDUP-GUARD] r-end Step 2 must dedup scratch notes vs un-compacted history
- [ ] #33: [MEM-CAP] Prune MEMORY.md — at 81% of SessionStart auto-load cap

## Key Context

- **Precheckout page = Matt frame `558:15067`** ("Page / Enroll", semantic alias "Purchase Course", Ready For Dev May 20) + paired **status frame `723:14935`**. Doc row: `docs/reference/matt-frames-ready-for-dev.md` row 9. Explicitly "NOT a Course SubNav tab — separate destination page after CTA."
- **Flow difference:** legacy `/old/*` "Enroll" → straight to Stripe Checkout (no Peerloop page). Matt inserts a pre-checkout *review* page first, which then hands off to the same Stripe session/`success_url`/webhooks.
- **Route-shape decision PARKED** — three options: (a) separate `/course/[...slug]/precheckout` route [addressable, reverses Conv 187], (b) "Buy" Course SubNav tab [diverges from Matt's frame], (c) overlay/state per Conv 187 [MATT-EXEC-FLAGS] [non-addressable]. **Decide via addressability:** does anything need to land on precheckout via URL? Candidates: Stripe `cancel_url`, "complete your enrollment" notification deep-link, abandoned-cart resume. Audit these from code first.
- **Conv 187 [MATT-EXEC-FLAGS]** classified "Enroll pre-checkout" as NON-addressable. Reversing that (option a) needs an explicit reason — surfaced to user, parked.
- **"precheckout" name locked** (not "enroll" — vague; not "checkout" — collides with Stripe).
- **Figma MCP on M4Pro:** registered via `claude mcp add --transport http figma https://mcp.figma.com/mcp` (machine-local `~/.claude.json`). Committed `settings.json` already allowlists `mcp__figma__*` tools. **OAuth still pending** — needs session relaunch (the `/mcp` panel + tool list only load at session start, so a mid-session registration is invisible until restart). After OAuth, probe live next conv. [MMP-PH5] machine-pin note may now relax for M4Pro.
- **Dev servers** were started this conv (:4321 live, :4331 pre-flip ref); they'll likely terminate on CC relaunch — restart as needed (`cd ../Peerloop && npm run dev`; pre-flip via `peerloop-ref` alias / `cd ~/projects/Peerloop-preflip && npm run dev -- --port 4331`).
- Changes will be committed in Step 6 of this conv's r-end (pre-commit state). Only docs change this conv: RESUME-STATE deletion (re-created here) + session files + the phase-5-pg2 plan note.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

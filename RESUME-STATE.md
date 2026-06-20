# State — Conv 311 (2026-06-20 ~17:25)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Closed out **RG-COMMS** (route group fully ☑ SWEPT) and landed a **systemic `@theme` radius fix**. RGCOMMS-VERIFY DOM-truth-confirmed the Conv-310 slice (6 islands, member+admin); RGCOMMS-FEEDS restyled the 3 raw-legacy feed bodies (CommunityFeed/SystemFeed/CommentSection) to Matt tokens with **full primitive adoption** (`<Textarea>`/`<Input>`/`<Button>`); the radius fix moved the `--radius-*` scale from primitives `:root` into the `@theme` bridge block, resolving ~32 bare `rounded-N` no-ops app-wide (incl. square `<Card>`s). Also resolved a long Chrome-bridge bring-up (the connected browser was the user's active **Brave**, not a zombie; reserved Chrome is the bridge target; extension **re-login** fixed the dead transport). All work committed (code `112bca19`, docs `057c3a1`) + pushed at this r-end.

## Completed

- [x] [RGCOMMS-VERIFY] #31 — DOM-truth verified the Conv-310 RG-COMMS slice (6 components) in the reserved Chrome bridge (member guy-rymberg + admin).
- [x] [RGCOMMS-FEEDS] #30 — restyled CommunityFeed/SystemFeed/CommentSection + full primitive adoption; gates green (/w-codecheck 0/0/0/0); DOM-truth zero forbidden tokens.
- [x] [RG-COMMS] #9 — marked ☑ SWEPT (both deferrals done + verified); README rows/status/master-table flipped.
- [x] [SWEEP-SPACING-GREP] #27 (rounded-N portion) — systemic @theme radius fix; build + tailwind green; DOM-verified (5× rounded-12=12px /community, 64 els on Home).
- [x] Memory: recorded the M4Pro Brave(personal)/Chrome(bridge-only) reservation in `reference_chrome_bridge_island_stale_cache`.

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conf OUT) · [RG-AUTH] #4 · [RG-DISCOVER] #10 (feed components now pre-conformant from this conv) · [RG-MOD] #18 · [RG-PUBLIC] #19 (conf OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Conformance foundations:**
- [ ] [PALETTE-FDN] #24 · [SPACING-4PX-SWEEP] #26 · [SWEEP-SPACING-GREP] #27 (rounded-N DONE this conv; **spacing-grep sub-part remains**) · [LAYOUT-SG] #17

**Tier-2 cross-cutting:**
- [ ] [XCUT-BACKREF] #28 — re-glance already-swept routes after cross-cutting extractions (the Conv-311 radius fix is one such extraction; Home re-glance done, others pending).

**Memory system:**
- [ ] [MEM-CAP-ARCH] #29 [Opus] — decide MEMORY.md auto-load cap architecture (both prune levers exhausted; do NOT just re-prune).

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #21 · [COURSES-FIXES] #22 · [PROV-STAMP-GAPS] #20 · [STALE-TESTS] #25 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #11 · [E2E-GATE] #12 · [ICN-NS] #13 · [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [V217-WATCH] #16 · [M4-ZGUARD] #23

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] (blocked by #5) · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #10 [RG-DISCOVER] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [ICN-NS] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [V217-WATCH] · #17 [LAYOUT-SG] · #18 [RG-MOD] · #19 [RG-PUBLIC] · #20 [PROV-STAMP-GAPS] · #21 [HOME-FIXES] · #22 [COURSES-FIXES] · #23 [M4-ZGUARD] · #24 [PALETTE-FDN] · #25 [STALE-TESTS] · #26 [SPACING-4PX-SWEEP] · #27 [SWEEP-SPACING-GREP] · #28 [XCUT-BACKREF] · #29 [MEM-CAP-ARCH] [Opus]

## Key Context

- **Chrome bridge on M4Pro:** the user runs **Brave for all personal browsing (hands off — never drive/kill it)** and reserves the **Google Chrome app exclusively for `/chrome` bridge testing**. "If you see Chrome running it is serving a CC session." When the bridge transport is dead/empty, the fix is **re-logging into the Claude extension in Chrome** (not a CC restart — that was Conv-310's unverified guess). Saved in `reference_chrome_bridge_island_stale_cache`.
- **Radius scale now lives in `@theme`** (tokens-tailwind-bridge.css), moved from tokens-primitives.css `:root`. Bare `rounded-{2,4,6,8,12,16,24}` resolve app-wide. `--radius-full`/`--radius-0` deliberately omitted (v4 built-ins). This is a cross-cutting extraction → [XCUT-BACKREF] #28 should re-glance other swept routes (Home done).
- **#27 split:** rounded-N no-op portion = DONE (systemic). The **stale off-scale spacing grep** portion remains (components marked Spacing ☑ before Conv 305 may carry off-scale spacing; pairs with #26).
- **System community feed is admin-only** (`community/[slug]/[...tab].astro:106`: isSystem && !isAdmin → notFound). To DOM-verify SystemFeed in /community, dev-login as admin (`admin@peerloop.com`).
- **RGCOMMS-FEEDS legacy palettes:** CommunityFeed used secondary/primary/`dark:`; SystemFeed+CommentSection used slate/indigo (no dark:). Both mapped → neutral/brand/error/warning. These 3 components are **shared** across ExploreFeeds/MyFeeds/FeedsHub/FeedsDirectory/FeedAllTab/CommunityTabs — restyling them benefits RG-DISCOVER surfaces too.
- **FeedActivityCard NOT touched** — shared, its recolor is separately deferred to the ReactionButton/IconButton extraction (typo-fdn ledger).
- **`javascript_tool` serializer** redacts some aggregate objects as `"[BLOCKED: Sensitive key]"` — return joined strings from DOM-truth probes instead.
- **Conv-311 commits (pushed at r-end):** code `112bca19` (feed restyle + radius fix); docs `057c3a1` (RG-COMMS swept + memory) + `ab86563` (USER-WIP auto-save) + `6245c30` (counter start) + this end-of-conv bookkeeping commit. Code on `jfg-dev-14`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

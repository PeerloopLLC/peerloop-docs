# State — Conv 310 (2026-06-20 ~14:55)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Landed the **RG-COMMS Option-B primitive-adoption slice** (route sweep, RTMIG-4). Restyled 5 community components to Matt tokens (secondary→neutral, primary→brand, amber→warning, red→error, dropped `dark:`, fixed 4px-collapse spacing) and adopted the `<Button>` primitive: CommunityMembersTab (Creator badge purple→brand, Mod badge amber→warning), CommunityResourcesTab, AddCommunityResourceModal (Modal primitive was already in use), RecommendedCommunities (`rounded-8` no-op→`rounded-[8px]`), CommunityRoleFallbackCard; CommunitiesCatalog confirmed already clean. Gates green (tsc/check 0/0/0/lint/prov:sweep), routes HTTP 200. Committed code `b0100c81`, docs `646e744`. **RG-COMMS is 🔄 partial — NOT ☑ Swept:** the two large raw-legacy feed bodies were deferred (`[RGCOMMS-FEEDS]`), and the live DOM-truth verify was blocked by a dead Chrome MCP bridge (CC re-login broke the transport; Chrome restart didn't fix) → deferred to `[RGCOMMS-VERIFY]`. Confirmed the bare-numeric `rounded-N` utilities are no-ops (`--radius-*` not in any `@theme` block) — widespread, folded into `[SWEEP-SPACING-GREP]`. Accepted the incoming Conv-309 memory consolidation at r-start (net −5, verified).

## Completed

- [x] [RG-COMMS] Option-B slice — 5 components Matt-conformed + `<Button>`/Modal adoption; gates green + routes 200; code `b0100c81`, docs `646e744`. (Route still 🔄 partial — see Remaining.)
- [x] RG-COMMS README marked 🔄 partial with deferral routing (route-migration README + group-summary row).
- [x] Memory: accepted Conv-309 `[MEM-CONSOLIDATE]` inflow at r-start Step 5.7 (84→79 sub-files); appended Chrome-bridge transport-break diagnostic to `reference_chrome_bridge_island_stale_cache` (body-only).

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conf OUT) · [RG-AUTH] #4 · [RG-DISCOVER] #10 · [RG-MOD] #18 · [RG-PUBLIC] #19 (conf OUT)
- [ ] [RG-COMMS] #9 — 🔄 PARTIAL (Option B landed Conv 310); remaining = [RGCOMMS-FEEDS] + [RGCOMMS-VERIFY] below, then mark ☑ Swept.
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**RG-COMMS follow-ups (this conv's deferrals):**
- [ ] [RGCOMMS-FEEDS] #30 — full restyle of CommunityFeed (344) + SystemFeed (430) raw-legacy feed bodies + CommentSection (shared, cross-cutting). CourseFeed is NOT in the /community tree (→ RG-COURSES).
- [ ] [RGCOMMS-VERIFY] #31 — live DOM-truth verify of the Conv-310 slice (Chrome bridge dead this session; do via healthy bridge or Playwright). Then mark RG-COMMS components ✅ verified in the README.

**Conformance foundations:**
- [ ] [PALETTE-FDN] #24 · [SPACING-4PX-SWEEP] #26 · [SWEEP-SPACING-GREP] #27 · [LAYOUT-SG] #17

**Tier-2 cross-cutting:**
- [ ] [XCUT-BACKREF] #28 — re-glance already-swept routes after future cross-cutting extractions.

**Memory system:**
- [ ] [MEM-CAP-ARCH] #29 [Opus] — decide MEMORY.md auto-load cap architecture (cap fired again this conv at 80%; both prune levers exhausted). Do NOT just re-prune.

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #21 · [COURSES-FIXES] #22 · [PROV-STAMP-GAPS] #20 · [STALE-TESTS] #25 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #11 · [E2E-GATE] #12 · [ICN-NS] #13 · [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [V217-WATCH] #16 · [M4-ZGUARD] #23

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] (blocked by #5) · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-COMMS] (🔄 partial) · #10 [RG-DISCOVER] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [ICN-NS] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [V217-WATCH] · #17 [LAYOUT-SG] · #18 [RG-MOD] · #19 [RG-PUBLIC] · #20 [PROV-STAMP-GAPS] · #21 [HOME-FIXES] · #22 [COURSES-FIXES] · #23 [M4-ZGUARD] · #24 [PALETTE-FDN] · #25 [STALE-TESTS] · #26 [SPACING-4PX-SWEEP] · #27 [SWEEP-SPACING-GREP] · #28 [XCUT-BACKREF] · #29 [MEM-CAP-ARCH] [Opus] · #30 [RGCOMMS-FEEDS] · #31 [RGCOMMS-VERIFY]

## Key Context

- **RG-COMMS legacy→Matt token map (reusable for [RGCOMMS-FEEDS]):** secondary-*→neutral-* (200→300, 400→500, 600→700 round-up; 50/100/700/900 direct), primary-*→brand-* (cap 500), amber-*→warning-*, red-*→error-*, purple Creator-badge→brand (matches FeedActivityCard creator=brand-500), green→success-*. Drop ALL `dark:` variants (Matt is light-only). Type: text-sm→text-body-default, text-xs→text-body-small, font-medium bundles→`text-body-*-medium`. Token inventory: neutral {50,100,300,500,700,900}; brand/success/error/warning {100,300,500}.
- **`rounded-N` numeric utilities are NO-OPS** (0px) — `--radius-*` tokens live in `tokens-primitives.css :root` but are NOT in any `@theme` block, so Tailwind never generates `rounded-8`/`rounded-12`. Conformant = `rounded-[Npx]` arbitrary (or named `rounded-lg/xl/full`, which DO resolve). Cross-cutting sites still to fix: FeedActivityCard:385, OnboardingNudgeBanner:65+:82 (both `rounded-12`, SHARED) → [SWEEP-SPACING-GREP] #27.
- **`dark:` variants = reliable "never-migrated" tell** during route assessment (Matt is light-only).
- **Chrome MCP bridge dies on a Claude Code re-login:** `tabs_context_mcp` → "extension not connected" even though `/chrome` reports connected; a full Chrome quit+reopen does NOT fix it (CC-side transport). Suspected fix = restart Claude Code. Don't loop retries — fall back to commit-defer or Playwright. (User restarting the VS Code terminal this conv-end to re-establish it for [RGCOMMS-VERIFY].) Captured in `reference_chrome_bridge_island_stale_cache`.
- **AddCommunityResourceModal already uses the Modal primitive** — the work was the form-body restyle, not Modal adoption.
- **MEMORY.md at the structural floor (~80%)** — cap alert will fire at next /r-start; durable fix is [MEM-CAP-ARCH] #29, NOT another prune (both levers exhausted Conv 309).
- **Conv-310 commits (pushed at this r-end):** code `b0100c81` (RG-COMMS slice); docs `646e744` (README partial-sweep), `3fa125c` (USER-WIP auto-save), + counter-start `ed26e99` + this end-of-conv bookkeeping commit. Code on `jfg-dev-14`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

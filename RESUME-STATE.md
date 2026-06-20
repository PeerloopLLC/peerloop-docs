# State — Conv 312 (2026-06-20 ~19:12)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Continued the **route sweep (RTMIG-4)** with **[RG-MOD] Tranche A** — an Option-B slice of the `/mod` moderation console. Conformed the 4 mod-only `Admin*` primitives (`AdminFilterBar`/`AdminPagination`/`AdminDataTable`/`AdminDetailPanel` + `StatusBadge`/`RoleBadge`/`PanelSection`/`PanelField`) on all 3 conformance axes, restoring **bridge-shrunk spacing** to literal-px Matt classes, and removed `ModeratorQueue`'s duplicate internal header (the page `SectionTitle` owns it). All 5 gates green; ModeratorQueue test 58/58. RG-MOD stays IN PROGRESS — Tranche B (ModeratorQueue chrome) + whole-route browser-verify pending. Committed (code `c53608a1`, docs `3510fd3`) + pushed at this r-end.

## Completed

- [x] [RG-MOD] Tranche A — 4 mod-only `Admin*` primitives conformed (3 axes); colour→role tokens (`gray`→`neutral`/`text-text-*`, legacy sky `primary-100/600`→`brand`, badge hues→success/warning/error/info/brand/neutral), type→`text-body-*`/`text-h3-bold`, spacing→literal-px (bridge-shrunk `p-4`/`h-4`/`h-12`/`h-16` restored to 16/16/48/64). Double-header fix (removed island `<h1>` + unused `ShieldCheckIcon` import); `ModeratorQueue.test` updated 58/58. 5 gates green. Conformance ledger + route-sweep README updated.

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conf OUT) · [RG-AUTH] #4 · [RG-DISCOVER] #9 (feed components pre-conformant from Conv 311) · [RG-MOD] #17 (**Tranche A DONE Conv 312; Tranche B + browser-verify pending**) · [RG-PUBLIC] #18 (conf OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**[RG-MOD] Tranche B (next conv) — `ModeratorQueue`'s own chrome:**
- [ ] Restyle the stats cards, action buttons, error/loading states (legacy `gray`/`red`/`yellow`/`green` ramps, `text-2xl font-bold`, `rounded-lg`); + the bridge-shrunk spacing on the island's own chrome.
- [ ] **Category-badge honest-orphan decision:** `getReason/Priority/ContentTypeBadgeClass` use 9 distinct hues (red/yellow/orange/purple/blue/indigo/cyan/pink/gray) with no Matt scale → keep as documented honest-orphan vs. collapse to neutral/status hues.
- [ ] **Whole-route browser DOM-verify** (do once, after Tranche B) — view `/mod` via moderator/admin login on the Chrome bridge; DOM-truth the bridge-spacing restorations (`px-16`=16px, `h-48`/`h-64` skeletons, `size-16/20` icons) + role-token colours.

**Conformance foundations:**
- [ ] [PALETTE-FDN] #23 · [SPACING-4PX-SWEEP] #25 · [SWEEP-SPACING-GREP] #26 (rounded-N DONE Conv 311; spacing-grep sub-part remains) · [LAYOUT-SG] #16

**Tier-2 cross-cutting:**
- [ ] [XCUT-BACKREF] #27 — re-glance already-swept routes after cross-cutting extractions.

**Memory system:**
- [ ] [MEM-CAP-ARCH] #28 [Opus] — decide MEMORY.md auto-load cap architecture (both prune levers exhausted; do NOT just re-prune). **This conv's r-start cap check fired at 80% bytes (20481/25600).**

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #20 · [COURSES-FIXES] #21 · [PROV-STAMP-GAPS] #19 (incl. the 4 `Admin*` primitives' missing `data-prov`) · [STALE-TESTS] #24 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #10 · [E2E-GATE] #11 · [ICN-NS] #12 · [TZ-AUDIT] #13 [Opus] · [DOCGEN-SPEC] #14 · [V217-WATCH] #15 · [M4-ZGUARD] #22

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] (blocked by #5) · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-DISCOVER] · #10 [E2E-MIG] · #11 [E2E-GATE] · #12 [ICN-NS] · #13 [TZ-AUDIT] [Opus] · #14 [DOCGEN-SPEC] · #15 [V217-WATCH] · #16 [LAYOUT-SG] · #17 [RG-MOD] (Tranche A done) · #18 [RG-PUBLIC] · #19 [PROV-STAMP-GAPS] · #20 [HOME-FIXES] · #21 [COURSES-FIXES] · #22 [M4-ZGUARD] · #23 [PALETTE-FDN] · #24 [STALE-TESTS] · #25 [SPACING-4PX-SWEEP] · #26 [SWEEP-SPACING-GREP] · #27 [XCUT-BACKREF] · #28 [MEM-CAP-ARCH] [Opus]

## Key Context

- **RG-MOD is mid-sweep (Tranche A done).** SoT for the sweep state: `plan/route-migration/README.md` (RG-MOD route row, 🟡 Tranche A) + `plan/typo-fdn/migration-ledger.md` (`/mod` section, 4 primitive rows ☑ code-complete, route row ☐). Resume RG-MOD at **Tranche B** = `ModeratorQueue`'s own chrome.
- **The 4 `Admin*` primitives are misnamed** — they live in `src/components/admin/` but are consumed ONLY by `ModeratorQueue` (zero RG-ADMIN blast radius). RG-ADMIN (conf OUT) does NOT use them.
- **Bridge-shrunk-spacing pattern (NEW this conv):** components authored before the `@theme` spacing bridge (Conv 174) render numeric `p-4`/`h-12`/`h-16` at literal px (4/12/16) instead of Tailwind defaults (16/48/64). Conformance fix = explicit literal-px Matt classes; check each utility's number against the aliased set `{4,8,12,16,20,24,32,40,48,64}` (numbers outside it — `gap-1`, `px-2.5`, `h-5`, `h-10` — render at Tailwind defaults).
- **`primary-100/600` are LEGACY SKY tokens, not role tokens** (`global.css` `--color-primary-100..600` = `#e0f2fe`/`#0284c7`); only `--color-primary-default/light` are americana-blue role tokens. Inverse of the Messages/Notifs catch — verify-before-counting both directions.
- **Available role-token colour scales:** `neutral` (50/100/300/500/700/900); `brand`/`info`/`success`/`error`/`warning` (each 100/300/500). Text colour role tokens: only `text-text-default` + `text-text-tertiary` (no `-secondary`). Radius: `--radius-4/6/8/12/16/24` (no `--radius-full`/`-0`).
- **Conv-312 commits (pushed at r-end):** code `c53608a1` (4 primitives + ModeratorQueue + test); docs `3510fd3` (ledger + sweep README) + `bbec8c7` (counter start) + this end-of-conv bookkeeping commit. Code on `jfg-dev-14`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

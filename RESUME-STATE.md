# State — Conv 193 (2026-05-25 ~20:21)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Demo-prep continuation across two blocks. **MATT-DESIGN-PUSH:** built the 6 remaining `/matt/*` SubNav targets ([MATT-SUBNAV-STUBS], option C — 2 thin-functional teacher pages + 4 stubs), backfilled `/matt/*` into url-routing.md ([URLDOC-MATT]), and graduated 2 machine-pinned scratch lookups to committed docs ([MMP-PH5] promotion half → `matt-figma-pages.md`; [MFRD-GRADUATE] → `matt-frames-ready-for-dev.md`). **NAV-RETROFIT:** retrofitted AdminNavbar only (user excluded the speculative AppHeader) and swapped both AppNavbar + AdminNavbar icons to MattIcon, harvesting 10 Material icons (registry 43→53) for gaps Matt's set doesn't cover. All gates green where run; commits land in /r-end Step 6.

## Completed

- [x] [MATT-SUBNAV-STUBS] — 6 /matt pages (teachers + teachers/[handle] thin-functional via D1 loaders; saved/todo/messages/notifications stubs), DOM-verified all 200 + 404 path
- [x] [URLDOC-MATT] — /matt/* backfilled into url-routing.md (§8 transient namespace + file-structure subtree + status row)
- [x] [MMP-PH5] **promotion half** — matt-figma-pages.md graduated → docs/as-designed/ (roll-forward half remains, see below)
- [x] [MFRD-GRADUATE] — matt-frames-ready-for-dev.md graduated → docs/reference/
- [x] [NAV-SIBLINGS] — AdminNavbar + AdminLayout retrofit (un-break hijacked spacing + 220px rail); scope narrowed to AdminNavbar-only by user
- [x] [LEGACY-SPACING-AUDIT] — resolved (do-nothing-broad; per-component recipe applied to AdminNavbar)
- [x] [NAV-ICON-SWAP] — both navs → MattIcon (Matt43 + 10 harvested Material); registry 43→53; zero dashed-border cases

## Remaining

**Carried, Opus-tagged:**
- [ ] [DISC-UNIFY] Migrate /discover/courses onto fetchCourseBrowseData (add primary_topic_id to loader) [Opus]
- [ ] [NAV-APP-A] approach-A component swap (replace legacy AppNavbar with Matt Sidebar) — deferred; approach B active [Opus]
- [ ] [MATT-EXEC-PG2] Matt exec page 2 (Enroll/Session families) [Opus]
- [ ] [MATT-EXEC-EXT] Matt exec extension (Phase 6 responsive/mobile-drawer) [Opus]
- [ ] [RTB] Role Tab Bar design [Opus]

**MMP / Matt blocks:**
- [ ] [MMP-PH5] **roll-forward half** — re-render remaining 11 Phase-5 pages via Figma MCP (promotion half done this conv)
- [ ] [MATT-EXEC-GRD] / [MMP-PH3] (PLAN marks MMP-PH3 complete Conv 185 — likely stale, verify)

**Course-tab polish:**
- [ ] [CRS-MOBILE] / [SHOWMORE] / [ENTITY-VIS-AUDIT] / [CH-VARIANTS] / [MATT-ICON-SWAP]

**Nav follow-up (this conv's spillover):**
- [ ] [MSP-COUPLING] Fix MoreSlidePanel left-64 misalignment with 220px AppNavbar (mirror Conv 191 inline-style slideout pattern)

**Harvests / tooling / watches:**
- [ ] [HOWTOREG-ICN] / [PLAY-CIRCLE-ICN] / [ASSET-SWEEP-GATE] / [FIGMA-MCP-DOC-HARVEST] / [MFRD-LOOKUP] (now at docs/reference/) / [ESOT-STRUCTURE] / [BROWSER-FALLBACK] / [TXTBTN] / [LH-VERIFY] / [MEM-CAP-WATCH] (MEMORY.md at ~79% byte cap)

**Conv-193 spawned:**
- [ ] [MCFRAME] Save feedback memory — don't MC-question when user is steering with specifics (grep memory first; confirm with user)
- [ ] [ICN-NS] Consider separate namespace for non-Matt Material nav icons (low priority)

## TodoWrite Items

- [ ] #1 [DISC-UNIFY] [Opus] / #7 [NAV-APP-A] [Opus] / #9 [CRS-MOBILE] / #10 [SHOWMORE] / #11 [ENTITY-VIS-AUDIT] / #12 [CH-VARIANTS] / #13 [MATT-ICON-SWAP]
- [ ] #14 [MATT-EXEC-PG2] [Opus] / #15 [MMP-PH5] (roll-forward) / #16 [MATT-EXEC-EXT] [Opus] / #17 [MATT-EXEC-GRD] / #18 [MMP-PH3] (likely stale) / #19 [RTB] [Opus]
- [ ] #20 [HOWTOREG-ICN] / #21 [PLAY-CIRCLE-ICN] / #22 [ASSET-SWEEP-GATE] / #23 [FIGMA-MCP-DOC-HARVEST] / #25 [ESOT-STRUCTURE] / #26 [BROWSER-FALLBACK] / #27 [MFRD-LOOKUP] / #28 [TXTBTN] / #29 [LH-VERIFY] / #30 [MEM-CAP-WATCH]
- [ ] #31 [MSP-COUPLING] / #32 [MCFRAME] / #33 [ICN-NS]

## Key Context

- **Both navs' icon swaps + admin 220px rail NOT visually verified** — AppNavbar + AdminNavbar are auth-gated. Mechanism proven (harvested `menu` icon renders in real SSR output, zero dashed placeholders; all 21 names resolve to real files), but the logged-in look is unconfirmed. User can eyeball logged in (as Brian/admin) or request a scripted seed-admin login DOM-check.
- **MattIcon harvest caveat:** wrapper is `fill="none"`, so harvested Material paths MUST carry `fill="currentColor"` (perl injection during harvest). Unknown name → dashed-square placeholder. 10 Material icons now in Matt's registry (provenance in MEMORY.md; [ICN-NS] tracks possible namespace cleanup).
- **NAV-RETROFIT strategy:** approach B (in-place restyle) is active; [NAV-APP-A] (approach A) deferred. [VTPRD] was dropped (intent unclear). AppHeader deliberately excluded (speculative/public-facing, likely redesigned).
- **MMP-PH5 split:** promotion (scratch→docs) DONE this conv; roll-forward (11 pages via MCP) remains — no longer machine-pinned now that lookups are committed.
- **Spacing bridge:** legacy hijacked-step utils {4,8,12,16,20,24,32,40,48,64} render ~4× small; per-component fix = arbitrary `[Npx]`. Applied to AdminNavbar this conv.
- Commits land in /r-end Step 6 (this state written pre-commit).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

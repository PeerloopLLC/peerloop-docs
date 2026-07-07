# State — Conv 370 (2026-07-07 ~11:22)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Completed **[ICN-NS]** end-to-end — the icon-system reconciliation, all three phases plus the §3.3 design decision. Retired the legacy Astro path registry (`icon-paths.ts` + `Icon.astro`; 4→3 systems), ratified MattIcon-canonical naming and executed all 15 name-mismatch renames + 10 alias consolidations (`icons.tsx` 108→98 exports), and decided to **accept** the `icons.tsx` (Heroicons) / `MattIcon` (Material) two-system split as intentional. All five gates green throughout. Also surfaced icon commercial-use/licensing as a new pre-launch item **[ICON-LIC]**.

## Key Context

- **Backlog:** see `CURRENT-TASKS.md`. **ICN-NS is CLOSED** (moved to ✅ Completed). New **[ICON-LIC]** parked under MVP-GOLIVE — add a third-party-notices file (Heroicons **MIT** + Material Symbols **Apache 2.0**) + a brand-logo trademark review (Google Sign-In / Stripe / `currentColor` recolor); needs counsel sign-off. Active backlog otherwise: TZ-AUDIT `[Opus]`, HOME/COURSES-FIXES, PLAN-XTRACT, BRAND-DOCS. Parked: RG-PUBLIC, PREFLIP-WT, BROWSER-SMOKE-2B, MINWIDTH-320, ICON-LIC.
- **Commits (this conv):** code `c50afd82` (ICN-NS renames, 95 files — amended from `9d956f94` to correct the `Stats:` trailer), docs `384859f` (ICN-NS docs). The r-end bookkeeping commit adds session records + 4 stale-ref doc fixes (`_COMPONENTS.md`/`helpers.md`/`DEVELOPMENT-GUIDE.md`/`03-app-context.md`). All pushed at this r-end.
- **Icon system now = 3 systems:** `icons.tsx` (Heroicons stroke, React islands, 98 exports), `brand-icons.tsx` (brand/social trademarks), `MattIcon` (Material, the canonical design system). Naming convention: MattIcon kebab name wins on a shared-concept conflict; MattIcon `.svg` files never renamed (provenance-bound). Canonical doc: `docs/as-designed/icon-system.md`; memory `reference_icon_system`.
- **§3.3 is DECIDED, not deferred:** the two-system split is intentional. Do NOT propose unifying `icons.tsx` onto MattIcon SVGs unless the app later commits to an all-Material look — the RTMIG-4 route sweep (closed Conv 340) never scoped icon-glyph unification, so no migration will absorb it.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

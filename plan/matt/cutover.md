# MATT-CUTOVER

**Block:** MATT-CUTOVER (spawned Conv 195)
**Status:** 🟢 SUBSTANTIALLY COMPLETE — route flip shipped Conv 197, post-flip reconciliation Conv 198, provenance detection workstream Conv 199; PROV-MATCH-AUTO open.
**Family:** matt
**Related:** [README](README.md), [phase-5-pg2](phase-5-pg2.md), `docs/as-designed/matt-provenance.md`

---

## What this block does

Make Matt the primary app and demote legacy. Full design rationale in `docs/as-designed/matt-provenance.md`. Two axes kept separate: **domain** (design-system vs `/old`, encoded structurally by route/layout tree) and **authorship** (Matt-drawn vs Claude-built, encoded by the `@matt-source` marker — the collision axis). Triggered "after today's demo" (2026-05-26).

## Conv 197 — PROV + ROUTE-FLIP landed

- **[PROV]** — 35 components + token blocks (primitives `477:8502`, typography `40:485`/`40:493`, semantic `40:484`/`40:482`) + 53-icon registry marked `@matt-source`; 9 unmarked = ours (RoleTabBar/MattIcon/ControlBar/HeaderBar/Card/SectionTitle + 2 demos + IconLabelChip); new `matt-embedded` curation class; `icon-provenance.ts` + `_INDEX.md` (per-glyph node granularity); `matt-provenance.md` §7 SETTLED + §9 record.
- **[ROUTE-FLIP]** — all 9 §8 steps executed (43 legacy pages → `/old/`, 9 Matt pages → root, layout collision resolved legacy→`/old` & Matt→canonical, `matt/*` namespace dissolved into components root + 83 imports rewritten, 139 `/matt` URL literals + ControlBar/MainNav home-active special-case, 2 demo bridges removed, route map regenerated, docs updated); all 5 gates green (6453 tests; full suite caught + fixed `onboarding.test.ts` hardcoded path).

## Conv 198 — post-flip doc reconciliation (batch #25–28)

All four post-flip doc-reconciliation items DONE, under a framing decision (Option B — design-canonical + status banner, NOT literal `/old` rewrite).

- **[URLDOC-RECONCILE]** (#25) — `url-routing.md` §§1–7 kept canonical (bare URL grammar permanent), churn confined to one status banner at § Route Categories + Implementation-Status row split + file-tree rewrite to real post-flip layout (root Matt pages + `old/` subtree); §8 note softened; Conv 197+198 References entries.
- **[DEVGUIDE-MATT-RECONCILE]** (#26) — `DEVELOPMENT-GUIDE.md` ~20 matt path/route/import refs swapped to root (`components/matt/X` → `components/X`, `layouts/matt/` → `layouts/`, `pages/matt/` → root, `@components/matt/` → `@components/`); `matchHref`/component locations grep-verified before editing.
- **[MDS-MATT-RECONCILE]** (#27) — `matt-design-system/` folder: INDEX.md banner contextualizing historical `/matt/*` narrative + concrete code-path/route fixes across 6 files; 03 got a Conv-190 supersession pointer (resolved a 03↔DEVGUIDE contradiction); 05 cross-ref repointed to a renamed heading.
- **[MFRD-MATT-PATHS]** (#28) — `matt-frames-ready-for-dev.md` bulk `replace_all` path/route promotion out of `matt/` + prose stragglers + post-flip Status note.

**New pattern:** doc-reconciliation treatment is a function of doc TYPE (timeless-design / living-guide / historical-spec / machine-lookup), not the stale string — each gets a different churn-vs-contextualize ratio.

## Conv 199 — provenance detection workstream (local half)

- **[PROV-SWEEP]** (#1) DONE as a thin validator + committed candidate registry, NOT the full §6 sweep (decision: build only the part that is both recurring AND deterministic today — the domain delimiter dissolved at the route flip, so candidates can't auto-derive from folder structure → must be hand-declared). New `scripts/prov-sweep.ts` (tsx validator: derives marked set by grep, reads `scripts/prov-candidates.ts` + `icon-provenance.ts`, runs 4 drift checks, emits collision-candidate manifest) + `scripts/prov-candidates.ts` (hand-maintained component+token unmarked-candidate registry — the boundary that can't auto-derive post-flip) + `prov:sweep` npm script; both branches (RECONCILED + UNTRACKED) calibrated via git-reverted test mutations; marker accept-rule tightened to require node-shaped ref `\d+:\d+` (fixed false-positive on prose `@matt-source` mentions). Documented in `matt-provenance.md §6a`.
- **[PROV-MATCH]** (#25, the Figma half) DONE same conv: live `get_metadata` on Components page (1:269) + manifest name-matching → **no confirmed collisions** (RoleTabBar NOT drawn by Matt; SectionTitle/SubNav name-matches are non-collisions by node-type) + `get_variable_defs` on 40:482 confirmed no Alert/Carmine tokens; recorded in `matt-provenance.md §10`. Side finding: `checklist`/`play_circle` icons Matt has but we lack.

## Open

- [ ] **[PROV-MATCH-AUTO]** Automate the Figma-matching half — filter section-type + status-component nodes out of the candidate pool (name-match alone over-flags; node-type is the disambiguator). Gated on [FIGMA-MCP-DOC-HARVEST] (#17) / [ASSET-SWEEP-GATE] (#16) harvest infra. Recorded in `matt-provenance.md §10`.

## Reconciliation principle

When Matt later redraws one of ours, re-translate from his node + **add** the marker — the git diff is the audit trail.

## Interactions (Conv 195 coherence review)

- **NAV-RETROFIT** stayed active until the flip landed, then was superseded (legacy was primary until the flip actually shipped — user decision Conv 195). Once `[ROUTE-FLIP]` shipped, legacy navbar chrome became `/old/*`-only and NAV-RETROFIT closed. **✅ Conv 199 — `[NAV-APP-A]` CONFIRMED MOOTED + CLOSED.** Investigation confirmed `AppNavbar` renders in exactly ONE place (`src/layouts/old/AppLayout.astro:38`), serving only `/old/*`; the 30+ grep hits across root pages were *comments*. Canonical `AppLayout.astro` already renders Matt's `Sidebar`. The approach-A swap was fully superseded by the route flip; NAV-RETROFIT + Conv-193 NAV-ICON-SWAP harvest likewise superseded.
- **`[ICN-NS]`** (Icon namespacing) — the `src/components/matt/icons/*` → `src/components/icons/*` namespace-dissolve half is mechanically done (verified Conv 199). **🟠 Re-scoped Conv 199, NOT closed:** distinct remaining intent = a real **204-file legacy→MattIcon convergence** (root files still import the legacy `icons.tsx`/`Icon.astro` system). Tracked as TodoWrite item, deferred.
- **Naming reconciled:** legacy prefix is `/old` (supersedes the `/fraser` that `url-routing.md` §8 had documented Conv 193 — now fixed).

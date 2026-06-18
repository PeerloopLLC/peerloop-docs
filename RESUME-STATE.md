# State — Conv 299 (2026-06-18 ~12:02)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Reframed the design-system conformance work to **ride the RTMIG-4 route sweep**: style-guide conformance (Type/Spacing/Colour; line-height folded into Type) is now a **4th "Swept" gate** with an explicit in/out scope (RG-ADMIN, RG-PUBLIC, `/old/*` OUT). Resolved the TYPO-FDN ledger's last two open decisions (off-scale-px → SNAP `6→8`/`10→12`; migrate both shared anchors now), then **migrated all 8 Home-route components** to conformance — StickySignupBar + FeedPost were already clean; CourseAnchor, CommunityAnchor, OnboardingNudgeBanner, ProgressionNudge, SmartFeed (group 1) + the heavy FeedActivityCard (group 2) were edited. tsc + lint green; 4 commits. **Paused before the whole-route browser-verify** — that's the only remaining gate before flipping the RG-HOME conformance rows ☑. Also fixed a VS Code preview-editor tab-loss issue (user settings.json).

## Completed

- [x] Folded conformance into the RTMIG-4 sweep as a 4th "Swept" gate + scope decision (docs `79b7ca7`)
- [x] Resolved TYPO-FDN open decisions 2 + 3, recorded in the conformance ledger (docs `2666393`)
- [x] Migrated 5 Home components to conformance (code `24cf8646`)
- [x] Migrated FeedActivityCard to conformance (code `02ba8664`)
- [x] Verified StickySignupBar + FeedPost already conformant (0 edits)
- [x] Fixed VS Code preview-editor tab loss (settings.json) + advised Cmd+P for deep files
- [x] Fixed latent broken token `text-body-default-bold` (ProgressionNudge)

## Remaining

**[TYPO-FDN] #31 (IN PROGRESS — conformance now rides the sweep):**
- [ ] [HOME-VERIFY] #33 — whole-route browser-verify of Home (member + visitor, DOM-truth): confirm the spacing-collapse fixes (FAC `p-16`/strip-bleed/`w-[80px]`, SmartFeed `space-y-16`), the 3-way source tints (system=brand/community=neutral/course=info), colour fidelity; then flip Home rows ☑ in the ledger + recalibrate its overstated Notes
- [ ] [TYPO-FDN] /courses backfill — the 11 /courses ledger components (SectionTitle, CoursesFilters, RecommendedCourses, 5 course-cards, CoursesRoleTabs, CoursesCatalog)
- [ ] [SPACING-4PX-SWEEP] #32 — legacy `h-4 w-4`/`p-4` 4px-collapse sweep · [TYPO-PHANTOM] #34 — phantom `text-body-*` token grep

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conformance OUT) · [RG-AUTH] #4 · [RG-PROFILE] #9 · [RG-COMMS] #10 · [RG-DISCOVER] #11 · [RG-MESSAGES] #20 · [RG-NOTIFS] #21 · [RG-SESSIONS] #22 · [RG-MOD] #23 · [RG-PUBLIC] #24 (conformance OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Follow-ups / debt:**
- [ ] [STALE-TESTS] #30 · [COURSES-FIXES] #27 · [HOME-FIXES] #26 · [PROV-STAMP-GAPS] #25 · [PALETTE-FDN] #29 (now the Colour axis of the sweep gate)
- [ ] [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #12 · [E2E-GATE] #13 · [ICN-NS] #14 · [TZ-AUDIT] #15 [Opus] · [DOCGEN-SPEC] #16 · [V217-WATCH] #17 · [MEM-PRUNE] #18 · [LAYOUT-SG] #19 · [M4-ZGUARD] #28

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-PROFILE] · #10 [RG-COMMS] · #11 [RG-DISCOVER] · #12 [E2E-MIG] · #13 [E2E-GATE] · #14 [ICN-NS] · #15 [TZ-AUDIT] [Opus] · #16 [DOCGEN-SPEC] · #17 [V217-WATCH] · #18 [MEM-PRUNE] · #19 [LAYOUT-SG] · #20 [RG-MESSAGES] · #21 [RG-NOTIFS] · #22 [RG-SESSIONS] · #23 [RG-MOD] · #24 [RG-PUBLIC] · #25 [PROV-STAMP-GAPS] · #26 [HOME-FIXES] · #27 [COURSES-FIXES] · #28 [M4-ZGUARD] · #29 [PALETTE-FDN] · #30 [STALE-TESTS] · #31 [TYPO-FDN] (in_progress) · #32 [SPACING-4PX-SWEEP] · #33 [HOME-VERIFY] · #34 [TYPO-PHANTOM]

## Key Context

- **Conformance now rides the sweep** — SoT `plan/route-migration/README.md` § "Style-guide conformance" (the 4th "Swept" gate) + § "Conformance scope" (IN/OUT). The conformance checklist is `plan/typo-fdn/migration-ledger.md` (retitled the **Style-Guide Conformance Ledger**).
- **Home rows stay ☐** in the ledger until [HOME-VERIFY] #33 runs — all 8 components are code-migrated (Conv 299) but unverified. RG-HOME stays ☑ Swept (Tier-1/2, Conv 291) — Swept ≠ conformant.
- **Colour mapping rule (reusable):** nearest available step, **round-half-up** on ties (200→300, 400→500, 600→700). Inventory: `neutral {50,100,300,500,700,900}`, accents (brand/info/success/error/warning) `{100,300,500}`, `text-star` single. Saturated buttons hit the 500 ceiling → use `hover:opacity-90` (no darker step).
- **FeedActivityCard source tint:** system=brand / community=neutral / **course=info** (3-way preserved per user). Reaction/comment **pill geometry preserved** — that's the pending ReactionButton/IconButton Tier-2 primitive; only colour+type migrated.
- **Bridge spacing-collapse (Conv-174):** the `@theme --spacing-*` remap makes set-member classes render at literal px — `p-4`→4px, `space-y-4`→4px, `h-4 w-4`→4px, **`w-20`→20px** (not 80px). Conformance restores intended values, often coupled (card `p-16` forces image-strip bleed `-my/-mr/ml 4→16`). Off-set classes (`gap-6`/`space-y-6`) fall back to the Tailwind multiplier (24px) — not collapsed.
- **`text-body-default-bold` is NOT a real token** (defined: default, -medium, -prose, large, -large-medium, medium, -medium-bold, small, -small-medium). [TYPO-PHANTOM] #34 sweeps for others.
- **MEMORY.md ~85%** of SessionStart cap → [MEM-PRUNE] #18 still live.
- **VS Code:** preview editors disabled in `~/Library/Application Support/Code/User/settings.json` (env-only). Use **Cmd+P** fuzzy filename to open deep files.
- Code on `jfg-dev-14`. Conv-299 commits: docs `79b7ca7`, `2666393` (+ start + this r-end close); code `24cf8646`, `02ba8664`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

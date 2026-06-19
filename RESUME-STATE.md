# State — Conv 301 (2026-06-18 ~20:33)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Route-sweep conformance work. **Closed [TYPO-FDN] #31** — the `/courses` conformance backfill (11/11 ledger rows ☑ via ~21 zero-change/exact-equivalent token edits, DOM-verified); both `/` and `/courses` backfill routes are now caught up on Type/Spacing/Colour. **Started [RG-PROFILE] #9** (the `/profile/[...tab]` multi-tab route) tab-by-tab and **paused at a clean 2/6** boundary: Account-tab chrome colour-mapped + Interests verified clean. Along the way: fixed a stale tier2-ledger FeedActivityCard note, corrected 3 stale `/courses` ledger rows, and **self-corrected an assessment error** (the RG-PROFILE "spacing clean" miscall — the `[Npx]`-only grep missed legacy numeric scale classes that collapse via the NAV-RETROFIT bridge). 5 commits this conv (2 code + 3 docs) + this r-end's docs commit.

## Completed

- [x] [TYPO-FDN] #31 — `/courses` conformance backfill COMPLETE (11/11 ledger rows ☑, DOM-verified member Amanda Lee); both `/` + `/courses` backfill routes done. Code `ad64e070`, docs `17fdef5`.
- [x] [RG-PROFILE] #9 (partial, 2/6) — Account-tab chrome 3 colour spots → role tokens + Interests verified clean; ledger `/profile` section opened. Code `67310d7d`, docs `ac19b47`.
- [x] Fixed stale tier2-primitive-ledger FeedActivityCard "colour deferred" note (recolor landed Conv 299); corrected 3 stale `/courses` ledger rows; corrected own RG-PROFILE spacing-assessment error (docs `534c108`).

## Remaining

**[RG-PROFILE] #9 (IN PROGRESS — resume here):**
- [ ] [RG-PROFILE] #9 — resume at **NotificationSettings** (full 3-axis disposition first). The 4 remaining settings islands (NotificationSettings, StripeConnectSettings, SecuritySettings, ProfileSettings-740ln) are **full legacy→Matt restyles**: slate `secondary-*`→`neutral-*`, `primary-*`→`brand-*` (map-or-flag); broken numeric spacing (`py-4`→4px collapse, `px-6`→24px, `space-y-6`, `mt-0.5` → Matt-scale by intended px); raw `font-semibold`/`text-sm`/`font-medium`→tokens. **Open: 16/500-label token gap** (mint 16/500 vs map 14/500 vs bump 16/600). Tab-by-tab, all axes, cheap-first; commit per tab. SoT: ledger § `/profile` + `plan/route-migration/README.md` RG-PROFILE row.

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conformance OUT) · [RG-AUTH] #4 · [RG-COMMS] #10 · [RG-DISCOVER] #11 · [RG-MESSAGES] #20 · [RG-NOTIFS] #21 · [RG-SESSIONS] #22 · [RG-MOD] #23 · [RG-PUBLIC] #24 (conformance OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Conformance axes / foundations:**
- [ ] [PALETTE-FDN] #29 (Colour axis) · [SPACING-4PX-SWEEP] #32 (4px-collapse) · [LAYOUT-SG] #19 (Layout)

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #26 · [COURSES-FIXES] #27 (incl. ReviewsTab raw hexes on course-detail) · [PROV-STAMP-GAPS] #25 (incl. InterestsSettings missing data-prov, Conv 301) · [STALE-TESTS] #30
- [ ] [SWEEP-SPACING-GREP] #33 — fold a legacy-numeric-spacing grep + DOM spot-check into the route-sweep sizing method (Conv-301 undercount fix)
- [ ] [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #12 · [E2E-GATE] #13 · [ICN-NS] #14 · [TZ-AUDIT] #15 [Opus] · [DOCGEN-SPEC] #16 · [V217-WATCH] #17 · [MEM-PRUNE] #18 · [M4-ZGUARD] #28

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-PROFILE] (in_progress, 2/6) · #10 [RG-COMMS] · #11 [RG-DISCOVER] · #12 [E2E-MIG] · #13 [E2E-GATE] · #14 [ICN-NS] · #15 [TZ-AUDIT] [Opus] · #16 [DOCGEN-SPEC] · #17 [V217-WATCH] · #18 [MEM-PRUNE] · #19 [LAYOUT-SG] · #20 [RG-MESSAGES] · #21 [RG-NOTIFS] · #22 [RG-SESSIONS] · #23 [RG-MOD] · #24 [RG-PUBLIC] · #25 [PROV-STAMP-GAPS] · #26 [HOME-FIXES] · #27 [COURSES-FIXES] · #28 [M4-ZGUARD] · #29 [PALETTE-FDN] · #30 [STALE-TESTS] · #32 [SPACING-4PX-SWEEP] · #33 [SWEEP-SPACING-GREP]

## Key Context

- **RG-PROFILE resume = NotificationSettings.** 6 tabs total; Account chrome + Interests ☑ (2/6). The 4 settings islands are full legacy restyles (see Remaining). Tab-by-tab, cheap→heavy order: Notifications → Payments(Stripe) → Security → Edit(ProfileSettings 740ln). Each = surface→confirm→restyle→DOM-verify→commit.
- **Role-scale anchors for the colour map-or-flag** (inventory: neutral {50,100,300,500,700,900}, accents {100,300,500}; nearest-step, round-half-up; saturated caps at 500 → `hover:opacity-90`): neutral-50 `#F8F8F8`, neutral-100 `#F1F1F1`(=`--gray-100`), neutral-300 `#DADADA`, neutral-500 `#767676`, neutral-700 `#414141`, neutral-900 `#1F1F1F`; brand-100 `#ECEBFE`, brand-300 `#584DF4`, brand-500 `#3A30C9`; error-100 `#FFDEE5`, error-300 `#E11D3F`, error-500 `#B0102F`. Legacy `secondary-*` = slate ramp → `neutral-*` by value-rank; `primary-*` → `brand-*`.
- **Tokens already encode weight/tracking** (drop redundant utilities = zero-change): `text-hN` = weight 500 (Matt Medium); `text-body-medium-bold` = `-0.022em` (= -0.352px @16px).
- **16/500-label gap** is unresolved — needs a per-case call when the settings sweep hits it.
- **Both `/` + `/courses` caught up** on Type/Spacing/Colour (Home Conv 300, /courses Conv 301), modulo recorded exceptions.
- Conv-301 commits (pre-r-end): code `ad64e070`/`67310d7d`; docs `17fdef5`/`ac19b47`/`534c108`. The r-end commit (session docs + `plan/route-migration/README.md` RG-PROFILE row) lands in Step 6 — **not yet pushed at the time of writing this file.**
- MEMORY.md at 88% of the SessionStart auto-load cap → [MEM-PRUNE] #18 live.
- Code on `jfg-dev-14`. `09-typography.md` is docs-repo-owned via symlink.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

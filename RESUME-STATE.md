# State — Conv 302 (2026-06-19 ~06:57)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Route-sweep conformance work. **Advanced [RG-PROFILE] #9 to 3/6** — swept the **NotificationSettings** (Notifications) tab: full 3-axis legacy→Matt restyle (3 NAV-RETROFIT spacing-collapse fixes incl. the toggle knob `h-4 w-4`→16px; 8 colour maps slate→neutral / sky→brand; 3 type-token maps), DOM-verified (member Amanda Lee, all computed values exact). Resolved the recurring **16/500 form-label gap** by minting **`text-body-medium-medium`** (16/500 body regime) in tokens-typography.css + bridge, documented in §09 §9.2b. Tier-2 sensor logged Toggle→`Switch` + Section→`Card` → deferred to [PROFILE-PRIM-SWEEP]. 2 commits this conv (code `5334ecff` + docs `3635216`) + this r-end's session-docs commit. All committed local — push lands in Step 7.

## Completed

- [x] [RG-PROFILE] #9 (partial, 3/6) — NotificationSettings tab full 3-axis restyle, DOM-verified (member Amanda Lee): label 16/500/lh24/−0.352px/#1F1F1F, desc 14/400/#767676, knob 15.99px, ON-track #584DF4, OFF-track #DADADA, header py16/px24/bg#F8F8F8/border#DADADA. Gates green (tsc/lint/astro-check/build + 28/28 NotificationSettings.test). Code `5334ecff`, docs `3635216`.
- [x] Minted + documented `text-body-medium-medium` (16/500, body regime, CC-minted NOT @matt-source) — tokens-typography.css + tokens-tailwind-bridge.css + §09 §9.2b + role-discipline row. Resolves the settings-island label gap; applies to remaining tabs.
- [x] Tier-2 assessment of NotificationSettings (`/w-prim-candidates`): Toggle→`Switch` (none in registry) + Section→`Card` (.astro mismatch) logged to `.scratch/prim-candidates-…NotificationSettings.md` → [PROFILE-PRIM-SWEEP].

## Remaining

**[RG-PROFILE] #9 (IN PROGRESS — resume here):**
- [ ] [RG-PROFILE] #9 — 3/6 done (Account chrome + Interests + NotificationSettings). Resume at the **cheapest of the 3 remaining settings islands**: `StripeConnectSettings` (Payments), `SecuritySettings`, `ProfileSettings` (Edit, 740 ln — heaviest). Each = a full 3-axis legacy→Matt restyle (same pattern: slate `secondary-*`→`neutral-*` by value/role-rank, sky `primary-*`→`brand-*`, collapse-prone numeric spacing → Matt literal-px, raw `font-*`→§09 tokens). The minted **`text-body-medium-medium` (16/500)** now covers their labels. Per-route 8-step PAUSE protocol: surface 3-axis disposition → PAUSE → restyle → DOM-verify (member + visitor) → commit per tab. SoT: ledger §/profile (`plan/typo-fdn/migration-ledger.md`) + `plan/route-migration/README.md` RG-PROFILE row.

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conformance OUT) · [RG-AUTH] #4 · [RG-COMMS] #10 · [RG-DISCOVER] #11 · [RG-MESSAGES] #20 · [RG-NOTIFS] #21 · [RG-SESSIONS] #22 · [RG-MOD] #23 · [RG-PUBLIC] #24 (conformance OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Conformance axes / foundations:**
- [ ] [PALETTE-FDN] #29 (Colour axis) · [SPACING-4PX-SWEEP] #31 (4px-collapse) · [LAYOUT-SG] #19 (Layout)

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #26 · [COURSES-FIXES] #27 (incl. ReviewsTab raw hexes on course-detail) · [PROV-STAMP-GAPS] #25 (incl. InterestsSettings missing data-prov + NotificationSettings component prov) · [STALE-TESTS] #30 · [SWEEP-SPACING-GREP] #32 (now exercised on NotificationSettings; fold the numeric-spacing-classify method into the sweep playbook)
- [ ] [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #12 · [E2E-GATE] #13 · [ICN-NS] #14 · [TZ-AUDIT] #15 [Opus] · [DOCGEN-SPEC] #16 · [V217-WATCH] #17 · [MEM-PRUNE] #18 · [M4-ZGUARD] #28

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-PROFILE] (in_progress, 3/6) · #10 [RG-COMMS] · #11 [RG-DISCOVER] · #12 [E2E-MIG] · #13 [E2E-GATE] · #14 [ICN-NS] · #15 [TZ-AUDIT] [Opus] · #16 [DOCGEN-SPEC] · #17 [V217-WATCH] · #18 [MEM-PRUNE] · #19 [LAYOUT-SG] · #20 [RG-MESSAGES] · #21 [RG-NOTIFS] · #22 [RG-SESSIONS] · #23 [RG-MOD] · #24 [RG-PUBLIC] · #25 [PROV-STAMP-GAPS] · #26 [HOME-FIXES] · #27 [COURSES-FIXES] · #28 [M4-ZGUARD] · #29 [PALETTE-FDN] · #30 [STALE-TESTS] · #31 [SPACING-4PX-SWEEP] · #32 [SWEEP-SPACING-GREP]

## Key Context

- **RG-PROFILE resume = cheapest of {StripeConnectSettings, SecuritySettings, ProfileSettings-740ln}.** 6 tabs total; Account + Interests + NotificationSettings ☑ (3/6). Each remaining = full 3-axis restyle (surface → PAUSE → restyle → DOM-verify member+visitor → commit per tab).
- **Role-scale anchors for the colour map** (nearest-step, round-half-up; saturated caps at 500 → `hover:opacity-90`): neutral-50 `#F8F8F8`, neutral-100 `#F1F1F1`(=`--gray-100`), neutral-300 `#DADADA`, neutral-500 `#767676`(muted/secondary-text role), neutral-700 `#414141`, neutral-900 `#1F1F1F`; brand-100 `#ECEBFE`, brand-300 `#584DF4`, brand-500 `#3A30C9`; error-100 `#FFDEE5`, error-300 `#E11D3F`, error-500 `#B0102F`. Legacy `secondary-*` = Tailwind **slate** ramp → `neutral-*` by value/role-rank (text-900→neutral-900, text-600→neutral-500, **border→neutral-300**, off-track→neutral-300, header-bg-50→neutral-50, dividers-100→neutral-100); `primary-*` = Tailwind **sky** (#0ea5e9) → `brand-300` (#584DF4).
- **SWEEP-SPACING-GREP method (applied this conv):** enumerate ALL numeric spacing/sizing utilities. **Collapse set** = `{4,8,12,16,20,24,32,40,48,64}` → render at Matt literal-px (`py-4`→4px) via the NAV-RETROFIT bridge = real visual bug. **Off-set numbers** (`px-6`, `space-y-6`) fall back to Tailwind `calc(--spacing*n)` → render correctly (24px), only failing the no-legacy-scale conformance rule. Classify each; don't trust an arbitrary-`[Npx]`-only grep.
- **`text-body-medium-medium`** = 16px/500, body regime (lh 1.5, ls −0.022em). CC-minted Conv 302 (§09 §9.2b). `--h4` is also 16/500 but header regime (lh 1.0, ls 0) — wrong for body labels.
- **Tier-2:** Toggle→`Switch` (NEW — none in registry; `ThemeToggle`/`PasswordInput`-toggle are specialized) + Section→`Card` (existing `Card.astro` unusable in React island) → defer to [PROFILE-PRIM-SWEEP] until all 4 islands assessed (shape the primitive against every consumer at once). Toggle internal geometry left unconverted on purpose (the future primitive replaces it).
- **DOM-verify recipe** ([BRIDGE-MEM]): `POST /api/auth/dev-login {email:'amanda.lee@example.com'}` on a permitted tab + hard-nav + settle-then-read (~1.5s) + `getComputedStyle`. This conv: navigate to my own `:4323` dev server was **denied** by the permission gate → used the already-permitted prior-session `:4321` tab (user-authorized). Chrome `javascript_tool` needs an async-IIFE wrapper (top-level await throws despite docs).
- Conv-302 commits (pre-r-end): code `5334ecff`, docs `3635216`. The r-end commit (session docs + RESUME-STATE) lands in Step 6 and is **pushed in Step 7** — both earlier commits push then too.
- MEMORY.md at 88% of the SessionStart auto-load cap → [MEM-PRUNE] #18 live.
- Code on `jfg-dev-14`. `09-typography.md` is docs-repo-owned via symlink. My `:4323` dev server left running (background).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

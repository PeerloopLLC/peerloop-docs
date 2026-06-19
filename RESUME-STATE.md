# State — Conv 303 (2026-06-19 ~09:03)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Completed the **[RG-PROFILE] route-group sweep — 6/6, COMPLETE.** This conv swept the 3 remaining `/profile/[...tab]` settings islands: **StripeConnectSettings** (Payments, 4/6), **SecuritySettings** (Security, 5/6), **ProfileSettings** (Edit, 6/6 — the 740-ln heaviest tab). Each = full 3-axis legacy→Matt restyle (slate `secondary-*`→`neutral-*`, sky `primary-*`→`brand-*`, red danger→`error-*`), DOM-verified member (Amanda Lee, exact computed values) + visitor (`/profile` middleware `/login` redirect), committed per-tab, all gates green. Standardized the spacing convention (**bare Matt numerics + off-set normalized**, retro-fixing StripeConnect) and applied ripe Tier-2 extractions (SkeletonCard + ErrorRetryCard) on Security + Profile. 6 commits (code `e92568e0`/`7e0fd706`/`c9d61e6c`, docs `d51ba0d`/`bce1782`/`7758aa0`) + this r-end's commit — pushed in Step 7.

## Completed

- [x] [RG-PROFILE] #9 — **COMPLETE 6/6.** All `/profile` islands swept + DOM-verified (member + visitor): Account chrome, Interests, NotificationSettings, StripeConnectSettings, SecuritySettings, ProfileSettings. Route ☑ Swept in route-migration README; all 6 island rows ☑☑☑ + `/profile` route CONFORMANCE COMPLETE in typo-fdn migration-ledger.
- [x] Spacing convention standardized: **bare Matt numerics + off-set normalized** (`py-16`/`px-24`, not `[16px]`); StripeConnect retro-fixed from its initial `[Npx]`/collapse-only pass.
- [x] Red danger → `error-*` mapping (Conv-301 precedent) applied (Security + Profile); minted `text-body-medium-medium` (16/500) reused for labels across Notifications + Security + Profile.
- [x] [PALETTE-FDN] #29 updated with the status-colour gap (no Matt success/warning token ramps; green/amber/yellow left raw).
- [x] Tier-2 extractions applied per tab: loading→`<SkeletonCard>`, error→`<ErrorRetryCard>` (Security + Profile). Test fix: SecuritySettings.test `border-red-200`→`border-error-300`.

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups, the main loop):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conformance OUT) · [RG-AUTH] #4 · [RG-COMMS] #10 · [RG-DISCOVER] #11 · [RG-MESSAGES] #20 · [RG-NOTIFS] #21 · [RG-SESSIONS] #22 · [RG-MOD] #23 · [RG-PUBLIC] #24 (conformance OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Primitives / conformance foundations:**
- [ ] [PROFILE-PRIM-SWEEP] #33 [Opus] — **NEW, now ripe** (full consumer set known after RG-PROFILE 6/6): build Switch (×2 consumers), Card/Section, Button danger + brand variants, Modal (DeleteAccountModal/FormModal), Textarea (FormField+textarea); swap islands onto them. Per-component candidate reports in `.scratch/prim-candidates-components-settings-*.md`. Also in PLAN.md PRIM-REGISTRY block.
- [ ] [PALETTE-FDN] #29 (Colour axis; now also carries the status-colour token gap) · [SPACING-4PX-SWEEP] #31 (4px-collapse) · [LAYOUT-SG] #19 (Layout)

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #26 · [COURSES-FIXES] #27 (incl. ReviewsTab raw hexes) · [PROV-STAMP-GAPS] #25 (incl. InterestsSettings + NotificationSettings prov) · [STALE-TESTS] #30 · [SWEEP-SPACING-GREP] #32
- [ ] [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #12 · [E2E-GATE] #13 · [ICN-NS] #14 · [TZ-AUDIT] #15 [Opus] · [DOCGEN-SPEC] #16 · [V217-WATCH] #17 · [MEM-PRUNE] #18 · [M4-ZGUARD] #28

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #10 [RG-COMMS] · #11 [RG-DISCOVER] · #12 [E2E-MIG] · #13 [E2E-GATE] · #14 [ICN-NS] · #15 [TZ-AUDIT] [Opus] · #16 [DOCGEN-SPEC] · #17 [V217-WATCH] · #18 [MEM-PRUNE] · #19 [LAYOUT-SG] · #20 [RG-MESSAGES] · #21 [RG-NOTIFS] · #22 [RG-SESSIONS] · #23 [RG-MOD] · #24 [RG-PUBLIC] · #25 [PROV-STAMP-GAPS] · #26 [HOME-FIXES] · #27 [COURSES-FIXES] · #28 [M4-ZGUARD] · #29 [PALETTE-FDN] · #30 [STALE-TESTS] · #31 [SPACING-4PX-SWEEP] · #32 [SWEEP-SPACING-GREP] · #33 [PROFILE-PRIM-SWEEP] [Opus]

## Key Context

- **RG-PROFILE is DONE (6/6).** Next route-sweep pick is any unblocked RG-* group (RG-NOTIFS/SESSIONS/MESSAGES/DISCOVER/COMMS/AUTH/ADMIN). The per-route 8-step PAUSE protocol + the now-locked conventions below apply.
- **Spacing convention (LOCKED Conv 303):** bare Matt numerics + off-set normalized. Collapse-set {4,8,12,16,20,24,32,40,48,64} render at literal-px via the NAV-RETROFIT bridge — express intended px as the Matt numeric (`gap-6`/24px→`gap-24`, `gap-1`/4px→`gap-4`, knob `h-4 w-4`→`h-16 w-16`). Sub-scale with no Matt equiv (`py-0.5`=2px, `px-1.5`=6px) kept. NOT arbitrary `[Npx]`.
- **Colour map:** slate `secondary-*`→`neutral-*` by role/value (900→900 titles, 700→700 strong-labels, 600/500/400→500 muted, 200/300 borders→300, 50→50 header-bg, 100→100 dividers); sky `primary-*`→`brand-*` (600→brand-300, 50→brand-100, 500 focus-ring→brand-300); **red danger→`error-*`** (red-600→error-300, red-700/800/900→error-500, red-50→error-100, red-200→error-300). **Status colours (green/amber/yellow success/warning) have NO Matt token — leave raw** → [PALETTE-FDN] #29. Discriminator: single-purpose danger red → error-*; multi-state status set → leave.
- **Type:** form-control labels (toggles, fields) = `text-body-medium-medium` (16/500, minted Conv 302); section h3 = `text-body-medium-bold`; desc/banners = `text-body-default` (14); captions/help/counts = `text-body-small` (12); modal title `text-xl font-bold` → `text-h3-bold` (20/600). Heading scale: h1 32, h2 24, h3 20, h4 16, h5 14 (all /500; -bold /600).
- **Tier-2 ripeness rule:** extract during a sweep only when the target primitive EXISTS and a sibling already consumes it (SkeletonCard/ErrorRetryCard were drop-in). New primitives deferred until full consumer set known → [PROFILE-PRIM-SWEEP] #33 now has it.
- **DOM-verify recipe** ([BRIDGE-MEM]): `POST /api/auth/dev-login {email:'amanda.lee@example.com'}` on the already-permitted `:4321` tab (my own `:4323` is permission-gated) + hard-nav + settle-then-read (~1.5s) + `getComputedStyle`. Chrome `javascript_tool` needs an async-IIFE wrapper. `rymberg@example.com` is NOT in the `:4321` D1 seed; the StripeConnect island renders on direct nav regardless of creator gating.
- **MEMORY.md at 88% of the SessionStart auto-load cap** → [MEM-PRUNE] #18 still pending (not addressed this conv).
- Conv-303 commits (pre-r-end): code `e92568e0`/`7e0fd706`/`c9d61e6c`, docs `d51ba0d`/`bce1782`/`7758aa0`. The r-end commit (session docs + RESUME-STATE) lands in Step 6 and all push in Step 7. Code on `jfg-dev-14`. `09-typography.md` docs-repo-owned via symlink.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

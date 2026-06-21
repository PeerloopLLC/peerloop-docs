# State — Conv 314 (2026-06-21 ~11:02)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Continued the route sweep (RTMIG-4) and **completed [RG-AUTH] — 7/7 routes ☑ Swept**. Conformed the 5 root routes (`/login`, `/signup`, `/onboarding`, `/visitor`, `/404`) — the recurring Tier-2 was hand-rolled submit `<button>`s adopting the `<Button>` primitive, plus modal-chrome token fixes and `ThemeToggle` off-track `bg-[#cbd5e1]`→`bg-neutral-300`; **OAuthButtons** (shared, app-wide via AuthModalRenderer) adopted `<Button variant="outlined">` (blue Matt pill, user-chosen). **Ported both unported routes** (MOVE old→root): `/reset-password` (legacy→Matt AppLayout + PasswordResetForm retrofit) and `/verify/[id]` (kept LandingLayout+SSR, full body conform, raw `<svg>`→`<MattIcon name="verified">`). Browser-verified all 7 routes DOM-truth on the Chrome bridge ("Peerloop2") + the `/profile` ThemeToggle back-pointer (no regression). A `/reset-password` `Input` `border-radius:0px` flag was investigated and **dismissed as a non-issue** (selector artifact — radius is on the `Input` wrapper, 12px DOM-confirmed). All 5 gates green incl. **full suite 6741/6741**. Committed + pushed at this r-end.

## Completed

- [x] [RG-AUTH] ☑ Swept 7/7 — 5 root routes conformed (visitor/onboarding/login/signup/404) + 2 ports (reset-password, verify/[id]); shared auth-modal tree (LoginForm/SignupForm submit + OAuthButtons) → `<Button>`; ThemeToggle off-track→neutral-300; DOM-truth browser-verified; 5 gates green (suite 6741/6741). SoT: `plan/route-migration/README.md` (RG-AUTH ☑) + `plan/typo-fdn/migration-ledger.md` (RG-AUTH section + per-route rows).

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 (umbrella) · [RG-ADMIN] #2 (conf OUT) · [RG-DISCOVER] #9 (feed components pre-conformant from Conv 311 — **lightest next sweep**) · [RG-PUBLIC] #17 (conf OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Conformance foundations:**
- [ ] [PALETTE-FDN] #22 · [SPACING-4PX-SWEEP] #23 · [SWEEP-SPACING-GREP] #24 · [LAYOUT-SG] #16

**Tier-2 cross-cutting:**
- [ ] [XCUT-BACKREF] #25 — re-glance already-swept routes after cross-cutting extractions.

**Memory system:**
- [ ] [MEM-CAP-ARCH] #26 [Opus] — decide MEMORY.md auto-load cap architecture (both prune levers exhausted; do NOT just re-prune). **This conv's r-start cap check fired again at 80% bytes (20481/25600).**

**Process / follow-ups / debt:**
- [ ] [SWEEP-FULLSUITE] #27 — fold an explicit full `npm test` into the route-sweep tranche-close checklist (DONE in practice this conv — RG-AUTH ran the full suite; the task is to make it a written checklist step).
- [ ] [PROV-STAMP-GAPS] #18 · [HOME-FIXES] #19 · [COURSES-FIXES] #20 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #10 · [E2E-GATE] #11 · [ICN-NS] #12 · [TZ-AUDIT] #13 [Opus] · [DOCGEN-SPEC] #14 · [V217-WATCH] #15 · [M4-ZGUARD] #21

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] (blocked by #5) · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-DISCOVER] · #10 [E2E-MIG] · #11 [E2E-GATE] · #12 [ICN-NS] · #13 [TZ-AUDIT] [Opus] · #14 [DOCGEN-SPEC] · #15 [V217-WATCH] · #16 [LAYOUT-SG] · #17 [RG-PUBLIC] · #18 [PROV-STAMP-GAPS] · #19 [HOME-FIXES] · #20 [COURSES-FIXES] · #21 [M4-ZGUARD] · #22 [PALETTE-FDN] · #23 [SPACING-4PX-SWEEP] · #24 [SWEEP-SPACING-GREP] · #25 [XCUT-BACKREF] · #26 [MEM-CAP-ARCH] [Opus] · #27 [SWEEP-FULLSUITE]

## Key Context

- **RG-AUTH is DONE (☑ Swept Conv 314).** Next sweep candidate = **RG-DISCOVER #9** (feed components pre-conformant from Conv 311 → lightest) or **RG-ADMIN #2** (conformance OUT, structural only). Remaining RG groups: RG-ADMIN, RG-DISCOVER, RG-PUBPROF (blocked by ROLE-SEMANTICS), RG-WORKSPACES (⛔client), RG-PUBLIC.
- **Auth-modal tree is now Button-conformant app-wide.** LoginForm/SignupForm/PasswordResetForm/OnboardingProfile submit buttons + OAuthButtons all use the `<Button>` primitive (r39 pill). The modal mounts via `AuthModalRenderer` in AppLayout — conformant-is-conformant, don't re-touch on later consuming routes.
- **2 routes ported this conv** (`git mv old→root`): `/reset-password`, `/verify/[id]`. Both `@matt-inspired`. `/old/reset-password.astro` + `/old/verify/[id].astro` no longer exist. These count toward the eventual [OLD-PORTED-CLEANUP].
- **Shared `form/Input` is wrapper-styled** — rounded box (`rounded-[12px]`) + border + padding on the outer `<div data-prov-name="Input">`; inner `<input>` is `bg-transparent`/no-radius. Probe the wrapper, not the leaf. (Learnings.md #1.)
- **[SWEEP-FULLSUITE] effectively satisfied in practice** this conv (RG-AUTH ran full `npm test` 6741/6741 at tranche close); #27 remains as the written-checklist-step task.
- **MEMORY.md cap at 80% bytes** — #26 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).
- **Bridge note:** Chrome bridge "Peerloop2" connected cleanly via `switch_browser` this conv (no relogin transport-break). Member `sarah.miller@example.com`; non-revoked cert `cert-sarah-ai-comp` for /verify; logout via `POST /api/auth/logout`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

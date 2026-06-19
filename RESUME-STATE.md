# State — Conv 306 (2026-06-19 ~17:18)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Drove the **4 priority routes** (`/`, `/courses`, `/profile`, `/course/[slug]`+book+success) to **fully Swept across all 5 axes** (Tier-1 · Typography · Colour · Spacing · Tier-2). Closed **[CDETAIL-CONF]** (browser-verified, route Swept) and **[PROFILE-PRIM-SWEEP]** (fully extracted). The CDETAIL browser-verify exposed that Conv-305 file-conformance hadn't reached shared sub-components → snapped **~25 shared components + app-shell nav** to the 4px scale (deterministic px→nearest, sub-4px guarded). Tokenized the profile status banners + the Stripe-purple orphan (minted `--stripe-*`); confirmed `--warning-*` already exists (corrected a stale "no warning ramp" claim). Added a CC-owned Button `danger` variant, extracted `Switch` + `SettingsSection` primitives, and conformed `Modal.tsx` (+ fixed a latent backdrop-click bug, benefiting all 6 consumers). All gates green (tsc/lint/build + 148/148 targeted tests). Ended at r-end with everything committed locally, pending push.

## Completed

- [x] [CDETAIL-CONF] #34 — `/course/[slug]/[...tab]` + `/book` + `/success` browser-verified (member + visitor), route ☑ Swept.
- [x] All 4 priority routes fully Swept across 5 axes.
- [x] Spacing closed app-wide (route-content + app-shell nav; ~25 shared components snapped).
- [x] [PROFILE-PRIM-SWEEP] #32 — fully extracted (Switch, Textarea adoption, SettingsSection, Modal conform+adopt, Button `danger`).
- [x] [PALETTE-FDN] partial — profile status banners + Stripe-purple tokenized; `--warning-*` confirmed existing.
- [x] Modal latent backdrop-click bug fixed; 2 stale tests fixed; wrong "no warning ramp" ledger note corrected.

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conf OUT) · [RG-AUTH] #4 · [RG-COMMS] #9 · [RG-DISCOVER] #10 · [RG-MESSAGES] #19 · [RG-NOTIFS] #20 · [RG-SESSIONS] #21 · [RG-MOD] #22 · [RG-PUBLIC] #23 (conf OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Conformance foundations:**
- [ ] [PALETTE-FDN] #28 · [SPACING-4PX-SWEEP] #30 · [SWEEP-SPACING-GREP] #31 · [LAYOUT-SG] #18

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #25 · [COURSES-FIXES] #26 · [PROV-STAMP-GAPS] #24 · [XCUT-BACKREF] #33 · [STALE-TESTS] #29 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #11 · [E2E-GATE] #12 · [ICN-NS] #13 · [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [V217-WATCH] #16 · [MEM-PRUNE] #17 · [M4-ZGUARD] #27

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] (blocked by #5) · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-COMMS] · #10 [RG-DISCOVER] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [ICN-NS] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [V217-WATCH] · #17 [MEM-PRUNE] · #18 [LAYOUT-SG] · #19 [RG-MESSAGES] · #20 [RG-NOTIFS] · #21 [RG-SESSIONS] · #22 [RG-MOD] · #23 [RG-PUBLIC] · #24 [PROV-STAMP-GAPS] · #25 [HOME-FIXES] · #26 [COURSES-FIXES] · #27 [M4-ZGUARD] · #28 [PALETTE-FDN] · #29 [STALE-TESTS] · #30 [SPACING-4PX-SWEEP] · #31 [SWEEP-SPACING-GREP] · #33 [XCUT-BACKREF]

## Key Context

- **4 priority routes done.** `/`, `/courses`, `/profile`, `/course/[slug]` are fully Swept (5 axes). Conformance SoT: `plan/typo-fdn/migration-ledger.md` (§ Conv-306 finish-sweep). The route sweep (RTMIG-4) continues for the remaining RG-* groups.
- **Spacing tooling for the rest of #30/#31:** a deterministic 4px-snap perl transform — `files=(…); perl -pi -e '…snap…' "${files[@]}"` — **must guard sub-4px** (`if ($n<4 || $n>64) keep`; `py-[2px]`/`mt-[2px]` are sanctioned). zsh does NOT word-split unquoted `$VAR` → use an array. After a blanket snap, grep the diff for `*-[123px]` removals (sub-4px regression check).
- **Status colour tokens EXIST** (`--success/-warning/-error-100/300/500`). Raw status banners → mechanical swap to tokens (Conv-303 shade map: `-600`→300, `-700`→500, tint→100, border→300). BUT ~1565 raw `text-/bg-{green,red,amber,yellow}-*` utils app-wide are MOSTLY legitimate role-tints (member directory, role badges) — only genuine *status* banners swap, per-route as routes are swept.
- **New primitives this conv:** `ui/Switch.tsx` (toggle control, 2 consumers); `settings/SettingsSection.tsx` (card with `body` presets padded/spaced/divided + `danger`); Button `danger` variant (CC-owned, error ramp, beyond Matt's Color-collection); `--stripe-100/300/500` tokens (Stripe-brand cue, kept purple).
- **Modal.tsx** is now conformed + its backdrop-click bug fixed (overlay child intercepted the container handler) — this is a FUNCTIONAL change to all 6 Modal consumers (LoginModal, SignupModal, NewConversationModal, CreateProgressionModal, CreateCommunityModal, AddCommunityResourceModal): backdrop-click now closes as `closeOnBackdropClick`-default intended. Watch for any modal that should NOT close on backdrop (set the flag false).
- **Stripe true brand** is #635BFF (indigo); the minted `--stripe-*` uses the existing Tailwind purple-100/600/700 values (zero visual change). Revisit only if a true-Stripe recolor is wanted.
- **MEMORY.md still at ~90%** of the SessionStart cap → [MEM-PRUNE] #17 open (not addressed this conv).
- **Conv-306 commits (local pre-push):** code `14d8c10d`/`510d6160`/`4edb6353`/`abb75158`/`721cb549`/`64b313cd`/`868ace65`; docs `96fdad3`/`6e43951`/`db80f80` (+ this r-end bookkeeping commit). Code on `jfg-dev-14`. Pushed in r-end Step 7.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

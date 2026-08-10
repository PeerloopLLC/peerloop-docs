# MERGE-BRIAN — Client-branch intent adoption

**Review target:** the **pivot snapshot `8a1e677f`** — the most recent commit of `origin/brian-July-7` (07-20 11:29), the state the user and Brian agreed was a good pivot point.
**Focus:** see what Brian built at that snapshot, extract the *intent* of the changes worth keeping, and selectively reimplement them on `jfg-dev-14` with a consequence audit per adoption. **Nothing is merged as-is — ever** (user directive, Conv 407: *"I know I won't be merging any of his work as is"*). His branch is a **reference exhibit**, not a source.
**Status:** 🔥 IN PROGRESS (Conv 408) — infrastructure verified + side-by-side environment operational (ours `:4321`, pivot `:4341`; **dev seeds diverge ~52 lines — Conv 408 correction**, NOT identical); **§1 `/course/[slug]` disposition walk COMPLETE (Conv 408)** — all 12 mechanisms decided (9 ADAPT · 3 DROP incl. 2 soft · 0 ADOPT); **§1 Tier A+B BUILT (Conv 409)** — M1/M4/M5 (cosmetic) + M6/M7/M12 (shared-primitive, all opt-in), all 5 gates green + live-verified (see §1 Build log). **§1 Tier C M10 + [RECEIPT] BUILT (Conv 410)** — community logo/affiliation + own durable receipt view; **§1 Tier C M2 `[SESS-TAB]` BUILT (Conv 411)** — merged curriculum-first Modules tab (public + session overlay; `/sessions` 301→`/modules`; Modules now 2nd), all 5 gates green (suite 6542) + live-verified; **§1 Tier C M3 `[SESS-FILES]` BUILT (Conv 412)** — per-module + course-wide file strips folded into the Modules tab (`is_public`-filtered, `display_order`-ordered, wired to `/api/resources/:id/download`; `in_room` + dead-link defects NOT adopted) — plus, on the Resources-tab regression finding, 2 parity gaps closed (descriptions + role-aware visibility) and the empty Resources tab retired (301→`/modules`); all 5 gates green (suite **6550**) + live-verified → **§1 is now 9 of 9 ADAPT built = COMPLETE**. **§1 `[HERO]` hero refinement (Conv 413)** — `CourseHeader` variant-system collapse + compaction (scheduled 360→198px) + first `@container` responsive reflow, 5 gates green (suite 6550), code `387b4a33`. **§1 `[TAB-THEME]` tab colour-theme toggle (Conv 414)** — Matt/Brian tab-state colour toggle revisiting M7's left-behind colours: 3 style-guide tokens + `--Tab-*` switch, `SubNavItem` themed (0 raw colour), `tab_theme` user column + API, `AppLayout` SSR root-attr site-wide, `TabThemeToggle` on /profile; 5 gates green (suite 6552), code `de090a18`. **§1 follow-up UI refinements + dev-tooling (Conv 415)** — `[STEP-LINK]` persistent-underline stepper link affordance + Modules-tab neutral hovers + variant-aware sticky-CTA darker-green hover + Modules-tab layout & per-file Download/Open buttons; plus `[R2-SEED]` dev R2 placeholder-blob seeding (`scripts/seed-r2-dev.mjs` + `db:seed:r2:local`) which surfaced `[MF-SKEW]` (wrangler↔dev-server miniflare version skew — deferred to next conv as #1 focus) + flagged `[DL-FILENAME]`; 5 gates green (suite 6552), code `ed70e19a`. **§1 course-page UI follow-ups (Conv 416)** — Post-button restyle to module-button style, "Ask a Question" (Creator + Peer Teachers) wired to `/messages?to=`, gated `CourseReviewComposer` modal (API-aligned 3-state), plus fixes to the shared messages `?to=` deep-link (by-id preselect + endless-reopen); the deferred `[MF-SKEW]` dev-tooling task also **✅ RESOLVED** this conv (wrangler exact-pin `4.112.0` + workers-types v5 → miniflare deduped, `3de05f0f`); 5 gates green (suite 6552), code `d450ae2c`. **§1 message follow-ups + site-wide bootstrap-race fix (Conv 417)** — the Conv-416 "Ask a Question" anchors replaced by an **in-place composer island** (`MessageUserButton`), a discard guard on unsent drafts, and an opt-in "Open in Messages" escape hatch; a 23-site message-affordance sweep produced 21 MODAL dispositions, deferred into a 6-step **MESSAGES mini-plan M1–M6** on the task board, of which **M1 `[MSGBOOT]` ✅ done** — a pre-existing site-wide current-user bootstrap race fixed by gating both consumers on the existing `useAuthStatus()` three-state; 5 gates green (suite 6568), code `1f7bfd79`. **§1 MESSAGES M2–M4 (Conv 418)** — **M2 `[CANMSG]` ✅** retired the per-row can-message fan-out (**4 requests → 0**, measured) but only after fixing the sources first (the gate was *not* vacuous on 3 of 4 surfaces: `deleted_at IS NULL` added to the `communities`/`teachers`/`creators` loaders), then rewriting `useCanMessage` as a pure `useAuthStatus`+`useCurrentUser` derivation; **M3 `[MSG-ICON]` ✅** added `appearance="bare"` to `MessageUserButton` as a discriminated prop union (icon-only trigger keeping each call site's own styling, deliberately bypassing the `Button` primitive); **M4 `[MSG-ADOPT-A]` ✅** converted all 11 high-consequence affordances across 9 files, with `signedIn` made **optional and self-resolving** from `useAuthStatus()` instead of threaded through 8 viewer-ignorant components (7 of 11 live-verified; 4 unreachable, preconditions named); 5 gates green (suite 6583), code `3b3310cd` / `1d0e740a` / `148ac48d`. **§1 MESSAGES M5–M6 (Conv 419)** — **M5 `[MSG-ADOPT-B]` ✅** converted all 10 remaining list/profile affordances, **10 of 10 live-verified**, after the task's prescribed `appearance="bare"` proved wrong for the 3 profile-header sites (they want the `Button` chrome) → `icon` widened to `string | ReactNode`; **M6 `[MSG-CLEANUP]` ✅** closed the programme with `GET /api/me/can-message/:userId` **deleted** (+7 tests, 6 docs) — so **MESSAGES M1–M6 = COMPLETE**. Two defects M5's verification surfaced were cleared in the same conv: `[COURSETAB-HASH]` (the same `[MSGBOOT]` three-state hydration race in `useRoleTabs`, `ready` gate + 6 tests) and the `[ICON-4PX]` unambiguous half (43 sites/21 files, which grew into the standalone **ICON-SIZING** PLAN block). Suite 6584→6587→6586, 5 gates green. **§2 `/courses` catalog — DISPOSITIONS DONE + ALL 14 BUILDABLE MECHANISMS BUILT (Conv 425)** — 16 mechanisms decided in four batches (**3 ADOPT · 12 ADAPT · 1 DROP**), then built in three tiers: shell (M1 640px left-anchored geometry replacing `ListingShell` · M2 search-first `sr-only h1` · M15 "Enroll Now" · M16 blue panel **kept and extended**, his site-wide deletion not adopted) · toolbar (M5 topic pill row keeping Level/Length + our `availableSoon` `[CAF]` filter · M6 flat tokenised pills · M7 visible compact sort · M8 opt-in `compact`/`dense` props) · card (M9 named `cover-story` variant + tokenised `CourseCoverPanel` · M11 extracted `CommunityAffiliation` · M12 badge + own-progress, `[DIPLOMA]` wording, no invented CTA · M13 persistent-underline link chips · M14 shared `formatPrice` + `formatPriceExact` receipt carve-out). **Findings F1** (pre-existing *site-wide* doubled form chrome — the `[DRV-C]` twin; search 49→34px, default 46px on both primitives) **and F2** (catalog/detail price split) **both CLOSED**. **M10 was unbuildable as dispositioned** → surfaced, re-decided by the user as *price sticker only* (`CoursePriceSticker` extracted, hero unchanged at 198px). Self-audit restored `prov:sweep` 17→11 and removed a stranded `context="catalog"` path; **narrow-width sweep 320→1280** found zero overflow and fixed two mobile defects (clearing 1 of `[MINWIDTH-320]`'s 3 blockers); empty-state copy re-keyed off the `courses.length === 0` invariant. 5 gates green, suite 6131→**6165**; code `f2c4dd80`→`cd0f36e9`. **§2 residue after that conv = M3 + M4, gated on the new `[ROLE-CRS-LIST]` / `[REC-REHOME]` tasks (M4 discharged Conv 427 — see below).** **§3 communities — DISPOSITIONS DONE + ALL 13 BUILDABLE MECHANISMS BUILT (Conv 426)** — 20 files censused, 16 mechanisms N1–N16 (**2 ADOPT · 12 ADAPT · 2 DROP**, both DROPs carried from §1), built in three tiers: **A** N14 `GET /api/storage/[...key]` allowlisted public-asset server (closing the pre-existing `[THUMB-404]` dead-link defect) + N5 Join/Leave rebinding on `astro:page-load` · **B** N16 loader aggregates (visibility-filtered to match the Courses tab, review-count-weighted rating), N11 named `hero` card variant + tokenised courses band, N12 brand marks, N6 640px geometry, N7 search-first, N9 role pills **retaining the Matt role palette** (opt-in `variant="pill"` on the shared `RoleTabBar`, not a bespoke row), N10 visible compact sort, N3 "Community Feed" label fix · **C** N1 identity band (96px), N4 shared `cover-story` card with **no invented journey CTA**, N13 owner-gated logo upload + settings UI (**SVG rejected** — same-origin executable content). **All three findings closed: F3** fixed by N14 and live-proved to gate before R2 · **F4** confirmed live with a hard-load control, then fixed · **F5** superseded. 5 gates green, suite 6165→**6234** (+69 across 5 new test files), `prov:sweep` at baseline. Also that conv: the client-facing [NOT-ADOPTED.md](NOT-ADOPTED.md) ledger + ground rule 9. **§2 M4 + §3 N8 BUILT (Conv 427)** — the two gated carousel mechanisms, discharged by a single `[REC-REHOME]` destination decision: **rails-backed lanes in the right rail**. New `DiscoveryRails` island + `DiscoveryRailCard` + pure `lib/discovery-rails/lanes.ts` (For You · Trending · New · Popular) mounted on `/courses`, `/communities` and `/`, all reading the ONE global Discovery Rails blob; both carousels and **both `/api/recommendations/*` endpoints deleted**. First production consumer of the Conv-261 Phase-4 rails client, and the executable cut of `[RECO-UNIFY]` #34 (Promoted / Peerloop Picks lanes still need `[PROMOTE-PIPELINE]` Steps 4–7). Four findings reframed the decision first: `/feeds` **does not exist** (retired Conv 331), a new `/discover` contradicts DISC-DROP, Home's `SmartFeed` already ships rails-backed suggestion-cards, and `[FEEDS]`'s bar covers the **feed column** not the Conv-298 right rail. Follow-up logged: `[OVERLAY-ORPHAN]` (the deleted carousels were the only call sites of `variant="overlay"` on both catalog cards). 5 gates green, suite 6234→**6210**. **§3 is now COMPLETE (14 of 14); §2 has only M3 left**, gated on `[ROLE-CRS-LIST]`. **BLOCK CLOSED Conv 428** — §2 M3 closed and §4–6 dispositioned and built that conv (see the Review-order table above, which is the accurate per-unit status; this status line was left mid-review at Conv 427). **Post-close amendment (Conv 433) — two dispositions reversed on the client's direct request, both recorded in [NOT-ADOPTED.md](NOT-ADOPTED.md) § Communities:** (a) **N11's footer-band blues are now adopted verbatim** on *both* catalog cards — `#e3f1fc` / `#d3e7f8` minted as `--brian-band` / `--brian-band-line` in the same `brian-*` provenance namespace as `[TAB-THEME]`, so his colour ships while `SubNavItem`-style "0 raw colour in a component" holds (the Conv-426 guard test kept its no-raw-hex loop and changed only the token name it asserts); (b) **N12's white-ringed medallion is now adopted on the `/courses` cover-story card** (his size, position and ring, via a new `presentation="band"` variant on `CommunityAffiliation` rather than a second component — `CourseHeader`, its other consumer, renders the same component *inline inside a dark hero*), but deliberately **not** on `CommunityCatalogCard`: there the logo is the card's own subject with no cover→band seam to bridge, so that card instead leads with the logo forward (56px squircle) over the `/community/[slug]` hero's exact scrim. Same asset, two meanings — treatment follows meaning, not uniformity. Follow-up logged: **`[COMM-IMG]`** (all community imagery is `picsum.photos` noise because `cover_image_url` has a settings slot but **no upload endpoint and no R2 path**, unlike N13's `logo_url` — tracked under PLAN.md § Deferred: IMAGES). **Post-close amendment (Conv 434) — three more § Courses rows reversed on the client's direct request:** the topic-pill **elevation** (`[PILL-LIFT]`) and the per-card **journey CTA** (`[CARD-CTA]`), both adopted by *removing the review's objection* rather than overruling it — his shadow tint turned out to be the already-adopted `--brian-ink`, and his CTA's declined divergence was designed out by sharing the detail page's own resolver. Detail, plus the three of our own CTA defects it surfaced, the `[TEACH-REQ]` flywheel work it spun off and the new `[TOKEN-TYPO]` gate → **§ Post-close amendments** at the tail of this file.
**Task-board body:** `CURRENT-TASKS.md § [MERGE-BRIAN-JULY7]` (branch facts, admission-gate history, timecard protection)
**Client-facing companion:** [NOT-ADOPTED.md](NOT-ADOPTED.md) — the inverse view of the same dispositions (everything of Brian's that is *not* in our app, with reasons), written to be walked through **with him**. Created Conv 426 at the user's request. **Keep it in step with this file** (ground rule 9).

> **Exploration branch — do not review.** `brian-July-20` is where the user moved Brian on 07-20 so he could keep exploring without git skills losing his work. Its commits post-date the pivot ([TAB-FIT], [SNAV-SCROLL], [CRS-MEMBERS], SubNav drag fix, Sidebar tweaks, feed changes) and are **out of scope until the next agreed pivot**. The *local* `brian-July-7` branch copy is also stale (28 behind origin) — `8a1e677f` is the only reference point.

---

## Ground rules

1. **No as-is adoption.** Adoption = reimplementation of intent on our branch, by us, passing all 5 gates.
2. **Consequence audit per change.** Brian drives his own CC without seeing downstream codebase consequences; every adoption gets an explicit ripple check (other detail pages, shared shell, schema, tests).
3. **Client-flagged watch areas:** `/course/[slug]` changes (implications for other detail pages) · breadcrumb/back-nav rework (site-wide) · colour changes that may contradict role-based colour theming.
4. **Colour/token conformance is a gate**, not a style preference — check against PALETTE-FDN tokens + role theming before any visual adoption.
5. **Schema/API = feature adoption decisions.** If a feature is wanted, we author our own schema change (fold into `0001_schema.sql` pre-launch + reseed, per CLAUDE.md §Database Migrations) and reimplement the API. Brian's migration files (`0005`, `0006`) never land.
6. **Evaluate per screen, implement per mechanism.** A change adopted on one screen lands once in the shared mechanism, serving every consumer of it.
7. **Provenance markers** (§Page Provenance) go on everything we write.
8. **Scope questions go to the user.** Any judgment call about what is in or out of scope — a branch, a snapshot, a mechanism — is surfaced as a question, not defaulted (Conv 407 lesson; `memory/feedback_assess_ask_before_acting.md`).
9. **Every disposition is mirrored into [NOT-ADOPTED.md](NOT-ADOPTED.md)** in the same conv it is decided — the client-facing ledger of what of Brian's is *not* in our app. A DROP goes in §1 or §2; an ADAPT contributes its *left-behind* part to §3; a prerequisite-gated item goes in §4; and a completed screen walk is removed from §5. The two files are updated together — this one records what we built, that one records what he'll notice missing. Its purpose is a live conversation with him, so reasons are consequences (or an honest "that's a taste call"), never internal shorthand.

## Infrastructure (machine-local, MacMiniM4Pro — mirrors [PREFLIP-WT])

- **Reference worktree:** `~/projects/Peerloop-brian` — detached at **`8a1e677f`** (verified byte-identical to the `origin/brian-July-7` tip), deps installed (`npm ci`), local D1 seeded via `npm run db:setup:local:dev` (includes Brian's `0005`/`0006` migrations + his dev seed).
- **Run it:** `cd ~/projects/Peerloop-brian && npm run dev -- --port 4341` — **ephemeral**, kill when done (Astro 6, foreground). Ours runs on `:4321` from `~/projects/Peerloop` for side-by-side — Astro 7 daemonizes: stop via `astro dev stop`, never a port kill, and stop it before any local wrangler D1 op (miniflare store contention, measured Conv 407; **root-caused Conv 415 = `[MF-SKEW]`** — wrangler & dev-server bundle skewed miniflare versions (`4.20260521` vs `4.20260714`) sharing `.wrangler/state/v3`; the newer upgrades `_cf_ALARM` on disk and crashes the older, so recovery = stop dev + `rm -rf .wrangler/state/v3` + reseed; **✅ RESOLVED Conv 416 `[MF-SKEW]`** — wrangler exact-pinned to `4.112.0` (+ `@cloudflare/workers-types` v5, global nvm wrangler bumped to match), whose exact miniflare pin (`4.20260714.0`) dedupes to the single copy the dev server uses, so the skew crash is structurally gone (see the Conv 415/416 build logs + CURRENT-TASKS.md); stopping `astro dev` before a `wrangler --local` op stays prudent for the shared `.wrangler/state/v3` store but is no longer skew-driven). **Dev R2 blobs:** `npm run db:seed:r2:local` (wired into `db:setup:local:dev`, Conv 415) PUTs a placeholder blob per `session_resources.r2_key` — the SQL seed only inserts metadata, so without it local R2 is empty and file downloads 404.
- **🔴 Side-by-side data parity is FALSE — corrected Conv 408.** Both local D1s are seeded to `dev` level, but **the seed file itself diverged across the fork**: `diff migrations-dev/0001_seed_dev.sql` ours vs the worktree = **52 differing lines**. His side adds `accent_color`/`logo_url` on communities (the `0005` `[COMM-BRAND]` columns), Guy availability rows, and a `cert-amanda-vc-comp` certificate row; our side adds the `[TZ-MODEL]` timezone seeding that post-dates his fork. **Consequence for every screen review: state-dependent differences (journey step completion, session counts, certificate/diploma state, community branding, booking availability) may be DATA artifacts, not UI-logic differences.** Verified instance (Conv 408, `amanda-lee` on `vibe-coding-101`): his journey reads "Sessions 2 of 2 · ✓ Certificate", ours reads "1 of 2 · 1 unbooked · ✓ Diploma" — the certificate row exists only in his seed. **Rule: before attributing any state difference to his code, diff the seed rows behind it.** Structural/layout comparisons remain valid. (Dev password `Peerloop2`.) **`:4341` login modal never renders** (merge-base-era auth UI, not being adopted — undiagnosed by choice): log in via the DevTools dev-login snippet (`fetch('/api/auth/dev-login', …)`) instead.
- **Read any file at the pivot without the worktree:** `git -C ~/projects/Peerloop show 8a1e677f:<path>`.
- **Teardown** (when the block closes): `git -C ~/projects/Peerloop worktree remove ~/projects/Peerloop-brian`.

## Open asks of Brian

- [ ] **The "approved Option B / mockup" artifacts** his commit messages cite — his rationale exists nowhere in git; only his chat sessions have it.

---

## Review order & status

| # | Review unit | Status |
|---|---|---|
| 1 | `/course/[slug]` detail | ✅ **COMPLETE (Conv 412)** — dispositions DONE (Conv 408, 12 mechanisms: 9 ADAPT · 3 DROP · 0 ADOPT). **All 9 ADAPT built:** Tier A+B (Conv 409, M1/M4/M5 + M6/M7/M12) · Tier C M10/[RECEIPT] (Conv 410) · Tier C M2 `[SESS-TAB]` (Conv 411) · Tier C M3 `[SESS-FILES]` (Conv 412) · hero refinement `[HERO]` (Conv 413) · colour-theme toggle `[TAB-THEME]` (Conv 414) · UI + messages follow-ups (Convs 415–419, incl. the **MESSAGES mini-plan M1–M6, COMPLETE Conv 419** — see build logs). Only the 3 DROPs unbuilt (2 soft/revisitable) |
| 2 | `/courses` catalog | ✅ **COMPLETE — all 16 of 16 built (M3 closed Conv 428)** — 16 mechanisms: 3 ADOPT · 12 ADAPT · 1 DROP. **All 14 buildable ones built** — M1 M2 M15 M16 (shell) · M5 M6 M7 M8 (toolbar) · M9 M10 M11 M12 M13 M14 (card + hero sticker). **Findings F1** (pre-existing site-wide doubled form chrome, measured and fixed) **and F2** (catalog/detail price split, fixed at the shared helper + a `formatPriceExact` receipt carve-out) **both closed**. M10's disposition proved unbuildable as written and was re-decided by the user as *price sticker only*. Also this conv: a self-audit restoring `prov:sweep` to its 11-issue baseline + removing a stranded `context="catalog"` path, a **narrow-width sweep 320→1280** (zero overflow; two mobile defects fixed; 1 of `[MINWIDTH-320]`'s 3 blockers cleared) and the invariant-keyed empty-state copy fix. 5 gates green (suite 6131 → **6165**, +34 tests / 3 new files), everything live-verified. **§2 is now COMPLETE except M3** — M4 shipped in Conv 427 when `[REC-REHOME]` was decided and built (rails-backed right-rail lanes; `/api/recommendations/courses` deleted). M3 stays gated on `[ROLE-CRS-LIST]` |
| 3 | `/community/[slug]` + `/communities` (+`[COMM-BRAND]` feature decision) | ✅ **COMPLETE for everything buildable (Conv 426)** — 20 files censused, **16 mechanisms (N1–N16)**: **2 ADOPT · 12 ADAPT · 2 DROP** (both DROPs carried from earlier walks). **All 13 buildable ones BUILT** across three tiers — A: N14 storage route + N5 Join/Leave rebinding · B: N16 aggregates, N11 hero card, N12 marks, N6 640px geometry, N7 search-first, N9 role pills, N10 compact sort, N3 label · C: N1 identity band, N4 shared course card, N13 logo upload + settings UI. **All 3 findings closed:** **F3** (course-thumbnail uploads 404 — pre-existing, no `/api/storage/` route) **FIXED by N14** and live-proved to gate before R2 · **F4** (Join/Leave dead on client-side nav) **CONFIRMED live with a control, then FIXED by N5** · **F5** (224px header square, 320×224 thumb — a Conv-423-preserved `[DEMO-HOME]` 4× artifact) **superseded** by N1 (band now 96px) and N4. **§3 is now COMPLETE** — N8 shipped in Conv 427 with §2 M4, both discharged by the one `[REC-REHOME]` decision. Divergences pinned by tests: role pills KEEP the Matt palette (N9); no invented journey CTA (N4); SVG rejected (N13); visibility-filtered + weighted aggregates (N16). 5 gates green, suite 6165→**6234** (+69), `prov:sweep` at baseline |
| 4 | **Site-wide shell track** (`[BACK-X]` back-nav, `SubNav`/`SubNavItem`, `Sidebar`, forms, `AppLayout`) | ✅ **COMPLETE (Conv 428)** — 11 files censused, **7 already dispositioned by §1–§3**, leaving 4 live mechanisms: **1 ADAPT · 1 ADOPT · 2 DROP**. `[BACK-X]` → keep breadcrumbs, drop the back button (its handler is literally `history.back()`, desktop-only where browser Back is always visible), keep the sticky title as new `StickyViewTitle.astro` on `/session/[id]`. `[FEED-WIDTH]` → DROP re-affirmed (geometry + rails stand or fall together; rails on a course workspace cut against the ≥75% completion metric). Sidebar "My Courses" → DROP (collides with `/courses`). "Peer Teachers" → ADOPT, finishing the half-applied relabel across 9 sites. See the §4 build log |
| 5 | Sessions-files feature (`0006` + storage API) — adopt/reject as a feature | ✅ **COMPLETE (Conv 428)** — **the feature question was already answered**: `display_order` ADOPTED (§1 M3), `in_room` DROPPED (§1), `/api/storage/[...key]` ADOPTED (§3 N14), and `api/sessions/index.ts` turned out to be **teacher switching mis-filed here**, already declined (our 403 verified still enforced). Real residue = 4 items, 3 of them course-chrome not files: **1 ADAPT · 3 DROP** — demo binaries DROP (repo is client-shared; `[R2-SEED]` covers it), `CourseMiniHeader` DROP, sticky rail DROP (mutually exclusive with §4's title bar), journey band **below** tabs ADAPT (fixes our own course-vs-session inconsistency). See the §5 build log |
| 6 | Misc ("Peer Teachers" relabel, `SessionBooking`, workspace touches) | ✅ **COMPLETE (Conv 428)** — 7 mechanisms: **3 ADOPT · 3 DROP · 1 already-adopted**. ADOPT: a **real booking defect** ("Selected at enrollment" could render under the wrong teacher after stepping back), the local course cover SVGs (removing the external picsum dependency that masked §3 F3), and `Peer Teacher Management` — **a gap §4 S4 left**, since that census grepped exact `Teachers` tokens and never saw `Teacher Management`. DROP: the "Change" button (UI half of declined teacher switching), the `/learning`→"My Courses" rename (other half of §4 S3), and nothing else outstanding. See the §6 build log |

**Disposition vocabulary:** **ADOPT** (reimplement the intent as-is) · **ADAPT** (take the idea, different mechanism) · **DROP** (with one-line reason; called REJECT before Conv 408 — the user's term is DROP) — recorded per change in each screen section, then implemented cosmetic-first; internal deps (schema/API) surface via the screens that need them.

**Agreed working order (Conv 408, user):** *all* dispositions are collected first — CC asks per mechanism, with any related questions, until every one of the 12 is asked and answered — **then** CC builds them, **then** the user checks the result. No implementation happens mid-walk; a disposition records a decision, it does not change the build.

## Route-impact map (pivot snapshot `8a1e677f` — 96 files vs merge-base `c50afd82`, measured Conv 407)

His commit tags at the pivot: `[COMM-BRAND]`×3 · `[TAB-SCROLL]`×2 · `[TAB-OWNS-PAGE]`×2 · `[COVER-STORY]`×2 · `[TCH-SEARCH]` `[TAB-FLOAT]` `[TAB-COMPACT]` `[SESS-TAB]` `[SESS-FILES]` `[COVER-STORY-MIRROR]` `[BAND-ACTION]` `[BACK-X]` (many commits untagged; messages are useful for grouping, not rationale).

| Review unit | His work there | Consequence flags |
|---|---|---|
| `/course/[slug]` detail | Tab/page architecture (`[TAB-OWNS-PAGE]` `[TAB-SCROLL]` `[TAB-FLOAT]` `[TAB-COMPACT]`) + `[SESS-TAB]` `[SESS-FILES]` `[TCH-SEARCH]` `[COVER-STORY]` `[BAND-ACTION]` | The flagship; overlaps all 9 files where his work and ours both changed; schema dep via `[SESS-FILES]` |
| `/courses` catalog | `CourseCoverPanel.tsx` (new), catalog/filter/card edits, bespoke cover SVGs (`[COVER-STORY-MIRROR]`) | Colour-theming check (known hex deviations in `CourseCoverPanel`) |
| `/community/[slug]` + `/communities` | `[COMM-BRAND]` (migration `0005`, `lib/community-branding.ts`, logo-upload API, demo logos), `[BAND-ACTION]` `CommunityBand`, tabs, catalog | Schema + API dep; **`accent_color` vs role-based theming** |
| Site-wide shell | `BackHeader.astro` (new, `[BACK-X]`), `SubNav`/`SubNavItem`, `Sidebar`, `ListingShell`, `StickyListingToolbar`, `form/Input`+`Select`, `IconLabelChip`, `AppLayout` | Cannot be judged on one screen; every route affected |
| Sessions-files feature | `0006_session_resource_files.sql`, `api/storage/[...key].ts` (new), `api/sessions/index.ts`, `session/[id].astro`, `public/docs/vibe-coding-101/*` demo files | A feature, not cosmetics — independent adopt/reject |
| Misc | "Peer Teachers" relabel (admin/analytics/profile display strings), `SessionBooking`, `learning`/`creating`/`teaching` page touches | Relabel = product decision |

Reference measurements (Conv 407, all vs the pivot unless noted): 96 changed files; 62 commits (`c50afd82..8a1e677f`), all authored `brian@peerloop.com`; 9 files changed on both branches need reconciliation-by-reimplementation (`CourseTabs.tsx`, `CoursesCatalog.tsx`, `CoursesFilters.tsx`, `CourseHeader.tsx`, `course/[slug]/[...tab].astro`, `_course-tabs.ts`, `book.astro`, `success.astro`, `tests/unit/journey-loop-tabs.test.ts`); our `migrations/` tops out at `0004`, so his `0005`/`0006` filenames are collision-free today.

---

## 1 · `/course/[slug]` review

**Brief generated Conv 407, analyzed entirely at the pivot snapshot `8a1e677f`** (dual-checkout read; `brian-July-20` excluded by instruction). ✅ **Dispositions DONE (Conv 408)** — all 12 decided from live side-by-side (ours `:4321`, pivot `:4341`): 9 ADAPT · 3 DROP · 0 ADOPT. **Tier A+B BUILT Conv 409** (M1/M4/M5 + M6/M7/M12) + **Tier C M10/[RECEIPT] BUILT Conv 410** + **Tier C M2 `[SESS-TAB]` BUILT Conv 411** + **Tier C M3 `[SESS-FILES]` BUILT Conv 412** (+ Resources-tab retirement) — see Build logs below. **All 9 ADAPT built → §1 COMPLETE (Conv 412);** hero `[HERO]` refined (Conv 413 — variant collapse + compaction + `@container` reflow) + tab colour-theme toggle `[TAB-THEME]` added (Conv 414 — revisits M7's left-behind colours as a user-toggleable theme), and §1 UI refinements + `[R2-SEED]` dev-tooling landed (Conv 415 — stepper link affordance, Modules-tab hovers/layout/Download buttons, dev R2 blob seeding; surfaced `[MF-SKEW]` deferred), and §1 course-page UI follow-ups landed (Conv 416 — Post-button restyle, "Ask a Question"→`/messages?to=` wiring, gated `CourseReviewComposer` modal, messages `?to=` deep-link fixes; the deferred `[MF-SKEW]` also ✅ resolved), and the §1 message follow-ups landed (Conv 417 — in-place composer island replacing the Conv-416 navigate-away anchors, discard guard, opt-in "Open in Messages" exit, plus the `[MSGBOOT]` site-wide bootstrap-race fix and the M1–M6 messages mini-plan), and the mini-plan advanced M2–M4 (Conv 418 — can-message fan-out retired after fixing the `deleted_at` sources, `appearance="bare"` variant, all 11 high-consequence affordances adopted), and **closed at M5–M6 (Conv 419** — the last 10 list/profile affordances adopted 10/10 live-verified, the UI-unused `can-message` endpoint deleted, plus the two defects M5's verification surfaced: `[COURSETAB-HASH]` and the `[ICON-4PX]` unambiguous half**)**, all see Build logs below; only the 3 DROPs unbuilt (2 soft/revisitable).

### Build log — Tier A (Conv 409, all 5 gates green)

The 9 ADAPT mechanisms split into three dependency tiers; the user chose **Tier A** (cosmetic, course-local, no schema) this conv:

- **M1 `[HDR-ABOVE-TABS]` BUILT** — `CourseHeader.tsx` default (browse) variant compressed to a slim identity band: dropped `min-h-[360px]` (natural height) + `justify-between`, tightened padding to `py-16 sm:py-20` / `px-24 sm:px-40`, removed the in-hero back button (breadcrumb + MobileUpNav already carry "← Courses"), tightened the title-cluster gap. Kept cover art, price, metadata chips, Enroll CTA. **DOM-measured: hero 360px → 166px (~194px reclaimed).** ⚠️ Spacing-token gotcha caught in the live check: `py-28` is NOT a defined token in this project's `N=px` scale, so it silently fell through to stock Tailwind's `28×4=112px` — only DEFINED tokens (16/20/24/32/40/64) are safe (see `[[project_spacing_snap_over_matt_exception]]`). Enrolled (285px) / scheduled (360px) variants untouched. **Provenance:** kept `@matt-source 517:8934` + stamp and documented the compression as a **Strict-B drift** — a full `@matt-inspired` reclassify needs the prov-registry update tracked under `[PROV-SWEEP-DEBT2]`, out of scope here (a raw flip added 2 prov:sweep errors; reverted).
- **M5 `[BAND-ACTION]` BUILT** — `CourseJourneyStepper.astro` horizontal band compacted to one short row (circle *beside* label, Sessions meter inline as "X of N"; `py-12 md:py-16` → `py-8`). Added an **`actionable`** flag to the step model (`_course-tabs.ts`): a completed Enroll gate is `done ✓` but **not a link**; Payment/Sessions/Diploma stay clickable (our definition of actionable — his rule left a completed student nothing to click). **Reconciliation:** did **NOT** take his band-end CTA — M1 keeps the CTA in the hero and it's mirrored in the sticky tab strip; a third copy would duplicate. **Deferred:** M5's Payment→receipt retarget is blocked on `[RECEIPT]` (no receipt page); Payment still points at `/success` until that lands.
- **M4 `[TCH-SEARCH]` BUILT** — tab strip relabel "Teachers" → "Peer Teachers" (`_course-tabs.ts` + `[...tab].astro` `TAB_LABELS`; the tab *body* already read "Peer Teachers"). Teacher list moved into a new `TeachersTabList.tsx` client island carrying a **count-gated** live search + sort (`SEARCH_THRESHOLD = 4`), so the control is invisible at today's single-teacher scale and appears as the flywheel produces certified teachers. `TeachersTab.astro` kept as the SSR shell (heading + intro) with its `@matt-source` stamp.

**Tier B BUILT (Conv 409)** — shared-primitive, every change **opt-in** so the ~8 other SubNav consumers are untouched:

- **M6 `[TAB-SCROLL]` BUILT** — `preserveScroll?: boolean` prop on `SubNav` (default off) + a self-scoping progressive-enhancement script that saves `scrollY` on tab-link click and restores it on the client-side swap (`astro:after-swap`/`page-load`) with `behavior:'instant'` (beating the global smooth), plus a short `ResizeObserver` clamp-retry for late-hydrating islands. `CourseRail` opts the course cluster in (both rail + top SubNav); the script keys off `nav[data-preserve-scroll]` so every other consumer is inert. DOM-verified: attr present, script attached, 0 JS errors.
- **M7 `[TAB-FLOAT/COMPACT]` BUILT** — a `dense?: boolean` opt-in on `SubNav`→`SubNavItem` (20px icon + `text-body-small` + `p-8` chip), passed only by `CourseRail`'s top-strip SubNav. **Purely token-based — deliberately left Brian's gradient selected-capsule and his 10 raw colour values behind** (`SubNavItem` keeps 0 raw colours + its `@matt-source` stamp; `dense` is a documented Peerloop extension like `compact`). DOM-verified: chip 40px → **36px**, and the 8-tab course strip now fits **7 tabs on row 1** (was 5). (Full row-unwrap still waits on M2's tab-count merge — as the disposition notes, the primitive is the wrong lever for that.)
- **M12 `MattCourseFeed` BUILT** — composer collapsed from a 3-row "Post Something" card to a **compact single row** (avatar + `field-sizing:content` growing input + Post; outer `gap-32`→`gap-16` so the feed starts higher) + **skeleton ghost-card** loaders replacing the one-line "loading" message. **Retokenised** — skeletons use `bg-border-default` (opacity), NOT Brian's raw `bg-neutral-100`. Kept the `@matt-source` stamp (composer redesign documented as a drift, same call as M1). DOM-verified: composer rows=1.

**Gates (both tiers, this conv):** tsc ✓ · astro check 0-err ✓ · lint 0-err ✓ · build ✓ · full suite 6540 pass ✓ (3 updated: 2 `journey-loop-tabs` label assertions for the relabel + 1 pre-existing `EarningsDetail` `/settings/payments`→`/profile/payments` Conv-408 residue) · prov:sweep unchanged at its 9-err/1-drift `[PROV-SWEEP-DEBT2]` baseline. Tier A + hero also SSR/DOM-verified live (`:4321`), Tier B DOM-verified.

### Build log — Tier C partial (Conv 410): M10 + [RECEIPT]

Tier C (schema-bearing) was sliced (Conv 410, user): the two **independent, completable** mechanisms shipped this conv; M2 `[SESS-TAB]` + M3 `[SESS-FILES]` (a coupled, fixture-gated IA rebuild) were deferred to their own conv. All 5 gates green (tsc · astro check 0-err · lint 0-err · build · **full suite 6541 pass**, +1 new test) + **live-verified on `:4321`**.

- **M10 `[COMM-BAND]` BUILT — logo + affiliation only.** Authored `communities.logo_url` (folded into `0001_schema.sql`; distinct from the pre-existing `cover_image_url` banner + `icon` emoji — documented in the column comment) + reseeded the three dev communities with square `picsum` logos. Course loader (`fetchCourseTabData`) now joins `courses.progression_id → progressions → communities` for `{name, slug, logoUrl, memberCount}` (added to `CourseTabData`); `CourseHeader.tsx` gained a `community` prop rendering a subtle **"part of X · N members"** affiliation line (logo + link to `/community/[slug]`) in the shared identity cluster — wired on `[...tab]`/`success`/`book`. **DROPPED** (per disposition): `accent_color`, `community-branding.ts` palette, the settings picker — all dead code on his branch, and the role-theming collision the user flagged. His `0005` never lands. Provenance: `CourseHeader` keeps its `@matt-source` stamp (the affiliation is an additive Peerloop element, documented). Live: `/course/intro-to-n8n` → "part of Automation Majors · 98 members" + logo.
- **`[RECEIPT]` BUILT — own durable receipt view (M5 dep).** The M5 Payment step's dangling target now resolves: new `/receipt/[id]` page ([id] = enrollment id, mirrors `/diploma/[id]`) + `loaders/receipt.ts`. **Path chosen: our own view** (renders the `transactions` row — handles refunds/partial refunds, no Stripe round-trip, brandable) over Stripe's hosted `receipt_url`. **PRIVATE** (unlike the public Diploma): logged-out → `302 /login?redirect=`; owner-only via `WHERE e.student_id = ?` (a non-owner gets an indistinguishable "Not Found" — no enumeration leak). Discriminated loader result (`ok` / `no-payment` for free enrollments / `not-found`). `LandingLayout`, printable (`@media print`), `@matt-inspired`. M5's Payment step retargeted in `_course-tabs.ts` (`href: j.enrollmentId ? /receipt/${id} : /success` fallback); `journey-loop-tabs.test.ts` updated (fallback case + new receipt-href case). Live-verified: completed ("Paid" $249.00), partially-refunded (gross $249 − refund $100 = **net $149**), auth guard (302), ownership guard (Not Found).

### Build log — Tier C M2 `[SESS-TAB]` (Conv 411, all 5 gates green + live-verified)

The curriculum-first Sessions-tab rebuild. **IA decided first (Conv 411, user):** merged tab canonical route **`/modules`**, label **"Modules"**, position **2nd (after About)** — all three from an `AskUserQuestion` pick; the Conv-408 disposition's framing (public + curriculum-first, session overlay once enrolled, Homework its own tab, Diploma naming) stood unchanged.

- **Merged component** — `ModulesTab.astro` rewritten as the curriculum-first tab: curriculum cards (Matt frame 497:12684, kept `@matt-source` with the session overlay documented as a Strict-B drift, per the M1/M12 precedent) + an **enrolled-only session overlay** per module (completed → "Completed ‹date›" + teacher + recording; in-progress → Rejoin; scheduled → date + Join-window Join/Details; unbooked → "Not booked yet") + the progress summary + Book CTA (ported from My Sessions) + a **"Past sessions"** tail for cancelled/no-show (which don't advance the curriculum). `MySessionsTab.astro` **deleted** + its registry entry removed (net-zero prov:sweep).
- **Loader** — new `fetchCourseModulesView` (loaders/courses.ts): reuses the app's positional SoT `resolveModuleAssignments` (module↔session_id) joined to `fetchStudentCourseSessions` (rich detail) by session id, so a booked-but-not-completed session (DB `module_id` NULL) still lands on its positional module row. Public/not-enrolled → curriculum only, no extra reads.
- **Routing** (`[...tab].astro`) — Modules is now **public** (dropped the enrolled-gate; the overlay self-gates on `isEnrolled`); **`/sessions` 301s to `/modules`**; the Sessions sub-row no longer renders on the tab catch-all (its Book/Join affordances live in the tab body now; the sub-row stays on `/book` + `/session/[id]`).
- **Tab model** (`_course-tabs.ts`) — Modules moved to strip position 2; the journey **Sessions step** href + `matchPrefixes`, both `buildCoursePrimaryCta` fallbacks, `isSessionsContext`, and `SessionCompletedView`'s "View Course Sessions" link all retargeted `/sessions`→`/modules`; `buildCourseSessionActions` **dropped its redundant "My Sessions" entry** (now the top-strip Modules tab).
- **Fixture** — the disposition's flagged booked-not-completed case **already existed in the dev seed** (`usr-david-rodriguez` on intro-to-n8n: 1 completed + 2 scheduled `module_id`=NULL + 1 cancelled) — no seed change. **Durable** verification: 3 new integration tests for `fetchCourseModulesView` against that fixture (completed→frozen module · scheduled→positional row · cancelled→past tail).
- **Gates:** tsc ✓ · astro check 0-err ✓ · lint 0-err ✓ · **full suite 6542 pass** (+1 net; updated journey-loop-tabs + SessionCompletedView assertions) ✓ · build ✓ · prov:sweep unchanged at the `[PROV-SWEEP-DEBT2]` 9-err/1-drift baseline. **Live-verified on `:4321`:** 301, anon curriculum-only (no overlay leak), tab order About→Modules→…, and the enrolled overlay against the david fixture (1 completed / 2 booked / 3 unbooked, "Completed Sun, Dec 15", 2 scheduled → Details on their positional rows, "Past sessions · Cancelled").

### Build log — Tier C M3 `[SESS-FILES]` (Conv 412, all 5 gates green + live-verified)

The last of §1's 9 ADAPT mechanisms — inline file strips on the Modules tab. **Key discovery:** the standalone `ResourcesTab.astro` is a pure empty-state placeholder ("No Resources Yet") that never rendered any `session_resources`, so this data was surfaced **nowhere** in the course UI before M3.

- **Schema (fold into `0001`, per ground rule 5):** added `session_resources.display_order INTEGER NOT NULL DEFAULT 0` — the one real column we lacked. Brian's `in_room` column **NOT adopted** (unimplemented on his branch — a badge label + sort key with no BBB pre-upload behind it; disposition 3). `SessionResource` type gained `display_order`. His `0006` never lands.
- **Loader (`fetchCourseModulesView`):** one indexed read of the course's `session_resources`, **`is_public`-gated** (unenrolled → public-preview files only; enrolled → all) and **`display_order ASC, created_at ASC`-ordered**, grouped into per-module `files[]` on each `CourseModuleView` + a course-wide `courseFiles[]` (`module_id` NULL) on `CourseModulesView`. New `CourseModuleFile` type resolves each row to a **non-null `href`** — uploads → `/api/resources/:id/download`, external links → their URL, a row with neither target is **dropped**. This is the deliberate fix for Brian's dead-link defect (`fileHref = external_url ?? null` rendered every R2 upload as a clickable dead link).
- **UI (`ModulesTab.astro`):** per-module file strip inside each module row (16px `resource`/`play-circle` glyph + name + size + `arrow-down`/`arrow-right` affordance; uploads download same-tab with `download` attr, external links `target=_blank rel=noopener`) + a course-wide "Course files" section between the module list and the past-sessions tail. Fully tokenised (0 raw hex); kept the `@matt-source 497:12684` stamp with the strips documented as additive Peerloop drift (M1/M2/M12 precedent). `courseFiles` wired through `[...tab].astro`.
- **Seed:** populated `r2_key`/`size_bytes`/`mime_type`/`display_order` on the 7 resource rows (uploads now real download links) + added `res-n8n-003` as a 2nd file on n8n module 1 so `display_order` is exercised (003 order 1 → 001 order 2). **Durable:** 3 new loader tests (public→public-only; enrolled→all, grouped + display_order-ordered, upload href resolution; neither-target row dropped).
- **Live-verified on `:4321`:** anon `/course/intro-to-n8n/modules` → only the public course-wide video (external, `_blank`), zero private per-module downloads, "Course files" present; enrolled `david-rodriguez` → both enrolled-only uploads under Module 1 **ordered 003→001**, same-tab downloads to `/api/resources/:id/download` with sizes + descriptions, external video `_blank`/`noopener`.
- **🔴 Incidental fix:** `tests/ssr/courses.test.ts:412` (Conv 411's cancelled-session test) shipped a latent `TS2367` error — `m.session?.status === 'cancelled'` compares against a union that excludes it; confirmed red at clean HEAD, so Conv 411's "tsc ✓ / 5 gates green" baseline was inaccurate. Fixed inline (string cast preserves the runtime guard).

#### Resources-tab decision (Conv 412) — regression recovery, then retire

The build surfaced that the standalone **Resources tab was a functional REGRESSION**, not a meaningless stub: the pre-flip course page had a fully-working `ResourcesTabContent.tsx` (242 lines) rendering `session_resources` grouped, with download links (uploads) + external "Open" links + past-session recordings + empty-state. Conv 188 [RESTAB] replaced it with a Matt **empty-state stub** (`ResourcesTab.astro` — Matt drew only the empty state), a DISC-DROP re-skin-drops-behavior failure; the populated legacy component was later deleted as an orphan. Data + read-API (`/api/courses/[id]/resources`) + creator upload UI all survived. **The user asked whether M3 covers everything the deleted view did** — a field-by-field diff found two real gaps, both then closed:

- **Gap 1 — per-file descriptions:** legacy showed a one-line description under each file; M3 now renders `f.description` under the name in both strips (the loader already carried it).
- **Gap 2 — role-aware visibility:** legacy `canSeeAllResources` let a course's creator / an admin / a community moderator see ALL files even when not enrolled. `fetchCourseModulesView` gained a `canViewAllFiles` param (OR'd with `isEnrolled` for the `is_public` gate; does NOT grant a session overlay), computed at the call site from `data.isCreatorOfCourse || data.isAdmin || data.isModeratorOfCommunity`. +1 loader test.
- Minor items dropped: distinct per-type icons (Matt icon set has no audio/image glyph), a resource count, and the "enroll to see hidden files" nudge (Modules already carries the Book/enroll CTA).

With M3 a **faithful superset** of the old tab, the user chose **retire it**: `/course/[slug]/resources` **301s → /modules** (mirrors M2's `/sessions`), `'resources'` removed from `VALID_TABS`/`TAB_LABELS`/`buildCourseExploreTabs`, the `ResourcesTab` import + render branch removed, and the orphaned `ResourcesTab.astro` deleted (+ registry regenerated). `journey-loop-tabs` expectations updated (6 public tabs, not 7).

- **🔴 Prov-tooling finding (fixed):** regenerating `matt-sourced-registry.generated.ts` after the delete surfaced a **`gen-registries.ts` scanner false-positive** — its `/@matt-source\s+\d+:\d+/` regex matches the marker-with-node ANYWHERE, so `messages/matt/Avatar.tsx` (genuinely `@matt-inspired`) was wrongly registered because its docstring *referenced* the UserIcon node it wraps ("@matt-source 1:35" in prose). Fix: reworded Avatar's prose to "Matt node 1:35" (no marker token) — Avatar is correctly absent from the registry, and prov:sweep returned to the exact `[PROV-SWEEP-DEBT2]` 9-err/1-drift baseline (net delta zero, registry diff = only the ResourcesTab removal). The scanner's prose-matching weakness is logged as a `[PROV-SWEEP-DEBT2]` follow-up.
- **Gates (final, all 5 green):** tsc 0 · astro check 0-err · lint 0-err · build ✓ · **full suite 6550 pass** (405 files) · prov:sweep unchanged at the `[PROV-SWEEP-DEBT2]` 9-err/1-drift baseline.

### Build log — §1 follow-up (Conv 413): `[HERO]` CourseHeader refinement (all 5 gates green + live-verified)

A post-§1 refinement of the M1 `[HDR-ABOVE-TABS]` band. Conv 409's M1 compressed only the *default* (browse) variant to ~166px and explicitly left the **enrolled (285px) / scheduled (360px)** variants untouched — so enrolled/scheduled students still got an oversized band. This conv collapsed the variant system and made the band responsive. Committed `387b4a33` (`jfg-dev-14`).

- **Variant collapse** — removed the `variant`/`headerHref` props + the **dead `enrolled` branch** from `CourseHeader.tsx` (no call site ever passed it; its doc comment claiming `/success` used it was stale — `success.astro` passes scheduled/default). The band now derives its state from data: `isEnrolled` (pill) / `scheduledSession` (session column) / else includes+CTA. One slim state-derived band (no `min-h`, `py-16/20`, no in-hero back button). `variant=` dropped from all 3 call sites (`[...tab].astro`, `book.astro`, `success.astro`); stale doc corrected. **DOM-measured: scheduled hero 360 → 244 → 198px** (parity with the browse variant).
- **Compaction** — 1-line tagline (`line-clamp-1`), single-row chips (`flex-nowrap overflow-hidden`), session label `text-h3-bold`→`text-body-medium-bold` (20→16px). The font-shrink freed enough width that chips fit one row with 0px clip; n8n hero reached exact Vibe-coding-101 parity (198px).
- **Responsive reflow — first `@container` in the codebase** — the right column was clipped in the ~640–780px band and at the `lg` sidebar-collide (`sm:` keys off viewport, not the content column). Fix: `@container` on `<header>` + `sm:`→`@lg:flex-row`; **removed `shrink-0`** from both right columns so the session label / includes **wrap** instead of overflowing; left cluster `min-w-0`; scheduled col `text-right`. Playwright-verified 8 widths **640–1280 uniform 198px** side-by-side (was a janky 198↔332 stack), label wraps at tight widths, zero clipping 500px+, stacks only at true mobile (375/500 ~324px, normal).
- **Gates (all 5 green this conv):** tsc 0 · astro check 0-err · lint 0-err (167 pre-existing warnings) · **full suite 6550 pass** · build ✓. `/w-codecheck` grep gates clean.
- **New patterns:** first CSS `@container` query in the codebase (reflow on an element's own width — the durable answer to sidebar-collide); Playwright headless + `POST /api/auth/dev-login` as the browser-verification fallback when the claude-in-chrome bridge can't reach this machine's dev server (bridge Chrome routes loopback away — recurring, not resolved).
- **Files:** `CourseHeader.tsx` (variant collapse + compaction + reflow), `course/[slug]/[...tab].astro` · `book.astro` · `success.astro` (dropped `variant=`). 4 files, +64/−76.
- **🟠 Optional mobile follow-up (not pursued):** the single-row chips (`overflow-hidden`) truncate at true-mobile (<~450px); could wrap onto 2 rows on mobile only. Flagged, deferred.

### Build log — §1 follow-up (Conv 414): `[TAB-THEME]` Matt/Brian tab colour-theme toggle (all 5 gates green + live-verified)

A second post-§1 follow-up, revisiting the **colours M7 `[TAB-FLOAT]`/`[TAB-COMPACT]` deliberately left behind** (Conv 409 took only the `dense` compactness; the gradient capsule + 10 raw colour values were rejected as un-tokenised prov damage on the most-shared primitive). The user asked to adopt Brian's tab *colours* — not the pill/elevation shape — as named style-guide tokens, switchable per-user via a /profile toggle. Committed `de090a18` (`jfg-dev-14`).

- **Revisit finding** — Brian's tab treatment = **10 raw values but only 4 distinct hues** (`#2a93d5` sheen, `#dfe6ee` border, `#0777b6` blue shadow, `#102a43` neutral shadow); the count inflates from 2-layer shadows × {selected,default}×{rest,hover} × per-depth alpha ramps + surface-tinted shadows. A flat design encodes state as a fill swap (~1 colour/state); elevation needs fill + border + multi-layer tinted shadow per state → why M7 saw them as raw "honest orphans." **`#0777b6` is already `--americana-blue`/Primary-Default**, so only **3 new tokens** were needed.
- **Decision (user):** adopt the **colours on our flat tab shape**, NOT the floating-pill/elevation shape (that raised-capsule reads as a badge, reserved for badge-like labels of readable text). Flat mapping **A "Solid selected"** chosen from a `.scratch` mockup (solid `#0777b6` chip + white label; `#dfe6ee` hover; `#102a43` default label). Persistence = **cross-device `tab_theme` DB column + instant CSS-var flip (no reload)**; scope = **site-wide** (all top-strip tabs via `AppLayout`), `AdminLayout`/`LandingLayout` left on Matt for v1.
- **Tokens** — 3 new primitives (`--brian-sky #2A93D5` / `--brian-pale #DFE6EE` / `--brian-ink #102A43`) in `tokens-primitives.css` + `bg-/text-/border-brian-*` bridge utilities; `--Tab-*` semantic switch in `tokens-semantic.css` defined to the *exact prior* utility values at `:root`/matt and overridden under `[data-tab-theme='brian']` → default theme renders byte-identical (zero-regression themeable primitive, verified live: Matt selected bg still `rgb(241,249,255)`).
- **Component** — `SubNavItem.astro` state colours rewired to `var(--Tab-*)`, keeping it at **0 raw colour** (prov-clean); the tokenisation is exactly what dissolved M7's objection (raw hex in a `@matt-source` primitive trips prov:sweep). `TabThemeToggle` registered in `matt-inspired-registry` → prov:sweep **net-zero** at the 9-err/1-drift `[PROV-SWEEP-DEBT2]` baseline (LayoutToggle stays part of that pre-existing debt).
- **Persistence/SSR** — `users.tab_theme TEXT NOT NULL DEFAULT 'matt' CHECK IN ('matt','brian')` (folded into `0001`, per ground rule 5) + `User` type; `PATCH/GET /api/me/profile` field + validation (+2 tests); `AppLayout` SSR-sets `data-tab-theme` on `<html>` (piggybacks the existing `nav_layout` user query — no extra DB round-trip, FOUC-free, better than `ThemeToggle`'s localStorage-on-mount flash); `TabThemeToggle.tsx` on the /profile **Preferences** card flips the attribute live (no reload) + PATCHes in the background, so the next SSR render carries the saved value across navigations + devices. Precedents on the same card: `LayoutToggle` (DB-column, reload) + `ThemeToggle` (localStorage, instant).
- **Gates (all 5 green):** tsc 0 · astro check 0-err · lint 0-err · **full suite 6552 pass** (+2) · build ✓ · prov:sweep net-zero. **Playwright live-verified**: matt→brian flips the selected tab `rgb(241,249,255)`→`rgb(7,119,182)`, survives reload (SSR-set), applies on /course; 6 screenshots (course/profile/toggle × matt/brian) reviewed. (Local-D1 reset of the test row = full reseed — standalone `wrangler d1 execute --local` fails while the `astro dev` daemon holds the store.)
- **Files (12, +250/−10):** `migrations/0001_schema.sql`, `styles/tokens-primitives.css`, `styles/tokens-tailwind-bridge.css`, `styles/tokens-semantic.css`, `components/SubNavItem.astro`, `layouts/AppLayout.astro`, `api/me/profile.ts`, `pages/profile/[...tab].astro`, `components/settings/TabThemeToggle.tsx` (new), `lib/db/types.ts`, `scripts/matt-inspired-registry.ts`, `tests/api/me/profile.test.ts`.
- **New pattern:** user-preference **runtime theme via root `data-*` attribute + CSS vars** — default theme = current values (no-op), SSR-set attribute from a DB column (FOUC-free), instant client flip + background persist. First real one (ThemeToggle dark is parked; LayoutToggle reloads); reusable for future toggleable themes.
- **🟠 Optional follow-ups (not pursued):** extend `data-tab-theme` to `AdminLayout` + `LandingLayout` (their tabs stay Matt for v1); `#2a93d5`/`--brian-sky` is in the style guide but **unused by mapping A** — wire it in or leave documented.

### Build log — §1 follow-up (Conv 415): Modules-tab/stepper UI refinements + `[R2-SEED]` dev-tooling (all 5 gates green + live-verified)

A batch of post-§1 UI refinements to the Modules tab and journey stepper (user drove in **batch mode** — implement each tweak directly, defer all gates + verification to the end of the batch), plus a dev-tooling thread (`[R2-SEED]`) that surfaced the miniflare version skew (`[MF-SKEW]`, deferred). Committed `ed70e19a` (`jfg-dev-14`, 5 files, +184/−26).

- **`[STEP-LINK]` enrollment-stepper link affordance — persistent underline.** `CourseJourneyStepper.astro`'s green band had linked and static steps that looked identical (ambiguous case = identical-green Enroll-static vs Payment-link). Added `underline decoration-1 underline-offset-2` (hover→`decoration-2`) to the *label* of linked steps in **both orientations** via a shared `linkUnderline` const; decoration inherits the label's own colour (no new token → prov-clean). Chosen via `AskUserQuestion` (persistent underline over trailing-chevron / hover-only) — only a resting cue answers "which can I click?" at a glance and on touch; hover-only fails, and underline is the codebase's link vocabulary + good a11y (not colour-alone). Playwright DOM-verified: Payment/Sessions underline 1px, Enroll/Diploma none.
- **Modules-tab hover = neutral tint.** The green hover tint (`bg-course-background` #E8F4DF) was byte-identical to the `variant="course"` Button base fill (used page-wide), so hovering a ghost element read as a resting CTA; file rows also hovered a bluish `bg-student-background` (Primary-Light) clashing on an all-green page. Swapped the 4 Modules-tab hovers → `hover:bg-neutral-50` (dominant 41-use convention); course CTAs untouched. No light green can separate from the pale-green button (both light-green-on-white) — a neutral tint reads unambiguously as feedback, never a CTA. (Confirmed the course-variant Button base = the hover-green, which informs future hover choices; also fixed the prior blue-on-green clash.)
- **Sticky "Go to Session" CTA hover = subtle darker-green tint, variant-aware.** That sticky CTA is the **Button primitive** (`SubNav.astro:247`, `variant="course" property1="Small"`) — the primitive draws hover only for the Figma `property1="Hover"` state, so at `Small` it has **no** CSS `:hover`; the hand-rolled ModulesTab hovers were a different code path. `hover:opacity-90` was imperceptible (dropping opacity blends a pale-on-white button *toward* the page background → invisible). Made `actionHover` variant-aware: `course` → `transition-colors hover:bg-course-primary/20 hover:border-course-primary/20` (deeper pale green ≈ #D6E5CC, dark text kept — existing token via opacity modifier, prov-clean); other variants keep `hover:opacity-90`. DOM-verified rest #E8F4DF → hover ≈ #D6E5CC, opacity-dim gone.
- **Modules-tab card layout + per-file Download buttons.** Right column `justify-center` → `self-stretch justify-between` (duration pins to the title's first line, the action button drops clear of the "20 min"/"30 min" label, circle stays centered); per-module + course-wide file rows are no longer a whole-row `<a>` — each gained an explicit **Download** (upload) / **Open** (external) button. Fixed a JSX slip (comment-in-map-return). User: "Your changes look good."
- **`[R2-SEED]` dev R2 placeholder-blob seeding.** Clicking a file Download 404'd and the browser saved the JSON error as `download.json`: Module 1's two files are seed `session_resources` **metadata** rows (`res-n8n-003` PDF, `res-n8n-001` ZIP) with an `r2_key`, but the actual R2 **blobs never existed** — `migrations-dev/0001_seed_dev.sql` inserts metadata and SQL can't PUT to R2, so local R2 had 0 objects and `/api/resources/:id/download` returned `404 {"error":"File not found in storage"}`. (Pre-existing — the old whole-row link had the same dead href; not caused by the Download-button change.) Built `scripts/seed-r2-dev.mjs` (type-appropriate placeholder — valid blank PDF / empty ZIP / text — per `r2_key`, via `wrangler r2 object put --local`) + `db:seed:r2:local` chained into `db:setup:local:dev`. Validated after a clean reseed (7/7; 329 B PDF `%PDF-1.4`, 22 B zip) and live via Playwright (res-n8n-003 → 200 application/pdf 329 B; res-n8n-001 → 200 application/zip 22 B). Downloads fixed end-to-end. Makes the file-upload feature demoable in dev; staging/prod unchanged (real uploads).
- **🔴 `[MF-SKEW]` surfaced — DEFERRED to next-conv #1 focus.** Running `db:seed:r2:local` against a live `astro dev` crashed with `table _cf_ALARM has 3 columns but 2 values supplied`: both `wrangler … --local` and `astro dev` (`@astrojs/cloudflare`) run Miniflare against the same `.wrangler/state/v3` SQLite, and the bundled versions are **skewed** — wrangler `4.20260521`, the dev server `4.20260714`; the newer migrated `_cf_ALARM` 2→3 columns ON DISK, so the older wrangler can't open it (forward-incompat). Stopping the dev server is necessary but **not sufficient** (the on-disk schema stays upgraded) → recovery = `rm -rf .wrangler/state/v3` then reseed with no dev server up (done this conv, clean 7/7). Durable alignment via `npm i -D wrangler@latest` **ballooned** — wrangler 4.114 peer-requires `@cloudflare/workers-types@^5` (a major v4→v5 bump of a tsconfig `types` package = codebase-wide tsc impact) + a global nvm wrangler 4.58 shadows the project's 4.94 on PATH — too big for a review batch, so per the multi-conv-scope carve-out it was **deferred to a focused next-conv task** (user directive: *"I cannot have the dev tooling this brittle"*). Interim rule: **stop `astro dev` before any `wrangler --local` op** (the standard setup-before-dev flow is unaffected). Lead for the focused task: find a wrangler in 4.95–4.113 whose miniflare ≥ 4.20260714 but that still peers workers-types v4. Tracked as `[MF-SKEW]` (CURRENT-TASKS.md Now #1 next conv).
- **🟠 `[DL-FILENAME]` flagged (tracked):** the download Content-Disposition filename = `resource.name` with no file extension. Low-priority; tracked as `[DL-FILENAME]` in CURRENT-TASKS.md. Also noted (Uncategorized): the `r2:list:local` npm script is broken in this wrangler version (`list` not a valid `r2 object` subcommand) — fix/remove when the wrangler upgrade lands.
- **Gates (all 5 green this conv):** tsc 0 · astro check 0-err · lint 0-err · **full suite 6552 pass** · build ✓. Per the user's batch-mode instruction the batch verification (5 gates + Playwright DOM-truth) was deferred to conv-end, then run clean.
- **Files (code, `ed70e19a`, +184/−26):** `src/components/course/CourseJourneyStepper.astro` (`[STEP-LINK]` underline), `src/components/course/ModulesTab.astro` (neutral hovers + layout + Download/Open buttons), `src/components/SubNav.astro` (variant-aware sticky-CTA hover), `scripts/seed-r2-dev.mjs` (NEW), `package.json` (`db:seed:r2:local` wired into `db:setup:local:dev`). No dependency version changes (the wrangler upgrade attempt failed clean).
- **New patterns:** variant-aware hover injected via `className` on a Button-primitive call site (the primitive lacks CSS `:hover` at `property1="Small"`); pale-tonal-button hover = darken bg via an opacity-modifier token (`course-primary/20`), NOT `opacity-90`; dev R2 blob seeding as an `npm`-wired step (`db:seed:r2:local`).

### Build log — §1 follow-up (Conv 416): course-page UI (Post button / Ask-a-Question / review composer) + messages `?to=` fixes (all 5 gates green + live-verified)

A second batch of post-§1 course-page UI refinements (David Rodriguez / intro-to-n8n), plus fixes to the shared messages `?to=` deep-link that the new "Ask a Question" wiring first exposed. Committed `d450ae2c` (`jfg-dev-14`, 9 files). The deferred `[MF-SKEW]` dev-tooling task was also resolved earlier this conv (wrangler exact-pin `4.112.0` + `@cloudflare/workers-types` v5 + global nvm bump; committed `3de05f0f`; not a §1 mechanism — tracked in CURRENT-TASKS.md, see the Infrastructure note above), and the stale Conv-415 dev server 500'd after that dependency swap and had to be restarted (Extract Learning 3).

- **Post button → module-button style.** `MattCourseFeed.tsx`'s Course-feed "Post" button was restyled to the bordered-neutral module-button treatment (`hover:bg-neutral-50`, matching the Modules-tab Download/Details buttons) + dropped the now-unused `Button` import. (Restyle-to-match chosen via `AskUserQuestion`.)
- **"Ask a Question" (Creator + Peer Teachers) wired to `/messages?to={userId}`.** Both buttons (`CreatorTab.astro`, `TeachersTabList.tsx`) were non-functional; now real links to the existing `/messages?to=` deep-link (messageability is open, Conv 110) + tonal hover (`hover:bg-student-primary/20`). `askHref` computed via the loader in `[...tab].astro`. Live-verified as real links (creator → Guy Rymberg, teachers → Marcus).
- **Gated `CourseReviewComposer` modal.** The Reviews-tab "Write a Review" affordance looked clickable but did nothing. New `CourseReviewComposer.tsx` (Modal + StarRating + Textarea + collapsible clarity/relevance/depth sub-ratings), modeled on `SessionCompletedView` (the post-session rating UI). **Display criteria = the exact predicate `POST /api/enrollments/:id/course-review` enforces** — `enrollment.status === 'completed'` + no existing review — computed via a LEFT JOIN in `[...tab].astro`, deliberately NOT the `courseComplete` journey proxy (which can diverge → the button would show then the POST 400s; Extract Learning 4). Three states: write / already-reviewed (read-only "You reviewed this ★N") / hidden. `ReviewsTab.astro` mounts the island. Verified end-to-end vs the David seed (in_progress→hidden; flipped→completed→write; POST 200; →already-reviewed); DB reverted + the course-rating aggregate drift fixed afterward (Extract Learning 6).
- **Messages `?to=` deep-link — 2 pre-existing bugs fixed.** The `?to=` links are the correct documented deep-link; "Ask a Question" was just the first feature to message a user with no existing thread, which exposed: (1) `NewConversationModal` resolved the preselect via `/api/users/search?q={id}` — search matches name/handle only, so a raw id returned `[]` (no user preloaded). Fix: added an exact by-id branch (`?id=`) to `/api/users/search`; preselect now uses `?id=`. (2) `MessagesCenter`'s `?to=` effect re-fired on every 10s poll (`conversations` dep, no guard, URL param never cleared) → the modal reopened endlessly. Fix: run-once ref guard + strip the `?to=` URL param + clear intent on modal close. Playwright-verified (with client-user cache warmup — Extract Learning 5): modal opens with "Guy Rymberg @guy-rymberg" preloaded, closes and stays closed, no reappear after a 12s wait (> one poll cycle).
- **Held off (open):** per-post **Enroll-Now** hover state — a pervasive shared component; the user explicitly deferred it to when that component is styled.
- **Gates (all 5 green):** tsc 0 · astro check 0-err · lint 0-err · **full suite 6552 pass** · build ✓.
- **Files (code, `d450ae2c`, 9):** `src/components/course/CourseReviewComposer.tsx` (NEW), `CreatorTab.astro`, `MattCourseFeed.tsx`, `ReviewsTab.astro`, `TeachersTabList.tsx`, `src/components/messages/matt/MessagesCenter.tsx`, `NewConversationModal.tsx`, `src/pages/api/users/search.ts`, `src/pages/course/[slug]/[...tab].astro`.
- **New patterns:** **API-aligned gating** — compute a UI affordance's visibility from the exact predicate the backing endpoint enforces (not a convenient proxy), so display and acceptance never disagree (Extract Learning 4); **tonal-button hover** — `transition-colors hover:bg-{variant}-primary/20` for pale variant buttons (matches the SubNav convention).

### Build log — §1 follow-up (Conv 417): in-place message composer + site-wide current-user bootstrap race (all 5 gates green + live-verified)

A direct follow-on to Conv 416: the "Ask a Question" buttons that conv wired to `/messages?to=` **navigate the reader off the course page**, which the user reported as wrong for that interaction. Fixing it grew into a codebase-wide message-affordance sweep and then uncovered a **pre-existing site-wide auth bug** unrelated to MERGE-BRIAN. Committed `1f7bfd79` (`jfg-dev-14`, 10 files, +605/−38).

- **`MessageUserButton` — shared in-place composer island (NEW).** Both course affordances were plain anchors (`TeachersTabList.tsx`, `CreatorTab.astro` via `askHref`), and `Button href=` renders an `<a>`, so the click was a full navigation; no modal existed on the course page (`NewConversationModal` is mounted inside `MessagesCenter`, so `?to=` only opened it *after* the jump). New `src/components/messages/MessageUserButton.tsx` composes the existing `Button` + `NewConversationModal` + `showToast` — **no new API surface** (the modal's preselect-by-id path makes `preselectedUserId` sufficient). Adopted on both course tabs (`CreatorTab` prop `askHref` → `askUserId`, button becomes a `client:visible` island; `signedIn={!!userId}` threaded from `[...tab].astro`); **signed-out viewers keep the plain anchor** so the login bounce survives. Chosen over a page-local modal (would duplicate the pattern immediately) and over a blanket site-wide flip (some sites legitimately want the jump) — opt-in adoption, the same shape as §1's Tier B shared primitives.
- **Discard guard on unsent drafts.** Measured (not inferred) that a backdrop click **unmounts** the modal (`closeOnBackdropClick` defaults true, `Modal` returns `null` when closed) with **0** POSTs fired and the draft value back to `""` — i.e. silent data loss. User chose the most protective option: every dismissal path (backdrop / Escape / ×) now raises a "Discard message?" `ConfirmModal` when the draft is non-empty, re-entry-guarded so a second Escape can't stack prompts; the send path calls `onClose` directly so it is never prompted. Applies to `/messages` too (same modal). Rendered after `</Modal>` so at equal `z-50` the later DOM node paints on top. **🟠 Cosmetic:** the two 50%-opacity backdrops compose to ~75% black — legible, noted, not changed.
- **Opt-in "Open in Messages" escape hatch.** The composer has no thread history, so `showOpenInMessages` (default **OFF**, only `MessageUserButton` opts in) renders a real `<a href="/messages?to=…">` — middle/cmd-click open a tab normally (deliberately unguarded: page + draft survive), a plain click with unsent text routes through the discard prompt. **Zero new plumbing:** `?to=` is already thread-aware (`MessagesCenter:104-110` — existing conversation selects the thread, none opens the composer), verified live to land on the real thread with prior messages. Always-on was rejected as circular (the modal is mounted *inside* `MessagesCenter`).
- **Silent-failure fix (found while wiring):** `NewConversationModal.handleStartConversation` swallowed a non-ok POST — no error, modal left open, button apparently dead. Now raises an error toast.
- **Sweep — 23 message affordances censused, per-site dispositions recorded** (21 MODAL · 1 KEEP `Sidebar:315` plain nav · 1 out of scope). Reading each call site (rather than pattern-matching hrefs) surfaced the decisive structural fact: **only 3 of 22 are `Button` components; 19 are bespoke icon-only `<a>` tags** with per-site classNames — so `MessageUserButton` does not drop in and adoption is not an href swap. Also **corrected a claim made earlier the same conv** — the admin panels are slide-in panels over filtered lists (`AdminDetailPanel.tsx`), making them among the *strongest* modal candidates, not "plausibly want the jump". Verified `POST /api/conversations` reuses an existing thread (200 vs 201), so nothing duplicates.
- **🔴 `[MSGBOOT]` (M1) — pre-existing site-wide current-user bootstrap race, FIXED.** Probing `useCanMessage` to *write the plan* revealed a second symptom of the same bug: cold visit → 0 requests / 0 icons, warm → 5 / 5. `getCurrentUser()` hydrates from localStorage then revalidates, returning `null` until `CurrentUserInit` resolves — and two independent consumers read that `null` as "logged out": `MessagesCenter` redirected an authenticated user to `/login` (which bounced them Home), and `useCanMessage` set `canMessage=false` without calling the API, so every `{canMessage && …}` affordance rendered nothing on a first visit. Neither logged anything and both self-heal on the second visit, which is why they survived. **Fix = two consumers joining an existing pattern, not new architecture:** `src/lib/current-user.ts` already exports `AuthStatus = 'loading' | 'authenticated' | 'visitor' | …` + a `useAuthStatus()` hook, already used by `StudentDashboard` / `ProgressionNudge` / `useCreatorGate`. SSR-seeding (the task's stated "durable option") was **not** needed. Done-test on **fresh Playwright contexts**: cold deep-link → thread ✓, cold members → 5 icons on first load (was 0) ✓, genuine visitor still redirected to `/login` ✓.
- **Gates (all 5 green):** tsc 0 · astro check 0-err · lint 0-err · **full suite 6568 pass** (+16: `MessageUserButton.test.tsx` 12 incl. an opt-out pin, `useCanMessage.test.ts` 5 pinning the three auth states apart, −1 net elsewhere) · build ✓. Live-verified as David Rodriguez on `:4321`: both tabs render `<BUTTON>` not `<a>`, no navigation, recipient preselected, live POST → 200 + toast, anon fallback anchor intact; discard prompt owns the viewport centre (`elementFromPoint`, not a screenshot), Cancel preserves the draft, Discard closes with 0 POSTs.
- **Files (code, `1f7bfd79`, 10):** `src/components/messages/MessageUserButton.tsx` (NEW) · `messages/matt/NewConversationModal.tsx` (error toast + discard guard + `showOpenInMessages`; stale header comment referencing a removed legacy `Messages.tsx` corrected) · `messages/matt/MessagesCenter.tsx` · `src/lib/useCanMessage.ts` · `course/TeachersTabList.tsx` · `course/TeachersTab.astro` · `course/CreatorTab.astro` · `pages/course/[slug]/[...tab].astro` · `tests/components/messages/MessageUserButton.test.tsx` (NEW) · `tests/lib/useCanMessage.test.ts` (NEW).
- **New patterns:** **opt-in shared affordance island** — a component wrapping a modal, adopted per call site rather than swept, with a prop-gated escape hatch that is OFF where it would be circular; **cold-vs-warm as an explicit test axis** — repeated loads in one browser context are not independent samples, so `browser.newContext()` per probe (both `[MSGBOOT]` symptoms are invisible on a warm browser); **tri-state consumer contract** — a nullable cached-then-revalidated singleton cannot express "not yet known", so every consumer treating `null` as a decision is a latent first-visit bug.

#### MESSAGES mini-plan (M1–M6) — recorded Conv 417

Sequenced on the task board with dependencies + per-step done-tests (**`CURRENT-TASKS.md` is the authority**; mirrored here because the sequence outlives §1). Adoption of the 21 swept sites was deliberately deferred behind M2/M3: 19 of 21 need an icon variant that does not exist, and until M1 landed the affordances did not render on a first visit at all.

- [x] **M1 `[MSGBOOT]`** — current-user bootstrap race (both symptoms) — ✅ Conv 417
- [x] **M2 `[CANMSG]`** — per-row `useCanMessage` fan-out **retired** (4 requests → 0, measured) — ✅ Conv 418. The undecided fork resolved as a **third** option once the premise was re-tested: the gate was *not* vacuous (3 of 4 surfaces did not filter soft-deleted users), so the sources were fixed first and only then was the gate dropped. No batch endpoint was needed
- [x] **M3 `[MSG-ICON]`** — `appearance="bare"` icon/child variant of `MessageUserButton` (discriminated prop union; unblocks M4/M5) — ✅ Conv 418
- [x] **M4 `[MSG-ADOPT-A]`** — all 11 high-consequence affordances adopted across 9 files (incl. the 7 admin slide-over panels) — ✅ Conv 418. 7 of 11 live-verified; 4 unreached, each with its precondition named (below)
- [x] **M5 `[MSG-ADOPT-B]`** — all 10 list/profile sites adopted — ✅ Conv 419, **10 of 10 live-verified**. Both "Learning with X" judgment calls resolved to MODAL **on evidence rather than taste**: `POST /api/conversations` is find-or-create (`index.ts:212-226`), so the composer appends to the existing thread instead of duplicating it, and `showOpenInMessages` reaches the history in one click — the modal is a strict superset of the anchor. `SessionRoom:364` kept its anchor as planned (thread-intent, not compose)
- [x] **M6 `[MSG-CLEANUP]`** — messages-area debt sweep — ✅ Conv 419. The keep-or-delete call went to **delete**: zero `src/` callers, and `canMessage()` in `lib/messaging.ts` (used by `POST /api/conversations` and `/[id]/messages`) was always the authoritative gate, so enforcement is untouched. Endpoint + 7 tests removed, 6 docs updated. Also fixed the stale `MessagesCenter` header and the `NewConversationModal` `set-state-in-effect` warning (by deriving rather than storing). `prov:sweep` needed no action — `MessageUserButton` is not among the 10 `[PROV-SWEEP-DEBT2]` errors
- [x] **`[CMDEL]` (Conv 418, raised + closed at the r-end checkpoint)** — the M2 loader sweep left `GET /api/me/communities/[slug]/members` as the **only** member-listing query still joining `users` unfiltered. Surfaced by the r-end docs agent, verified against source, then decided rather than assumed: the list it backs (`CommunityManagement.tsx`) is **read-only** — no remove, no promote, no row actions — so the "creator needs the row to act on it" case had nothing to act on, and leaving it made that panel's `Members (n)` disagree with the now-filtered directory tab. Filter added + test (`tests/api/me/communities/[slug]/members.test.ts`, 12 in file); suite **6584**; documented in `API-COMMUNITY.md` on both endpoints
- [ ] **M4 residue (accepted, not a blocker)** — 4 affordances remain live-unverified, each gated on a specific setup: 2 need a three-step booking-wizard state (`SessionBooking`), 1 needs a live session (`SessionParticipantCard`), 1 needs a `moderation_actions` row with a resolvable `targetUser` (`ModerationDetailContent`). Covered by tsc + the 21 `MessageUserButton` unit tests + the build; a later pass has a setup checklist rather than an open-ended retry

### Build log — §1 follow-up (Conv 419b): MESSAGES M6 + two defects found verifying M5

Closed the MESSAGES programme and cleared the two defects M5's verification surfaced. Suite **6586** (net: +3 M5, +6 useRoleTabs, −7 deleted can-message), 408 files, all 5 gates green, lint warnings 167 → 166.

- **`[COURSETAB-HASH]` — the tasked hypothesis was wrong, and the real cause was already familiar.** Not a `courses:tabchange` dispatch race: `useRoleTabs`'s reset-on-role-lost effect fired *during hydration*, when `visibleTabs` (derived from the current user) still held only the neutral tab — so it could not tell "you don't have that role" from "we don't know yet", reset the deep-linked tab, and the hash sync then erased the evidence. **The same three-state bootstrap race as `[MSGBOOT]`**, M1 of this very programme, in a different consumer. Fixed the same way: a `ready` flag both callers pass from `useAuthStatus()`. +6 tests, 3 of which fail if the gate is reverted (checked by reverting it). Live-verified `/courses#student`, `/courses#teaching`, and that a signed-out viewer still falls back and has the hash cleared.
- **`[ICON-4PX]` — measured, half-fixed, half deliberately deferred.** The mechanism: `tokens-tailwind-bridge.css` overrides exactly ten spacing values (`4,8,12,16,20,24,32,40,48,64`), so for those `N` means N px while every other value keeps Tailwind's `N × 4`. Measured in-browser: `h-4`=**4px**, `h-5`=20px, `h-8`=**8px**, `h-16`=**16px**. For spacing that is the intended Conv-174 behaviour; the bug is only where an author meant the multiplier. Swept the unambiguous half — `h-4 w-4`/`w-4 h-4` → `size-[16px]`, **43 sites in 21 files**, including the 5 `ui/icons.tsx` *defaults* (so every un-overridden chevron was 4px) and two **checkboxes**. Lone `h-4` (skeleton bars, sentinels) is deliberate and untouched. **The task's grep-derived "44 `h-4 w-4`" framing missed `h-8 w-8` entirely** — found only by measuring live DOM across 18 routes. Residue (`/become-a-teacher`, gated behind `[RG-PUBLIC]`; ~155 intent-ambiguous sites) documented on the task with a measure-first method.
- **`[MSG-CLEANUP]` — all four items verified before acting, and two were misstated.** The stale `MessagesCenter` header was real but one directory off; the `[RHOOKS]` warning was at line 62, not 54. `prov:sweep` needed nothing (baseline 10 unchanged). The endpoint decision went to **delete** — see the mini-plan entry above.
- **Method note.** Three task premises in this programme were written from reading a *function* rather than its *call sites*; a fourth (`[ICON-4PX]`) was written from grep rather than measurement. Both failure modes produced a plausible, wrong scope. Where a claim is about what renders, measure it.

### Build log — §1 follow-up (Conv 419): MESSAGES M5 (all 5 gates green + 10/10 live-verified)

M5 `[MSG-ADOPT-B]` closed the adoption programme — 12 files, suite 6584 → **6587**.

- **The task's own "How" was wrong for 3 of the 10 sites, in the now-familiar way.** It prescribed `appearance="bare"` for the whole tranche, but `bare` deliberately bypasses the `Button` primitive (its comment: *"Button's base classes would fight it"*), and `TeacherProfileHeader` / `CreatorProfileHeader` / `UserCard` are exactly the three sites that *want* that chrome. They needed `appearance="button"` — which in turn hardcoded `property1="Small"` and a 20px `MattIcon`, while all three sites use `Default` padding and a 16px `@components/ui/icons` glyph matching their sibling buttons (Website, Book a Session). **Third conv running that a task premise written from reading the function did not survive contact with the call sites** (cf. M2's "vacuous gate", M4's "thread `signedIn` through").
- **Fix: `icon` widened to `string | ReactNode`** — a string stays a MattIcon name sized to `property1`; a node renders verbatim. Same escape hatch `bare` already gives via `children`, for the same reason. Plus `property1="Default"` at the 3 sites. Verified by measurement, not eyeball: the converted Message control reports padding `12px` / font `14px` / radius `39px` — identical to its sibling `Book a Session`.
- **7 bare sites** converted with `className`, `title` and icon element verbatim: `MyStudents`, `TeacherStudentList`, `CreatorTeacherList`, `TeacherUpcomingSessions`, `CommunityMembersTab`, `EnrollmentCard`, `CourseProgressCard`.
- **All 10 sit inside `client:load` / `client:only` islands** — checked before converting, since a server-only render would have silently dropped the click handler while leaving the markup plausible.
- **10 of 10 live-verified** by Playwright across 3 seed users: composer opens, URL unchanged, and **zero surviving `/messages?to=` anchors** on any of those routes. Two initial misses were probe-setup errors, not code — `/courses` is hash-tabbed and `gabriel-rymberg` has 0 certified teachers (`guy-rymberg` has 7). Harness kept at `_scratch/msg-adopt-b/verify-msg-adopt-b.mjs`.
- **+3 tests** pinning the node-icon path (node renders verbatim with no MattIcon substituted; string still resolves to a MattIcon; node carries onto the signed-out anchor) — 24 in the file.
- **Two pre-existing defects surfaced and tasked, not fixed:** `[ICON-4PX]` (44 `h-4 w-4`-class occurrences across 17 files render at **4px**, not 16px — the Conv-174 global `--spacing-*` override; confirmed on a stashed baseline) and `[COURSETAB-HASH]` (`/courses#student` deep link doesn't restore the tab). Preserving each call site's classes verbatim is what made the first one detectable.

### Build log — §1 follow-up (Conv 418): MESSAGES M2–M4 (all 5 gates green + live-verified)

Three steps of the Conv-417 MESSAGES mini-plan closed in one conv. Committed `3b3310cd` (M2) · `1d0e740a` (M3) · `148ac48d` (M4) on `jfg-dev-14` — 17 files, +611/−156.

- **M2 `[CANMSG]` — per-row can-message fan-out retired, 4 requests → 0.** Re-measured with Playwright on `/community/ai-for-you/members` (fresh browser context per probe): **4 requests on both cold and warm loads** — one per member minus self, all returning `true`. Then tested the task's own premise that the gate is vacuous and found it **only half-true**: `/@handle` filters `deleted_at` (`users.ts:212`) but the community-members query and the teacher/creator profile lookups did **not**, so on 3 of 4 surfaces the gate was load-bearing for a soft-deleted user — and the members directory could list a soft-deleted user whose row linked to a `/@handle` that 404s. **Chosen path (user, a third option surfaced beyond the task's two): fix the sources, then drop the gate.** `deleted_at IS NULL` added to `loaders/communities.ts` (member directory), `loaders/teachers.ts` and `loaders/creators.ts` (profile lookups), matching `fetchPublicProfileData`; `useCanMessage` then rewritten as a pure `useAuthStatus` + `useCurrentUser` derivation — **no effect, no fetch** — keeping the `[MSGBOOT]` three-state contract. Its test was rewritten for the changed premise (now asserts the API is never called in any auth state) and **NEW `tests/ssr/soft-deleted-users.test.ts`** (3 tests) pins the three filters *because* the client derivation now depends on them. Live: 4 → **0 requests** cold and warm, icons unchanged at 4; signed-out 0, own-profile 0, other-profile 1. Suite 6573. `GET /api/me/can-message/:userId` retained with no UI caller → keep-or-delete moved to M6.
- **M3 `[MSG-ICON]` — `appearance="bare"` variant.** `MessageUserButton` gained `appearance: 'button' | 'bare'` as a **discriminated prop union** (`label` required in `button` mode, `title` required in `bare` mode), following `Button`'s own `LinkProps | NativeButtonProps` shape rather than inventing one. The bare appearance renders a plain `<button>` carrying the call site's own icon as `children` with `className` passed through verbatim — **deliberately bypassing the `Button` primitive**, whose pill radius/border/padding would fight the site's styling, and left **unstamped** for `data-prov` so it adds no new `[PROV-SWEEP-DEBT2]` offender. Rejected: a separate `MessageUserIconButton` (would duplicate the modal, discard guard and escape hatch) and optional props on a flat interface (runtime ambiguity). +5 tests (16 in the file); suite 6578; the two existing course-tab call sites live-verified unchanged (`<button>`, 39px radius, 8/12px padding, student background); prov:sweep unchanged.
- **M4 `[MSG-ADOPT-A]` — all 11 high-consequence affordances converted.** None of the 8 owning components had **any** viewer knowledge, so rather than hardcoding `signedIn` 11 times or adding a hook to 8 files, the prop was made **optional and self-resolving from `useAuthStatus()` when omitted** (an explicit prop still wins, sparing the 2 course tabs that know server-side a resolve + flicker). All 11 affordances across 9 files converted to `appearance="bare"` with each site's `className`, `title` and icon preserved: `booking/SessionBooking.tsx` (×2), `SessionParticipantCard.tsx`, `teachers/workspace/TeacherSessionsList.tsx`, and `admin/{User,Teacher,Enrollment,Session,Moderation,CreatorApplication}DetailContent.tsx` (7, `SessionDetailContent` ×2). Zero raw `/messages?to=` anchors remain in the target set. +5 tests (21 in the file); suite 6583. **7 of 11 live-verified** (button renders, composer opens, URL unchanged); the 4 unreached are recorded with their preconditions in the mini-plan above — **the user's call to close on that split**, since all four are the same component with the same props shape as the seven verified, and both mechanisms that mattered (bare button in a slide-over panel; bare button in a list) were confirmed to open the composer without navigating.
- **Gates (all 5 green at each of the three commits):** tsc 0 · astro check 0-err · lint 0-err · build ✓ · full suite **6573 → 6578 → 6583**.
- **🟠 `[PROV-SWEEP-DEBT2]` drifted 10 → 11** — new offender `course/CourseReviewComposer.tsx` (introduced Conv 416), recorded on that task; not caused by this conv's work.
- **🟠 Third `[DEVSRV-STALE]` variant recorded** — a route-specific 500 (`/teaching/sessions`) on a dev server running since Conv 417, from a stale Vite dep-optimizer chunk that a 9-file import change triggered a re-optimize the long-running server couldn't follow. Distinguishing signature: **the server responds** (not the `curl 000` bricked-daemon variant) but one route 500s while `npm run build` is clean — which is what proves it is never a code defect. Fix `rm -rf node_modules/.vite` + restart; the fresh `astro dev` daemon binds `[::1]` only, so probe `localhost:4321`, not `127.0.0.1`.
- **New patterns:** **optional-prop-with-hook-fallback** — a prop most call sites would pass a constant for is better made optional with a hook-derived default, keeping the explicit form for callers that genuinely know (prop-threading pressure across ignorant components is a signal the value belongs to the leaf); **guard-removal precondition** — before deleting a check as vacuous, enumerate its call sites and prove the guarded condition cannot arise at each, fix the data sources where it can, then pin those sources with tests that say why they exist.

### Architecture in one paragraph

Our page keeps a state-rich full `CourseHeader` hero (default/scheduled variants, CTA, includes), the journey stepper in the content column, and a broad 7–8 tab set separating Modules, My Sessions, and Homework. **Correction (Conv 408, live-verified):** that hero is **not** About-only — it renders identically above the tab strip on every tab (checked on `/modules`), so "his change adds permanent identity we lack" is false. Both designs put persistent identity above the tabs; the real axis is what it costs and what it carries. His pivot replaces that with a slim art-branded `CourseMiniHeader` that is **permanent chrome** above the tab strip on every tab (and on `book`/`success`), moves the CTA into the green journey band below the strip, and uses Astro view-transition freezing so only the panel under the band swaps. He collapses the IA to **4 tabs — About, Course Feed, Peer Teachers, Sessions** — by merging Modules + My Sessions into a single fold-based `SessionsTab` and hiding (not deleting) Creator/Reviews/Resources behind hero/About deep-links (routes stay live; `/modules` 301→`/sessions`). The cluster is re-parented into a shared `back-header` slot + `--pin-top` sticky system and a 640px `contentWidth="feed"` geometry — so the changes reach `AppLayout`, `SubNav`, `SubNavItem`, and `CourseRail` rather than staying page-local. Net: ours is hero-centric with wide tab breadth; his is a persistent-identity, session-centric, app-like shell with heavier shared-shell coupling.

### Findings that resolve open questions

- **`CourseTabs.tsx` plays no role in his course page** — at the pivot it's imported only by `discover/ExploreCourseTabs.tsx` (a discover subsystem **we deleted in Conv 392** along with it). His only touch was a label sweep. The Conv-396 modify/delete dilemma is void.
- **`CourseHeader.tsx` is fully orphaned at the pivot** — his own later reorg replaced its last three consumers with `CourseMiniHeader`, so the entire `[COVER-STORY]`/`[COVER-STORY-MIRROR]` hero-mirror work is **dead code on his branch**. Skip it; only `CourseCoverPanel` (catalog side) survives into §2.
- **Homework never existed on his branch** — `[HW-SUBMIT-UI]` (our Conv 387) post-dates his fork. His 4-tab merge therefore collides with our Modules + My Sessions + **Homework** trio; Homework's placement in any adopted IA needs an explicit decision.
- **Sessions tab visibility flips**: ours is enrolled-gated; his is public/browseable (states/actions render enrolled-only).

### Mechanism inventory (dispositions DONE — Conv 408)

| Mechanism | Data/API deps | Site-wide ripple | Token/colour | Disposition |
|---|---|---|---|---|
| `[HDR-ABOVE-TABS]` permanent chrome: `CourseMiniHeader` in `entity-header` on every tab + `book`/`success`; view-transition `persist`; About panel rebuilt (video placeholder, creator/community cards, 2-review preview) | loader `community` join (`progressions→communities`) | pushes onto `book`/`success`; depends on `back-header` slot + `--pin-top` | 🔴 heavy raw hex: on-dark link `#7cc4ec`×5 ("honest orphan — no on-dark link token"), `#d7e6ef`, `#c6d6e2`, `#e8a213`, gradient `#0e3a5c`/`#0b2740`; forces `text-white` over `.entity-course` → breaks role-blue links | **ADAPT** (Conv 408) |
| `[SESS-TAB]` merged Sessions tab: session-grouped `<details>` folds, 6-state machine (`done/live/booked/next/locked/browse`), actions overlay outside `<summary>`; kills Modules/My Sessions split | loader `moduleProgress`, `resources`, session-group counts in `CourseJourneyState`; extra DB read per course-tab load | course cluster + shared loader (additive) | tokens good; many arbitrary px (`pr-[168px]` overlay etc.) | **ADAPT — curriculum-first** (Conv 408) · **✅ BUILT Conv 411** (route `/modules`, label "Modules", 2nd) |
| `[SESS-FILES]` course/session file strips + badges (see §5) | `0006` columns + loader `resources[]` | none (additive) | minor | **ADAPT** (Conv 408) · **✅ BUILT Conv 412** (per-module + course-wide strips; `display_order` only, `in_room` + dead-link dropped) |
| `[TCH-SEARCH]` `TeachersTabList` island: header-docked live search + sort-in-search; "Peer Teachers" label | none new | none — course-only | clean; arbitrary widths only | **ADAPT** (Conv 408) |
| `[BAND-ACTION]` journey band: links only on actionable steps (`isLinkStep`), green CTA at band end | existing `buildCoursePrimaryCta` | course cluster (stepper on 4 routes) | raw green `rgba` CTA shadows | **ADAPT** (Conv 408) |
| `[TAB-SCROLL]` scroll-preservation script on tab switch (with `ResizeObserver` clamp-retry for slow islands) | none | 🔴 **shared `SubNav`** — fires on every SubNav surface site-wide | JS only | **ADAPT — opt-in** (Conv 408) |
| `[TAB-FLOAT]`+`[TAB-COMPACT]` floating-pill, ~65%-height top-strip chips (selected = blue gradient capsule) | none | 🔴 **shared `SubNavItem`** — every top-strip SubNav | raw `#2a93d5`, `#dfe6ee`, 8 `rgba` shadow stacks; `py-[6px]` documented-required | **ADAPT — compact only** (Conv 408) · **colours later adopted as a toggle-gated theme** (`[TAB-THEME]`, Conv 414 — flat, tokenised, 0 raw colour) |
| `[BACK-X]` sticky X-style `BackHeader` (desktop) + breadcrumb swap on **7 deep routes only** (NOT site-wide — 22 pages keep `header-bar`; correction Conv 408) | none | 🔴 **shared shell** — new AppLayout slot + `--pin-top` in SubNav/CourseRail; wired into 7 drill-in routes | clean tokens; `h-[52px]`, `--pin-top:68px` magic number | **DROP — for now, revisitable** (Conv 408) |
| `[FEED-WIDTH]` (untagged) `contentWidth: 'full'\|'feed'` prop on AppLayout — 640px left-anchored column for entity pages | none | AppLayout (opt-in, `display:contents` default = bit-identical) | `lg:w-[640px]` must stay in sync with Home//courses geometry | **DROP — for now, revisitable** (Conv 408) |
| `[COMM-BAND]` course-side community affiliation (logo + "part of X — N members" in header) | `0005` columns + loader join + public storage route for logos | loader + migration shared with §3 | `accent_color` = validated palette hex, stored not hard-coded | **ADAPT — logo + affiliation only** (Conv 408) |
| Teacher-switching (untagged, `POST /api/sessions`): **removes the teacher-match 403**; booking re-assigns `enrollments.assigned_teacher_id` | none (existing columns) | 🔴 **behavioral API change** — booking semantics, not cosmetics; cited to a client-side product decision in his notes — verify intent with Brian | n/a | **DROP — keep one-teacher rule** (Conv 408) |
| `MattCourseFeed` compact composer + skeleton loaders; `CourseEmbedCard` elevation | none | `CourseEmbedCard` shared across feed surfaces | raw `rgba` shadows; `bg-neutral-100` non-token | **ADAPT — composer + skeleton, tokenised** (Conv 408) |

*(`[TAB-OWNS-PAGE]` was his intermediate step, fully superseded by `[HDR-ABOVE-TABS]` within the branch — no separate disposition.)*

### 🔴 Data-model correction: Modules ≠ Sessions (Conv 408, from `migrations/0001_schema.sql`)

The client's working equation "Modules = Sessions" is **false at the data layer**, and this constrains any session-first IA:

- **`course_curriculum` (Modules)** — `course_id NOT NULL`, no enrollment reference. Curriculum exists with **zero students**; it is the public, browsable description of the course.
- **`sessions`** — `enrollment_id NOT NULL`. A session **cannot exist without an enrollment**. For an unenrolled visitor there are no sessions at all, so a sessions-first tab must synthesise pseudo-rows from curriculum (which is what his "2 sessions · 2 modules covered" line is doing).
- **The link is late-bound, not an identity** — `sessions.module_id` is nullable, and the schema comment states *"Module linkage (frozen on completion, NULL while scheduled)"*. So a **booked-but-not-yet-completed** session has **no module**, and a row rendered as `Session N · <module title>` cannot be populated for it. His screenshots only ever showed *completed* sessions (Amanda), so this case is unexercised — **verify against a booked-not-completed fixture before implementing any session-first list.**
- **Homework straddles both** — `homework_assignments` is `course_id NOT NULL` + **`module_id` nullable** (`REFERENCES course_curriculum`), so an assignment is course-level *or* module-level and belongs on the curriculum side; `homework_submissions` requires `enrollment_id NOT NULL`, so submissions belong on the enrollment side. If Modules stop being a surface, module-scoped assignments lose their natural home.

**Consequence:** the defensible synthesis is **curriculum-first with a session overlay** (one public tab showing modules, annotated with your session state once enrolled) rather than his sessions-first framing — it keeps the public surface public, removes our off-strip My Sessions, and never has to render a module-less session row.

### Divergences to reconcile if adopting the IA

- **Journey step 4:** his `certificate` (always locked, `href:''`) vs our `diploma` → `/diploma/[enrollmentId]` — his naming violates our [DIPLOMA] rule (completion = diploma); ours is functional, his is a stub. Keep diploma semantics in any adoption.
- **`buildCourseExploreTabs` signature:** his drops `isEnrolled` (4 public tabs, no Homework) vs ours `(slug, isEnrolled)` with enrolled-only Homework.
- **`CourseSessionsActions` sub-row**: deleted in his model (actions live inside session rows).
- **Enrolled-gating**: our `/sessions` redirects non-enrolled; his is public.

### Provenance census (new files at the pivot)

`SessionsTab.astro` + `BackHeader.astro` = `data-prov="matt-inspired"` ✓ · `CourseMiniHeader.tsx` = `data-prov-name` only, docstring "UNMARKED = ours" · `TeachersTabList.tsx` = **no marker** (wrapper `TeachersTab.astro` keeps its `matt-sourced` stamp).

### User's pre-review stance (Conv 407, verbatim intent)

> "His changes are troubling to me. They subvert what the app does predictably for aesthetics that are quite intrusive and local-focussed. I find myself quite resistant to many of them."

Recorded as context, not as dispositions. The evidence concentrates the resistance on the **shared-shell / restyling layer** (`[TAB-SCROLL]`, `[TAB-FLOAT]`/`[TAB-COMPACT]`, `[BACK-X]` + breadcrumb removal, `[FEED-WIDTH]`, the diploma→locked-certificate regression, the teacher-match-403 removal); the **course-local intent items** (`[SESS-TAB]` session-first IA, `[TCH-SEARCH]`, `[BAND-ACTION]`, the About-de-duplication intent) remain live ADAPT candidates.

### Dispositions

**1 · `[HDR-ABOVE-TABS]` → ADAPT** (Conv 408, decided from a live side-by-side at `/course/vibe-coding-101`, both sides as `sarah-miller`, unenrolled).

*Measured.* Ours spends ~270px on a full-bleed stock-photo hero and wraps 7 tabs onto two rows — ~510px before first content. His spends ~56px on a dense dark band with 4 pills on one row — ~235px. Better than 2×, and the density is real: his band adds creator, community affiliation + member count, and duration. It drops the cover art (generated "AI" tile instead), the **price**, and the Enroll CTA (relocated to the end of the green journey band).

*Why ADAPT rather than ADOPT.* The compression intent is sound and worth taking. The implementation is not: the dark scrim carries the raw-hex load catalogued above (no on-dark link token exists, so `#7cc4ec` is an honest orphan — but an orphan we would own), it forces `text-white` over `.entity-course` and breaks role-blue links, and it depends on the `back-header` slot + `--pin-top` (`[BACK-X]`, mechanism 8) rather than standing alone. Dropping price from the identity block is a **commerce regression** for unenrolled visitors, not a style choice.

*What we take:* the density — compress our hero into a slim identity band, single-row tabs, reclaim ~200px.
*What we keep:* cover art (it is course identity and is reused on `/courses` cards), price, and a visible enrol affordance.
*What we leave:* the dark raw-hex scrim, the `back-header`/`--pin-top` coupling, and the CTA relocation.

**2 · `[SESS-TAB]` → ADAPT, curriculum-first** (Conv 408) · **✅ BUILT Conv 411** (route `/modules`, label "Modules", position 2nd — all user-decided; see the Tier C M2 build log above). Take the *merge* — collapse our Modules tab and our off-strip My Sessions into **one tab, in the tab strip** — but **invert his framing**: the tab is **curriculum-first and public** (modules are student-independent), with the signed-in student's session state **overlaid** on each module once enrolled. Rationale is the data-model correction above: sessions require an enrolment and bind to a module only on completion, so a sessions-first list must invent pseudo-rows for visitors and cannot label a booked-but-incomplete session with a module. Curriculum-first has neither failure. **Keep:** `Prepare / Join` and the booking affordance (carried into the row/fold body — dropping them would be the `feedback_port_functionality_and_styling` failure), **Homework as its own tab** (module-scoped assignments belong on the curriculum side; his IA has no slot for it), and **Diploma** naming over his locked "Certificate" stub. **Fixes on our side while we're here:** the merged tab goes *in the strip* (My Sessions is currently reachable only via the journey band). **Verify before building:** render a booked-but-not-completed fixture — `sessions.module_id` is NULL in that state and no screenshot on either side has exercised it.

**3 · `[SESS-FILES]` → ADAPT** (Conv 408) · **✅ BUILT Conv 412** (see the Tier C M3 build log above). Smaller than the plan implied: **`session_resources` already exists in our schema** (`course_id`, `module_id`, `type`, `r2_key`, `external_url`, `is_public`, `download_count`) with 5 live routes including `/api/resources/[id]/download`. His `0006` adds only two columns. **Take:** the inline file strip (files shown against the module they belong to instead of exiled to a Resources tab) and **`display_order`** — real ordering we lack. Honour our existing **`is_public`** so public files appear on the public curriculum tab and enrolled-only files appear after enrolment (dovetails with mechanism 2). **Wire file rows to `/api/resources/[id]/download`.** **Defer `in_room`.**

Two defects found by reading his source, both reasons not to ADOPT:
- **`in_room` is an unimplemented promise.** Its migration comment says the file "is preloaded into the BigBlueButton room", but `git grep in_room 8a1e677f -- src/` returns only `SessionsTab.astro` and `loaders/courses.ts`: it is a badge label and a sort key, nothing more. Shipping it would tell students a file is in the room when no code puts it there. If we want the capability, build the BBB pre-upload deliberately as its own scoped work, then add the flag.
- **Uploaded files are dead links.** `fileHref = (r) => r.external_url ?? null`, rendered as `<a href={href ?? undefined}>` with link colouring and a hover state — so external links work while every R2-stored file (the normal creator upload) looks clickable and does nothing.

Per ground rule 5 we author our own schema change (fold into `0001` pre-launch + reseed); his `0006` never lands.

**4 · `[TCH-SEARCH]` → ADAPT** (Conv 408). The teacher **card content is identical on both builds** (avatar, "Course Creator" badge, bio, Ask-a-Question / students / reviews row) — the whole delta is a docked search+sort control and the tab label. **Take the relabel:** our own body copy already reads "Peer Teachers · 1 available" and "a course certified peer teacher", so his tab label makes us self-consistent; Conv 407 Gate 2 confirmed the relabel is display-string only (SQL `teacher_certifications` untouched). **Take the search, gated:** probed live and it works properly, with an empty state (*"No teachers match … — Clear search"*) — the objection is scale, not quality. It renders unconditionally beside a heading reading **"1 available"**, a control that can only ever filter one row. Render search+sort **only above a teacher-count threshold** so it stays invisible at today's scale and appears as the flywheel produces certified peer teachers.

**5 · `[BAND-ACTION]` → ADAPT** (Conv 408, measured from the live DOM, `amanda-lee` / `vibe-coding-101`). **Ours: 80px, 4 links** — `✓ Enroll → /benefits`, `✓ Payment → /success`, `Sessions 1 of 2 → /sessions`, `✓ Diploma → /diploma/enr-amanda-vibe-coding`. **His: 44px, 1 link** — only the `Book next session → /book` CTA; no step is linkable and step 4 reads "Certificate **locked**".

**Take:** the compact single row (36px saved, compounding with mechanism 1's ~200px) and the CTA at the band end. **Take `isLinkStep`, with our own definition of "actionable"** — his rule leaves a *completed* student with nothing clickable at all.

Per-step rules decided with the user (Conv 408):
- **Enroll** — unlink/hide once enrolled (agreed: no longer actionable).
- **Payment** — **stays clickable.** ⚠️ But its current target is wrong: `/course/[slug]/success` is the post-Stripe *confirmation* page (it consumes `?session_id=`, self-heals a missed webhook, shows the expectations form) — **there is no receipt anywhere in the app.** The destination must become a real receipt view. Data already exists: `transactions` carries `amount_cents`, `stripe_payment_intent_id`, `stripe_charge_id`, `status`, `paid_at`, `refunded_at`, `refund_amount_cents` — so the cheap path is Stripe's hosted `receipt_url` via `stripe_charge_id`, the richer path our own page. **Note:** a payment-receipt *email* is planned (`plan/mvp-golive/README.md` line 94) and its template `PaymentReceiptEmail.tsx` was deleted as dead code in Conv 398 — but a receipt *page* was tracked nowhere until `[RECEIPT]` was opened this conv.
- **Sessions** — stays clickable (actionable).
- **Diploma** — **counts as actionable**; keep our `/diploma/[enrollmentId]` route and Diploma naming over his permanently-locked "Certificate" stub (`href:''`). Same `[DIPLOMA]` violation seen in mechanism 2.

Token note: his CTA uses raw `rgba` shadow values; ours must tokenise.

**6 · `[TAB-SCROLL]` → ADAPT, opt-in** (Conv 408). Take scroll-position preservation on tab switch — but gate it behind a **per-consumer prop** on `SubNav` (which has **9 consumers**), so the course cluster opts in and admin / profile / workspaces keep today's scroll-to-top. His script is careful (saves `scrollY` on tab-link click; restores on `astro:after-swap` + `astro:page-load` with `behavior:'instant'` to beat our global `scroll-behavior:smooth`; `ResizeObserver` clamp-retry for late-hydrating islands) and doesn't collide with our existing SubNav script (that one only toggles `data-stuck` for sticky actions). The as-is risk is purely blast radius: unconditional in the shared component = changed tab behaviour on all 9 surfaces at once. Need shrinks anyway once mechanism 1 reclaims ~200px.

**7 · `[TAB-FLOAT]`+`[TAB-COMPACT]` → ADAPT, compact only** (Conv 408). Take the **compactness** (shorter tab row) as a properly **tokenised** `SubNavItem` variant; **leave the gradient selected-capsule and all raw colour behind.** Two measured reasons not to ADOPT:
- **Provenance:** `SubNavItem.astro` is a `@matt-source` 1:1 Figma mirror (node `494:11653`, Conv 184 `[MATT-EXEC-CMP-SNV]`). His edit **kept the "Mirrors Matt's Figma … 1:1" docstring verbatim** while replacing the Selected variant with a gradient capsule, so on his branch the docstring is now false. (Softened but not erased by the Matt phase-out — `[[project_matt_phaseout_inspired_default]]`, Figma is layout-only now, CC owns consistency.)
- **Token damage (counted):** his `SubNavItem` carries **10 raw colour values** (`#2a93d5`, `#dfe6ee`, `rgba(7,119,182,…)`×4, `rgba(16,42,67,…)`×4); **ours carries 0** — fully tokenised. ADOPT would end that on the design system's most-shared primitive (9 surfaces).
- The row-wrap he's solving is a **tab-count** problem (mechanism 2's merge already removes one tab), not a style problem — repainting the primitive is the wrong lever for it.

**Follow-up (Conv 414 `[TAB-THEME]`):** the *colours* left behind here were later adopted — not as Brian's gradient capsule, but as **3 named style-guide tokens + a `--Tab-*` theme switch**, user-toggleable (matt/brian) on /profile, with `SubNavItem` staying at **0 raw colour**. "Leave the raw colour behind" stands for the *primitive default*; tokenising the 4 hues into an opt-in theme is what made adoption prov-clean. See the Conv 414 build log above.

**8 · `[BACK-X]` → DROP for now (revisitable)** and **9 · `[FEED-WIDTH]` → DROP for now (revisitable)** (Conv 408, user, decided together as the shell track). **User's words:** *"I am going to drop both (for now). I do not like the breadcrumb changes, as is, but I can be convinced by him at a later date."* So these are **soft DROPs** — not rejected on the merits, parked pending a case from Brian; keep the analysis intact for that conversation. **Not a DROP reason for Brian's ledger:** the breadcrumb-removal aesthetic is what the user declined, not the behaviour.

*Analysis retained for the revisit:*
- **`[BACK-X]` plan correction:** NOT a "site-wide breadcrumb removal" — measured on his branch, **22 pages keep the `header-bar` breadcrumb**; only **7 deep detail routes** swap to `BackHeader` (course `[...tab]`/`book`/`success`, community `[...tab]`, `creating/communities/[slug]`, `teaching/courses/[courseId]`, `session/[id]`), each dropping its breadcrumb in the trade. Behaviour is good (X-style `history.back()` with hierarchical-parent `fallback` for deep-link entry, mirroring MobileUpNav). Cost: new `back-header` slot in AppLayout + a `--pin-top: 68px` contract on `<main>` that `SubNav` and `CourseRail` must both read. Tokens clean; only magic numbers.
- **`[FEED-WIDTH]`:** opt-in `contentWidth?: 'full'|'feed'` on AppLayout; default `'full'` renders `contents` (bit-identical to today), so the prop is safe until used. `'feed'` = 640px left-anchored column (matches our Home `lg:w-[640px]`), applied to 3 pages (course `[...tab]`, `book`, `success`), narrowing course detail from full-width. Our `courses.astro` does NOT currently use the 640 column.
- **Why paired:** back-row + `--pin-top` region + 640 column are one continuous geometry; if revisited, decide both together and reconcile mechanism 1's compressed band into the same column.
- **Knock-on for mechanism 1 (ADAPT):** mechanism 1 as recorded noted a dependency on the `back-header` slot + `--pin-top`. With `[BACK-X]` dropped, the mechanism-1 band must be built **standalone** (its own slim identity band above the tabs, no back-row/pin-top scaffolding) — which is already the ADAPT intent, so no contradiction, but the implementer must not reach for the (now-absent) shell contract.

**10 · `[COMM-BAND]` → ADAPT, logo + affiliation only** (Conv 408). Author our own **`logo_url`** column (fold into `0001` + reseed per ground rule 5) and render the community **logo + "part of X — N members"** affiliation line (the piece mechanism 1's band also wanted). **DROP `accent_color`, the 10-colour palette lib (`community-branding.ts`), and the settings picker entirely.** Rationale: the accent tinting — the exact role-theming collision the user flagged — **is already dead code on his branch.** He disabled it site-wide *at the client's own request* (Conv 373): `CommunityCatalogCard.tsx` has `void accentColor` + "accents off site-wide", `entity/CommunityBand.tsx` hardcodes `const accent = null`. So ADOPT would import a schema column + palette + picker to drive a switched-off feature, carrying the collision risk dormant. Taking logo + affiliation only keeps the identity value and **permanently forecloses** the theming collision instead of shipping it disabled. His `0005` never lands (we author `logo_url` ourselves); no `accent_color` column at all. Logo storage needs a public read route — reuse our existing R2/resources infra rather than his `api/me/communities/[slug]/logo.ts` as-is (assess when implementing).

**11 · Teacher-switching (`POST /api/sessions` 403 removal) → DROP, keep the one-teacher rule** (Conv 408, user — a marketplace-policy decision, explicitly the user's per ground rule 3). **Keep our current behaviour:** `POST /api/sessions` returns `403 "Teacher does not match your enrollment"` when `enrollment.assigned_teacher_id && assigned_teacher_id !== teacher_id` (verified live on `jfg-dev-14`, `api/sessions/index.ts:246`). His branch removes that 403 and **silently re-assigns** `assigned_teacher_id` to the just-booked teacher on every booking. **DROP reason for Brian's ledger:** one teacher per enrollment is deliberate continuity; silent re-assignment on each booking has un-audited knock-ons (earnings attribution, session history, teacher's roster expectations). **Open ask stands:** his code cites "Conv 376, product decision / approved" but that rationale is in his chat only, nowhere in git — request it before any future reconsideration. Nothing to build; our code already enforces the rule.

**12 · `MattCourseFeed` (compact composer + skeleton loaders + `CourseEmbedCard` elevation) → ADAPT, tokenised** (Conv 408). Take the **compact single-row composer** (avatar + `[field-sizing:content]` growing input + Post, `gap-16` between composer/heading/posts — "feed starts higher", his Conv-372 approved mockup) and the **skeleton ghost-card loading state** (genuine improvement over a one-line "loading" message on `client:load` feed islands). **Retokenise on the way in:** his `MattCourseFeed` carries **5 raw colour values** — the skeleton blocks use `bg-neutral-100` and there are raw `rgba` shadows; map to `--color-*` tokens / an existing skeleton token before it lands. `CourseEmbedCard` elevation change is shared across feed surfaces — verify it against the other consumers, not just the course feed. No data/API deps. (Empty-state copy "The course creator hasn't enabled discussions for this course yet." is unchanged from ours — nothing to adopt there.)

*Coupling to record before implementing:* his band renders the community affiliation inline, so this overlaps mechanism **10** `[COMM-BAND]`; and it is laid out inside mechanism 9 `[FEED-WIDTH]` (640px) with mechanism 8 `[BACK-X]` above it. Implement 1 only after 8/9/10 have dispositions, or the geometry gets decided twice. *(Corrected Conv 408 — I first wrote "11" for `[COMM-BAND]`; row 11 is Teacher-switching. Update: 8+9 DROPPED, 10 ADAPTED — so mechanism 1's band is now standalone; see the mechanism-1 knock-on note under §8/9.)*

## 2 · `/courses` catalog review

**Scope (Conv 425).** Files at the pivot that land on this screen: `src/pages/courses.astro`,
`courses/CoursesCatalog.tsx`, `courses/CoursesFilters.tsx`, `courses/CourseCatalogCard.tsx`,
`courses/CourseCoverPanel.tsx` (**new**), plus five shared primitives the screen pulls in
(`form/Input.tsx`, `form/Select.tsx`, `ui/IconLabelChip.tsx`, `layout/StickyListingToolbar.astro`,
`layout/ListingShell.astro`). **Excluded** and handled elsewhere: `CourseMiniHeader.tsx` +
`CourseRail.astro` (§1 `[HDR-ABOVE-TABS]`, already ADAPTed) · `CourseEmbedCard.tsx` elevation
(§1 `MattCourseFeed` row) · `communities/*` (§3) · "Peer Teachers" relabel in
`CoursePerformanceTable`/`CourseEditor`/`CourseTabs` (§6).

**Baseline check (Conv 425):** ours is **byte-identical to the merge-base** on all four core
`/courses` files (`courses.astro`, `CoursesCatalog`, `CoursesFilters`, `CourseCatalogCard`), and
carries **none** of the cover-story machinery (no `CourseCoverPanel`, no `CommunityBand` on the
card, no `enrollment` journey mode, no `reviewsHref`). So every mechanism below is genuinely
undecided — nothing here has been silently absorbed by §1's work.

### Mechanism inventory (dispositions DONE — Conv 425)

| # | Mechanism | Ripple | Token/colour | Notes |
|---|---|---|---|---|
| M1 | `[CRS-LAYOUT]` /courses adopts Home's 640px left-anchored two-column geometry; drops `ListingShell` **and** the rail/top `navLayout` variance (filters always inline `orientation="top"`) | `ListingShell` keeps 3 other consumers (`index`, `communities`, `members`); kills [LAYOUT-MODE] Phase D rail mode **for this page only** | clean | page-level twin of §1's `[FEED-WIDTH]` (DROPped, soft) |
| M2 | `[CRS-SEARCH-FIRST]` visible "Browse Courses" h1 + description removed (sr-only h1 kept); toolbar leads the page; nudge banner moves below it | none | clean | a11y preserved via `sr-only h1` |
| M3 | `[CRS-ROLE-TABS-OFF]` `CoursesRoleTabs` hidden (commented out, code retained) | 🔴 the As-Student/Teaching/Moderating **lenses become unreachable**; `courses:tabchange`, sub-filters + hash routing all go dormant | n/a | functional removal, not cosmetics |
| M4 | `[CRS-POPULAR-OFF]` "Popular Courses" `RecommendedCourses` carousel hidden (code retained) | recommendations surface loses its only home on this page | n/a | functional removal |
| M5 | `[TOPIC-PILLS]` Level / Topic / Length dropdowns + "Filters" collapse → one horizontally-scrolling **topic** pill row (sticky "All", drag-scroll, flanking ◀▶ arrows) | 🔴 **Level and Duration filters disappear from the UI** (`FilterState` contract keeps them `null`, catalog code untouched) | clean | functional narrowing |
| M6 | `[PILL-FLOAT]` raised-pill treatment: two-layer shadows, hover lift 1px, selected = blue gradient capsule | none (page-local) | 🔴 raw `#2a93d5`, `#dfe6ee`, 8 `rgba` shadow stacks | same class as §1 `[TAB-FLOAT]` → ADAPTed compact-only, colours later shipped tokenised as `[TAB-THEME]` |
| M7 | `[SORT-IN-SEARCH]` sort moves **inside** the search box: chevron-only slot behind a hairline divider, invisible native `<select>` beneath; chevron tints brand-blue when sort ≠ default | consistency with our `TeachersTabList` (Conv 409), which kept a **visible** `Select` | clean | sort label disappears — discoverability trade |
| M8 | `[TOOLBAR-COMPACT]` `compact` prop on `Input` + `Select` (34px vs 46px) + `StickyListingToolbar` slimming (`gap-12→8`, `py-8→4`, riser `20→16px`) | 🔴 toolbar is shared by `/courses`, `/communities`, `/members` — the riser trim is site-wide | clean | opt-in props are safe; riser is not |
| M9 | `[COVER-STORY]` catalog card → "Cover story" hero: white card, left `CourseCoverPanel` (price sticker + badge), description-forward 3-line clamp (✓ checklist gone), ONE merged bottom meta line, `min-h-190` density "Option B", resting+hover 2-layer shadow, course icon right of title, green CTA docked in the title row | card is also used by `RecommendedCourses` / community Courses tabs — his change is gated to `variant="overlay" + context="catalog"`, so other hosts are untouched | 🔴 `CourseCoverPanel` gradient hexes (`#0e3a5c`, `#0b2740`, `rgba(18,179,168)`, `rgba(88,77,244)`) + shadow `rgba` stacks | the flagship of §2 |
| M10 | `[COVER-STORY-MIRROR]` the **detail** hero (`CourseHeader`) renders the same shared `CourseCoverPanel` so catalog card and detail hero look identical | 🔴 **collides with our Conv-413 `[HERO]` work** (variant-system collapse + compaction + `@container` reflow) | as M9 | client's explicit request at the pivot: *"make the detail page card look exactly like the summary listing"* |
| M11 | `[CARD-COMM-BAND]` `CommunityBand` footer on catalog cards (whole strip → community page) | low — we already adopted `CommunityBand` (§1 `[COMM-BAND]`, Conv 410) | reuses adopted tokens | cheap extension of an already-built primitive |
| M12 | `[CARD-JOURNEY]` enrolled viewers get journey mode on the card: ✓ Enrolled/Completed cover badge, CTA becomes the next journey step (book first/next · Teach this course), meta line trades students·level for own progress | duplicates `buildCoursePrimaryCta` semantics **client-side** | 🔴 his string is "Certificate earned" — **violates our [DIPLOMA] rule** (completion = diploma) | needs our own next-step source of truth |
| M13 | `[CHIP-LINK]` `IconLabelChip` gains `tone="link"` (brand blue) + `hoverUnderline` (label-only underline via `group-hover`) | shared primitive, additive | clean | our Conv-415 `[STEP-LINK]` chose a **persistent** underline for the same problem — consistency call |
| M14 | `[PRICE-FMT]` price drops forced decimals (`$249`, not `$249.00`) | bypasses shared `formatPrice` locally (11 call sites) | n/a | **see finding F2 — this fixes a real inconsistency on our side.** *(The "abbreviated rating" his comment claims is **already ours** — `ratingLabel` was unchanged context in his diff, comment-only.)* |
| M15 | `[ENROLL-NOW]` catalog CTA label "Enroll" → "Enroll Now" | none | n/a | trivial |
| M16 | `[PANEL-REMOVE]` the light-blue "More coming soon" placeholder panel deleted **site-wide** (`ListingShell` + `AppLayout` + Home + /courses) | 🔴 site-wide; our Home renders this panel today (Conv 298 client markup) | removes an `#eff6ff` honest-orphan | interacts with M1: 640-left-anchored **without** a panel leaves /courses' right region empty at ≥lg |

### Findings surfaced while building the inventory (Conv 425)

- **F1 — `form/Input.tsx` may double-render form chrome on ours (unverified).** `@tailwindcss/forms`
  is active (`src/styles/global.css:5`). Our `Select` strips the plugin's chrome (Conv 223
  `[DRV-C]`), but our `Input` never got the twin fix — the wrapper div owns a border + `px-16 py-12`
  while the inner `<input>` keeps the plugin's own border, padding and focus ring. His pivot adds
  exactly that fix (`appearance-none border-0 p-0 focus:ring-0`) bundled into the `compact` commit.
  **Needs live measurement before being called a defect** — plausible from the code, not confirmed.
  → ✅ **CONFIRMED by live measurement and FIXED (Conv 425)** while building M8: the inner `<input>`
  carried its own 1px border + 8px/12px padding inside the wrapper (`Select` had the padding half of
  the same bug). Fixed as the `[DRV-C]` twin; search 49→34px, default variant now a consistent 46px
  across both primitives. See the Tier A+B build log.
- **F2 — our price format is inconsistent between catalog and detail (verified, both sides read).**
  `CourseHeader.tsx:157` uses `minimumFractionDigits: 0` → **`$249`**; `CoursesCatalog` uses shared
  `formatPrice` (`lib/db/types.ts`, no `minimumFractionDigits`) → **`$249.00`**. Same course, two
  formats, one click apart. M14 is the fix; the open question is local override vs changing
  `formatPrice` for all 11 call sites.
  → ✅ **CLOSED (Conv 425)** — fixed at the shared helper. The "11 call sites" was a grep count, not a
  consumer count: **6 of the 11 files define their own local `formatPrice`** and never imported the
  shared one (which is why an admin test asserting `$199.00` still passes), leaving **4 real
  consumers**. `minimumFractionDigits: 0` added to `formatPrice`, plus a deliberate `formatPriceExact`
  carve-out for `receipt/[id].astro` — a financial document keeps its cents.

### Dispositions

✅ **Walk COMPLETE (Conv 425)** — all 16 decided in four batches: **3 ADOPT · 12 ADAPT · 1 DROP**. 14 buildable and built Conv 425 (see the Tier A+B / Tier C build logs); **M4 built Conv 427** once `[REC-REHOME]` resolved (see the Conv-427 build log) → **15 of 16 built, M3 alone still gated on `[ROLE-CRS-LIST]`**. Result summary at **§2 walk result** below.

**Batch A — page shell + IA (decided Conv 425):**

| # | Disposition | Build note |
|---|---|---|
| M1 `[CRS-LAYOUT]` | **ADAPT** — take Home's 640px left-anchored two-column geometry on `/courses` | `ListingShell` stays untouched for its 3 other consumers (`index`, `communities`, `members`); this page stops varying by `navLayout` (filters always `orientation="top"`) |
| M16 `[PANEL-REMOVE]` | **DROP his removal** — keep the light-blue panel **and extend it to `/courses`** | Home keeps its Conv-298 panel; `/courses` gains the same `#eff6ff` sticky aside so M1's right region isn't dead space. His site-wide deletion is not adopted |
| M2 `[CRS-SEARCH-FIRST]` | **ADOPT** — search leads the page | Visible "Browse Courses" h1 + description out, `sr-only` h1 in; toolbar first, nudge banner below it |
| M3 `[CRS-ROLE-TABS-OFF]` | **ADAPT — hide only after rehoming** · ✅ **BUILT Conv 428** | The recorded blocker was **re-tested and falsified** before building (`[ROLE-CRS-LIST]`, Conv 428). It claimed `/teaching` had no courses list and that `TeacherDashboard` "never lists them" — but `TeacherDashboard` renders `TeacherCertifications` ("My Teaching Certifications", one card per course → `/teaching/courses/{id}`) off the **same** `getTeacherCertifications()` array the tab counts from, and `/teaching/sessions` groups by course too. The cited route comment was about the **route** `/teaching/courses`, not page content. `#moderating` did hold, but is derived from `community_moderators` and is already homed in its native shape at `/communities#moderating`; the disposition also omitted the **Created** lens, covered by `/creating/studio`. So the prerequisite shrank from "two new list pages" to bringing `/teaching`'s existing list up to the tab's function. Role tabs then removed from `/courses` (mount + import deleted, not commented out). See the Conv-428 build log |

**Batch B — filter toolbar (decided Conv 425):**

| # | Disposition | Build note |
|---|---|---|
| M4 `[CRS-POPULAR-OFF]` | **ADAPT — hide after rehoming ✅ BUILT (Conv 427)** | The prerequisite is discharged. `/courses` was the **only** consumer of `RecommendedCourses`, so `[REC-REHOME]` rehomed the surface before hiding it: the carousel is gone from the listing column (his intent) and the recommendations now render as rails-backed lanes in the page's right rail. `/api/recommendations/courses` was **deleted**, not stranded — the lanes read the global Discovery Rails blob. The undecided target resolved *against* Home-the-feed-column: `[FEEDS]`'s bar names FeedsHub/ActionCards/TriageStrip in the feed column, while the Conv-298 right rail was an explicitly empty placeholder |
| M5 `[TOPIC-PILLS]` | **ADAPT — pill row, keep Level + Length** | Take the single-line scrolling **topic** pill row (sticky "All", drag-scroll, flanking arrows); Level and Length stay reachable rather than being dropped to `null`. Keeps `FilterState` fully exercised |
| M6 `[PILL-FLOAT]` | **ADAPT — tokenised, flat** | Compact geometry + clear selected state; **no raw hexes, no gradient** — same call as §1 `[TAB-FLOAT]`. The `#2a93d5` / `#dfe6ee` / 8 `rgba` shadow stacks are not adopted |
| M7 `[SORT-IN-SEARCH]` | **ADAPT — visible compact control** | Sort stays a labelled compact `Select` in the toolbar: matches `TeachersTabList` (Conv 409) and keeps sorting discoverable. The chevron-in-search trick (invisible native `<select>`) is not adopted |

**Batch C — the card (decided Conv 425):**

| # | Disposition | Build note |
|---|---|---|
| M8 `[TOOLBAR-COMPACT]` | **ADAPT — every shared change opt-in** | `compact` props on `Input` + `Select` adopted (additive, default unchanged); the `StickyListingToolbar` slimming (`gap-12→8`, `py-8→4`, riser `20→16px`) goes behind an **opt-in prop** so `/communities` and `/members` stay bit-identical. Same opt-in discipline as §1's shared-primitive adoptions. Verify **F1** while in `Input.tsx` |
| M9 `[COVER-STORY]` | **ADAPT — cover-story card, tokenised** | Left `CourseCoverPanel` + price sticker + badge on the cover, description-forward 3-line clamp, ONE merged bottom meta line, `min-h` "Option B" density, resting + hover elevation, course icon right of title, CTA docked in the title row. **Built on our palette tokens — no raw hex, no gradient** (his `#0e3a5c`/`#0b2740`/`rgba(18,179,168)`/`rgba(88,77,244)` are not adopted). Gated to `variant="overlay" + context="catalog"` so `RecommendedCourses` and community Courses tabs are untouched |
| M10 `[COVER-STORY-MIRROR]` | **ADAPT — share the cover panel only** | Both surfaces render the same `CourseCoverPanel`, so cover art + price sticker are identical; our Conv-413 `[HERO-COLLAPSE]` hero keeps its slim band, compaction and `@container` reflow. The client's "make the detail page look exactly like the listing" is honoured at the cover, not by cloning the card |
| M11 `[CARD-COMM-BAND]` | **ADOPT** | Reuse the `CommunityBand` primitive built Conv 410 (§1 `[COMM-BAND]`); whole strip links to the community page |

**Batch D — journey, chips, formats (decided Conv 425):**

| # | Disposition | Build note |
|---|---|---|
| M12 `[CARD-JOURNEY]` | **ADAPT — badge + progress, no CTA change** | ✓ Enrolled / ✓ Completed cover badge + own-progress meta line for enrolled viewers; **CTA logic untouched**. Rationale: his card CTA is derived from the client snapshot (`{status, modulesCompleted, modulesTotal}`) only, while our `buildCoursePrimaryCta` (`_course-tabs.ts:255`, pure) resolves an upcoming session to `Go to Session N → /session/[id]` **before** offering booking — so his version would read "Book next session" on the catalog and "Go to Session 3" on the detail for the same course. Giving the card the real next step needs per-course journey state in the catalog loader (N-per-course SSR). 🔴 Progress wording must say **diploma**, never "Certificate earned" (`[DIPLOMA]`); his completed-CTA ("Teach this course" → `/become-a-teacher`) also diverges from ours ("Review your sessions") and is not adopted |
| M13 `[CHIP-LINK]` | **ADAPT — link tone, persistent underline** | `IconLabelChip` gains `tone="link"` (brand blue); the affordance uses the **persistent** underline standardised by `[STEP-LINK]` (Conv 415), not his hover-only `group-hover:underline` |
| M14 `[PRICE-FMT]` | **ADAPT — fix the shared helper** | Add `minimumFractionDigits: 0` to `formatPrice` (`lib/db/types.ts`) so all 11 call sites agree with `CourseHeader.tsx:157`. Closes **F2**. Only whole-dollar amounts change (`$19.99` is unaffected — it's a *minimum*) |
| M15 `[ENROLL-NOW]` | **ADOPT** | Catalog CTA label "Enroll" → "Enroll Now", matching the detail hero's own `$249 • Enroll Now` |

### Build log — §2 Tier A + B (Conv 425, all 5 gates green + live-verified)

**Tier A — page shell** (`src/pages/courses.astro`): `ListingShell` replaced by Home's two-column
geometry (M1) — measured live at **640px column anchored left (x=437) + 284px panel at x=1101** on a
1600px viewport; the `[LAYOUT-MODE]` `isRail` branch and its duplicate filter island are gone, so the
page no longer varies by `navLayout`. The light-blue "More coming soon" panel is **kept and extended
here** (M16 — his site-wide deletion not adopted). Visible hero removed, `h1` now `sr-only` (M2 —
measured 1px tall), toolbar leads the column, nudge + carousel below it. Catalog CTA → "Enroll Now" (M15).

**Tier B — toolbar** (`CoursesFilters.tsx` rewritten, `form/Input.tsx`, `form/Select.tsx`,
`layout/StickyListingToolbar.astro`): topic pill row with sticky "All", drag-scroll and flanking
arrows (M5) — **Level, Length and our `availableSoon` [CAF] filter all kept reachable** behind the
Filters toggle, where his version hard-coded `level`/`duration` to `null` and had no `availableSoon`
at all. Pills are flat and token-only (M6): selected = `bg-primary-light` + `text-primary-default`,
zero raw hex. Sort stays a labelled compact `Select` (M7). `compact` props added to `Input`/`Select`
and a `dense` prop to `StickyListingToolbar` — **all opt-in** (M8): `/communities` verified still on
the default bar with its 20px riser. The icon set has no `chevron-left`, so the arrows mirror
`chevron-right` with `rotate-180` rather than adding a near-duplicate asset.

**🔴 Finding F1 CONFIRMED and FIXED — a pre-existing site-wide defect, not his mechanism.** Measured
live on `/courses`: the inner `<input>` carried **its own 1px border (the forms-plugin grey) plus
8px/12px padding** inside `Input`'s wrapper border+padding, rendering a hard-cornered box nested in
the rounded pill; `Select` had the padding half of the same bug (Conv 223 `[DRV-C]` stripped its
border but not its `8px 40px 8px 12px` padding). This also **blocked M8's intent** — the `compact`
wrapper measured **49px** where ~34px was intended. Fixed as the twin of `[DRV-C]`
(`appearance-none border-0 p-0 focus:ring-0`). After: search **49→34px**, sort **44→34px**, Filters
button aligned to 34px via `py-8`, toolbar **94→79px**; the default (non-compact) variant is now a
consistent **46px for both primitives**, which previously disagreed (59 vs 56). `/login` re-verified
visually — clean single-bordered fields.

**Live verification** (`localhost:4321`, dev seed, signed in as `amanda.lee@example.com`): topic pill
filters the catalog **6 → 2 courses** with the chip and "Clear filters" appearing; "All" resets to
null; role tabs render (`All 6` · `As Student 1`) confirming M3's keep — signed **out** they are
correctly absent because `RoleTabBar.tsx:92` returns null at ≤1 tab; the "Popular Courses" carousel is
retained (M4). Arrow handler verified to fire with the exact expected step (454.4 ≈ `clientWidth×0.8`)
and to scroll the row to 454.5 when the animation is not suppressed.

**⚠️ Residual verification gap:** the arrows' **smooth animation** and their **enabled/disabled
toggle** could not be confirmed — Chrome suppresses programmatic smooth scrolling and throttles
re-renders in a tab whose `visibilityState` is `hidden`, and the bridge tab could not be foregrounded.
The handler logic and scroll math are verified; the animation needs a foreground eyeball.
→ ✅ **Gap CLOSED later the same conv** once the browser window was moved back on-screen — the cause
was `[BRIDGE-OFFSCREEN-WINDOW]`, not a harness limitation. See the Tier C build log.

**Tests:** new `tests/components/courses/CoursesFilters.test.tsx` (8 tests) pins M5's contract claim —
that the published `FilterState` keeps every field rather than nulling `level`/`duration` — plus the
pill semantics, Level/Length reachability, the visible sort, and role-tab collapse. Suite
**6131 → 6139** (396 files). 5 gates green: tsc · astro check 0 errors · lint 0 errors · 6139 tests ·
build complete. Tailwind check's 3 `outline-none` hits are the pre-existing `[OUTLINE-V4B]` sites in
files this build never touched.

**Not built (Tier C, next):** M9 cover-story card · M10 shared `CourseCoverPanel` on the hero ·
M11 community band on cards · M12 badge + progress · M13 link chips · M14 the `formatPrice` fix that
closes F2 (the catalog still shows `$249.00` against the detail hero's `$249`).

### Build log — §2 Tier C (Conv 425, all 5 gates green + live-verified) — M10 OPEN

**Two inventory premises were wrong and were corrected before building** (both would have made the
work look cheaper than it is):

- **M11 was NOT "reuse a primitive we already built".** Conv 410's `[COMM-BAND]` landed as **inline
  markup inside `CourseHeader`**, and the community join lives only in the course **detail** loader.
  Real work: extract `entity/CommunityAffiliation.tsx` (tone `default` | `on-dark`, `raised` for hosts
  with a stretched card link) and add the chain to the **browse** loader.
- **M14's blast radius was 4 files, not 11.** Six of the eleven `formatPrice` matches are **local
  shadow definitions** (`CoursesAdmin`, `CourseDetailContent`, `CourseCard`, `CourseEditor`,
  `CreatorStudio`, `ProgressionCard`) that never imported the shared helper — which is why the admin
  test asserting `$199.00` still passes. Real consumers: `RecommendedCourses`, `CoursesCatalog`,
  `EnrollButton`, `receipt/[id].astro`.

**Built:** `CourseCoverPanel.tsx` (new, shared) — cover art + white price sticker + badge slot, sized
by container query (120px banner → 180px panel at `@xl`); **tokenised**, his navy/teal/violet gradient
replaced by a `neutral-700` placeholder (M9). `CourseCatalogCard` gains a **third named variant,
`cover-story`** rather than his `overlay + catalog` overloading, so `RecommendedCourses` keeps exactly
what "overlay" has always meant: cover left, description-forward body (3-line clamp, `tagline`
fallback), one merged meta line, `min-h-190`, CTA docked in the title row (M9). Community affiliation
footer (M11). `IconLabelChip` gains `tone="link"` with a **persistent** underline per Conv 415
`[STEP-LINK]`, not his hover-only version (M13). `formatPrice` drops forced decimals (M14) — with a
deliberate carve-out: **`formatPriceExact` added for the receipt page**, because a financial document
stating an amount charged should keep its cents.

**M12 built as dispositioned — markers, not a CTA.** ✓ Enrolled / ✓ Completed badge on the cover and
the viewer's own progress replacing students · level; the CTA is left exactly as the host passed it.
Live-verified on `amanda.lee`: **"✓ Completed" · "2 of 2 sessions · Diploma earned"**, and the string
"Certificate earned" appears nowhere on the page (`[DIPLOMA]`).

**Live verification** (`localhost:4321`, signed in as `amanda.lee@example.com`): 6 cover-story cards at
640×193 with a 180px cover panel; price sticker reads **`$249`** where it read `$249.00` before, closing
**F2**; description clamped to 3 lines; creator + rating chips both linked, brand blue `rgb(7,119,182)`,
`text-decoration: underline` at rest; affiliation reads "part of AI for You · 156 members". The course
**detail** hero re-verified after the extraction: still **198px** (the Conv-413 compaction, unchanged),
affiliation now rendered by the shared component in white, linking to `/community/ai-for-you`.

**Tests:** `tests/components/courses/CourseCatalogCard.test.tsx` (new, 12) pins the three deliberate
divergences from his branch — no invented journey CTA, "Diploma" not "Certificate", persistent
underline — plus that `stacked`/`overlay` are unaffected. `tests/ssr/courses.test.ts` +2 for the
loader's `description` and the LEFT-JOIN community chain (including that a course outside a
progression still loads with `community: null`). Suite **6139 → 6153** (397 files). 5 gates green.

**M10 — surfaced as under-specified, then narrowed and BUILT (Conv 425).** "Share the cover panel, keep
our hero" is unbuildable as literally stated: our hero renders the course art as a **full-bleed dark
backdrop with white text over a scrim**, so there is no cover panel to share, and giving it one leaves
the band's white text on nothing — the hero becomes the card, the option the walk declined. Rather than
guess, the choice went back to the user, who picked **price sticker only**.

Built as `CoursePriceSticker.tsx` — extracted from `CourseCoverPanel` so "the same sticker" stays true
by construction rather than by maintenance. The hero renders it top-right (**measured top:12 right:12
from the hero's corner — the same offsets as on the card**), gated on `!isEnrolled` (once you own the
course the price is history and the CTA becomes "Continue learning"). The hero CTA dropped its embedded
price accordingly: `$249 • Enroll Now` → **`Enroll Now`**, so the price appears exactly once per hero
(verified: one `$249` on the page) and both surfaces read the same way. Hero height unchanged at
**198px**. +2 tests.

**⚠️ The Tier-B verification gap is now CLOSED.** With the window on-screen (`visibilityState:
"visible"`) the pill arrows verify fully: smooth scroll moves the row 0 → 455, the left arrow enables
once scrolled, the right arrow disables exactly at `scrollLeft === maxScroll` (1538), and the sticky
"All" pill holds at offset 0 while the row scrolls beneath it.

**🔴 Both earlier "failures" were the same harness artifact.** The unverifiable smooth scroll AND a
price sticker that screenshotted as solid black while its DOM was provably correct (56×22, white,
topmost on `elementFromPoint`) were both caused by the Chrome window being extended past the right edge
of the display — user-diagnosed. A loud-mutation test (force `background:red`) proved the element
painted. Recorded as `[BRIDGE-OFFSCREEN-WINDOW]` in
`memory/reference_playwright_headless_browser_fallback.md`: before concluding "doesn't render", check
`visibilityState` and whether the element's rect lies beyond `innerWidth`.

### Post-build self-audit (Conv 425) — asked "anything outstanding on /courses?"

Checked rather than recalled, and two of the findings were **self-inflicted by this conv's work**:

- **`prov:sweep` had gone 11 → 17 issues** (10 → 13 errors), all three new errors being the components
  built above, each stamping `data-prov-name` with no `matt-inspired-registry.ts` entry — exactly the
  drift `[PROV-SWEEP-DEBT2]` warns about. **Registered; gate back to its 11-issue baseline.**
- **The `cover-story` switch stranded code.** With `/courses` moved off `stacked + context="catalog"`,
  the only two call sites left were `RecommendedCourses` (`overlay`) and `CoursesCatalog`
  (`cover-story`) — so every `isCatalog` branch and the `sessionCount` / `durationLabel` /
  `creatorAvatarUrl` props feeding them became unreachable **while tsc, lint and 6155 tests stayed
  green** ([ORPHAN-DETECT] in miniature). **Removed** — along with the `context` prop, the
  `CourseCardContext` type and the `UserAvatar` import. Verified inert live: 6 cards, 6 stickers, 6
  affiliations, identical geometry either side of the change.

Still outstanding on `/courses`, all pre-existing or gated:

| Item | Status |
|---|---|
| M3 role tabs | gated on `[ROLE-CRS-LIST]` (M4 ✅ BUILT Conv 427 — `[REC-REHOME]` discharged) |
| `[OVERLAY-ORPHAN]` | NEW Conv 427 — `variant="overlay"` now has **zero** production call sites on `CourseCatalogCard` **and** `CommunityCatalogCard`; the two deleted reco carousels were its only hosts. Keep-or-delete decision (not a unilateral sweep — the variant is coherent, named and tested, unlike the Conv-425 `context` strand); a pointer NOTE sits in both component headers |
| `[COURSES-FIXES]` | holds the Conv-292 sweep deferrals `[FILTERS-RESPONSIVE]` + `[TYPO-REVIEW]`. This conv's compact toolbar plausibly overlaps the first; **not verified, so not claimed** |
| `[TSLASH]` | names `/courses/` as a duplicate-content risk (site-wide task) |
| Narrow widths | ✅ **DONE (Conv 425)** — swept 320/375/640/768/1024/1280 via the iframe harness; two defects found and fixed. See below |

`/courses` itself remains ☑ Swept (Conv 292) in the route-migration ledger; F1 and F2 are both closed.

### Narrow-width sweep (Conv 425) — `[VPHARNESS]` iframe harness

Swept **320 / 375 / 640 / 768 / 1024 / 1280** in an exact-size same-origin iframe (media queries key off
the iframe, not the window — `resize_window` cannot set width, `[BRIDGE-RESIZE]`).

**Clean:** zero horizontal overflow at every width including 320 (`scrollWidth === innerWidth`, no
offenders). The cover reflows correctly — 341×120 stacked banner at 375, 180px side panel once the card
clears `@xl`. The blue panel is properly `lg`-gated (`display:none` at 1024, 284px at 1280), confirming
`lg` > 1024 as `StickyListingToolbar`'s own comment states.

**Two defects found and FIXED:**

- 🔴 **Card title cramped at 375.** One-row title+icon+CTA left the title **128px over 2 lines** beside
  a 125px button. Fixed by stacking below `@xl` — **explicitly** (`flex-col … @xl:flex-row`), not via
  `flex-wrap`, because flex items shrink before they wrap so the h3 would still have been squeezed.
  After: title **174px on 1 line**, CTA on its own row. Card grows 333→365px at 375; desktop untouched
  (193px, single row, verified at 640 + 1280). The client branch reached the same conclusion for its own
  narrow column ("CourseMiniHeader: CTA wraps to its own row in the narrow feed column").
- 🟠 **Sticky toolbar ate 36% of a phone.** At 375×760 it pinned **174px**; with the 48px header + 48px
  bottom nav that was **270px of chrome**, permanently over the catalog. Fixed by hiding the topic pill
  row below `sm` (it was 28px of the 174) and putting a **Topic select inside the Filters collapse**
  for phones, so topic filtering is moved rather than stranded — both controls write the same `topic`
  state. After: toolbar **138px**, chrome 234px (**31%**), catalog 526px. Live-verified at 375 that the
  select is visible (pill row `display:none`), publishes a real topic id, and that "Clear filters"
  restores all 6 courses. +2 tests pin the responsive intent so neither half can be deleted alone.

**Bonus — a `[MINWIDTH-320]` blocker appears cleared.** That parked task lists three 320px overflow
sites, one being `CoursesFilters.tsx` filter rows. At 320 the rewritten bar overflows by **0px** (the
`flex-wrap` + `min-w-[160px] flex-1` search and `overflow-x-auto` pill row). `MembersFilters` and the
Home feed-card button are untouched and unverified, so the task stays parked at 2 of 3.

**✅ Pre-existing copy defect — FIXED (Conv 425, user-requested).** The "all"-tab empty state branched on
`q` and `availableSoon` only, so narrowing by **topic / level / length** to zero results said *"No courses
available right now."* — claiming the platform was empty when the reader's own filter was to blame, and
giving them no reason to touch the filters. Pre-existing: the block sits at the merge-base `c50afd82`
with only the `q` branch.

The fix keys off a small invariant rather than guessing: with no filters applied `allVisible` is just
`courses` re-sorted, so **`courses.length === 0` is the only genuine "nothing published" case** — an
empty result over a non-empty catalog is always the filters' doing. Precedence: platform-empty truth
first, then the multi-filter message, then the two single-filter messages worth keeping (search is
precise because the reader knows what they typed; `availableSoon` explains a time-window concept that
"filters" would obscure). A query **plus** an attribute filter now yields the filter message — the old
search-only copy would have been misleading, since clearing the search still left the topic excluding
everything.

Live-verified: selecting the "Machine Learning" topic (no courses in the dev seed) reads *"No courses
match your filters — try removing one."*; search-only still reads *"No courses match your search."*;
clearing restores 6. The advice is actionable without naming a position — a removable chip and "Clear
filters" are on screen in every filtered-empty case (confirmed). New
`tests/components/courses/CoursesCatalog.test.tsx` (8 tests) pins all four branches plus the
combination case. Suite **6157 → 6165**.

**🟠 Same defect class, different trigger, NOT fixed:** the four role-tab empty states branch on `q` but
ignore their own **`sub`-filter**, so a student on `sub=completed` with only in-progress enrolments is
told *"You haven't enrolled in any courses yet."* — denying enrolments that exist. Those tabs are
dispositioned for retirement once `[ROLE-CRS-LIST]` lands, which is why it was left rather than folded
in. Tracked in `[COURSES-FIXES]`.

### §2 walk result (Conv 425)

**16 mechanisms · 3 ADOPT · 12 ADAPT · 1 DROP.** Two ADAPTs are **gated on prerequisites** and are not
buildable yet: M3 (`[ROLE-CRS-LIST]`) and M4 (`[REC-REHOME]`). The other **14 are buildable now**. (M4 was
subsequently built in Conv 427 once `[REC-REHOME]` resolved; only M3 remains.)

Build tiers (mirrors §1's A/B/C staging) — **all three shipped the same conv**; see the two build logs above:

- **Tier A — page shell:** M1 640-left geometry · M16 panel extended to `/courses` · M2 search-first · M15 label
- **Tier B — toolbar:** M5 topic pills + retained Level/Length · M6 tokenised pill treatment · M7 visible compact sort · M8 opt-in `compact`/`dense` props (**verify F1 while in `Input.tsx`**)
- **Tier C — card:** M9 cover-story card (tokenised) · M11 community band · M12 badge + progress · M13 link chips · M10 shared `CourseCoverPanel` on the hero · M14 `formatPrice` fix

The two DROP-adjacent notes worth keeping: his site-wide `[PANEL-REMOVE]` is **not** adopted (M16), and
his `[SORT-IN-SEARCH]` chevron is **not** adopted (M7) — both are revisitable if the client raises them.

## 3 · Communities review

**Scope (Conv 426).** 20 files at the pivot land on this unit: the detail page
(`community/[slug]/[...tab].astro`, `_community-tabs.ts`), the catalog
(`communities.astro`, `CommunitiesCatalog`, `CommunitiesFilters`, `CommunitiesRoleTabs`,
`CommunityCatalogCard`), two new entity components (`CommunityMiniHeader`, `CommunityBand`),
the loader (`ssr/loaders/communities.ts`), the branding lib + migration
(`lib/community-branding.ts`, `0005_community_branding.sql`), four API surfaces
(`api/me/communities/[slug].ts` PATCH validator, `index.ts`, `[slug]/logo.ts` **new**,
`api/recommendations/communities.ts`), `RecommendedCommunities`, `CommunityManagement`,
`CommunitySettings`, and `creating/communities/[slug].astro`.

**Overlap census:** **5 files changed on both branches** — `CommunitiesRoleTabs.tsx`,
`CommunityManagement.tsx`, `RecommendedCommunities.tsx`, `ssr/loaders/communities.ts`,
`community/[slug]/[...tab].astro`. Everything else is his-only. Our own changes to those five are
small and mechanical (Conv-423 spacing migration, `size-icon-*` sweep, a `deleted_at` guard), so
reimplementation reconciles cleanly.

**Already decided elsewhere — no new disposition needed:**
- **`CommunityBand.tsx`** (the course-side "Part of X community" strip) → §1 M10, **ADAPT logo +
  affiliation only**, shipped as `CommunityAffiliation.tsx` (Conv 425). His full-width tinted strip
  and the 48px medallion were not adopted.
- **`accent_color` + the 10-swatch palette + the settings picker + the PATCH validator** → §1 M10,
  **DROP**. Confirmed again here: the picker is commented out in his own `CommunitySettings`, the
  stripe is `void accentColor` in `CommunityCatalogCard`, and `CommunityBand` hardcodes
  `const accent = null`. Dead on his branch, at the client's own request.
- **`BackHeader` on the community page** → §1 `[BACK-X]`, **DROP (soft, revisitable)**.

### Mechanism inventory (dispositions DONE — Conv 426)

| # | Mechanism | Ripple | Token/colour | Notes |
|---|---|---|---|---|
| N1 | `[COMM-HDR]` `CommunityMiniHeader` replaces the `Card` hero: cover art as full background + left-heavy scrim, 56px white-ringed logo mark, byline `by X · Public · N members · N posts`, CTAs (Manage/Leave/Join) move into the band, description dropped (the About tab already shows it verbatim), view-transition freeze + slug-scoped persist | community cluster; new entity component | 🔴 raw hex — scrim `rgba(8,25,40,…)`, fallback gradient `#0e3a5c`/`#0b2740`, byline `#d7e6ef`, on-dark link `#7cc4ec` | direct analog of §1 M1 `[HDR-ABOVE-TABS]` (**ADAPTed**: took the density, left the scrim + raw hex, kept price/art) |
| N2 | `[COMM-BACK]` `BackHeader` on the community detail route | shared shell | clean | **already DROPped** (§1 `[BACK-X]`, soft) |
| N3 | `[COMM-FEED-LABEL]` tab label `Course Feed` → `Community Feed` (page + `_community-tabs.ts`) | none | n/a | ours calls the *community* feed tab "Course Feed" — a plain mislabel |
| N4 | `[COMM-CRS-CARD]` the Courses tab renders the **full `CourseCatalogCard`** instead of the bespoke mini-row, plus a viewer-enrollment query driving CTA + journey mode; community band suppressed (would point at the community you're in); `?via=community-courses` attribution kept via `href` override | 🔴 collides with §2 M9 (we made a **named** `cover-story` variant instead of his `overlay + catalog` overloading) and §2 M12 (**we declined the card CTA change**) | inherits the card's tokens | +1 SSR query per page load; his local `coursePriceLabel` duplicates the `formatPrice` fix already landed in §2 M14 |
| N5 | `[COMM-JOIN-REBIND]` Join/Leave wiring moved off module top-level into a `wireMembershipButtons()` re-run on `astro:page-load`, `data-wired` double-bind guard, plus a Leave **self-heal** — a `Not a member` 400 lands where success lands instead of alerting | community detail only | n/a | **bug fix — see finding F4** |
| N6 | `[COMM-LAYOUT]` `/communities` adopts the 640px left-anchored two-column geometry; drops `ListingShell` and the rail/top `navLayout` variance (filters always `orientation="top"`) | `ListingShell` keeps its other consumers | clean | exact twin of §2 M1 (**ADAPTed**) |
| N7 | `[COMM-SEARCH-FIRST]` visible "Browse Communities" header + description removed (`sr-only h1` kept); toolbar leads; nudge banner moves below it | none | clean | exact twin of §2 M2 (**ADOPTed**) |
| N8 | `[COMM-REC-OFF]` `RecommendedCommunities` carousel removed from the page | 🔴 `/communities` is its only consumer — same shape as §2 M4 | n/a | twin of §2 M4, which is **gated on `[REC-REHOME]`** |
| N9 | `[COMM-PILLS]` role tabs move off the shared `RoleTabBar` onto floating pills with count badges | 🔴 **drops the Matt-§5 role palette** (member/teaching → student/teacher blue, created → creator purple, moderating → neutral) — his docstring states this explicitly | 🔴 raw `#2a93d5`, `#dfe6ee`, `rgba(7,119,182,…)`, `rgba(16,42,67,…)` + gradient capsule | twin of §2 M6 (**ADAPTed flat + tokenised**) **plus** a role-colour loss §2 never faced — role theming is a client-flagged watch area (ground rule 3) |
| N10 | `[COMM-SORT-IN-SEARCH]` sort docked inside the search box as a chevron-only slot over an invisible native `<select>` | none | clean | exact twin of §2 M7 (**not adopted** — sort stays a visible labelled `Select`) |
| N11 | `[COMM-HERO-CARD]` third `hero` variant on `CommunityCatalogCard`: 180px cover panel left (120px banner below `@xl`), Public/Private badge top-left, 56px white-ringed logo bottom-left, `min-h-190`, 3-line description, "Led by" + aggregate-rating link chips, merged members·posts meta line, and a **courses footer band** ("N courses in this community · taught by N peer teachers") | card is shared with `RecommendedCommunities` (gated by variant) | 🔴 footer band raw `#e3f1fc` / `#d3e7f8`, shadow `rgba` stacks | twin of §2 M9 (**ADAPTed, tokenised, as a named variant**); needs N16's loader aggregates |
| N12 | `[COMM-LOGO-CARDS]` logo mark rendered in all three card variants (hero 56px ringed, overlay 40px, stacked 20px) | additive | clean | our `logo_url` column exists but **no community-side surface renders it** |
| N13 | `[COMM-LOGO-UPLOAD]` `POST`/`DELETE /api/me/communities/[slug]/logo` (owner-gated, type + 2MB validated, R2, old-logo cleanup, instant-persist) + the `CommunitySettings` upload/remove UI | new API + settings UI | clean | **the missing half of our own §1 M10 adoption** — we shipped the column with no way to set it |
| N14 | `[COMM-STORAGE-ROUTE]` `GET /api/storage/[...key]` — public R2 asset server with a **prefix allowlist** (`courses/*/thumbnail/`, `communities/*/logo/`), 404 for everything else so private objects stay behind their auth-gated endpoints | 🔴 site-wide storage surface | n/a | **fixes finding F3 on our branch**; his docstring: *"the upload endpoints have always generated `/api/storage/{key}` URLs, but no route served them until now"* |
| N15 | `[COMM-ACCENT]` `accent_color` column + `community-branding.ts` palette + picker + PATCH validator | — | — | **already DROPped** (§1 M10) |
| N16 | `[COMM-LIST-AGG]` loader aggregates per community — `courseCount`, `teacherCount` (distinct active certified teachers), and a **review-count-weighted** average rating + total review count, via two `LEFT JOIN` subqueries; plus `creator` on `CommunityProgressionCourse` | list loader (2 extra subqueries) | n/a | prerequisite for N11's chips + footer band and N4's card |

### Findings surfaced while building the inventory (Conv 426)

- **F3 — course thumbnail uploads produce dead URLs on our branch (CONFIRMED in code, pre-existing,
  nothing to do with communities).** `api/me/courses/[id]/thumbnail.ts:131` stores
  `thumbnail_url = /api/storage/${key}`, and **no `/api/storage/` route exists on our branch** (no
  `src/pages/api/storage/` directory; the only producer of that path is the thumbnail endpoint
  itself). So a creator who uploads a course thumbnail through Creator Studio (`CourseEditor.tsx`)
  gets a URL that 404s everywhere a thumbnail renders — catalog cards, hero, recommendations,
  community Courses tab, admin. **Masked in dev**: the seed uses external `picsum.photos` URLs, so
  the broken path is never exercised. N14 is the fix. Tracked as `[THUMB-404]`.
- **F4 — community Join/Leave is probably dead on client-side navigation (plausible from code,
  needs live verification).** Our page binds both buttons at module top level. `ClientRouter` is
  active (`AppLayout.astro:169`), and Astro executes a given module script **once per document** —
  so arriving at a *second* community via a client-side navigation (e.g. from a `/communities`
  card) leaves the new page's Join/Leave unbound. This is exactly the bug his comment describes
  (*"clicked Join, feed still said join to participate"*) and N5 fixes. **Verify live before calling
  it a defect** — same discipline as §2's F1.
- **F5 — two sizes on the community page render 4× their apparent intent.** The identity square is
  `min-[480px]:w-224 h-224` (**224px**) beside a `w-[96px]` mobile value, and the Courses-tab
  thumbnail is `w-320 h-224` (**320×224**) for what reads as a list-row thumb. Both came from the
  Conv-423 spacing-base fix (`dc1f031e`), which correctly rewrote `w-56`→`w-224` and `w-80 h-56`→
  `w-320 h-224` to **preserve the rendered size** — pre-fix, `w-56` resolved through Tailwind's stock
  `0.25rem` base to 14rem = 224px. So the migration is faithful; what it preserved was a pre-existing
  4× artifact (the `[DEMO-HOME]` class). Brian independently spotted the header one — his
  `CommunityMiniHeader` docstring calls out *"its w-56 hit the rem fallback and rendered 224px"*.
  N1 supersedes the header instance; the Courses-tab thumbnail is superseded by N4. If both are
  declined, these need their own fix.

### Dispositions

✅ **Walk COMPLETE (Conv 426).** All 16 decided — Batch A (10) + Batch B (4), with N2/N15 carrying
prior decisions from §1.

**Batch A — catalog twins, role colours, hero, upload (decided Conv 426):**

| # | Disposition | Build note |
|---|---|---|
| N3 `[COMM-FEED-LABEL]` | **ADOPT** | `Course Feed` → `Community Feed` in `_community-tabs.ts` **and** the page's `TAB_LABELS`. A plain mislabel on the community feed tab — his fix is simply right |
| N6 `[COMM-LAYOUT]` | **ADAPT — per §2 M1** | Take Home's 640px left-anchored two-column geometry; filters always `orientation="top"`, so the page stops varying by `navLayout`. ⚠️ `ListingShell` loses a consumer here — after this it keeps **`index` + `members`** only; leave it in place for them (do not delete) |
| N7 `[COMM-SEARCH-FIRST]` | **ADOPT — per §2 M2** | Visible "Browse Communities" header + description out, `sr-only h1` in, toolbar first, onboarding nudge below it |
| N9 `[COMM-PILLS]` | **ADAPT — pill geometry, role colours KEPT** | Take the compact floating-pill treatment with count badges, **flat and tokenised** (his `#2a93d5`/`#dfe6ee`/`rgba` stacks + gradient capsule are not adopted, same call as §2 M6). 🔴 **Diverges from his build on the substance:** he drops the Matt-§5 role palette (member/teaching → student/teacher blue, created → creator purple, moderating → neutral) because "the courses pill row has none". Role-based colour theming is a client-flagged watch area (ground rule 3), so the palette is retained here. Consequence to settle at build time: whether `RoleTabBar` gains a pill variant, or the role colours move into the pill styling directly — the shared primitive has other consumers |
| N10 `[COMM-SORT-IN-SEARCH]` | **ADAPT — visible compact control, per §2 M7** | Sort stays a labelled compact `Select` in the toolbar. The chevron-in-search slot over an invisible native `<select>` is not adopted — the label disappears, which is a discoverability trade rather than a space saving |
| N11 `[COMM-HERO-CARD]` | **ADAPT — tokenised, named variant, per §2 M9** | Cover panel left + Public/Private badge + logo mark + `min-h`, 3-line description, "Led by" / aggregate-rating link chips (persistent underline per `[STEP-LINK]`), merged members·posts meta line, and the courses footer band. **Built on palette tokens** — his `#e3f1fc`/`#d3e7f8` band and `rgba` shadow stacks are not adopted. Added as a **named third variant** (as `cover-story` was on `CourseCatalogCard`), not by overloading `stacked`, so `RecommendedCommunities` is untouched. Depends on N16 |
| N12 `[COMM-LOGO-CARDS]` | **ADAPT** | Render the logo mark across the card variants — closing the gap that our `logo_url` column has **no community-side surface** today. Sizing per variant, using the rounded-mark convention already in `CommunityAffiliation`; his white-ringed medallion treatment stays behind (same call as §1 M10). Exact hero-panel mark size is a build-time call |
| N1 `[COMM-HDR]` | **ADAPT — per §1 M1** | Take the compaction, the logo mark, and the denser byline (`by X · Public · N members · N posts`); drop the duplicated description (the About tab renders it verbatim). **Leave behind** the raw-hex scrim + fallback gradient, the on-dark `#7cc4ec` link, and any `back-header`/`--pin-top` coupling (`[BACK-X]` is dropped, so this band must stand alone — same knock-on as §1 M1). Supersedes **F5**'s 224px identity square |
| N13 `[COMM-LOGO-UPLOAD]` | **ADAPT — sequenced after N14** | Owner-gated `POST`/`DELETE` logo endpoint (type + size validated, R2, old-object cleanup, instant-persist rather than tied to Save/Cancel) + the settings upload/remove UI, reimplemented on our conventions and mirroring our existing course-thumbnail endpoint. **This completes our own §1 M10 adoption** — we shipped `communities.logo_url` with no way for a creator to set it |
| N14 `[COMM-STORAGE-ROUTE]` | **ADAPT — build FIRST** | `GET /api/storage/[...key]`, serving **only** an allowlist of public prefixes (`courses/*/thumbnail/`, `communities/*/logo/`) and 404ing everything else, so private objects (community resources, homework submissions, recordings) stay behind their auth-gated endpoints. **Stands on its own merits — it closes finding F3 / `[THUMB-404]`, a live pre-existing defect unrelated to communities** — so it is built first, ahead of N13 which depends on it |

**Carried from earlier walks (no new decision):** N2 `[COMM-BACK]` → **DROP** (§1 `[BACK-X]`, soft) ·
N15 `[COMM-ACCENT]` → **DROP** (§1 M10).

**Batch B — Courses tab, bug fix, recommendations, loader (decided Conv 426):**

| # | Disposition | Build note |
|---|---|---|
| N4 `[COMM-CRS-CARD]` | **ADAPT — shared card, badge + progress, no CTA change** | Take "one course card everywhere": the Courses tab renders our shared `cover-story` card instead of the bespoke mini-row, keeping the `?via=community-courses` attribution via the `href` override and suppressing the community affiliation (it would point at the community you are already inside). **Keeps §2 M12's call** — enrolled viewers get the ✓ Enrolled / ✓ Completed badge and their own progress; the **CTA is left as the host passes it**. His server-side enrollment query is better data than the catalog's client snapshot, but it still carries only `status` + module counts, so a card CTA derived from it would read "Book next session" while the detail page — resolving an upcoming session through `buildCoursePrimaryCta` — reads "Go to Session N" for the same course. The contradiction §2 declined survives the better data source. **Drop his local `coursePriceLabel`** — `formatPrice` already carries `minimumFractionDigits: 0` since §2 M14. Supersedes **F5**'s 320×224 Courses-tab thumbnail |
| N5 `[COMM-JOIN-REBIND]` | **ADAPT — both halves, after verifying F4 live** | Move Join/Leave wiring off module top level into a function re-run on `astro:page-load`, with a `data-wired` guard against double-binding on same-slug tab switches (`transition:persist` keeps the element). Take the **Leave self-heal** too: a `Not a member` 400 means the page's membership state has drifted and the user's goal state is already true, so land where success lands rather than alerting. **Verify first** — reproduce the dead-button case by navigating client-side from a `/communities` card to a second community and clicking Join; the defect is plausible from the code but unmeasured (`[PREMISE]` discipline, same as §2's F1) |
| N8 `[COMM-REC-OFF]` | **ADAPT — hide after rehoming ✅ BUILT (Conv 427)** | Discharged together with §2 M4, exactly as the widened `[REC-REHOME]` intended: one destination decided once for both carousels. `RecommendedCommunities` and `/api/recommendations/communities` are **deleted**; `/communities` keeps a recommendations surface as community lanes in its right rail, off the same global Discovery Rails blob |
| N16 `[COMM-LIST-AGG]` | **ADAPT — all four aggregates** | `courseCount`, `teacherCount` (distinct active certified teachers), and a **review-count-weighted** average rating + total review count, via two `LEFT JOIN` subqueries on the list query, plus `creator` on `CommunityProgressionCourse` (N4 needs it for the card's creator chip). Weighted (`SUM(rating × rating_count) / SUM(rating_count)`) rather than a flat mean, so a 5.0-from-one-review course cannot outweigh a 4.6-from-fifty. Prerequisite for N11 and N4 — build it first among the catalog work |

### Build log — §3 all three tiers (Conv 426, all 5 gates green + live-verified)

**13 of 13 buildable mechanisms shipped**; N8 was gated on `[REC-REHOME]` and shipped in Conv 427 → **14 of 14**.

**Tier A — the defect + storage foundation.**
- **N14** `GET /api/storage/[...key]` built with a two-entry prefix allowlist, traversal rejection,
  ETag/304 revalidation and immutable caching. **Closes `[THUMB-404]` / finding F3.** The security
  property is verified *live, not just by unit test*: with a real object seeded at
  `homework/sub-1/secret.pdf`, the route still 404s — so the allowlist gates **before** R2 is
  consulted and object existence is not observable. An allowlisted key with an object returns 200
  `image/png`, and `If-None-Match` returns 304.
- **N5** Join/Leave wiring moved to `astro:page-load` + a `data-wired` guard, with the Leave
  self-heal. **F4 was confirmed before being fixed**, with a control: as `amanda.lee` on
  `/community/q-system`, a hard load fired `POST /api/communities/q-system/join` and disabled the
  button, while the same button reached client-side (`/communities` → automation-majors →
  `/communities` → q-system) produced **zero requests**. Post-fix the identical route fires the POST;
  three same-slug tab switches then produce exactly one request, so the guard holds. Membership was
  never mutated — the POST was intercepted in-page.

**Tier B — the catalog.** N16 loader aggregates (two grouped subqueries) · N11 `hero` card variant ·
N12 brand marks across all three variants · N6 640px left-anchored geometry · N7 search-first ·
N9 role pills · N10 compact controls · N3 label fix.

**Tier C — detail page + feature completion.** N1 identity band · N4 shared course card · N13 logo
upload endpoint + settings UI.

**Divergences from his build that are now pinned by tests** (not just prose):
- **N9 role palette retained** — `RoleTabBar` gained an opt-in `variant="pill"` rather than a bespoke
  row, so /courses role tabs and dev/primitives are untouched. Live: selecting *Member* renders
  `--Student-Primary` on `--Student-Background` with its role dot. His branch dropped the palette.
- **N4 no invented journey CTA** — live on the Courses tab, the completed course shows **✓ Completed**
  with **no CTA**, while unenrolled courses show "Enroll Now". "Certificate earned" appears nowhere.
- **N11/N9 tokenised** — the courses band computes to `rgb(241,249,255)` (`--Primary-Light`) with a
  `border-default` hairline; zero raw hex and no gradient anywhere in either component.
- **N13 rejects SVG** (his `ALLOWED_TYPES` accepted it) — an SVG is executable and these are served
  same-origin by N14. The upload UI's `accept` matches.
- **N16 visibility filter** — his subqueries filtered only `is_active = 1`; ours matches
  `fetchCommunityProgressionsData`, so a card cannot advertise courses the Courses tab won't list.
  Also weighted-by-review-count rather than a flat mean (a test pins 4.61, not 4.80).

**Live verification** (`localhost:4321`, `amanda.lee` then `guy-rymberg`):
- `/communities`: listing column exactly **640px** anchored left with the panel at x=1035; `h1`
  present and `sr-only`; search leads at y=80; compact search wrapper 34px; sort **visible and
  labelled** with 3 options and no invisible-select trick. Three hero cards at 640×190 rendering real
  aggregates — *"3 courses in this community · taught by 3 peer teachers"*, *"1 course … 2 peer
  teachers"*, and *"2 courses in this community"* (teacher clause correctly omitted at zero).
- `/community/ai-for-you`: the identity band measures **96px** — the block it replaced spent 224px on
  its identity square alone (finding F5) — with the byline reading exactly *"by Guy Rymberg · Public ·
  156 members · 89 posts"*, and the description now appearing **once** on the page instead of twice.
  Tab reads **"Community Feed"**.
- Courses tab: 3 shared `cover-story` cards at 948×190 using the shared `CourseCoverPanel`, community
  affiliation suppressed (it would point at the community you are inside), and the `?via=` attribution
  preserved through the new `href` override. The old 320×224 thumbnail is gone (F5's second instance).
- **N13 + N14 end-to-end**: uploading a PNG as the community's creator returned a
  `/api/storage/communities/…/logo/{ts}.png` URL that N14 then served (200, `image/png`, 70 bytes);
  the same upload against a community he does not own returned **403**; the mark rendered at 40×40 on
  the catalog card (`complete`, no medallion treatment); and the settings editor showed the preview,
  Replace/Remove, `Square PNG, JPG, WebP or GIF. Max 2MB.`, and **no accent picker**.
- Local dev state restored afterwards (seeded `logo_url` reinstated, test R2 objects deleted).

**Gates:** tsc ✅ · `astro check` **0 errors** ✅ · lint **0 errors** (162 warnings, all pre-existing —
`[A11Y]` / `[RHOOKS]`) ✅ · suite **6165 → 6234** (+69 across 5 new files: storage route 18, logo
endpoint 17, community card 16, RoleTabBar 12, loader aggregates 6) ✅ · build ✅. `prov:sweep` unchanged at
the `[PROV-SWEEP-DEBT2]` baseline of 11 — the work added variants to already-stamped components rather
than new ones.

**One environment note worth keeping:** under jsdom, a `File` round-tripped through
`new Request({ body: formData })` → `.formData()` comes back with its bytes collapsed (`size` reads 9
regardless of input), which silently neutered the logo size-cap assertion. The handler only consumes
`request.formData()`, so the test hands it the `FormData` directly.

### §3 walk result (Conv 426)

**16 mechanisms · 2 ADOPT (N3, N7) · 12 ADAPT · 2 DROP (both carried from earlier walks).** One ADAPT
(N8) was **gated** on `[REC-REHOME]`; the other 13 were buildable — **all 13 shipped this conv**, and N8
followed in Conv 427 → **14 of 14**. Three
findings, all closed: **F3 confirmed and fixed by N14** (`[THUMB-404]`), **F4 confirmed live with a
hard-load control, then fixed by N5**, **F5 superseded** by N1 (header square, band now 96px) and N4
(Courses-tab thumbnail).

Build tiers (mirroring §1/§2 staging) — **all three shipped the same conv**; see the build log above:

- **Tier A — the defect + storage foundation:** N14 storage route (closes `[THUMB-404]` on its own
  merits, independent of everything else) · N5 Join/Leave rebinding, after live verification of F4
- **Tier B — the community surfaces:** N16 loader aggregates → N11 hero card variant · N12 logo marks
  · N6 640px geometry · N7 search-first · N9 pills with role colours retained · N10 visible sort · N3
  label fix
- **Tier C — detail page + feature completion:** N1 community identity band · N4 shared course card ·
  N13 logo upload API + settings UI (needs N14)

**Two deliberate divergences from his build to pin in tests**, as §2 did: the role-tab pills **keep**
the Matt role palette (N9), and the Courses-tab card carries **no invented journey CTA** (N4).

### Build log — §2 M3 `[CRS-ROLE-TABS-OFF]` + `[ROLE-CRS-LIST]` (Conv 428, all 5 gates green + live-verified)

The last §2 mechanism, and the second consecutive one where **re-testing the task's own
stated blocker turned a product decision into a small build** (`[REC-REHOME]` was the first).

**The premise test.** `[ROLE-CRS-LIST]` was scoped as "give the teaching and moderating
lenses their own course lists". Checked against consumers rather than the definition
([[feedback_retest_task_premise_before_executing]]):

| Claim | Verdict |
|---|---|
| "`TeacherDashboard` groups students by course but never lists them" | **FALSE** — `TeacherDashboard.tsx:206` renders `TeacherCertifications` = *"My Teaching Certifications"*, one card per course → `/teaching/courses/{id}` (`TeacherCertifications.tsx:20,56`), off the **same** `getTeacherCertifications()` array `CoursesRoleTabs.tsx:41-43` counts the tab from |
| "`/courses#teaching` is the only list of a teacher's courses" | **FALSE** — `/teaching/sessions` (`TeacherSessionsList.tsx:651-670`) also groups by course with a `Course Details →` link |
| the cited `/teaching` route comment | **misread** — "There is no courses LIST page" is about the **route** `/teaching/courses` (which redirects), not about page content |
| "same for `#moderating`" | **HOLDS** — `getModeratedCourseIds()` has 3 consumers (its definition + the 2 role-tab files); `/mod` is a flagged-content queue. **But** it is derived from `community_moderators` (`current-user.ts:576-579`), and `/communities#moderating` already lists those communities — the course view was a second-order flattening of a lens already homed |
| — | **omission:** the disposition never mentioned the **Created** lens M3 also hides. Covered by `/creating/studio` (`CreatorStudio` = "course list with stats") — but by luck, not analysis |

**What was actually lost** if M3 shipped untouched: the tab's title search + All/Active/Paused
sub-filter (`CoursesCatalog.tsx:56-66`) and the Matt-styled `CourseTeachingCard`; `/teaching`'s
list had none of those and a legacy-scale card. That gap — not "no list exists" — was the real
prerequisite, and it is a [DISC-DROP]-shaped regression if ignored.

**Built.** `TeacherCertifications` rewritten: self-sources from `useCurrentUser()` (no new
endpoint — the richer `UserTeacherCertification` was already there), renders the shared
`CourseTeachingCard`, and carries the tab's sub-filter with **identical predicates** plus a
count-gated search (`SEARCH_THRESHOLD = 4`, the `TeachersTabList` Conv-409 precedent). Panel
chrome deliberately left on the legacy scale to match its dashboard siblings —
`[TEACH-ISLAND-RESTYLE]` owns that — so the component stays `data-prov`-unstamped and
`prov:sweep` holds at its 11-issue baseline. Deliberately **no** `useAuthStatus` gate: the
parent island already gates on it, and a second gate would render a skeleton over resolved data.
Then M3: `CoursesRoleTabs` mount + import removed from `courses.astro` (Brian commented his out;
we delete, git is the retention mechanism).

**🔴 Defect found in live verification, fixed same-conv.** With the tab bar gone,
`CoursesCatalog`/`CoursesFilters` still read the URL hash — so `/courses#teaching` rendered the
teaching lens with **no control to leave it** (0 catalog cards, viewer stranded on a stale
bookmark). `readHashTab()` in both islands now always returns `'all'`; all four role hashes
re-verified live to render the full public catalog. This is exactly the dormant-subsystem hazard,
and it is why the leftover branches are tracked rather than left silent → `[CRS-ROLE-DORMANT]`.

**Also fixed:** the `/teaching` availability toggle carried `aria-pressed` with **no accessible
name** — surfaced because the new sub-filter pills made a bare `pressed: true` query ambiguous;
given `aria-label="Toggle teaching availability"`.

**Live-verified** on `:4321` (after an `[DEVSRV-STALE]` teardown — a pre-existing daemon was
serving stale code and 500ing `/teaching`): guy-rymberg (4 certs) → 4 cards with status pill,
creator, taught/rating/teacher chips, filter pills **and** search box; Paused → 0 + *"No courses
match this filter."*; search `n8n` → 1; search `zzzz` → *"No courses match your search."*;
marcus (2 certs) → cards + pills, **no** search box (count gate). `/courses` → no `RoleTabBar`,
6 catalog cards, rails intact; the only "Teaching" strings on the page are sidebar nav links.

5 gates green — suite 6210 → **6215** (+5 tests), lint 0 errors (160 pre-existing warnings,
unchanged), `prov:sweep` at baseline. Follow-ups: `[CRS-ROLE-DORMANT]`, `[CRS-COMM-TABSYM]`
(the `/courses`-vs-`/communities` role-pill asymmetry), `[TDASH-CERTS-DEAD]`.

### Build log — §2 M4 + §3 N8 `[REC-REHOME]` (Conv 427, all 5 gates green + live-verified)

The two gated carousel mechanisms, discharged together by one destination decision. Both were
dispositioned *ADAPT — hide only after rehoming*, because `/courses` was the sole consumer of
`RecommendedCourses` and `/communities` the sole consumer of `RecommendedCommunities`, each carousel
the sole caller of its `/api/recommendations/*` endpoint. Hiding either would have retired a surface
site-wide and stranded an endpoint.

**Four findings reframed the decision before any code was written:**

1. **`/feeds` does not exist.** `memory/project_feeds_hub.md` called it "the Discover destination", but
   there is no `src/pages/feeds.astro` and zero `href="/feeds"` in `src/`. Memory corrected.
2. **A new `/discover` hub would contradict DISC-DROP** (Conv 204) — `/discover` was dropped entirely and
   folded into `/courses`.
3. **Home already does this job, and better.** `SmartFeed` renders rails-backed `suggestion-card`s
   (reason badge, CTA, and a dismiss that *trains* future feeds). Home was never "barred" by `[FEEDS]`
   so much as already occupied — and `[FEEDS]`'s bar names FeedsHub / ActionCards / TriageStrip in the
   **feed column**, which says nothing about the Conv-298 right rail.
4. **The work already had an owner.** `src/lib/discovery-rails/types.ts` names the reco bands as its
   intended consumer, and `plan/home-feed-merge/README.md` **#34 `[RECO-UNIFY]`** scopes exactly this
   refactor. `[REC-REHOME]` was written in the §2/§3 walks without noticing it.

**User decision:** rails-backed lanes in the existing right rail — the executable cut of `[RECO-UNIFY]`
#34 minus the Promoted / Peerloop Picks lanes (those need `[PROMOTE-PIPELINE]` Steps 4–7).

**Built:** `DiscoveryRails` (island) + `DiscoveryRailCard` (compact row) + `lib/discovery-rails/lanes.ts`
(pure builder), mounted in the right rail of `/courses` (course lanes), `/communities` (community lanes)
and `/` (both, `maxItems=3`). **Deleted:** both carousels, both `/api/recommendations/*` endpoints, and
their 4 test files.

**Decisions worth keeping:**

- **Not a fourth `CourseCatalogCard` variant.** `RailEntity` carries no price, rating, level or creator,
  so a `variant="rail"` would have meant making four required props optional and threading an "absent"
  state through three existing variants — the exact stranding pattern that card's own header documents
  from Conv 425. One card, one data shape, serving both entity types because the payload does.
- **Personalization costs zero requests.** `CurrentUser` already carries `interestTopicIds` (from
  `/api/me/full`), so the lens needs no fetch. The island gates on the `useAuthStatus()` three-state, not
  `useCurrentUser()` truthiness — treating the pre-hydration moment as "visitor" is the same bootstrap
  race as M1 `[MSGBOOT]` and `[COURSETAB-HASH]`, and here it would cost a member their For You lane on
  every cold load.
- **An entity appears in at most one lane.** Claimed in order (For You → Trending → New → Popular). In a
  284px rail the same course repeating down the column reads as a bug. For You is capped like every other
  lane so it cannot swallow the set. Pinned by tests and verified live.
- **The blue placeholder survives as the island's empty-state fallback**, passed as Astro island children.
  His pivot deleted the panel site-wide (§2 M16) and that removal is still not adopted; the honest-orphan
  blue now appears exactly when there is genuinely nothing to recommend.
- **Sticky-height cap added** (`max-h-[calc(100vh-48px)] overflow-y-auto`): lane height is data-driven, and
  a sticky rail taller than the viewport puts its lower lanes permanently out of reach.

**Live verification** (dev `:4321`, DOM reads not screenshots): rails endpoint returns 15 items across 6
rails (`x-discovery-source: compute`). Anonymous `/courses` → Trending/New/Popular, 6 items, **zero
duplicates** with `intro-to-n8n` present in two server rails but rendered once. Signed in as
`marcus.t@example.com` (topics `top-001`, `top-014`) → **For You leads with `intro-to-n8n`** (the only
2-topic match) ahead of five 1-topic matches, and Trending collapses because its only item was claimed —
matching the prediction computed from the blob beforehand. `/communities` and `/` verified likewise; Home
renders 4 lanes at 284×686 with all images loading. Empty path forced by poisoning the cache with an
empty blob → rail absent, blue placeholder at 284×200. Below `lg` (1019px iframe) the aside is
`display:none` with no horizontal overflow.

**Accepted caveat:** the rail is `hidden lg:block`, so there is no recommendations surface below `lg`.
The lane components are host-independent, so a later mobile placement is a mount change, not a rewrite.

**Deliberate drop:** each carousel had a localStorage dismiss. The rail occupies what was empty
placeholder space, and the dismiss that actually trains recommendations is the feed's
(`/api/feeds/smart/dismiss`). Flagged to the user rather than lost quietly.

**Follow-up logged — `[OVERLAY-ORPHAN]`:** deleting the carousels left `variant="overlay"` with zero
production call sites on **both** catalog cards. Logged as a keep-or-delete task with a pointer NOTE in
each component header rather than swept: the Conv-425 precedent removed a strand that was unreachable
*and* undocumented, whereas `overlay` is coherent, named and tested, and deleting two variants plus their
tests is adjacent work whose blast radius is the user's to size.

5 gates green; suite 6234→**6210** (−44 deleted, +20 new); `prov:sweep` at its 11-issue baseline with both
new components stamped and registered.

## 4 · Shell track review

✅ **Walk COMPLETE + BUILT (Conv 428)** — 11 files censused, **4 live mechanisms** (1 ADAPT · 1 ADOPT ·
2 DROP). The other 7 files were already dispositioned by the §1–§3 screen walks; the shell track's real
residue was far smaller than the route-impact map implied.

### Already settled before this walk (stated for the record)

| File | Where it was decided |
|---|---|
| `SubNav.astro` | `[TAB-SCROLL]` → ADOPTED as opt-in `preserveScroll` (§1 M6, Conv 409); our implementation differs (`data-preserve-scroll` + sessionStorage vs his `astro:before-preparation` capture), same effect |
| `SubNavItem.astro` | `[TAB-COMPACT]`/`[TAB-FLOAT]` → ADAPTED as `dense`, tokenised, **no gradient capsule** (§1 M7); the colours he wanted were later revisited as the `[TAB-THEME]` toggle (Conv 414) |
| `form/Input.tsx` | `compact` + the forms-plugin chrome strip → ADOPTED (§2 M8 + finding F1, Conv 425) |
| `form/Select.tsx` | `compact` → ADOPTED (§2 M8) |
| `ui/IconLabelChip.tsx` | `link` tone → ADAPTED with a **persistent** underline, not his hover-only (§2 M13, following Conv 415 `[STEP-LINK]`) |
| `layout/StickyListingToolbar.astro` | toolbar slimming → ADAPTED as opt-in `dense` (§2 M8) rather than changing the defaults |
| `layout/ListingShell.astro` | placeholder-panel removal → DROPPED (§2 M16 — panel kept and later filled by `[REC-REHOME]`) |

His `index.astro` change is the same site-wide panel deletion already dropped in §2 M16, and
`MobileUpNav.astro` is untouched at the pivot — so the census is complete.

### Dispositions

| # | Mechanism | Disposition | Reasoning |
|---|---|---|---|
| S1 | `[BACK-X]` `BackHeader.astro` — sticky ← button + view-type title, **and** the site-wide removal of the desktop breadcrumb row | **ADAPT — take the title, drop the button, keep breadcrumbs** | His branch comments the `header-bar` breadcrumb row out site-wide ("DISABLED site-wide per client request"), which is *why* it needed a back button. We keep breadcrumbs, so that hole never opens. The button itself was then examined on the user's instinct that it duplicated browser Back — **it does**: the handler calls `history.back()` in the common in-app case, literally the same call, and renders `lg:` only, i.e. exactly where the browser toolbar Back is always visible. Its one non-duplicate case (deep-link/fresh-tab → route parent) is covered by the breadcrumb we kept. The sticky **title** survives as the one part nothing else provides |
| S2 | `[FEED-WIDTH]` `contentWidth='feed'` — 640px left-anchored column for course detail / book / success | **DROP** (re-affirms the §1 soft DROP) | The geometry and a right-hand filler stand or fall together. The only candidate filler was `DiscoveryRails`, and its value on `/course/[slug]` splits by enrollment: useful to an unenrolled comparison shopper, but off-task for an **enrolled** student whose course page is a workspace — cutting against the **≥75% completion** key metric on the page where completion is earned. Without rails the 640px column leaves dead space, which was the original §1 reason to drop. Course detail is also the densest page in the product (modules + file strips + teachers + reviews); consistency with the listing pages is a weaker argument than content width, because detail pages legitimately differ from listing pages |
| S3 | Sidebar `Learning` → `My Courses` | **DROP** | "My Courses" now collides with `/courses`, which M3 (same conv) made purely the public catalog — and our `/learning` page heading is "My Learning", so adopting the sidebar label alone would split label from heading |
| S4 | `Teachers` → `Peer Teachers` across admin / analytics / studio | **ADOPT** | Settles the half-applied state surfaced earlier this conv: the relabel had landed on the 5 course surfaces (§1 M4) but not admin. Adopting finishes it so the product uses one term. (This is nominally §6 scope; the artifact surfaced here, and deciding it once avoids deciding it twice) |

### Build log — §4 (Conv 428, all 5 gates green + live-verified)

**S1.** New `src/components/ui/StickyViewTitle.astro` (52px sticky row, desktop-only, no button),
a `view-title` slot on `AppLayout` that sets `--pin-top: 68px` when filled, and `SubNav`'s two pin
lines moved from a hardcoded `16px` to `var(--pin-top,16px)`. Registered in
`scripts/matt-inspired-registry.ts` so the stamp doesn't turn `prov:sweep` red (the Conv-425 lesson).

**Where it is deliberately NOT used, and why.** Not on `/course/[slug]`, `/community/[slug]` or
`/profile` — all three already pin a sticky `SubNav`, so they have pinned context already, and
stacking a second 52px row runs into the decision already recorded in
`course/[slug]/[...tab].astro` ("*~275px of chrome. Do not make this sticky.*", Conv 359). The one
qualifying host is **`/session/[id]`**: deep, no sticky strip, and its journey stepper scrolls away.
It shows the **course title** rather than the view type, because the course is the context actually
lost. `/receipt/[id]` can't host it (uses `LandingLayout`, and it's a short printable page).

**🟠 Honest limitation.** Verified live at 1244×1059 the session page's content is 1059px — it does
not scroll at that viewport, so the bar has nothing to stick past. The pages long enough to need this
are exactly the pages that already have a sticky strip. The mechanism is built, correct and
regression-safe, but its practical value on the one available host is thin — flagged for the user
rather than quietly scoped away.

**S4.** 9 bare `Teachers` label sites relabelled — `AdminDashboard` (nav item + StatCard),
`CoursePerformanceTable` header, `CourseCreatedCard` button, `CourseEditor` (tab + h3), `AdminNavbar`,
`TeacherProfile` breadcrumb, `api/admin/analytics/users.ts` chart series. Each was checked to be the
role name rather than an unrelated string. `StoriesBrowse.tsx` is his-only and doesn't exist here.
4 tests asserted the old label and were updated.

**Live-verified:** `/session/ses-sarah-ai-1` → bar present, `position: sticky`, `top: 0`, 52px,
text "AI Tools Overview", breadcrumb still rendered, **no** back button, `--pin-top: 68px` on `<main>`.
`/course/ai-tools-overview` → no bar, `--pin-top` unset so the strip falls back to `16px` and pins at
16px exactly as before (the var change is behaviour-identical). `/admin` → 3 "Peer Teachers", zero
bare "Teachers".

5 gates green; suite **6215** (unchanged — the 4 relabel-assertion updates are edits, not additions);
lint 0 errors (160 pre-existing warnings); `prov:sweep` at its 11-issue baseline.

**§4 result: 1 ADAPT · 1 ADOPT · 2 DROP.**

**Follow-through (later in Conv 428).** `StickyViewTitle` now has **three** hosts, not one:
§6's census found he mounted `BackHeader` on `/creating/communities/[slug]` and
`/teaching/courses/[courseId]` too, and both were verified to carry no `SubNav` — so both
qualify under the rule above. Wired with a view-type title on the community page (its name is
only known client-side) and the course title on the teaching page. The honest limitation is
unchanged though: at a 1059px window none of the three scroll (each ~1059px of content); on a
typical 800px laptop they scroll ~260px, which is where the row earns its 52px.

## 5 · Sessions-files feature decision

✅ **Walk COMPLETE + BUILT (Conv 428).** **The feature question was already answered** — every component
of "sessions files" had been dispositioned in an earlier walk, and one file the route-impact map filed
here isn't a files change at all. Verified against our tree, not inferred:

| Component | Status | Verified how |
|---|---|---|
| `0006` → `display_order` | **ADOPTED** (§1 M3, Conv 412) | present in `migrations/0001_schema.sql`'s `session_resources`, with an inline note recording the `in_room` decision |
| `0006` → `in_room` | **DROPPED** (§1; ledger §1) | appears in our tree only inside two comments — never as a column or field |
| `api/storage/[...key].ts` | **ADOPTED** (§3 N14, Conv 426) | route exists |
| `api/sessions/index.ts` | **DROPPED — and mis-filed.** Not a files change: it removes the "teacher does not match your enrollment" 403 and re-assigns `enrollments.assigned_teacher_id` on every booking. That is the **teacher-switching** mechanism, already declined | our 403 is still enforced at `src/pages/api/sessions/index.ts` |
| `public/docs/vibe-coding-101/*` | **P1 below** | 6 binaries on his side; we have no `public/docs` |
| `session/[id].astro` | **P2–P4 below** — course-chrome parity, not files | — |

### Dispositions

| # | Mechanism | Disposition | Reasoning |
|---|---|---|---|
| P1 | 6 committed demo documents (`.pptx` `.pdf` `.docx` `.gif` `.jpg`) under `public/docs/` | **DROP** | No binaries in git — the code repo is **shared with the client**, and Conv 415 `[R2-SEED]` deliberately built type-appropriate placeholder-blob seeding to avoid exactly this. Real demo content can be pushed to local/staging R2 without committing it |
| P2 | `CourseMiniHeader` identity box on the session page | **DROP** | The session page's job is the video room. `StickyViewTitle` (§4 S1, same conv) already names the course in **52px**; a ~198px identity header would push the room down for chrome we just solved more cheaply. We also have no `CourseMiniHeader` — it would be a net-new component |
| P3 | `sticky` on the session page's `CourseRail` | **DROP** | Mutually exclusive with §4's `StickyViewTitle` by the rule §4 set (use the title row only on deep pages with **no** sticky strip). Adopting P3 would strip the title bar of its one host; stacking both costs ~120px of pinned chrome, which is what the Conv-359 note warns against. Rail stays `static` |
| P4 | Journey band **below** the tab strip (`[HDR-ABOVE-TABS]`) | **ADAPT** | Not really an adoption — a fix to our own inconsistency. Our `/course/[slug]` already renders the stepper in the **default** slot, which `AppLayout` places after `sub-nav`, so the course page reads tabs-then-band. The session page put it in `entity-header` (above), making it the odd one out. His change fixes the same divergence |

### Build log — §5 (Conv 428, all 5 gates green + live-verified)

Only P4 required code: `CourseJourneyStepper` moved out of `slot="entity-header"` into the default
slot on `src/pages/session/[id].astro`, with `class="mb-16"` matching the course page's spacing.

**Live-verified** on `/session/ses-sarah-ai-1` — document order is now sticky title (y=16) → tab rail
(y=112) → journey band (y=181), i.e. band **below** tabs; `CourseRail` computed `position: static`
(P3 DROP honoured); no `CourseMiniHeader` in the DOM (P2 DROP honoured).

5 gates green; suite **6215** unchanged; lint 0 errors; `prov:sweep` at baseline.

**§5 result: 1 ADAPT · 3 DROP**, plus four components confirmed already-decided. Remaining
MERGE-BRIAN work = **§6 only**.

## 6 · Misc review

✅ **Walk COMPLETE + BUILT (Conv 428).** 7 mechanisms — **3 ADOPT · 1 already-adopted · 3 DROP**. This
closes the review programme: **all six units are now complete.**

### Dispositions

| # | Mechanism | Disposition | Reasoning |
|---|---|---|---|
| M1a | `SessionBooking` **"Change"** button beside the selected teacher, jumping back to the Teacher step | **DROP** | It is the UI half of **teacher switching**, already declined (ledger §1). Adopting it without the API change would build a dead end — pick another teacher, receive the 403 we deliberately kept |
| M1b | His inline `selectedTeacher.id === assignedTeacherId`, replacing the `isAssignedTeacher` variable | **ADOPT — a real defect on our side** | Ours computed `isAssignedTeacher` from `preSelected?.id` (line 96) but rendered it under `selectedTeacher.name` (line 537). `canNavigateTo` lets the user return to any earlier step, so: open `/book?st=<assigned teacher>` → step back → pick a different teacher → **"Selected at enrollment" renders under the wrong teacher**. A false statement about which teacher the enrollment is bound to. Independent of teacher switching |
| M2 | `/learning` renamed **"My Courses"** (page title, tab label, 2 breadcrumb strings, a comment) | **DROP** | The same relabel dropped as §4 S3 — this is simply its other half; he renamed the whole workspace, not just the sidebar entry |
| M3 | `.gitignore` += `.playwright-mcp/` | **ADOPT** | Trivial, and we do use Playwright as the browser-bridge fallback |
| M4 | Bespoke course cover SVGs replacing `picsum.photos` seed URLs | **ADOPT** | Removes an external dependency from dev/staging seeding — and external seed URLs are exactly what masked the real thumbnail 404 that §3 F3 found. Unlike the §5 demo documents these are **text**, ~22 KB for all six, so the client-shared-repo objection doesn't apply. Safety-scanned: no `<script>`, no `foreignObject`, no external refs; each carries `role="img"` + `aria-label` |
| M5 | `CourseListItem.description` + `.community` type fields | **already adopted** | Present at `mock-data.ts:248` / `:259` via §2 M9 / M11. No action |
| M6 | `Teacher Management` → **`Peer Teacher Management`** | **ADOPT** | **A gap left by §4 S4.** That census grepped `'Teachers'` / `"Teachers"` / `>Teachers<` and so never saw `Teacher Management`; two sites (`TeachersAdmin.tsx:435`, `admin/teachers.astro:12`) were still unrelabelled after S4 was reported complete |

### Build log — §6 (Conv 428, all 5 gates green + live-verified)

**M4 reached further than his diff suggested.** He also edits `migrations-dev/0001_seed_dev.sql` — which my
earlier completeness sweep missed, because the exclusion regex for `migrations` also swallowed
`migrations-dev`. That file is the actual dev data source, so without it M4 would have been a **no-op in
dev**: `seed-feeds.mjs` and `mock-data.ts` alone don't feed `/courses`. Six course `thumbnail_url`s
rewired there. Deliberately **not** taken from the same hunk: his `accent_color` column (declined,
ledger §1) and unrelated teacher-availability seed rows.

**Live-verified** (after `db:setup:local:dev` — the seed change needs a reseed):
- `/courses` → all **6** card covers are `/images/courses/*.svg`, zero picsum; SVG served `200 image/svg+xml`.
- `/admin/teachers` → `h1` and document title both "Peer Teacher Management"; no bare "Teacher Management".
- **M1b walked end-to-end**: `/course/ai-tools-overview/book?st=usr-guy-rymberg` as sarah (assigned
  teacher = Guy) → "Selected at enrollment" **shown** (correct) → clicked the completed Teacher step →
  selected **Marcus** → label **absent** (correct). Before the fix it would have rendered under Marcus.

One stale test assertion updated (`TeachersAdmin.test.tsx:155`). 5 gates green; suite **6215**; lint 0
errors; `prov:sweep` at baseline.

**§6 result: 3 ADOPT · 3 DROP · 1 already-adopted.**

---

## Programme complete

**All six review units are walked and every buildable disposition is built.** Across the programme:
§1 `/course/[slug]` · §2 `/courses` · §3 communities · §4 site-wide shell · §5 sessions-files · §6 misc.

Two patterns recurred often enough to be worth stating for any future client-branch review:

1. **A unit's recorded scope is a claim, not a fact.** §4 looked like 11 files and was 4 mechanisms;
   §5 looked like a feature decision and had none left; §2's M3 blocker was false in every load-bearing
   clause. Re-testing scope against the *consumers* before building repeatedly turned multi-conv work
   into single-slice work.
2. **Mis-filing is normal.** `api/sessions/index.ts` sat in §5 but was teacher switching; the
   "Peer Teachers" relabel spanned §1, §4 and §6; `migrations-dev` hid inside a `migrations` glob.
   The census, not the map, is authoritative.

---

## Post-close amendments

The block closed Conv 428. Convs since have **reversed individual dispositions on the client's direct
request**. They are recorded as ⚠️ amendments inside [NOT-ADOPTED.md](NOT-ADOPTED.md) rather than as
rewritten history — that file has to stay walkable *with him*, and "we changed our mind because you
asked, and here is what changed" is the honest version.

**The reusable move, common to all five rows so far:** before re-litigating a declined decision, read
*why* it was declined and ask whether that reason can be **dissolved**. In every case the review's
objection was about the **carrier**, not the design — raw hex for the colours, a divergent snapshot for
the CTA — so adopting meant fixing the carrier (name the values; share the resolver), which produced a
better result than either the original rejection or a straight adoption.

- **Conv 433 — § Communities, 2 rows.** N11's footer-band blues adopted verbatim as `--brian-band` /
  `--brian-band-line`; N12's white-ringed medallion adopted on the `/courses` cover-story card and
  deliberately *not* on `CommunityCatalogCard`. Detail in the Status line above.

- **Conv 435 — the five amended rows are now a client-facing RFC: [`docs/requirements/rfc/CD-040/`](../../docs/requirements/rfc/CD-040/RFC.md)**
  (`[CD040-BATCH]`; `original.txt` + `CD-040.md` + `RFC.md`, 35 items / 30 done, `rfc/INDEX.md` updated).
  Scope resolved to **five delivered changes across Convs 433–434** — `[COMM-BAND-ADOPT]`, `[COMM-IDENT]`,
  `[PILL-LIFT]`, `[CARD-CTA]`, `[TEACH-REQ]` — matching the five amended `NOT-ADOPTED.md` rows
  (2 § Communities + 3 § Courses) exactly, one RFC item per row. Two details worth carrying:
  (a) the batch **arrived verbally, one request at a time**, so `original.txt` is a *reconstruction* from
  the Conv-433/434 Extracts' § Conv Prompts and says so in a provenance note the CD-035..039 files do not
  carry; (b) the RFC keeps the two different "fives" apart — five *delivered* across both convs vs Conv
  434's five *planned*, of which only #1–#2 were ever named, so the unnamed #3–#5 became **client question
  Q1** rather than a silent omission. The five open/parked tasks that trail these rows now back-link into
  the RFC so a closure ticks the client-visible item too. **Walk CD-040 alongside NOT-ADOPTED.md** — the
  ledger says what he'll notice missing, the RFC says what he asked for and got.

### Build log — § Courses amendments (Conv 434, all 5 gates green + live-verified)

- **`[PILL-LIFT]` — topic-pill elevation ADOPTED (was: left behind with the raw-colour category).**
  Read his actual branch (`origin/brian-July-7:CoursesFilters.tsx:161-174`) rather than the screenshot,
  which is what found the load-bearing fact: his shadow tint `rgba(16,42,67)` = `#102A43` =
  **`--brian-ink`, a token already adopted from his tab palette**, so the elevation cost **no new
  colour**. Shipped as `--brian-pill-shadow{,-hover}` + an `@theme` bridge; `hover:bg-neutral-100`
  removed (hover lifts, it does not tint); 1px lift with a `motion-reduce` guard; the scroller went
  `py-2`→`py-12` because `overflow-x-auto` computes `overflow-y:auto` and was clipping the shadow.
  **Scope kept deliberately LOCAL to that row (user decision)** — other pill surfaces stay flat, and the
  component docstring records *why* it must not be propagated on consistency grounds (the Conv-433
  `[COMM-IDENT]` reversal is the precedent: treatment follows meaning, not uniformity). Suite 6352.
  Measuring it live added a `[BRIDGE-OFFSCREEN-WINDOW]` variant: a backgrounded Chrome window froze the
  `box-shadow` transition at `currentTime: 0`, so `getComputedStyle` returned the *pre-change* value —
  `element.getAnimations().forEach(a => a.finish())` yields the settled one.
- **`[CARD-CTA]` — per-card journey CTA ADOPTED (was: declined for disagreeing with the detail page).**
  Two blockers surfaced *before* building rather than after: "Teach this course" had **no destination**
  (certification is teacher-recommends → admin-approves; no self-serve path existed), and his four states
  have **no slot for "you already have a session booked"** — the exact divergence that got the CTA
  declined. User's call: point at the Diploma for now and log a task; match the detail page on the booked
  state. Implemented by moving `buildCoursePrimaryCta` into **`@lib/course-cta`** (out of the course-page
  module so a client island can call it without pulling in SSR code) and adding `nextSessionId` to the
  client snapshot with a predicate **deliberately aligned to `computeCourseJourney`** (scheduled-OR-
  in_progress, *not* the existing future-only `nextSessionAt`). A parity test now fails the moment a
  second implementation reappears. Suite 6360.
- **Three CTA defects of ours, one root cause.** `myCourseIds` conflated four unrelated relationships
  (enrolled + teaching-certified + created + moderated, all suppressed alike). `[CTA-MOD-GAP]` narrowed
  suppression to **creators only** (only authorship genuinely has no next step to offer);
  `[CTA-TEACHER-DUP]` routes certified teachers to `/teaching/courses/[id]` — placed in the **shared**
  resolver so both surfaces pass `isTeacherOfCourse`, since host-side would have recreated the split just
  closed; `[CTA-CANCELLED]` makes cancelled enrolments read as not-enrolled on both surfaces. Also fixed a
  case neither ticket named: a certified teacher who never enrolled previously got **no CTA at all**.
  Suite 6365.
- **`[CARD-CTA-COMM]` — the third surface.** Asked "will the same CTAs show up if the card appears
  elsewhere?", the answer was **no**: the community Courses tab was still on its own stale logic, so
  enrolled viewers got no CTA there. Wired to the shared resolver, preserving `?via=` attribution on
  course-bound hrefs only. All three surfaces verified to agree, live, on the exact student who would have
  shown the original divergence.
- **`[TEACH-REQ]` + `[TEACH-REQ-CREATOR-PATH]` — the flywheel work the CTA's dead end spun off.** Student
  request-to-teach flow and the creator-side **Requests** queue → tracked under
  [plan/cert-approval/README.md](../cert-approval/README.md) (What Exists + PHASE-2), since it is
  certification-pipeline work, not client-branch adoption.
- **`[TOKEN-TYPO]` — new gate for invented token/icon names.** Three invented names shipped in one small
  component (`bg-success-background`, `text-success-700`, `text-text-secondary`) plus
  `MattIcon name="check"` when no check icon exists — and **`tsc`, `eslint`, `astro check`, 6,371 tests
  and `build` were all green** while the UI was visibly wrong, because Tailwind emits nothing for an
  unknown utility and `MattIcon` renders a placeholder behind a DEV-only warning. Every one was written by
  following the naming *convention* instead of checking the *catalogue*. `scripts/check-token-names.ts`
  now polices **only families this repo declares and Tailwind does not ship** (so "declared or invalid" is
  exact and false positives stay at zero, which is what keeps a gate switched on); wired into
  `npm run verify` and `/w-codecheck` as check #10. Calibrated per `[CMH]` — the first two runs were wrong
  in *opposite* directions (attribute-only scan missed 2 of 6 real violations, since class lists here live
  in variables and object maps; broadened, it flagged 4 false positives on a valid `shadow-brian-pill`,
  because `shadow-*` resolves against `--shadow-*` not `--color-*`). Found **6 pre-existing
  `text-warning-600/700` defects** on a scale that only goes 100/300/500.
- **Follow-ups logged:** `[DIPL-SHELL]` (`/diploma/[id]` renders in the marketing `LandingLayout` for
  signed-in viewers — added to PLAN.md § Deferred: PUBLIC-PAGES), `[CTA-HOST-GUARD]` (nothing stops a new
  host of `CourseCatalogCard` shipping dead cards) and `[SHADOW-DEAD]` (the `--shadow-*` scale is inert —
  **parked by user decision**, and distinct from "should the pill shadow go site-wide", which is the
  question it was first mistaken for). All three on `CURRENT-TASKS.md`.

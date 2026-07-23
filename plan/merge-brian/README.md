# MERGE-BRIAN — Client-branch intent adoption

**Review target:** the **pivot snapshot `8a1e677f`** — the most recent commit of `origin/brian-July-7` (07-20 11:29), the state the user and Brian agreed was a good pivot point.
**Focus:** see what Brian built at that snapshot, extract the *intent* of the changes worth keeping, and selectively reimplement them on `jfg-dev-14` with a consequence audit per adoption. **Nothing is merged as-is — ever** (user directive, Conv 407: *"I know I won't be merging any of his work as is"*). His branch is a **reference exhibit**, not a source.
**Status:** 🔥 IN PROGRESS (Conv 407, fresh-docs restart) — infrastructure verified + side-by-side environment operational (ours `:4321`, pivot `:4341`, identical dev datasets); `/course/[slug]` §1 brief DONE (pivot-grounded) — dispositions pending the side-by-side walk
**Task-board body:** `CURRENT-TASKS.md § [MERGE-BRIAN-JULY7]` (branch facts, admission-gate history, timecard protection)

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

## Infrastructure (machine-local, MacMiniM4Pro — mirrors [PREFLIP-WT])

- **Reference worktree:** `~/projects/Peerloop-brian` — detached at **`8a1e677f`** (verified byte-identical to the `origin/brian-July-7` tip), deps installed (`npm ci`), local D1 seeded via `npm run db:setup:local:dev` (includes Brian's `0005`/`0006` migrations + his dev seed).
- **Run it:** `cd ~/projects/Peerloop-brian && npm run dev -- --port 4341` — **ephemeral**, kill when done (Astro 6, foreground). Ours runs on `:4321` from `~/projects/Peerloop` for side-by-side — Astro 7 daemonizes: stop via `astro dev stop`, never a port kill, and stop it before any local wrangler D1 op (miniflare store contention, measured Conv 407).
- **🔴 Side-by-side data parity is FALSE — corrected Conv 408.** Both local D1s are seeded to `dev` level, but **the seed file itself diverged across the fork**: `diff migrations-dev/0001_seed_dev.sql` ours vs the worktree = **52 differing lines**. His side adds `accent_color`/`logo_url` on communities (the `0005` `[COMM-BRAND]` columns), Guy availability rows, and a `cert-amanda-vc-comp` certificate row; our side adds the `[TZ-MODEL]` timezone seeding that post-dates his fork. **Consequence for every screen review: state-dependent differences (journey step completion, session counts, certificate/diploma state, community branding, booking availability) may be DATA artifacts, not UI-logic differences.** Verified instance (Conv 408, `amanda-lee` on `vibe-coding-101`): his journey reads "Sessions 2 of 2 · ✓ Certificate", ours reads "1 of 2 · 1 unbooked · ✓ Diploma" — the certificate row exists only in his seed. **Rule: before attributing any state difference to his code, diff the seed rows behind it.** Structural/layout comparisons remain valid. (Dev password `Peerloop2`.) **`:4341` login modal never renders** (merge-base-era auth UI, not being adopted — undiagnosed by choice): log in via the DevTools dev-login snippet (`fetch('/api/auth/dev-login', …)`) instead.
- **Read any file at the pivot without the worktree:** `git -C ~/projects/Peerloop show 8a1e677f:<path>`.
- **Teardown** (when the block closes): `git -C ~/projects/Peerloop worktree remove ~/projects/Peerloop-brian`.

## Open asks of Brian

- [ ] **The "approved Option B / mockup" artifacts** his commit messages cite — his rationale exists nowhere in git; only his chat sessions have it.

---

## Review order & status

| # | Review unit | Status |
|---|---|---|
| 1 | `/course/[slug]` detail | 🟢 brief DONE (pivot-grounded, Conv 407) — dispositions ⬜ pending side-by-side |
| 2 | `/courses` catalog | ⬜ |
| 3 | `/community/[slug]` + `/communities` (+`[COMM-BRAND]` feature decision) | ⬜ |
| 4 | **Site-wide shell track** (`[BACK-X]` back-nav, `SubNav`/`SubNavItem`, `Sidebar`, forms, `AppLayout`) | ⬜ |
| 5 | Sessions-files feature (`0006` + storage API) — adopt/reject as a feature | ⬜ |
| 6 | Misc ("Peer Teachers" relabel, `SessionBooking`, workspace touches) | ⬜ |

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

**Brief generated Conv 407, analyzed entirely at the pivot snapshot `8a1e677f`** (dual-checkout read; `brian-July-20` excluded by instruction). Dispositions ⬜ pending side-by-side review (ours `:4321`, pivot `:4341`).

### Architecture in one paragraph

Our page keeps a state-rich full `CourseHeader` hero (default/scheduled variants, CTA, includes), the journey stepper in the content column, and a broad 7–8 tab set separating Modules, My Sessions, and Homework. **Correction (Conv 408, live-verified):** that hero is **not** About-only — it renders identically above the tab strip on every tab (checked on `/modules`), so "his change adds permanent identity we lack" is false. Both designs put persistent identity above the tabs; the real axis is what it costs and what it carries. His pivot replaces that with a slim art-branded `CourseMiniHeader` that is **permanent chrome** above the tab strip on every tab (and on `book`/`success`), moves the CTA into the green journey band below the strip, and uses Astro view-transition freezing so only the panel under the band swaps. He collapses the IA to **4 tabs — About, Course Feed, Peer Teachers, Sessions** — by merging Modules + My Sessions into a single fold-based `SessionsTab` and hiding (not deleting) Creator/Reviews/Resources behind hero/About deep-links (routes stay live; `/modules` 301→`/sessions`). The cluster is re-parented into a shared `back-header` slot + `--pin-top` sticky system and a 640px `contentWidth="feed"` geometry — so the changes reach `AppLayout`, `SubNav`, `SubNavItem`, and `CourseRail` rather than staying page-local. Net: ours is hero-centric with wide tab breadth; his is a persistent-identity, session-centric, app-like shell with heavier shared-shell coupling.

### Findings that resolve open questions

- **`CourseTabs.tsx` plays no role in his course page** — at the pivot it's imported only by `discover/ExploreCourseTabs.tsx` (a discover subsystem **we deleted in Conv 392** along with it). His only touch was a label sweep. The Conv-396 modify/delete dilemma is void.
- **`CourseHeader.tsx` is fully orphaned at the pivot** — his own later reorg replaced its last three consumers with `CourseMiniHeader`, so the entire `[COVER-STORY]`/`[COVER-STORY-MIRROR]` hero-mirror work is **dead code on his branch**. Skip it; only `CourseCoverPanel` (catalog side) survives into §2.
- **Homework never existed on his branch** — `[HW-SUBMIT-UI]` (our Conv 387) post-dates his fork. His 4-tab merge therefore collides with our Modules + My Sessions + **Homework** trio; Homework's placement in any adopted IA needs an explicit decision.
- **Sessions tab visibility flips**: ours is enrolled-gated; his is public/browseable (states/actions render enrolled-only).

### Mechanism inventory (dispositions ⬜ pending)

| Mechanism | Data/API deps | Site-wide ripple | Token/colour | Disposition |
|---|---|---|---|---|
| `[HDR-ABOVE-TABS]` permanent chrome: `CourseMiniHeader` in `entity-header` on every tab + `book`/`success`; view-transition `persist`; About panel rebuilt (video placeholder, creator/community cards, 2-review preview) | loader `community` join (`progressions→communities`) | pushes onto `book`/`success`; depends on `back-header` slot + `--pin-top` | 🔴 heavy raw hex: on-dark link `#7cc4ec`×5 ("honest orphan — no on-dark link token"), `#d7e6ef`, `#c6d6e2`, `#e8a213`, gradient `#0e3a5c`/`#0b2740`; forces `text-white` over `.entity-course` → breaks role-blue links | **ADAPT** (Conv 408) |
| `[SESS-TAB]` merged Sessions tab: session-grouped `<details>` folds, 6-state machine (`done/live/booked/next/locked/browse`), actions overlay outside `<summary>`; kills Modules/My Sessions split | loader `moduleProgress`, `resources`, session-group counts in `CourseJourneyState`; extra DB read per course-tab load | course cluster + shared loader (additive) | tokens good; many arbitrary px (`pr-[168px]` overlay etc.) | **ADAPT — curriculum-first** (Conv 408) |
| `[SESS-FILES]` course/session file strips + badges (see §5) | `0006` columns + loader `resources[]` | none (additive) | minor | **ADAPT** (Conv 408) |
| `[TCH-SEARCH]` `TeachersTabList` island: header-docked live search + sort-in-search; "Peer Teachers" label | none new | none — course-only | clean; arbitrary widths only | **ADAPT** (Conv 408) |
| `[BAND-ACTION]` journey band: links only on actionable steps (`isLinkStep`), green CTA at band end | existing `buildCoursePrimaryCta` | course cluster (stepper on 4 routes) | raw green `rgba` CTA shadows | **ADAPT** (Conv 408) |
| `[TAB-SCROLL]` scroll-preservation script on tab switch (with `ResizeObserver` clamp-retry for slow islands) | none | 🔴 **shared `SubNav`** — fires on every SubNav surface site-wide | JS only | **ADAPT — opt-in** (Conv 408) |
| `[TAB-FLOAT]`+`[TAB-COMPACT]` floating-pill, ~65%-height top-strip chips (selected = blue gradient capsule) | none | 🔴 **shared `SubNavItem`** — every top-strip SubNav | raw `#2a93d5`, `#dfe6ee`, 8 `rgba` shadow stacks; `py-[6px]` documented-required | **ADAPT — compact only** (Conv 408) |
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

**2 · `[SESS-TAB]` → ADAPT, curriculum-first** (Conv 408). Take the *merge* — collapse our Modules tab and our off-strip My Sessions into **one tab, in the tab strip** — but **invert his framing**: the tab is **curriculum-first and public** (modules are student-independent), with the signed-in student's session state **overlaid** on each module once enrolled. Rationale is the data-model correction above: sessions require an enrolment and bind to a module only on completion, so a sessions-first list must invent pseudo-rows for visitors and cannot label a booked-but-incomplete session with a module. Curriculum-first has neither failure. **Keep:** `Prepare / Join` and the booking affordance (carried into the row/fold body — dropping them would be the `feedback_port_functionality_and_styling` failure), **Homework as its own tab** (module-scoped assignments belong on the curriculum side; his IA has no slot for it), and **Diploma** naming over his locked "Certificate" stub. **Fixes on our side while we're here:** the merged tab goes *in the strip* (My Sessions is currently reachable only via the journey band). **Verify before building:** render a booked-but-not-completed fixture — `sessions.module_id` is NULL in that state and no screenshot on either side has exercised it.

**3 · `[SESS-FILES]` → ADAPT** (Conv 408). Smaller than the plan implied: **`session_resources` already exists in our schema** (`course_id`, `module_id`, `type`, `r2_key`, `external_url`, `is_public`, `download_count`) with 5 live routes including `/api/resources/[id]/download`. His `0006` adds only two columns. **Take:** the inline file strip (files shown against the module they belong to instead of exiled to a Resources tab) and **`display_order`** — real ordering we lack. Honour our existing **`is_public`** so public files appear on the public curriculum tab and enrolled-only files appear after enrolment (dovetails with mechanism 2). **Wire file rows to `/api/resources/[id]/download`.** **Defer `in_room`.**

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

_(pending)_

## 3 · Communities review

_(pending)_

## 4 · Shell track review

_(pending)_

## 5 · Sessions-files feature decision

_(pending)_

## 6 · Misc review

_(pending)_

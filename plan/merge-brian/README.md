# MERGE-BRIAN — Client-branch intent adoption

**Review target:** the **pivot snapshot `8a1e677f`** — the most recent commit of `origin/brian-July-7` (07-20 11:29), the state the user and Brian agreed was a good pivot point.
**Focus:** see what Brian built at that snapshot, extract the *intent* of the changes worth keeping, and selectively reimplement them on `jfg-dev-14` with a consequence audit per adoption. **Nothing is merged as-is — ever** (user directive, Conv 407: *"I know I won't be merging any of his work as is"*). His branch is a **reference exhibit**, not a source.
**Status:** 🔥 IN PROGRESS (Conv 407, fresh-docs restart) — infrastructure verified; `/course/[slug]` analysis re-running against the pivot snapshot
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
- **Run it:** `cd ~/projects/Peerloop-brian && npm run dev -- --port 4341` — **ephemeral**, kill when done. Ours runs on `:4321` from `~/projects/Peerloop` for side-by-side.
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

**Disposition vocabulary:** **ADOPT** (reimplement the intent as-is) · **ADAPT** (take the idea, different mechanism) · **REJECT** (with one-line reason) — recorded per change in each screen section, then implemented cosmetic-first; internal deps (schema/API) surface via the screens that need them.

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

Our page keeps a state-rich full `CourseHeader` hero (default/scheduled variants, CTA, includes) dominating the About tab, the journey stepper in the content column, and a broad 7–8 tab set separating Modules, My Sessions, and Homework. His pivot replaces that with a slim art-branded `CourseMiniHeader` that is **permanent chrome** above the tab strip on every tab (and on `book`/`success`), moves the CTA into the green journey band below the strip, and uses Astro view-transition freezing so only the panel under the band swaps. He collapses the IA to **4 tabs — About, Course Feed, Peer Teachers, Sessions** — by merging Modules + My Sessions into a single fold-based `SessionsTab` and hiding (not deleting) Creator/Reviews/Resources behind hero/About deep-links (routes stay live; `/modules` 301→`/sessions`). The cluster is re-parented into a shared `back-header` slot + `--pin-top` sticky system and a 640px `contentWidth="feed"` geometry — so the changes reach `AppLayout`, `SubNav`, `SubNavItem`, and `CourseRail` rather than staying page-local. Net: ours is hero-centric with wide tab breadth; his is a persistent-identity, session-centric, app-like shell with heavier shared-shell coupling.

### Findings that resolve open questions

- **`CourseTabs.tsx` plays no role in his course page** — at the pivot it's imported only by `discover/ExploreCourseTabs.tsx` (a discover subsystem **we deleted in Conv 392** along with it). His only touch was a label sweep. The Conv-396 modify/delete dilemma is void.
- **`CourseHeader.tsx` is fully orphaned at the pivot** — his own later reorg replaced its last three consumers with `CourseMiniHeader`, so the entire `[COVER-STORY]`/`[COVER-STORY-MIRROR]` hero-mirror work is **dead code on his branch**. Skip it; only `CourseCoverPanel` (catalog side) survives into §2.
- **Homework never existed on his branch** — `[HW-SUBMIT-UI]` (our Conv 387) post-dates his fork. His 4-tab merge therefore collides with our Modules + My Sessions + **Homework** trio; Homework's placement in any adopted IA needs an explicit decision.
- **Sessions tab visibility flips**: ours is enrolled-gated; his is public/browseable (states/actions render enrolled-only).

### Mechanism inventory (dispositions ⬜ pending)

| Mechanism | Data/API deps | Site-wide ripple | Token/colour | Disposition |
|---|---|---|---|---|
| `[HDR-ABOVE-TABS]` permanent chrome: `CourseMiniHeader` in `entity-header` on every tab + `book`/`success`; view-transition `persist`; About panel rebuilt (video placeholder, creator/community cards, 2-review preview) | loader `community` join (`progressions→communities`) | pushes onto `book`/`success`; depends on `back-header` slot + `--pin-top` | 🔴 heavy raw hex: on-dark link `#7cc4ec`×5 ("honest orphan — no on-dark link token"), `#d7e6ef`, `#c6d6e2`, `#e8a213`, gradient `#0e3a5c`/`#0b2740`; forces `text-white` over `.entity-course` → breaks role-blue links | ⬜ |
| `[SESS-TAB]` merged Sessions tab: session-grouped `<details>` folds, 6-state machine (`done/live/booked/next/locked/browse`), actions overlay outside `<summary>`; kills Modules/My Sessions split | loader `moduleProgress`, `resources`, session-group counts in `CourseJourneyState`; extra DB read per course-tab load | course cluster + shared loader (additive) | tokens good; many arbitrary px (`pr-[168px]` overlay etc.) | ⬜ |
| `[SESS-FILES]` course/session file strips + badges (see §5) | `0006` columns + loader `resources[]` | none (additive) | minor | ⬜ |
| `[TCH-SEARCH]` `TeachersTabList` island: header-docked live search + sort-in-search; "Peer Teachers" label | none new | none — course-only | clean; arbitrary widths only | ⬜ |
| `[BAND-ACTION]` journey band: links only on actionable steps (`isLinkStep`), green CTA at band end | existing `buildCoursePrimaryCta` | course cluster (stepper on 4 routes) | raw green `rgba` CTA shadows | ⬜ |
| `[TAB-SCROLL]` scroll-preservation script on tab switch (with `ResizeObserver` clamp-retry for slow islands) | none | 🔴 **shared `SubNav`** — fires on every SubNav surface site-wide | JS only | ⬜ |
| `[TAB-FLOAT]`+`[TAB-COMPACT]` floating-pill, ~65%-height top-strip chips (selected = blue gradient capsule) | none | 🔴 **shared `SubNavItem`** — every top-strip SubNav | raw `#2a93d5`, `#dfe6ee`, 8 `rgba` shadow stacks; `py-[6px]` documented-required | ⬜ |
| `[BACK-X]` sticky X-style `BackHeader` (desktop) + **site-wide removal of the old breadcrumb `header-bar` row** | none | 🔴 **shared shell** — new AppLayout slot + `--pin-top` in SubNav/CourseRail; wired into 7 drill-in routes; breadcrumb removal touches every route | clean tokens; `h-[52px]`, `--pin-top:68px` magic number | ⬜ |
| `[FEED-WIDTH]` (untagged) `contentWidth: 'full'\|'feed'` prop on AppLayout — 640px left-anchored column for entity pages | none | AppLayout (opt-in, `display:contents` default = bit-identical) | `lg:w-[640px]` must stay in sync with Home//courses geometry | ⬜ |
| `[COMM-BAND]` course-side community affiliation (logo + "part of X — N members" in header) | `0005` columns + loader join + public storage route for logos | loader + migration shared with §3 | `accent_color` = validated palette hex, stored not hard-coded | ⬜ |
| Teacher-switching (untagged, `POST /api/sessions`): **removes the teacher-match 403**; booking re-assigns `enrollments.assigned_teacher_id` | none (existing columns) | 🔴 **behavioral API change** — booking semantics, not cosmetics; cited to a client-side product decision in his notes — verify intent with Brian | n/a | ⬜ |
| `MattCourseFeed` compact composer + skeleton loaders; `CourseEmbedCard` elevation | none | `CourseEmbedCard` shared across feed surfaces | raw `rgba` shadows; `bg-neutral-100` non-token | ⬜ |

*(`[TAB-OWNS-PAGE]` was his intermediate step, fully superseded by `[HDR-ABOVE-TABS]` within the branch — no separate disposition.)*

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

_(to be filled during the side-by-side review — ADOPT / ADAPT / REJECT per mechanism row above; one-line reason per REJECT, for the conversation with Brian)_

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

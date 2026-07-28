# What we did NOT take from Brian's branch

**Companion to [README.md](README.md) — the client-facing view of the same dispositions.**
Where the README records *what we decided and why we built it that way*, this file records the
inverse: **every change Brian made that is not in our app**, with the reason, so it can be walked
through with him directly.

- **Review target:** pivot snapshot `8a1e677f` (tip of `origin/brian-July-7`, 07-20 11:29) — the point
  he and the user agreed to review from. His later `brian-July-20` exploration is out of scope.
- **Decided so far:** 42 distinct mechanisms across 3 of 6 screens — **6 taken as-is · 32 taken in
  part · 4 declined**. Screens 4–6 are not reviewed yet, so nothing on them is decided either way.
- **As of:** Conv 426 (2026-07-28). **Living document — updated as each screen walk completes.**

## How to read it

| Status | Meaning |
|---|---|
| ❌ **Declined** | We are not doing this. Reason given; a decision, not an oversight. |
| 🟡 **Declined for now** | Not rejected on the merits — parked, and we're open to his case for it. |
| 🔵 **Took the idea, not the build** | The intent shipped; a specific part of his implementation did not. |
| ⏸️ **Deferred** | Agreed in principle, blocked on work we have to do first. |
| ⬜ **Not yet reviewed** | No decision exists. |

---

## 1 · ❌ Declined

### Teacher switching on booking (`POST /api/sessions`)

**His change:** removes the "teacher does not match your enrollment" 403, and re-assigns
`enrollments.assigned_teacher_id` to whichever teacher the student just booked.

**Ours:** unchanged — one assigned teacher per enrollment; booking a different teacher is refused.

**Why:** this is a marketplace-policy change, not a UI change. Silent re-assignment on every booking
has knock-ons nobody has costed — earnings attribution, session history, and a teacher's own roster
expectations all key off that column. His code cites *"Conv 376, product decision / approved"*, but
that rationale is in his chat only and never reached git. **This is the one item where we'd want the
original reasoning before reconsidering.**

### The `in_room` file flag

**His change:** `session_resources.in_room`, rendered as a badge telling students the file is
preloaded into the BigBlueButton room.

**Ours:** the file strips shipped (per-module and course-wide), but without this flag.

**Why:** nothing implements it. Searching his branch for `in_room` returns only the tab component and
the loader — it is a badge label and a sort key, with no code that puts any file into a BBB room. The
badge would tell students something untrue. The capability is worth building; it needs to be built
first, then flagged.

### Community accent colours — column, palette and picker

**His change:** `communities.accent_color`, a 10-colour palette library (`lib/community-branding.ts`),
and a settings picker, tinting community surfaces.

**Ours:** we took the **community logo and the "part of X — N members" affiliation line** (both now
live on the course hero and the catalog cards). No accent colour anywhere.

**Why:** two reasons, and the first is his own. **The accent tinting is already switched off across his
branch** — he disabled it site-wide at the client's request (`void accentColor` / "accents off
site-wide" in the catalog card; `const accent = null` in the community band). Adopting it would mean
importing a schema column, a palette library and a settings UI to drive a feature that is off.
Second, per-community accents collide with our role-based colour theming — the exact risk flagged
going in. Taking logo + affiliation keeps all the identity value and closes the collision permanently
rather than shipping it dormant.

### "Certificate" as the name for course completion

**His change:** journey step 4 reads "Certificate" (a permanently-locked stub, `href:''`); the enrolled
catalog card reads "Certificate earned".

**Ours:** **Diploma**, linked to a real `/diploma/[enrollmentId]` page.

**Why:** these are two different things in the product. A **diploma** is course completion. A
**certificate** is teach-readiness — the thing that qualifies someone to teach the course they
finished. Using "certificate" for completion breaks the distinction the flywheel depends on. Ours is
also functional where his is a stub.

---

## 2 · 🟡 Declined for now — open to his case

These four were declined by the user's own read, not by a consequence audit. The analysis is kept
intact so the conversation can be reopened. On the back-nav work the user's words were: *"I do not
like the breadcrumb changes, as is, but I can be convinced by him at a later date."*

### `[BACK-X]` back-nav header replacing breadcrumbs on deep routes

**His change:** an X-style sticky `BackHeader` — `history.back()` with a hierarchical-parent fallback
for deep-link entry — on **7 deep detail routes** (course tabs/book/success, community tabs, creator
community, teacher course, session), each dropping its breadcrumb in the trade. *(Worth correcting a
misconception on our side: this was never a site-wide breadcrumb removal — 22 pages keep the
breadcrumb bar on his branch.)*

**Why not yet:** the behaviour is good and cleanly built. What was declined is the aesthetic of losing
the breadcrumb on those routes. The cost is structural: a new layout slot plus a `--pin-top: 68px`
contract that `SubNav` and `CourseRail` must both honour — so it is a shared-shell commitment, not a
per-page one.

### `[FEED-WIDTH]` 640px column on course detail

**His change:** an opt-in `contentWidth: 'full' | 'feed'` prop on the layout; `'feed'` gives a 640px
left-anchored column, applied to course detail, book and success.

**Why not yet:** paired with `[BACK-X]` — back-row, pinned region and 640 column are one continuous
geometry, and revisiting one means revisiting all of it. **Note the partial reversal:** we *did* adopt
the 640px left-anchored geometry, on `/courses` (his `[CRS-LAYOUT]`). So the idea has landed; it is
course *detail* that still runs full-width.

### `[PANEL-REMOVE]` deleting the light-blue "More coming soon" panel site-wide

**His change:** removes the panel from the shared shell, the layout, Home and `/courses`.

**Ours:** **kept it, and extended it to `/courses`** — where it now fills the right-hand region that
his 640px left-anchored geometry would otherwise leave empty.

**Why not:** it is live client markup on Home. Deleting a surface site-wide is a product call, and the
opposite call turned out to solve a real problem his own layout change created.

### `[SORT-IN-SEARCH]` sort hidden behind a chevron in the search box

**His change:** the sort control moves inside the search field — chevron-only, behind a hairline
divider, with an invisible native `<select>` under it; the chevron tints blue when sort ≠ default.

**Ours:** sort stays a labelled compact `Select` in the toolbar.

**Why not:** the sort label disappears entirely, which is a discoverability trade rather than a space
saving, and it would diverge from the visible `Select` we shipped on the course Peer Teachers tab.
Formally this was recorded as a partial adoption (we took the compactness), but from his side the
mechanism is simply not there.

---

## 3 · 🔵 Took the idea, left part of the build

Thirty-two of his mechanisms shipped in adapted form. Listed here is only **what was left behind** in
each — the rest is in the app.

### Cross-cutting: raw colour values

This is the single biggest category, so it is stated once. Across five mechanisms his implementation
carried hard-coded colour rather than design tokens, and in each case we shipped the layout/geometry
and re-derived the colour from our palette:

| Where | What was left behind |
|---|---|
| Course header band | Dark scrim gradient (`#0e3a5c`/`#0b2740`), on-dark link `#7cc4ec`, `#d7e6ef`, `#c6d6e2`, `#e8a213`; also forced white text over the course role colour, breaking role-blue links |
| Tab pills (`SubNavItem`) | 10 raw values — `#2a93d5`, `#dfe6ee`, 8 `rgba` shadow stacks — on a primitive shared by 9 surfaces that previously carried **zero** |
| Catalog filter pills | Same palette again, plus the gradient selected-capsule |
| Cover panel | Navy/teal/violet gradient (`rgba(18,179,168)`, `rgba(88,77,244)`) — replaced with a tokenised placeholder |
| Course feed | 5 raw values — `bg-neutral-100` skeletons and `rgba` shadows |

**But his tab colours did ship.** Rather than lose them, they were rebuilt as three named style-guide
tokens behind a **user-toggleable theme switch** (Matt / Brian) on the profile Preferences page — so
his colour scheme is selectable in the running app, with the shared primitive still carrying no raw
colour. That is probably the most useful thing to show him.

### Course detail (`/course/[slug]`)

| His mechanism | What we left behind |
|---|---|
| **Permanent header band** above the tabs | The band's **removal of price, cover art and the Enroll CTA**. We took the compression (~200px reclaimed) but kept all three — dropping price from the identity block is a commerce regression for unenrolled visitors. Also left: the dark scrim, and the dependency on the `[BACK-X]` shell scaffolding |
| **Merged Sessions tab** (Modules + My Sessions in one) | The **sessions-first framing**, and the `/modules → /sessions` redirect. We merged the tabs but inverted it: curriculum-first at `/modules`, with your session state overlaid once enrolled. Reason is the data model — a session cannot exist without an enrollment, and binds to a module only on completion, so a sessions-first list has to invent rows for visitors and cannot label a booked-but-incomplete session. Also kept: **Homework as its own tab** (his 4-tab IA has no slot for it — it post-dates his fork) |
| **File strips** | The `in_room` flag (above), and the dead-link behaviour — in his version every R2-uploaded file renders as a styled link that does nothing (only external URLs work). Ours wire to the real download endpoint |
| **Teacher search + sort** | Nothing of the mechanism — but it is **count-gated**: it appears once there are enough certified peer teachers to filter. Today the heading reads "1 available", so an always-on search filters a single row |
| **Journey band** | His rule that **only the CTA is clickable**, which leaves a student who has completed the course with nothing to click at all. We took the compact single row and the end-of-band CTA, and kept Payment, Sessions and Diploma linkable. Payment also got a real destination — it pointed at the post-Stripe confirmation page; there was no receipt anywhere in the app, so we built one |
| **Tab scroll preservation** | Its unconditional application. The script is careful and it shipped — but opt-in per consumer, so the course pages get it and admin/profile/workspaces keep scroll-to-top |
| **Floating/compact tab pills** | The gradient selected-capsule and the raw colour (above). Compactness shipped; the row-wrap he was solving was a tab-*count* problem, which the tab merge already reduced |
| **Community band** | Accent colours (above). Logo + affiliation shipped |
| **Course feed** | Raw colour (above). The compact composer and skeleton loading states shipped |

### Courses catalog (`/courses`)

| His mechanism | What we left behind |
|---|---|
| **Topic pill row** replacing the filter dropdowns | The **removal of the Level and Length filters**. His version leaves them permanently `null` in the filter state — the code stays, the UI to reach them does not. We took the scrolling pill row and kept both filters reachable, along with our "available soon" filter |
| **Toolbar slimming** | The site-wide part. The `compact` field props are additive and shipped; the toolbar riser trim is behind an opt-in prop so `/communities` and `/members` are byte-identical to before (verified) |
| **Cover-story card** | The gradient (above), and the way it was gated — his overloads the existing `overlay` variant with a `catalog` context; ours is a third **named** variant, so the recommendations carousel and community course tabs keep exactly what `overlay` has always meant |
| **Detail hero mirrors the catalog card** — *"make the detail page card look exactly like the summary listing"* | Most of it. Literally shared, the hero becomes the card — which is the option the review had already declined, since our hero is a full-bleed backdrop with white text over a scrim and has no cover panel to share. Narrowed by the user to **the price sticker only**: the same component renders at the same offsets on both surfaces, and the hero keeps its own slim band |
| **Enrolled journey on the card** | The **CTA change**. His card CTA is derived from a client-side snapshot, while ours resolves an upcoming session first — so the same course would read "Book next session" on the catalog and "Go to Session 3" on the detail one click later. We took the ✓ Enrolled / ✓ Completed badge and the progress line; the CTA is untouched. His completed-state CTA ("Teach this course") is also not adopted |
| **Link-style chips** | Hover-only underline — we use a persistent underline, matching the affordance standard set on the journey stepper |

### Communities (`/communities`, `/community/[slug]`)

| His mechanism | What we left behind |
|---|---|
| **Community identity band** replacing the Card hero | The dark scrim and its hard-coded colours (the same set as the course header), and the dependency on the back-nav shell. We took the compaction, the logo mark, the denser byline, and his call to drop the duplicated description — the About tab already shows it verbatim |
| **Role tabs as floating pills** | The **removal of the role colours**. His version drops the member/teaching blue, created purple and moderating neutral because "the courses pill row has none". Role-based colour theming is one of the three areas flagged at the start of this review, so we took the pill shape and kept the palette. The gradient capsule and raw colour are left behind as everywhere else |
| **Community catalog hero card** | The hard-coded footer-band blues and shadow stacks, retokenised as on the course card. Added as its own named variant rather than replacing the existing `stacked` one, so the recommendations carousel is untouched |
| **Logo marks on the cards** | The white-ringed medallion treatment (the seal that rises above the band edge) — same call as on the course-side band. The logo itself now renders on community surfaces, which it did not before |
| **Course cards in the community Courses tab** | The **enrolled-CTA / journey mode** again, for the same reason as on the catalog: his card CTA is derived from status + module counts, so it would read "Book next session" while the course page reads "Go to Session 3" for the same course. His server-side enrollment query is better data than the catalog version, but it still lacks the upcoming session, so the contradiction survives. Badge and progress shipped; CTA untouched |
| **Sort docked in the search box** | Not adopted here either — same call as on `/courses` |

### Where his work fixed real defects on our side

Worth saying out loud, because the ledger otherwise reads one-directionally. Four of his changes
were not design preferences at all — they caught things genuinely broken or wrong on our branch:

- **The public asset route.** His `/api/storage/[...key]` exists because, as his own docstring puts
  it, *"the upload endpoints have always generated `/api/storage/{key}` URLs, but no route served
  them until now."* That was true on our branch too: **every course thumbnail a creator uploaded was
  a dead link**, invisible in dev only because our seed data uses external image URLs. **Adopted and
  shipped** — with a prefix allowlist, so the private files sharing that bucket stay unreachable.
- **Join/Leave on a second community.** He found that the buttons stop working when you arrive at a
  community by clicking through from the list, and moved the wiring to re-run on each navigation.
  **We reproduced it exactly** — reached by a direct load the Join button works; reached by clicking
  through from the communities list the same button produced no request at all — and **shipped the
  fix**.
- **The feed tab label.** Our *community* feed tab was labelled "Course Feed". His fix is simply
  correct, and is now in.
- **The oversized identity square.** His note that the header image *"hit the rem fallback and
  rendered 224px"* independently identified a sizing artifact on our page — one our own spacing
  migration had faithfully carried forward. His replacement header supersedes it: **that band is now
  96px**, and the same 4x artifact on the Courses-tab thumbnail went with it.

### Things skipped because they were already inactive on his branch

Neither of these is a judgment on the design — the code was dead at the pivot:

- **The `CourseHeader` hero-mirror work** (`[COVER-STORY]` / `[COVER-STORY-MIRROR]`) — his own later
  reorg replaced that component's last three consumers with the mini-header, so the entire hero-mirror
  effort is unreachable on his branch. Only the catalog-side cover panel survives, and that was
  reviewed on its own merits.
- **Community accent tinting** — disabled site-wide at the client's request (see §1).

---

## 4 · ⏸️ Deferred — agreed, but blocked on our own work

Both of these are changes we **want** to make and have not made yet, because making them now would
strand a surface with nowhere else to live.

### Hiding the As-Student / Teaching / Moderating role tabs on `/courses`

Agreed in principle. Blocked because **`/teaching` has no courses-list page** — its own route comment
says so, and the teacher dashboard groups students by course but never lists the courses themselves.
So `/courses#teaching` is currently the only list of a teacher's courses, and the same is true for
moderating. (`/learning` already covers the student lens.) Those two lists get built first, then the
tabs come out.

### Hiding the recommendation carousels on `/courses` **and** `/communities`

Agreed in principle, on both pages. Blocked for the same measured reason in each case: **that page is
the only consumer of its carousel**, and its carousel is the only caller of its recommendations API.
Hiding them retires personalized course *and* community recommendations across the whole product and
leaves two APIs with no callers. They need a new home first, and **that destination is still
undecided** — Home is the obvious candidate, but a previous decision bars re-adding panel surfaces
there. Both are now tracked under one task, since they would compete for the same destination.

---

## 5 · ⬜ Not yet reviewed

Three of the six review units have no dispositions at all. Nothing in them is declined; nothing is
agreed.

| Screen / area | His work there |
|---|---|
| **Site-wide shell** | Back-nav header, `SubNav`/`SubNavItem`, `Sidebar`, listing shell, sticky toolbar, form `Input`/`Select`, chips, app layout |
| **Sessions files feature** | The migration, session API edits, session page, demo course documents — an adopt/reject decision on the feature as a whole |
| **Misc** | "Peer Teachers" relabel across admin/analytics/profile, session booking, workspace page touches |

Several of these overlap work already done: the per-module file strips shipped as part of the
course-detail review, and the public asset route that the sessions-files feature needs was adopted in
the communities review. The remaining feature decisions are open.

---

## 6 · A process note, not a rejection

**His migration and API files never land as files, regardless of whether we want the feature.** Our
schema is still pre-launch, so a schema change is folded into the base schema and reseeded rather than
added as an incremental migration — his `0005` and `0006` would fork our migration history. Where we
wanted the capability we authored the equivalent column ourselves (the community `logo_url` and the
file `display_order` are both live). Same for the API routes: reimplemented against our own storage
and auth conventions.

This is worth stating explicitly to him, because "your migration didn't land" reads as rejection when
the feature it carried actually shipped.

## 7 · Open asks of Brian

- [ ] **The "approved Option B / mockup" artifacts** his commit messages cite. His rationale exists
      nowhere in git — only in his chat sessions. This is the main gap when auditing intent.
- [ ] **The product reasoning behind teacher switching** (§1) — cited as "Conv 376, product decision /
      approved". It is the one declined item where the original case could change the outcome.

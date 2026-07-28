# What we did NOT take from Brian's branch

**Companion to [README.md](README.md) — the client-facing view of the same dispositions.**
Where the README records *what we decided and why we built it that way*, this file records the
inverse: **every change Brian made that is not in our app**, with the reason, so it can be walked
through with him directly.

- **Review target:** pivot snapshot `8a1e677f` (tip of `origin/brian-July-7`, 07-20 11:29) — the point
  he and the user agreed to review from. His later `brian-July-20` exploration is out of scope.
- **Decided so far:** 42 distinct mechanisms across 3 of 6 screens — **5 taken as-is · 33 taken in
  part · 4 declined**. Screens 4–6 are not reviewed yet, so nothing on them is decided either way.
- **As of:** Conv 427 (2026-07-28). **Living document — updated as each screen walk completes.**
- **Since Conv 426:** the two deferred recommendation-carousel items moved out of "blocked" — the
  recommendations were rehomed and both carousels are now gone from the listing columns, so his goal
  there is met (see §3, *Recommendations on `/courses` and `/communities`*). The counts above are
  unchanged: no new mechanism of his was decided, an existing agreement was simply unblocked.

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

### Removing the breadcrumb row site-wide, and the back button that replaced it

**Reviewed and decided (shell track).** Your branch switches off the desktop breadcrumb row across the
whole site and puts a round ← button with a short title at the top of deep pages instead. We have kept
the breadcrumbs and not taken the button, for two reasons.

The first is that the two things answer different questions. A breadcrumb says *where this page sits* —
which community, which course, which module — and each step is a link you can jump to. A back button
says *how you arrived*. That distinction matters more here than on a site like X, whose back-only
pattern this follows: X shows a flat feed of posts, whereas Peerloop content is genuinely nested.

The second is that the button turned out to do exactly what the browser's own Back button does. Its
code calls the same browser history command, and it only ever appears on desktop — where the browser's
Back button is always visible in the toolbar. It behaves differently in one situation, when someone
opens a deep link in a fresh tab with no history to go back to; there it goes to the parent page
instead. Keeping the breadcrumb covers that situation already, since the parent is right there as a
link.

**What we did take:** the sticky title line. On a long page, once the header has scrolled out of view,
nothing tells you what you are looking at — so that part fills a real gap and is now in the product.

*A correction to an earlier note in this document, which said the breadcrumb removal applied only to
seven deep routes while twenty-two pages kept theirs. That was wrong. The layout renders the breadcrumb
in exactly one place, and on your branch that block is commented out, so no page shows a desktop
breadcrumb. The earlier count came from pages that still contain breadcrumb markup — which they do,
but the layout no longer displays it.*

### `[FEED-WIDTH]` narrower content column on course pages

**Reviewed and declined (shell track).** Your branch narrows course detail, booking and confirmation
pages to the same ~640px column the listing pages use. We have left them full width.

Narrowing only pays for itself if something useful fills the space it frees on the right. The natural
candidate was the recommendations panel we added to the listing pages — but on a course page that
splits badly. For someone still deciding, showing other courses is reasonable. For someone already
enrolled, the course page is where they actually do the work, and putting other courses alongside it
works against course completion, which is one of the project's headline goals. Without that panel the
narrower column just leaves empty space, and course detail is the densest page in the product — module
lists, files, teachers and reviews all need the width. Listing pages and detail pages are allowed to
differ.

### Renaming the sidebar's "Learning" to "My Courses"

**Reviewed and declined (shell track).** "My Courses" reads clearly on its own, but the product now has
a `/courses` catalogue that is purely a public list, so two sidebar-level things would be called almost
the same name while meaning different things — one your enrolled courses, one everything on offer. The
page itself is also headed "My Learning", so the label and the heading would disagree.

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
| **Cover-story card** | The gradient (above), and the way it was gated — his overloads the existing `overlay` variant with a `catalog` context; ours is a third **named** variant, so no existing host of that card changed appearance as a side effect of the new one |
| **Detail hero mirrors the catalog card** — *"make the detail page card look exactly like the summary listing"* | Most of it. Literally shared, the hero becomes the card — which is the option the review had already declined, since our hero is a full-bleed backdrop with white text over a scrim and has no cover panel to share. Narrowed by the user to **the price sticker only**: the same component renders at the same offsets on both surfaces, and the hero keeps its own slim band |
| **Enrolled journey on the card** | The **CTA change**. His card CTA is derived from a client-side snapshot, while ours resolves an upcoming session first — so the same course would read "Book next session" on the catalog and "Go to Session 3" on the detail one click later. We took the ✓ Enrolled / ✓ Completed badge and the progress line; the CTA is untouched. His completed-state CTA ("Teach this course") is also not adopted |
| **Link-style chips** | Hover-only underline — we use a persistent underline, matching the affordance standard set on the journey stepper |

### Recommendations on `/courses` and `/communities` — now done, differently

He hid both recommendation carousels. We agreed with the goal — neither listing column should be
interrupted between the search box and the results — but not with hiding them where they stood, since
each page was the only place its recommendations existed anywhere in the product.

So they moved rather than disappeared. Both pages, and Home, now carry recommendations in the
right-hand panel that had been an empty "more coming soon" placeholder, and they are fed by the single
daily discovery dataset the home feed already uses instead of two separate per-page recommenders. A
signed-in member gets a "for you" lane ranked by how well something matches the interests they picked
during onboarding; everyone gets trending, new and popular.

**What we left behind:** his outright removal, and the per-page recommendation endpoints, which are
deleted. **One thing to flag:** the panel only appears on wider screens, so on a phone there is
currently no recommendations surface at all. That is a known gap, not an oversight.

### Role tabs on `/courses` — now done, after checking where each view lived

He hid the As-Student / Teaching / Created / Moderating tabs on the courses catalog, leaving it as a
purely public list. We agreed with that, and it is now done — but we held it back until we were sure
each of those four views existed somewhere else, because on the catalog they were not just filters,
they were the only way some members reached their own courses.

Checking that turned out to matter, and also turned out to be less work than expected. Three of the
four views already had a home: a member's enrolled courses live on **My Learning**, a creator's
courses on the **Creator Studio**, and a teacher's certified courses on the **Teaching** dashboard.
The moderating view is a special case — moderation is granted per community, not per course, so the
list of communities you moderate on the communities page is the real version of it; the courses tab
was a flattened restatement.

The one genuine gap was that the teaching dashboard's list was plainer than the tab it was replacing:
no search, no Active/Paused split, and a simpler card. Rather than build a new page, we brought that
existing list up to the same standard — same card, same filters, same underlying data — so nothing
was lost when the tabs came out.

**What we left behind:** his approach of commenting the tabs out and leaving the code in place. We
removed them properly; the version history keeps the old code if we ever want it back.

### Communities (`/communities`, `/community/[slug]`)

| His mechanism | What we left behind |
|---|---|
| **Community identity band** replacing the Card hero | The dark scrim and its hard-coded colours (the same set as the course header), and the dependency on the back-nav shell. We took the compaction, the logo mark, the denser byline, and his call to drop the duplicated description — the About tab already shows it verbatim |
| **Role tabs as floating pills** | The **removal of the role colours**. His version drops the member/teaching blue, created purple and moderating neutral because "the courses pill row has none". Role-based colour theming is one of the three areas flagged at the start of this review, so we took the pill shape and kept the palette. The gradient capsule and raw colour are left behind as everywhere else |
| **Community catalog hero card** | The hard-coded footer-band blues and shadow stacks, retokenised as on the course card. Added as its own named variant rather than replacing the existing `stacked` one, so no other card surface changed meaning underneath it |
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

**Nothing is currently sitting here.** Both entries that were — the recommendation carousels and the
`/courses` role tabs — have since been built, each after we made the destination ready first. See §3,
*Recommendations on `/courses` and `/communities`* and *Role tabs on `/courses`*.

---

## 5 · ⬜ Not yet reviewed

Two of the six review units still have no dispositions. Nothing in them is declined; nothing is agreed.
(The site-wide shell was reviewed and is now fully decided — see the breadcrumb, content-width and
sidebar-label entries above, and the "Peer Teachers" note below.)

| Screen / area | His work there |
|---|---|
| **Sessions files feature** | The migration, session API edits, session page, demo course documents — an adopt/reject decision on the feature as a whole |
| **Misc** | Session booking, workspace page touches, story browsing |

Both overlap work already done: the per-module file strips shipped as part of the course-detail
review, and the public asset route that the sessions-files feature needs was adopted in the
communities review — so the sessions-files unit is smaller than it looks. The **"Peer Teachers"
renaming has now been adopted in full**: it had already reached the course pages, and the admin,
analytics and course-editor screens have been brought in line, so the whole product uses one term.

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

# Client meeting — Feeds redesign (2026-06-10)

**Status:** 🟡 SPECULATIVE — NOT ADOPTED. This is a *client meeting* model, captured for discussion. We will try to accommodate the list, but **pushback is expected and welcome** — nothing here is binding until we explicitly adopt it. The pre-meeting design in `README.md` stands as the coherent baseline; this file is the **delta** to assess and challenge against it.
**Source:** Fraser's Slack notes (verbatim below, hierarchy preserved from screenshot `2026-06-10_06-45-19.png`).

---

## Verbatim notes (hierarchy preserved)

- **Home page MUST have the Smart Feed:** An aggregate feed that contains everything from the current user/member's feed (course feeds + community feeds they follow + Announcements from The Common's feed. There maybe a welcome widget for visitors, that we can dismiss so it doesn't show again)
- **The Commons Community and its feed is never seen by anyone but admins**
- **Course Feeds**
  - teachers, creators and students (past, current) can create regular posts (everyone in the course can see)
  - teachers can promote a post into the parent Community feed (for a price)
- **Community Feeds**
  - posts can arrive when promoted from the Course feeds
  - teachers, creators and moderators can create posts (everyone in community can see them)
  - teachers, creators can promote posts into The Commons feed (for a price)
- **The Commons Feed**
  - admins can create posts (only seen by admins)
  - posts can arrive when promoted (from community feeds)
  - any post can be marked as an Announcement (by an admin) and that post will then be picked up in the Smart Feeds of Users and Visitors
  - if you want to promote a course or a community, you make a specific Post of that content type (we will create a template each for courses, communities)
- **Smart Feed**
  - shows up on Home Page
  - contains
    - Announcements from The Commons feed
    - high-value, algo-based community posts from each of your communities
    - high-value, algo-based course posts from each of your courses
    - **potentially**
      - announcements of courses you have taken that have been updated, have followup courses
      - nudges to update your interests from time to time (as they dictate what you see in your smart feed and recommendations)
      - occasional popular courses in your interests
      - occasional popular communities in your interests
      - new courses in your interests, communities
      - new communities in your interests
      - high-value, algo-based community posts from OUTSIDE of your communities but inside your interests
      - high-value, algo-based course posts from INSIDE your communities but from courses you have not taken
      - high-value, algo-based course posts from OUTSIDE of your courses but inside your interests

---

## The new model in one diagram

```
Course Feed ──promote($, teacher)──▶ Community Feed ──promote($, teacher/creator)──▶ Commons Feed
  post: teacher/creator/student        post: teacher/creator/mod                       post: admin only
  visible: everyone in course          visible: everyone in community                  visible: ADMINS ONLY
                                                                                            │
                                                              admin marks post = Announcement
                                                                                            ▼
                                                          Smart Feeds of ALL Users + Visitors
```
- **Promotion is the escalation + curation mechanism** (paid at each step up).
- **Announcements are the ONLY Commons content that escapes admin-only visibility** → they're the public/visitor fan-out channel.
- **Promote-a-course / promote-a-community = specific Post content types** (templated).

---

## Impact vs. the pre-meeting design (`README.md`)

### ✅ Survives
- Home MUST host the smart feed; merge into Home. (unchanged)
- **Member aggregation** = your communities + your courses → matches our S1, now sharpened to "**high-value algo**" (not chronological).
- **Discovery layer** = the whole "*potentially*" list ≈ our S2/S3 (popular/new in interests, outside-feed algo posts) — same concept, enumerated more precisely.
- **Welcome widget for visitors (dismissible)** replaces our "thin orienting line" — compatible, slightly richer (dismiss-and-remember).
- **Mechanics largely orthogonal to the curation change** and mostly carry over: interleaving/gradient, always-full (for the *member* feed), D1/Stream signal split, 3 render variants, per-post intent-preserving CTAs, sticky bar. Cursor needs a tweak (see below).

### 🔴 Changed / invalidated
1. **The Commons flips: public anchor → ADMIN-ONLY.** Our design used The Commons as the always-on *visitor* anchor (cascade tier 5, "everyone auto-joined"). Now its feed is admin-only — **our Commons-anchor is dead.** Open: is everyone still auto-*joined* to Commons at all, or only its *Announcements* reach members? (Reconcile with the existing `is_system` Commons model.)
2. **Visitor public content flips: algo-trending-public → ADMIN-CURATED Announcements.** Curation moves algorithm → human. Our "marketing aggregator pulls trending public posts" is replaced by "Commons Announcements fan out to visitors."
3. **"New-entity announcements" mechanism changes.** We auto-derived "new course/community" cards from `created_at`. Now you **author a promote-Post (template)** that escalates via the (paid) pipeline and an admin marks it an Announcement → authored + paid + curated, not auto. (Possible convergence: our "suggestion card" ≈ their "promote-a-course/community post template.")
4. **The member feed itself is now algo-curated** ("high-value algo posts"), not chronological. Affects the cursor decision (Option A assumed a *chronological* member backbone) — an algo-ranked backbone needs a stable score+id cursor, or we keep chronological pagination under an algo *pre-selection*.

### 🟠 Net-new scope (absent from our plan — large)
1. **Promotion/escalation pipeline** Course→Community→Commons with per-level promote permissions.
2. **PAID promotion** (payment per promotion — Stripe). A **monetization epic**, likely its own block, sequenced before/around feed display.
3. **Promote-course / promote-community POST templates** = new content types + authoring UI.
4. **Admin Announcement marking** (admin action → fan-out to all smart feeds incl. visitors).
5. **Per-feed posting + visibility model:** Course (teacher/creator/student), Community (teacher/creator/mod), Commons (admin-only-visible). Verify vs current schema/permissions.
6. **Promotion lineage** ("post arrived via promotion from X") in the data model. (`feed_activities` today is just `post|reply`.)

### ❓ Tensions / questions for the discussion
1. **Visitor supply vs. our "always-full" decision.** A pure visitor has no interests → the "*potentially*" interest-based items don't apply → **visitor feed ≈ Commons Announcements only**. Announcements depend on admin effort → can be **sparse**, which directly contradicts "always-full, accept lower-quality" (that assumed an algo-trending supply now gone for visitors). Fallback to algo discovery when announcements are thin, or accept sparse + lean on the welcome widget?
2. **The conversion-bait premise weakens.** "Wall of live platform activity → FOMO" becomes "a few curated announcements." Do the sticky bar + intent-preserving CTAs still earn their place over curated content? (Probably yes, but the content driving them changed.)
3. **Cold-start, new form.** Feed quality now depends on the **promotion economy + admin curation** being active. At launch: no promoted content, few announcements → sparse. The cold-supply problem returns, gated on human/economic activity rather than algorithm.
4. **Sequencing.** Paid promotion (monetization) is plausibly a prerequisite/parallel epic to the feed display — it's where the content *comes from*. Which lands first?
5. **Overlaps with existing tasks:** "followup courses" announcements ↔ `[NUDGE-TC-V2]` (progression-gap/followups); "interest-update nudges" ↔ onboarding/interests; promote-templates ↔ our card variant; per-feed structure ↔ `[COMM-TAG-FILTER]` channels.

## RESOLVED in discussion (2026-06-10) — visitor supply + Discovery Rails

**Visitor feed composition = B (curated + texture), always-full via promos.**
- **Backbone = promos** (promote-a-course / promote-a-community templated posts) — curated, marketing-grade, seedable at launch → guarantees always-full without depending on admin announcement throughput.
- **Lead = admin Announcements** (platform news / featured), prioritized at top.
- **Texture = entity rails, NOT raw posts.** The vitality layer is trending/popular/new **communities & courses** (entity cards), which is brand-safe (no uncurated post exposure) AND better conversion content for a *learning* platform than trending chatter. (Concession: the client's curation instinct beats our pre-meeting "wall of trending posts" — a cold learner is moved by "what could I learn," not eavesdropped discussion.)
- **Pushback recorded:** routing the entire visitor first-impression through the admin-only "mark as Announcement" channel is an admin-bottleneck; promos-as-backbone is what actually makes it scale. Accepted via promos.

**New component — Discovery Rails service (general, reusable):**
- **Precomputed, global, daily-refreshed** dataset — the lists are the same for everyone, so compute once, not per-request-per-user.
- **6 rails** = {trending, popular, new} × {communities, courses}, top-N each.
- **Signals:** *new* = `created_at` within window (7/14/30d TBD); *popular* = standing magnitude (enrollments / members, cumulative); *trending* = velocity (rolling-7d delta of enrollments/joins/activity, not absolute).
- **Architecture:** daily scheduled job (Cloudflare Cron Trigger → Worker) runs the heavy aggregations → writes a **KV JSON blob** → one API endpoint serves the blob (zero per-request aggregation) → client caches in **localStorage** (date/version stamp + freshness check; per-device staleness caveat).
- **Personalization = client-side lens on the global blob.** Payload stays global (each entity tagged with `topic_id`s); visitor uses as-is, logged-in user filters/boosts by their interests over the *same cached blob* → one cache entry, no per-user fetch/fragmentation.
- **Elevation:** build as the platform's **discovery-data layer**, reused by `/communities`, `/courses`, recommendation sections, AND the feed — and it can *replace* the expensive per-request `getDiscoveryCandidates` aggregation (precompute heavy global work daily; per-request just filter/personalize). Standalone-valuable even if the rest of the feeds model changes. Prospective task: **[DISCOVERY-RAILS]** (create on adoption).

## RESOLVED in discussion (2026-06-10) — "Featured" source + discovery unification

**"Featured" now has a principled source = Promoted content.** Current `RecommendedCommunities`/`RecommendedCourses` bands are only two-state (`source: 'personalized'` / `'popular'`, from `/api/recommendations/*`). There's a manual admin **Featured toggle** on courses (`context-actions/registry.ts` "Toggle Featured") but **no systematic source** — it's whatever an admin flipped. The new **paid promotion pipeline** gives Featured a real, economically-driven, time-bound source.

**Full sourcing table (every discovery category now backed):**
| Rail label (user-facing) | Source | Mechanism |
|---|---|---|
| **Peerloop Picks** | editorial curation | admin house-picks (absorbs old manual "Featured" toggle); no payment — platform vouches |
| **Promoted** | paid promotion | the new promotion pipeline; active promotions |
| Trending | Discovery Rails | daily velocity |
| New | Discovery Rails | daily `created_at` |
| Popular | Discovery Rails | daily magnitude |
| For You | interest lens over the above | client-side filter on global blob |

**Unification (elevation):** Discovery Rails + Promotion become the **single backing** for the `/communities` + `/courses` recommendation bands AND the home feed texture; `/api/recommendations/*` gets subsumed/refactored onto the same layer (one source of truth, three consumers).

**Sub-decision RESOLVED = (ii) coexist** — paid lane AND an editorial lane.

**Taxonomy reconciliation (transparency):** with two lanes, don't call the paid one "Featured" (reads as endorsement). Honest pair:
- **Paid lane → "Promoted"** (or "Sponsored") — labeled as paid, like every platform's paid placement. Source = active promotions.
- **Editorial lane → "Peerloop Picks"** (DECIDED) — the platform vouches, no money changes hands; the trust/conversion lever. Absorbs the old manual admin "Featured" toggle as the editorial source.
- So the rail set reads honestly: **Peerloop Picks** (we vouch) · **Promoted** (paid) · **Trending/New/Popular** (earned by data) · **For You** (your interests).
- Mechanical note: Promoted = active promotions is more *transactional* than the daily calc — ride it in the daily payload OR add a thin near-real-time overlay so a just-purchased promotion appears promptly.

## Prospective build tasks (CREATE ON ADOPTION — not yet in TodoWrite)
Held until the model is adopted + the open threads (esp. promotion scope) resolve, to avoid churn. Codes reserved:

- **[DISCOVERY-RAILS]** — the daily discovery-data service: scheduled job (CF Cron Trigger → Worker) computing trending/popular/new × communities/courses → KV blob; one API endpoint; client localStorage cache + freshness check. The general layer; can replace per-request `getDiscoveryCandidates` aggregation. *(standalone-valuable even if rest of model changes)*
- **[PROMOTE-PIPELINE]** — promotion epic. **Sequencing DECIDED = B (in feed MVP):**
  - **MVP (ships with the feed):** escalation mechanic (Course→Community→System, per-level permissions), promote-a-course / promote-a-community post templates, promotion lineage in the data model, the **Promoted lane** in the feed/rails, and **promote-nudges** (creator/teacher "promote this post" prompts on the `ProgressionNudge` family) — with escalation **free/admin-gated** at launch (the notes' "for a price" starts as free).
  - **Later phase (deferred):** **payment** (Stripe) + pricing/policy/refunds — a client-owned input; monetize once the marketplace has activity. Decouples cleanly (escalation works without payment).
- **[ADMIN-FEED-UI]** — admin console additions: mark-post-as-Announcement, manage **Peerloop Picks** (editorial lane, absorbs old "Featured" toggle), Commons posting, curation/moderation of promoted/announced content.
- **[RECO-UNIFY]** — refactor the `/communities` + `/courses` recommendation bands (`RecommendedCommunities`/`RecommendedCourses` + `/api/recommendations/*`) onto the Discovery Rails + Promotion backing; surface the full rail set (Peerloop Picks · Promoted · Trending · New · Popular · For You).
- **[POST-MATT]** — redesign the post/feed-item format to Matt's design. **Frames received + spec captured Conv 258 → `plan/home-feed-merge/post-format-matt.md`** (simple `477:8285` + complex `477:8203`, `@matt-source`). Key finding: the post shell + optional embedded **entity card** ("Learn More" green CTA) IS the unifying structure for the 3 feed-item variants AND the promote-a-course/community template; ties to `[SHOWMORE]` #13 (body truncation). Reuse Avatar/Button/CourseCatalogCard; new primitives: ReactionPill + comment-summary pill + post shell. Needed regardless of model adoption (posts exist today).
- *(feed consumption side already tracked: `[HOME-FEED-MERGE]` #30; signup-intent shared with `[VISITOR-GATING]` #31.)*

**Tunability (confirmed Conv 258) — extend, don't reinvent.** The existing Smart Feed already externalizes its levers: `scoring.ts` `ScoringParams` = 7 weights (recency/relationship/unseen/engagement/topicMatch/feedAffinity/topicAffinity, sum 1.00) + 6 structural dials (decayHours 72, pageSize 20, candidateLimit 100, diversityCap 3, discoveryFrequency 7, discoveryMax 3), all defaulted in `PARAM_DEFAULTS` and **runtime-overridable from `platform_stats` (`key LIKE 'smart_feed_%'`)** via `loadScoringParams(db)` — tunable without redeploy. Per-item score breakdown emitted for explainability. **New-model dials** (Trending/New/Popular windows, rail-mix ratios, Announcement priority, Promoted-lane frequency, page-1 best-of-recent window) should reuse the same `platform_stats` `smart_feed_*` pattern, not a parallel config.

**Dependencies:** DISCOVERY-RAILS feeds RECO-UNIFY + the home feed · PROMOTE-PIPELINE feeds the Promoted/Featured lanes · ADMIN-FEED-UI operates both. Whole cluster gated on adopting the speculative model.

## RESOLVED (2026-06-10) — Commons reconciliation + terminology

**Resolution = Option 1 (repurpose).** The participatory townhall is **retired**; the System community becomes admin-only.

**Terminology overhaul (DECIDED — use going forward):**
- **"The Commons" → "System community"** (the `is_system=1` community). Drop the "Commons" brand name. Admin-only domain.
- **"TownHall" → retired.** It was only the *name of that community's feed*; **feeds don't get names.**
- **Feeds are un-named, referenced by their parent.** Three feed-bearing parents only: **System community**, a **creator community**, a **Course**.
- **`feed_type`:** `'townhall' → 'system'`; keep `'community'` (creator community) + `'course'`. (Schema CHECK-constraint change + code sweep.)

**Concrete unwind (Option 1):**
- Retire `autoJoinTheCommons` (register). System-community membership stops being meaningful — **Announcements reach everyone via global fan-out, not membership.**
- `smart-feed/candidates.ts`: "include all townhall posts in member feed" → "include System-community **Announcements** only." The System feed itself is admin-only.
- `current-user.ts` `getTownhall`/"always first" wiring + the System community's user-facing detail page (`/community/the-commons`) → admin-only (redirect non-admins); **drop the `/communities` pin.**
- Existing townhall posts become admin-only history (minimal migration); old auto-join rows go vestigial.
- UI labels follow the un-named-feed principle (e.g. community-detail "Course Feed"/"Town Hall" tab labels from Conv 237 → reference parent, no proper feed names).
- ⚠️ **Client confirm flagged:** killing participatory townhall is an intended deletion of a built feature — get explicit sign-off. (Defensible: townhall's only unique value, platform-wide reach, is replaced by Announcements.)
- Adds rename/refactor scope to the prospective tasks (feed_type rename, drop Commons/TownHall naming across code + docs).

## RESOLVED (2026-06-10) — algo backbone vs. cursor (thread C)
**No conflict — Option-A cursor holds.** The existing pipeline already does **time-windowed fetch + algo-rank-within-window**: `getMemberCandidates` fetches the next recency batch (`created_at < cursor … LIMIT`), `scoreCandidates` ranks that batch by value, cursor advances by time. So "high-value algo" is the *ranking lens within each window*; time is the *pagination axis*. `(created_at, id)` cursor unchanged.
- **Rejected:** pure score-pagination ("best-ever first") — needs a stable ranked snapshot AND makes the feed feel stale (old post camping at top). Recency-windowed-with-quality is the right feed model.
- **Build-detail:** advance the cursor by the **oldest post *fetched* in the window, not the last *shown*** (current code uses last-shown — latent skip/dupe when scoring reorders); + the `(created_at,id)` tiebreaker.
- **Page-1 best-of-recent boost (DECIDED = B):** page 1 pulls top-scored posts from a slightly wider recent window (last 3–7d) so the feed *opens* on strongest content, then settles into pure time-window pagination from page 2. Page-1-only; no cursor impact.

## RESOLVED (2026-06-10) — promotion-economy cold-start (thread D)
**No special cold-start mode needed** — the always-full cascade + the *controllable* sources cover launch. At Genesis (~60–80 users, 4–5 courses): member/promoted/trending/popular are thin, but **New is abundant** (everything's new) and **Peerloop Picks + Announcements are fully admin-controllable**. So the launch feed leans on Picks + Announcements + New; algo sources fill in as activity accrues. Self-corrects (New narrows to a rolling window; Trending/Popular light up with history).
- **Operational, not architectural:** a **launch checklist** — admins seed Peerloop Picks + a few Announcements + ensure courses/communities surface via New.
- **Promotion economy bootstrapping** = behavioral/GTM; free escalation at launch (thread B) minimizes friction.
- **Promote-nudges DECIDED = B (in promotion MVP):** creator/teacher nudges to "promote this post" at high-engagement moments, built on the existing `ProgressionNudge` family — cheap given the framework, and directly seeds the promotion economy. → folded into `[PROMOTE-PIPELINE]` MVP.

## Net read
The **member smart-feed half is largely intact** (our S1 + discovery + mechanics survive, with the member backbone becoming algo-ranked). The **visitor half is substantially redirected** — from an algorithmic trending-public marketing feed to an admin-curated Announcement fan-out — which retires the Commons-anchor and the auto-new-entity-cards, and surfaces a real supply tension against our "always-full" call. And the model introduces a **net-new promotion/monetization pipeline** that is its own body of work upstream of feed display.

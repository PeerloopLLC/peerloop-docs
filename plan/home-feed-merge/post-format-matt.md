# [POST-MATT] — Post format, Matt design (spec capture)

**Status:** 🔨 BUILT (Conv 260, component-only) — resolved model below; primitives already existed (see § Resolved build model). `FeedPost` adapter + `SocialPost.feedLink` + `_FeedPostDemo` + 8 tests built, 5 gates green, browser-verified. NOT yet live-wired into SmartFeed (that's `[HOME-FEED-MERGE]` #28 phase 4). Part of `[HOME-FEED-MERGE]` / the feeds redesign.
**Figma:** fileKey `UpDNMiIEO8y3J7ZHkm356b` · **simple post** node `477:8285` · **complex post** node `477:8203`. (Asset URLs from the probe expire in 7 days — re-probe by node ID.)

---

## Resolved build model (Conv 260 — discussed + decided with user)

The Conv-258 spec assumed new primitives were needed. **They already existed** from the Conv-184 Matt component extraction:

| Spec "new" primitive | Already built (reuse) |
|---|---|
| Post shell | `SocialPost.tsx` (`@matt-source 40:528`) — header + body (+ Show More wired) + `embed` slot + footer |
| ReactionPill + comment pill | `AnalyticCount.tsx` (`516:15960`) — primary/light bg, `rounded-[33px]`, `#f6f6f6` zero-state, string-label support |
| Embedded entity card | `CourseAnchor.tsx` (`317:10557`) + 11 sibling Anchor types |
| Avatar role-tint | `UserIcon.tsx` (entity cascade) |
| Role chip | `IconLabelChip.tsx` |

**Decisions (Conv 260):**

1. **Scope = the Home aggregated feed only** (`/` SmartFeed). A post here is shown *out of its home feed*, mixed with marketing posts + discovery cards — it's a **teaser / social-proof preview**, not the conversation.
2. **Display-only.** Reaction + comment pills are **non-interactive social proof** (counts only). No reaction POST/DELETE, no inline `CommentSection` in the aggregated feed. This is *better product* (drives users into communities/courses = the flywheel) and sidesteps mixed-source reaction-API / optimistic-update / visitor-can't-react problems.
3. **Native feeds out of scope.** Course / community / system feeds keep their full inline interactivity on legacy `FeedActivityCard` (restyle is a separate later task).
4. **Two distinct, non-colliding click targets** — so the card is **NOT** a single click target:
   - **Embedded PostAnchor** → navigates to whatever *it* promotes (course/creator/etc.), via its own CTA. The anchor must stay independently clickable.
   - **"View in {feed}" affordance** → navigates to the post's *home feed* to actually participate. Placed in the header next to the timestamp (`Name · Creator · in The Commons · 2h`). This is an **ours-extension** — Matt's frame draws a single isolated post, so the feed-context link is not in his design.

**Build (Conv 260):**
- `SocialPost` extended with an optional `feedLink?: { label, href }` (renders `· in <a>{label}</a>` after timestamp; default undefined → existing callers byte-identical).
- `FeedPost.tsx` (`src/components/feed/`) — display-only adapter mapping the existing `Activity` shape → `SocialPost` + primitives (role→entity-tint/icon/label, reaction-taxonomy `like→👍 / love→💕 / celebrate→🎉` as display pills, comment count, embedded `CourseAnchor` when the post promotes a course, `feedLink` from the post's home feed). Drop-in for the SmartFeed render path so `[HOME-FEED-MERGE]` #28 phase 4 can consume it.
- Green CTA — **RESOLVED Conv 260: it is not a new variant.** Probed Matt's frame `477:8210`: the "Learn More" button binds `Color #327D00 / Background #E8F4DF`, which are exactly Peerloop's `--Course-Primary` (`--dark-green`) / `--Course-Background` (`--pastel-green`). The Course entity color *is* green, so `CourseAnchor`'s default `variant="course"` already renders Matt's green CTA. No token/variant work needed.
- **Not** wired into the live SmartFeed recomposition — that's `[HOME-FEED-MERGE]` #28 phase 4. POST-MATT delivers the component + dev-page verification.
- Folds in `[SHOWMORE]` #13 (body truncation — already on SocialPost's `showMore`).

## Shared card shell (both posts)
`border (border/default #eaeff5) · rounded-[12px] · p-[20px] · flex-col · gap-[20px]`. Three stacked regions: **header · body · reactions row** (complex adds an embedded entity card between body and reactions).

## Header row (`gap-6`, items-center)
- **Avatar chip** ("User Icon" — maps to existing `Avatar`/`UserIcon`): initials, rounded-[33px], **role-tinted bg + initials**: student/new = bg `#f1f9ff` + initials `#0777b6` (primary blue); creator = bg `#e0e8ff` + initials `#584df4` (creator purple). → avatar tint encodes role (ties to ROLE-SEMANTICS accent tokens). Simple = 39–41px, complex = 40px.
- **Name** — Body Medium Bold (Inter 16/600, tracking -0.352), black.
- **Role icon + label** — `how_to_reg` icon + "Joined PeerLoop" (new member) · `creator` gear icon + "Creator". Label = Body Small (12, text/tertiary `#767676`). Role-driven.
- **Timestamp** — bulleted (`list-disc`) "2h"/"1h", Body Small tertiary.

## Body
- Text = Body Default (Inter 14/400, text/default `#414141`); multi-paragraph + bullet lines supported.
- **"Show More" truncation** (complex post) — underlined link, primary `#0777b6`. → **directly ties to `[SHOWMORE]` #13** (build them together).

## Embedded entity card (complex post only, node `477:8210`)
A **course** card embedded *inside* the post — `border · rounded-[12px] · px-20 py-12`:
- `course` icon + title ("Intro to Claude Code", Body Medium Bold).
- meta row: creator icon + name · `stars_2` + "5.0 (1 review)" · `accessibility_new` + "Beginner".
- **"Learn More" Button** — note a **green variant** (bg `#e8f4df` / text `#327d00`) + right-arrow. (Check whether `Button` has this success/course-green variant or needs one.)
- 🔑 **This IS the "promote-a-course" content type / the feed "card"/"sample-post-with-CTA" variant we designed.** The embedded entity card + "Learn More" = the entity-promo in post form. Cross-links: `[PROMOTE-PIPELINE]` templates + `[HOME-FEED-MERGE]` render variants. A community promo would be the parallel template. **Reuse candidate:** existing `CourseCatalogCard`/`CourseCard` (compact variant) rather than a new inline card.

## Reactions row (`gap-10`)
- **Reaction pills** — emoji + count, `primary/light #f1f9ff` bg + border, rounded-[33px], primary text (👍 2 · 💕 1). Zero-count pill uses `#f6f6f6` bg.
- **Comment pill** — 💬 + "Matt commented" / "Matt and 1 other commented" (purple `#584df4` accent border). → likely a new `ReactionPill` primitive (emoji+count) + a comment-summary pill.

## Tokens seen
`border/default #eaeff5` · `primary #0777b6` · creator `#584df4` · `text/default #414141` · `text/tertiary #767676` · `primary/light #f1f9ff` · avatar bg tints `#f1f9ff`/`#e0e8ff` · course-green button `#e8f4df`/`#327d00`. Type: Body Medium Bold (16/600), Body Default (14/400), Body Small (12/400) — all Inter.

## Build notes / cross-links
- **Reuse, don't inline** (`feedback_reuse_existing_components`): Avatar/UserIcon, Button (+ verify green variant), CourseCatalogCard for the embedded entity. New primitives likely needed: `ReactionPill`, comment-summary pill, the post shell itself.
- Post shell is the container for the **3 feed-item variants** (member-post = this; sample-post = this + entity card + CTA; card-announcement). The complex post shows member-post + embedded-entity already unify into one component with optional regions.
- `[SHOWMORE]` #13 is the body-truncation behavior — fold in.
- Provenance: `@matt-source` (these ARE Matt frames — list both node IDs).

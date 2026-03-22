# RFC: CD-035 - UX & Pricing Changes

**Source:** [CD-035.md](./CD-035.md)
**Date:** 2026-01-09
**Status:** Open
**Client:** Brian

---

## Summary

Brian's directives covering 5 areas: vertical scroll feed UX, creator monthly fees, revenue split clarification, terminology standardization, and community time expectations.

---

## Change Requests

### 1. Vertical Scroll Feed (UI/UX)

**Core Change:** Replace course grid with single-column infinite scroll (like social feeds)

#### Pages Affected
- [ ] **HOME** - Course sections to vertical feed
- [ ] **CBRO** - Course browse (primary change)
- [ ] **CPRO** - Creator profile courses section
- [ ] **CRLS** - Creator listing (TBD - needs Brian confirmation)

#### Components
- [ ] **CourseBrowse.tsx** - Replace grid with single column
- [ ] **CourseBrowse.tsx** - Replace pagination with infinite scroll
- [ ] **CourseCard.tsx** - Consider horizontal/wider variant for feed layout
- [ ] Remove pagination UI entirely
- [ ] Remove "Showing X of Y courses" text

#### Documentation
- [ ] Update COMPONENTS.md - Remove grid references, add feed pattern
- [ ] Update page specs if they reference grid layout

#### Alternative Approach (Fraser 2026-01-09)
- [ ] **UI Toggle Component** - Add toggle near listings to switch between card grid and table-like infinite scroll
- [ ] Apply toggle pattern to all paginated/gridded listing areas

---

### 2. Creator Monthly Fee (Pricing)

**Core Change:** Introduce monthly creator fee (~$25/month TBD, free initially)

#### Implementation (Future - Not Immediate)
- [ ] **DB-SCHEMA.md** - Add creator_subscriptions table design
- [ ] **PRIC page** - Add creator fee section (when ready)
- [ ] **FCRE page** - Mention fee waiver during early access

#### Open Questions
- [ ] Confirm exact fee amount with Brian
- [ ] Confirm when to start showing fee messaging

---

### 3. Revenue Split Clarification (Copy)

**Core Change:** Clarify that 85% applies only when creator personally teaches

| Scenario | Creator | S-T | Platform |
|----------|---------|-----|----------|
| Creator teaches | 85% | - | 15% |
| S-T teaches | 15% | 70% | 15% |

#### Pages to Update
- [ ] **FCRE** - Change "Earn 85% of course sales" → "Earn 85% when you teach your course"
- [ ] **FCRE** - Clarify 15% royalty on S-T sessions as primary income
- [ ] **PRIC** - Update earnings calculator scenarios
- [ ] **HOWI** - Clarify Step 2 "you keep 85%" = when you teach
- [ ] **HOWI** - Verify Step 4 "15% of every tutoring session" wording

---

### 4. Terminology: Tutor → Student-Teacher (Global)

**Core Change:** Replace "tutor/tutoring" with "Student-Teacher" throughout

#### Search & Replace
- [ ] Global grep for "tutor" in all pages
- [ ] Global grep for "tutoring" in all pages
- [ ] Update marketing copy (FCRE, PRIC, HOWI, BTAT)
- [ ] Update user stories if any use "tutor"
- [ ] Update documentation

#### SEO Considerations
- [ ] Research new keyword targets (replace "peer tutoring")
- [ ] Update meta descriptions
- [ ] Update any SEO-targeted copy

---

### 5. Community Time Expectations (Copy)

**Core Change:** Balance "passive income" messaging with reality of community management

#### Updates
- [ ] **FCRE** - Add mention of community management responsibilities
- [ ] **FCRE** - Reference moderator assignment feature
- [ ] Review other passive income claims for accuracy

---

## Open Questions for Brian

| # | Question | Status | Answer |
|---|----------|--------|--------|
| 1 | Should CRLS (Creator Listing) also be vertical scroll? | Open | |
| 2 | For vertical feed, wider/horizontal cards or keep current shape? | Open | |
| 3 | What SEO keywords should replace "peer tutoring"? | Open | |
| 4 | When should we add monthly fee messaging to pages? | Open | |

---

## Implementation Priority

| Priority | Item | Effort |
|----------|------|--------|
| High | Vertical scroll feed (CourseBrowse refactor) | Medium |
| High | Remove pagination | Low |
| High | Tutor → Student-Teacher terminology | Low |
| Medium | Revenue split copy updates | Low |
| Low | Monthly fee documentation | Low |
| Deferred | Creator subscriptions DB/billing | High |

---

## Completion Tracking

- **Total Items:** 30
- **Completed:** 0
- **Remaining:** 30
- **Last Updated:** 2026-01-09

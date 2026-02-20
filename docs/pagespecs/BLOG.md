# Page: Blog

**Code:** BLOG
**URL:** `/blog`
**Access:** Public
**Priority:** P3
**Status:** Spec Only (Future)

---

## Purpose

Content marketing hub for articles about learning, teaching, career development, and Peerloop updates.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| HOME | "Blog" link | Footer/nav |
| External | SEO/social | Content discovery |
| Email | Newsletter links | Marketing |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CBRO | "Browse Courses" CTA | In articles |
| CDET | Course links | Related courses |
| SGUP | "Sign Up" CTA | Conversion |

---

## Sections

### Blog Index (`/blog`)

**Header:**
- Blog title
- Search bar
- Category filter

**Featured Post:**
- Large hero card
- Image, title, excerpt
- Author, date

**Recent Posts Grid:**
- Image thumbnail
- Title
- Excerpt
- Author avatar + name
- Date
- Category tag
- Read time

**Categories Sidebar:**
- Learning Tips
- Career Development
- Student-Teacher Spotlight
- Creator Stories
- Platform Updates

**Pagination:**
- Load more or numbered pages

### Blog Post (`/blog/:slug`)

**Article:**
- Title
- Featured image
- Author info (avatar, name, bio)
- Publish date
- Read time
- Content (rich text/MDX)
- Tags/categories

**Sidebar:**
- Related posts
- Newsletter signup
- Popular posts

**Footer:**
- Author bio
- Share buttons
- Related courses CTA
- Comments (optional)

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| blog_posts | All | Post content |
| blog_authors | name, avatar, bio | Author info |
| blog_categories | name, slug | Categorization |

---

## Implementation Options

1. **Static (MDX):** Blog posts as MDX files, built at deploy
2. **Headless CMS:** Contentful, Sanity, etc.
3. **Custom:** D1 table for posts with admin editor

---

## Notes

- SEO is primary driver for blog
- Consider RSS feed
- Newsletter signup integration
- Social sharing important
- May defer to Phase 2+

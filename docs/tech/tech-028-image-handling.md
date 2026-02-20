# Image Handling Architecture

**Created:** 2026-02-16 (Session 215)
**Status:** Active — Plain `<img>` tags with R2 storage. Optimization deferred to post-MVP.

## Overview

Peerloop stores images in Cloudflare R2 and renders them with standard HTML `<img>` tags. No image transformation, responsive srcsets, or CDN optimization is applied. This decision was made intentionally for MVP — the image volume is low and the complexity of an optimization pipeline is not justified yet.

## Current Architecture

### Storage

**Cloudflare R2** is the sole image storage backend.

- Course thumbnails are uploaded via `POST /api/me/courses/[id]/thumbnail` and stored in R2 at `courses/{courseId}/thumbnail/{timestamp}.{ext}`
- Images are served through a proxy route: `/api/storage/{key}`
- Allowed types: JPEG, PNG, WebP, GIF
- Max size: 5MB per thumbnail

### Schema: Image URL Columns

| Table | Column | Source | Upload Endpoint |
|-------|--------|--------|-----------------|
| `users` | `avatar_url` | OAuth provider or manual | None (set via DB or OAuth callback) |
| `categories` | `cover_image_url` | Seed data | None |
| `courses` | `thumbnail_url` | R2 upload | `POST /api/me/courses/[id]/thumbnail` |
| `course_modules` | `thumbnail_url` | Not yet used | None |
| `team_members` | `avatar_url` | Seed data | None |

### Rendering

All images use plain `<img>` tags:

```tsx
// Course thumbnail
<img src={thumbnail_url} alt={title} className="h-full w-full object-cover" />

// Avatar with fallback
<img
  src={avatar_url || `https://placehold.co/100x100/0ea5e9/white?text=${name.charAt(0)}`}
  alt={name}
  className="h-6 w-6 rounded-full object-cover"
/>
```

### What Is NOT Used

- Astro's `<Image>` component — not imported anywhere
- Astro's `getImage()` function — not called anywhere
- Astro's image service (sharp) — disabled via `no-op` config
- No responsive `srcset` generation
- No WebP/AVIF format conversion
- No lazy loading beyond browser `loading="lazy"` defaults

## Astro Image Service: Disabled

The Cloudflare adapter warns about sharp not being available at runtime. Since we don't use Astro's image pipeline, the service is set to `no-op`:

```javascript
// astro.config.mjs
image: {
  service: {
    entrypoint: 'astro/assets/services/no-op',
  },
},
```

This suppresses the warning and explicitly declares that Astro should not attempt image optimization.

## Post-MVP: Optimization Options

When traffic grows and image performance matters, three options were evaluated:

### Option A: Cloudinary (Recommended for Rich Transforms)

**What:** External SaaS for image storage, transformation, and delivery.
**URL-based transforms:** `https://res.cloudinary.com/{cloud}/image/upload/w_400,h_300,c_fill,f_auto,q_auto/v1/image.jpg`

| Pros | Cons |
|------|------|
| Best-in-class transform API (crop, face detection, overlays, video) | Another vendor and billing |
| Generous free tier (25K transforms/mo, 25GB bandwidth) | Not Cloudflare-native |
| URL-based — no server-side code needed | Migration: re-upload or use fetch-from-R2 |
| React SDK available | Paid tier starts ~$89/mo |

**Migration path:** Either re-upload images to Cloudinary, or configure Cloudinary to fetch from R2 as origin. Update stored URLs or add a helper to generate Cloudinary transform URLs from R2 keys.

### Option B: Cloudflare Image Resizing (Recommended for CF Ecosystem)

**What:** Cloudflare's built-in image transform at the edge, pulling from R2.
**URL-based transforms:** `/cdn-cgi/image/width=400,format=auto,quality=80/your-r2-image.jpg`

| Pros | Cons |
|------|------|
| Native to Cloudflare — no new vendor | Pricing: $0.50 per 1K unique transforms |
| Uses existing R2 as origin | Fewer transform options than Cloudinary |
| Edge-cached results | Requires CF pro plan or images add-on |
| No code changes to storage layer | Less mature ecosystem |

**Migration path:** Minimal — images already in R2. Add a URL helper to prefix R2 URLs with `/cdn-cgi/image/` params. No re-upload needed.

### Option C: Cloudflare Images (Managed)

**What:** Cloudflare's managed image hosting with pre-defined variants.
**Pricing:** $5/mo for 100K stored images, $1/100K deliveries.

| Pros | Cons |
|------|------|
| Simple variant-based API | Pre-defined variants (not as flexible as URL params) |
| Integrated with CF dashboard | Separate storage from R2 |
| Good for known sizes (thumbnail, avatar, hero) | Would need to maintain both R2 and CF Images |

**Not recommended** — duplicates R2 storage and adds complexity.

## Decision Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-02-16 | Plain `<img>` + R2 for MVP | Low image volume (~4 courses, <10 users). Optimization adds complexity with no measurable benefit yet. |
| 2026-02-16 | Astro image service set to `no-op` | Not using `<Image>` component. Suppresses Cloudflare sharp warning. |
| 2026-02-16 | Cloudinary and CF Image Resizing deferred | Both viable post-MVP. Decision depends on traffic patterns and transform needs. |

## When to Revisit

- First real user uploads (avatar, course thumbnails) — are images too large / slow?
- Mobile performance audit — are unoptimized images causing layout shift or slow loads?
- Image count exceeds ~100 — manual management becomes unwieldy
- Video thumbnails needed — Cloudinary handles video transforms too

## References

- `src/pages/api/me/courses/[id]/thumbnail.ts` — R2 upload endpoint
- `src/lib/r2.ts` — R2 utility functions
- `src/components/courses/CourseCard.tsx` — Image rendering with fallback
- `src/components/messages/Avatar.tsx` — Avatar rendering with fallback
- Cloudinary: https://cloudinary.com/documentation
- Cloudflare Image Resizing: https://developers.cloudflare.com/images/transform-images/
- Cloudflare Images: https://developers.cloudflare.com/images/

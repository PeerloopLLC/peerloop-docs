---
description: Project-specific git history summary guidance (extends /q-git-history)
argument-hint: ""
---

# Peerloop Git History Summary

**Extends:** `/q-git-history` (that skill calls this one at Step 6)

**Configuration** comes from `.claude/config.json`.

This skill provides guidance on what client-facing changes to highlight in commit summaries.

---

## Client Perspective Categories

Git commits are technical. For each commit, also note changes that would be noticed by a **user** or **administrator**:

| Category | What to Highlight |
|----------|-------------------|
| **User-visible** | New pages, UI changes, new features |
| **User flows** | Login changes, checkout improvements, booking updates |
| **Admin capabilities** | New admin tools, moderation features, dashboard updates |
| **Monitoring** | New logging, error handling, analytics |
| **Performance** | Speed improvements, optimization |
| **SEO/Marketing** | Meta tags, CTAs, landing page changes |

---

## Summary Line Format

Add a summary bullet prefixed with the audience:

```
- for Users: ability to book sessions from teacher profile
- for Admin: new payout approval dashboard
- for Creators: course analytics now show completion rates
```

---

## Peerloop-Specific Highlights

Pay special attention to:

| Area | Examples |
|------|----------|
| **Pages** | New pages added/removed, PageSpecView → implemented |
| **Payments** | Stripe integration, refunds, payouts |
| **Video** | Session booking, video room changes |
| **Courses** | Course display, enrollment, certification |
| **Teacher features** | Teacher dashboard, availability, earnings |
| **Admin** | User management, course moderation, reports |

---

## Notes

- Not every commit needs a client summary (skip for pure refactoring)
- Focus on what the user/admin would *experience*, not technical details
- Use Peerloop terminology (Teacher, Creator, etc. — see GLOSSARY.md)

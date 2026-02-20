# HOME - Dashboard Homepage

| Field | Value |
|-------|-------|
| Route | `/` |
| Access | Public |
| Priority | P0 |
| Status | ✅ Implemented |
| Block | - |
| Astro Page | `src/pages/index.astro` |
| Component | `src/components/dash/` (DashNavbar, FeedSlidePanel, MoreSlidePanel) |
| JSON Spec | `src/data/pages/index.json` |

---

## Purpose

Role-aware dashboard hub with persistent sidebar navigation. Main entry point for all users (visitors and authenticated). Marketing content is at `/welcome` (WELC).

---

## History

- **2026-01-29**: Changed from marketing page to dashboard (Session 145)
- **Previous**: Marketing landing page (now at /welcome)

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| (External) | Direct URL, search engines | Primary entry point |
| Any page | Logo click | Global navigation |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| DDSC | Discover nav item | Browse courses and content | ✅ |
| DCRS | My Courses nav item | View enrolled courses | ✅ |
| DMSG | Messages nav item | View messages | ✅ |
| DNTF | Notifications nav item | View notifications | ✅ |
| DWRK | Workspace nav item | ST/Creator workspace | ✅ |
| DPRF | Profile nav item | View/edit profile | ✅ |
| WELC | Marketing link | Marketing/landing page | ✅ |
| SGUP | Get Started CTA | Visitor signup | ✅ |
| LGIN | Log In link | Visitor login | ✅ |

---

## Features

### Layout Shell
- [x] Persistent left navbar (256px / w-64)
- [x] Role-based menu items
- [x] Mobile hamburger menu
- [x] Light/dark mode support

### Slide-Out Panels
- [x] FeedSlidePanel (full height) - community selection
- [x] MoreSlidePanel (smaller) - settings, help, logout
- [x] Search communities
- [x] Escape key to close panels

### Role-Based Rendering
- [x] Visitor: Limited menu + marketing CTAs
- [x] Student: Full student menu
- [x] Student-Teacher: + Workspace
- [x] Creator: + Workspace

### Main Content
- [x] Welcome message
- [x] Quick Start Cards (Discover, My Courses, Messages)
- [x] Recent Activity section (placeholder)

---

## Sections

### Left Navbar
- Logo
- User info (if logged in)
- My Feeds (with arrow) - opens FeedSlidePanel
- Discover
- My Courses
- Messages
- Notifications
- Workspace (ST/Creator only)
- Profile
- More - opens MoreSlidePanel

### Feed Slide Panel
- Header with close button
- Search input
- PUBLIC section (The Commons, Announcements, Help)
- MY COMMUNITIES section
- Browse All Communities link

### More Slide Panel
- Settings link
- Help Center link
- Privacy Policy link
- Toggle Dark Mode
- Sign Out (if authenticated)

### Main Content Area
- Welcome message
- Quick Start Cards grid (3 columns)
- Recent Activity section

---

## States & Variations

| State | Description | Status |
|-------|-------------|--------|
| Visitor | Limited menu, marketing CTAs, sample communities | ✅ |
| Student | Full student menu, personal communities | ✅ |
| Student-Teacher | Student items + Workspace | ✅ |
| Creator | Student items + Workspace | ✅ |
| Loading | Skeleton menu items | ✅ |

---

## Mobile Considerations

- Hamburger menu in fixed header
- Sidebar slides in from left
- Full-screen overlays for panels
- Touch-friendly tap targets

---

## Implementation Notes

- Does NOT redirect unauthenticated users
- Marketing content moved to /welcome (WELC) in Session 145
- Persistent sidebar navigation using DashLayout
- Two slide-out panels: My Feeds (full height), More (smaller)
- Session data fetched client-side for role-based rendering

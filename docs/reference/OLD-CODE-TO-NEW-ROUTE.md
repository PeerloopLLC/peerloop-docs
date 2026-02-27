# OLD-CODE-TO-NEW-ROUTE.md

**Purpose:** Translation table mapping old page codes (ORIG-PAGES-MAP.md) to current routes (tech-021-url-routing.md).
**Created:** Session 306 (2026-02-27)
**Used by:** ROUTE-STORIES.md (canonical story mapping)

---

## Translation Table

| Old Code | Old Page Name | Old Route | New Route(s) | Notes |
|----------|--------------|-----------|--------------|-------|
| **Root / Auth** | | | | |
| HOME | Home | `/` | `/` | Unchanged |
| LGIN | Login | `/login` | `/login` | Now modal over AppLayout |
| SGUP | Sign Up | `/signup` | `/signup` | Now modal over AppLayout |
| PWRS | Password Reset | `/reset-password` | `/reset-password` | Unchanged |
| WELC | Welcome | `/welcome` | `/welcome` | Not yet implemented |
| PROF | Profile | `/profile` | `/profile` → `/@[handle]` | Redirect; universal profile |
| MSGS | Messages | `/messages` | `/messages` | Unchanged |
| NOTF | Notifications | `/notifications` | `/notifications` | Unchanged |
| LEAD | Leaderboard | `/leaderboard` | `/discover/leaderboard` | Moved under discover |
| **Marketing** | | | | |
| ABOU | About Us | `/about` | `/about` | Unchanged |
| HOWI | How It Works | `/how-it-works` | `/how-it-works` | Unchanged |
| PRIC | Pricing | `/pricing` | `/pricing` | Unchanged |
| FAQP | FAQ | `/faq` | `/faq` | Unchanged |
| FCRE | For Creators | `/for-creators` | `/for-creators` | Unchanged |
| BTAT | Become a Teacher | `/become-a-teacher` | `/become-a-teacher` | Unchanged |
| CONT | Contact Us | `/contact` | `/contact` | Unchanged |
| PRIV | Privacy Policy | `/privacy` | `/privacy` | Unchanged |
| TERM | Terms of Service | `/terms` | `/terms` | Unchanged |
| STOR | Success Stories | `/stories` | `/stories` | Unchanged |
| TSTM | Testimonials | `/testimonials` | `/testimonials` | Unchanged |
| **Courses** | | | | |
| CBRO | Course Browse | `/courses` | `/discover/courses` | Browse moved to discover |
| CDET | Course Detail | `/courses/:slug` | `/course/[slug]` | Plural→singular |
| CCNT | Course Content | `/courses/:slug/learn` | `/course/[slug]/learn` | Under singular course |
| CDIS | Course Discussion | `/courses/[slug]/discuss` | `/course/[slug]/feed` | Renamed to feed |
| CSUC | Enrollment Success | `/courses/:slug/success` | `/course/[slug]/success` | Under singular course |
| SBOK | Session Booking | `/courses/[slug]/book` | `/course/[slug]/book` | Under singular course |
| **Creators** | | | | |
| CRLS | Creator Listing | `/creators` | `/discover/creators` | Moved to discover |
| CPRO | Creator Profile | `/creators/:handle` | `/creator/[handle]` | Plural→singular |
| **Teachers** | | | | |
| STDR | ST Directory | `/teachers` | `/discover/teachers` | Moved to discover |
| STPR | ST Profile | `/teachers/[handle]` | `/teacher/[handle]` | Plural→singular |
| **Community** | | | | |
| FEED | Community Feed | `/community` | `/community`, `/community/[slug]` | Now per-community; The Commons is default |
| IFED | Instructor Feed | `/community/[instructor]` | `/community/[slug]` | Creators use communities, not personal feeds |
| **Session** | | | | |
| SROM | Session Room | `/session/[id]` | `/session/[id]` | Unchanged |
| **Settings** | | | | |
| SETT | Settings Hub | `/settings` | `/settings` | Unchanged |
| SPRF | Profile Settings | `/settings/profile` | `/settings/profile` | Unchanged |
| SNOT | Notification Settings | `/settings/notifications` | `/settings/notifications` | Unchanged |
| SPAY | Payment Settings | `/settings/payments` | `/settings/payments` | Unchanged |
| SSEC | Security Settings | `/settings/security` | `/settings/security` | Unchanged |
| **Dashboard - Learning** | | | | |
| SDSH | Student Dashboard | `/dashboard/learning` | `/learning` | Activity namespace |
| **Dashboard - Teaching** | | | | |
| TDSH | ST Dashboard | `/dashboard/teaching` | `/teaching` | Activity namespace |
| CMST | My Students (Creator) | `/dashboard/teaching/students` | `/teaching/students` | Under teaching |
| CSES | Session History | `/dashboard/teaching/sessions` | `/teaching/sessions` | Under teaching |
| CEAR | Earnings Detail | `/dashboard/teaching/earnings` | `/teaching/earnings` | Under teaching |
| TANA | ST Analytics | `/dashboard/teaching/analytics` | `/teaching/analytics` | Under teaching |
| **Dashboard - Creator** | | | | |
| CDSH | Creator Dashboard | `/dashboard/creator` | `/creating` | Activity namespace |
| STUD | Creator Studio | `/dashboard/creator/studio` | `/creating/studio` | Under creating |
| CANA | Creator Analytics | `/dashboard/creator/analytics` | `/creating/analytics` | Under creating |
| **Admin** | | | | |
| ADMN | Admin Dashboard | `/admin` | `/admin` | Unchanged |
| AUSR | Admin Users | `/admin/users` | `/admin/users` | Unchanged |
| ACRS | Admin Courses | `/admin/courses` | `/admin/courses` | Unchanged |
| AENR | Admin Enrollments | `/admin/enrollments` | `/admin/enrollments` | Unchanged |
| ASES | Admin Sessions | `/admin/sessions` | `/admin/sessions` | Unchanged |
| ACRT | Admin Certificates | `/admin/certificates` | `/admin/certificates` | Unchanged |
| APAY | Payout Management | `/admin/payouts` | `/admin/payouts` | Unchanged |
| ACAT | Admin Categories | `/admin/categories` | `/admin/categories` | Unchanged |
| AANA | Admin Analytics | `/admin/analytics` | `/admin/analytics` | Unchanged |
| AMOD | Admin Moderation | `/admin/moderation` | `/admin/moderation` | Unchanged |
| **Moderator** | | | | |
| MODQ | Moderator Queue | `/mod` | `/mod` | Unchanged |
| **Other** | | | | |
| CVER | Certificate Verify | `/verify/:id` | `/verify/[id]` | Unchanged |
| MINV | Moderator Invite | `/invite/mod/[token]` | `/invite/mod/[token]` | Unchanged (implied) |
| DCRS | My Courses | `/dash/courses` | `/courses` | Bare route = my stuff |
| DDSC | Discover | `/dash/discover` | `/discover` | Top-level discover hub |
| DMSG | Messages | `/dash/messages` | `/messages` | Bare route |
| DNTF | Notifications | `/dash/notifications` | `/notifications` | Bare route |
| DPRF | Profile | `/dash/profile` | `/@[handle]` | Universal profile |
| DWRK | Workspace | `/dash/workspace` | — | Absorbed into role dashboards |

---

## On-Hold Pages (no current route)

| Old Code | Old Page Name | Old Route | Status |
|----------|--------------|-----------|--------|
| HELP | Summon Help | `/help` | Post-MVP (goodwill feature) |
| BLOG | Blog | `/blog` | Post-MVP |
| CARE | Careers | `/careers` | Post-MVP |
| CHAT | Course Chat | `/courses/:slug/chat` | Post-MVP (real-time chat) |
| CNEW | Creator Newsletters | `/dashboard/creator/newsletters` | Post-MVP |
| SUBCOM | Sub-Community | `/groups/[id]` | Post-MVP |

---

## New Routes (no old page code)

These routes exist in the current architecture but had no equivalent in the original page system.

| New Route | Purpose | Category |
|-----------|---------|----------|
| `/@[handle]` | Universal profile | Resource |
| `/@me` | Shortcut → own profile | Resource |
| `/discover` | Discovery hub page | Discovery |
| `/discover/students` | Student directory | Discovery |
| `/discover/communities` | Community discovery | Discovery |
| `/feed` | Aggregated personalized feed | Personal |
| `/onboarding` | Interests & preferences | Personal |
| `/learning` | Student dashboard (renamed from SDSH) | Personal |
| `/teaching` | ST dashboard (renamed from TDSH) | Personal |
| `/teaching/availability` | ST availability management | Personal |
| `/creating` | Creator dashboard (renamed from CDSH) | Personal |
| `/creating/apply` | Creator application form | Personal |
| `/creating/communities` | Creator community management | Personal |
| `/creating/communities/[slug]` | Community detail (progressions, settings) | Personal |
| `/creating/earnings` | Creator earnings | Personal |
| `/community/[slug]/courses` | Community courses tab | Resource |
| `/community/[slug]/resources` | Community resources tab | Resource |
| `/community/[slug]/members` | Community members tab | Resource |
| `/course/[slug]/teachers` | Course S-T directory tab | Resource |
| `/course/[slug]/resources` | Course materials & downloads | Resource |
| `/course/[slug]/feed` | Course discussion feed | Resource |
| `/admin/creator-applications` | Creator app review | Admin |
| `/admin/moderators` | Moderator management | Admin |

---

## Migration Summary

| Change Type | Count |
|-------------|-------|
| Unchanged routes | 28 |
| Renamed/moved routes | 24 |
| On-hold (no current route) | 6 |
| Absorbed into other routes | 1 (DWRK) |
| New routes (no old code) | 23 |
| **Total old codes** | **59** |
| **Total current routes** | **~75** |

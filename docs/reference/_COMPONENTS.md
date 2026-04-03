# PeerLoop - Component Library

**Version:** v3
**Last Updated:** 2026-04-03
**Status:** GATHER Phase - Accumulating from source documents
**Primary Source:** CD-021 (Database Schema Sample), CD-002 (Feature Summary)

> This document catalogs reusable UI components. During RUN phase, scenarios may specify different component implementations based on technology choices.

---

## Component Overview

Components are organized by function:
- **Cards** - Display entities in list/grid views
- **Profiles** - User profile displays
- **Course** - Course-specific components
- **Forms** - Input and editing components
- **Navigation** - App structure and navigation
- **Feed** - Community feed components
- **Session** - Video/scheduling components
- **Common** - Shared utility components

---

## Cards

### CourseCard

Displays course in browse/listing views.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Browse, Creator Profile, Dashboard, Related Courses |
| **Data Source** | courses, users (creator) |
| **Source** | CD-021 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| course | Course | Yes | Course object |
| variant | 'default' \| 'compact' \| 'horizontal' | No | Display variant |
| showCreator | boolean | No | Show creator info |

**Display Fields (from CD-021, CD-022):**
- thumbnail_url (image)
- badge (CourseBadge overlay - from CD-022)
- title
- level (badge: Beginner/Intermediate/Advanced)
- rating (stars + number)
- rating_count (review count - from CD-022)
- student_count
- price
- duration
- creator name + avatar (optional)

**Actions:**
- Click → Course Detail page
- Follow button (if authenticated)

---

### CreatorCard

Displays creator in listing views.

| Attribute | Value |
|-----------|-------|
| **Used On** | Creator Listing, Search Results |
| **Data Source** | users, user_expertise, user_stats |
| **Source** | CD-021 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| creator | User | Yes | Creator user object |
| variant | 'default' \| 'compact' | No | Display variant |

**Display Fields (from CD-021):**
- avatar_url
- name
- title
- expertise tags (first 3-4)
- stats.students_taught
- stats.courses_created
- stats.average_rating

**Actions:**
- Click → Creator Profile page
- Follow button

---

### TeacherCard

Displays Teacher for selection/listing.

| Attribute | Value |
|-----------|-------|
| **Used On** | Teacher Directory, Course Detail (Teacher section), Session Booking |
| **Data Source** | users, teacher_certifications |
| **Source** | CD-021, CD-018 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| teacher | TeacherCertification | Yes | Teacher certification record with user |
| course | Course | No | Course context |
| showAvailability | boolean | No | Show availability preview |

**Display Fields (from CD-021):**
- avatar_url
- name
- "Teaching" badge
- students_taught
- certified_date
- courses certified (list)
- availability preview (optional)

**Actions:**
- Click → Teacher Profile page
- Book Session button

---

### EnrolledCourseCard

Displays enrolled course with progress on dashboard.

| Attribute | Value |
|-----------|-------|
| **Used On** | Student Dashboard |
| **Data Source** | enrollments, courses, module_progress |
| **Source** | CD-019 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| enrollment | Enrollment | Yes | Enrollment with course |
| progress | number | Yes | Completion percentage |

**Display Fields:**
- thumbnail_url
- title
- Progress bar (% complete)
- Next module title
- Next session (if scheduled)

**Actions:**
- Continue Learning → Course Content
- Schedule Session → Booking

---

### SessionCard

Displays upcoming/past session.

| Attribute | Value |
|-----------|-------|
| **Used On** | Dashboard, Session History |
| **Data Source** | sessions, users |
| **Source** | CD-014, CD-015 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| session | Session | Yes | Session object |
| role | 'student' \| 'teacher' | Yes | User's role in session |

**Display Fields:**
- Date/time
- Other participant (avatar, name)
- Course title
- Status badge
- Duration

**Actions:**
- Join (if in_progress or starting soon)
- Reschedule
- Cancel

---

## Profile Components

### ProfileHeader

Large profile header with key info.

| Attribute | Value |
|-----------|-------|
| **Used On** | Creator Profile, Teacher Profile, Own Profile |
| **Data Source** | users |
| **Source** | CD-021, CD-018 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| user | User | Yes | User object |
| isOwnProfile | boolean | No | Show edit controls |
| showFollowButton | boolean | No | Show follow CTA |

**Display Fields:**
- avatar_url (large)
- name
- handle (@username)
- title
- bio
- website (link)
- Role badges (Creator, Teaching)
- Follower/following counts

**Actions:**
- Follow/Unfollow
- Edit Profile (if own)
- Message

---

### QualificationsList

Displays user qualifications/credentials.

| Attribute | Value |
|-----------|-------|
| **Used On** | Creator Profile, Teacher Profile |
| **Data Source** | user_qualifications |
| **Source** | CD-021 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| qualifications | Qualification[] | Yes | List of qualifications |

**Display Fields (from CD-021):**
- sentence (credential statement)
- Ordered list display

---

### ExpertiseTags

Displays expertise/specialty tags.

| Attribute | Value |
|-----------|-------|
| **Used On** | Creator Profile, CreatorCard, Teacher Profile |
| **Data Source** | user_expertise |
| **Source** | CD-021, US-C036 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| tags | string[] | Yes | Expertise tags |
| limit | number | No | Max tags to show |
| clickable | boolean | No | Tags link to search |

**Display:**
- Pill/chip style tags
- "+N more" if truncated

---

### StatsDisplay

Displays user statistics.

| Attribute | Value |
|-----------|-------|
| **Used On** | Creator Profile, CreatorCard, Teacher Profile |
| **Data Source** | user_stats |
| **Source** | CD-021 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| stats | UserStats | Yes | Stats object |
| layout | 'row' \| 'grid' | No | Layout style |

**Display Fields (from CD-021):**
- students_taught (with label)
- courses_created (creators only)
- average_rating (stars)
- total_reviews

---

## Course Components

### LearningObjectivesList

Displays "What You'll Learn" section.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Detail |
| **Data Source** | course_objectives |
| **Source** | CD-021, US-S059 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| objectives | string[] | Yes | Learning objectives |

**Display (from CD-021):**
- Checkmark icon + objective text
- List format

---

### CourseIncludesList

Displays "What's Included" section.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Detail |
| **Data Source** | course_includes |
| **Source** | CD-021, US-S060 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| includes | string[] | Yes | Included items |

**Display (from CD-021 sample):**
- Icon + item text
- Items like: Full course access, 1-on-1 peer teaching sessions, Certificate on completion, etc.

---

### ModuleAccordion

Displays an individual course module as an expandable card with visual state indicators.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Detail (Learn tab) |
| **Data Source** | course_curriculum, enrollment_progress, sessions |
| **Source** | CD-021, Session 379 (COURSE-PAGE-MERGE) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| module | CurriculumModule | Yes | Module data |
| progress | ModuleProgress | No | Completion state for this module |
| session | SessionInfo | No | Booked/completed session info |
| isExpanded | boolean | No | Whether accordion is open |
| onToggle | () => void | No | Toggle callback |

**4 Visual States:**
- **Completed** — checkmark icon, muted styling
- **Future** — default styling, no session info
- **Future + Booked** — session date + teacher name displayed
- **Expanded** — full content visible with chevron rotation

**Display Fields:**
- title, description, duration
- Session date and teacher name (if booked)
- Completion indicator
- Chevron expand/collapse icon

---

### LearnTab

Manages the Learn tab on course detail pages — accordion list of modules with progress tracking.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Detail (Learn tab, enrolled only) |
| **Data Source** | course_curriculum, enrollment_progress, sessions |
| **Source** | Session 379 (COURSE-PAGE-MERGE) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| courseId | string | Yes | Course ID |
| enrollmentId | string | Yes | Enrollment ID |

**Features:**
- Parallel data fetch (modules + progress + sessions)
- Progress bar with percentage
- Module list using ModuleAccordion components
- Course completion celebration when all modules done
- Content is never locked — students browse freely; only session order is gated

---

### LevelBadge

Displays course difficulty level.

| Attribute | Value |
|-----------|-------|
| **Used On** | CourseCard, Course Detail |
| **Data Source** | courses.level |
| **Source** | CD-021, US-S057 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| level | 'beginner' \| 'intermediate' \| 'advanced' | Yes | Difficulty level |

**Display:**
- Color-coded badge
- Beginner (green), Intermediate (yellow), Advanced (red)

---

### CategoryBadge

Displays course category.

| Attribute | Value |
|-----------|-------|
| **Used On** | CourseCard, Course Detail, Filters |
| **Data Source** | categories |
| **Source** | CD-021, US-S058 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| category | Category | Yes | Category object |
| clickable | boolean | No | Links to filtered browse |

---

### CourseBadge

Displays promotional badge on course cards.

| Attribute | Value |
|-----------|-------|
| **Used On** | CourseCard, Course Detail |
| **Data Source** | courses.badge |
| **Source** | CD-022 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| badge | 'popular' \| 'new' \| 'bestseller' \| 'featured' \| null | Yes | Badge type |

**Display:**
- Colored ribbon/chip overlay on course card
- Popular (orange), New (green), Bestseller (gold), Featured (blue)
- Null = no badge displayed

---

### PeerLoopFeatures

Displays PeerLoop-specific course features.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Detail |
| **Data Source** | peerloop_features |
| **Source** | CD-021 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| features | PeerLoopFeatures | Yes | Features object |

**Display (from CD-021):**
- 1-on-1 peer teaching available
- Certified teachers
- Earn while teaching
- Teacher commission (70%)

---

### CourseTeachers

Displays Teachers for a specific course.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Detail |
| **Data Source** | teacher_certifications |
| **Source** | CD-021, US-S061 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| courseId | string | Yes | Course ID |
| teachers | TeacherCertification[] | Yes | Teacher list for course |

**Display (from CD-021):**
- List of TeacherCards
- Or compact list: name, students_taught, certified_date
- CTA: Book with this Teacher

---

### CourseAvailabilityPreview

Displays teacher availability summary on course detail page. Shows teacher cards with slot counts and next-available dates for the configurable availability window. Shown to non-enrolled users to help them make informed enrollment decisions.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Detail (About tab, non-enrolled users only) |
| **Data Source** | `/api/courses/:id/availability-summary` |
| **Source** | Conv 008 (ENROLL-AVAIL block) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| courseId | string | Yes | Course ID to fetch availability for |

**States:**
- **Loading** — skeleton cards (2 placeholders)
- **No teachers** — "No teachers yet" message
- **No availability** — amber warning: teachers exist but none have slots in the window; soft message ("You can still enroll")
- **Has availability** — grid of teacher cards with slot counts

**Teacher Card Display:**
- Avatar (or initial fallback)
- Name, rating (stars), students taught
- Slot count ("3 slots available") with next-available date ("Next: Tomorrow")
- Paused teachers (`teaching_active=0`) show 0 slots

**Layout:** 2-column responsive grid (`sm:grid-cols-2`)

---

### EnrollButton

Handles the full course enrollment flow with state-aware rendering. Checks authentication, role, and enrollment status to display the appropriate action or message.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Detail (CourseHero) |
| **Data Source** | `getCurrentUser()`, `/api/courses/:id/availability-summary`, `/api/checkout/create-session` |
| **Source** | Conv 008 (ENROLL-AVAIL block) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| courseId | string | Yes | Course ID |
| courseSlug | string | Yes | Course slug (for navigation) |
| priceCents | number | Yes | Course price in cents |
| currency | string | No | Currency code (default: `'USD'`) |
| teacherId | string | No | Teacher certification ID |
| creatorId | string | No | Course creator's user ID |
| className | string | No | Additional CSS classes |

**9 States (EnrollmentState):**
| State | Display | Behavior |
|-------|---------|----------|
| `loading` | Spinner + "Loading..." | Disabled button |
| `not-authenticated` | "Enroll Now - $XX" | Redirects to `/signup?redirect=...` |
| `is-creator` | "You created this course" | Static message (disabled) |
| `is-active-teacher` | "You teach this course" | Static message (disabled) |
| `enrolled` | "Go to Course" (green) | Links to `/course/[slug]/learn` |
| `completed` | "Retake Course - $XX" (amber) | Shows confirmation dialog before checkout |
| `no-teachers` | "Enrollment Unavailable" | Disabled + "No teachers available" message |
| `can-enroll` | "Enroll Now - $XX" (primary) | Creates Stripe checkout session |
| `error` | "Retry" (red) | Shows error message, retries status check |

**Retake Confirmation Dialog:** Shown when a student who completed the course clicks "Retake Course". Displays completion date and warns that all sessions must be completed again. Confirm triggers checkout; cancel dismisses.

---

## Form Components

### CourseFilters

Filter controls for course browsing.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Browse |
| **Data Source** | categories |
| **Source** | CD-021, US-S057, US-S058 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| onFilterChange | function | Yes | Filter change handler |
| initialFilters | Filters | No | Initial state |

**Filter Options (from CD-021):**
- Level: Beginner, Intermediate, Advanced (checkboxes)
- Category: Dropdown or multi-select
- Price range: Slider or inputs
- Duration: Short/Medium/Long

---

### SearchInput

Global search input.

| Attribute | Value |
|-----------|-------|
| **Used On** | Header, Course Browse, Creator Listing |
| **Data Source** | - |
| **Source** | CD-021 (search index pattern) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| placeholder | string | No | Placeholder text |
| onSearch | function | Yes | Search handler |
| searchType | 'all' \| 'courses' \| 'creators' | No | Search scope |

---

### AvailabilityPicker

Calendar-based availability selector.

| Attribute | Value |
|-----------|-------|
| **Used On** | Session Booking, Teacher Dashboard |
| **Data Source** | availability |
| **Source** | CD-015 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| teacherId | string | Yes | Teacher user ID |
| onSelect | function | Yes | Slot selection handler |

**Display:**
- Calendar date picker
- Time slots for selected date
- Timezone indicator

---

## Navigation Components

Three header/footer sets for different areas. May share internal components (Logo, UserMenu) but are architecturally separate for designer flexibility.

### PublicHeader

Header for public-facing pages (logged out or logged in browsing).

| Attribute | Value |
|-----------|-------|
| **Used On** | Home, Courses, Course Detail, Creator Profiles, Marketing pages |
| **Data Source** | users (if logged in) |
| **Source** | CD-002 |

**Menu Items (Left):**
| Item | Link | Visibility |
|------|------|------------|
| Logo | `/` | Always |
| Courses | `/courses` | Always |
| Creators | `/creators` | Always |
| Community | `/community` | Always |

**Menu Items (Right - Logged Out):**
| Item | Link | Visibility |
|------|------|------------|
| Log In | `/login` | Logged out |
| Sign Up | `/signup` | Logged out (CTA button) |

**Menu Items (Right - Logged In):**
| Item | Link | Visibility |
|------|------|------------|
| Notifications | `/notifications` | Logged in (🔔 with badge) |
| Avatar Dropdown | - | Logged in |

**Avatar Dropdown Menu:**
| Item | Link | Condition |
|------|------|-----------|
| My Learning | `/dashboard` | if `is_student` |
| My Teaching | `/dashboard/teaching` | if `is_teacher` |
| Creator Studio | `/dashboard/creator` | if `is_creator` |
| ─────────── | - | divider |
| Settings | `/settings` | Always |
| Sign Out | `/logout` | Always |

---

### GatedHeader

Header for authenticated dashboard/management pages.

| Attribute | Value |
|-----------|-------|
| **Used On** | Dashboard, Teaching, Creator Studio, Settings |
| **Data Source** | users |
| **Source** | CD-002 |

**Menu Items (Left):**
| Item | Link | Visibility |
|------|------|------------|
| Logo | `/` | Always |
| Home | `/` | Always |
| Courses | `/courses` | Always |
| Community | `/community` | Always |
| Dashboard | `/dashboard` | Always (highlighted when in gated area) |

**Menu Items (Right):**
| Item | Link | Visibility |
|------|------|------------|
| Notifications | `/notifications` | Always (🔔 with badge) |
| Avatar Dropdown | - | Always |

**Avatar Dropdown Menu:**
Same as PublicHeader logged-in dropdown.

---

### AdminSidebar

Left sidebar navigation for Admin SPA (Twitter-style layout).

| Attribute | Value |
|-----------|-------|
| **Used On** | Admin Panel (all screens) |
| **Data Source** | users |
| **Source** | CD-002 |

**Layout:** Fixed left sidebar with primary nav → secondary submenu → main content area

**Primary Nav (Left Column):**
| Item | Icon | Submenu |
|------|------|---------|
| Dashboard | 📊 | Overview, Analytics |
| Users | 👥 | All Users, Admins, Flagged |
| Courses | 📚 | All Courses, Pending Review, Flagged |
| Payouts | 💰 | Pending, Completed, Failed |
| Reports | 🚩 | Content Reports, User Reports |
| Settings | ⚙️ | Platform, Features, Integrations |

**Secondary Nav (Submenu Column):**
Displays submenu items for currently selected primary nav item.

**Header Bar (Top of Main Content):**
| Item | Position | Description |
|------|----------|-------------|
| Page Title | Left | Current screen name |
| Search | Center | Global admin search |
| Avatar Dropdown | Right | Settings, Sign Out, Back to Site |

---

### PublicFooter

Footer for public-facing pages.

| Attribute | Value |
|-----------|-------|
| **Used On** | Home, Courses, Course Detail, Creator Profiles, Marketing pages |
| **Data Source** | - |
| **Source** | CD-002 |

**Columns:**

| Column | Links |
|--------|-------|
| **Platform** | About, How It Works, Pricing, For Creators |
| **Resources** | Help Center, Blog, Success Stories, FAQs |
| **Legal** | Terms of Service, Privacy Policy, Cookie Policy |
| **Connect** | Contact, Twitter/X, LinkedIn |

**Bottom Bar:**
- © 2025 PeerLoop. All rights reserved.
- Logo (small)

---

### GatedFooter

Footer for authenticated dashboard pages. Minimal version.

| Attribute | Value |
|-----------|-------|
| **Used On** | Dashboard, Teaching, Creator Studio, Settings |
| **Data Source** | - |
| **Source** | CD-002 |

**Single Row:**
| Item | Link |
|------|------|
| Help | `/help` |
| Terms | `/terms` |
| Privacy | `/privacy` |
| © 2025 PeerLoop | - |

---

### AdminFooter

Minimal footer for Admin SPA.

| Attribute | Value |
|-----------|-------|
| **Used On** | Admin Panel |
| **Data Source** | - |
| **Source** | CD-002 |

**Single Row (Bottom of Sidebar or Main Area):**
| Item | Description |
|------|-------------|
| Version | App version (e.g., v1.2.3) |
| Back to Site | Link to `/` (exit admin) |

---

### UserMenu

Shared avatar dropdown component used by headers.

| Attribute | Value |
|-----------|-------|
| **Used On** | PublicHeader, GatedHeader, AdminSidebar |
| **Data Source** | users (role flags) |
| **Source** | CD-002 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| user | User | Yes | Current user with role flags |
| onSignOut | function | Yes | Sign out handler |

**Behavior:**
- Shows avatar image (or initials fallback)
- Click opens dropdown
- Role items filtered by `is_student`, `is_teacher`, `is_creator` flags
- Divider before Settings/Sign Out

---

## Feed Components

### PostCard

Community feed post.

| Attribute | Value |
|-----------|-------|
| **Used On** | My Community |
| **Data Source** | posts |
| **Source** | CD-013 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| post | Post | Yes | Post object |

**Display:**
- Author avatar, name, handle
- Post content
- Timestamp
- Course tag (if applicable)
- Like, bookmark, reply, repost buttons
- Reply count

**Actions:**
- Like (US-S037)
- Bookmark (US-S038)
- Reply (US-S039)
- Repost (US-S040)
- Flag (US-S041)

---

### FeedPromotionButton

Button to promote a post to the main Peer Loop feed (using goodwill points).

| Attribute | Value |
|-----------|-------|
| **Used On** | PostCard, PostComposer |
| **Data Source** | user_goodwill, promoted_posts |
| **Source** | CD-024 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| postId | string | Yes | Post to promote |
| pointsCost | number | Yes | Points required |
| userBalance | number | Yes | User's available points |
| onPromote | function | Yes | Promotion handler |

**Display:**
- "Promote to Peer Loop" button with points cost
- Disabled if insufficient balance
- Confirmation modal before spending

**Access Control:**
- Only visible on course-specific posts
- Requires goodwill points balance

---

### InstructorFeedHeader

Header for instructor-level feed.

| Attribute | Value |
|-----------|-------|
| **Used On** | Instructor Feed |
| **Data Source** | users, instructor_followers, courses |
| **Source** | CD-024 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| instructor | User | Yes | Instructor user object |
| coursesCount | number | Yes | Number of courses |
| followersCount | number | Yes | Feed followers |

**Display:**
- Instructor avatar and name
- "Instructor Feed" label
- Student count across all courses
- List of courses by this instructor

---

### PostComposer

Create new post.

| Attribute | Value |
|-----------|-------|
| **Used On** | My Community |
| **Data Source** | - |
| **Source** | CD-013, US-S036 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| onPost | function | Yes | Post submit handler |
| courseContext | Course | No | Pre-selected course |

**Elements:**
- Text input
- Post type selector
- Course tag selector
- Submit button

---

## Common Components

### RatingDisplay

Star rating display.

| Attribute | Value |
|-----------|-------|
| **Used On** | CourseCard, Course Detail, CreatorCard, Profile |
| **Data Source** | rating fields |
| **Source** | CD-021 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| rating | number | Yes | Rating value (0-5) |
| count | number | No | Number of reviews |
| size | 'sm' \| 'md' \| 'lg' | No | Display size |

---

### Avatar

User avatar with fallback.

| Attribute | Value |
|-----------|-------|
| **Used On** | Multiple |
| **Data Source** | users.avatar_url |
| **Source** | CD-021 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| src | string | No | Image URL |
| name | string | Yes | User name (for fallback) |
| size | 'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl' | No | Size |

---

### Badge

Generic badge/tag component.

| Attribute | Value |
|-----------|-------|
| **Used On** | Multiple |
| **Data Source** | - |
| **Source** | - |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| label | string | Yes | Badge text |
| variant | 'default' \| 'success' \| 'warning' \| 'error' \| 'info' | No | Color variant |

---

### ProgressBar

Progress indicator.

| Attribute | Value |
|-----------|-------|
| **Used On** | EnrolledCourseCard, Course Content |
| **Data Source** | module_progress |
| **Source** | CD-019 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| value | number | Yes | Progress 0-100 |
| showLabel | boolean | No | Show percentage |

---

### EmptyState

Empty state placeholder.

| Attribute | Value |
|-----------|-------|
| **Used On** | Multiple |
| **Data Source** | - |
| **Source** | - |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| title | string | Yes | Empty state title |
| description | string | No | Description |
| action | ReactNode | No | CTA button |
| icon | ReactNode | No | Illustration |

---

### FollowButton

Follow/unfollow toggle.

| Attribute | Value |
|-----------|-------|
| **Used On** | CreatorCard, ProfileHeader, Course Detail |
| **Data Source** | follows, course_follows |
| **Source** | CD-018 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| targetId | string | Yes | User or course ID |
| targetType | 'user' \| 'course' | Yes | Follow type |
| isFollowing | boolean | Yes | Current state |
| onToggle | function | Yes | Toggle handler |

---

## UI Primitives (`src/components/ui/`)

Low-level, shared design system components used across the application.

### Icon.astro

Astro icon component backed by icon-paths registry. Renders to plain `<svg>` at build time (zero client JS).

| Attribute | Value |
|-----------|-------|
| **Used On** | Breadcrumbs, navigation, pages |
| **Source** | Conv 068+ |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| name | IconName | Yes | Icon name from `@lib/icon-paths` registry |
| class | string | No | Tailwind classes for size/color |

---

### icons.tsx

Centralized React icon library. All icons accept `className` prop (default: `h-5 w-5`, inherits `currentColor`).

| Attribute | Value |
|-----------|-------|
| **Used On** | All React components |
| **Source** | Conv 068+ |

---

### brand-icons.tsx

Brand & logo icons (Google, GitHub, etc). Separate from utility icons because brand logos are multi-color or fill-based.

| Attribute | Value |
|-----------|-------|
| **Used On** | Login/signup, OAuth buttons |
| **Source** | Conv 068+ |

---

### Breadcrumbs.astro

Route-based breadcrumb trail above page titles. Last item renders as plain text (current page). Supports `?via=` query param context.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course detail, community, discover, dashboard |
| **Source** | Conv 068+ |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| items | BreadcrumbItem[] | Yes | Array of `{ label, href? }` |

---

### Modal.tsx

Reusable modal dialog with backdrop, focus trap, escape key close, and click-outside close.

| Attribute | Value |
|-----------|-------|
| **Used On** | Login, signup, role edit, various admin flows |
| **Source** | Conv 068+ |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| isOpen | boolean | Yes | Visibility state |
| onClose | function | Yes | Close handler |
| children | ReactNode | Yes | Modal content |
| title | string | No | Header title |
| maxWidth | 'max-w-sm' \| ... \| 'max-w-2xl' | No | Width constraint |

---

### ConfirmModal.tsx

Confirmation dialog with loading/error state. Uses callback-in-state pattern for unlimited confirm dialogs per component.

| Attribute | Value |
|-----------|-------|
| **Used On** | Admin panels (delete, force-complete), moderation |
| **Source** | Conv 079 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| state | ConfirmState \| null | Yes | `{ title, message, confirmLabel?, variant?, onConfirm }` |
| onClose | function | Yes | Close handler (set state to null) |

---

### FormModal.tsx

Multi-field form modal. Supports text, textarea, select, number, and email inputs with built-in validation and loading/error state.

| Attribute | Value |
|-----------|-------|
| **Used On** | Admin panels (suspend, warn, refund, notes), moderation queue |
| **Source** | Conv 080 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| state | FormModalState \| null | Yes | `{ title, description?, fields, submitLabel?, variant?, onSubmit }` |
| onClose | function | Yes | Close handler (set state to null) |

**Field types:** `{ name, label, type?, required?, placeholder?, defaultValue?, options? }`

---

### Charts (`ui/charts/`)

Library-agnostic chart components: AreaChart, BarChart, PieChart, FunnelChart. Used in admin intelligence dashboards.

| Attribute | Value |
|-----------|-------|
| **Used On** | Admin dashboard, creator analytics |
| **Source** | Conv 055+ (ADMIN-INTEL) |

---

## Goodwill Components (Block 2+)

*Note: Not MVP - Goodwill points are a community currency replacing 5-star reviews.*

### SummonHelpButton

Triggers help summon request.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Content |
| **Data Source** | user_availability |
| **Source** | CD-023 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| courseId | string | Yes | Course to summon help for |
| availableCount | number | Yes | Number of available helpers |
| onSummon | function | Yes | Summon handler |

**Display:**
- "Summon Help" button with icon
- Available helpers count badge

---

### GoodwillPointsDisplay

Shows user's public goodwill points.

| Attribute | Value |
|-----------|-------|
| **Used On** | Profile (public view), TeacherCard, CreatorCard |
| **Data Source** | user_goodwill |
| **Source** | CD-023 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| totalEarned | number | Yes | Lifetime points |
| breakdown | object | No | {summonsHelped, questionsAnswered, referrals} |
| showBreakdown | boolean | No | Show detailed breakdown |

**Display:**
- Trophy icon + "847 earned"
- Optional breakdown list

---

### GoodwillBalanceCard

Shows user's private goodwill balance.

| Attribute | Value |
|-----------|-------|
| **Used On** | Profile (own, private view) |
| **Data Source** | user_goodwill |
| **Source** | CD-023 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| totalEarned | number | Yes | Lifetime points |
| spent | number | Yes | Points given away |
| balance | number | Yes | Available to award |

**Display:**
- Total Earned, Spent, Available
- Transaction history link

---

### PointsSlider

Slider for awarding goodwill points.

| Attribute | Value |
|-----------|-------|
| **Used On** | Summon Help Modal (complete state) |
| **Data Source** | - |
| **Source** | CD-023 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| min | number | No | Minimum points (default 10) |
| max | number | No | Maximum points (default 25) |
| value | number | Yes | Current value |
| onChange | function | Yes | Value change handler |

---

### MarkAsQuestionButton

Marks a chat message as a question.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Chat Room |
| **Data Source** | posts |
| **Source** | CD-023 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| messageId | string | Yes | Message to mark |
| isMarked | boolean | Yes | Current state |
| onMark | function | Yes | Mark handler |

**Display:**
- "❓ Mark as Question" button/link

---

### ThisHelpedButton

Awards 5 points to a helpful answer.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Chat Room |
| **Data Source** | goodwill_transactions |
| **Source** | CD-023 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| messageId | string | Yes | Message that helped |
| helperId | string | Yes | User who helped |
| isAwarded | boolean | Yes | Already awarded |
| onAward | function | Yes | Award handler |

**Display:**
- "✅ This Helped" button
- Disabled if already awarded

---

### AvailableToHelpToggle

Toggle Teacher availability for summons.

| Attribute | Value |
|-----------|-------|
| **Used On** | Profile, Teacher Dashboard |
| **Data Source** | user_availability |
| **Source** | CD-023 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| isAvailable | boolean | Yes | Current state |
| onToggle | function | Yes | Toggle handler |

**Display:**
- "Available to Help" toggle switch
- Status indicator (green when on)

---

### GoodwillBadge

Badge for point thresholds (Community Helper, etc.).

| Attribute | Value |
|-----------|-------|
| **Used On** | Profile, TeacherCard |
| **Data Source** | user_reward_unlocks |
| **Source** | CD-023 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| badge | 'community_helper' \| 'discount_10' \| etc. | Yes | Badge type |

**Display:**
- Badge icon with label
- "Community Helper" at 500 points

---

### SummonNotification

Notification for Teachers when a student summons help.

| Attribute | Value |
|-----------|-------|
| **Used On** | Notifications, Toast |
| **Data Source** | help_summons |
| **Source** | CD-023 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| summon | HelpSummon | Yes | Summon request |
| onRespond | function | Yes | Respond handler |
| onDismiss | function | Yes | Dismiss handler |

**Display:**
- Student name, course, module
- "Respond" and "Dismiss" buttons

---

## Explore Components

Components powering the `/discover/courses` listing and `/discover/course/[slug]` detail pages. Built on top of the CurrentUser singleton for O(1) role detection per card.

**Source directory:** `src/components/discover/`

---

### RoleBadge

Displays a colored pill showing the viewer's role for a course. Supports three size variants for different contexts.

| Attribute | Value |
|-----------|-------|
| **Used On** | ExploreCard, ExploreCourseHero, Discover Course Detail |
| **Data Source** | `getRoleBadges()` via CurrentUser |
| **Source** | Conv 042 (EXPLORE-COURSES) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| config | RoleBadgeConfig | Yes | Role, label, state, isActive |
| size | 'sm' \| 'md' \| 'compact' | No | Display size (default: 'sm') |

**Size Variants:**
| Size | Display | Example |
|------|---------|---------|
| sm | Pill: icon + label + optional state | "Learning · In Progress" |
| md | Larger pill: icon + label + state | "Teaching · Active" |
| compact | 20px circle with 1-letter abbreviation + tooltip | "T" |

**Role Colors:**
- student: blue · teacher: green · creator: purple · moderator: amber
- Inactive: secondary-100/600

**Helper:** `RoleBadgeRow` renders multiple badges in a flex row.

---

### ExploreCard

Course card with role badge overlay. Extended CourseCard with RoleBadge support and links to `/discover/course/[slug]`.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/courses listing |
| **Data Source** | AnnotatedCourseListItem |
| **Source** | Conv 042 (EXPLORE-COURSES) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| course | object | Yes | Course data (id, slug, title, tagline, price, rating, etc.) |
| roleBadges | RoleBadgeConfig[] | No | Viewer's role badges for this course |
| variant | 'default' \| 'compact' \| 'featured' | No | Display variant |
| via | string | No | Tracking parameter for link |
| cta | { label, href } | No | Optional CTA button |

**Display Fields:** Thumbnail, course badge, title (2-line clamp), tagline, creator (avatar + name), role badges, rating + student count, session/duration/level pills, price.

**Variants:** default (standard card), compact (hides tagline + info pills), featured (horizontal layout with side thumbnail).

---

### ExploreCourses

Main orchestrator for the unified course listing page. Handles tab state, role detection, and data flow.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/courses |
| **Data Source** | SSR courses + client-side CurrentUser |
| **Source** | Conv 042 (EXPLORE-COURSES) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| initialCourses | PublicCourseListItem[] | Yes | SSR-provided course catalog |
| categories | Category[] | Yes | Category list for filters |

**Tab Computation:** Reads CurrentUser enrollments, certifications, created courses, and moderated courses to determine visible tabs and counts.

**URL Hash State:** Syncs active tab to URL hash (`#teaching`, `#created`, etc.) with browser back/forward support.

---

### ExploreTabBar

Top-level tab switcher for the course listing page with role-colored tabs and count badges.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/courses |
| **Data Source** | ExploreTabConfig[] |
| **Source** | Conv 042 (EXPLORE-COURSES) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| tabs | ExploreTabConfig[] | Yes | Tab configurations |
| activeTab | ExploreTab | Yes | Currently active tab |
| onTabChange | (tab) => void | Yes | Tab change handler |

**Tabs:** all, student, teaching, created, moderating. Each shows a role-colored dot indicator and count badge. Hidden when only "All" is available. Responsive with `overflow-x-auto`.

---

### RolePillFilters

Multi-select role toggle pills for the "All" tab. Filters course list to show courses matching any selected role (union).

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/courses (All tab only) |
| **Data Source** | CurrentUser |
| **Source** | Conv 042 (EXPLORE-COURSES) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| state | RolePillState | Yes | Toggle state per role |
| onChange | (state) => void | Yes | State change handler |
| currentUser | CurrentUser | Yes | For role detection |

**Behavior:** Only renders pills for roles the user actually has. "Clear" button appears when any pill is active. Union filtering: courses matching ANY selected role are shown.

---

### ExploreCourseTabs

Wrapper around CourseTabs that injects role-specific tabs (teacher, creator, completed, moderator) into the detail page tab bar.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/course/[slug] detail page |
| **Data Source** | CourseTabsProps + CurrentUser |
| **Source** | Conv 042 (EXPLORE-COURSES) |

**Props:** Passes through all CourseTabsProps (courseId, slug, enrollmentId, etc.)

**Injected Tabs:**
| Tab ID | Role | Condition |
|--------|------|-----------|
| my-students, my-sessions, my-reviews | teacher | Active or past certification |
| studio, analytics, manage-teachers | creator | Course creator |
| certificate, write-review | student | Completed course |
| moderation-queue | moderator | Can moderate (non-creator) |

---

### ExploreCourseHero

Course hero section with role badge overlay. Wraps existing CourseHero and adds role badges below.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/course/[slug] detail page |
| **Data Source** | CourseHero props + CurrentUser |
| **Source** | Conv 042 (EXPLORE-COURSES) |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| course | CourseHero['course'] | Yes | Course data for hero |
| courseId | string | Yes | Course ID for role lookup |

**Display:** Renders CourseHero + "Your Role:" label with md-size role badges below (only when viewer has roles for this course).

---

### ExploreCommunities

Main orchestrator for the community listing page. Handles tab state, role detection, and data flow.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/communities |
| **Data Source** | SSR communities + client-side CurrentUser |
| **Source** | Conv 043 (EXPLORE-COMMUNITIES-FEEDS P1) |

---

### ExploreCommunityCard

Community card with role badge overlay. Links to `/discover/community/[slug]`.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/communities listing |
| **Data Source** | AnnotatedCommunityListItem |
| **Source** | Conv 043 (EXPLORE-COMMUNITIES-FEEDS P1) |

---

### CommunityRolePillFilters

Multi-select role toggle pills for the community "All" tab. Filters to communities matching any selected role.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/communities (All tab only) |
| **Data Source** | CurrentUser |
| **Source** | Conv 043 (EXPLORE-COMMUNITIES-FEEDS P1) |

---

### Community Tab Components (5)

Role-specific tab content for the community listing page:
- **CommunityAllTab** — full public catalog with search, sort, role pill filters
- **CommunityMemberTab** — communities where user has memberRole='member'
- **CommunityTeachingTab** — communities where user has memberRole='teacher'
- **CommunityCreatedTab** — communities where user has memberRole='creator'
- **CommunityModerationTab** — communities where user is appointed moderator

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/communities (via ExploreCommunities) |
| **Source** | Conv 043 (EXPLORE-COMMUNITIES-FEEDS P1) |

---

### ExploreCommunityTabs

Wrapper around CommunityTabs that injects role-specific tabs (creator settings, member management, moderation) into the detail page tab bar.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/community/[slug] detail page |
| **Data Source** | CommunityTabsProps + CurrentUser |
| **Source** | Conv 044 (EXPLORE-COMMUNITIES-FEEDS P3) |

**Injected Tabs:**
| Tab ID | Role | Condition |
|--------|------|-----------|
| settings, manage-members | creator | Community creator |
| moderation | moderator | Appointed moderator (non-creator) |

---

### ExploreCommunityHero

Community hero with role badge overlay. Shows "Your Role:" badges for members.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/community/[slug] detail page |
| **Data Source** | Community data + CurrentUser |
| **Source** | Conv 044 (EXPLORE-COMMUNITIES-FEEDS P3) |

---

### Community Detail Tab Content (2)

Placeholder content components for community role tabs:
- **CommunityCreatorTabContent** — Settings + Manage Members placeholders (purple)
- **CommunityModerationTabContent** — Moderation queue placeholder (amber)

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/community/[slug] (via ExploreCommunityTabs) |
| **Source** | Conv 044 (EXPLORE-COMMUNITIES-FEEDS P3) |

---

### ExploreFeeds

Main orchestrator for the feed listing page. Handles tab state, badge counts, and role-aware feed display.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/feeds (Your Feeds section) |
| **Data Source** | CurrentUser.getFeeds() + /api/me/feed-badges |
| **Source** | Conv 043 (EXPLORE-COMMUNITIES-FEEDS P2) |

---

### ExploreFeedCard

Feed card with role badges and unread count overlay. Shows type label and links to feed URL.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/feeds listing |
| **Data Source** | AnnotatedFeedLink |
| **Source** | Conv 043 (EXPLORE-COMMUNITIES-FEEDS P2) |

---

### Feed Tab Components (2)

- **FeedAllTab** — townhall (pinned), Home Feed link, community/course sections, search
- **FeedRoleTab** — shared for Student/Teaching/Created/Moderating tabs, filtered grid

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/feeds (via ExploreFeeds) |
| **Source** | Conv 043 (EXPLORE-COMMUNITIES-FEEDS P2) |

---

### DiscoverFeedsGrid

Discovery card grid showing active public feeds with clear CTAs. Fetches from `/api/feeds/discover`.

| Attribute | Value |
|-----------|-------|
| **Used On** | /discover/feeds (discovery section, visible to all) |
| **Data Source** | GET /api/feeds/discover |
| **Source** | Conv 044 (DISCOVER-FEEDS realignment) |

**Card Display:** Feed type icon, name, match reason ("Matches your interests" / "Popular on PeerLoop"), vitality stats, latest post preview, CTA button ("Join Community →" / "View Course →").

**Visitor support:** Works without authentication (shows popular feeds ranked by vitality).

---

## Component Count Summary

| Category | Count |
|----------|-------|
| Cards | 5 |
| Profile | 4 |
| Course | 8 |
| Explore | 26 |
| Form | 3 |
| Navigation | 2 |
| Feed | 4 |
| Common | 6 |
| UI Primitives | 8 |
| Goodwill | 9 |
| **Total** | **75** |

---

## Document Lineage

| Source Document | Components Derived |
|-----------------|-------------------|
| CD-021 | CourseCard (fields), CreatorCard (fields), TeacherCard, QualificationsList, ExpertiseTags, StatsDisplay, LearningObjectivesList, CourseIncludesList, CurriculumAccordion, LevelBadge, CategoryBadge, PeerLoopFeatures, CourseTeachers, CourseFilters, RatingDisplay |
| CD-022 | CourseBadge, CourseCard (badge, rating_count fields) |
| CD-023 | SummonHelpButton, GoodwillPointsDisplay, GoodwillBalanceCard, PointsSlider, MarkAsQuestionButton, ThisHelpedButton, AvailableToHelpToggle, GoodwillBadge, SummonNotification |
| CD-002 | MainNav, RoleSwitcher |
| CD-013 | PostCard, PostComposer |
| CD-024 | FeedPromotionButton, InstructorFeedHeader |
| CD-015 | AvailabilityPicker, SessionCard |
| CD-018 | ProfileHeader, FollowButton |
| CD-019 | EnrolledCourseCard, ProgressBar |
| Conv 042 | RoleBadge, ExploreCard, ExploreCourses, ExploreTabBar, RolePillFilters, ExploreCourseTabs, ExploreCourseHero |
| Conv 043 | ExploreCommunities, ExploreCommunityCard, CommunityRolePillFilters, CommunityAllTab, CommunityMemberTab, CommunityTeachingTab, CommunityCreatedTab, CommunityModerationTab, ExploreFeeds, ExploreFeedCard, FeedAllTab, FeedRoleTab |
| Conv 044 | ExploreCommunityTabs, ExploreCommunityHero, CommunityCreatorTabContent, CommunityModerationTabContent, DiscoverFeedsGrid |

---

## Notes for Implementation

1. **Tech Stack:** Components will use React + TailwindCSS (per tech-004, tech-005)
2. **Component Library:** Consider using Shadcn/ui as base
3. **getstream.io:** Feed components may use Stream SDK components
4. **Accessibility:** All components should be ARIA-compliant
5. **Responsive:** Mobile-first responsive design

---

## Component Version History

| Version | Date | Changes |
|---------|------|---------|
| v1 | 2025-12-23 | Initial component inventory from CD-021 and existing docs |
| v2 | 2026-03-28 | Added Explore Components section (7 components from EXPLORE-COURSES block, Conv 042) |
| v3 | 2026-04-03 | Added UI Primitives section (8 components: Icon.astro, icons.tsx, brand-icons.tsx, Breadcrumbs.astro, Modal, ConfirmModal, FormModal, Charts) |

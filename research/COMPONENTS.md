# PeerLoop - Component Library

**Version:** v1
**Last Updated:** 2025-12-23
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

### StudentTeacherCard

Displays Student-Teacher for selection/listing.

| Attribute | Value |
|-----------|-------|
| **Used On** | ST Directory, Course Detail (ST section), Session Booking |
| **Data Source** | users, student_teachers |
| **Source** | CD-021, CD-018 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| studentTeacher | StudentTeacher | Yes | ST record with user |
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
- Click → ST Profile page
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
| **Used On** | Creator Profile, ST Profile, Own Profile |
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
| **Used On** | Creator Profile, ST Profile |
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
| **Used On** | Creator Profile, CreatorCard, ST Profile |
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
| **Used On** | Creator Profile, CreatorCard, ST Profile |
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

### CurriculumAccordion

Displays course curriculum/modules.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Detail, Course Content |
| **Data Source** | course_curriculum |
| **Source** | CD-021 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| modules | CurriculumModule[] | Yes | Curriculum modules |
| progress | ModuleProgress[] | No | Completion state |
| expandable | boolean | No | Accordion behavior |

**Display Fields (from CD-021):**
- title
- duration
- description
- video_count, reading_count (if available)
- has_assessment badge
- Completion checkbox (if enrolled)

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

### CourseStudentTeachers

Displays Student-Teachers for a specific course.

| Attribute | Value |
|-----------|-------|
| **Used On** | Course Detail |
| **Data Source** | student_teachers |
| **Source** | CD-021, US-S061 |

**Props:**
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| courseId | string | Yes | Course ID |
| studentTeachers | StudentTeacher[] | Yes | ST list for course |

**Display (from CD-021):**
- List of StudentTeacherCards
- Or compact list: name, students_taught, certified_date
- CTA: Book with this ST

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
| **Used On** | Session Booking, ST Dashboard |
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
| My Teaching | `/dashboard/teaching` | if `is_student_teacher` |
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
- Role items filtered by `is_student`, `is_student_teacher`, `is_creator` flags
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
| **Used On** | Profile (public view), STCard, CreatorCard |
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

Toggle S-T availability for summons.

| Attribute | Value |
|-----------|-------|
| **Used On** | Profile, ST Dashboard |
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
| **Used On** | Profile, STCard |
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

Notification for S-Ts when a student summons help.

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

## Component Count Summary

| Category | Count |
|----------|-------|
| Cards | 5 |
| Profile | 4 |
| Course | 8 |
| Form | 3 |
| Navigation | 2 |
| Feed | 4 |
| Common | 6 |
| Goodwill | 9 |
| **Total** | **41** |

---

## Document Lineage

| Source Document | Components Derived |
|-----------------|-------------------|
| CD-021 | CourseCard (fields), CreatorCard (fields), STCard, QualificationsList, ExpertiseTags, StatsDisplay, LearningObjectivesList, CourseIncludesList, CurriculumAccordion, LevelBadge, CategoryBadge, PeerLoopFeatures, CourseStudentTeachers, CourseFilters, RatingDisplay |
| CD-022 | CourseBadge, CourseCard (badge, rating_count fields) |
| CD-023 | SummonHelpButton, GoodwillPointsDisplay, GoodwillBalanceCard, PointsSlider, MarkAsQuestionButton, ThisHelpedButton, AvailableToHelpToggle, GoodwillBadge, SummonNotification |
| CD-002 | MainNav, RoleSwitcher |
| CD-013 | PostCard, PostComposer |
| CD-024 | FeedPromotionButton, InstructorFeedHeader |
| CD-015 | AvailabilityPicker, SessionCard |
| CD-018 | ProfileHeader, FollowButton |
| CD-019 | EnrolledCourseCard, ProgressBar |

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

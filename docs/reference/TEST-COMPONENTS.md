# Component Tests

React component tests using Vitest and React Testing Library.

**Last Updated:** 2026-07-28 (Conv 428 — no new or deleted files; **two files changed in place**. `dashboard/TeacherDashboard.test.tsx` **14→17** (+3 for the generalised `useRoleGate('teacher')` gate: the shared `RoleGatePanel` renders instead of this island's fetch-error branch when denied, the teacher API is not called at all when denied, and the skeleton — not the gate — shows while access is still resolving) → Dashboard 90→93. `courses/CourseCatalogCard.test.tsx` **14→13** (−1: the "overlay ignores cover-story-only props" guard went with the `overlay` variant itself — Conv 427's [REC-REHOME] left it with no production call site, so `CourseCardVariant` narrowed to `'stacked' | 'cover-story'`; `CommunityCatalogCard`'s `overlay` was dropped in the same sweep but its 16 cases were retargeted rather than reduced) → Courses 55→54. Grand total files **82** (unchanged), cases **1,870→1,872**.)
**Prev:** 2026-07-28 (Conv 427 — [REC-REHOME]: **−2 files**, the whole **Recommendations Components** category. `recommendations/RecommendedCommunities.test.tsx` (11) and `recommendations/RecommendedCourses.test.tsx` (9) were deleted with the two carousels they covered — the recommendations surface moved to the right rail as the rails-backed `DiscoveryRails` island, whose logic is pure and tested in `tests/lib/discovery-rails-lanes.test.ts` (a lib test, so it does not land in this file). Recommendations 2→0 files / 20→0 cases, category removed. Grand total files **84→82**, cases **1,890→1,870**.)
**Prev:** 2026-07-28 (Conv 426 — MERGE-BRIAN §3 communities: **+2 new files**. `communities/CommunityCatalogCard.test.tsx` (16 — the named third **`hero`** variant plus brand marks on all three variants: the tokenised identity band with no raw hex and no gradient, the per-community aggregates row (course count, teacher count, weighted rating, review count), and the absent-medallion treatment when a community has no `logoUrl`; `entity-community` deliberately **not** adopted — our `tokens-semantic.css` defines only the five role entities, so the class would be a no-op) → Community 8→9 files / 102→118 cases. `RoleTabBar.test.tsx` (12 — the opt-in `variant="pill"`: active pill fills with its **role background**, inactive pills keep the role dot, and the default underline treatment is byte-identical, so `/courses` role tabs and `dev/primitives` are untouched; the client branch dropped the role palette with the underline form, and these 12 make a later "just match his version" edit fail rather than silently regress) → new root-level **Shared Primitives** category (1 file / 12). Grand total files **82→84**, cases **1,862→1,890**.)
**Prev:** 2026-07-28 (Conv 425 — MERGE-BRIAN §2 `/courses` catalog: **+3 new files**, all in the Courses category. `courses/CourseCatalogCard.test.tsx` (14 — the new **`cover-story`** variant, named rather than overloading `overlay + context`: shared cover panel + price sticker, description-preferred body with tagline fallback, the sticker proven to be the shared `CoursePriceSticker` and kept `pointer-events-none` so it can't eat the stretched card link, the shared `CommunityAffiliation` line + its no-community null, enrolled journey markers with "Diploma earned" pinned against "Certificate" ([DIPLOMA]) and the CTA left exactly as the host passed it, persistently-underlined link chips, and two cases pinning `stacked`/`overlay` as untouched), `courses/CoursesFilters.test.tsx` (10 — topic pill row incl. the full `FilterState` contract his pivot nulled, Level/Length still reachable behind the Filters toggle, the `hidden sm:flex` pill row and `sm:hidden` collapse select writing the same topic state so neither half can be deleted alone, visible labelled sort, role-tab collapse-to-search) and `courses/CoursesCatalog.test.tsx` (8 — empty-state copy keyed off the `courses.length === 0` invariant so no future filter can re-open the "platform is empty" bug: filter-blame for topic/level/length, precise search-only + availableSoon messages, filter message preferred when a query *and* an attribute filter are both set). Courses 2→5 files / 23→55 cases. Grand total files **79→82**, cases **1,830→1,862**.)
**Prev:** 2026-07-26 (Conv 419b — [MKTDEAD] dead-marketing purge: **−10 files** deleted with the 56 provably-dead components they covered. Marketing 9→1 files / 389→49 cases (−`AboutPage` 31, `ContactPage` 57, `FaqPage` 40, `ForCreatorsPage` 42, `HowItWorksPage` 34, `PricingPage` 38, `PrivacyPolicyPage` 51, `TermsOfServicePage` 47; **`BecomeATeacherPage` 49 deliberately KEPT** — `/become-a-teacher` is live). Stories 1→0 / 43→0 and Testimonials 1→0 / 53→0, both categories removed. The 14 `/old/*` marketing pages have rendered "Coming soon." stubs for a long time, so the bundler had been tree-shaking these components out — confirmed via sourcemap `sources`, not inferred. Grand total files **89→79**, cases **2,266→1,830**. Also corrected the `**Total:**` line, which had lagged at 88 since the previous Conv-419 entry.)
**Prev:** 2026-07-26 (Conv 419 — [MSG-ADOPT-B]/[COURSETAB-HASH]: `messages/MessageUserButton.test.tsx` grew **21→24** in place (+3 for `icon` widening to `string | ReactNode` — a node renders verbatim with no MattIcon substituted, a string still resolves to a MattIcon, and the node carries onto the signed-out anchor; needed because the 3 profile-header `Button` sites sit in a row of siblings carrying 16px `ui/icons` glyphs). +1 **new** file `useRoleTabs.test.ts` (6 — the `ready` gate that fixed the `/courses#student` deep link, the same three-state bootstrap race as [MSGBOOT]; 3 of the 6 fail if the gate is reverted). Messages 25→28 cases; new root-level entry. Grand total files **88→89**, cases **2,257→2,266**.)
**Prev:** 2026-07-26 (Conv 418 — [MSG-ICON]/[MSG-ADOPT-A]: `messages/MessageUserButton.test.tsx` grew **11→21** in place (+5 for the `appearance="bare"` icon trigger — a bare `<button>` rendering the call site's own icon as children with `className` passed through and a required `title`, deliberately not the `Button` primitive; +5 for `signedIn` becoming optional and resolving from `useAuthStatus()` when omitted, with an explicit prop still winning). Messages 15→25 cases, files unchanged (2). Grand total files **88** (unchanged), cases **2,247→2,257**. No new component test files.)
**Prev:** 2026-07-26 (Conv 417 — [MSG-INPLACE]/[MSG-EXIT]: +1 **new** file `messages/MessageUserButton.test.tsx` (11 — the in-place composer island: button-not-link when signed in, `/messages?to=` anchor fallback when signed out, recipient preselected on open, POST → close → toast with no navigation, the discard guard's cancel/confirm/nothing-typed paths, the opt-in "Open in Messages" exit + its typed-draft guard, error toast on a failed POST, and one case pinning the exit as opt-**out** on the `/messages` mount) → Messages 1→2 files / 4→15. Grand total files **87→88**, cases **2,236→2,247**.)
**Prev:** 2026-07-13 (Conv 393 — [ORPHAN-BACKLOG] Category C + dead-.ts sweep: deleted 4 orphaned component test files whose components/utils were removed as dead code. Context Actions 1→0 files / 11→0 (−`ContextActionsPanel` 11, category removed), Explore 3→1 / 83→37 (−`community-role-utils` 24, −`feed-role-utils` 22), Leaderboard 1→0 / 35→0 (−`Leaderboard` 35, category removed). Grand total files **91→87**, cases **2,328→2,236**.)
**Prev:** 2026-07-12 (Conv 392 — [ORPHAN-PURGE]/[ORPHAN-BACKLOG]: deleted 13 orphaned component test files whose components were removed as dead-legacy (unreachable from any route). Courses 7→2 files / 85→23 (−`CourseTabs` 19, `LearnTab` 18, `ModuleAccordion` 11, `MyCourses` 7, `course-tabs/ResourcesTabContent` 7), Explore 8→3 / 146→83 (−`RoleBadge` 21, `ExploreTabBar` 7, `RolePillFilters` 8, `ExploreCommunityCard` 16, `CommunityRolePillFilters` 11), Learning 2→1 / 20→2 (−`ModuleContent` 18), Messages 2→1 / 21→4 (−`Messages` 17), Notifications 1→0 / 35→0 (−`NotificationsList` 35, category removed). Grand total files **104→91**, cases **2,523→2,328**.)
**Prev:** 2026-07-12 (Conv 390 — [CERT-MASTERY-UI]: +1 **new** file `teachers/RecommendCertButton.test.tsx` (4 — confirm→POST teaching-cert recommend, optimistic "Recommended" pill, compact/labeled variants) → new **Teachers** category (1 file / 4). Two Admin files shed cases for the retired `completion`/`mastery` cert types: `admin/CertificateDetailContent.test.tsx` 31→29, `admin/CertificatesAdmin.test.tsx` 27→26 (dropped the single-option type-filter test) → Admin 695→692. Grand total files **103→104**, cases **2,522→2,523**.)
**Prev:** 2026-07-11 (Conv 386 — [XTZ] cross-timezone regression suite. Two **new** files: `dashboard/cross-timezone-day-of.test.tsx` (2 — same instant rendered teacher LA/PDT vs student Tokyo/JST, day AND hour diverge) → Dashboard 6→7 files / 88→90, and `messages/message-timezone.test.ts` (4 — `formatMessageTime`/`formatDateHeader`/`groupMessagesByDate` per viewer stored tz, null→`" UTC"` label) → Messages 1→2 files / 17→21. Grand total files **101→103**, cases **2,516→2,522**.)
**Prev:** 2026-07-09 (Conv 377 — [TZ-BROWSER-AUTO] jsdom viewer-tz display regression suite across 6 islands (+12 tests). Two **new** files: `dashboard/TeacherUpcomingSessions.test.tsx` (2) → Dashboard 5→6 files / 86→88, and `learning/StudentSessionsList.test.tsx` (2) → Learning 1→2 files / 18→20. Three files gained +2 each: `admin/SessionDetailContent.test.tsx` 53→55 (Admin 693→695), `booking/SessionBooking.test.tsx` 31→33 (Booking 106→108), `teaching/TeacherSessionsList.test.tsx` 32→34 (Teaching 144→146). Grand total files **99→101**, cases **2,506→2,516**. The 6th island `pages/dashboard/StudentDashboard.test.tsx` (+2) is a page test — see TEST-PAGES.md.)
**Prev:** 2026-07-09 (Conv 376 — [TZ-LINT-SCAN2] SessionRoom viewer-tz fix added +2 render tests to `booking/SessionRoom.test.tsx` (26→28 — mock `useUserTimezone`, asserting viewer-tz session time + `" UTC"` null fallback with `{exact:false}`) → Booking 104→106 cases, grand total **2,504→2,506**. No new test *file*, so file count stays **99** and TEST-COVERAGE.md summary totals are unchanged.)
**Prev:** 2026-07-04 (Conv 363 — [VBAR] added `feed/SignupCtaCard.test.tsx` (2, dismissable in-feed visitor CTA) → Community 7→8 files / 98→102 cases (also SmartFeed 3→5 for the visitor-CTA interleave) and `Sidebar.test.tsx` (2, visitor Sign up/Log in affordance) → Layout 1→2 / 9→11; [THEME-CS] added `ui/ThemeToggle.test.tsx` (2, `comingSoon` disabled+badge) → UI 1→2 / 8→10. Grand total files **96→99**, cases **2,496→2,504**.)
**Prev:** 2026-07-04 (Conv 362 [MOBUP]: added new UI category `ui/MobileUpNav.test.ts` (8 — Astro source-level: `@matt-inspired` marker, `lg:hidden` mobile contract, parent href/label props, deterministic up-anchor never `history.back()`, arrow-left MattIcon, AppLayout `mobile-upnav` slot wiring) → files **95→96**, cases **2,488→2,496**.)
**Prev:** 2026-06-27 (Conv 340 [TEST-FILE-COUNT]: corrected the stale grand-total row — files **94→95**, cases **2,473→2,488** — to match the category-row sums, the on-disk `tests/components/` count (95), and the header + TEST-COVERAGE.md (both already 95). The per-category rows were correct; only the total row was left un-resummed after the Conv-339 swap.)
**Prev:** 2026-06-26 (Conv 339 — [SESSHIST]/[OLD-PORTED-CLEANUP] retired `teaching/SessionHistory.test.tsx` (42) and added `teaching/TeacherSessionsList.test.tsx` (32); Teaching cases 154→144, file count unchanged (4).)
**Prev:** 2026-06-15 (Conv 286 — two changes: [TESTCOMP-DRIFT] reconciled the doc against on-disk via a verified `vitest run` (removed stale `booking/SessionJoinableView.test.tsx`; corrected 5 drifted per-file counts: SessionBooking 32→31, EnrollButton 13→17, CreatorTeacherList 21→18, Messages 19→17, ModeratorQueue 61→59), then [NUDGE-TC-V2] added a new Progression category `progression/ProgressionNudge.test.tsx` (15). Net: 93→95 files / 2,262→2,498 cases.)

**Total:** 82 test files

---

## Overview

Component tests validate:
- Rendering with various props
- User interactions (clicks, form inputs)
- API call mocking and response handling
- Loading, error, and empty states
- Accessibility (roles, labels)

All components use mocked API responses via `vi.mock()`.

---

## Admin Components (19 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| AdminDashboard | `tests/components/admin/AdminDashboard.test.tsx` | 39 |
| CategoriesAdmin | `tests/components/admin/CategoriesAdmin.test.tsx` | 47 |
| CertificateDetailContent | `tests/components/admin/CertificateDetailContent.test.tsx` | 29 |
| CertificatesAdmin | `tests/components/admin/CertificatesAdmin.test.tsx` | 26 |
| CourseDetailContent | `tests/components/admin/CourseDetailContent.test.tsx` | 42 |
| CoursesAdmin | `tests/components/admin/CoursesAdmin.test.tsx` | 26 |
| CreatorApplicationsAdmin | `tests/components/admin/CreatorApplicationsAdmin.test.tsx` | 15 |
| EnrollmentDetailContent | `tests/components/admin/EnrollmentDetailContent.test.tsx` | 36 |
| EnrollmentsAdmin | `tests/components/admin/EnrollmentsAdmin.test.tsx` | 30 |
| ModerationAdmin | `tests/components/admin/ModerationAdmin.test.tsx` | 38 |
| ModerationDetailContent | `tests/components/admin/ModerationDetailContent.test.tsx` | 70 |
| PayoutDetailContent | `tests/components/admin/PayoutDetailContent.test.tsx` | 37 |
| PayoutsAdmin | `tests/components/admin/PayoutsAdmin.test.tsx` | 28 |
| SessionDetailContent | `tests/components/admin/SessionDetailContent.test.tsx` | 55 |
| SessionsAdmin | `tests/components/admin/SessionsAdmin.test.tsx` | 48 |
| TeacherDetailContent | `tests/components/admin/TeacherDetailContent.test.tsx` | 37 |
| TeachersAdmin | `tests/components/admin/TeachersAdmin.test.tsx` | 34 |
| UserDetailContent | `tests/components/admin/UserDetailContent.test.tsx` | 31 |
| UsersAdmin | `tests/components/admin/UsersAdmin.test.tsx` | 24 |

---

## Analytics Components (9 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| AdminAnalytics | `tests/components/analytics/AdminAnalytics.test.tsx` | 20 |
| CoursePerformanceTable | `tests/components/analytics/CoursePerformanceTable.test.tsx` | 19 |
| CreatorAnalytics | `tests/components/analytics/CreatorAnalytics.test.tsx` | 37 |
| EnrollmentTrendsChart | `tests/components/analytics/EnrollmentTrendsChart.test.tsx` | 13 |
| FunnelAnalysis | `tests/components/analytics/FunnelAnalysis.test.tsx` | 11 |
| MetricsRow | `tests/components/analytics/MetricsRow.test.tsx` | 11 |
| ProgressDistribution | `tests/components/analytics/ProgressDistribution.test.tsx` | 9 |
| SessionAnalytics | `tests/components/analytics/SessionAnalytics.test.tsx` | 14 |
| TeacherPerformanceTable | `tests/components/analytics/TeacherPerformanceTable.test.tsx` | 18 |

---

## Shared Hooks (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| useRoleTabs (`ready` gate) | `tests/components/useRoleTabs.test.ts` | 6 |

---

## Shared Primitives (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| RoleTabBar (`variant="pill"`) | `tests/components/RoleTabBar.test.tsx` | 12 |

The opt-in pill variant added in Conv 426 ([MERGE-BRIAN §3 · N9]) — the active pill fills with its role background, inactive pills keep the role dot, and the default underline treatment is unchanged. These cases pin the Matt **role palette** on both treatments, which the client branch had dropped along with the underline form.

---

## Auth Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| useCreatorGate | `tests/components/auth/useCreatorGate.test.ts` | 11 |

---

## Booking/Sessions Components (4 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| SessionBooking | `tests/components/booking/SessionBooking.test.tsx` | 33 |
| SessionCompletedView | `tests/components/booking/SessionCompletedView.test.tsx` | 40 |
| SessionParticipantCard | `tests/components/booking/SessionParticipantCard.test.tsx` | 7 |
| SessionRoom | `tests/components/booking/SessionRoom.test.tsx` | 28 |

---

## Community/Feeds Components (9 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CommunityCatalogCard | `tests/components/communities/CommunityCatalogCard.test.tsx` | 16 |
| CourseFeed | `tests/components/community/CourseFeed.test.tsx` | 22 |
| FeedActivityCard | `tests/components/community/FeedActivityCard.test.tsx` | 35 |
| SystemFeed | `tests/components/community/SystemFeed.test.tsx` | 21 |
| FeedPost | `tests/components/feed/FeedPost.test.tsx` | 8 |
| SmartFeed | `tests/components/feed/SmartFeed.test.tsx` | 5 |
| SignupCtaCard | `tests/components/feed/SignupCtaCard.test.tsx` | 2 |
| EntityPromoComposer | `tests/components/feed/EntityPromoComposer.test.tsx` | 3 |
| PromoteNudge | `tests/components/promotion/PromoteNudge.test.tsx` | 6 |

---

## Explore Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| role-utils | `tests/components/discover/role-utils.test.ts` | 37 |

---

## Course Components (5 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CourseCatalogCard | `tests/components/courses/CourseCatalogCard.test.tsx` | 13 |
| CoursesCatalog | `tests/components/courses/CoursesCatalog.test.tsx` | 8 |
| CoursesFilters | `tests/components/courses/CoursesFilters.test.tsx` | 10 |
| EnrollButton | `tests/components/courses/EnrollButton.test.tsx` | 17 |
| MilestoneComposer | `tests/components/course/MilestoneComposer.test.tsx` | 6 |

---

## Creator Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CreatorApplicationForm | `tests/components/creator/CreatorApplicationForm.test.tsx` | 15 |
| CreatorStudio | `tests/components/creator/CreatorStudio.test.tsx` | 41 |

---

## Entity Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CommunityAnchor | `tests/components/entity/CommunityAnchor.test.tsx` | 5 |

---

## Dashboard Components (7 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| CreatorDashboard | `tests/components/dashboard/CreatorDashboard.test.tsx` | 20 |
| CreatorTeacherList | `tests/components/dashboard/CreatorTeacherList.test.tsx` | 18 |
| EarningsOverview | `tests/components/dashboard/EarningsOverview.test.tsx` | 13 |
| TeacherDashboard | `tests/components/dashboard/TeacherDashboard.test.tsx` | 17 |
| TeacherStudentList | `tests/components/dashboard/TeacherStudentList.test.tsx` | 21 |
| TeacherUpcomingSessions | `tests/components/dashboard/TeacherUpcomingSessions.test.tsx` | 2 |
| Cross-TZ day-of (XTZ) | `tests/components/dashboard/cross-timezone-day-of.test.tsx` | 2 |

---

## Invite Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ModeratorInvite | `tests/components/invite/ModeratorInvite.test.tsx` | 36 |

---

## Learning Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| StudentSessionsList | `tests/components/learning/StudentSessionsList.test.tsx` | 2 |

---

## Layout Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ListingShell | `tests/components/layout/ListingShell.test.ts` | 9 |
| Sidebar | `tests/components/Sidebar.test.tsx` | 2 |

---

## Marketing Page Components (1 file)

The other 8 files here were deleted in Conv 419 ([MKTDEAD]) along with the `src/components/marketing/` tree — the `/old/*` marketing pages they covered have rendered "Coming soon." stubs for a long time, so the components were already being tree-shaken out of the build.

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| BecomeATeacherPage | `tests/components/marketing/BecomeATeacherPage.test.tsx` | 49 |

---

## Messages Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| MessageUserButton (in-place composer island) | `tests/components/messages/MessageUserButton.test.tsx` | 24 |
| Message time (viewer-tz, XTZ) | `tests/components/messages/message-timezone.test.ts` | 4 |

---

## Moderation Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ModeratorQueue | `tests/components/mod/ModeratorQueue.test.tsx` | 59 |

---

## Onboarding Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| OnboardingNudgeBanner | `tests/components/onboarding/OnboardingNudgeBanner.test.tsx` | 14 |
| OnboardingProfile | `tests/components/onboarding/OnboardingProfile.test.tsx` | 28 |

---

## Progression Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| ProgressionNudge | `tests/components/progression/ProgressionNudge.test.tsx` | 15 |

---

---

## Settings Components (4 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| NotificationSettings | `tests/components/settings/NotificationSettings.test.tsx` | 28 |
| ProfileSettings | `tests/components/settings/ProfileSettings.test.tsx` | 33 |
| SecuritySettings | `tests/components/settings/SecuritySettings.test.tsx` | 29 |
| StripeConnectSettings | `tests/components/settings/StripeConnectSettings.test.tsx` | 36 |

---

## Teachers Components (1 file)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| RecommendCertButton | `tests/components/teachers/RecommendCertButton.test.tsx` | 4 |

---

## Teaching Components (4 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| EarningsDetail | `tests/components/teaching/EarningsDetail.test.tsx` | 38 |
| MyStudents | `tests/components/teaching/MyStudents.test.tsx` | 43 |
| TeacherAnalytics | `tests/components/teaching/TeacherAnalytics.test.tsx` | 31 |
| TeacherSessionsList | `tests/components/teaching/TeacherSessionsList.test.tsx` | 34 |

---

## UI Components (2 files)

| Component | Test File | Tests |
|-----------|-----------|:-----:|
| MobileUpNav | `tests/components/ui/MobileUpNav.test.ts` | 8 |
| ThemeToggle | `tests/components/ui/ThemeToggle.test.tsx` | 2 |

---

## Summary by Category

| Category | Files | Tests |
|----------|------:|------:|
| Admin | 19 | 692 |
| Analytics | 9 | 152 |
| Auth | 1 | 11 |
| Booking | 4 | 108 |
| Community | 9 | 118 |
| Courses | 5 | 54 |
| Creator | 2 | 56 |
| Entity | 1 | 5 |
| Explore | 1 | 37 |
| Dashboard | 7 | 93 |
| Invite | 1 | 36 |
| Learning | 1 | 2 |
| Layout | 2 | 11 |
| Marketing | 1 | 49 |
| Messages | 2 | 28 |
| Moderation | 1 | 59 |
| Onboarding | 2 | 42 |
| Progression | 1 | 15 |
| Settings | 4 | 126 |
| Teachers | 1 | 4 |
| Teaching | 4 | 146 |
| UI | 2 | 10 |
| Shared hooks | 1 | 6 |
| Shared primitives | 1 | 12 |
| **Total** | **82** | **1,872** |

---

## Related Documentation

- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test coverage index
- [TEST-PAGES.md](TEST-PAGES.md) - Page-level tests
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands

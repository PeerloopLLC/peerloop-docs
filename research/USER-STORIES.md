# Alpha Peer - User Stories Index

**Version:** v11
**Last Updated:** 2026-01-06
**Sources:** CD-001 through CD-034, SCOPE (see individual story files for details)

> **Version History:** v9 - Split into role-based files for easier navigation. Increment version when substantive changes occur (new stories, priority changes, removed stories).

---

## Story Files

Stories are split by role for easier navigation:

| File | Role | Description | Stories | P0 | P1 | P2 | P3 |
|------|------|-------------|---------|----|----|----|----|
| [stories-G-visitor.md](user-stories/stories-G-visitor.md) | Visitor/Guest | Non-logged in user browsing public site | 18 | 11 | 7 | 0 | 0 |
| [stories-A-admin.md](user-stories/stories-A-admin.md) | Admin (AP Rep) | Platform operations and oversight | 60 | 35 | 19 | 6 | 0 |
| [stories-C-creator.md](user-stories/stories-C-creator.md) | Creator-Instructor | Course creator who may also teach directly | 57 | 16 | 25 | 14 | 1 |
| [stories-S-student.md](user-stories/stories-S-student.md) | Student | Learner progressing through courses | 95 | 43 | 29 | 21 | 2 |
| [stories-T-st.md](user-stories/stories-T-st.md) | Teacher | Graduate who teaches peers (earns 70%) | 35 | 16 | 9 | 10 | 0 |
| [stories-E-employer.md](user-stories/stories-E-employer.md) | Employer/Funder | Third party paying for student enrollment | 6 | 0 | 5 | 1 | 0 |
| [stories-V-video.md](user-stories/stories-V-video.md) | System (Video) | Automated video session functionality | 11 | 4 | 6 | 1 | 0 |
| [stories-P-platform.md](user-stories/stories-P-platform.md) | Platform/System | Platform infrastructure and automation | 100 | 57 | 19 | 19 | 5 |
| [stories-M-moderator.md](user-stories/stories-M-moderator.md) | Community Moderator | Course community support staff | 9 | 2 | 6 | 1 | 0 |

---

## Summary Statistics

| Category | P0 | P1 | P2 | P3 | Total |
|----------|----|----|----|----|-------|
| Visitor/Guest | 11 | 7 | 0 | 0 | 18 |
| Admin | 35 | 19 | 6 | 0 | 60 |
| Creator | 16 | 25 | 14 | 1 | 57 |
| Student | 43 | 29 | 21 | 2 | 95 |
| Teacher | 16 | 9 | 10 | 0 | 35 |
| Employer/Funder | 0 | 5 | 1 | 0 | 6 |
| Session (System) | 4 | 6 | 1 | 0 | 11 |
| Platform/Infrastructure | 57 | 19 | 19 | 5 | 100 |
| Community Moderator | 2 | 6 | 1 | 0 | 9 |
| **Total** | **184** | **125** | **73** | **8** | **391** |

---

## Story Format

Stories follow the format: **As a [role], I need to [action] so that [benefit].**

**Story ID Format:** `US-[Role][NNN]` where:
- `US` = User Story prefix
- `[Role]` = Single letter for role (G=Guest/Visitor, A=Admin, C=Creator, S=Student, T=Teacher, E=Employer, V=Video/Session, P=Platform, M=Moderator)
- `[NNN]` = Zero-padded 3-digit number (001-999)

**Priority levels:**
- **P0:** MVP critical - required for Genesis Cohort launch
- **P1:** High priority - needed for full flywheel validation
- **P2:** Medium priority - enhances experience
- **P3:** Nice to have - future consideration

---

## User Roles

| Role | Code | Description |
|------|------|-------------|
| **Visitor/Guest** | G | Non-logged in user browsing public site |
| **Student** | S | Learner progressing through courses |
| **Teacher** | T | Graduate who teaches peers (earns 70%) |
| **Creator-Instructor** | C | Course creator who may also teach directly |
| **Employer/Funder** | E | Third party paying for student enrollment |
| **Admin (AP Rep)** | A | Platform operations and oversight |
| **System (Video)** | V | Automated video session functionality |
| **Platform/System** | P | Platform infrastructure and automation |
| **Community Moderator** | M | Course community support staff (appointed by Creator) |

---

## Current State

| Role | Prefix | Next Number |
|------|--------|-------------|
| Visitor/Guest | US-G | US-G019 |
| Admin | US-A | US-A061 |
| Creator | US-C | US-C058 |
| Student | US-S | US-S096 |
| Teacher | US-T | US-T039 |
| Employer/Funder | US-E | US-E007 |
| Session (System) | US-V | US-V012 |
| Platform/Infrastructure | US-P | US-P109 |
| Community Moderator | US-M | US-M010 |

---

## Source Document Index

| ID | Document | Stories Added |
|----|----------|---------------|
| CD-001 | Business Plan | US-C021, US-T012 |
| CD-002 | Feature Summary | US-C005, US-C009–C010, US-C021–C023, US-S003–S007, US-S009–S012, US-S019, US-S021–S025, US-T004–T005, US-T007, US-T013, US-V007, US-P001–P006 |
| CD-003 | User Stories | US-A001–A025, US-C001–C020, US-S001–S002, US-S008, US-S013–S018, US-S020, US-S026–S027, US-T001–T011, US-E001–E006, US-V001–V006 |
| CD-004 | Impact Filter | US-A023 |
| CD-008 | Meeting - Budget/Feed | US-S028 |
| CD-010 | Miro - Main Activities | US-S029–S031, US-C024–C027, US-P051–P055, US-M001–M005 |
| CD-011 | Miro - Drivers | US-S032–S035, US-T014–T016, US-C028–C030, US-P056–P059 |
| CD-012 | MVP Review | US-P060–P064 |
| CD-013 | Community Feed | US-S036–S041, US-T017–T018, US-C031–C032, US-M006–M009 |
| CD-014 | Video Conferencing | US-T019, US-S042–S043 |
| CD-015 | Calendar/Scheduling | US-S044–S046, US-P065 |
| CD-018 | Student Profile System | US-S047–S051, US-T020–T022, US-P066–P070 |
| CD-019 | Course Content Delivery | US-S052–S056, US-C033–C034, US-P071–P073 |
| CD-020 | Payment & Escrow | US-A026–A030, US-P074–P076, US-T023, US-C035 |
| CD-021 | Database Schema | US-S057–S061, US-C036 |
| CD-023 | Goodwill Points | US-S062–S068, US-T024–T029, US-P077–P082 |
| CD-024 | Brian Walkthrough | US-S069–S071, US-C037–C038, US-P083–P085 |
| CD-025 | Intro to Claude Code | US-S072–S075, US-C039–C042 |
| CD-029 | Block Sequence | US-G016–G018, US-T030–T032, US-C043–C044, US-P086–P090 |
| CD-032 | Fraser Meeting Notes | US-A031–A033, US-C045–C048, US-S076–S082, US-T033, US-P091–P101 |
| CD-033 | Teacher Pricing | US-S083–S086 |
| CD-034 | Brian Review Decisions | US-A034–A039, US-C049–C057, US-S087–S095, US-T034–T038, US-P102–P108 |
| Gap Analysis | Tech Research | US-G001–G015, US-P007–P050, US-V008–V011 |
| SCOPE | run-001 Page Requirements | US-A040–A060 |

---

## How to Use

### Find a Story
1. Identify the role (see Role table above)
2. Open the corresponding story file
3. Find the story by ID or description

### Add a New Story
1. Check "Current State" for the next available number
2. Add the story to the appropriate role file
3. Update the "Current State" section in this index
4. Update the Summary Statistics if needed

### Update a Story
1. Find the story in its role file
2. Update priority, source, or description as needed
3. Update statistics in this index if priority changed

---

## Notes for Implementation

1. **P0 stories (184 total)** are required for Genesis Cohort launch with 4-5 founding creators
2. **Student-to-student messaging (US-S017)** flagged as "tricky" - needs careful design to prevent abuse
3. **Role switching (US-T005)** is critical UX - single account with multiple role views
4. **Post-session assessment (US-V006)** enables quality tracking for flywheel validation
5. **Earnings dashboard (US-T013, US-S012)** essential for demonstrating value to Teachers

# Alpha Peer - Client Documents Index

**Purpose:** Track all client-provided documents with upload dates and concise summaries focused on utility for SPECS.md creation.

**Process for adding new documents:**
1. Drop file(s) into `/MyResearch/file_holding/` on your Mac
2. Drag file(s) from file_holding into Claude Desktop chat
3. Type `/add-client-doc` (no parameters needed)
4. Claude automatically:
   - Detects which files were uploaded
   - Reads and analyzes each document
   - Moves files to `/client-docs/`
   - Adds entries to this index
   - Deletes files from file_holding
   - Updates session file

**Supports batch processing:** Drag multiple files at once and use single `/add-client-doc` command.

---

## Document Entries

### CD-001: Alpha_Peer_Business_Plan_92825old.pdf
**Date Uploaded:** 2025-11-25
**Summary for SPECS.md:**

Comprehensive business plan defining Alpha Peer's core concept: a peer-to-peer AI education platform built on a "Learn, Teach, Earn" flywheel model.

**Key elements for SPECS.md:**
- **Business Model:** Three-sided network (Course Creators, Student-Teachers, Students) with 15/15/70 revenue split
- **Core User Journey:** Students master courses, become Student-Teachers, earn 70% commission teaching others
- **Value Propositions:** 
  - Creators: 15% perpetual royalty, community ownership tools
  - Student-Teachers: Earn while mastering material (protégé effect)
  - Students: Recoup 70% of course fee by teaching one peer
- **Pedagogical Foundation:** Solves Bloom's 2-Sigma Problem through scalable 1-on-1 peer tutoring
- **Target Market:** Initially AI education (strategic beachhead), expandable to any skill-based learning
- **Platform Features:** Creator community hubs, forums, role management, peer verification systems
- **Go-to-Market:** Phase 1: Recruit 10-15 AI educators; Phase 2: Genesis cohorts; Phase 3: Flywheel ignition
- **Competitive Differentiation:** Creates new category vs. Coursera/Udemy's linear marketplace model
- **Monetization:** 15% platform fee per transaction, scalable through network effects

**Technical Implications:**
- Needs user roles system (Creator, Student-Teacher, Student)
- Payment/commission distribution engine (15/15/70 split)
- Course mastery verification system
- Community features (forums, chat, role management)
- Student-to-teacher transition workflow
- Creator community hub infrastructure

**Non-Functional Requirements:**
- Must support exponential growth (viral flywheel)
- Quality assurance through peer verification
- Secure payment processing
- Community engagement metrics
- Student-to-teacher conversion rate tracking

---

### CD-002: Feature_Summary_WIPold.pdf
**Date Uploaded:** 2025-11-29
**Summary for SPECS.md:**

Detailed feature specification and UI/UX design document outlining the complete platform architecture for Rapid Learning Community (Alpha Peer). Includes 11 pages of UI mockups created with Cursor.

**Key elements for SPECS.md:**
- **Three Core Pillars:**
  1. Community Flywheel: Learn → Certify → Teach → Grow cycle (based on "Helper Therapy Principle")
  2. Monetization Engine: 70% Student-Teacher, 15% Creator, 15% Platform split (flexible per creator, platform minimum required)
  3. Credentialing System: Learning Certificates, Teaching Certificates, Community Roles (paid assistants with revenue sharing), Reputation System

- **Core Features to Build:**
  - **Creator & Course Hub:** Open EdX LMS integration, flexible assessments, creator profiles
  - **Algorithmic X.com-Style Feed:** Intelligent content prioritization, teacher discovery, session booking/purchasing
  - **Student Lifecycle Engine:** Unified dashboard, dual-certificate system, public profiles, gated communities, earnings tracking
  - **Screen Sharing:** Big Blue Button integration for peer-to-peer sessions with flexible content delivery (BYO lesson plans, web apps)
  - **AI Integration:** Strategic force multiplier for personalization and efficiency

- **UI/UX Navigation Structure (with mockups in PDF):**
  - Browse Menu: Course search, Creator/Instructor search with detailed profiles
  - My Community: X.com-style algorithmic feed of followed content
  - Dashboard: Student/teacher activity tracking, calendar, quick actions
  - Messages: Private messaging system
  - Profile: Student-Teacher vs Creator-Instructor views with "Switch User" and "Creator Studio" buttons

- **Course Detail Page Elements:**
  - Curriculum outline with time estimates
  - Creator profile card with stats (Active Student-Teachers, Avg Taught per Teacher, badges)
  - Action buttons: Enroll, Explore Teaching, Follow Course, Join Community
  - Related courses suggestions

- **Tech Stack Decisions:**
  - LMS: Open EdX for content creation and delivery
  - Social Feed: Bluesky protocol for community posts
  - Video: Big Blue Button for 1-on-1 sessions with screen sharing

**Technical Implications:**
- Integration layer between Open EdX, Bluesky, and Big Blue Button
- Algorithmic feed engine for content relevance and engagement
- Dual-mode profile system (Student-Teacher vs Creator-Instructor)
- Certificate issuance and verification system (Teaching Certificate dynamically updates with student count)
- Revenue tracking and distribution dashboard
- Gated community access control based on credentials
- Real-time scheduling and video conferencing integration
- Creator Studio for course management (Open EdX wrapper)
- Community Roles system with revenue sharing for creator assistants

**Non-Functional Requirements:**
- Social media-like endless scrolling engagement ("TikTok for education")
- Simple, clean X.com-inspired interface design
- Seamless role switching between student and creator modes
- Real-time updates for community feed
- Scalable video conferencing infrastructure
- Flexible revenue split configuration per creator (with platform minimum)

**Key Design Decisions:**
- X.com interface pattern for familiarity and engagement
- Community feed as marketing funnel (discovery → enrollment)
- Creator control over community organization and content delivery
- Screen sharing enables web-based collaborative learning beyond LMS constraints
- AI as fabric-level integration, not add-on feature
- "Switch User" button enables fluid role transitions within single account

---

### CD-003: Alpha Peer User Stories • Nov 29 2025.pdf
**Date Uploaded:** 2025-11-29
**Summary for SPECS.md:**

Working-level user stories document defining routine operational needs across 6 user roles. Organized as "mini user stories" in tabular format.

**Key elements for SPECS.md:**

- **User Roles Defined:**
  1. **Admin (AP Rep):** Platform operations and oversight
  2. **Creator-Instructor:** Course creators who also teach
  3. **Student:** Learners who can progress to teaching
  4. **Student-Teacher:** Students who have leveled up to teach
  5. **Employer/Funder:** Third parties paying for student enrollment
  6. **Tutor Session:** System entity for live sessions

- **Admin/Platform Needs:**
  - Enroll and cancel teachers/students (with reasons)
  - Payment distribution from enrollments; refunds and chargebacks
  - Vet teacher certificates
  - Third-party organization billing with progress/completion reporting
  - Email marketing for referrals from students/teachers
  - Facilitate video sessions with recording, AI summaries/transcripts, time tracking, screen sharing
  - Store session metadata (date/time/participants)
  - Analytics: user retention, course stats, fee tracking, session monitoring, student-to-teacher conversion, grade averages, user acquisition sources

- **Creator-Instructor Needs:**
  - Availability calendar for tutoring
  - Course content management: syllabi, quizzes, reference materials, completion criteria, progression/leveling
  - Rich profile (pictures, videos, PDFs)
  - Session/student cancellation
  - Vet and monitor student-turned-teachers
  - Messaging: students, AP platform
  - Course retirement
  - Certificate granting
  - Student progress assessments
  - Referral capability
  - AI assistance during sessions
  - Earn teaching certificates (displayed on profile)

- **Student Needs:**
  - Pay for tutors; view available courses
  - Profile with public/private sections
  - Cancel course (with reason); reschedule/cancel sessions
  - Messaging: teachers, other students (noted as "tricky"), AP
  - Referral capability
  - Apply for teacher status
  - AI assistance during sessions

- **Student-Teacher Needs:**
  - Availability calendar
  - Rich profile (pictures, videos, PDFs)
  - Session cancellation
  - Messaging: students, AP
  - Grant completion certificates
  - Referral capability
  - AI assistance during sessions

- **Employer/Funder Needs:**
  - Pay for student course enrollment
  - Receive student progress/completion reports
  - Receive copy of certifications
  - Profile (potentially all private)
  - Messaging: AP, their funded students

- **Tutor Session Requirements:**
  - Video chat with participant limits
  - In-session messaging and file sharing
  - Time monitoring
  - Conversation recording
  - Post-session assessment by each participant

**Technical Implications:**
- Multi-role user system with role-specific permissions and views
- Payment processing: enrollment fees, refunds, chargebacks, third-party billing
- Video conferencing integration with recording, AI transcription, screen sharing
- Session data storage with comprehensive metadata
- Messaging system with role-based routing (student-to-student flagged as complex)
- Certificate issuance and verification system
- Course lifecycle management (create, update, retire)
- Analytics dashboard for platform metrics
- Referral tracking system
- AI integration for in-session assistance

**Non-Functional Requirements:**
- Secure payment handling with chargeback support
- Video session reliability and quality
- Data retention for session recordings and transcripts
- Privacy controls for employer/funder profiles
- Scalable messaging infrastructure
- Real-time session monitoring capabilities

**New Requirements Not in Previous Docs:**
- Employer/Funder role (B2B sponsorship model)
- Chargeback handling for teacher cancellations
- Post-session mutual assessments
- Course retirement workflow
- Student-to-student messaging (flagged as needing careful design)
- User acquisition source tracking

---

### CD-004: The Impact Filter 110425 Mission Statement.pdf
**Date Uploaded:** 2025-11-29
**Summary for SPECS.md:**

Strategic planning document (dated 10/29/2025) using the "Impact Filter" framework to define Alpha Peer's purpose, success criteria, and vision. Authored by Brian LeBlanc.

**Key elements for SPECS.md:**

- **Purpose Statement:**
  Launch Alpha Peer as a functioning peer-to-peer learning platform for AI education with three founding course creators. Validate that students transition to paid Student-Teachers, proving the learn-teach-earn flywheel creates self-sustaining teaching capacity.

- **Quantified Success Criteria (MVP Validation Targets):**
  | Metric | Target | Rationale |
  |--------|--------|-----------|
  | Student-to-Teacher Conversion | 10% (ideal: 20%) | Proves flywheel creates value beyond learning |
  | Student-Teacher Satisfaction | ≥95% | Validates peer teachers can effectively guide others |
  | Learning Outcomes (grades) | ≥90% average | Maintains educational quality |
  | Course Completion Rate | ≥75% | Far above MOOC industry average of 15-20% |
  | Monthly Active User Retention | 60% higher than traditional platforms | Measured via login frequency, forum participation, session bookings |
  | Student-Teacher Recruitment | ≥2 new students per teacher in first 3 months | Evidence of exponential growth pattern |
  | Break-even Timeline | 12 months to cover operational costs | 15% platform fee viability at scale |

- **Ideal Outcome Vision:**
  - Three thriving course communities with daily peer-to-peer teaching
  - Collaborative (not transactional) atmosphere
  - Creators earn meaningful income while Student-Teacher networks expand organically
  - Creators spend time deepening content rather than repetitive teaching
  - Students feel connected; don't want to let peers down
  - Student-Teachers report deeper mastery through teaching

- **Best Result (Success Vision):**
  - Each founder creator builds 50+ active Student-Teachers
  - Sustainable income streams for creators
  - Students earn back course fees by teaching others
  - Attracts investment interest
  - Expansion beyond AI into other skill-based learning
  - Creates new category in online education

- **Worst Result (Failure Scenario):**
  - Miss critical window in AI education market
  - Model remains theoretical and unproven
  - Competitor captures space with inferior approach
  - Course creators stuck in one-to-many teaching models

- **Monetization Note:**
  - 15% platform fee as primary revenue
  - Also considering monthly subscription fee for creators

- **Core Philosophy:**
  - Solves the "2 Sigma Problem" by democratizing 1-on-1 tutoring
  - Teaching deepens understanding for both parties (protégé effect)
  - Education as reciprocal relationship, not one-way transaction
  - Aligns financial incentives with pedagogical best practices

**Technical Implications:**
- Analytics dashboard must track all success metrics listed above
- Student-to-teacher conversion funnel tracking
- Satisfaction/rating system for peer teaching sessions
- Grade/assessment tracking at course and platform level
- User retention and engagement metrics
- Referral tracking (students recruited per teacher)
- Revenue/transaction volume reporting

**Non-Functional Requirements:**
- Platform must support 3 creators with 50+ Student-Teachers each at MVP
- Performance to enable daily peer-to-peer session activity
- Forum and community engagement features
- Session booking system

**Key Insights for Development:**
- MVP scope: 3 founding creators, their initial cohorts
- Primary validation: Does the flywheel work? (conversion rate is key metric)
- Quality bar: 75% completion, 90% grades, 95% satisfaction
- Growth proof: Each teacher recruits 2+ students in 3 months

---

### CD-005: Slack Message - GetStream Feed Discussion
**Date Uploaded:** 2025-11-30
**Original Date:** 2025-11-13
**Summary for SPECS.md:**

Client Slack message clarifying technology preferences and MVP priorities for the social feed component.

**Key elements for SPECS.md:**

- **Technology Decision:** GetStream.io mentioned as preferred solution for algorithmic feed
  - Specifically wants the "feed option" from GetStream
  - Target UX: X.com, Skool.com, Substack.com style feeds
  - Purpose: "users to gather in a common area and see relevant posts based on their interests"

- **MVP Requirements (client's stated priorities):**
  1. Profiles
  2. Payments
  3. Calendar options
  4. Algorithmic feed (interest-based content)

- **Discord Evaluation:**
  - Acceptable as temporary solution for initial technical users
  - Client explicitly states: "I really don't like the idea of discord"
  - "would be ok for technical users who we will target initially"
  - Must be replaced by in-site X.com-style feed "in the near future"
  - Discord is a compromise, not a preference

- **Feed Vision:**
  - Common gathering area for users
  - Interest-based content relevance ("relevant posts based on their interests")
  - Social media-style engagement pattern (X.com, Skool.com, Substack.com)

**Technical Implications:**
- GetStream.io integration for activity feeds (or equivalent)
- Interest/preference system for algorithmic content delivery
- Profile system must support feed interactions
- Calendar integration for scheduling
- Payment processing for transactions

**Relationship to Other Docs:**
- Reinforces CD-002's "Algorithmic X.com-Style Feed" requirement
- Provides specific technology choice (GetStream.io) vs CD-002's mention of Bluesky protocol
- **Chronology Note:** This message (Nov 13) predates CD-002 (Nov 29)
- **⚠️ Requires Clarification:** GetStream.io vs Bluesky protocol—which is current preference? Later document (CD-002) typically takes precedence, but Stream is already marked REQUIRED in tech research

**Goals Referenced:** GO-010 (Community & Engagement Features)
**Stories Referenced:** US-S025, US-P002

---

### CD-006: Slack Message - Calendar, BBB, Discord Discussion
**Date Uploaded:** 2025-11-30
**Original Date:** 2025-11-16
**Summary for SPECS.md:**

Client Slack message clarifying infrastructure priorities and technology decisions for scheduling, video, and real-time communication.

**Key elements for SPECS.md:**

- **Calendar Feature:** "Full blown calendar feature" required
  - Rationale: Avoid manual behind-the-scenes scheduling management
  - Core MVP component alongside profiles
  - Client quote: "we don't have to try and keep up behind the scenes with scheduling"

- **Video Conferencing:** BigBlueButton (BBB) confirmed
  - Use hosted service providers (not self-hosted)
  - Pricing model: Per-session vs per-user (cost savings vs Zoom)
  - Avoids user-paid monthly fees (reduces friction)
  - Client quote: "BBB charges by the session instead of by the user. This is a huge cost savings versus zoom"

- **Real-Time Communication:** Discord accepted as interim solution
  - Alternatives mentioned: Slack, Telegram
  - Users will need to set up external accounts
  - Implies real-time chat is not MVP priority for in-platform build

- **Cost Considerations:**
  - BBB per-session pricing preferred over Zoom per-user pricing
  - Avoiding user-paid monthly fees reduces friction and overhead
  - Hosted BBB services preferred over self-hosting

**Technical Implications:**
- Calendar system must be robust ("full blown")
- BBB integration via hosted provider API
- External chat platform (Discord/Slack/Telegram) for real-time communication initially
- No immediate need to build in-platform real-time chat for MVP

**Relationship to Other Docs:**
- Reinforces CD-002's BigBlueButton mention for video sessions
- Reinforces CD-005's Discord as interim solution
- Confirms calendar as MVP priority (also mentioned in CD-005)
- **Chronology:** Nov 16 - between CD-005 (Nov 13) and CD-002 (Nov 29)

**Goals Referenced:** GO-009 (Video Session Infrastructure)
**Stories Referenced:** US-C006, US-T001, US-P020–P025 (calendar stories)

---

### CD-007: Slack Message - BBB Alternatives & P2P Video Research
**Date Uploaded:** 2025-11-30
**Original Date:** 2025-11-18
**Summary for SPECS.md:**

Client research on video conferencing alternatives to BBB, specifically optimized for 1:1 peer tutoring sessions.

**Key elements for SPECS.md:**

- **P2P Architecture Insight:** For 1:1 sessions, Peer-to-Peer architecture is critical
  - Video data travels directly between devices
  - Bypasses expensive SFU (Selective Forwarding Unit) servers
  - Benefits: Lower latency, higher security, significantly lower costs

- **Three Options Evaluated:**

  | Service | Best For | Free Tier | Key Feature |
  |---------|----------|-----------|-------------|
  | Digital Samba | Low code (iframe) | 10,000 mins/mo (~83 hrs 1:1) | Pre-built Zoom-like UI |
  | Daily.co | Developer SDK | 10,000 mins/mo | Auto P2P switching for 1:1 |
  | VideoSDK.live | Scale/cost priority | N/A | $0.003/min (below industry $0.004) |

- **Daily.co Highlighted Feature:** Automatic P2P switching
  - 2 people → P2P mode (efficient)
  - 3+ people → SFU mode (seamless switch)
  - Many competitors always use SFU (inefficient for 1:1)

- **Whereby Warning:** Recently imposed 30-minute limit on free calls (avoid)

- **Client Recommendations:**
  - Digital Samba: Quick integration, no UI code needed
  - Daily.co: Professional SDK with intelligent P2P handling

**Technical Implications:**
- 1:1 tutoring sessions benefit from P2P-optimized solutions
- May reconsider BBB if primarily 1:1 sessions (P2P alternatives more cost-effective)
- Daily.co offers best developer experience with automatic optimization
- Digital Samba offers fastest time-to-market

**Relationship to Other Docs:**
- **Potentially supersedes CD-006's BBB preference** for 1:1 use case
- Aligns with CD-006's cost-consciousness (avoiding per-user fees)
- **Chronology:** Nov 18 - after CD-006 (Nov 16), before CD-002 (Nov 29)
- CD-002 still mentions BBB - may be for group sessions vs 1:1

**⚠️ Requires Clarification:**
- Daily.co vs Digital Samba vs BBB - final decision?
- BBB for groups + P2P for 1:1? Or single solution?

**Goals Referenced:** GO-009 (Video Session Infrastructure)
**Stories Referenced:** US-V001, US-V002, US-T007, US-A014

---

### CD-008: Meeting Transcript - Budget, Timeline, Community Feed
**Date Uploaded:** 2025-11-30
**Original Date:** 2025-11-26
**Summary for SPECS.md:**

Meeting transcript capturing Brian's (client) stated positions on budget, timeline, and community feed priorities.

**Key elements for SPECS.md:**

- **Budget & Timeline (NEW):**
  - Budget: **$75,000** (increased from earlier conservative estimates)
  - Timeline: **4 months**
  - Client quote: "I want to take a bigger risk"

- **Community Feed - Critical MVP Priority:**
  - Must build now, not later: "would be a nut house after the fact"
  - Fallback value: Even if thesis fails, "I'll have a tutoring site with unique functionality"
  - Purpose: **Marketing funnel** that overcomes resistance to purchase

- **Community Feed as Marketing Funnel (User Journey):**
  1. Student arrives → sees courses → clicks "follow" to explore
  2. Sees creator → clicks "follow"
  3. Subject/course feeds appear in their community feed
  4. Social proof: "I took this course, built this app, got 8 weeks work in a week"
  5. Public discussion of pros/cons
  6. Conversion: "You can talk somebody into the course"
  7. Retention: After course, stay in community to teach others

- **Stream (GetStream.io) - Clarified Scope:**
  - **Feeds only** - not their video conferencing
  - Chat is "much lower on the priority list"
  - Quote: "The community feeds is all I want out of there"

- **Skool.com as Prototype:**
  - Agreed to use Skool as reference for community feed design
  - Quote: "Let's use Skool as the prototype to build our community feed"

- **Core Philosophy - Human Connection:**
  - "People motivate people. Computers don't motivate people."
  - "The human connections are overlooked in this quest to educate people"
  - "Just the one hour paid session is not enough of a connection"
  - Self-paced sites create isolation; community feed combats this

- **Video Conferencing:**
  - Jitsi mentioned as possibility (from Claude/Q feedback)
  - Concern: "doesn't seem like it's quite as full featured"

**Technical Implications:**
- Stream integration scoped to feeds only (reduces complexity)
- Community feed is MVP-critical, not post-launch
- Skool.com UX patterns should inform feed design
- 4-month timeline requires focused scope

**Relationship to Other Docs:**
- **Supersedes** earlier budget/timeline assumptions
- **Clarifies** CD-005's Stream mention (feeds only, not chat)
- **Reinforces** CD-005's feed priority
- Adds Jitsi to video options (CD-006, CD-007)
- **Chronology:** Nov 26 - after CD-007 (Nov 18), before CD-002 (Nov 29)

**Goals Referenced:** GO-010, GO-014 (Community & Combat Isolation)
**Stories Referenced:** US-S025, US-P002, US-S001, US-S006

---

### CD-009: Slack Conversation - BBB Blindside Networks & Cloudflare Setup
**Date Uploaded:** 2025-11-30
**Original Date:** 2025-11-28
**Summary for SPECS.md:**

Slack conversation confirming BBB hosting provider selection and Cloudflare deployment.

**Key elements for SPECS.md:**

- **BBB Hosting Provider Confirmed:** Blindside Networks (https://blindsidenetworks.com/)
  - They are the original creators of BigBlueButton
  - Managed hosting - no SSH/root access (security/stability)
  - Control via API or LMS integration
  - Custom configurations, usage reports, and logs available on request

- **Managed Hosting Rationale:**
  - Quote: "It will get us to market quicker. We have lots of moving parts. We need to cut corners where ever possible."
  - Speed to market is priority over self-hosting flexibility

- **Cloudflare Hosting Confirmed:**
  - Domain: **peerloop.com** set up on Cloudflare free tier
  - Generic splash page deployed
  - Quote: "I setup a cloudflare free site, pointed dns and setup a generic splash page. Free is good lol"

- **Landing Page Purpose:**
  - Form for prospective students and creators to invite
  - Logo pending (Brian's wife will design)

**Technical Implications:**
- BBB integration will be API-based (no server customization)
- Cloudflare free tier for hosting (confirms comp-001 preference)
- peerloop.com is the production domain
- Managed services preferred over self-hosting for speed

**Relationship to Other Docs:**
- **Confirms** CD-006's BBB decision with specific provider
- **Confirms** comp-001's Cloudflare preference
- **Reinforces** CD-008's "cut corners" / speed-to-market priority
- **Chronology:** Nov 28 - after CD-008 (Nov 26), before CD-002 (Nov 29)

**Goals Referenced:** GO-009 (Video Session Infrastructure), GO-018 (Budget/Timeline)
**Stories Referenced:** US-V001-V007, US-A013-A018 (video/session stories)

---

### CD-010: Miro Board - Main Activities by Role
**Date Uploaded:** 2025-11-30
**Source:** Miro Board Screenshot - [Peer Loop] Project Board
**Summary for SPECS.md:**

Visual board mapping main activities and pain points for each user role. Introduces Community Moderator as a new distinct role.

**Key elements for SPECS.md:**

- **Five User Roles Mapped (with activities and pain points):**

  | Role | Primary Activities | Key Pain Points |
  |------|-------------------|-----------------|
  | **Student** | Sign up, Browse courses, Pay/enroll, Complete courses, Apply for Teacher Student | Isolation/dropout, Lack of feedback, Confusing learning flow, Inability to matchmake teacher |
  | **Teacher Student** | Apply to teach (creator approves), Track student activity, Earn commission, Provide feedback, Create availability calendar, Earn teaching certificate | Cost recovery, Timely feedback pressure, Confusing application process, Student-teacher mismatch risk |
  | **Course Creator (Author)** | Develop curriculum, Assign Teacher Students, Earn royalty, Gather feedback, Host AMAs, Build personal brand, Appoint moderators | Building supportive community, Ensuring Teacher Student quality, Course visibility, Lack of content, Real-time communication needs |
  | **Platform Admin** | Manage configurations, User management, Platform analytics | (none listed) |
  | **Community Moderator** | Support staff, Answer questions, Troubleshoot issues, Moderate chats, Add users to closed chats | (none listed) |

- **NEW ROLE: Community Moderator** - Distinct from Course Creator, handles day-to-day community support

- **Student Engagement Features:**
  - Goodwill points system
  - "Power user" progression
  - Teacher Student matchmaking (random is default)
  - Discussion participation

- **Teacher Student Economics:**
  - Commission per mentored student
  - Teaching certificate as credential
  - Calendar-based availability

- **Creator Revenue Model:**
  - Course fee royalty
  - Newsletter possibility with subscription payments (question raised)
  - Moderator assistants for scaling

- **Pain Points Theme:** Communication, feedback loops, and community building are recurring challenges across all roles

**Technical Implications:**
- Moderator role requires distinct permissions (not just creator sub-role)
- Goodwill points/gamification system needed
- Teacher matchmaking algorithm (with random fallback)
- Newsletter/subscription infrastructure (potential feature)
- Calendar integration for Teacher Students and Creators

**Relationship to Other Docs:**
- Expands on CD-003's role definitions with visual activity mapping
- Adds Community Moderator role not explicitly in CD-003
- Reinforces pain points around isolation (aligns with GO-014)
- Confirms teaching certificate concept from CD-003

**Goals Referenced:** GO-003 (sustainable income), GO-008 (multi-role system), GO-014 (combat isolation)
**Stories Referenced:** US-C022 (Community Roles), US-S020 (apply for teacher status), US-T001 (calendar availability)

---

### CD-011: Miro Board - Drivers & Action Items
**Date Uploaded:** 2025-11-30
**Source:** Miro Board Screenshot - [Peer Loop] Project Board
**Summary for SPECS.md:**

Detailed mapping of user drivers (motivations/needs) and corresponding action items (platform features) for Student, Teacher Student, and Course Creator roles.

**Key elements for SPECS.md:**

- **DRIVERS by Role (What motivates users to engage):**

  | Role | Key Drivers |
  |------|-------------|
  | **Student** | Friendly community, high-quality mentorship, cost recoup, AI assistance, diverse content, course discovery, teacher selection, content requests, opt-out ability, mastery certificate |
  | **Teacher Student** | Community access, income/cost recovery, synchronous communication, clear application process, opt-out ability, verifiable mastery (career advancement) |
  | **Course Creator** | User-friendly course management, strong community, royalty income, easy teacher approval, student activity monitoring, teaching quality monitoring, loyal tribe with high switching cost |

- **ACTION ITEMS (Platform features needed):**

  | Feature | Roles Served | Technology |
  |---------|--------------|------------|
  | Community tool (discussions, events, news) | All | Bluesky |
  | Synchronous communication | Student, Teacher Student | Big Blue Button |
  | Payment system (courses, commissions, royalties) | All | TBD |
  | AI Assistant | Student | TBD |
  | Newsletters | Student | TBD |
  | Mastery Certificate (separate from completion) | Student | Custom |
  | Teacher points/motivation system | Teacher Student | Custom |
  | Teacher Student application functionality | Teacher Student | Custom |
  | Content request form | Student | Custom |
  | Teacher Student approval functionality | Creator | Custom |
  | Extended course analytics | Creator | Custom |
  | Student feedback access (per Teacher Student) | Creator | Custom |
  | Flexible filtering | Creator | Custom |

- **NEW REQUIREMENT - Two Certificate Types:**
  1. **Certificate of Completion** - Standard course completion
  2. **Certificate of Mastery** - Separate credential confirming deeper understanding

- **BBB Pricing Model:** Usage-based fee (per session) to creator for unlimited BBB use

- **Bluesky Confirmed:** Explicitly mentioned as community tool for all three roles

- **Opt-Out for Both Parties:** Both Students AND Teacher Students need ability to exit relationships gracefully

- **Teacher Motivation:** Points system to encourage Teacher Student activity

- **Content Gap Handling:** Students can request content that doesn't exist yet

**Technical Implications:**
- Bluesky integration for community features (confirms CD-002 mention)
- Dual certificate system (completion vs mastery)
- Bidirectional opt-out workflow for Student-Teacher relationships
- Content request/suggestion system
- Teacher Student gamification (points, activity tracking)
- Per-session BBB billing for creators

**Relationship to Other Docs:**
- Confirms Bluesky for community (aligns with CD-002)
- Expands on CD-010's activities with underlying motivations
- Adds mastery certificate concept (new)
- Clarifies BBB pricing model (per-session)

**Goals Referenced:** GO-002 (2 Sigma), GO-003 (sustainable income), GO-014 (combat isolation), GO-019 (gamification)
**Stories Referenced:** US-S029 (matchmaking), US-S021-S022 (certificates), US-T012 (commissions)

---

### CD-012: Meeting Prep - MVP Spec Review with Fraser & Gabriel
**Date Uploaded:** 2025-12-04
**Prepared:** December 2, 2025
**Summary for SPECS.md:**

Comprehensive meeting preparation document for MVP spec review with developer (Fraser) and strategic advisor (Gabriel). Consolidates all 8 decided MVP features with budget and timeline tracking.

**Key elements for SPECS.md:**

- **8 MUST HAVE MVP Features (Decided):**

  | # | Feature | Dev Cost | Timeline |
  |---|---------|----------|----------|
  | 1 | Video Conferencing (BBB hosted) | $2.4K-3.6K/yr | - |
  | 2 | Community Feed (getstream.io) | $3.4K-5.7K/yr | - |
  | 3 | Calendar/Scheduling | $1.7K-3.8K | 1-2 weeks |
  | 4 | Student Profile System | $14K-18.7K | 3-4 weeks |
  | 5 | Creator Profiles | $500 | <1 week |
  | 6 | Rebrand to PeerLoop | Complete | Done |
  | 7 | Payment & Escrow | $11K-15K | 2-3 weeks |
  | 8 | Course Content Delivery | $2K-4K | ~1 week |

- **Budget Status:**
  - Phase 1 Budget: **$75,000** (confirms CD-008)
  - Allocated: $46K-62K (61-83%)
  - Remaining: $13K-29K
  - Status: Getting tight

- **Timeline Milestones:**
  - MVP Spec Deadline: **Dec 6, 2025**
  - Build Period: Dec 6 → Apr 1 (~4 months)
  - Genesis Cohort: Apr 1 → Jun 1 (60-80 students)

- **Genesis Cohort Size:** 60-80 students across 4-5 courses (refines earlier "3 creators" estimates)

- **Operational Model Confirmed (Critical for SPECS.md):**
  - **Creators control their courses** - approve certifications, payouts, new Student-Teachers
  - **Brian (Platform) = Strategic oversight only** - ~3-4 hours/week
  - Minimal admin involvement in day-to-day operations

- **Calendar Options Under Consideration:**
  - Cal.com (Option B)
  - Custom react-big-calendar (Option D)
  - Google Calendar API (Option E)

- **Three Potential Gaps Identified:**
  1. **Certification Workflow** - ST recommends → Creator approves → Certificate issued
  2. **Student-Teacher Application Workflow** - Student applies → Creator approves → Can teach
  3. **Student Dashboard/Home** - Enrolled courses, next session, progress, quick actions

- **Gap Budget:** $2K-4K total if needed (or manual for Genesis)

- **6 Hypotheses Being Tested:**

  | # | Hypothesis | Test | Feature Coverage |
  |---|------------|------|------------------|
  | H1 | Students pay $300-600 | Genesis payments | Payment System |
  | H2 | 75%+ completion rate | Track completions | Content Delivery |
  | H3 | Two customer segments | Analyze enrollments | Profile System |
  | H4 | 10%+ become Student-Teachers | Track conversions | Profile System |
  | H5 | Peer teaching matches experts | Quality feedback | **Manual for MVP** |
  | H6 | Flywheel (2+ students recruited) | Track network growth | Profile System |

**Technical Implications:**
- GetStream.io confirmed for Activity Feeds (not chat)
- BBB via hosted provider API (Blindside Networks)
- Semi-automated payment approach (Stripe + manual payout approval)
- Course content: simple pages, external video links, self-mark progress
- Creator Dashboard for certification/payout approval workflows
- Student Dashboard as minimal viable landing experience

**Relationship to Other Docs:**
- **Consolidates** CD-008's budget ($75K) and CD-009's BBB/Cloudflare decisions
- **Confirms** GetStream for feeds (CD-005), not chat (CD-008)
- **Refines** Genesis cohort: 60-80 students (vs earlier estimates)
- **Adds** operational model detail: creator-controlled, minimal Brian involvement
- **Identifies** three workflow gaps for prioritization

**Goals Referenced:** GO-001 (flywheel), GO-004 (Genesis), GO-005 (validation metrics), GO-018 (budget/timeline)
**Stories Referenced:** US-C014 (certification), US-S020 (apply for teacher status), US-P003 (dashboard)

---

### CD-013: MVP Decision - Community Feed (getstream.io)
**Date Uploaded:** 2025-12-04
**Original Date:** 2025-11-25
**Summary for SPECS.md:**

Detailed MVP decision document for AI-sorted community feed feature using getstream.io. Documents rationale, hypothesis coverage, budget, timeline, and implementation requirements.

**Key elements for SPECS.md:**

- **Decision:** MUST HAVE - AI-sorted community feed
- **Technology:** getstream.io (SaaS feed infrastructure)
- **Approach:** SDK integration (NOT building feed from scratch)

- **Core Functionality:**
  - **Follow System:** Users can follow other users, courses, creators
  - **Content Types:** Q&A, progress updates, teaching tips, announcements, success stories, availability
  - **Social Interactions:** Like, Bookmark, Reply, Repost
  - **AI/Algorithmic Feed:** Personalized based on interests, follows, engagement, relevance, recency

- **User Role Permissions:**

  | Role | Capabilities |
  |------|-------------|
  | Students | Create posts, like/bookmark/reply/repost, follow, flag content |
  | Student-Teachers | All student + post teaching tips/availability, build following |
  | Moderators | All user + delete posts, ban users, pin posts, see flagged queue |
  | Creators | All user + course announcements, pin to course feed, analytics |
  | Brian (Admin) | Full moderation powers, override, all analytics |

- **Hypothesis Validation Coverage (5 of 6):**
  - H1: Market Positioning (community as social proof)
  - H3: Customer Segmentation (behavior reveals motivations)
  - H4: Conversion to Teaching (ST success stories inspire others)
  - H5: Peer Teaching Quality (STs share tips, get advice)
  - H6: Flywheel (STs recruit students via feed - **critical for Brian's #1 uncertainty**)

- **Budget & Timeline:**
  - Development: 2-3 weeks, $3,000-4,500 (4-6% of $75K)
  - Service: ~$100-300/month (Growth tier)
  - Total Phase 1: $3,400-5,700

- **Implementation Phases:**
  - Week 1: Core setup, SDK integration, auth, basic feed, post creation
  - Week 2: Social features (like, bookmark, reply, repost), notifications, profiles
  - Week 3: Moderation tools, testing, mobile responsiveness, polish

- **Success Metrics (Genesis Cohort):**
  - 60%+ students post weekly
  - 40%+ students engage daily
  - 3-5 posts per day per course
  - ST actively recruiting via feed
  - At least 2-3 second-gen students found ST via feed

- **Scale Consideration:** 75-100 people = perfect "village size" for community dynamics

**Technical Implications:**
- getstream.io SDK integration (React components available)
- Authentication integration with PeerLoop required
- Moderator tools: flag, delete, ban, pin
- Mobile-responsive feed UI
- ~9ms API response time from getstream.io

**Relationship to Other Docs:**
- **Expands** CD-005's GetStream mention with full decision rationale
- **Confirms** CD-008's "feeds only" scope (not chat)
- **Aligns with** CD-012's 8 MVP features list (Community Feed #2)
- Provides detailed implementation plan for Fraser

**Goals Referenced:** GO-001 (flywheel), GO-005 (validation metrics), GO-006 (engagement), GO-010 (community features)
**Stories Referenced:** US-S025 (algorithmic feed), US-P002 (My Community feed), US-S028 (follow creators)

---

### CD-014: MVP Decision - Video Conferencing Integration (BBB/Jitsi)
**Date Uploaded:** 2025-12-04
**Original Date:** 2025-11-25
**Summary for SPECS.md:**

Detailed MVP decision document for video conferencing integration. Core infrastructure enabling live 1-on-1 sessions between Student-Teachers and students.

**Key elements for SPECS.md:**

- **Decision:** MUST HAVE - Video conferencing integration
- **Preferred Platform:** Big Blue Button (or Jitsi if Fraser recommends)
- **Approach:** API integration (NOT building from scratch)
- **Deployment:** Hosted service for MVP, self-hosting option for Phase 2+

- **Core Functionality:**
  - **Students:** Schedule sessions, receive email notifications, calendar sync (Google/Outlook), join from dashboard or email, browser-based (no downloads)
  - **Student-Teachers:** Manage availability, schedule with multiple students, access recordings, teaching features (screen share, whiteboard)
  - **Platform:** Track attendance, store recordings, analytics, progress integration

- **Hypothesis Validation Coverage (4 of 6):**
  - H5: Peer Teaching Quality (enables 1-on-1 instruction)
  - H6: Flywheel (enables ST to teach their students)
  - H2: Completion Rates (accountability via live sessions)
  - H1: Market Positioning (professional video justifies premium)

- **Budget & Timeline:**
  - Development: 1-2 weeks, $1,500-3,000 (2-4% of $75K)
  - Service: $50-200/month (BBB) or $50-150/month (Jitsi)
  - Total Phase 1: $1,700-3,800

- **Platform Comparison:**

  | Feature | Big Blue Button | Jitsi |
  |---------|----------------|-------|
  | Education features | Whiteboard, breakout, polls | Basic |
  | Recording | Excellent | Good |
  | Per-session pricing | Yes | Yes |
  | Open source | Yes | Yes |
  | Self-host option | Yes (Phase 2+) | Yes |

- **MVP Scope:**
  - MUST: Calendar/scheduling, session booking, email notifications, calendar sync, API integration, attendance tracking, basic recording
  - NICE TO HAVE: Embedded video, recurring sessions, in-platform recording library
  - OUT OF SCOPE: Self-hosted servers, custom features, mobile app

- **Success Metrics (Genesis):**
  - Session completion rate >80%
  - 60-80 students using sessions successfully
  - Video quality acceptable (no major complaints)
  - Student-Teachers comfortable with platform

**Technical Implications:**
- BBB or Jitsi API integration (Fraser to evaluate)
- Calendar/scheduling system in dashboard
- Email notification system integration
- Google Calendar/Outlook sync
- Session attendance tracking
- Recording storage (service provider handles)

**Relationship to Other Docs:**
- **Expands** CD-006's BBB mention with full decision rationale
- **Expands** CD-009's Blindside Networks confirmation
- **Aligns with** CD-012's 8 MVP features list (Video Conferencing #1)
- **Clarifies** CD-007's P2P research - BBB preferred for education features

**Goals Referenced:** GO-001 (flywheel), GO-005 (validation metrics), GO-009 (video infrastructure)
**Stories Referenced:** US-V001-V007 (session stories), US-A013-A018 (session facilitation), US-T007 (video sessions)

---

### CD-015: Decision - Calendar/Scheduling System
**Date Uploaded:** 2025-12-04
**Original Date:** 2025-11-26
**Summary for SPECS.md:**

MVP decision document for calendar/scheduling system. Automated booking for 1-on-1 sessions between students and Student-Teachers.

**Key elements for SPECS.md:**

- **Decision:** MUST HAVE - Automated scheduling/booking system
- **Status:** Pending Fraser evaluation of Options B, D, or E
- **Capacity Required:** ~60 sessions/week

- **User Flow:**
  1. Student navigates to course listing
  2. Clicks "Schedule Session" button
  3. Views calendar, selects day
  4. Sees list of available Student-Teacher time slots
  5. Clicks on Student-Teacher listing, books time
  6. Both receive: email notification, in-app message, BBB link

- **Three Options for Fraser:**

  | Option | Platform | Dev Time | Dev Cost | Monthly Cost |
  |--------|----------|----------|----------|--------------|
  | B | Cal.com (Open Source) | 1-1.5 weeks | $1,700-2,850 | $12/ST ($720-960/mo) |
  | D | react-big-calendar + custom | 1.5-2 weeks | $2,550-3,800 | $0 |
  | E | Google Calendar API + Custom | 2 weeks | $3,400 | $0 |

- **Hypothesis Validation Coverage (5 of 6):**
  - H1: Market Positioning (professional booking is table stakes)
  - H2: Completion Rates (easy booking increases participation)
  - H4: Conversion to Teaching (STs set availability = commitment)
  - H6: Flywheel (critical marketplace infrastructure)
  - H3: Indirect (booking data identifies engaged vs passive)

- **Manual Alternative:** FAILS - 60 sessions/week = 10-15 hrs/week manual coordination

- **Budget Impact:**
  - One-time: $1,700-3,800
  - Option B recurring: $8,640-11,520/year
  - Options D/E eliminate recurring cost

- **Success Metrics (Genesis):**
  - 80%+ students book at least 1 session via calendar
  - <5% booking errors or failed notifications
  - <2 minutes from click to confirmed booking
  - Zero manual intervention required

**Technical Implications:**
- Integration with email notification system
- Integration with in-app messaging
- BBB link generation and delivery
- Student-Teacher availability management
- Timezone handling
- Calendar sync (if using Option E)

**Relationship to Other Docs:**
- **Depends on** CD-014 (Video Conferencing - BBB links)
- **Aligns with** CD-006's calendar priority statement
- **Aligns with** CD-012's MVP features list (#3 Calendar/Scheduling)
- Provides specific implementation options for Fraser decision

**Goals Referenced:** GO-009 (video/calendar infrastructure), GO-005 (validation metrics)
**Stories Referenced:** US-P020-P025 (calendar infrastructure), US-C006, US-T001 (availability calendars)

---

### CD-016: Decision - Rebrand from AlphaPeer to PeerLoop
**Date Uploaded:** 2025-12-04
**Original Date:** 2025-11-29
**Summary for SPECS.md:**

Branding decision document for product name change from AlphaPeer to PeerLoop.

**Key elements for SPECS.md:**

- **Decision:** APPROVED - Rebrand to PeerLoop
- **Implementation:** Immediate (documentation), Before Launch (domain/email)
- **Status:** Complete for CD-012 "Rebrand to PeerLoop" item

- **Name Change:**
  - Product: AlphaPeer → **PeerLoop**
  - Domain: alphapeer.com → **peerloop.com**
  - Subdomain: class.alphapeer.com → **class.peerloop.com**
  - Email: brian@alphapeer.com → **brian@peerloop.com**

- **Reasoning:**
  - **Trademark Conflict:** Alpha.school is actively trademarking "Alpha" names in education
  - **Risk Avoidance:** Proactive rebrand avoids potential legal issues
  - **Brand Identity:** "PeerLoop" maintains peer-to-peer focus + suggests flywheel/cycle

- **Why PeerLoop:**
  - Maintains peer-to-peer learning focus
  - "Loop" suggests continuous learning cycle, flywheel effect
  - Clean, memorable, one-word brand
  - No existing trademark conflicts in education space
  - Domain available: peerloop.com

- **Impact Assessment:**
  - **Zero Impact:** Technical architecture, features, budget/timeline, hypotheses
  - **Documentation Updates:** All MVP decisions, feature specs, meeting notes

- **Timeline:**
  - Effective: 2025-11-29
  - Launch: April 1, 2026 (as PeerLoop)
  - Domain Acquisition: ASAP

**Technical Implications:**
- Domain/DNS configuration for peerloop.com
- Email setup for @peerloop.com
- class.peerloop.com subdomain configuration
- All user-facing text, logos, branding updated
- Cloudflare already configured for peerloop.com (per CD-009)

**Relationship to Other Docs:**
- **Confirms** CD-009's peerloop.com Cloudflare setup
- **Aligns with** CD-012's MVP features list (#6 "Rebrand to PeerLoop" = COMPLETE)
- No impact on technical decisions or feature specs

**Goals Referenced:** (None - branding only, no new goals)
**Stories Referenced:** (None - branding only, no new user stories)

---

### CD-017: MVP Decision - Creator Profiles
**Date Uploaded:** 2025-12-04
**Original Date:** 2025-11-30
**Summary for SPECS.md:**

MVP decision document for creator profile functionality. Uses Q-DECIDE framework to scope basic creator profiles within unified profile system.

**Key elements for SPECS.md:**

- **Decision:** MUST HAVE (Basic Profile Only)
- **Budget:** ~$500 incremental (1 day, included in profile system)
- **Timeline:** 1 day (part of 3-4 week profile system build)

- **Scope - MVP (IN):**
  - Uses unified profile system (same as Student/ST profiles)
  - Basic profile: name, @handle, photo, bio, interests/tags
  - "Creator" role badge (visually distinct)
  - "Courses Created" label display
  - Aggregate stats: total students, average rating, course count
  - Course list linking to all created courses
  - Follow/unfollow functionality, follower/following counts
  - Payment system integration (backend creator_id)
  - Public profile (no privacy toggle - creators must be discoverable)

- **Scope - DEFERRED to Phase 2:**
  - Revenue tracking dashboard
  - Per-course analytics
  - Payout history view
  - Course creation wizard
  - Content upload interface
  - Curriculum builder
  - Creator achievements/badges
  - Creator-to-creator messaging
  - Automated payout system

- **User Flow:**
  1. Brian invites creator (Gabriel)
  2. Creator signs up, selects "Creator" role
  3. Profile auto-created, creator adds photo/bio/interests
  4. Profile visible at `peerloop.com/@gabriel`
  5. Students browse → click creator name → view profile → follow → discover courses

- **Success Metrics:**
  - 100% of 4-5 creators complete profiles
  - 40%+ students follow at least one creator
  - 100% enrollments correctly attributed to creators

- **Hypothesis Validation:**
  - H1 (Indirect): Professional presence builds trust
  - H3 (Indirect): May attract "Premium Learner-Only" segment
  - **Not primary validation** - necessary for consistency/payment tracking

**Technical Implications:**
- Single users table with role field (student, student_teacher, creator)
- Display logic based on role
- Aggregate stats query across creator's courses
- Creator profile links to payment_accounts table
- Creator ID in enrollments table for revenue attribution

**Relationship to Other Docs:**
- **Part of** unified profile system (with Student Profile System)
- **Integrates with** Payment System (creator_id for revenue)
- **Aligns with** CD-012's MVP features list (#5 Creator Profiles = $500)
- **Integrates with** Community Feed (creator posts with badge)

**Goals Referenced:** GO-003 (sustainable income - payment attribution), GO-008 (multi-role system)
**Stories Referenced:** US-C008-C010 (creator profiles), US-S004 (search creators)

---

### CD-018: MVP Decision - Student Profile System
**Date Uploaded:** 2025-12-04
**Original Date:** 2025-11-30
**Summary for SPECS.md:**

Comprehensive MVP decision document for student profile system. Uses Q-DECIDE framework to approve student profiles as MUST HAVE for validating Brian's top two uncertainties (Hypotheses #4 and #6).

**Key elements for SPECS.md:**

- **Decision:** MUST HAVE for MVP
- **Budget:** ~$14K-$18.7K (~20% of Phase 1 budget)
- **Timeline:** ~3-4 weeks (~18-25% of build timeline)

- **Core Profile Features:**
  - Name, @handle, profile photo
  - Bio (160 characters visible, expandable)
  - Interests/topics (3-5 tags)
  - Privacy toggle (public/private profile)

- **Social Features:**
  - Follow/unfollow other users (students, Student-Teachers)
  - Follow/unfollow courses
  - Display follower/following counts
  - View lists of followers/following

- **Reputation Display (Read-Only in MVP):**
  - Average star rating
  - Number of ratings received
  - *(Brian manually grants ratings after course completion)*

- **Student-Teacher Signaling:**
  - "Available as Student-Teacher" toggle
  - "Teaching" badge display
  - Basic availability indicator
  - List of courses certified to teach

- **Profile Discovery:**
  - Student-Teacher directory
  - Basic search by name/interests
  - Profile accessible via direct link

- **Hypothesis Validation:**
  - **H4 (Primary):** % of students who toggle "Available as ST" - measures conversion to teaching
  - **H6 (Critical):** Follow relationships, follower→enrollment conversion, organic recruitment tracking - **Brian's #1 uncertainty**
  - H2, H3 (Secondary): Completion rates, customer segmentation behavior

- **User Flow:**
  1. Student signs up → profile auto-created
  2. Onboarding prompts for photo/bio/interests (optional)
  3. Student browses courses → discovers Student-Teachers
  4. Clicks ST name → views profile → follows
  5. Student completes course → earns certificate
  6. Toggles "Available as Student-Teacher" ON
  7. Profile visible in ST directory
  8. Other students discover and follow → organic recruitment

- **Success Metrics (Genesis Cohort):**
  - Profile completion: 60%+ students, 80%+ Student-Teachers
  - Social graph: 5+ connections per student, 30%+ follow at least one ST
  - ST activation: 10%+ toggle "Available as Student-Teacher"
  - Organic recruitment: 30%+ enrollments from profile connections (vs external)

- **Scope DEFERRED to Phase 2:**
  - Activity feed on profile page
  - Mutual connections display
  - Direct messaging (use WhatsApp/Discord for MVP)
  - Social recommendations
  - Goodwill points display
  - Achievement badges
  - Leaderboards/gamification
  - Gender preference filtering
  - AI-powered ST recommendations

- **Implementation Notes:**
  - Unified profile system with role-based display
  - Single profile table with role fields (student, student_teacher, creator)
  - Display logic based on role flags
  - 60-80 students = simple DB queries (no graph DB needed at MVP scale)

- **Risks & Mitigations:**
  - Scope creep → strict scope definition, defer all social/gamification
  - Privacy concerns → toggle (default TBD), clear opt-in messaging
  - Empty profiles → onboarding prompts, "profile strength" indicator
  - Timeline overrun → phased builds (basic → social → ST features)

**Technical Implications:**
- Photo upload with crop (use Cloudinary/S3)
- Follow functionality (database social graph)
- ST directory with basic search
- Privacy toggle system
- Profile strength/completion tracking
- Integration points: Community Feed, Calendar/Scheduling, Video, Payment, Certificates

**Relationship to Other Docs:**
- **Extends** unified profile system (with CD-017 Creator Profiles)
- **Integrates with** CD-013 (Community Feed - profile photo/name in posts)
- **Integrates with** CD-015 (Calendar - ST availability link)
- **Integrates with** CD-014 (Video - profile photo in sessions)
- **Aligns with** CD-012's MVP features list (#4 Student Profile System = $14K-18.7K)
- **Validates** CD-004's success metrics (H4, H6)

**Goals Referenced:** GO-001 (flywheel validation), GO-005 (validation metrics), GO-006 (engagement/growth), GO-008 (multi-role system), GO-014 (combat isolation)
**Stories Referenced:** US-S004 (student profile), US-S036-S041 (feed interactions), US-T017-T018 (ST signaling)

---

### CD-019: Decision - Course Content Delivery
**Date Uploaded:** 2025-12-04
**Original Date:** 2025-12-02
**Summary for SPECS.md:**

MVP decision document for course content delivery system. Defines minimal approach using external video/document hosting with self-service progress tracking. Includes comprehensive user journey from enrollment through certification to becoming Student-Teacher.

**Key elements for SPECS.md:**

- **Decision:** MUST HAVE (Option A - Minimal)
- **Budget:** $2,000-4,000
- **Timeline:** ~1 week
- **Monthly Recurring:** $0 (external hosting)

- **Scope - MVP (IN):**
  - Simple course page with organized module structure
  - Video links (YouTube/Vimeo unlisted)
  - Document links (Google Drive / Notion)
  - Student self-marks progress (checkboxes)
  - Creator monitors completion

- **Scope DEFERRED to Phase 2:**
  - Video hosting (use external links)
  - Quiz/assessment engine (peer validates mastery)
  - Auto-grading
  - Drip content / time-locked modules
  - SCORM/xAPI
  - Advanced analytics

- **Hypothesis Validation:**
  - **H2 (PRIMARY):** Completion Rates - This IS how students complete the course (75% target)
  - **H4:** Conversion to Teaching - Path to certification = become Student-Teacher
  - H1, H5 (Indirect): Market positioning, content consistency

- **Complete User Journey (Critical Documentation):**

  1. **Enrollment & Scheduling:** Student → Pays (Stripe) → Schedules (Calendar) → Auto-notifications
  2. **Learning:** Student studies content → Attends BBB sessions → Marks progress → Repeats
  3. **Certification:** Student-Teacher recommends → CREATOR approves → Certificate issued
  4. **Payout:** CREATOR approves → System processes → 70/15/15 split paid
  5. **Become ST:** Student applies → CREATOR approves → Can now teach → Flywheel continues

- **Role Clarification (Important!):**

  | Creator (e.g., Guy) | Brian (Platform) |
  |---------------------|------------------|
  | Creates course content | Recruits/onboards Creators |
  | Approves certifications | Platform-level disputes |
  | Approves payouts | Monitors overall health |
  | Approves new Student-Teachers | Strategic oversight only |
  | Day-to-day course ops | ~3-4 hrs/week total |

- **Weekly Learning Rhythm:**
  - Mon: Student watches videos, reads materials
  - Tue: 1-on-1 session with ST via BBB
  - Wed-Thu: Practice, prepare questions
  - Fri: Community feed check-in
  - Weekend: Catch up if needed

- **Budget Summary (8 MVP Features):**
  - Total Allocated: $46K-62K
  - Remaining: $13K-29K

- **Success Metrics (Genesis):**
  - Students can access all course content without issues
  - 75%+ of students complete all modules
  - Student-Teachers can guide students through content effectively
  - Creators can monitor student progress
  - Content delivery doesn't block certification pathway

**Technical Implications:**
- Simple module-based course pages (no complex LMS)
- External video embedding (YouTube/Vimeo unlisted links)
- External document links (Google Drive/Notion)
- Checkbox-based progress tracking
- Creator dashboard for monitoring completion
- Integration with certification workflow
- Integration with payout approval workflow

**Relationship to Other Docs:**
- **Aligns with** CD-012's MVP features list (#8 Course Content Delivery = $2K-4K)
- **Integrates with** CD-014 (Video Conferencing - BBB sessions)
- **Integrates with** CD-015 (Calendar/Scheduling - session booking)
- **Integrates with** Payment System (70/15/15 payout flow)
- **Validates** CD-004's H2 (completion rates) and H4 (conversion)
- **Clarifies** operational model: Creator-controlled, Brian strategic only

**Goals Referenced:** GO-001 (flywheel), GO-004 (Genesis cohort), GO-005 (validation metrics - 75% completion), GO-011 (learning management)
**Stories Referenced:** US-C001-C003 (course management), US-S005 (course detail), US-P060-P064 (certification/payout workflows)

---

### CD-020: MVP Decision - Payment & Escrow System
**Date Uploaded:** 2025-12-04
**Original Date:** 2025-12-02
**Summary for SPECS.md:**

Comprehensive MVP decision document for payment and escrow system. Defines semi-automated approach using Stripe for payment collection with manual payout approval.

**Key elements for SPECS.md:**

- **Decision:** MUST HAVE
- **Payment Processor:** Stripe
- **Approach:** Semi-Automated (System calculates, Brian clicks to process payouts)
- **Budget:** $11,000 - $15,000 (15-20% of Phase 1)
- **Timeline:** 2-3 weeks

- **Scope - MVP (IN):**
  - Stripe Checkout integration (credit card processing)
  - Course purchase flow with instant enrollment
  - Payment confirmation emails and receipt generation
  - Automatic 70/15/15 split calculation per transaction
  - Per-transaction tracking in database
  - Creator earnings dashboard view
  - Student-Teacher earnings dashboard view
  - Running balance display
  - Escrow/holding until milestone completion
  - Admin payout dashboard (view pending, process button, batch option)
  - Payout history and audit trail
  - Monthly summary reports

- **Scope DEFERRED to Phase 2:**
  - Stripe Connect (fully automated marketplace payouts)
  - Subscription/recurring billing
  - Multiple currency support
  - Automated refund processing
  - Complex escrow conditions
  - Payment plans/installments
  - Tax document generation (1099s)

- **Why Stripe:**
  - Industry standard for SaaS/EdTech
  - Excellent React components and documentation
  - 99.99% uptime, built-in fraud detection
  - PCI compliance handled
  - Easy upgrade path to Stripe Connect in Phase 2
  - Fees: 2.9% + $0.30 per transaction (~$14.80 on $500 course)

- **Why Semi-Automated (vs Fully Automated):**
  - Saves $5K-$11K vs fully automated (Stripe Connect)
  - 1-2 hrs/month acceptable for 4-5 creators
  - Brian maintains cash flow oversight
  - Upgrade path exists for Phase 2

- **Semi-Automated Workflow:**
  1. Student pays via Stripe Checkout
  2. System instantly enrolls student
  3. System calculates 70/15/15 split
  4. System tracks amounts owed to each recipient
  5. Monthly: Brian opens Admin Dashboard
  6. Brian clicks "Process Payout" for each recipient
  7. System sends payment via Stripe Transfer or PayPal Payouts API
  8. Recipients receive funds + confirmation

- **Hypothesis Validation:**
  - **H1 (PRIMARY):** Market Positioning - Directly tests if students will pay $400-600
  - **H4:** Conversion to Teaching - 70% payout incentivizes becoming ST
  - **H6:** Flywheel - Revenue share enables sustainable flywheel

- **Success Metrics:**
  - 60-80 students successfully pay $400-600
  - Payment completion rate >90%
  - No major payment-related complaints
  - Student-Teachers receive payouts as promised
  - Recipients receive funds within 2-3 business days

- **Budget Breakdown:**
  | Component | Estimate |
  |-----------|----------|
  | Stripe Integration | $4,000-5,500 |
  | Split Calculation System | $2,500-3,500 |
  | Admin Dashboard | $2,500-3,500 |
  | Payout Processing | $2,000-2,500 |
  | Monthly Operating | ~$50 |
  | Stripe Fees (Genesis) | ~$1,000-1,200 |

**Technical Implications:**
- Stripe Checkout integration (not custom form)
- Webhook setup for payment confirmations
- Database schema for tracking splits and pending payouts
- Admin dashboard for payout management
- Integration with Creator/ST earnings dashboards
- Escrow logic with manual release approval

**Relationship to Other Docs:**
- **Aligns with** CD-012's MVP features list (#7 Payment & Escrow = $11K-15K)
- **Depends on** CD-017 (Creator Profiles) and CD-018 (Student Profiles) for recipient identification
- **Integrates with** CD-019 (Course Content) for enrollment triggering
- **Validates** CD-004's H1 (market positioning/pricing)

**Goals Referenced:** GO-001 (flywheel), GO-003 (sustainable income - 70/15/15 split), GO-005 (validation metrics), GO-012 (payment infrastructure)
**Stories Referenced:** US-P026-P033 (payment infrastructure), US-T012-T013 (ST earnings), US-C014 (certification → payout trigger)

---

### CD-021: PeerLoop Database Sample (Dec 12, 2025)
**Date Uploaded:** 2025-12-23
**Original Date:** 2025-12-12
**Summary for SPECS.md:**

JavaScript mock database file containing sample data structures for PeerLoop's core entities: Creators (instructors) and Courses. Provides concrete schema definitions and sample data.

**Key elements for SPECS.md:**

- **Two Core Entities Defined:**
  - **Instructors (Creators):** id, name, title, avatar, bio, qualifications[], website, expertise[], stats{}, courses[]
  - **Courses:** id, title, description, duration, level, rating, students, price, thumbnail, instructorId, category, tags[], learningObjectives[], curriculum[]

- **PeerLoop Model Confirmation:**
  - Learn → Certify → Teach → Earn (70/15/15 split)
  - Price Range: $300-600 (1-on-1 tutoring pricing)

- **Course 15 as Reference Implementation:**
  - Shows `peerloopFeatures` block (oneOnOneTeaching, certifiedTeachers, earnWhileTeaching, teacherCommission)
  - Shows `studentTeachers` array with name, studentsTaught, certifiedDate
  - Shows `includes` list (what's included with course)
  - Extended curriculum with videos/readings/assessments per module

- **New Fields to Consider:**
  | Field | Recommendation |
  |-------|----------------|
  | Course `level` | Add (Beginner/Intermediate/Advanced) |
  | Course `category` | Formalize taxonomy |
  | `learningObjectives` | Add to course detail page |
  | `includes` list | Add to course detail page |
  | `peerloopFeatures` block | Make explicit in UI |

- **Sample Data Stats:**
  - 8 creators, 15 courses
  - Price range: $299-$499
  - Duration: 4-12 weeks
  - 15 categories observed

- **Search Index Pattern:** Pre-computed searchable text combining title, description, tags, objectives, curriculum for full-text search

**Technical Implications:**
- Database schema for users, qualifications, expertise, courses, curriculum, student_teachers
- Level/category fields needed for browse/filter
- Learning objectives and includes list improve course detail pages
- Consider storing price as cents (integer) not string

**Relationship to Other Docs:**
- **Confirms** CD-001 revenue model (70/15/15)
- **Confirms** CD-017/CD-018 profile structures
- **Confirms** CD-019 course content approach
- **Adds** concrete schema definitions for database design

**Goals Referenced:** GO-001, GO-003, GO-011
**Stories Referenced:** US-C001-C003, US-S005, US-C008-C010
**Stories Added:** US-S057-S061, US-C036 (course filtering, learning objectives, includes list, per-course STs, creator expertise)

---

### CD-022: PeerLoop Data Structures Documentation (Dec 23, 2025)
**Date Uploaded:** 2025-12-23
**Original Date:** 2025-12-23
**Summary for SPECS.md:**

Formal documentation of data structures from the PeerLoop prototype. Complements CD-021 with cleaner formatting and adds two new fields.

**Key elements for SPECS.md:**

- **Live Prototype URL:** https://brianpeerloop.github.io/Peerloop-v2/

- **New Fields (not in CD-021):**
  | Field | Type | Description |
  |-------|------|-------------|
  | `ratingCount` | number | Per-course review count (distinct from creator totalReviews) |
  | `badge` | string/null | Promotional badge: "Popular", "New", "Bestseller", "Featured", null |

- **Confirms CD-021 structures** for Instructor/Creator and Course entities

- **Source Code Locations:**
  - Database: `src/data/database.js`
  - Course Listing UI: `src/components/MainContent.js`
  - Course Detail UI: `src/components/CourseListing.js`
  - Instructor Profile: `src/components/MainContent.js`

**Relationship to Other Docs:**
- **Complements** CD-021 (database sample)
- **Updates** DB-SCHEMA.md with rating_count and badge fields
- **Updates** COMPONENTS.md with CourseBadge component

**Goals Referenced:** GO-001, GO-003

---

### CD-023: Goodwill Points System Specification (Dec 12, 2025)
**Date Uploaded:** 2025-12-23
**Original Date:** 2025-12-12
**Author:** Brian LeBlanc
**Summary for SPECS.md:**

Comprehensive specification for community currency system called "Goodwill Points" that replaces 5-star reviews. Includes Summon Help feature, anti-gaming safeguards, and future reward thresholds.

**Key elements for SPECS.md:**

- **Core Concept:**
  - Total Earned (public credibility) / Balance (private) / Spent (private)
  - Formula: Balance = Total Earned - Spent

- **How Points Are Earned:**
  | Action | Points | Limits |
  |--------|--------|--------|
  | Answer Summon help request | 10-25 | Must be certified |
  | Answer chat question | 5 | Max 3/day to same person |
  | Help S-T first session | 50 | One-time |
  | Referral | 100 | One-time |
  | Availability bonus | 5/day | While available |

- **Summon Help Feature:**
  - Students click "Summon Help" on course content
  - Available S-Ts get notification, first responder joins
  - After 5+ min, student awards 10-25 points

- **Anti-Gaming Safeguards:**
  - Must be certified in course to earn points
  - Daily caps on points given TO/BY any user
  - 5-min minimum session before points
  - 24-48 hour cooldown between awarding same person

- **Future Rewards (Block 4+):**
  - 500 pts → "Community Helper" badge
  - 1,000 pts → 10% discount
  - 2,500 pts → Free session with Creator
  - 5,000 pts → Extra 5% revenue share

- **Block Roadmap:** NOT MVP - Block 2+

**Architecture Updates:**
- **DB-SCHEMA.md:** user_goodwill, goodwill_transactions, help_summons, user_availability, goodwill_rewards, user_reward_unlocks
- **PAGES.md:** Course Chat Room, Summon Help Modal, Profile goodwill sections
- **COMPONENTS.md:** 9 new components (SummonHelpButton, GoodwillPointsDisplay, etc.)
- **API.md:** 9 new endpoints (summons, goodwill, availability)

**Goals Updated:** GO-019 (Gamification & Engagement)
**Stories Added:** US-S062-S068, US-T024-T029, US-P077-P082 (19 stories)

---

### CD-024: Meeting Notes - Brian Walkthrough & Flywheel Testing (Dec 15, 2025)
**Date Uploaded:** 2025-12-23
**Original Date:** 2025-12-15
**Summary for SPECS.md:**

Meeting notes from Brian's walkthrough of PeerLoopApp prototype, discussing user access states, instructor feeds, and initial flywheel testing plan.

**Key elements for SPECS.md:**

- **User Access States (State Machine):**
  - Registered user → can view instructor and their courses
  - Paid for course → access to that course's feed
  - Paid for ANY instructor's course → access to Instructor's public feed
  - Implies tiered access control based on enrollment relationships

- **Instructor Feed (NEW):**
  - Instructors should have a feed for current and former students
  - Distinct from course-specific feeds
  - Provides ongoing community connection after course completion

- **Flywheel Testing Plan:**
  - Gabriel and Guy will create 4 entry-level courses: n8n, GitHub, Claude Code, AI tools
  - Each course: 1-2 sessions with homework
  - Purpose: Test the learn-teach-earn flywheel with real users

- **Onboarding Flow:**
  - Needed for full product
  - NOT for MVP (deferred)

- **Enhanced Gamification (Gabriel's Suggestion):**
  - Point system rewarding participation
  - Points can lead to:
    - Promotions for purchasing courses (discounts)
    - Deals for promoting a message from current feed to the Peer Loop main feed
  - Feed promotion feature: Users can spend points to boost their posts to wider audience

**Technical Implications:**
- User access state machine needed (not just roles, but enrollment-based access levels)
- Instructor-level feeds distinct from course-level feeds
- Feed promotion mechanism (spend points to boost posts)
- Need to track "ever enrolled with instructor" for instructor feed access

**Relationship to Other Docs:**
- **Expands** CD-023's Goodwill Points with feed promotion use case
- **Adds** instructor feed concept (not just course feeds)
- **Confirms** 4 courses for Genesis testing (complements CD-012's 4-5 courses estimate)
- **Clarifies** MVP scope: onboarding flow is deferred

**Goals Referenced:** GO-001 (flywheel testing), GO-019 (gamification)
**Stories Added:** US-S069-S071, US-C037-C038, US-P083

---

### CD-025: Sample Course - Intro to Claude Code 101 (Dec 2025)
**Date Uploaded:** 2025-12-23
**Type:** Real Course Data (4 files)
**Summary for SPECS.md:**

Complete course package for "Intro to Claude Code" by Guy Rymberg - used to validate schema against real course content. This course will be offered on PeerLoop.

**Files Included:**
1. `intro-to-claude-code/course-info.yaml` - Course metadata, pricing, prerequisites, target audience
2. `intro-to-claude-code/curriculum.md` - Detailed 2-session curriculum with 7 modules
3. `intro-to-claude-code/instructor.md` - Instructor profile and teaching philosophy
4. `intro-to-claude-code/overview.md` - Marketing overview and course description

**Course Details:**
- **Title:** Intro to Claude Code
- **Instructor:** Guy Rymberg (AI & Automation Expert)
- **Price:** $249 USD
- **Format:** 2 live 1-on-1 sessions (90 min each, 3 hours total)
- **Modules:** 7 (12 lessons)
- **Level:** Beginner (no coding experience required)
- **Certificate:** Certificate of Completion

**Schema Validation & Gaps Identified:**

| Field/Entity | Status | Notes |
|--------------|--------|-------|
| `courses.title` | ✅ Exists | |
| `courses.slug` | ✅ Exists | |
| `courses.tagline` | ❌ **NEW** | Short marketing text (e.g., "Master AI-powered coding...") |
| `courses.price_cents` | ✅ Exists | 24900 cents |
| `courses.currency` | ❌ **NEW** | "USD" - needed for international support |
| `courses.format` | ❌ **NEW** | "Live 1-on-1 sessions" |
| `courses.lifetime_access` | ❌ **NEW** | boolean |
| `courses.total_duration` | ❌ **NEW** | "3 hours" |
| `courses.session_count` | ❌ **NEW** | 2 |
| `course_objectives` | ✅ Exists | Maps to course_outcomes |
| `course_includes` | ✅ Exists | |
| `course_curriculum` | ✅ Exists | Needs enhancement |

**New Tables Needed:**

1. **course_prerequisites**
   - `course_id`, `type` (required/nice_to_have/not_required), `content`
   - Examples: "Computer with terminal", "Claude Pro account", "No coding experience needed"

2. **course_target_audience**
   - `course_id`, `order`, `description`
   - Examples: "Non-coders wanting to use AI for development"

3. **course_testimonials**
   - `course_id`, `quote`, `student_name`, `student_role`
   - Example: "I went from knowing nothing..." - Sarah, Course Graduate

**Curriculum Enhancement Needed:**

Current `course_curriculum` has: title, description, duration, video_count, etc.
Real data shows need for:
- `learning_objectives` per module (array)
- `topics_covered` per module (array)
- `hands_on_exercise` per module (text)
- `session_number` to group modules into sessions

**Instructor Profile Enhancement:**

Current `users` has: bio, title, qualifications
Real data shows need for:
- `teaching_philosophy` (text)
- `experience_highlights` (array)
- `why_learn_from` (array)

**Technical Implications:**
- Course structure is session-based (Session 1, Session 2) with modules grouped under sessions
- Homework exists between sessions (async component)
- Prerequisites have 3 tiers: required, nice-to-have, not-required
- Testimonials are course-specific, not just instructor reviews

**Relationship to Other Docs:**
- **Validates** CD-021 schema (courses, curriculum structure)
- **Extends** schema with real-world fields not in prototype
- **Confirms** CD-024's 4 courses for flywheel testing (this is one of them)

**Stories Implied:** US-S072-S075, US-C039-C040

---

### CD-026: Genesis Cohort Course Package (Dec 2025)
**Date Uploaded:** 2025-12-23
**Type:** Course Data Bundle (3 additional courses)
**Summary for SPECS.md:**

Three additional courses following the identical CD-025 format. Together with CD-025, these form the **4 Genesis Cohort courses** for flywheel testing (as planned in CD-024).

**Courses Included:**

| Course | Slug | Instructor | Price | Modules |
|--------|------|------------|-------|---------|
| Intro to n8n | `intro-to-n8n` | Guy Rymberg | $249 | 8 |
| Vibe Coding 101 | `vibe-coding-101` | Guy or Gabriel Rymberg | $249 | 8 |
| AI Tools Overview | `ai-tools-overview` | Guy Rymberg | $249 | 8 |

**Files per course (identical structure to CD-025):**
- `course-info.yaml` - Metadata, pricing, prerequisites, target audience
- `curriculum.md` - Session-based modules with exercises
- `instructor.md` - Instructor profile and teaching philosophy
- `overview.md` - Marketing description and outcomes

**Course Sequencing Discovered:**
- **Vibe Coding 101** requires completion of "Intro to Claude Code" as prerequisite
- Implies course dependency/progression tracking needed

**Complete Genesis Cohort (4 courses):**

| # | Course | Topic | Prerequisite |
|---|--------|-------|--------------|
| 1 | Intro to Claude Code (CD-025) | AI Coding | None |
| 2 | Intro to n8n | Workflow Automation | None |
| 3 | AI Tools Overview | AI Landscape | None |
| 4 | Vibe Coding 101 | Web Development | Intro to Claude Code |

**Schema Validation:**
- All courses use identical YAML structure
- CD-025 schema additions support all 4 courses
- No additional schema changes needed

**Relationship to Other Docs:**
- **Confirms** CD-024's plan for 4 entry-level courses for flywheel testing
- **Uses** CD-025 schema (prerequisites, target_audience, testimonials tables)
- **Validates** course format fields (session_count, format, lifetime_access)

**No new stories needed** - CD-025 user stories cover all course display requirements.

---

### CD-027: PeerLoop Prototype Walkthrough - Complete Analysis (Dec 24, 2025)
**Date Uploaded:** 2025-12-24
**Type:** Prototype Analysis (All 5 Personas)
**Source:** https://peerloopllc.github.io/Peerloop-v2/
**Summary for SPECS.md:**

Comprehensive walkthrough of Brian's vibe-coded prototype through ALL personas. Captures page structure, navigation patterns, new features, gaps, and UX issues.

**Key elements for SPECS.md:**

- **5 Personas Reviewed:** New User, Sarah Miller (Student), Alex Sanders (Student & Teacher), Jamie Chen (Creator), Marcus Johnson (Admin)
- **20+ Pages Documented** including Course Progress (richest page), Teaching Dashboard, all Profile tabs
- **31 Keepers (Features) Identified**

- **Critical Gaps Identified:**
  1. Admin not implemented (shows Teacher view)
  2. Creator Dashboard same as Student-Teacher (no course management)
  3. No user menu in header (no logout, no user indicator)

- **UX Issues:**
  - No user avatar/indicator in header
  - No logout visible
  - Settings buried in Profile tabs
  - Global Edit toggle (should be per-section)
  - Mentions tab non-functional

- **Major Features Discovered:**
  - Session-based course structure (8 sessions)
  - Homework tracking with due dates and scores
  - Per-session resources (Recording, Slides, Code Files)
  - Group sessions (not just 1:1)
  - Earnings dashboard with 70% payout display
  - "Recommend" button for certification workflow
  - Browse Student-Teachers CTA for extra help

- **Schema Implications:**
  - 15+ new tables implied
  - 25+ new fields on existing tables

- **12 Questions for Brian** covering community structure, group sessions, homework system, Creator Studio needs

**Technical Implications:**
- Course Progress page is central learning experience
- Teaching Dashboard validates CD-019/CD-020 workflows
- Group sessions extend beyond 1:1 model
- Homework/grading system needs scope clarification

**Relationship to Other Docs:**
- **Extends** CD-022's prototype URL with detailed page analysis
- **Validates** CD-013 (Community Feed), CD-014 (Video/Sessions), CD-018 (Profiles), CD-019 (Course Content), CD-020 (Payment)
- **Identifies gaps** requiring clarification before implementation

**Goals Referenced:** GO-001, GO-006, GO-010, GO-014, GO-019
**Stories Implied:** 50+ user stories across all features discovered

**Full Document:** `/client-docs/CD-027-prototype-walkthrough-complete.md`

---

### CD-028: Slack - PlugNmeet as BBB Alternative (Dec 24, 2025)
**Date Uploaded:** 2025-12-24
**Type:** Slack Conversation
**Source:** Brian LeBlanc messages after Fraser raised concerns about BBB being "old and dated"
**Summary for SPECS.md:**

Brian researched modern alternatives to BigBlueButton after hearing feedback that BBB is outdated. Found **PlugNmeet** as the "Best Modern BBB Replacement."

**Key elements for SPECS.md:**

- **PlugNmeet Overview:**
  - Open-source, built on Go + LiveKit (modern WebRTC)
  - Positions itself as "modern BigBlueButton replacement"
  - Zoom-like interface (vs BBB's clunky UI)
  - Same classroom features as BBB

- **Pricing:**
  - Self-Hosted: Free (just VPS cost $5-10/month) - flat rate
  - Cloud Flex Plan: Flat monthly fee based on concurrent capacity (not per-user)

- **Key Features:**
  - HD video, screen sharing, breakout rooms, waiting rooms
  - Whiteboard (upload PDFs/Office docs)
  - Polls & Voting, Shared Notepad
  - Moderator Controls (lock mics/webcams/chat)
  - AI "Meeting Agent" for live speech-to-text and translations
  - LMS plugins (Moodle, WordPress, Joomla)

- **Scalability Advantages over BBB:**
  - BBB is "monolithic" - heavy, difficult to split across servers
  - PlugNmeet uses microservices architecture
  - Small: Single server handles hundreds of concurrent users
  - Large: Can separate heavy components (recording on separate server)
  - Massive: Cluster media servers for 1,000+ students

- **Status:** Brian to "look deeper" before final decision

**Technical Implications:**
- May replace BBB (DIR-001: MUST-USE BigBlueButton) if evaluation is positive
- Better scalability for growth
- Lower/predictable costs vs per-session fees
- Modern UX aligns with Zoom-like expectations

**Relationship to Other Docs:**
- **May supersede** CD-006, CD-007, CD-009, CD-014's BBB decisions
- **Research doc:** `docs/vendors/plugnmeet.md`
- **Updates** QUESTIONS-FOR-BRIAN.md - video platform question now includes PlugNmeet

**Goals Referenced:** GO-009 (Video Session Infrastructure)
**Stories Covered:** US-V001-V007, US-A013-A018, US-T007

---

### CD-029: PeerLoop Block Sequence v2.1 - From Zero to Flywheel (Dec 19, 2025)
**Date Uploaded:** 2025-12-24
**Original Date:** 2025-12-19 (v2.2, incorporating Dec 19 UX meeting)
**Author:** Gabriel Rymberg (with Claude)
**Type:** Management Planning Document (HTML with tabs)
**Summary for SPECS.md:**

Comprehensive block sequence planning document from Gabriel (project manager) breaking MVP into small, testable, deployable increments while tracking hypothesis validation. Includes user journey narratives, hypothesis definitions, Brian's review comments, Dec 15 meeting updates, and Dec 19 UX meeting insights.

**Key elements for SPECS.md:**

- **Six Core Hypotheses (H1-H6):**
  | ID | Hypothesis | Success Criteria | Uncertainty |
  |-----|------------|-----------------|-------------|
  | H1 | Market Positioning: Students pay $300-600 | Complete purchase | Medium-High |
  | H2 | Completion Rates: 75%+ (vs 10-20% MOOCs) | ≥75% completion | Medium |
  | H3 | Customer Segmentation: Both "Earn-While-Learn" and "Premium Learner-Only" | See both segments | Low |
  | H4 | Conversion to Teaching: 10%+ become S-Ts | ≥10% certified apply | Medium-High |
  | H5 | Peer Teaching Quality: Match expert outcomes | Creator approves quality | Medium |
  | H6 | Flywheel Validation: Second generation emerges | S-Ts teach new students | **HIGHEST** |

- **Brian's Top 3 Uncertainties (ranked):**
  1. Will Student-Teachers recruit 2+ students? (MOST uncertain)
  2. Will second-generation emerge?
  3. Will students pay $400-600?

- **Block Sequence Overview (0.x = Flywheel Validation):**
  | Block | Name | Duration | Hypotheses |
  |-------|------|----------|------------|
  | 0.0 | Foundation | 1 week | (Enables all) |
  | 0.1 | Discovery & Payment | 1 week | H1 |
  | 0.2 | Content Access | 1 week | (Enables H2, H5) |
  | 0.3 | Scheduling & Sessions | 1-2 weeks | H5 |
  | 0.4 | Progress & Completion | 1 week | H2 |
  | 0.5 | Certification | 1 week | H2, H5 |
  | 0.6 | Become Student-Teacher | 1 week | H3, H4 |
  | 0.7 | Flywheel & Payouts | 1-2 weeks | H3, H6 |

- **Brian's Review Comments (Critical Insights):**
  1. **Trust-building before payment:** New platform with no reviews needs pre-enrollment communication
  2. **Tiered pricing suggestion:** $150×3 courses vs $450 single payment (lower entry barrier)
  3. **Free 15-minute intro sessions:** Let visitors experience differentiation before committing
  4. **Basic "Contact Creator" feature:** Needed in Block 0.1, not deferred to Block 1.x

- **Dec 15 Meeting Updates:**
  1. **Course access model CHANGED:** Students get community feed access upon PAYMENT, not after graduation
     - Fraser's insight: "You need help after session one, but before session two"
     - Brian: "Having paid access to it makes perfect sense"
  2. **Four starter courses confirmed:** GitHub, Claude Code, n8n, AI Tools Overview (1-2 sessions each)
  3. **States/roles matrix required:** Fraser to create systematic tracking of course-role-state combinations
  4. **Designer trial test:** $500 budget, 10 hours max, 2-day turnaround

- **Dec 19 UX Meeting (Matt McCloskey):**
  1. **"The one-on-one live video instruction is the core value proposition and lynchpin"**
  2. Course-first for MVP, community features secondary
  3. Mobile-first design critical for growth
  4. Validates current block sequence: 0.x (flywheel) before 1.x (community)

- **Actor-Block Matrix:** Maps when each actor gets functionality across blocks
  - 258 total user stories, 135 P0 (MVP critical), ~72 in Block 0.x

- **Timeline:**
  - Block 0.x (Flywheel): ~11 weeks
  - Block 1.x (Community): 4-5 weeks
  - Block 2.x (Polish): 4-6 weeks
  - **Total: 21-24 weeks → Launch May-June 2026**

- **Key Decisions Retained:**
  - Creator approves certs/payouts/S-T apps (not Brian)
  - S-T recommends → Creator approves certification workflow
  - Stripe automated payouts (after Creator approval)
  - Brian's time: 3-4 hrs/week (strategic only)

**Technical Implications:**
- Pre-enrollment communication feature needed earlier than planned (Block 0.1 or 0.2)
- Course community feed access upon payment requires enrollment-triggered access control
- States/roles matrix informs permission system design
- Mobile-first responsive design requirement

**Relationship to Other Docs:**
- **Consolidates** CD-001 through CD-028 into actionable development sequence
- **Validates** architecture decisions from MVP decision docs (CD-013 through CD-020)
- **Confirms** 4 starter courses (complements CD-025, CD-026)
- **Adds** Brian's critical feedback on trust-building gap
- **Adds** Matt McCloskey's UX validation of video-first approach

**Goals Referenced:** GO-001 (flywheel), GO-002 (2 Sigma), GO-004 (Genesis cohort), GO-005 (validation metrics), GO-006 (engagement), GO-014 (combat isolation), GO-018 (budget/timeline)
**Goals Added:** GO-021 (Trust-Building Before Purchase)
**Stories Implied:** Trust-building stories, tiered pricing stories, free intro session stories

---

### CD-030: PeerLoop Block 1 Actor Stories (Dec 7, 2025)
**Date Uploaded:** 2025-12-24
**Original Date:** 2025-12-07
**Author:** Gabriel Rymberg (with Claude), Corrections by Brian LeBlanc
**Status:** APPROVED
**Summary for SPECS.md:**

Actor-organized view of Block 1 capabilities. Describes what each type of person can DO with PeerLoop, organized by actor rather than by feature. Essential for validating "Can we put this person in front of the system and let them do their job?"

**Key elements for SPECS.md:**

- **Four Actors Defined:**
  | Actor | Example | Role |
  |-------|---------|------|
  | Student | Sarah | Pays for course, learns from Student-Teacher |
  | Student-Teacher | Marcus | Certified former student who now teaches others |
  | Creator | Guy | Expert who created the course content, manages their course |
  | Platform Owner | Brian | Runs PeerLoop, handles platform-level operations |

- **Student (Sarah) Block 1 Capabilities:**
  - Discover and evaluate courses (browse, view details, pricing, creator info)
  - Create account and pay (Stripe Checkout)
  - Schedule first session (view S-T availability, book time slot)
  - Access course content (modules, video links, document links, progress checkboxes)
  - Attend video sessions (BBB)
  - Track progress
  - **CANNOT:** Apply to become S-T (button exists, Creator approves), see certificate in portal (email only), rate S-T, access community feed (Discord instead), cancel/reschedule via system, pay in installments, request refund via system

- **Student-Teacher (Marcus) Block 1 Capabilities:**
  - Set availability (calendar with time slots)
  - View assigned students with progress
  - View upcoming sessions
  - Conduct teaching sessions (BBB, screen share)
  - Recommend students for certification
  - Receive booking notifications (email + calendar invite)
  - Receive payouts (Stripe, after Creator approval)
  - **CANNOT:** Approve certifications, view session recordings, add session notes in system, cancel/reschedule sessions via system

- **Creator (Guy) Block 1 Capabilities:**
  - Monitor course performance (enrollments, active students, completion rate, revenue)
  - View enrolled students with progress
  - View upcoming sessions
  - View Student-Teachers list
  - **Approve certifications** (click button → certificate issued via email)
  - **Approve payouts** (click button → Stripe processes 70/15/15)
  - **Approve Student-Teacher applications** (click button → student becomes S-T)
  - **CANNOT:** Edit course content in system (ask Brian), upload new content, message students directly (use Discord), see advanced analytics

- **Platform Owner (Brian) Block 1 Capabilities:**
  - Onboard Creators (manual vetting + database setup)
  - Monitor platform health (admin access to all dashboards + Stripe)
  - Handle platform-level exceptions (refunds, disputes, technical issues)
  - Creator support (1-2 hrs/week check-ins)
  - **Does NOT:** Approve certifications, approve payouts, approve S-T applications, day-to-day course operations
  - **Weekly time commitment:** ~3-4 hrs/week

- **Automated vs Manual Summary:**
  | Automated (System) | Creator Dashboard | Brian (Manual) |
  |-------------------|-------------------|----------------|
  | Payment collection | Approve certifications | Creator onboarding |
  | Account creation | Approve payouts | Course creation in DB |
  | Course enrollment | Approve S-T applications | Refunds |
  | Content access | Monitor students/S-Ts | Platform exceptions |
  | Scheduling/booking | | Creator support |
  | Video sessions (BBB) | | |
  | Progress tracking | | |
  | Email notifications | | |
  | Payout processing | | |

- **Open Questions (7 total):**
  1. Certification format (PDF? Email? Badge?)
  2. Communication channels (S-T and Creator)
  3. Cancellation/rescheduling process
  4. S-T assignment permanence (can student switch?)
  5. Payout timing (per completion? weekly batch?)
  6. Content update requests
  7. Progress verification

**Technical Implications:**
- Block 1 Creator Dashboard is ACTIVE - not just monitoring, but action buttons for approval workflows
- Key correction from original: Creator (not Brian) manages course operations
- Brian's time reduced from earlier 6-10 hrs to 3-4 hrs/week
- Payouts via Stripe (not PayPal/Venmo manual)
- No ratings on S-T cards in Block 1 (Block 2 feature)

**Relationship to Other Docs:**
- **Organizes** CD-012's 8 MVP features by actor
- **Confirms** CD-019's creator-controlled operational model
- **Confirms** CD-020's Stripe-based payout workflow
- **Clarifies** Block 1 scope vs later blocks

**Goals Referenced:** GO-001 (flywheel), GO-004 (Genesis cohort), GO-008 (multi-role system)
**Stories Referenced:** Consolidates existing stories by actor capability

---

### CD-031: PeerLoop User Journeys & Summary (Dec 7, 2025)
**Date Uploaded:** 2025-12-24
**Original Date:** 2025-12-07
**Author:** Brian + Claude (Q-Command System)
**Status:** APPROVED
**Summary for SPECS.md:**

Quick reference document with user journey narratives and one-page story summary. Provides high-level view of all actors' journeys and story counts by category.

**Key elements for SPECS.md:**

- **User Journey Narratives for 7 Actor Types:**
  1. **Student (Sarah):** Browse → enroll ($450) → schedule → learn (BBB sessions + content) → complete → certify → apply to become S-T → teach others
  2. **Student-Teacher (Marcus):** Set availability → receive bookings → conduct sessions → guide students → recommend for certification → receive 70% payout
  3. **Creator (Guy):** Work with Brian to set up course → monitor dashboard → approve certifications/payouts/S-T apps → earn 15% royalty
  4. **Admin (Brian):** Onboard creators → monitor platform → handle exceptions → 3-4 hrs/week strategic oversight
  5. **Visitor:** View value proposition → browse courses/creators without login → sign up when enrolling
  6. **Community Moderator:** Monitor feed → answer questions → delete/ban → pin announcements → manage flagged queue
  7. **Employer/Funder:** Pay for employee enrollment → receive progress updates → get certification copy

- **One-Page Story Summary:**
  | Actor | Stories | Notes |
  |-------|---------|-------|
  | Visitor (Pre-Login) | 15 | Homepage, courses, auth |
  | Student | 56 | P0: pay, content, sessions, dashboard; P0 Block 2: S-T application, certificates |
  | Student-Teacher | 23 | P0: availability, students, sessions, payouts |
  | Creator | 36 | P0: students, S-Ts, sessions, approvals |
  | Admin (Brian) | 29 | P0: onboard, refunds, Stripe |
  | System/Platform | 84 | Auth, payments, video, email, calendar, progress, messaging, feed |
  | Community Moderator | 9 | Delete posts, flagged queue |
  | Employer/Funder | 6 | All P1 |
  | **TOTAL** | **258** | **135 P0 (MVP Critical)** |

- **Timeline (Full 135 P0 Scope):**
  | Phase | Weeks | What's Done |
  |-------|-------|-------------|
  | Block 1 | 4-5 | Core flow + basic messaging |
  | Block 2 | 4-5 | Community feed + profiles |
  | Block 3 | 4-6 | Full features + polish |
  | Buffer | 2 | Testing |
  | **TOTAL** | **14-18** | **Launch: April-May 2026** |

- **Key Decisions (Dec 7, 2025) - Updated:**
  - ✅ Build messaging system (full in-platform)
  - ✅ Build community feed (posts, likes, replies, follows)
  - ✅ Build follow system (social graph)
  - ✅ Build file uploads (profiles, course materials)

- **Flywheel Summary:**
  ```
  Student enrolls ($450) → Learns from S-T → Completes → S-T recommends → Creator certifies
  → Creator approves payout → 70/15/15 split via Stripe → Student becomes S-T → Teaches new students → Cycle repeats
  ```

**Timeline Note:**
- CD-031 shows 14-18 weeks / April-May 2026 launch
- CD-029 shows 21-24 weeks / May-June 2026 launch
- Difference: CD-031 covers P0 scope only; CD-029 includes community and polish blocks

**Story Count Note:**
- CD-031 shows 258 total / 135 P0
- USER-STORIES.md shows 299 total / 139 P0
- Difference likely due to stories added after Dec 7 (CD-023 Goodwill, CD-024 Feed Access, CD-025/CD-026 Course Display, CD-029 Trust-Building)

**Relationship to Other Docs:**
- **Consolidates** CD-030's actor capabilities into journey narratives
- **Provides** story summary aligned with CD-029's block structure
- **Confirms** timeline and key decisions from Dec 7

**Goals Referenced:** GO-001 (flywheel), GO-004 (Genesis cohort), GO-018 (timeline)

---

### CD-032: Fraser's Meeting Notes (Nov 9 - Dec 24, 2025)
**Date Uploaded:** 2025-12-24
**Original Date:** 2025-11-09 to 2025-12-24
**Author:** Fraser (Developer)
**Type:** Compiled Meeting Notes
**Summary for SPECS.md:**

Developer's personal notes from meetings and observations over the project timeline. Contains valuable context, decisions, and open questions not fully captured in formal documents.

**Key elements for SPECS.md:**

- **Creator Pricing Model (Nov 21) - NEW:**
  - Monthly subscription fee for creators
  - Per-course fee for each course
  - **Lifetime membership for first 10-20 creators** (early adopter incentive)
  - AppSumo launch consideration for bootstrapping community

- **Platform Philosophy (Nov 20):**
  - 80% focus on education/giving to public, 20% on monetization
  - Not worried about going viral - will be a good business regardless

- **Product Naming (Dec 22) - NEW:**
  - Brian doesn't like "tutoring" - prefers "skills taught from people just ahead of you"
  - Teaching moves learner from 70% to 80% mastery
  - Gabriel: Call it a "platform" not an "app"
  - Fraser's suggestion: "Personalized transfer of skills platform"
  - **Learning split:** 50% non-expert tutoring, 50% social interaction through feeds/challenges

- **Architecture Decisions (Nov 24):**
  - BBB and Stream as **backend services** to custom frontend
  - Create as little new stuff as possible while looking professional
  - Keep costs down until site pays for itself, then go fully custom
  - Eventually may have 3 developers working for Fraser
  - Invitation-only launch to control reception and create buzz

- **Feed Companion UI (Nov 26 + Dec 24) - NEW:**
  - User feed showing 10 most recent posters with 24hr count
  - Pinnable authors/posts to track specific content
  - AI Chat component in feed - users can ask for what they want to see
  - **Feed noise solution:** Pin a post → show original + latest thread comment only
  - Privacy: Clear policy, NOT using AI to mine user discussions

- **Onboarding Process (Nov 26) - NEW:**
  - Need onboarding to get initial interests from users
  - AI can suggest courses/teachers/students over time (with privacy in mind)

- **Timeline Reality (Dec 10) - CONFLICTS:**
  - Fraser believes 6 months more realistic than 4 months
  - Budget ($75K) OK at present

- **Page Architecture (Dec 22) - NEW:**
  - 3 basic page types:
    1. **Public-facing:** Predictable layout, CTAs to get signups
    2. **User-facing:** After login
    3. **Admin pages:** Just for Brian
  - Could be subdomains or folders under main domain

- **Additional Features Mentioned:**
  - **Changelog page** (Dec 5) - add to site
  - **Feature flags** (Dec 24) - hide features behind flags
  - **ICS export** (Dec 10) - export calendar to Google/Outlook/Apple via email
  - **Course promotion** (Dec 24) - paid promotion into feeds, basic promotion free
  - **Sub-communities** (Dec 24) - users may want to create and invite others
  - **Custom coaching/mentoring** (Dec 24) - revenue stream for students needing extra help

- **Unified Dashboard (Dec 24) - CLARIFICATION:**
  - User can have multiple roles simultaneously (student, guest, student-teacher, teacher)
  - Dashboard should show all roles on common dashboard
  - NOT separate logins per role
  - Roles isolated and interconnected as needed

- **Open Questions (Dec 24):**
  1. **S-T Pricing Visibility:** How do new students see S-T prices before buying course?
     - Students buy course from Teacher but S-Ts have cheaper rates they never see
     - Need to resolve: how do students find/evaluate S-Ts before buying?
  2. **Course Passing:** How do students "pass" a course? What are the criteria?
  3. **Moderator Invites:** Moderators need login + invite from Teacher to moderate feeds

**Technical Implications:**
- Feature flag system needed for hiding features
- Onboarding flow for interest collection
- Feed companion/pinning UI component
- AI chat integration in feed
- Sub-community creation capability
- Changelog page
- 3-tier page architecture (public/user/admin)

**Relationship to Other Docs:**
- **Reinforces** CD-005, CD-008 (Stream for feeds, BBB for video)
- **Adds** creator pricing model not in other docs
- **Adds** feed companion UI concept
- **Adds** onboarding process requirement
- **Clarifies** unified dashboard vs separate role logins
- **Raises** timeline concern (6 months vs 4 months)

**Goals Referenced:** GO-003 (sustainable income - creator pricing), GO-010 (community features - feed companion), GO-019 (gamification - noted)
**Goals Implied:** Creator subscription model, feature flag system, onboarding process
**Stories Implied:** 15+ new stories (feed companion, onboarding, changelog, sub-communities, extra coaching, course promotion, feature flags)

---

### CD-033: Slack - S-T Pricing Clarification
**Date Uploaded:** 2025-12-24
**Source:** Slack conversation between Fraser Gorrie and Brian LeBlanc
**Type:** Clarification / Decision
**Summary for SPECS.md:**

Real-time Slack conversation resolving Question #23 about Student-Teacher pricing visibility. Contains critical pricing model decisions.

**Key elements for SPECS.md:**

- **Unified Pricing Model (CONFIRMED) - CRITICAL:**
  - **Course price IS the S-T price** - no separate Teacher premium
  - Creator prices course as if they're NOT the primary teacher
  - "Too complicated for the creator to charge premium. Too confusing."
  - Question #23 resolved: no hidden pricing because displayed price already reflects S-T level

- **Revenue Split (CONFIRMED):**
  - **85/15 split** (platform takes 15%)
  - Example: $450 course → $67.50 site, $67.50 creator, $315 adjustable (S-T share)
  - When creator teaches: creator earns full amount (minus platform fee)

- **Enrollment Flow (CLARIFIED):**
  1. Student finds course, clicks for detail
  2. Clicks Enroll button
  3. Sees **calendar with dots** showing S-T availability
  4. **S-T list with times** displayed below calendar
  5. Click S-T for detail OR click time to purchase
  6. **"Schedule Later" button** available
  7. After purchase: access to course feed + booking rights

- **Creator Teaching Role (CLARIFIED):**
  - Creator can teach but will reduce as network grows
  - Creator charges **same fee as S-Ts** (no premium)
  - Creator's job: "prime the pump" - teach initially, certify S-Ts
  - Community takes over teaching over time

- **Refund Policy (NEW):**
  - Students can bail at **any time** and get a refund
  - "The pressure is on the student teacher to earn his pay"

- **S-T Discount Option (POSTPONED):**
  - Initially discussed: S-Ts could teach at discount/free to gain experience
  - Concern: "bidding war" might "cheapen the experience"
  - Decision: Defer for MVP, see if quality S-T experience holds up

**Technical Implications:**
- Course detail page needs S-T availability calendar view
- Single price point per course simplifies payment logic
- Refund system required with any-time cancellation
- No need for price comparison UI (single price)

---

### CD-034: Brian Review Decisions
**Date Uploaded:** 2025-12-26
**Source:** Brian Review Session - RUN-001 Final Review
**Type:** Scope Changes & Clarifications
**Summary for SPECS.md:**

Consolidated decisions from Brian's review session that changed scope or clarified requirements. Applied directly to technical docs; requires extraction to GOALS.md and USER-STORIES.md.

**Key elements for SPECS.md:**

- **Homework System → MVP (SCOPE CHANGE):**
  - Changed from "Excluding from MVP" to Block 4 MVP feature
  - Creators/STs create assignments linked to courses/modules
  - Students submit homework with text and/or file uploads
  - Reviewers provide feedback, approve, or request resubmit
  - Optional grading with points

- **Session Resources → R2 Storage (SCOPE CHANGE):**
  - Changed from "External links" to full R2 storage
  - PlugNmeet recordings replicated to R2
  - STs upload session materials post-session
  - Creators upload course-level resources
  - Students access recordings and downloads

- **Moderator Invites → Two-Step Flow (SCOPE CHANGE):**
  - Changed from "Post-MVP" to included
  - Admin sends invite email with token
  - Invitee clicks link to accept/decline
  - New users create account during acceptance
  - Accepting sets `is_moderator = true`

- **Privacy Default → Private (CLARIFICATION):**
  - Changed from "Assuming Public default" to Private
  - `privacy_public = false` by default
  - Users opt-in to public visibility

**Technical Implications:**
- 4 new DB tables: homework_assignments, homework_submissions, session_resources, moderator_invites
- 24 new API endpoints across homework, resources, and invites
- HOMEWORK feature flag added (MVP, Block 4)
- 7 pages updated, 1 new page (MINV)
- Requires extraction to GOALS.md and USER-STORIES.md

---

### CD-035: Brian UX & Pricing Note
**Date Uploaded:** 2026-01-09
**Source:** Brian - Client Note (Pasted in Chat)
**Type:** UX Changes, Pricing Updates, Terminology
**Location:** [RFC/CD-035/](../../RFC/CD-035/) (RFC folder)
**Summary for SPECS.md:**

Brian's directives about course display UX, creator pricing model, and terminology preferences with significant UI/UX changes. See [RFC/CD-035/RFC.md](../../RFC/CD-035/RFC.md) for actionable checklist.

**Key elements:**
- Vertical scroll feed (no grid, infinite scroll)
- Creator monthly fee (~$25/month TBD, free initially)
- Revenue split: 85% only when creator teaches, 15% royalty from S-Ts
- Terminology: "tutor" → "Student-Teacher"
- Community time expectations

---

## Index Statistics
- **Total Documents:** 35
- **Next CD Number:** CD-036
- **Last Updated:** 2026-01-09

## Quick Reference

| ID | Document | Key Content |
|----|----------|-------------|
| CD-001 | Business Plan | Revenue model, flywheel, go-to-market |
| CD-002 | Feature Summary | UI/UX mockups, tech stack, navigation |
| CD-003 | User Stories | Role-based needs, 6 user types |
| CD-004 | Impact Filter | Mission, success metrics, vision |
| CD-005 | Slack - GetStream | Feed tech choice, MVP priorities, Discord concerns |
| CD-006 | Slack - Calendar/BBB | Calendar priority, BBB hosting, Discord interim |
| CD-007 | Slack - P2P Video | Daily.co, Digital Samba, P2P for 1:1 sessions |
| CD-008 | Meeting - Budget/Feed | $75K budget, 4mo timeline, Skool prototype, feeds-only Stream |
| CD-009 | Slack - Blindside/Cloudflare | BBB via Blindside Networks, peerloop.com on Cloudflare |
| CD-010 | Miro - Main Activities by Role | 5 roles mapped, Community Moderator NEW, pain points |
| CD-011 | Miro - Drivers & Action Items | User motivations, Bluesky confirmed, mastery certificate, opt-out |
| CD-012 | Meeting Prep - MVP Review | 8 MVP features, $75K budget, 60-80 students, 3 gaps identified |
| CD-013 | MVP Decision - Community Feed | getstream.io, 5 hypotheses validated, 2-3 weeks dev, role permissions |
| CD-014 | MVP Decision - Video Conferencing | BBB/Jitsi, 4 hypotheses, 1-2 weeks dev, calendar/scheduling |
| CD-015 | Decision - Calendar/Scheduling | 3 options (Cal.com/custom/Google), 5 hypotheses, 60 sessions/week |
| CD-016 | Decision - Rebrand to PeerLoop | AlphaPeer → PeerLoop, trademark avoidance, peerloop.com |
| CD-017 | MVP Decision - Creator Profiles | Basic only ($500), unified system, deferred dashboard/analytics |
| CD-018 | MVP Decision - Student Profile System | $14K-18.7K, 3-4 weeks, social graph, ST signaling, H4/H6 validation |
| CD-019 | Decision - Course Content Delivery | $2K-4K, ~1 week, external video/docs, self-mark progress, user journey |
| CD-020 | MVP Decision - Payment & Escrow | Stripe, $11K-15K, 2-3 weeks, semi-automated 70/15/15 split, H1 validation |
| CD-021 | Database Schema Sample | JS mock data, Creator/Course entities, schema definitions, new fields to add |
| CD-022 | Data Structures Doc | Formal docs, prototype URL, ratingCount, badge fields |
| CD-023 | Goodwill Points Spec | Summon Help, community currency, anti-gaming, Block 2+ |
| CD-024 | Meeting Notes - Brian Walkthrough | User access states, instructor feed, flywheel testing (4 courses), feed promotion |
| CD-025 | Sample Course - Intro to Claude Code | Real course data (4 files), schema validation, Guy Rymberg, $249, 2 sessions |
| CD-026 | Genesis Cohort Course Package | 3 more courses (n8n, Vibe Coding, AI Tools), same format, course sequencing |
| CD-027 | Prototype Walkthrough - Complete | All 5 personas, 20+ pages, 31 keepers, gaps & UX issues, 12 questions for Brian |
| CD-028 | Slack - PlugNmeet | Modern BBB replacement, microservices, Zoom-like UI, flat pricing |
| CD-029 | Block Sequence v2.1 | Gabriel's management doc, 6 hypotheses (H1-H6), block sequence 0.x-2.x, Brian's trust-building comments, Dec 15 access model change, Dec 19 UX "video lynchpin" |
| CD-030 | Block 1 Actor Stories | 4 actors (Student, S-T, Creator, Brian), Block 1 capabilities/limitations, automated vs manual, open questions |
| CD-031 | User Journeys Summary | 7 actor journeys, 258 stories / 135 P0, 14-18 week timeline, April-May 2026 launch, Dec 7 decisions |
| CD-032 | Fraser Meeting Notes | Creator pricing model, feed companion UI, onboarding, 6-month timeline, unified dashboard, open questions |
| CD-033 | Slack - S-T Pricing | Unified pricing (course price = S-T price), 85/15 split, enrollment flow, refund policy, S-T discounts deferred |
| CD-034 | Brian Review Decisions | Homework → MVP, Session Resources → R2, Moderator Invites → two-step, Privacy → Private default |
| CD-035 | Brian UX & Pricing Note | Vertical scroll feed, creator monthly fee, 85%/15% clarification, tutor → Student-Teacher |

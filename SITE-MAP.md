# Site Map

Page interconnection diagrams. Originally auto-generated from page JSON specs (now archived).
The generation script was removed in Session 307 (2026-02-27). This file is now a static reference.

Last Generated: 2026-01-28

**60** pages, **202** connections across all focuses

| Focus | Primary Pages | Description |
|-------|:------------:|-------------|
| [Public / Visitor Journey](#public) | 24 | Marketing pages, course/creator browsing, auth flow |
| [Student Journey](#student) | 21 | Dashboard, learning, sessions, community, settings |
| [Student-Teacher Journey](#teacher) | 16 | Teaching dashboard, students, sessions, earnings, analytics |
| [Creator Journey](#creator) | 12 | Creator dashboard, studio, analytics, profile |
| [Admin Journey](#admin) | 16 | Admin dashboard, management pages, moderation |

---

## Public / Visitor Journey {#public}

Marketing pages, course/creator browsing, auth flow

**24** primary pages, **11** boundary, **81** connections

```mermaid
flowchart LR
  subgraph Root
    HOME["Homepage"]
    LEAD["Leaderboard"]
    LGIN["Login"]
    MSGS["Messages"]
    NOTF["Notifications"]
    PROF["Profile"]
    PWRS["Password Reset"]
    SGUP["Sign Up"]
  end
  subgraph Marketing
    ABOU["About Us"]
    BTAT["Become a Teacher"]
    CONT["Contact Us"]
    FAQP["Frequently Asked Questions"]
    FCRE["For Creators"]
    HOWI["How It Works"]
    PRIC["Pricing"]
    PRIV["Privacy Policy"]
    STOR["Success Stories"]
    TERM["Terms of Service"]
    TSTM["Testimonials"]
  end
  subgraph Courses
    CBRO["Course Browse"]
    CDET["Course Detail"]
    CSUC["Enrollment Success"]
  end
  subgraph Creators
    CPRO["Creator Profile"]
    CRLS["Creator Listing"]
  end
  subgraph External
    ADMN["Admin Dashboard"]:::boundary
    CCNT["Course Content"]:::boundary
    CDSH["Creator Dashboard"]:::boundary
    FEED["Community Feed"]:::boundary
    IFED["Instructor Feed"]:::boundary
    SBOK["Session Booking"]:::boundary
    SDSH["Student Dashboard"]:::boundary
    SETT["Settings Hub"]:::boundary
    SROM["Session Room"]:::boundary
    STPR["Student-Teacher Profile"]:::boundary
    TDSH["Student-Teacher Dashboard"]:::boundary
  end

  TSTM -->|Browse Courses' CTA| CBRO
  TSTM -->|Get Started' CTA| SGUP
  TSTM -->|Course link on card| CDET
  TERM -->|Privacy Policy' link| PRIV
  TERM -->|Contact us' for questions| CONT
  STOR -->|Start Learning' CTA| CBRO
  SGUP -->|Successful signup as St…| SDSH
  SGUP -->|Successful signup as Cr…| CDSH
  SGUP -->|Already have an account?…| LGIN
  SGUP -->|Logo click| HOME
  PWRS -->|Back to login' link| LGIN
  PWRS -->|Logo click| HOME
  PROF -->|Settings' / 'Edit Settin…| SETT
  PROF -->|Message' on others' pro…| MSGS
  PROF -->|If user is Creator| CPRO
  PROF -->|If user is ST| STPR
  PRIV -->|Terms of Service' link| TERM
  PRIV -->|Contact us' for privacy …| CONT
  PRIC -->|Browse Courses' CTA| CBRO
  PRIC -->|Get Started' CTA| SGUP
  PRIC -->|Become a Teacher' CTA| BTAT
  PRIC -->|Create a Course' CTA| FCRE
  PRIC -->|More questions?' link| FAQP
  NOTF -->|Session notification cli…| SROM
  NOTF -->|Message notification cli…| MSGS
  NOTF -->|Course notification click| CDET
  NOTF -->|Follower notification cl…| PROF
  NOTF -->|Notification Settings| SETT
  MSGS -->|Avatar/name click in con…| PROF
  MSGS -->|Avatar/name click if ST| STPR
  MSGS -->|Book Session' in chat| SBOK
  LGIN -->|Successful login Studen…| SDSH
  LGIN -->|Successful login ST| TDSH
  LGIN -->|Successful login Creato…| CDSH
  LGIN -->|Successful login Admin| ADMN
  LGIN -->|Create an account' link| SGUP
  LGIN -->|Forgot password?' link| PWRS
  LGIN -->|Logo click| HOME
  LEAD -->|Click on user name| STPR
  LEAD -->|Back/breadcrumb| FEED
  HOME -->|Browse Courses' CTA| CBRO
  HOME -->|Featured course card cli…| CDET
  HOME -->|Meet Our Creators' link| CRLS
  HOME -->|Get Started' / 'Sign Up'…| SGUP
  HOME -->|Log In' nav link| LGIN
  HOWI -->|Get Started Free' CTA| SGUP
  HOWI -->|Start Learning' or 'Brow…| CBRO
  HOWI -->|Become a Teacher' link| BTAT
  HOWI -->|Create a Course' link| FCRE
  HOWI -->|See all FAQs' link| FAQP
  FCRE -->|Start Creating' CTA| SGUP
  FCRE -->|See Our Creators' link| CRLS
  FCRE -->|Talk to Our Team' link| CONT
  FCRE -->|More questions? See all …| FAQP
  FAQP -->|Contact Us' CTA| CONT
  CONT -->|Visit FAQ' link| FAQP
  CONT -->|Return to Home' after fo…| HOME
  BTAT -->|Browse Courses' CTA| CBRO
  BTAT -->|Check My Eligibility' CTA| LGIN
  BTAT -->|More questions? See all …| FAQP
  ABOU -->|Get Started Free' CTA| SGUP
  ABOU -->|Explore Courses' CTA| CBRO
  CRLS -->|Creator card click| CPRO
  CRLS -->|Course link on creator c…| CDET
  CPRO -->|Course card click| CDET
  CPRO -->|View All Courses| CBRO
  CPRO -->|View Feed' if enrolled …| IFED
  CPRO -->|Follow button logged ou…| SGUP
  CBRO -->|Course card click| CDET
  CBRO -->|Creator name/avatar click| CPRO
  CBRO -->|Sign up to enroll' prompt| SGUP
  CBRO -->|Log in' link| LGIN
  CDET -->|Book a Session' / ST car…| SBOK
  CDET -->|Enroll' logged out| SGUP
  CDET -->|Start Learning' enrolle…| CCNT
  CDET -->|Creator name/avatar click| CPRO
  CDET -->|ST name click in ST list| STPR
  CDET -->|Breadcrumb 'Courses| CBRO
  CSUC -->|Start Learning' CTA| CCNT
  CSUC -->|Go to Dashboard' CTA| SDSH
  CSUC -->|Book Your First Session'…| SBOK

  classDef boundary stroke-dasharray: 5 5,fill:#f9f9f9,color:#999
```

### Public / Visitor Journey — Connections

| Page | Out | Targets |
|------|:---:|---------|
| ABOU | 2 | SGUP, CBRO |
| BTAT | 3 | CBRO, LGIN, FAQP |
| CBRO | 4 | CDET, CPRO, SGUP, LGIN |
| CDET | 6 | *SBOK*, SGUP, *CCNT*, CPRO, *STPR*, CBRO |
| CONT | 2 | FAQP, HOME |
| CPRO | 4 | CDET, CBRO, *IFED*, SGUP |
| CRLS | 2 | CPRO, CDET |
| CSUC | 3 | *CCNT*, *SDSH*, *SBOK* |
| FAQP | 1 | CONT |
| FCRE | 4 | SGUP, CRLS, CONT, FAQP |
| HOME | 5 | CBRO, CDET, CRLS, SGUP, LGIN |
| HOWI | 5 | SGUP, CBRO, BTAT, FCRE, FAQP |
| LEAD | 2 | *STPR*, *FEED* |
| LGIN | 7 | *SDSH*, *TDSH*, *CDSH*, *ADMN*, SGUP, PWRS, HOME |
| MSGS | 3 | PROF, *STPR*, *SBOK* |
| NOTF | 5 | *SROM*, MSGS, CDET, PROF, *SETT* |
| PRIC | 5 | CBRO, SGUP, BTAT, FCRE, FAQP |
| PRIV | 2 | TERM, CONT |
| PROF | 4 | *SETT*, MSGS, CPRO, *STPR* |
| PWRS | 2 | LGIN, HOME |
| SGUP | 4 | *SDSH*, *CDSH*, LGIN, HOME |
| STOR | 1 | CBRO |
| TERM | 2 | PRIV, CONT |
| TSTM | 3 | CBRO, SGUP, CDET |

*Italicized* targets are boundary pages (outside this focus area).

---

## Student Journey {#student}

Dashboard, learning, sessions, community, settings

**21** primary pages, **6** boundary, **75** connections

```mermaid
flowchart LR
  subgraph Root
    LEAD["Leaderboard"]
    MSGS["Messages"]
    NOTF["Notifications"]
    PROF["Profile"]
  end
  subgraph Courses
    CBRO["Course Browse"]
    CCNT["Course Content"]
    CDET["Course Detail"]
    CDIS["Course Discussion"]
    CSUC["Enrollment Success"]
  end
  subgraph Teachers
    STDR["Student-Teacher Directory"]
    STPR["Student-Teacher Profile"]
  end
  subgraph Community
    FEED["Community Feed"]
    IFED["Instructor Feed"]
  end
  subgraph Session
    SBOK["Session Booking"]
    SROM["Session Room"]
  end
  subgraph Settings
    SETT["Settings Hub"]
    SNOT["Notification Settings"]
    SPAY["Payment Settings"]
    SPRF["Profile Settings"]
    SSEC["Security Settings"]
  end
  subgraph Dash-Learning
    SDSH["Student Dashboard"]
  end
  subgraph External
    CPRO["Creator Profile"]:::boundary
    HOME["Homepage"]:::boundary
    LGIN["Login"]:::boundary
    PWRS["Password Reset"]:::boundary
    SGUP["Sign Up"]:::boundary
    TDSH["Student-Teacher Dashboard"]:::boundary
  end

  PROF -->|Settings' / 'Edit Settin…| SETT
  PROF -->|Message' on others' pro…| MSGS
  PROF -->|If user is Creator| CPRO
  PROF -->|If user is ST| STPR
  NOTF -->|Session notification cli…| SROM
  NOTF -->|Message notification cli…| MSGS
  NOTF -->|Course notification click| CDET
  NOTF -->|Follower notification cl…| PROF
  NOTF -->|Notification Settings| SETT
  MSGS -->|Avatar/name click in con…| PROF
  MSGS -->|Avatar/name click if ST| STPR
  MSGS -->|Book Session' in chat| SBOK
  LEAD -->|Click on user name| STPR
  LEAD -->|Back/breadcrumb| FEED
  STDR -->|ST card click| STPR
  STDR -->|Course badge click on ST…| CDET
  STDR -->|Book Session' CTA on card| SBOK
  STPR -->|Book Session' CTA| SBOK
  STPR -->|Course card click| CDET
  STPR -->|Message' button| MSGS
  SSEC -->|Breadcrumb navigation| SETT
  SSEC -->|Change password' link| PWRS
  SSEC -->|Logout button| HOME
  SPRF -->|Breadcrumb navigation| SETT
  SPRF -->|View Profile' link| PROF
  SPAY -->|Breadcrumb navigation| SETT
  SNOT -->|Breadcrumb navigation| SETT
  SETT -->|Profile card click| SPRF
  SETT -->|Payments card click| SPAY
  SETT -->|Notifications card click| SNOT
  SETT -->|Security card click| SSEC
  SROM -->|Back to Dashboard' / ses…| SDSH
  SROM -->|Back to Dashboard' / ses…| TDSH
  SROM -->|Back to Course| CCNT
  SDSH -->|Continue Learning' on co…| CCNT
  SDSH -->|Book Session' / 'Schedule| SBOK
  SDSH -->|Join Session| SROM
  SDSH -->|Course title click| CDET
  SDSH -->|Community' nav| FEED
  SDSH -->|Browse Courses| CBRO
  SDSH -->|Settings' nav| PROF
  SDSH -->|Your Teacher' link| STPR
  SDSH -->|Notification bell| NOTF
  CBRO -->|Course card click| CDET
  CBRO -->|Creator name/avatar click| CPRO
  CBRO -->|Sign up to enroll' prompt| SGUP
  CBRO -->|Log in' link| LGIN
  CDET -->|Book a Session' / ST car…| SBOK
  CDET -->|Enroll' logged out| SGUP
  CDET -->|Start Learning' enrolle…| CCNT
  CDET -->|Creator name/avatar click| CPRO
  CDET -->|ST name click in ST list| STPR
  CDET -->|Breadcrumb 'Courses| CBRO
  CSUC -->|Start Learning' CTA| CCNT
  CSUC -->|Go to Dashboard' CTA| SDSH
  CSUC -->|Book Your First Session'…| SBOK
  CCNT -->|Schedule Session| SBOK
  CCNT -->|Join Session' if immine…| SROM
  CCNT -->|Dashboard' / back| SDSH
  CCNT -->|Course Info| CDET
  CCNT -->|ST name in 'Your Teacher| STPR
  CDIS -->|Back to Course| CCNT
  CDIS -->|ST name click| STPR
  CDIS -->|User name click| PROF
  SBOK -->|After successful booking| SDSH
  SBOK -->|ST name/avatar click| STPR
  SBOK -->|Back/cancel| CDET
  FEED -->|Author name/avatar click| PROF
  FEED -->|Course mention click| CDET
  FEED -->|Creator mention click| CPRO
  FEED -->|View Creator Feed| IFED
  IFED -->|Instructor name/avatar c…| CPRO
  IFED -->|Course mention click| CDET
  IFED -->|Other student name click| PROF
  IFED -->|Main Feed' nav| FEED

  classDef boundary stroke-dasharray: 5 5,fill:#f9f9f9,color:#999
```

### Student Journey — Connections

| Page | Out | Targets |
|------|:---:|---------|
| CBRO | 4 | CDET, *CPRO*, *SGUP*, *LGIN* |
| CCNT | 5 | SBOK, SROM, SDSH, CDET, STPR |
| CDET | 6 | SBOK, *SGUP*, CCNT, *CPRO*, STPR, CBRO |
| CDIS | 3 | CCNT, STPR, PROF |
| CSUC | 3 | CCNT, SDSH, SBOK |
| FEED | 4 | PROF, CDET, *CPRO*, IFED |
| IFED | 4 | *CPRO*, CDET, PROF, FEED |
| LEAD | 2 | STPR, FEED |
| MSGS | 3 | PROF, STPR, SBOK |
| NOTF | 5 | SROM, MSGS, CDET, PROF, SETT |
| PROF | 4 | SETT, MSGS, *CPRO*, STPR |
| SBOK | 3 | SDSH, STPR, CDET |
| SDSH | 9 | CCNT, SBOK, SROM, CDET, FEED, CBRO, PROF, STPR, NOTF |
| SETT | 4 | SPRF, SPAY, SNOT, SSEC |
| SNOT | 1 | SETT |
| SPAY | 1 | SETT |
| SPRF | 2 | SETT, PROF |
| SROM | 3 | SDSH, *TDSH*, CCNT |
| SSEC | 3 | SETT, *PWRS*, *HOME* |
| STDR | 3 | STPR, CDET, SBOK |
| STPR | 3 | SBOK, CDET, MSGS |

*Italicized* targets are boundary pages (outside this focus area).

---

## Student-Teacher Journey {#teacher}

Teaching dashboard, students, sessions, earnings, analytics

**16** primary pages, **8** boundary, **60** connections

```mermaid
flowchart LR
  subgraph Root
    MSGS["Messages"]
    NOTF["Notifications"]
    PROF["Profile"]
  end
  subgraph Courses
    CDET["Course Detail"]
  end
  subgraph Teachers
    STDR["Student-Teacher Directory"]
    STPR["Student-Teacher Profile"]
  end
  subgraph Session
    SBOK["Session Booking"]
    SROM["Session Room"]
  end
  subgraph Settings
    SETT["Settings Hub"]
    SPAY["Payment Settings"]
    SPRF["Profile Settings"]
  end
  subgraph Dash-Teaching
    CEAR["Earnings Detail Creator"]
    CMST["My Students Creator"]
    CSES["Session History Creator"]
    TANA["ST Analytics"]
    TDSH["Student-Teacher Dashboard"]
  end
  subgraph External
    CBRO["Course Browse"]:::boundary
    CCNT["Course Content"]:::boundary
    CDSH["Creator Dashboard"]:::boundary
    CPRO["Creator Profile"]:::boundary
    SDSH["Student Dashboard"]:::boundary
    SGUP["Sign Up"]:::boundary
    SNOT["Notification Settings"]:::boundary
    SSEC["Security Settings"]:::boundary
  end

  PROF -->|Settings' / 'Edit Settin…| SETT
  PROF -->|Message' on others' pro…| MSGS
  PROF -->|If user is Creator| CPRO
  PROF -->|If user is ST| STPR
  NOTF -->|Session notification cli…| SROM
  NOTF -->|Message notification cli…| MSGS
  NOTF -->|Course notification click| CDET
  NOTF -->|Follower notification cl…| PROF
  NOTF -->|Notification Settings| SETT
  MSGS -->|Avatar/name click in con…| PROF
  MSGS -->|Avatar/name click if ST| STPR
  MSGS -->|Book Session' in chat| SBOK
  STDR -->|ST card click| STPR
  STDR -->|Course badge click on ST…| CDET
  STDR -->|Book Session' CTA on card| SBOK
  STPR -->|Book Session' CTA| SBOK
  STPR -->|Course card click| CDET
  STPR -->|Message' button| MSGS
  SPRF -->|Breadcrumb navigation| SETT
  SPRF -->|View Profile' link| PROF
  SPAY -->|Breadcrumb navigation| SETT
  SETT -->|Profile card click| SPRF
  SETT -->|Payments card click| SPAY
  SETT -->|Notifications card click| SNOT
  SETT -->|Security card click| SSEC
  SROM -->|Back to Dashboard' / ses…| SDSH
  SROM -->|Back to Dashboard' / ses…| TDSH
  SROM -->|Back to Course| CCNT
  CMST -->|Student name click| PROF
  CMST -->|Message' button| MSGS
  CMST -->|Course name click| CDET
  CMST -->|View Sessions' on studen…| CSES
  CMST -->|Back/breadcrumb| CDSH
  CSES -->|Student/ST name click| PROF
  CSES -->|View Recording| SROM
  CSES -->|Message' button| MSGS
  CSES -->|Course name click| CDET
  CSES -->|Back/breadcrumb| CDSH
  TDSH -->|Join Session| SROM
  TDSH -->|View My Profile| STPR
  TDSH -->|Edit Profile| PROF
  TDSH -->|Availability| SETT
  TDSH -->|Message Student| MSGS
  TDSH -->|Course title click| CDET
  CEAR -->|Course name click| CDET
  CEAR -->|Payment Settings| SETT
  CEAR -->|Back/breadcrumb| CDSH
  TANA -->|View Full Earnings| CEAR
  TANA -->|View Sessions| CSES
  TANA -->|View Students| CMST
  TANA -->|Back/breadcrumb| TDSH
  CDET -->|Book a Session' / ST car…| SBOK
  CDET -->|Enroll' logged out| SGUP
  CDET -->|Start Learning' enrolle…| CCNT
  CDET -->|Creator name/avatar click| CPRO
  CDET -->|ST name click in ST list| STPR
  CDET -->|Breadcrumb 'Courses| CBRO
  SBOK -->|After successful booking| SDSH
  SBOK -->|ST name/avatar click| STPR
  SBOK -->|Back/cancel| CDET

  classDef boundary stroke-dasharray: 5 5,fill:#f9f9f9,color:#999
```

### Student-Teacher Journey — Connections

| Page | Out | Targets |
|------|:---:|---------|
| CDET | 6 | SBOK, *SGUP*, *CCNT*, *CPRO*, STPR, *CBRO* |
| CEAR | 3 | CDET, SETT, *CDSH* |
| CMST | 5 | PROF, MSGS, CDET, CSES, *CDSH* |
| CSES | 5 | PROF, SROM, MSGS, CDET, *CDSH* |
| MSGS | 3 | PROF, STPR, SBOK |
| NOTF | 5 | SROM, MSGS, CDET, PROF, SETT |
| PROF | 4 | SETT, MSGS, *CPRO*, STPR |
| SBOK | 3 | *SDSH*, STPR, CDET |
| SETT | 4 | SPRF, SPAY, *SNOT*, *SSEC* |
| SPAY | 1 | SETT |
| SPRF | 2 | SETT, PROF |
| SROM | 3 | *SDSH*, TDSH, *CCNT* |
| STDR | 3 | STPR, CDET, SBOK |
| STPR | 3 | SBOK, CDET, MSGS |
| TANA | 4 | CEAR, CSES, CMST, TDSH |
| TDSH | 6 | SROM, STPR, PROF, SETT, MSGS, CDET |

*Italicized* targets are boundary pages (outside this focus area).

---

## Creator Journey {#creator}

Creator dashboard, studio, analytics, profile

**12** primary pages, **8** boundary, **47** connections

```mermaid
flowchart LR
  subgraph Root
    MSGS["Messages"]
    PROF["Profile"]
  end
  subgraph Courses
    CBRO["Course Browse"]
    CDET["Course Detail"]
  end
  subgraph Creators
    CPRO["Creator Profile"]
    CRLS["Creator Listing"]
  end
  subgraph Dash-Teaching
    CEAR["Earnings Detail Creator"]
    CMST["My Students Creator"]
    CSES["Session History Creator"]
  end
  subgraph Dash-Creator
    CANA["Creator Analytics"]
    CDSH["Creator Dashboard"]
    STUD["Creator Studio"]
  end
  subgraph External
    CCNT["Course Content"]:::boundary
    IFED["Instructor Feed"]:::boundary
    LGIN["Login"]:::boundary
    SBOK["Session Booking"]:::boundary
    SETT["Settings Hub"]:::boundary
    SGUP["Sign Up"]:::boundary
    SROM["Session Room"]:::boundary
    STPR["Student-Teacher Profile"]:::boundary
  end

  PROF -->|Settings' / 'Edit Settin…| SETT
  PROF -->|Message' on others' pro…| MSGS
  PROF -->|If user is Creator| CPRO
  PROF -->|If user is ST| STPR
  MSGS -->|Avatar/name click in con…| PROF
  MSGS -->|Avatar/name click if ST| STPR
  MSGS -->|Book Session' in chat| SBOK
  CMST -->|Student name click| PROF
  CMST -->|Message' button| MSGS
  CMST -->|Course name click| CDET
  CMST -->|View Sessions' on studen…| CSES
  CMST -->|Back/breadcrumb| CDSH
  CSES -->|Student/ST name click| PROF
  CSES -->|View Recording| SROM
  CSES -->|Message' button| MSGS
  CSES -->|Course name click| CDET
  CSES -->|Back/breadcrumb| CDSH
  CEAR -->|Course name click| CDET
  CEAR -->|Payment Settings| SETT
  CEAR -->|Back/breadcrumb| CDSH
  STUD -->|Dashboard' / back| CDSH
  STUD -->|Preview Course| CDET
  STUD -->|View Profile| CPRO
  CDSH -->|Creator Studio' / 'Manag…| STUD
  CDSH -->|View Public Profile| CPRO
  CDSH -->|Course card click| CDET
  CDSH -->|View Analytics| CANA
  CANA -->|Course name click| CDET
  CANA -->|View Students' link| CMST
  CANA -->|View Earnings' link| CEAR
  CANA -->|Back/breadcrumb| CDSH
  CRLS -->|Creator card click| CPRO
  CRLS -->|Course link on creator c…| CDET
  CPRO -->|Course card click| CDET
  CPRO -->|View All Courses| CBRO
  CPRO -->|View Feed' if enrolled …| IFED
  CPRO -->|Follow button logged ou…| SGUP
  CBRO -->|Course card click| CDET
  CBRO -->|Creator name/avatar click| CPRO
  CBRO -->|Sign up to enroll' prompt| SGUP
  CBRO -->|Log in' link| LGIN
  CDET -->|Book a Session' / ST car…| SBOK
  CDET -->|Enroll' logged out| SGUP
  CDET -->|Start Learning' enrolle…| CCNT
  CDET -->|Creator name/avatar click| CPRO
  CDET -->|ST name click in ST list| STPR
  CDET -->|Breadcrumb 'Courses| CBRO

  classDef boundary stroke-dasharray: 5 5,fill:#f9f9f9,color:#999
```

### Creator Journey — Connections

| Page | Out | Targets |
|------|:---:|---------|
| CANA | 4 | CDET, CMST, CEAR, CDSH |
| CBRO | 4 | CDET, CPRO, *SGUP*, *LGIN* |
| CDET | 6 | *SBOK*, *SGUP*, *CCNT*, CPRO, *STPR*, CBRO |
| CDSH | 4 | STUD, CPRO, CDET, CANA |
| CEAR | 3 | CDET, *SETT*, CDSH |
| CMST | 5 | PROF, MSGS, CDET, CSES, CDSH |
| CPRO | 4 | CDET, CBRO, *IFED*, *SGUP* |
| CRLS | 2 | CPRO, CDET |
| CSES | 5 | PROF, *SROM*, MSGS, CDET, CDSH |
| MSGS | 3 | PROF, *STPR*, *SBOK* |
| PROF | 4 | *SETT*, MSGS, CPRO, *STPR* |
| STUD | 3 | CDSH, CDET, CPRO |

*Italicized* targets are boundary pages (outside this focus area).

---

## Admin Journey {#admin}

Admin dashboard, management pages, moderation

**16** primary pages, **8** boundary, **50** connections

```mermaid
flowchart LR
  subgraph Root
    PROF["Profile"]
  end
  subgraph Courses
    CDET["Course Detail"]
  end
  subgraph Creators
    CPRO["Creator Profile"]
  end
  subgraph Community
    FEED["Community Feed"]
  end
  subgraph Admin
    AANA["Admin Analytics"]
    ACAT["Admin Categories"]
    ACRS["Admin Courses"]
    ACRT["Admin Certificates"]
    ADMN["Admin Dashboard"]
    AENR["Admin Enrollments"]
    AMOD["Admin Moderation"]
    APAY["Payout Management"]
    ASES["Admin Sessions"]
    ASTC["Admin Student-Teachers"]
    AUSR["Admin Users"]
  end
  subgraph Moderator
    MODQ["Moderator Queue"]
  end
  subgraph External
    CBRO["Course Browse"]:::boundary
    CCNT["Course Content"]:::boundary
    IFED["Instructor Feed"]:::boundary
    MSGS["Messages"]:::boundary
    SBOK["Session Booking"]:::boundary
    SETT["Settings Hub"]:::boundary
    SGUP["Sign Up"]:::boundary
    STPR["Student-Teacher Profile"]:::boundary
  end

  PROF -->|Settings' / 'Edit Settin…| SETT
  PROF -->|Message' on others' pro…| MSGS
  PROF -->|If user is Creator| CPRO
  PROF -->|If user is ST| STPR
  MODQ -->|Post context link| FEED
  MODQ -->|User profile link| PROF
  MODQ -->|Admin Dashboard| ADMN
  CPRO -->|Course card click| CDET
  CPRO -->|View All Courses| CBRO
  CPRO -->|View Feed' if enrolled …| IFED
  CPRO -->|Follow button logged ou…| SGUP
  CDET -->|Book a Session' / ST car…| SBOK
  CDET -->|Enroll' logged out| SGUP
  CDET -->|Start Learning' enrolle…| CCNT
  CDET -->|Creator name/avatar click| CPRO
  CDET -->|ST name click in ST list| STPR
  CDET -->|Breadcrumb 'Courses| CBRO
  FEED -->|Author name/avatar click| PROF
  FEED -->|Course mention click| CDET
  FEED -->|Creator mention click| CPRO
  FEED -->|View Creator Feed| IFED
  AUSR -->|View Profile' action| PROF
  ASTC -->|View Profile' action| AUSR
  ASTC -->|View Students' action| AENR
  ASTC -->|View Sessions' action| ASES
  ASTC -->|View Public Profile' but…| CPRO
  ASES -->|Student/ST name click| AUSR
  ASES -->|Course name click| ACRS
  ASES -->|Enrollment link| AENR
  APAY -->|Recipient name click| AUSR
  APAY -->|View Enrollment| AENR
  AMOD -->|User name click| AUSR
  AMOD -->|Content link click| CDET
  AMOD -->|Post link click| FEED
  ADMN -->|Users stat card or quick…| AUSR
  ADMN -->|Courses stat card or qui…| ACRS
  ADMN -->|Enrollments stat card or…| AENR
  ADMN -->|Student-Teachers stat ca…| ASTC
  ADMN -->|Categories quick action| ACAT
  ADMN -->|Moderation Queue quick a…| MODQ
  AENR -->|Student profile link| PROF
  AENR -->|Course link| CDET
  ACRS -->|View Public Page| CDET
  ACRT -->|User name click| AUSR
  ACRT -->|Course name click| ACRS
  ACAT -->|View Courses| ACRS
  AANA -->|Back/breadcrumb| ADMN
  AANA -->|View Users| AUSR
  AANA -->|View Courses| ACRS
  AANA -->|View Payouts| APAY

  classDef boundary stroke-dasharray: 5 5,fill:#f9f9f9,color:#999
```

### Admin Journey — Connections

| Page | Out | Targets |
|------|:---:|---------|
| AANA | 4 | ADMN, AUSR, ACRS, APAY |
| ACAT | 1 | ACRS |
| ACRS | 1 | CDET |
| ACRT | 2 | AUSR, ACRS |
| ADMN | 6 | AUSR, ACRS, AENR, ASTC, ACAT, MODQ |
| AENR | 2 | PROF, CDET |
| AMOD | 3 | AUSR, CDET, FEED |
| APAY | 2 | AUSR, AENR |
| ASES | 3 | AUSR, ACRS, AENR |
| ASTC | 4 | AUSR, AENR, ASES, CPRO |
| AUSR | 1 | PROF |
| CDET | 6 | *SBOK*, *SGUP*, *CCNT*, CPRO, *STPR*, *CBRO* |
| CPRO | 4 | CDET, *CBRO*, *IFED*, *SGUP* |
| FEED | 4 | PROF, CDET, CPRO, *IFED* |
| MODQ | 3 | FEED, PROF, ADMN |
| PROF | 4 | *SETT*, *MSGS*, CPRO, *STPR* |

*Italicized* targets are boundary pages (outside this focus area).

---

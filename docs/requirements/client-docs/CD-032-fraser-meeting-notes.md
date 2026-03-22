# Fraser's Meeting Notes (Nov 9 - Dec 24, 2025)

**Source:** Developer's (Fraser's) personal notes from meetings and observations
**Date Range:** 2025-11-09 to 2025-12-24
**Type:** Compiled Meeting Notes

---

## Nov 9
- Need PayPal eventually

## Nov 13
- Brian wants to build an algorithmic feed similar to X (Twitter) or substack.com
- Users will need to gather in common areas where interests overlap and see posts that apply to them
- MVP list:
  - Profiles
  - Payments
  - Calendar options
  - Discord-like meeting place where feeds are available

## Nov 16
- BBB integration needed

## Nov 20
- Brian wants PeerLoop MVP to have every aspect of the app, even if minimal to start with
- Brian wants PeerLoop's main focus to be education and giving to the public, with 20% of it targeted at making money for him
- Brian isn't worried about PeerLoop not going viral. It will succeed and be a good business and he'll make money.

## Nov 21
- Brian wants to charge creators:
  - A monthly fee
  - But lifetime membership for 1st 10-20 creators
  - Each course will require a fee as well
- AI told him that other edtech/course platforms have launched via Appsumo and used the influx of creator/users to bootstrap their communities

## Nov 24
- GetStream looks a little overkill for our needs (to me)
- Brian decided on maximizing Big Blue Button and GetStream to speed up development and look as professional as possible
- Brian set me straight that to be effective and spend only the money he has earmarked, then we will need to create as little new stuff as possible while at the same time making it look professional and the look and feel will be kept as we move into a completely custom product
- He wants Big Blue Button for the community aspects
- He wants Stream for the algorithmic feeds that tailor posts that are relevant (or subscribed to) to show up in user's personal feeds. A lot like Twitter and how it works
- Didn't seem to think he wanted BBB or Stream to do the video conferencing, so I will need to ask him about that. LiveKit can do so and it seems to be underlying BBB and Stream (confirm)
- He needs a payment processor. Stripe for now, but maybe Square or PayPal and others
- He needs profiles and chats, course listings and all of that which will need to be custom, I think
- We decided that I need to see how much of BBB and Stream I can leverage but still have the site look unique
- Brian is going to talk to BBB vendors and get a feel for what they can do (and by extension what he can do and how AP will fit into this mix)
- He wants to keep costs down until the site can pay for itself and then he will turn his attention to making all of it custom
- Eventually he sees I may have 3 guys working for me
- When students move through courses they gain access to BBB rooms where they pay to belong and get exclusive content, maybe video, maybe audio only, maybe just text
- Treat BBB and Stream as backend services to our completely custom Front End
- Brian wants to start out invitation-only to control how it is received, how much loading we get and to create some buzz
- Every user's feed could be algorithmically controlled (i.e. by profiles of interests) or by AI (analyzing their posts, interactions)
- He thought he would start out in the US, but now with Gabriel he wants to handle everywhere
- BBB and Stream seems to have handled the international aspects of privacy, liability, moderators and bad language, violence and sexual content
- Brian says they may start out with 1:1 tutoring, but he may want to do 1:many as well at times

## Nov 26
- The only thing Brian wants from Stream is the community feed
- It is a marketing funnel, a way to get courses in front of current students (and users who are just looking)
- I had an idea for the Feed. It normally scrolls out of view to suits its "most recent on top" paradigm. We could maintain a user feed (showing the 10 most recent users who posted) with the order being most recent on top and a count of the posts in the last 24 hours. These users could be teachers, AP, Courses, students. Any "user" can be pinned to the list as well so they can track anything new from things that interest them (profile), perceived interests and shared courses, teachers, etc. or as asked for in chats with AI. We must be very clear in privacy policy. but NOT using AI to mine their discussions with others on the site.
- The feed should also have an AI Chat component so that users can ask for what they want to see
- We will need an onboarding process to get initial interests from users.
- As time goes on, AI can be suggesting courses, teachers, students, but keep privacy in mind
- The only things Brian wants from BBB are video conferencing for at least 2, Screen sharing (a must) and maybe a whiteboard. There also needs to be video/audio recording. He also likes that BBB is distributed on the edge (like Cloudflare)
- After we discussed my concerns, we all agreed that we should start off with Big Blue Button on a managed server that Brian arranges us to rent monthly and that I should also install Stream to use its feeds to allow messages to arrive in user's feeds just as it does on Twitter
- We need a Pages.md where we assemble all the Pages the site will need. In it should also be headers and footers
  - Pages to include:
    - Purpose
    - Connected db table or query
    - Header
    - Footer
    - Connected pages
    - Features
    - Sidebar actions

## Dec 3
- Project Manager and I talked about the need for Big Blue Button in the MVP. From a business POV it is not needed. Zoom would handle it. BBB is needed to be ready to scale if the concept takes off.
- Get started on the Page Flow Diagram
- My 1st version of app (not useable) will just be scaffolding and pages with connections to related pages via a sidebar menu on each page

## Dec 4
- Brian is a little worried I can't make a calendar quickly. He suggested Calendly. I told him that having it in-app would allow 2 people trying to find an open time to automatically show common open areas

## Dec 5
- Add a Changelog page to Peer Loop

## Dec 10
- We discussed that an internal calendar that is only for members (teachers and students) should be fine, with the ability to export in ICS format to a person's own calendar like Google or Outlook or Apple via email is fine
- I told Gabriel I think the 75K for this project is ok at present but the 4 month timeframe is ambitious. More like 6 months

## Dec 15
- It looks like there are a few states that a person can be in wrt Courses and Instructors, so I will need a Role table, Courses table and Persons table and various combinations which will represent state. For example, a registered user (who has created an account) can view an instructor and their courses. Once they pay for a course they will have access to the feed for that course. Once they pay for any instructor's course, they have access to the Instructor's public feed. etc.
- Will there be a feed for the instructor? Probably should be. It's their current and former students and they need to interact
- Gabriel (manager) suggested a point system (gamification) that rewards participation and can lead to promotions for purchasing courses, deals for promoting a message from your current feed to the Peer Loop feed, etc

## Dec 22
- Brian doesn't like tutoring, but skills being taught from people just ahead of you, who by teaching, they move from 70% to 80% mastery themselves
- Gabriel said call it a platform, not an app
- I like "Personalized transfer of skills platform"
- Brian wants the platform to attract students where 50% of their learning comes from being tutored by non-experts and 50% comes from social interaction through the feeds, maybe challenges
- I told there are 3 basic pages:
  - Public-facing with predictable understandable layout, CTAs with a purpose to get people to sign up
  - User-facing pages (after they log in)
  - Admin pages just for Brian
- They each might be subdomains or folders under the main domain

## Dec 24 (Fraser's Observations and Questions)
- Moderators will come after MVP, but they are still a persona on the system
  - They will need a login and an invite from a Teacher to moderate their Teacher feed and/or their course feed
- Moderators will have typical moderator duties
- When a user signs up for a course they have only as yet seen the course cost that comes from the Teacher. The cost is an indication of value. But student-teachers in that course can also teach pieces of it and at likely cheaper rates. SO this is a weird experience for a new student. They buy the course to be taught 1:1 from the teacher, but others there in the course feed might be cheaper and according to the whole business of students learn best from recent students, yet they never see their pricings. This needs to be resolved. That is, how do new students to a course get student teachers to teach them. How do they know they are available before they buy?
- Any user can have a student role (of a course) and a guest role and if they get certified, also a student-teacher role. If they are so inclined, they can become a teacher too. SO the landing page cannot be the way Brian laid it out (separate login for each role). The many roles a user can be must be available on a common dashboard and the roles isolated as needed and interconnected as needed.
- Teachers (Course creators) need an easy way to promote their courses into certain feeds. They will need to pay for that. There will be basic promotion without paying
- There is a possibility that any user will want to create a new "sub-community" and invite certain users to it
- Not sure how students "Pass" a course
- Those that cannot pass in the allotted tutoring sessions may want more tutoring, so this suggests another revenue stream like "custom coaching or mentoring" that might be done off-site, but could be added since we have all the tools already in place
- Feeds can get very noisy with interleaved comments from many sources in the feed sorted by time. I suggest a feed "companion" that allows you to "pin" a post and its author in a UI element. The original pinned content will remain, but underneath will be the latest comment from anybody that is in that thread after that post was made. I suggest showing only the originating post and the latest thread post. No other content is saved or displayed
- We need a page flow diagram
- We need to hide features behind feature flags

---

*End of Document*

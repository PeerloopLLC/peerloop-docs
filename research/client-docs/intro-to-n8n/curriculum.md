# Intro to n8n - Curriculum

## Course Structure

**Format:** 2 live 1-on-1 sessions (90 minutes each)
**Total Duration:** 3 hours + practice workflows
**Delivery:** Interactive sessions via video call
**Pace:** Beginner-friendly with lots of hands-on building

---

## Session 1: Foundations & First Workflows (90 minutes)

### Module 1: What is n8n & Platform Setup (20 minutes)

**Learning Objectives:**
- Understand what n8n is and what problems it solves
- Know when to use n8n vs other automation tools
- Successfully set up your n8n account and navigate the interface
- Understand the difference between cloud and self-hosted options

**Topics Covered:**
- **What is Workflow Automation?**
  - Connecting apps to work together automatically
  - Common automation scenarios (notifications, data sync, triggers)
  - Time and cost savings from automation
- **n8n vs Competitors:**
  - n8n vs Zapier (open source, self-hostable, no per-workflow costs)
  - n8n vs Make/Integromat (simpler interface, better for beginners)
  - When to use n8n (flexibility, control, unlimited executions)
- **Setup Options:**
  - n8n Cloud (easiest - sign up and start, free tier available)
  - Self-hosted (more control, unlimited, requires server setup)
  - Desktop app (local development and testing)
- **Editor UI Tour:**
  - Canvas (where you build workflows)
  - Node panel (available integrations and tools)
  - Workflow controls (execute, save, settings)
  - Executions panel (see workflow runs and data)

**Hands-On Exercise:**
- Create n8n Cloud account
- Navigate the Editor UI
- Create your first blank workflow
- Explore the node panel and find popular apps

**Duration:** 20 min

---

### Module 2: Core Concepts & Understanding Data (25 minutes)

**Learning Objectives:**
- Understand what nodes are and how they connect
- Learn how data flows through workflows
- Read and interpret node output data
- Understand the difference between triggers and actions

**Topics Covered:**
- **Nodes Explained:**
  - What is a node? (a single step in your workflow)
  - Types of nodes: Triggers, Actions, Logic, Helpers
  - How nodes connect (data flows from one to the next)
  - Node naming and organization
- **Triggers vs Actions:**
  - Triggers (what starts your workflow)
  - Actions (what happens after the trigger)
  - Common trigger types (schedule, webhook, app event, manual)
- **Data Structure in n8n:**
  - How n8n passes data between nodes (JSON format)
  - Reading node output (the data panel)
  - Understanding items (each piece of data processed)
  - Using data from previous nodes
- **Workflow Execution:**
  - Manual execution (test button)
  - Automatic execution (when workflow is active)
  - Execution history and logs
  - Success vs error states

**Hands-On Exercise:**
- Add a Manual Trigger node to your workflow
- Add a Set node to create sample data
- Execute the workflow and examine the output
- See how data appears in each node
- Practice reading the JSON data structure

**Duration:** 25 min

---

### Module 3: Building Your First Workflows (25 minutes)

**Learning Objectives:**
- Build a complete 2-node workflow from scratch
- Understand how to configure node settings
- Create a useful automation you can use immediately
- Save and activate your first workflow

**Topics Covered:**
- **Simple Two-Node Workflow:**
  - Schedule Trigger (run workflow daily/weekly/hourly)
  - Action node (send message, create item, etc.)
  - Configuring node parameters
  - Setting schedule intervals
- **Workflow Example: Daily Slack Reminder**
  - Schedule trigger (every day at 9am)
  - Slack node (send message to channel)
  - Setting up the connection
  - Testing and activating
- **Saving & Activating:**
  - Saving workflows (naming conventions)
  - Activating vs deactivating workflows
  - Workflow settings (error handling, timezone)
  - Organizing workflows in folders

**Hands-On Exercise:**
- Build "Daily Slack Reminder" workflow
- Configure schedule for specific time
- Set up Slack node to send message
- Test the workflow manually
- Activate the workflow to run automatically
- Verify it appears in active workflows list

**Duration:** 25 min

---

### Module 4: Triggers & Data Flow (20 minutes)

**Learning Objectives:**
- Master different types of triggers
- Understand when to use each trigger type
- Build workflows that respond to external events
- Work with real data from app triggers

**Topics Covered:**
- **Trigger Types:**
  - **Schedule Trigger** - Time-based automations
  - **Webhook Trigger** - Receive data from external sources
  - **App Triggers** - React to events in apps (new email, form submission, etc.)
  - **Manual Trigger** - Run on-demand for testing
- **Working with App Triggers:**
  - Gmail Trigger (when new email arrives)
  - Google Forms Trigger (when form submitted)
  - Slack Trigger (when message posted)
  - Calendar Trigger (when event created)
- **Data from Triggers:**
  - Capturing incoming data
  - Using trigger data in subsequent nodes
  - Filtering and processing trigger data
  - Understanding trigger data structure

**Hands-On Exercise:**
- Build "New Email Notification" workflow
- Set up Gmail Trigger to watch for emails
- Add Slack node to notify about new emails
- Test with real email
- See how email data flows to Slack
- Customize the notification message using email data

**Duration:** 20 min

---

### Session 1 Wrap-Up (5 minutes)

**Review:**
- n8n setup and interface navigation ✓
- Core concepts (nodes, triggers, actions, data) ✓
- Built first working workflows ✓
- Understanding different trigger types ✓

**Practice Between Sessions:**
Build these simple workflows:
- Weekly reminder workflow (Schedule → Slack/Email)
- Gmail watcher (Gmail Trigger → your action of choice)
- Experiment with different triggers and actions
- Explore the node panel and discover new nodes

**Prepare for Session 2:**
- Have your Google account ready for Sheets integration
- Think about a repetitive task you want to automate
- Come with questions from your practice workflows

---

## Session 2: Advanced Workflows & Real Projects (90 minutes)

### Module 5: App Integrations & Credentials (20 minutes)

**Learning Objectives:**
- Connect popular apps to n8n securely
- Understand OAuth vs API key authentication
- Add and manage credentials for multiple services
- Build workflows using multiple app integrations

**Topics Covered:**
- **Popular Integrations:**
  - Google Workspace (Gmail, Sheets, Calendar, Drive)
  - Communication (Slack, Discord, Microsoft Teams)
  - Databases (Notion, Airtable, Google Sheets)
  - Forms (Google Forms, Typeform)
  - Other (Trello, Asana, GitHub, etc.)
- **Credentials & Security:**
  - OAuth authentication (secure app connections)
  - API keys and tokens (when OAuth isn't available)
  - Storing credentials safely in n8n
  - Reusing credentials across workflows
  - Credential permissions and scopes
- **Google Sheets Integration:**
  - Reading data from sheets
  - Appending rows to sheets
  - Updating existing rows
  - Creating new sheets
  - Common use cases (data logging, reporting)

**Hands-On Exercise:**
- Add Google Sheets credentials to n8n
- Build "Data Logger" workflow
- Schedule Trigger (daily) → Get data → Append to Google Sheet
- Test adding rows to your sheet
- Verify data appears correctly
- Add Slack credentials for next exercise

**Duration:** 20 min

---

### Module 6: Conditional Logic & Multi-Step Workflows (25 minutes)

**Learning Objectives:**
- Add conditional logic to workflows (IF statements)
- Build multi-step workflows with 5+ nodes
- Filter and process data between steps
- Create sophisticated automations with branching paths

**Topics Covered:**
- **IF Node (Conditional Logic):**
  - When to use IF nodes (filter data, make decisions)
  - Setting conditions (equals, contains, greater than, etc.)
  - True vs False branches
  - Multiple conditions (AND/OR logic)
- **Switch Node:**
  - When to use Switch vs IF
  - Multiple routing paths
  - Default fallback path
- **Multi-Step Workflow Design:**
  - Breaking complex automations into steps
  - Planning workflow logic before building
  - Processing data through multiple nodes
  - Combining app actions with logic
- **Data Transformation:**
  - Set node (modify/add data fields)
  - Filter node (remove unwanted items)
  - Item Lists node (work with arrays)
  - Function node basics (simple JavaScript if needed)

**Hands-On Exercise:**
- Build "Smart Email Router" workflow
- Gmail Trigger → IF node (check subject/sender)
- If important: Add to priority sheet + Send Slack notification
- If not important: Add to regular sheet only
- Test with different email scenarios
- See data flow through different paths

**Duration:** 25 min

---

### Module 7: Testing, Debugging & Templates (20 minutes)

**Learning Objectives:**
- Test workflows effectively before activating
- Debug common workflow errors
- Read execution logs to find problems
- Use n8n's template library to speed up automation

**Topics Covered:**
- **Testing Workflows:**
  - Manual execution vs automatic
  - Using test data vs real data
  - Checking each node's output
  - Verifying the final result
  - Testing all conditional branches
- **Common Errors:**
  - Credential issues (expired, wrong permissions)
  - Missing data (node returns empty)
  - Configuration errors (wrong field mapping)
  - API rate limits and quotas
  - Timeout errors
- **Debugging Strategies:**
  - Reading error messages carefully
  - Checking execution data at each step
  - Isolating the problem node
  - Testing nodes individually
  - Using sticky notes for documentation
- **n8n Template Library:**
  - Browsing available templates
  - Importing templates to your account
  - Customizing templates for your needs
  - Popular beginner-friendly templates
  - Using templates as learning tools

**Hands-On Exercise:**
- Intentionally break a workflow and fix it
- Practice reading execution logs
- Import a template from n8n library
- Customize template for your use case
- Learn to troubleshoot credential issues

**Duration:** 20 min

---

### Module 8: Final Project - Automated Form Response Handler (25 minutes)

**Capstone Project:**
Build a complete, production-ready automation that handles form submissions with notifications and confirmations.

**Project: Automated Form Response Handler**

**What it does:**
1. Receives form submission (Google Forms trigger)
2. Filters responses based on criteria (IF node - check priority field)
3. Adds all data to Google Sheets (append row)
4. Sends Slack notification to team (Slack message)
5. Sends confirmation email to submitter (Gmail/Send Email node)

**Build Steps:**

**Step 1: Set Up Google Form**
- Create a simple Google Form (name, email, message, priority level)
- Get form trigger ready in n8n

**Step 2: Build the Workflow**
- Add Google Forms Trigger node
- Configure to watch your form
- Test by submitting a form entry

**Step 3: Add Conditional Logic**
- Add IF node to check priority field
- Create two paths: High Priority vs Normal

**Step 4: Add to Google Sheets**
- Add Google Sheets node (both paths)
- Configure to append row with form data
- Map form fields to sheet columns

**Step 5: Slack Notification (High Priority Path)**
- Add Slack node to high priority path
- Configure message with form details
- Include submitter name and message
- Test notification appears in Slack

**Step 6: Confirmation Email**
- Add Send Email node (or Gmail node)
- Use submitter's email from form data
- Craft friendly confirmation message
- Personalize with their name
- Test email delivery

**Step 7: Test Complete Flow**
- Submit test forms with different priorities
- Verify high priority → Slack notification
- Verify all submissions → Google Sheets
- Verify all submissions → Confirmation email
- Check data accuracy in each step

**Step 8: Activate & Monitor**
- Activate the workflow
- Submit real form entry
- Verify everything works end-to-end
- Check execution logs

**Key Learning:**
- Building multi-step, real-world automations
- Combining triggers, logic, and multiple apps
- Testing complex workflows thoroughly
- Creating automations you'll actually use
- Understanding data flow through 5+ nodes

**Duration:** 25 min

---

### Session 2 Wrap-Up & Next Steps (5 minutes)

**What You've Mastered:**
- n8n platform and interface ✓
- Building workflows from scratch ✓
- Multiple trigger types ✓
- App integrations (Sheets, Slack, Gmail, Forms) ✓
- Conditional logic and branching ✓
- Multi-step workflows ✓
- Testing and debugging ✓
- Template library usage ✓
- Complete production automation ✓

**Your Accomplishments:**
- Built multiple working workflows
- Created automated form response handler
- Connected real apps and services
- Saved hours of manual work

**Next Steps:**
- **Automate Your Work** - Identify repetitive tasks and automate them
- **Explore More Integrations** - Try n8n's 400+ app nodes
- **Advanced Topics** - Webhooks, APIs, custom code, AI integrations
- **Join Communities** - n8n community forums, PeerLoop community
- **Become a Student-Teacher** - Apply to teach Intro to n8n and earn 70% per student
- **Build Your Automation Library** - Create reusable workflows for common tasks

**Resources:**
- n8n official documentation (docs.n8n.io)
- n8n workflow templates library
- n8n community forum
- PeerLoop community
- Your instructor for ongoing questions

**Certification:**
Upon completion, you'll receive your certificate and be eligible to apply as a student-teacher for Intro to n8n!

---

## Learning Methodology

**Live 1-on-1 Format:**
- Personalized attention to your specific automation needs
- Ask questions anytime, get immediate answers
- Work at your own pace with expert guidance
- Real-time troubleshooting when issues arise

**Hands-On Building:**
- 75% practical building
- 25% instruction and demonstration
- Build real automations you'll actually use
- No passive watching - you build everything

**Progressive Complexity:**
- Start with simple 2-node workflows
- Build to complex 5+ node automations
- Add features incrementally
- Learn by doing, not just watching

**Real-World Focus:**
- Every workflow solves a real problem
- Use actual apps you work with daily
- Build automations ready for production
- No toy examples or demos

---

## Prerequisites Checklist

Before Session 1, ensure you have:

✓ **Computer** with modern web browser (Chrome, Firefox, Safari, Edge)
✓ **Google Account** (free Gmail account for Sheets, Forms, Gmail integration)
✓ **Slack Account** (free tier is fine - join a workspace or create one)
✓ **n8n Account** (sign up at n8n.io - free tier available)
✓ **Internet Connection** (stable connection for live sessions and testing)
✓ **Enthusiasm** to automate and save time!

**Helpful to have:**
✓ A repetitive task you want to automate
✓ Apps you currently use (Notion, Airtable, Trello, etc.)
✓ Ideas for workflows you want to build

**Not Required:**
✗ No coding experience
✗ No technical background
✗ No prior automation experience
✗ No server setup or hosting

---

## What Students Say

*"I was manually copying form responses to a spreadsheet and sending emails - it took me 30 minutes every day. After this course, I built a workflow that does it all automatically. I literally bought back 15 hours a month."* - Jessica, Small Business Owner

*"Guy made n8n approachable. I thought automation was for developers, but now I'm building workflows for everything - meeting reminders, lead capture, content organization. Game changer."* - Marcus, Marketing Manager

*"The form response handler project is brilliant. I use variations of it for customer inquiries, event registrations, and feedback forms. One course, endless applications."* - Sarah, Operations Manager

*"I've tried Zapier and Make before but n8n clicked for me after this course. The visual interface plus Guy's teaching made everything clear. Now I'm automating my entire business."* - Kevin, Entrepreneur

*"Best $249 I've spent on productivity. I save more time in a week than the course cost. Already built 10+ workflows and still finding new things to automate."* - Lisa, Freelance Consultant

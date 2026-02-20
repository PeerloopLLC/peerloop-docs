# Intro to Claude Code - Curriculum

## Course Structure

**Format:** 2 live 1-on-1 sessions (90 minutes each)
**Total Duration:** 3 hours + homework
**Delivery:** Interactive sessions via video call
**Pace:** Beginner-friendly with hands-on exercises

---

## Session 1: Foundation & Core Concepts (90 minutes)

### Module 1: Introduction & Setup (20 minutes)

**Learning Objectives:**
- Understand what Claude Code is and how it differs from other AI tools
- Successfully install Claude Code on your system
- Authenticate and start your first session

**Topics Covered:**
- What is Claude Code? (Terminal-based AI coding assistant)
- Why Claude Code vs Cursor, Copilot, Windsurf
- Pricing plans (Pro vs Max)
- Installation via npm
- Authentication workflow
- Starting your first session with `claude`
- VS Code integration and extension

**Hands-On Exercise:**
- Install Claude Code
- Authenticate with your account
- Start a session in a test project
- Ask Claude to analyze the project structure

**Duration:** 20 min

---

### Module 2: CLAUDE.md Files & Project Memory (20 minutes)

**Learning Objectives:**
- Initialize project context with `/init`
- Understand how Claude uses CLAUDE.md for guidance
- Add and manage project memory

**Topics Covered:**
- The `/init` command - scanning your codebase
- What goes into CLAUDE.md (architecture, structure, conventions)
- Project vs Local vs Global memory
- Adding memories with `#` symbol
- The `/memory` command
- Keeping CLAUDE.md updated

**Hands-On Exercise:**
- Run `/init` on a sample project
- Examine the generated CLAUDE.md
- Manually add a memory about file structure
- Add a memory using `#` in the chat

**Duration:** 20 min

---

### Module 3: Understanding Context (25 minutes)

**Learning Objectives:**
- Master context management for accurate AI responses
- Add files and images as context
- Keep context clean and focused

**Topics Covered:**
- What is context and why it matters
- Adding files with `@` symbol
- Adding images as context (drag & drop)
- Active file context (opening files)
- Multiple file context
- Context bloat problems
- Managing context: `/clear`, `/compact`, double-escape
- The `/exit` and `/resume` commands
- Context window limits (200K tokens)

**Hands-On Exercise:**
- Add a specific file as context to make targeted changes
- Use an image as context to create a styled component
- Practice clearing context and starting fresh
- Learn to resume previous sessions

**Duration:** 25 min

---

### Module 4: Tools & Permissions (20 minutes)

**Learning Objectives:**
- Understand Claude's built-in tools
- Configure permissions for smoother workflows
- Control what Claude can access

**Topics Covered:**
- Built-in tools: read, edit, bash, write, etc.
- Permission prompts and approval workflow
- settings.local.json configuration
- Adding allowed commands
- Alt+M shortcut for accept edits mode
- Tool usage patterns

**Hands-On Exercise:**
- Make code edits (trigger edit tool)
- Run a bash command (trigger bash tool)
- Configure permissions to auto-allow certain commands
- Toggle accept edits mode

**Duration:** 20 min

---

### Session 1 Wrap-Up (5 minutes)

**Review:**
- Installation and authentication ✓
- Project context with CLAUDE.md ✓
- Context management strategies ✓
- Tools and permissions ✓

**Homework Assignment:**
Build a simple project using Claude Code:
- Initialize a new project with `/init`
- Create 2-3 components or functions
- Practice adding context strategically
- Keep notes on what works well

**Prepare for Session 2:**
- Come with questions from homework
- Think about a project idea to build
- Review your CLAUDE.md file

---

## Session 2: Advanced Techniques & Workflows (90 minutes)

### Module 5: Planning & Thinking Modes (30 minutes)

**Learning Objectives:**
- Use Plan Mode for complex, multi-file tasks
- Activate thinking modes for better reasoning
- Know when to use each mode

**Topics Covered:**
- **Plan Mode** (Alt+M twice)
  - When to use planning
  - Wide-scope vs narrow-scope tasks
  - Reviewing and approving plans
  - Auto-accept edits in plan mode
- **Thinking Modes**
  - "think" - basic reasoning
  - "think hard" - medium complexity
  - "think harder" - advanced reasoning
  - "ultra think" - maximum reasoning
  - Token consumption trade-offs
  - When thinking helps vs hurts

**Hands-On Exercise:**
- Use Plan Mode to create a multi-component feature
- Trigger thinking mode for a logic problem
- Compare results with and without planning

**Duration:** 30 min

---

### Module 6: Slash Commands & Customization (25 minutes)

**Learning Objectives:**
- Master essential built-in commands
- Create custom commands for repeated workflows
- Build a command library

**Topics Covered:**
- **Built-in Commands**
  - `/` to see all commands
  - `/clear`, `/compact`, `/exit`, `/resume`
  - `/memory`, `/init`, `/model`
  - `/terminal setup`
  - `/add dir` for multi-repo development
- **Custom Commands**
  - Creating `.claude/commands/` directory
  - Writing command markdown files
  - Using command arguments with `$arguments`
  - Front matter (description, argument hint)
  - Parsing multiple arguments
  - Restarting sessions to load commands

**Hands-On Exercise:**
- Create a custom command for your workflow
- Add command arguments for flexibility
- Test the command with different inputs
- Build a small command library

**Duration:** 25 min

---

### Module 7: Real-World Project Workflow (30 minutes)

**Capstone Project:**
Build a complete working project from scratch, applying everything learned:

**Project Options:**
1. Personal webpage with multiple pages and components
2. Task automation script for your daily workflow
3. Simple web app with UI components
4. Your own idea (approved by instructor)

**Workflow Steps:**
1. Initialize project with `/init`
2. Create CLAUDE.md with project structure
3. Use Plan Mode to outline the build
4. Implement features iteratively
5. Manage context strategically
6. Use custom commands where helpful
7. Review and test as you go

**Key Learning:**
- When to use AI vs when to code manually
- How to stay in control and avoid vibe coding
- Iterative development with Claude
- Debugging and fixing AI-generated code
- Best practices for maintainable projects

**Duration:** 30 min

---

### Session 2 Wrap-Up & Next Steps (5 minutes)

**What You've Mastered:**
- Claude Code installation and setup ✓
- Project context and memory management ✓
- Context optimization strategies ✓
- Tools, permissions, and workflows ✓
- Planning and thinking modes ✓
- Custom commands and automation ✓
- Real-world project development ✓

**Next Steps:**
- **Keep Building** - Apply skills to your own projects
- **Advanced Topics** - MCP servers, subagents, GitHub integration (future courses)
- **Join the Community** - Share projects, get feedback
- **Become a Student-Teacher** - Apply to teach and earn 70% per student

**Resources:**
- Claude Code official docs
- PeerLoop community forum
- Your instructor for ongoing questions

**Certification:**
Upon completion, you'll receive your certificate and be eligible to apply as a student-teacher!

---

## Learning Methodology

**Live 1-on-1 Format:**
- Personalized attention to your learning pace
- Ask questions anytime
- Work on projects relevant to you
- Get immediate feedback

**Hands-On Approach:**
- 60% practical exercises
- 40% instruction and demonstration
- Build real projects, not just demos

**Iterative Learning:**
- Start simple, build complexity
- Review and reinforce concepts
- Apply immediately in exercises

**Stay in Control:**
- Understand what Claude does, why it works
- Learn to review AI-generated code
- Build skills for independent work

---

## Prerequisites Checklist

Before Session 1, ensure you have:

✓ **Computer** with terminal access (Windows 10+ or macOS 10.15+)
✓ **Claude Account** (Pro $17/month or Max plan)
✓ **Node.js 18+** installed (for npm installation)
✓ **Stable internet connection** for live sessions
✓ **Code editor** installed (VS Code recommended but not required)
✓ **Enthusiasm** to learn and build!

**Not Required:**
✗ No coding experience
✗ No command-line knowledge
✗ No computer science background

---

## What Students Say

*"I went from knowing nothing about coding to building my first web app in just two sessions. Guy's teaching style makes everything click."* - Sarah, Course Graduate

*"The hands-on approach is perfect. You're not just watching - you're building real things from day one."* - Marcus, Now a Student-Teacher

*"Best investment I made this year. Now I can prototype my startup ideas without hiring a developer."* - Jessica, Entrepreneur

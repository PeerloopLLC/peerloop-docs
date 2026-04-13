# Browser Testing Reference

Comparison of browser testing approaches available in the Peerloop development environment. For test commands, see [CLI-TESTING.md](CLI-TESTING.md). For PLATO scenario details, see the [PLATO architecture doc](../as-designed/plato.md).

---

## Testing Approaches

| Approach | Tool | Purpose |
|----------|------|---------|
| **Unit/Integration** | Vitest + PLATO API runner | API-level validation, DB state verification |
| **E2E Scripted** | Playwright | Repeatable multi-user browser flows, CI/CD |
| **E2E Exploratory** | Chrome MCP (Claude in Chrome) | Ad-hoc visual QA, walkthroughs, demos |
| **Manual Walkthrough** | PLATO BrowserIntents | Human-guided structured walkthroughs using API-seeded state |

---

## Chrome MCP vs Playwright

### When to Use Each

| Scenario | Use |
|----------|-----|
| Regression prevention in CI | Playwright |
| Multi-browser compatibility | Playwright |
| Multi-user interaction (teacher + student) | Playwright (parallel contexts) |
| Repeatable assertion-based tests | Playwright |
| Ad-hoc "does this page look right?" checks | Chrome MCP |
| Exploratory QA on new features | Chrome MCP |
| GIF/demo generation for client review | Chrome MCP |
| One-off state inspection with specific seed data | Chrome MCP |
| Navigating a page Claude has never seen before | Chrome MCP |

### Speed

| Dimension | Chrome MCP | Playwright |
|-----------|------------|------------|
| **Startup** | Instant — attaches to already-running Chrome | Cold start — launches browser process per test |
| **Per-action** | Slower — each action is a round-trip through MCP protocol + Claude reasoning | Fast — scripted actions execute sequentially, no AI deliberation |
| **Full suite** | Minutes (AI reasoning between each step) | Seconds (deterministic script execution) |

Playwright is dramatically faster for repeatable test runs. Chrome MCP is not viable as a CI test runner.

### Flexibility

| Dimension | Chrome MCP | Playwright |
|-----------|------------|------------|
| **Adaptability** | High — Claude sees the page and recovers from unexpected states (wrong modal, skeleton loading) | Low — brittle selectors; UI changes break tests |
| **Exploratory** | Excellent — can improvise, notice anomalies, report issues | None — only checks what was coded |
| **Judgment** | Can make calls like "this looks wrong" | Binary pass/fail on assertions |
| **New pages** | Can navigate unseen pages | Requires someone to write the test first |

### Restrictions

| Concern | Chrome MCP | Playwright |
|---------|------------|------------|
| **Determinism** | Non-deterministic — Claude may take different paths each run | Fully deterministic |
| **CI/CD** | Cannot run in CI (needs live Chrome + extension) | Built for CI |
| **Assertions** | Informal — Claude "sees" the page, no structured assertions | Structured `expect()` with timeouts, retries |
| **Parallelism** | Single browser, one tab group at a time | Parallel workers, multiple contexts |
| **Cost** | Burns API tokens on every action + screenshot | Free after setup |
| **Reproducibility** | Hard to reproduce — depends on Claude's decisions | Exact replay |
| **Dialogs/alerts** | Can get stuck (blocks extension) | Handles natively |

### Coverage Quadrants

```
              Scripted ────────────────── Exploratory
                 │                             │
  Repeatable     │  Playwright                 │  (gap)
                 │  PLATO API tests            │
                 │                             │
  One-shot       │  PLATO BrowserIntents       │  Chrome MCP
                 │  (manual, structured)       │
                 │                             │
```

Chrome MCP fills the **one-shot exploratory** quadrant — the work that was previously "someone manually clicks through the app."

---

## Chrome MCP Setup

**Prerequisites:**
- Chrome browser running
- Claude in Chrome extension installed and active
- Claude Code session with `--add-dir` for the code repo

**Typical workflow:**
1. Seed the local DB: `cd ../Peerloop && npm run db:setup:local:dev`
2. Start dev server: `cd ../Peerloop && nohup npm run dev > /tmp/peerloop-dev.log 2>&1 &`
3. Use Chrome MCP tools to navigate and interact

**Dev server note:** When launching the dev server from Claude Code for browser testing, use `nohup` to prevent the server from dying when background task runners clean up. The standard `npm run dev` via Bash tool's `run_in_background` may terminate unexpectedly.

**Key tools:**
| Tool | Purpose |
|------|---------|
| `tabs_context_mcp` | Get current tab info (call first) |
| `navigate` | Go to URL |
| `read_page` | Get accessibility tree (element refs) |
| `computer` | Click, type, screenshot, scroll |
| `form_input` | Fill form fields by ref |
| `gif_creator` | Record and export walkthrough GIFs |
| `read_console_messages` | Check browser console for errors |

**GIF recording pattern:**
```
gif_creator(start_recording) → screenshot (initial frame)
→ navigate/click/interact...
→ screenshot (final frame) → gif_creator(stop_recording)
→ gif_creator(export, filename, download: true)
```

### Known Limitations

| Limitation | Detail |
|------------|--------|
| **Screenshot dimensions** | Chrome MCP screenshots are captured at the browser viewport size (typically 1200x~900). Elements below the fold require scrolling. Zoom captures are limited to the visible viewport region. |
| **Image dimensions in tool results** | Screenshots returned via `computer(screenshot)` are JPEG-compressed at viewport resolution. For inspecting small UI elements (icons, badges), use `computer(zoom)` with a `region` to get a closer view. |
| **Scroll stuck on some layouts** | Pages with `overflow: hidden` on intermediate containers or sticky sidebars can prevent scroll from reaching all content. Use JS injection (`window.scrollTo`) or `scroll_to` with a `ref_id` as fallback. |
| **Dialogs block everything** | JavaScript alerts, confirms, and prompts block the extension. Avoid triggering them. If stuck, user must dismiss manually in Chrome. |
| **No incognito/multi-profile** | Chrome MCP operates in the active Chrome profile. Cannot test as different users simultaneously — must log out and log in between personas. |

---

## PLATO BrowserIntents

PLATO scenarios can define `BrowserIntent` entries for structured manual walkthroughs. These describe what to click and verify in human-readable terms, using API-seeded DB state as the starting point.

**Bridge pattern:** Run the API portion to seed the DB, then walk through the browser portion:
```bash
# API-run seeds exact state, saves snapshot
npm run plato:restore -- flywheel-to-enrollment
# Restore snapshot into local D1
npm run plato:snapshot:restore -- flywheel-to-enrollment
# Dev server now serves the API-produced state
```

BrowserIntents are a natural fit for Chrome MCP execution — Claude can interpret the intent descriptions and execute them in the browser, combining PLATO's structured approach with MCP's adaptive navigation.

**Snapshot strategy for browser-completable walkthroughs:** When a PLATO scenario ends with steps that are fully completable in the browser (e.g., accepting a session invite), stop the API-run *before* the accept step and save the snapshot. The browser-run then picks up from the pending state (e.g., invite visible, waiting for user action). This gives the browser walkthrough a meaningful interaction to perform rather than just verifying post-fact state. Convention: name these `{scenario}-to-{stoppoint}` (e.g., `flywheel-to-enrollment`).

---

## Future Possibility

Chrome MCP could be used to **generate** Playwright tests: Claude walks through a flow exploratorily, learns the selectors and assertions needed, then produces the deterministic Playwright script. This would fill the "repeatable + exploratory" gap in the coverage quadrants.

---

## First Browser Walkthrough (Conv 094)

The Chrome MCP approach was validated in Conv 094 with a login-browse-detail walkthrough:

| Step | Route | Observation |
|------|-------|-------------|
| Visitor dashboard | `/` | Sidebar: My Feeds, Discover, Create account / Log in |
| Login | Modal | Sign in as Sarah Miller |
| Authenticated dashboard | `/` | Full sidebar with role-appropriate nav items |
| Discover Courses | `/discover/courses` | 6 courses, interest carousel, role tabs, topic filters |
| Course Detail | `/discover/course/ai-tools-overview` | Hero, 3 role badges, tab bar, 100% completion, module accordion |

**Learnings:**
- Dev server stability: use `nohup` for persistence during browser sessions
- `form_input` + `ref` from `read_page` is more reliable than coordinate-based clicks for form fields
- GIF export works well for capturing multi-step flows (23 frames, 6.8MB)

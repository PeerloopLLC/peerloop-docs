---
name: Test file import hygiene
description: Clean up starter-kit imports in test files before moving on — don't leave unused imports
type: feedback
---

When writing new test files, do an import cleanup pass before considering the file done. Test starter templates often include imports like `within`, `waitFor`, `describe`, `userEvent` that may not all be used.

**Why:** Session 386 found 9 unused imports across test files written in earlier sessions. These generate Astro hints and add noise to codecheck output. Cleaning them up after the fact is more work than catching them at write time.

**How to apply:**
- After writing a test file, scan imports for anything unused
- Remove unused testing-library imports (`within`, `waitFor`, `act`, etc.)
- Remove unused vitest imports (`describe`, `beforeAll`, `afterAll`, etc.)
- Remove unused `userEvent.setup()` calls where only `screen` queries are used
- Documented in BEST-PRACTICES.md §8 and CLI-TESTING.md "Import & Fixture Hygiene"

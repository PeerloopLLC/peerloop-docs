# CLI Miscellaneous Commands

Installation, setup, and environment commands. For npm script reference, see [CLI-QUICKREF.md](CLI-QUICKREF.md).

---

## Dual-Repo Setup

Peerloop uses two sibling repos: `peerloop-docs` (documentation + Claude Code home) and `Peerloop` (application code).

### First-Time Setup

```bash
# Clone both repos into the same parent directory
cd ~/projects
git clone https://github.com/PeerloopLLC/peerloop-docs.git
git clone https://github.com/PeerloopLLC/Peerloop.git

# Create symlinks in code repo
cd Peerloop
bash scripts/link-docs.sh

# Verify symlinks
ls -la docs research
```

### Launch Claude Code

```bash
cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop
```

### What link-docs.sh Creates

| Symlink | Target | Purpose |
|---------|--------|---------|
| `Peerloop/docs` | `../peerloop-docs/docs` | Build scripts reference `docs/` |
| `Peerloop/research` | `../peerloop-docs/research` | Build scripts reference `research/` |

Both symlinks are gitignored. Run `link-docs.sh` once per machine after cloning.

---

## Environment Validation

### Pre-flight Check

```bash
./scripts/check-env.sh
```

**What it checks:**
- Node.js version matches `.nvmrc`
- npm version meets minimum (>=10.0.0)
- Wrangler CLI installed (global)
- Stripe CLI installed and authenticated
- `.dev.vars` file exists
- `.env` symlink exists
- `node_modules` in sync with `package-lock.json`

**When to run:**
- After cloning repository
- After `git pull` (detects if `npm install` needed)
- When switching between development machines
- Before starting development session

See [tech-015-dev-setup.md](../tech/tech-015-dev-setup.md) for full setup documentation.

---

## Node.js Version Management

### Required Version

```
Node.js 22.19.0
```

Enforced via `.nvmrc` and `engines` field in `package.json`.

---

### Switch to Correct Node Version

```bash
nvm use
```

**What it does:**
- Reads version from `.nvmrc`
- Switches to Node.js 22.19.0

**When to use:**
- After cloning the repository
- If version check fails
- When switching between projects

**If version not installed:**
```bash
nvm install 22.19.0
nvm use
```

---

### Check Current Version

```bash
node --version
```

Expected output: `v22.19.0`

---

## Installation

### Install Dependencies

```bash
npm install
```

**What it does:**
- Installs all dependencies from `package-lock.json`
- Creates `node_modules/` directory

**Version enforcement:**
- `engines` field in `package.json` warns if wrong Node/npm version
- Run `./scripts/check-env.sh` to validate full environment

**If install fails due to version:**
```bash
nvm use          # Switch to correct version
npm install      # Retry
```

---

### Clean Install

```bash
rm -rf node_modules package-lock.json
npm install
```

**When to use:**
- Dependency resolution issues
- Corrupted node_modules
- After major dependency updates

---

## Environment Setup

### Environment Files

Peerloop uses two environment file conventions:
- **`.dev.vars`** - Wrangler/Cloudflare convention (source of truth)
- **`.env`** - Symlink to `.dev.vars` for dotenv package compatibility

**Create symlink (if missing):**
```bash
ln -s .dev.vars .env
```

### Required Environment Variables

In `.dev.vars` file (not committed to git):

```bash
# Authentication
JWT_SECRET=your-secret-key-here

# OAuth (optional for local dev)
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=

# Cloudflare (for deployment)
CLOUDFLARE_ACCOUNT_ID=
CLOUDFLARE_API_TOKEN=
```

---

### Local Development Setup

1. Clone repository
2. Run environment check: `./scripts/check-env.sh`
3. Fix any issues reported by check
4. Switch Node version: `nvm use`
5. Install dependencies: `npm install`
6. Create `.dev.vars` with required variables
7. Create `.env` symlink: `ln -s .dev.vars .env`
8. Start dev server: `npm run dev`

See [tech-015-dev-setup.md](../tech/tech-015-dev-setup.md) for detailed setup guide.

---

## Git Commands (Common Patterns)

### Check Status

```bash
git status
```

### Stage and Commit

```bash
git add .
git commit -m "Message"
```

### Push to Remote

```bash
git push origin <branch-name>
```

### Create New Branch

```bash
git checkout -b feature/my-feature
```

---

## Related Documentation

- [CLI-QUICKREF.md](CLI-QUICKREF.md) - Quick command reference (all npm scripts)
- [CLI-REFERENCE.md](CLI-REFERENCE.md) - Detailed npm script documentation
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands
- [tech-015-dev-setup.md](../tech/tech-015-dev-setup.md) - Development environment setup

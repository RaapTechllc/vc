# Project Structure Guide for VC

This guide shows how to organize multiple projects using VC as your AI-orchestrated development workflow.

## Overview

VC is an **orchestration tool**, not a project itself. Think of it like `make`, `docker`, or `terraform` - it manages your development workflow across any project.

## Recommended Setup

### Option 1: VC as a Standalone Tool (Recommended)

Install VC once, use it everywhere:

```
~/tools/
  └── vc/                          # VC orchestration tool (this repo)
      ├── vc.exe                   # Built binary
      ├── .env                     # Your OAuth token
      └── ...

~/projects/
  ├── my-web-app/                  # Project 1
  │   ├── .beads/
  │   │   ├── beads.db            # Project issue tracker
  │   │   └── issues.jsonl        # Source of truth (git tracked)
  │   ├── docs/                    # Project specifications
  │   │   ├── requirements.md     # What you want built
  │   │   ├── architecture.md     # System design
  │   │   └── api-spec.md         # API documentation
  │   ├── src/                     # Source code (built by VC)
  │   ├── tests/                   # Tests (built by VC)
  │   └── README.md
  │
  ├── mobile-app/                  # Project 2
  │   ├── .beads/
  │   │   ├── beads.db
  │   │   └── issues.jsonl
  │   ├── docs/
  │   │   ├── features.md         # Feature specifications
  │   │   └── design-system.md    # UI/UX guidelines
  │   ├── app/                     # App code
  │   └── README.md
  │
  └── data-pipeline/               # Project 3
      ├── .beads/
      │   ├── beads.db
      │   └── issues.jsonl
      ├── docs/
      │   ├── data-flow.md        # Pipeline architecture
      │   └── schemas.md          # Data schemas
      ├── pipelines/               # Pipeline code
      └── README.md
```

**Usage:**
```bash
# Add VC to your PATH
export PATH="$HOME/tools/vc:$PATH"

# Work on any project
cd ~/projects/my-web-app
vc ready                          # Check ready work
vc repl                           # Start interactive session
vc execute                        # Run the executor loop
```

### Option 2: VC Per Project (Alternative)

If projects need different VC versions or configurations:

```
~/projects/
  ├── my-web-app/
  │   ├── tools/
  │   │   └── vc/                 # VC copy for this project
  │   ├── .beads/
  │   ├── docs/
  │   └── src/
  │
  └── mobile-app/
      ├── tools/
      │   └── vc/                 # Separate VC copy
      ├── .beads/
      ├── docs/
      └── app/
```

## Where to Put Project Documents

### 1. Specifications Go in `docs/`

VC reads your specifications to create issues. Recommended structure:

```
docs/
├── requirements.md              # What you want built
├── architecture.md              # System design/structure
├── features/                    # Feature specifications
│   ├── user-auth.md
│   ├── payment-processing.md
│   └── notifications.md
├── api/                         # API specifications
│   ├── endpoints.md
│   └── schemas.json
└── design/                      # UI/UX specifications
    ├── wireframes/
    └── style-guide.md
```

### 2. Issues Go in `.beads/`

VC tracks work as issues in Beads:

```
.beads/
├── beads.db                     # SQLite database (gitignored)
├── issues.jsonl                 # Source of truth (git tracked)
└── config.yaml                  # Project-specific config
```

**Creating issues from specs:**
```bash
# Create epic from specification
bd create "Implement user authentication" \
  -t epic \
  -d "See docs/features/user-auth.md for full spec" \
  --design "OAuth2 with JWT tokens"

# Let VC break it down
vc> Break down vc-123 into subtasks
```

### 3. Code Goes in Project Root

VC generates code in your project structure:

```
my-web-app/
├── src/
│   ├── auth/                    # Built by VC
│   ├── api/                     # Built by VC
│   └── ui/                      # Built by VC
├── tests/                       # Tests built by VC
└── docs/                        # Specs written by you
```

## Workflow: Spec → Issues → Code

### Step 1: Write Specifications

Create `docs/features/user-auth.md`:
```markdown
# User Authentication Feature

## Requirements
- Users can register with email/password
- OAuth2 support (Google, GitHub)
- JWT-based session management
- Password reset flow

## Acceptance Criteria
- [ ] User can register with email
- [ ] User can login with OAuth2
- [ ] Sessions expire after 24 hours
- [ ] Password reset emails work
```

### Step 2: Create Epic in Beads

```bash
cd ~/projects/my-web-app

bd create "User Authentication" \
  -t epic \
  -p 1 \
  -d "$(cat docs/features/user-auth.md)" \
  --acceptance "See docs/features/user-auth.md"
```

### Step 3: Let VC Break It Down

```bash
vc repl

# In REPL:
vc> Break down vc-5 (User Authentication) into implementation tasks
vc> Add design documents for each subtask
vc> Let's start working on the first task
```

### Step 4: VC Builds It

```bash
# Option A: Interactive (REPL)
vc> Continue working until blocked

# Option B: Autonomous (Executor)
vc execute

# VC will:
# 1. Claim ready issues
# 2. Read your specs from docs/
# 3. Generate code in src/
# 4. Create tests in tests/
# 5. Run quality gates
# 6. Create follow-on issues as needed
```

## Multi-Project Workflow

### Switching Between Projects

```bash
# Morning: Work on web app
cd ~/projects/my-web-app
vc ready
vc execute

# Afternoon: Work on mobile app
cd ~/projects/mobile-app
vc ready
vc execute
```

### Shared VC Configuration

Create `~/.vc/config.yaml` for global settings:
```yaml
# Global VC configuration
oauth_token: ${ANTHROPIC_OAUTH_TOKEN}
model_default: claude-sonnet-4-5-20250929
model_simple: claude-3-5-haiku-20241022
```

Project-specific overrides in `.beads/config.yaml`:
```yaml
# Project-specific settings
quality_gates:
  - test
  - lint
  - build
agent_type: claude-code
```

## Example: Starting a New Project

```bash
# 1. Create project folder
mkdir ~/projects/my-saas-app
cd ~/projects/my-saas-app

# 2. Initialize git
git init

# 3. Initialize VC tracker
vc init

# 4. Create project structure
mkdir -p docs/{features,api,design}
mkdir -p src tests

# 5. Write initial specification
cat > docs/requirements.md <<EOF
# My SaaS App

## Vision
Build a subscription-based SaaS platform for...

## Features
1. User management
2. Subscription billing
3. Admin dashboard
4. API for integrations
EOF

# 6. Create initial epic
bd create "MVP Launch" \
  -t epic \
  -p 0 \
  -d "$(cat docs/requirements.md)"

# 7. Start building
vc repl
vc> Break down vc-1 into features
vc> Let's start with user management
```

## Best Practices

### 1. Specifications First
Always write `docs/` before creating issues. VC reads specs to understand intent.

### 2. One .beads/ Per Project
Each project has its own issue tracker. Don't share `.beads/` across projects.

### 3. Git Track issues.jsonl
```gitignore
# .gitignore
.beads/beads.db          # Database is local cache
.beads/*.sock*           # Runtime files
# .beads/issues.jsonl    # COMMIT THIS!
```

### 4. Use Epics for Features
```bash
bd create "Payment Integration" -t epic    # Epic for feature
bd create "Add Stripe SDK" -t task         # Task under epic
bd dep add vc-2 vc-1 --type blocks         # Task blocks epic
```

### 5. Let VC Discover Work
Don't manually create every task. Let VC's AI analysis discover:
- Edge cases
- Testing requirements
- Documentation needs
- Refactoring opportunities

## Summary

**VC Installation:**
- One VC installation in `~/tools/vc/` or similar
- Add to PATH for global access

**Project Structure:**
- Each project: `~/projects/your-project/`
- Specs in: `docs/`
- Issues in: `.beads/`
- Code in: `src/`, `app/`, etc.

**Workflow:**
1. Write specifications in `docs/`
2. Create epics in `.beads/`
3. Let VC break down and implement
4. Review and iterate

**Multi-Project:**
- Switch with `cd ~/projects/different-project`
- Each has independent `.beads/` tracker
- Shared VC binary and OAuth token

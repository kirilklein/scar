# Self-Improving Claude

A complete, self-improving [Claude Code](https://docs.anthropic.com/en/docs/claude-code) setup that gets better the more you use it. It learns from mistakes, captures reusable workflows, calibrates its own code reviews from human feedback, and tightens its own development pipeline over time.

**This is not a library or a framework.** It's a working configuration — a set of markdown files, shell scripts, and conventions — that you drop into `~/.claude/` and customize for your projects.

## What Makes It Self-Improving?

Most Claude Code setups are static: you write instructions once and they never change. This setup has **four feedback loops** that compound over time:

```
                    ┌─────────────────────────────┐
                    │     You work normally        │
                    │  (features, bugs, refactors) │
                    └─────────────┬───────────────┘
                                  │
                    ┌─────────────▼───────────────┐
                    │   /ship runs the pipeline    │
                    │  format → lint → test →      │
                    │  review → commit → push      │
                    └─────────────┬───────────────┘
                                  │
              ┌───────────────────┼───────────────────┐
              │                   │                     │
   ┌──────────▼────────┐  ┌──────▼───────┐  ┌─────────▼──────────┐
   │  Pipeline Gaps     │  │  Lessons     │  │  Workflow Recipes   │
   │                    │  │              │  │                     │
   │  /ship tracks when │  │  Gotchas,    │  │  Complex multi-step │
   │  steps miss things │  │  patterns,   │  │  procedures saved   │
   │  → tightens itself │  │  decisions   │  │  for instant replay │
   └────────────────────┘  └──────────────┘  └─────────────────────┘
                                  │
                    ┌─────────────▼───────────────┐
                    │  /retro after PR review      │
                    │  Human feedback → calibrates │
                    │  /review for next time       │
                    └─────────────────────────────┘
```

### Loop 1: Lessons & Memory

After completing a non-trivial task, Claude proactively updates memory files with gotchas, non-obvious patterns, and decision context. Next session, it reads these first — avoiding the same mistakes and rediscovery.

- **Per-repo lessons** in `.claude/lessons.md` (checked into git, shared with the team)
- **Cross-repo patterns** in the auto memory directory (private to you)
- **Debugging insights** accumulated from hard-won fixes

Lessons are categorized by **confidence level** so Claude knows how strictly to follow them:

| Level | Meaning | Example |
|---|---|---|
| **Hard Rules** | Violations caused real bugs. Mandatory. | *"Never call X without checking Y first"* |
| **Proven Patterns** | Worked 2+ times. Default to following. | *"When adding an endpoint, copy the pattern from Z"* |
| **Observations** | Noticed once. Useful context, not yet proven. | *"Tests seem faster with per-class fixtures"* |

Observations get promoted to proven patterns after a second confirmation. Proven patterns become hard rules after a violation causes a real failure.

### Loop 2: Review Calibration

The `/retro` command analyzes human PR review comments and asks: *"Could `/review` have caught this?"* If yes, it writes a specific pattern to `.claude/review-calibration.md`. Next time `/review` runs, it loads these patterns and checks for them. Your code reviews get sharper with every PR.

### Loop 3: Pipeline Gap Tracking

When `/ship` runs its format → lint → test → review pipeline, it tracks when later steps catch issues that earlier steps should have caught. These gaps accumulate in `workflow-gaps.md` and are reviewed periodically to tighten the pipeline.

### Loop 4: Workflow Capture

When Claude figures out a complex multi-step procedure (e.g., adding a new model type end-to-end, debugging a specific class of CI failure), it saves the workflow as a recipe. After 2+ successful uses, it gets promoted to a slash command — turning hours of reasoning into a single invocation.

**Draft** → **Tested** → **Promoted to `/user:command`**

## What's Included

```
self-improving-claude/
├── CLAUDE.md                    # Core coding rules (Python-optimized)
├── workspace-CLAUDE.md          # Workspace-level instructions (customize per project)
├── lessons-template.md          # Template for per-repo lessons with confidence levels
├── settings.json                # Permissions, hooks, and plugins config
├── statusline.sh                # Context % + git branch in status bar
├── commands/                    # Slash commands (/ship, /review, etc.)
│   ├── ship.md                  #   Full pre-push pipeline
│   ├── review.md                #   Code review with calibration
│   ├── triage-ci.md             #   Triage CI failures and bot comments
│   ├── start.md                 #   Start feature branch with context
│   ├── cleanup.md               #   Clean up merged branch + worktree
│   ├── handoff.md               #   Save session context for next conversation
│   └── retro.md                 #   Learn from human PR feedback
├── agents/                      # Specialized sub-agents
│   ├── code-governor.md         #   YAGNI/complexity auditor
│   ├── debugger.md              #   Root cause analysis expert
│   ├── profiler.md              #   Performance measurement (not guessing)
│   └── test-writer.md           #   Writes tests and iterates until green
├── hooks/                       # Safety guardrails
│   ├── block-dangerous-commands.sh  # Blocks rm -rf, git reset --hard, etc.
│   └── block-protected-push.sh      # Blocks push to main/dev
└── memory-template/             # Bootstrap template for auto memory
    ├── MEMORY.md
    └── workflows/
        └── README.md
```

## Quick Start

### 1. Clone this repo

Clone it next to your workspace (not inside `~/.claude/` — keep the source repo separate from the installed config):

```bash
cd ~/your-workspace   # or wherever you keep repos
git clone https://github.com/kvk-cmd/self-improving-claude.git
```

### 2. Copy files to `~/.claude/`

```bash
# Core config
cp self-improving-claude/CLAUDE.md ~/.claude/CLAUDE.md
cp self-improving-claude/settings.json ~/.claude/settings.json
cp self-improving-claude/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

# Commands
mkdir -p ~/.claude/commands
cp self-improving-claude/commands/*.md ~/.claude/commands/

# Agents
mkdir -p ~/.claude/agents
cp self-improving-claude/agents/*.md ~/.claude/agents/

# Safety hooks
mkdir -p ~/.claude/hooks
cp self-improving-claude/hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

### 3. Set up workspace-level instructions

Copy `workspace-CLAUDE.md` to your workspace root as `CLAUDE.md` and customize it:

```bash
cp self-improving-claude/workspace-CLAUDE.md ~/your-workspace/CLAUDE.md
# Edit to match your repo layout, branch conventions, and team structure
```

### 4. Bootstrap memory (optional)

If you use Claude Code's auto memory feature, seed the memory directory:

```bash
MEMORY_DIR=~/.claude/projects/<your-project-hash>/memory
mkdir -p "$MEMORY_DIR/workflows"
cp self-improving-claude/memory-template/MEMORY.md "$MEMORY_DIR/MEMORY.md"
cp self-improving-claude/memory-template/workflows/README.md "$MEMORY_DIR/workflows/README.md"
```

### 5. Set up per-repo lessons

In each repo you work with, bootstrap a lessons file with confidence levels:

```bash
mkdir -p .claude
cp self-improving-claude/lessons-template.md .claude/lessons.md
```

Claude will automatically append lessons here as it works, categorized by confidence (Hard Rules > Proven Patterns > Observations). Commit this file to share learnings with your team.

## How the Commands Work Together

### Daily development flow

```
/start my-feature          # Create branch, load context, check for handoff
  ... write code ...
/ship                      # Format → lint → test → review → commit → push
  ... PR gets CI results ...
/triage-ci                 # Fix CI failures, dismiss false positives
  ... human reviews PR ...
/retro                     # Learn from human feedback → calibrate /review
  ... PR merges ...
/cleanup repo/my-feature   # Remove worktree and branch
```

### Session continuity

```
/handoff                   # End of session: save context
  ... new conversation ...
/start my-feature          # Reads handoff, picks up where you left off
```

### The self-improvement chain

1. `/ship` runs `/review` as step 6 and tracks pipeline gaps
2. `/triage-ci` adds to lessons when CI reveals non-obvious failures
3. `/retro` calibrates `/review` from human feedback
4. Next `/ship` → `/review` is now smarter

## Customization Guide

### Adapting CLAUDE.md for your language

The included `CLAUDE.md` is Python-optimized. To adapt for other languages:

- Replace PEP 8 references with your language's style guide
- Change the testing framework references
- Adjust the modularity thresholds (150-200 lines) if different for your language
- Keep the core principles (YAGNI, correctness > clarity > performance, etc.) — they're language-agnostic

### Adding project-specific test mappings

In your repo's `.claude/CLAUDE.md`, add a test mapping table:

```markdown
## Pre-Push Test Mapping

| Source changes in | Run command |
|---|---|
| `src/auth/**` | `pytest tests/test_auth -v` |
| `src/api/**` | `pytest tests/test_api -v` |
| Cross-module changes | `pytest tests/integration -v` |
```

`/ship` reads this to run only the relevant tests.

### Adding new slash commands

Create a markdown file in `~/.claude/commands/` (global) or `.claude/commands/` (per-repo):

```markdown
---
description: Short description shown in /help
---

Instructions for Claude to follow when this command is invoked.

$ARGUMENTS
```

Invoke with `/user:command-name` (global) or `/project:command-name` (per-repo).

### Workflow recipe to slash command promotion

When a workflow recipe in `memory/workflows/` has been used successfully 2+ times:

1. Copy it from the memory directory to `~/.claude/commands/<name>.md` or `.claude/commands/<name>.md`
2. Add the YAML frontmatter (`---` block with description)
3. Replace the recipe's "Example" section with `$ARGUMENTS`
4. It's now a slash command

## Architecture Principles

**Everything is a markdown file.** No compiled code, no complex runtime, no dependencies beyond Claude Code itself. The entire system is inspectable and editable by both humans and Claude.

**Three layers of instructions:**
1. **`~/.claude/CLAUDE.md`** — global coding rules (applies to all repos)
2. **`workspace/CLAUDE.md`** — workspace conventions (branching, cross-repo patterns)
3. **`repo/.claude/CLAUDE.md`** — repo-specific rules (test mappings, modification guides)

**Three layers of memory:**
1. **`repo/.claude/lessons.md`** — repo-specific lessons (shared with team via git)
2. **Auto memory files** — cross-repo patterns and debugging insights (private)
3. **Workflow recipes** — reusable procedures (private, promotable to commands)

**Safety by default.** Hooks block destructive commands (`rm -rf`, `git reset --hard`, `push --force`, push to `main`/`dev`). Claude must ask before doing anything irreversible.

## License

MIT

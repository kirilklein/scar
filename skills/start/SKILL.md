---
description: Start a new feature branch with worktree and loaded context
---

Set up a new feature branch and load project context. Takes the branch name as argument.

## Steps

1. **Parse arguments**: The branch name is `$ARGUMENTS`. If empty, ask the user for a branch name.

2. **Detect repo**: Determine which repo to work in based on the current directory. If ambiguous, ask the user.

3. **Create worktree** (bucketed by creation month — `YYYY-MM`, so older branches sort to the top and stale work is easy to spot):
   ```
   cd <repo-root>
   git fetch origin
   MONTH=$(date +%Y-%m)
   mkdir -p ../worktrees/<repo>/$MONTH
   git worktree add ../worktrees/<repo>/$MONTH/<branch-name> -b <branch-name> origin/dev
   cd ../worktrees/<repo>/$MONTH/<branch-name>
   ```

4. **Link the Python venv** (skip for repos with no venv, e.g. pure JS): a fresh worktree has no venv, so bare `python` can fall back to a different interpreter than the project uses (e.g. a global pyenv version too old to import the project's deps). Symlink the main checkout's venv so the right interpreter + installed deps are available without bootstrapping a per-worktree venv. Run from inside the worktree:
   ```bash
   REPO_MAIN="$(cd "$(git rev-parse --git-common-dir)/.." && pwd)"
   for v in .venv venv; do
     if [ -d "$REPO_MAIN/$v" ] && [ ! -e "$v" ]; then
       ln -s "$REPO_MAIN/$v" "$v"; echo "Linked $v -> $REPO_MAIN/$v"; break
     fi
   done
   ```
   `.venv`/`venv` are usually gitignored, so the symlink won't show in `git status`. Activate before running anything (`source .venv/bin/activate`). Run tests **from the worktree dir** — cwd-precedence makes imports resolve to the worktree's source, not the shared venv's editable install of the main checkout. The venv is *shared* via symlink, so a `pip install` here mutates the main checkout's venv too.

5. **Load context**: Read the following files from the new worktree to build understanding:
   - `.claude/CLAUDE.md` (project rules and test mapping)
   - `.claude/overview.md` (architecture overview, if it exists)
   - `.claude/lessons.md` (hard-won lessons from previous work)
   - `.claude/review-calibration.md` (review patterns, if it exists)

6. **Check for handoff**: Look for `.claude/handoff.md` in the worktree or repo root. If it exists, read it, summarize the previous session's state, and delete the file. This bridges context across conversations.

7. **Report ready**: Summarize what was loaded (and any handoff context). Ask what we're building.

Branch name:
$ARGUMENTS

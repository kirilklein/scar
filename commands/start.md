---
description: Start a new feature branch with worktree and loaded context
---

Set up a new feature branch and load project context. Takes the branch name as argument.

## Steps

1. **Parse arguments**: The branch name is `$ARGUMENTS`. If empty, ask the user for a branch name.

2. **Detect repo**: Determine which repo to work in based on the current directory. If ambiguous, ask the user.

3. **Create worktree**:
   ```
   cd <repo-root>
   git fetch origin
   git worktree add ../worktrees/<repo>/<branch-name> -b <branch-name> origin/dev
   ```

4. **Load context**: Read the following files from the new worktree to build understanding:
   - `.claude/CLAUDE.md` (project rules and test mapping)
   - `.claude/overview.md` (architecture overview, if it exists)
   - `.claude/lessons.md` (hard-won lessons from previous work)
   - `.claude/review-calibration.md` (review patterns, if it exists)

5. **Check for handoff**: Look for `.claude/handoff.md` in the worktree or repo root. If it exists, read it, summarize the previous session's state, and delete the file. This bridges context across conversations.

6. **Report ready**: Summarize what was loaded (and any handoff context). Ask what we're building.

Branch name:
$ARGUMENTS

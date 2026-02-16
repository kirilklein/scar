---
description: Clean up a merged feature branch and its worktree
---

Remove a feature branch worktree after its PR has been merged. Takes the repo and branch name as argument (e.g., `repo-name/my-feature`).

## Steps

1. **Parse arguments**: `$ARGUMENTS` should be `<repo>/<branch-name>`. If empty or missing the repo prefix, ask the user.

2. **Verify PR is merged**: Run `gh pr list --head <branch-name> --state merged --json number,title` to confirm the branch's PR was merged. If not merged, warn the user and ask for confirmation before proceeding.

3. **Remove worktree**:
   ```
   cd <repo-root>
   git worktree remove ../worktrees/<repo>/<branch-name>
   ```

4. **Delete local branch**:
   ```
   git branch -d <branch-name>
   ```
   Use `-d` (not `-D`) so git refuses if the branch has unmerged changes.

5. **Confirm**: Report what was cleaned up.

Target:
$ARGUMENTS

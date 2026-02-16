---
description: Save session context for the next conversation
---

Capture the current session state so the next conversation can pick up where we left off. Write a brief handoff note.

## Steps

1. **Identify the repo and branch**: Check `git branch --show-current` and working directory.

2. **Summarize current state**: Review what was done this session:
   - What feature/task we were working on
   - What's done and what's not
   - Current branch state: committed? pushed? PR open?
   - Any failing tests or known issues

3. **Note open threads**: List any:
   - Deferred decisions ("we said we'd handle X later")
   - Unresolved questions or ambiguities
   - Next steps that were discussed but not started

4. **Write handoff file**: Write to `.claude/handoff.md` in the current worktree (or repo root if not in a worktree). Keep it short — aim for 10-20 lines max. Format:
   ```markdown
   # Session Handoff

   ## Working on
   [Brief description of the feature/task]

   ## Status
   - [What's done]
   - [What's remaining]

   ## Open threads
   - [Decisions deferred, questions, blockers]

   ## Next steps
   - [What to do next]
   ```

5. **Confirm**: Show the handoff note and confirm it was saved.

This file is ephemeral — `/start` reads it and it should be deleted once the next session picks it up. Do NOT commit it to git.

$ARGUMENTS

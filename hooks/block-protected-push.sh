#!/bin/bash
# Block pushes to main or dev branches.
# Used as a PreToolUse hook for Bash commands.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only check git push commands
if ! echo "$COMMAND" | grep -qE 'git\s+push'; then
  exit 0
fi

# Block explicit push to protected branches (e.g. git push origin main)
if echo "$COMMAND" | grep -qE 'git\s+push\s+\S+\s+(main|dev)\b'; then
  echo "BLOCKED: Pushing directly to main or dev is not allowed. Use a feature branch." >&2
  exit 2
fi

# Block plain "git push" when currently on a protected branch
current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ "$current_branch" = "main" ] || [ "$current_branch" = "dev" ]; then
  echo "BLOCKED: Currently on '$current_branch'. Pushing to protected branches is not allowed. Switch to a feature branch." >&2
  exit 2
fi

exit 0

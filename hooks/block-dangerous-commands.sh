#!/bin/bash
# Block dangerous/destructive commands that are hard to reverse.
# Used as a PreToolUse hook for Bash commands.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Skip commit/tag commands — their messages may contain dangerous-looking strings
if echo "$COMMAND" | grep -qE 'git\s+(commit|tag)\s'; then
  exit 0
fi

# rm -rf (allow rm on specific files, block recursive force)
if echo "$COMMAND" | grep -qE 'rm\s+(-[a-zA-Z]*r[a-zA-Z]*f|--recursive)\s'; then
  echo "BLOCKED: rm -rf is destructive. Please remove files individually or ask the user to confirm." >&2
  exit 2
fi

# git reset --hard
if echo "$COMMAND" | grep -qE 'git\s+reset\s+--hard'; then
  echo "BLOCKED: git reset --hard discards uncommitted changes. Ask the user before proceeding." >&2
  exit 2
fi

# git checkout . (discard all changes)
if echo "$COMMAND" | grep -qE 'git\s+checkout\s+\.'; then
  echo "BLOCKED: git checkout . discards all uncommitted changes. Ask the user before proceeding." >&2
  exit 2
fi

# git clean -f
if echo "$COMMAND" | grep -qE 'git\s+clean\s+-[a-zA-Z]*f'; then
  echo "BLOCKED: git clean -f permanently deletes untracked files. Ask the user before proceeding." >&2
  exit 2
fi

# git restore . (discard all changes)
if echo "$COMMAND" | grep -qE 'git\s+restore\s+\.'; then
  echo "BLOCKED: git restore . discards all uncommitted changes. Ask the user before proceeding." >&2
  exit 2
fi

# git push --force (but not --force-with-lease which is safer)
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*--force\b' && ! echo "$COMMAND" | grep -qE '--force-with-lease'; then
  echo "BLOCKED: git push --force can overwrite remote history. Use --force-with-lease or ask the user." >&2
  exit 2
fi

exit 0

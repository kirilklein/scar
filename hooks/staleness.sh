#!/bin/sh
# Nudge, once per session, when Scar's files are due for an audit. Silent otherwise.
dir=".claude"
stale=""
for f in lessons.md review-calibration.md; do
  [ -f "$dir/$f" ] && [ -n "$(find "$dir/$f" -mtime +30 2>/dev/null)" ] && stale="$stale $f"
done
[ -n "$stale" ] && echo "Scar: not audited in 30+ days:$stale. Run /promote."

g="$dir/workflow-gaps.md"
if [ -f "$g" ]; then
  n=$(sed '/^## Resolved/,$d' "$g" | grep -c '^- \[')
  [ "$n" -ge 5 ] && echo "Scar: $n unresolved pipeline gaps. Run /gaps."
fi
exit 0

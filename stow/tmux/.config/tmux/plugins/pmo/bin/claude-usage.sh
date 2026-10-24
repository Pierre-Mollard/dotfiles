#!/usr/bin/env sh
# Claude 5h usage segment for the tmux status-right (see pmo_tmux.conf).
#
# Claude Code's statusline (~/.claude/scripts/statusline.sh) writes the cache
# file below on every message update. It holds one line:
#   "<used_percent> <resets_at_epoch>"   e.g. "42 1761318000"
# tmux calls this script every status-interval, so it stays plain sh and only
# reads the file (no JSON parsing, no network).

f="$HOME/.cache/claude/usage"

# No cache yet: Claude Code hasn't run since login, or the account has no plan limits
[ -r "$f" ] || { echo "--"; exit 0; }

read -r pct reset <"$f"

# The cache only refreshes while Claude is in use; once the 5h window's reset
# time has passed the stored value is stale, so the real usage is back to 0
if [ "${reset:-0}" -gt 0 ] && [ "$(date +%s)" -ge "$reset" ]; then
  pct=0
fi

echo "${pct}%"

#!/usr/bin/env bash
# Claude Code statusline (settings.json -> statusLine).
#
# Claude Code runs this after each message update in an open session, passing a
# JSON payload on stdin. For Pro/Max logins that payload includes the plan rate
# limits, e.g. "rate_limits":{"five_hour":{"used_percentage":42,"resets_at":1761318000},...},
# which Claude Code reads from its own API response headers (no extra requests).
#
# Besides printing the statusline, we cache the 5h window to ~/.cache/claude/usage
# as "<used_percent> <resets_at_epoch>" for the tmux status bar
# (~/.config/tmux/plugins/pmo/bin/claude-usage.sh).

input=$(cat)
cache_dir="$HOME/.cache/claude"

# Minimal JSON field extraction without jq: first match of "key":"value" or "key":number
json_field() {
  local re="\"$1\"[[:space:]]*:[[:space:]]*\"?([^\",}]*)"
  [[ $2 =~ $re ]] && printf '%s' "${BASH_REMATCH[1]}"
}

model=$(json_field display_name "$input")

# Narrow to the five_hour object so we don't pick up seven_day's values
five_hour_re='"five_hour"[[:space:]]*:[[:space:]]*\{([^}]*)\}'
if [[ $input =~ $five_hour_re ]]; then
  five_hour=${BASH_REMATCH[1]}
  pct=$(json_field used_percentage "$five_hour")
  reset=$(json_field resets_at "$five_hour")
  pct=$(printf '%.0f' "$pct" 2>/dev/null) || pct=0
  [[ $reset =~ ^[0-9]+$ ]] || reset=0

  # Atomic write so tmux never reads a half-written file
  mkdir -p "$cache_dir"
  printf '%s %s\n' "$pct" "$reset" >"$cache_dir/usage.tmp"
  mv -f "$cache_dir/usage.tmp" "$cache_dir/usage"

  printf '%s · 5h %s%%\n' "${model:-Claude}" "$pct"
else
  printf '%s\n' "${model:-Claude}"
fi

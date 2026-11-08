#!/usr/bin/env sh
# GitHub commits-today segment for the tmux status-left (see pmo_tmux.conf).
#
# tmux calls this script every status-interval, so the API is only hit once per
# $ttl seconds and the result is cached in one line: "<YYYY-MM-DD> <count>"
#
# The count follows the contribution graph: commits on default branches, by an
# email linked to the account. It is commits visible to the gh token, plus
# restrictedContributionsCount, the private contributions the token can't see.
# Those are only reported when the profile's "Private contributions" setting is
# on, and they aren't limited to commits (they include private PRs, issues...).

ttl=120
f="$HOME/.cache/tmux-pmo/github-commits"

mkdir -p "${f%/*}"

last=$(stat -c %Y "$f" 2>/dev/null || echo 0)

if [ $(($(date +%s) - last)) -ge "$ttl" ]; then
  # Touch before fetching so a failing request (offline, expired token) also
  # waits for the next ttl instead of being retried every second
  touch "$f"

  # shellcheck disable=SC2016 # $from and $to are GraphQL variables
  count=$(timeout 15 gh api graphql \
    -f query='query($from:DateTime!,$to:DateTime!){viewer{contributionsCollection(from:$from,to:$to){totalCommitContributions restrictedContributionsCount}}}' \
    -F from="$(date -d 00:00:00 +%FT%T%:z)" \
    -F to="$(date -d 23:59:59 +%FT%T%:z)" \
    --jq '.data.viewer.contributionsCollection | .totalCommitContributions + .restrictedContributionsCount' \
    2>/dev/null)

  case "$count" in
  '' | *[!0-9]*) ;;
  *)
    printf '%s %s\n' "$(date +%F)" "$count" >"$f.tmp"
    mv -f "$f.tmp" "$f"
    ;;
  esac
fi

read -r day count <"$f"

# A count from a previous day means nothing today, so don't show it
if [ "$day" = "$(date +%F)" ]; then
  echo "$count"
else
  echo "--"
fi

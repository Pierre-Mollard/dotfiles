#!/usr/bin/env sh
# GitHub commits-today segment for the tmux status-right (see pmo_tmux.conf).
#
# Display:
#   12      commits made today (public + private)
#   --      no count for today yet (first few minutes after midnight)
#   red 󰀦   last refresh failed, followed by today's last known count or --
#
# ---------------------------------------------------------------------------
# Setup, and what to do when it shows the red 󰀦
# ---------------------------------------------------------------------------
# The usual cause is the token expiring. Check its expiry date with:
#   gh api -i user | grep -i token-expiration
#
# Create a new token: GitHub > Settings > Developer settings >
# Personal access tokens > Fine-grained tokens, with:
#   - Repository access: All repositories
#   - Repository permissions > Contents: Read-only
# Then log in with it, and force a refresh instead of waiting for the next one:
#   gh auth login
#   rm ~/.cache/tmux-pmo/github-commits
#
# It also shows while offline, and goes away by itself once back online.
# To see the real error, run the query by hand: gh api graphql -f query='{viewer{id}}'
#
# Why two sources: contributionsCollection returns nothing for private repos
# with a fine-grained token, even with Contents read (it found 0 of 517 private
# commits). So public commits come from it, and private ones from each repo's
# commit history.
#
# What counts: commits on default branches, by an email linked to the account.
# Private repos are limited to the first 100 the token can see.
# ---------------------------------------------------------------------------

# Seconds between two GitHub refreshes (tmux runs this script every second)
ttl=120
# Cache file holding one line: "<YYYY-MM-DD> <count> <ok|broken>"
f="$HOME/.cache/tmux-pmo/github-commits"
# Today's date, compared to the cached one to detect a count from another day
today=$(date +%F)

# GraphQL query, read by the gh call below.
# $from/$to and $since/$until are the same range: the two fields want different types.
# contributionsCollection gives the commit count of each repo, with its visibility.
# repositories gives the private repos, and history counts my commits on the
# default branch of each one ($id is my account, to skip other people's commits).
# shellcheck disable=SC2016 # these $ are GraphQL variables, not shell ones
query='query($from:DateTime!,$to:DateTime!,$since:GitTimestamp!,$until:GitTimestamp!,$id:ID!){
  viewer{
    contributionsCollection(from:$from,to:$to){
      commitContributionsByRepository(maxRepositories:100){
        repository{isPrivate}
        contributions{totalCount}
      }
    }
    repositories(first:100,privacy:PRIVATE){
      totalCount
      nodes{defaultBranchRef{target{... on Commit{history(since:$since,until:$until,author:{id:$id}){totalCount}}}}}
    }
  }
}'

# Filter turning the response into one number, read by the same gh call.
# If no private repo is visible, the token lost its access: output text instead
# of a number so it counts as a failure rather than a wrong total.
# Otherwise add the public repos' counts to the private repos' counts.
# "// 0" covers empty repos (no default branch) and an empty list.
filter='.data.viewer
  | if .repositories.totalCount == 0 then "no-private-access"
    else
      ([.contributionsCollection.commitContributionsByRepository[]
        | select(.repository.isPrivate | not) | .contributions.totalCount] | add // 0)
      + ([.repositories.nodes[].defaultBranchRef.target.history.totalCount // 0] | add // 0)
    end'

# Create the cache folder if it doesn't exist yet
mkdir -p "${f%/*}"
# Load the previous result, if there is one
[ -r "$f" ] && read -r day count state <"$f"
# Time of the last refresh attempt (0 when there's no cache, so it refreshes now)
last=$(stat -c %Y "$f" 2>/dev/null || echo 0)

# Only call GitHub once the last attempt is at least $ttl seconds old
if [ $(($(date +%s) - last)) -ge "$ttl" ]; then
  # Mark the attempt before fetching: a failure then waits for the next $ttl
  # instead of being retried every second
  touch "$f"

  # Start of today, with the timezone offset so the day is local and not UTC
  start=$(date -d 00:00:00 +%FT%T%:z)
  # End of today
  end=$(date -d 23:59:59 +%FT%T%:z)
  # My account id, needed by the history filter. Empty on failure, which then
  # makes the next request fail too. timeout stops a hung request.
  id=$(timeout 15 gh api graphql -f query='{viewer{id}}' --jq .data.viewer.id 2>/dev/null)
  # Fetch today's count. Empty on any failure (offline, expired token...).
  new=$(timeout 15 gh api graphql -f query="$query" \
    -F from="$start" -F to="$end" -F since="$start" -F until="$end" -F id="$id" \
    --jq "$filter" 2>/dev/null)

  # Anything but digits means the refresh failed
  case "$new" in
  # Failed: keep the previous day and count, and only flag it as broken
  '' | *[!0-9]*) state=broken ;;
  # Worked: store the new count for today
  *)
    day=$today
    count=$new
    state=ok
    ;;
  esac

  # Write to a temp file first, then rename, so tmux never reads half a line.
  # The defaults stop the fields shifting when a first ever refresh fails.
  printf '%s %s %s\n' "${day:-none}" "${count:-0}" "$state" >"$f.tmp"
  # Replace the cache in one step (this also resets its age for the $ttl check)
  mv -f "$f.tmp" "$f"
fi

# Use the count only if it's from today, since yesterday's means nothing now
if [ "$day" = "$today" ]; then
  shown=$count
else
  shown="--"
fi

# Print the segment: tmux applies the #[...] colour itself
if [ "$state" = "broken" ]; then
  echo "#[fg=red]󰀦 $shown"
else
  echo "$shown"
fi

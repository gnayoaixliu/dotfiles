#!/usr/bin/env bash
# Rename each Herdr space once to the short session title ("🗂️ TEAMKB") of its first agent pane.
# Run every 10s by the herdr-space-names launchd agent in home.nix.
# A space is renamed once per agent session; later manual renames are kept.
set -euo pipefail

state_dir="$HOME/.local/state/herdr-space-names"
state="$state_dir/renamed.tsv" # workspace_id <TAB> agent session path
mkdir -p "$state_dir"
touch "$state"

# Herdr not running: nothing to do.
panes=$(herdr pane list 2>/dev/null) || exit 0

# workspace_id <TAB> session path of the first agent pane in each space.
masters=$(jq -r '
  .result.panes
  | map(select(.agent != null and .agent_session.kind == "path"))
  | group_by(.workspace_id)[] | .[0]
  | [.workspace_id, .agent_session.value] | @tsv' <<<"$panes")

# Drop state for spaces or sessions that no longer exist.
grep -xFf <(printf '%s\n' "$masters") "$state" >"$state.tmp" || true
mv "$state.tmp" "$state"

while IFS=$'\t' read -r ws session; do
  [ -n "$ws" ] || continue
  grep -qxF "$ws"$'\t'"$session" "$state" && continue
  # omp keeps the session title record on the first line of the session file.
  # Keep only the "<emoji> TAG" before the colon; titles without one stay whole.
  title=$(head -n1 "$session" 2>/dev/null | jq -r 'select(.type == "title") | .title // empty | sub("\\s*:.*"; "")' 2>/dev/null || true)
  [ -n "$title" ] || continue # title not generated yet; retry next run
  herdr workspace rename "$ws" "$title" >/dev/null
  printf '%s\t%s\n' "$ws" "$session" >>"$state"
  echo "$(date '+%F %T') renamed $ws -> $title"
done <<<"$masters"

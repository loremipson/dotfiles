#!/usr/bin/env bash
set -euo pipefail

fail() {
  echo
  echo "$1"
  echo "Press any key to close."
  read -r -n 1 -s
  exit 1
}

command -v gt >/dev/null 2>&1 || fail "Graphite CLI (gt) is not installed."
command -v workmux >/dev/null 2>&1 || fail "workmux is not installed."

current_branch=$(git branch --show-current)
[ -n "$current_branch" ] || fail "Detached HEAD is not supported."

trunk=$(gt trunk) || fail "Could not determine the Graphite trunk."

printf 'Branch (from %s): ' "$trunk"
read -r branch
[ -z "$branch" ] && exit 0

# Graphite owns branch creation. `gt create --onto` creates the branch
# on the requested parent, but checks it out in the current worktree.
# Switch back before asking workmux to check the new branch out elsewhere.
if ! gt create --onto "$trunk" "$branch"; then
  fail "gt create failed."
fi

if ! git switch "$current_branch"; then
  echo
  echo "Graphite created $branch, but could not switch back to $current_branch."
  echo "Do not run this again until you are back on $current_branch."
  fail "Switch-back failed."
fi

if ! workmux add "$branch" --base "$trunk"; then
  echo
  echo "Graphite created $branch successfully, but workmux failed to create the worktree."
  echo "You can retry with: workmux add $branch --base $trunk"
  fail "workmux add failed."
fi

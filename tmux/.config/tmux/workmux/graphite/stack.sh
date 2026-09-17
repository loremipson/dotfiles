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

parent=$(git branch --show-current)
[ -n "$parent" ] || fail "Detached HEAD is not supported for stacking."

printf 'Branch (stack on %s): ' "$parent"
read -r branch
[ -z "$branch" ] && exit 0

# Graphite owns branch creation. The new branch is temporarily checked out
# in this worktree; switch back before workmux checks it out in its own.
if ! gt create --onto "$parent" "$branch"; then
  fail "gt create failed."
fi

if ! git switch "$parent"; then
  echo
  echo "Graphite created $branch, but could not switch back to $parent."
  echo "Do not run this again until you are back on $parent."
  fail "Switch-back failed."
fi

if ! workmux add "$branch" --base "$parent"; then
  echo
  echo "Graphite created $branch successfully, but workmux failed to create the worktree."
  echo "You can retry with: workmux add $branch --base $parent"
  fail "workmux add failed."
fi


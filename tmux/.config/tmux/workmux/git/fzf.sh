#!/usr/bin/env bash
set -euo pipefail

cmd="${1:-}"
[ -n "$cmd" ] || exit 1

selection=$(workmux list | tail -n +2 | fzf)
[ -z "$selection" ] && exit 0

branch=$(awk '{print $1}' <<< "$selection")
workmux "$cmd" "$branch" || {
  echo
  echo "workmux $cmd failed. Press any key to close."
  read -r -n 1 -s
}

#!/usr/bin/env bash
set -euo pipefail

if ! command -v gt >/dev/null 2>&1; then
  echo "Graphite CLI (gt) is not installed."
  echo "Press any key to close."
  read -r -n 1 -s
  exit 1
fi

selection=$(git for-each-ref --format='%(refname:short)' refs/heads | fzf)
[ -z "$selection" ] && exit 0

workmux add -o "$selection" || {
  echo
  echo "workmux add failed. Press any key to close."
  read -r -n 1 -s
}

#!/usr/bin/env bash
set -euo pipefail

printf 'Branch: '
read -r branch
[ -z "$branch" ] && exit 0

workmux add -o "$branch" || {
  echo
  echo "workmux add failed. Press any key to close."
  read -r -n 1 -s
}

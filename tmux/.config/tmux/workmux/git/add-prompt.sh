#!/usr/bin/env bash
set -euo pipefail

printf 'Prompt: '
read -r prompt
[ -z "$prompt" ] && exit 0

workmux add -A -p "$prompt" || {
  echo
  echo "workmux add failed. Press any key to close."
  read -r -n 1 -s
}

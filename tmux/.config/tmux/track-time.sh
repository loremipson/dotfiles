#!/bin/bash

# Sessions of all currently-attached clients (tmux updates this list
# before firing the hook, so a just-detached client won't appear)
REMAINING=$(tmux list-clients -F '#{client_session}' 2>/dev/null)

if [[ -z "$REMAINING" ]]; then
  # nobody attached anywhere — stop, full stop
  timew stop >/dev/null 2>&1
  exit 0
fi

# of the remaining clients, track whichever was most recently active
SESSION=$(tmux list-clients -F '#{client_activity} #{client_session}' \
  | sort -rn | head -1 | cut -d' ' -f2-)

CURRENT=$(timew get dom.active.tag.1 2>/dev/null)
if [[ "$SESSION" != "$CURRENT" ]]; then
  timew stop >/dev/null 2>&1
  timew start "$SESSION"
fi

#!/bin/bash

ACTIVE=$(timew get dom.active 2>/dev/null)

if [[ "$ACTIVE" == "1" ]]; then
  TAG=$(timew get dom.active.tag.1 2>/dev/null)
  ELAPSED_ISO=$(timew get dom.active.duration 2>/dev/null)

  # Parse an ISO 8601 duration like PT1H23M45S into HH:MM:SS.
  # (timew durations only ever use days/hours/minutes/seconds, no
  # years or months, so this doesn't need to handle those.)
  DUR="${ELAPSED_ISO#P}"
  if [[ "$DUR" == *T* ]]; then
    DATE_PART="${DUR%%T*}"
    TIME_PART="${DUR#*T}"
  else
    DATE_PART="$DUR"
    TIME_PART=""
  fi

  DAYS=0; HOURS=0; MINUTES=0; SECONDS=0
  [[ "$DATE_PART" =~ ([0-9]+)D ]] && DAYS="${BASH_REMATCH[1]}"
  [[ "$TIME_PART" =~ ([0-9]+)H ]] && HOURS="${BASH_REMATCH[1]}"
  [[ "$TIME_PART" =~ ([0-9]+)M ]] && MINUTES="${BASH_REMATCH[1]}"
  [[ "$TIME_PART" =~ ([0-9]+)(\.[0-9]+)?S ]] && SECONDS="${BASH_REMATCH[1]}"

  TOTAL_HOURS=$(( DAYS * 24 + HOURS ))

  if [ "$TOTAL_HOURS" -gt 0 ]; then
    ELAPSED=$(printf "%d:%02d:%02d" "$TOTAL_HOURS" "$MINUTES" "$SECONDS")
  elif [ "$MINUTES" -gt 0 ]; then
    ELAPSED=$(printf "%d:%02d" "$MINUTES" "$SECONDS")
  else
    ELAPSED=$(printf "0:%02d" "$SECONDS")
  fi

  sketchybar --set "$NAME" label="$TAG · $ELAPSED" icon="󰔟" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi

#!/bin/bash

source "$CONFIG_DIR/colors.sh"

BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATTERY_INFO" | grep -Eo "[0-9]+%" | cut -d% -f1)"
CHARGING="$(echo "$BATTERY_INFO" | grep -c 'AC Power')"
TIME_REMAINING="$(echo "$BATTERY_INFO" | grep -Eo '[0-9]+:[0-9]+' | head -1)"

if [ "$CHARGING" -gt 0 ]; then
  ICON=""
  COLOR="$GREEN"
else
  case "$PERCENTAGE" in
    9[0-9]|100) ICON="" ;;
    [6-8][0-9]) ICON="" ;;
    [3-5][0-9]) ICON="" ;;
    [1-2][0-9]) ICON="" ;;
    *) ICON="" ;;
  esac
  if [ "$PERCENTAGE" -le 20 ]; then
    COLOR="$RED"
  else
    COLOR="$FG"
  fi
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label.drawing=off

if [ "$CHARGING" -gt 0 ]; then
  STATUS_LABEL="Charging — ${PERCENTAGE}%"
else
  STATUS_LABEL="${PERCENTAGE}% remaining"
fi

if [ -n "$TIME_REMAINING" ] && [ "$TIME_REMAINING" != "0:00" ]; then
  STATUS_LABEL="$STATUS_LABEL  (${TIME_REMAINING} left)"
fi

sketchybar --set battery.details label="$STATUS_LABEL"

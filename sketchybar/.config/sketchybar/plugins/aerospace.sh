#!/bin/bash

source "$CONFIG_DIR/colors.sh"

SID="$1"
AEROSPACE="$(command -v aerospace 2>/dev/null || echo /opt/homebrew/bin/aerospace)"

FOCUSED="${FOCUSED_WORKSPACE:-$("$AEROSPACE" list-workspaces --focused 2>/dev/null)}"
APP_ICONS=$("$AEROSPACE" list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null |
  awk 'NF && !seen[$0]++' |
  "$CONFIG_DIR/helpers/app_icon.sh" |
  paste -sd ' ' -)

DRAWING=off
LABEL_DRAWING=off
if [ "$SID" = "$FOCUSED" ] || [ -n "$APP_ICONS" ]; then
  DRAWING=on
fi
[ -n "$APP_ICONS" ] && LABEL_DRAWING=on

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar \
    --set "$NAME" drawing=$DRAWING \
    icon.color="$BG" \
    label.color="$BG" \
    label="$APP_ICONS" \
    label.drawing=$LABEL_DRAWING \
    background.corner_radius=3 \
    background.color="$YELLOW" \
    background.drawing=on
else
  sketchybar \
    --set "$NAME" drawing=$DRAWING \
    icon.color="$FG" \
    label.color="0xe6${FG#0xff}" \
    label="$APP_ICONS" \
    label.drawing=$LABEL_DRAWING \
    background.color="$BG" \
    background.drawing=off
fi

#!/bin/bash

source "$CONFIG_DIR/colors.sh"

SID="$1"
AEROSPACE="$(command -v aerospace 2>/dev/null || echo /opt/homebrew/bin/aerospace)"

FOCUSED="${FOCUSED_WORKSPACE:-$("$AEROSPACE" list-workspaces --focused 2>/dev/null)}"
NONEMPTY=$("$AEROSPACE" list-workspaces --monitor all --empty no 2>/dev/null)

DRAWING=off
if [ "$SID" = "$FOCUSED" ] || printf '%s\n' "$NONEMPTY" | grep -qx "$SID"; then
  DRAWING=on
fi

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar \
    --set "$NAME" drawing=$DRAWING \
      label.color="$BG" \
      background.corner_radius=3 \
      background.color="$YELLOW" \
      background.drawing=on
else
  sketchybar \
    --set "$NAME" drawing=$DRAWING \
      label.color="$FG" \
      background.color="$BG" \
      background.drawing=off
fi

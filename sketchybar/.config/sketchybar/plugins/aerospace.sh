#!/bin/bash

SID="$1"
AEROSPACE="$(command -v aerospace 2>/dev/null || echo /opt/homebrew/bin/aerospace)"

FOCUSED="${FOCUSED_WORKSPACE:-$("$AEROSPACE" list-workspaces --focused 2>/dev/null)}"
NONEMPTY=$("$AEROSPACE" list-workspaces --monitor all --empty no 2>/dev/null)

DRAWING=off
if [ "$SID" = "$FOCUSED" ] || printf '%s\n' "$NONEMPTY" | grep -qx "$SID"; then
  DRAWING=on
fi

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" drawing=$DRAWING \
    label.color=0xff000000 \
    background.color=0xffff8f4d \
    background.drawing=on
else
  sketchybar --set "$NAME" drawing=$DRAWING \
    label.color=0x80ffffff \
    background.color=0x00000000 \
    background.drawing=off
fi

#!/bin/bash
ACTIVE=$(timew get dom.active 2>/dev/null)
if [[ "$ACTIVE" == "1" ]]; then
  TAG=$(timew get dom.active.tag.1 2>/dev/null)
  ELAPSED=$(timew get dom.active.duration 2>/dev/null)
  sketchybar --set "$NAME" label="⏱ $TAG · $ELAPSED" icon="" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi

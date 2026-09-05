#!/bin/bash

WEATHER="$(curl -s --max-time 5 'wttr.in/?format=%c+%t')"

if [ -z "$WEATHER" ]; then
  sketchybar --set "$NAME" label.drawing=off
else
  sketchybar --set "$NAME" label="$WEATHER" label.drawing=on
fi

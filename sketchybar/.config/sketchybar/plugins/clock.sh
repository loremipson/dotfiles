#!/bin/sh

DATE="$(date '+%b %d')"
TIME="$(date '+%H:%M')"

sketchybar --set "$NAME" label="$DATE $TIME" icon="󰃭"


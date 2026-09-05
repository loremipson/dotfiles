#!/bin/sh

DATE="$(date '+%a %b %d')"
TIME="$(date '+%H:%M')"

sketchybar --set "$NAME" label="$DATE  $TIME"


#!/bin/sh

[ "$SENDER" = "theme_changed" ] || exit 0

sleep 0.2
sketchybar --reload

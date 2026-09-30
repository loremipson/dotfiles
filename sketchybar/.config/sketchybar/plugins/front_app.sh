#!/bin/sh

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "front_app_switched" ]; then
  icon=$("$CONFIG_DIR/helpers/app_icon.sh" "$INFO")
  sketchybar --set "$NAME" icon="$icon" icon.color="$YELLOW" label="$INFO"
fi

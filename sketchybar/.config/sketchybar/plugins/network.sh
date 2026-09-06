#!/bin/bash

WIFI_INTERFACE="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')"
VPN_SERVICE="$(scutil --nc list 2>/dev/null | head -1 | sed -E 's/^\* \(.*\) [^"]*"([^"]+)".*/\1/')"

update() {
  WIFI_STATUS="$(networksetup -getairportpower "$WIFI_INTERFACE" | awk '{print $NF}')"
  SSID="$(ipconfig getsummary "$WIFI_INTERFACE" 2>/dev/null | awk -F ' SSID : ' '/ SSID : /{print $2}')"
  VPN_ACTIVE="$(scutil --nc list 2>/dev/null | grep -c '(Connected)')"

  if [ "$WIFI_STATUS" = "On" ] && [ -n "$SSID" ]; then
    ICON="󰖩"
    COLOR=0xffffffff
  else
    ICON="󰖪"
    COLOR=0x60ffffff
  fi

  if [ "$VPN_ACTIVE" -gt 0 ]; then
    ICON="󰦝"
    COLOR=0xff98c379
  fi

  sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label.drawing=off
}

case "$1" in
  toggle_popup)
    sketchybar --set network popup.drawing=toggle
    ;;
  toggle_wifi)
    if [ "$(networksetup -getairportpower "$WIFI_INTERFACE" | awk '{print $NF}')" = "On" ]; then
      networksetup -setairportpower "$WIFI_INTERFACE" off
    else
      networksetup -setairportpower "$WIFI_INTERFACE" on
    fi
    update
    ;;
  toggle_vpn)
    if [ -n "$VPN_SERVICE" ]; then
      if scutil --nc status "$VPN_SERVICE" | grep -q "Connected"; then
        scutil --nc stop "$VPN_SERVICE"
      else
        scutil --nc start "$VPN_SERVICE"
      fi
    fi
    update
    ;;
  *)
    update
    ;;
esac

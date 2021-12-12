#!/bin/bash

PID=$(pgrep unclutter)

if [ "$PID" != "" ]; then
  kill "$PID"
  dunstify -a 'x11' -i '/usr/share/icons/dunst/system/location-disabled-symbolic.svg' 'unclutter stopped'
else
  unclutter --timeout 1 --ignore-scrolling &
  dunstify -a 'x11' -i '/usr/share/icons/dunst/system/location-active-symbolic.svg' 'unclutter started'
fi

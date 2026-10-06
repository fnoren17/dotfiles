#!/bin/bash

# Called from the lid switch binds in config/binds.lua.
#   close: docked (external screen connected) -> reload so config/monitors.lua
#          turns the laptop panel off; otherwise lock the session (logind
#          then suspends).
#   open:  reload so the laptop panel comes back on.
externalConnected() {
    grep -lx connected /sys/class/drm/card*-*/status 2>/dev/null | grep -qv eDP
}

case "$1" in
    close)
        if externalConnected; then
            hyprctl reload
        else
            noctalia msg session lock
        fi
        ;;
    open)
        hyprctl reload
        ;;
esac

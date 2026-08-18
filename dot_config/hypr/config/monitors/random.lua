-- Generated from this template by scripts/monitors.sh -> config/monitors_current.lua
-- Fallback for an unrecognized setup (multiple screens, none matching a known serial).

MONITOR1 = "eDP-1"
MONITOR2 = ""
MONITOR3 = ""

hl.monitor({ output = "eDP-1", mode = "3200x2000", position = "0x0", scale = "1.67" })

-- Generated from this template by scripts/monitors.sh -> config/monitors_current.lua
-- Home setup: laptop docked with LG UltraGear + ASUS externals.

MONITOR1 = "{{LG_SCREEN_NAME}}"
MONITOR2 = "{{ASUS_SCREEN_NAME}}"
MONITOR3 = "eDP-1"

hl.monitor({ output = "eDP-1", mode = "3200x2000", position = "0x0", scale = "1" })
hl.monitor({ output = MONITOR1, mode = "2560x1440@74.97", position = "3200x0", scale = "1" })
hl.monitor({ output = MONITOR2, mode = "1920x1080@60", position = "5760x0", scale = "1" })

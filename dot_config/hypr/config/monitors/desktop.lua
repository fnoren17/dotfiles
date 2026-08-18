-- Generated from this template by scripts/monitors.sh -> config/monitors_current.lua
-- Stationary desktop connected to the LG UltraGear + ASUS externals, no
-- laptop panel involved. Same physical monitors as the "home" (docked
-- laptop) setup, but arranged without an eDP-1 offset.

MONITOR1 = "{{LG_SCREEN_NAME}}"
MONITOR2 = "{{ASUS_SCREEN_NAME}}"
MONITOR3 = ""

hl.monitor({ output = MONITOR1, mode = "preferred", position = "0x0", scale = "1" })
hl.monitor({ output = MONITOR2, mode = "preferred", position = "2560x0", scale = "1" })

-- Generated from this template by scripts/monitors.sh -> config/monitors_current.lua
-- Work setup: laptop docked with 2x Philips + AOC externals.

MONITOR1 = "{{PHILIPS_SCREEN_NAME}}"
MONITOR2 = "{{PHILIPS_WITH_WEBCAM_SCREEN_NAME}}"
MONITOR3 = "{{AOC_SCREEN_NAME}}"

hl.monitor({ output = "eDP-1", mode = "3200x2000", position = "7040x0", scale = "1" })
hl.monitor({ output = MONITOR1, mode = "2560x1440@59.95", position = "0x0", scale = "1" })
hl.monitor({ output = MONITOR2, mode = "2560x1440@59.95", position = "2560x0", scale = "1" })
hl.monitor({ output = MONITOR3, mode = "1920x1080@60", position = "5120x0", scale = "1" })

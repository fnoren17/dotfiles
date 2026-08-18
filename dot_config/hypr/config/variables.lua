-- Hyprland default apps

TERMINAL     = "kitty"
FILE_MANAGER = "nautilus"
BROWSER      = "firefox"
EDITOR       = "gnome-text-editor --new-window"
CALCULATOR   = "gnome-calculator"

-- Monitors
-- scripts/monitors.sh identifies connected screens by serial number (port
-- names like DP-2 can be reassigned between boots) and generates
-- config/monitors_current.lua on every Hyprland start and screen hotplug.
-- These are just placeholders for the brief moment before that first run.
if not pcall(require, "config.monitors_current") then
    MONITOR1 = ""
    MONITOR2 = ""
    MONITOR3 = ""
end
PRIMARY_MONITOR = MONITOR1

-- Workspaces
NUM_WPM = 3 -- Number of workspaces per monitor (Max 10)

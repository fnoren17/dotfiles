#!/bin/bash

# Screen output names (DP-1, DP-2, ...) can be reassigned by the kernel/driver
# between boots, and the setup differs between work and home too. This script
# runs on every Hyprland start (and on hotplug, for portable machines) and
# identifies screens by their serial number instead, then generates the
# matching lua config on the fly.
CONFIG_DIR="$HOME/.config/hypr"

HOME_MONITOR_TEMPLATE="$CONFIG_DIR/config/monitors/home.lua"
DESKTOP_MONITOR_TEMPLATE="$CONFIG_DIR/config/monitors/desktop.lua"
WORK_MONITOR_TEMPLATE="$CONFIG_DIR/config/monitors/work.lua"
LAPTOP_MONITOR_TEMPLATE="$CONFIG_DIR/config/monitors/laptop.lua"
RANDOM_MONITOR_TEMPLATE="$CONFIG_DIR/config/monitors/random.lua"

HOME_WORKSPACE_TEMPLATE="$CONFIG_DIR/config/workspaces/home.lua"
DESKTOP_WORKSPACE_TEMPLATE="$CONFIG_DIR/config/workspaces/desktop.lua"
WORK_WORKSPACE_TEMPLATE="$CONFIG_DIR/config/workspaces/work.lua"
LAPTOP_WORKSPACE_TEMPLATE="$CONFIG_DIR/config/workspaces/laptop.lua"

CURRENT_MONITOR_CONFIG="$CONFIG_DIR/config/monitors_current.lua"
CURRENT_WORKSPACE_CONFIG="$CONFIG_DIR/config/workspaces_current.lua"

DEBOUNCE_INTERVAL=2  # Time interval in seconds for debounce
LAST_CALL_FILE="/tmp/monitor_event_last_call"  # Temporary file to track the last event time

HOME_LG_SERIAL_NUMBER="106NTGY1Y495"
HOME_ASUS_SERIAL_NUMBER="K9LMQS091019"

WORK_AOC_SERIAL_NUMBER="F54G8BA002503"
WORK_PHILIPS_WITH_WEBCAM_SERIAL_NUMBER="UHB1728049574"
WORK_PHILIPS_SERIAL_NUMBER="UHB1719039234"

# Render $1 (a lua template with {{PLACEHOLDER}} tokens) into $2, substituting
# each NAME=value pair passed after that. Writes via a temp file + mv so
# Hyprland never reads a half-written file.
renderTemplate() {
    local template="$1" target="$2"
    shift 2

    local sedArgs=()
    for pair in "$@"; do
        local name="${pair%%=*}" value="${pair#*=}"
        sedArgs+=(-e "s/{{${name}}}/${value}/g")
    done

    sed "${sedArgs[@]}" "$template" > "${target}.tmp"
    mv "${target}.tmp" "$target"
}

# Parse the "workspace = "N", monitor = "X"" pairs out of a rendered
# workspaces_current.lua and actively move each workspace - and any windows
# already open on it - to its assigned monitor. hl.workspace_rule() alone
# only affects newly created workspaces, so this is what makes an existing
# workspace move along the moment its location is (re)detected. Requires
# the target monitors to already be live, so must run after `hyprctl reload`.
moveWorkspaces() {
    local file="$1"
    while read -r ws mon; do
        # This build's hyprctl routes `dispatch` through its lua config
        # engine, so the classic "moveworkspacetomonitor $ws $mon" CLI form
        # no longer parses - it wants a real hl.dsp call, verified live:
        # hl.dsp.workspace.move({ workspace = N, monitor = "NAME" })
        hyprctl dispatch "hl.dsp.workspace.move({ workspace = ${ws}, monitor = \"${mon}\" })"
    done < <(sed -n -E 's/.*workspace = "([0-9]+)".*monitor = "([^"]+)".*/\1 \2/p' "$file")
}

configureMonitors() {
    LG_SCREEN_NAME=$(hyprctl monitors -j | jq -r --arg serial "$HOME_LG_SERIAL_NUMBER" '.[] | select(.description | test($serial)) | .name' | grep -v '^$')
    ASUS_SCREEN_NAME=$(hyprctl monitors -j | jq -r --arg serial "$HOME_ASUS_SERIAL_NUMBER" '.[] | select(.description | test($serial)) | .name' | grep -v '^$')

    PHILIPS_WITH_WEBCAM_SCREEN_NAME=$(hyprctl monitors -j | jq -r --arg serial "$WORK_PHILIPS_WITH_WEBCAM_SERIAL_NUMBER" '.[] | select(.description | test($serial)) | .name' | grep -v '^$')
    PHILIPS_SCREEN_NAME=$(hyprctl monitors -j | jq -r --arg serial "$WORK_PHILIPS_SERIAL_NUMBER" '.[] | select(.description | test($serial)) | .name' | grep -v '^$')
    AOC_SCREEN_NAME=$(hyprctl monitors -j | jq -r --arg serial "$WORK_AOC_SERIAL_NUMBER" '.[] | select(.description | test($serial)) | .name' | grep -v '^$')

    connected_monitors=$(hyprctl monitors -j | jq '. | length')
    edp_present=$(hyprctl monitors -j | jq -r '.[] | select(.name == "eDP-1") | .name')
    local workspaces_updated=0

    # LG + ASUS with a laptop panel too -> laptop docked at home
    if [ -n "$LG_SCREEN_NAME" ] && [ -n "$ASUS_SCREEN_NAME" ] && [ -n "$edp_present" ]; then
        renderTemplate "$HOME_MONITOR_TEMPLATE" "$CURRENT_MONITOR_CONFIG" \
            "LG_SCREEN_NAME=$LG_SCREEN_NAME" "ASUS_SCREEN_NAME=$ASUS_SCREEN_NAME"
        renderTemplate "$HOME_WORKSPACE_TEMPLATE" "$CURRENT_WORKSPACE_CONFIG" \
            "LG_MONITOR=$LG_SCREEN_NAME" "ASUS_MONITOR=$ASUS_SCREEN_NAME"
        workspaces_updated=1

    # LG + ASUS without a laptop panel -> the stationary desktop, permanently
    # wired to these same two monitors - this machine never hotplugs, it's
    # only here because these dotfiles are shared with the portable laptop
    # setups above/below. Workspace layout is fixed (1-5 on the LG, 6-10 on
    # the ASUS); still (re)render workspaces_current.lua every start since
    # output names (DP-2 vs DP-3) can shuffle between boots even with no
    # cable ever touched - this also overwrites any stale rules left behind
    # by a previous boot in a different mode (e.g. laptop-only, which pins
    # 1-5 to eDP-1). No workspaces_updated=1 / moveWorkspaces here though:
    # that's for reacting to a live hotplug event, which never happens on
    # this machine - a plain hl.workspace_rule() applied at the next full
    # Hyprland start (when workspaces get created fresh) is enough.
    elif [ -n "$LG_SCREEN_NAME" ] && [ -n "$ASUS_SCREEN_NAME" ]; then
        renderTemplate "$DESKTOP_MONITOR_TEMPLATE" "$CURRENT_MONITOR_CONFIG" \
            "LG_SCREEN_NAME=$LG_SCREEN_NAME" "ASUS_SCREEN_NAME=$ASUS_SCREEN_NAME"
        renderTemplate "$DESKTOP_WORKSPACE_TEMPLATE" "$CURRENT_WORKSPACE_CONFIG" \
            "LG_MONITOR=$LG_SCREEN_NAME" "ASUS_MONITOR=$ASUS_SCREEN_NAME"

    # If these monitors are connected, it's safe to assume we are on the work setup
    elif [ -n "$PHILIPS_WITH_WEBCAM_SCREEN_NAME" ] && [ -n "$PHILIPS_SCREEN_NAME" ] && [ -n "$AOC_SCREEN_NAME" ]; then
        renderTemplate "$WORK_MONITOR_TEMPLATE" "$CURRENT_MONITOR_CONFIG" \
            "PHILIPS_SCREEN_NAME=$PHILIPS_SCREEN_NAME" "PHILIPS_WITH_WEBCAM_SCREEN_NAME=$PHILIPS_WITH_WEBCAM_SCREEN_NAME" "AOC_SCREEN_NAME=$AOC_SCREEN_NAME"
        renderTemplate "$WORK_WORKSPACE_TEMPLATE" "$CURRENT_WORKSPACE_CONFIG" \
            "PHILIPS_MONITOR=$PHILIPS_SCREEN_NAME" "PHILIPS_WITH_WEBCAM_MONITOR=$PHILIPS_WITH_WEBCAM_SCREEN_NAME" "AOC_MONITOR=$AOC_SCREEN_NAME"
        workspaces_updated=1

    elif [ "$connected_monitors" -eq 1 ]; then
        cp "$LAPTOP_MONITOR_TEMPLATE" "$CURRENT_MONITOR_CONFIG"
        cp "$LAPTOP_WORKSPACE_TEMPLATE" "$CURRENT_WORKSPACE_CONFIG"
        workspaces_updated=1

    else
        # Unknown setup, use the random config. Leave workspace assignment
        # as-is since we don't know which screen should get which workspace.
        cp "$RANDOM_MONITOR_TEMPLATE" "$CURRENT_MONITOR_CONFIG"
    fi

    hyprctl reload

    # Actively relocate workspaces (and any windows already on them) to
    # match the layout just applied - not just newly created ones.
    if [ "$workspaces_updated" -eq 1 ]; then
        moveWorkspaces "$CURRENT_WORKSPACE_CONFIG"
    fi
}

# If multiple events come in within the debounce interval, only run `configureMonitors` from the last event
debounced_configure() {
    # Update the last event time
    touch "$LAST_CALL_FILE"

    # Start a background process that waits until the debounce period has passed with no new events
    (
        sleep "$DEBOUNCE_INTERVAL"

        # Check if the time since the last event is greater than or equal to the DEBOUNCE_INTERVAL
        if [[ $(($(date +%s) - $(stat -c %Y "$LAST_CALL_FILE"))) -ge "$DEBOUNCE_INTERVAL" ]]; then
            configureMonitors $1  # Run `configureMonitors` if no new event has come in
        fi
    ) &
}

# Handler function for `monitoraddedv2*` and `monitorremoved*` events
handle() {
    case $1 in
        monitoraddedv2* | monitorremoved*) debounced_configure "$1" ;;
    esac
}

# Run `configureMonitors` at startup
configureMonitors

# Start socat and listen for events on the socket
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    handle "$line"
done

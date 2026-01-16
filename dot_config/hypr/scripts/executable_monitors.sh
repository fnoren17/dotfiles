#!/bin/bash

CONFIG_DIR="$HOME/.config/hypr"

HOME_MONITOR_SETUP="$CONFIG_DIR/monitors/home.conf"
WORK_MONITOR_SETUP="$CONFIG_DIR/monitors/work.conf"
LAPTOP_MONITOR_SETUP="$CONFIG_DIR/monitors/laptop.conf"
RANDOM_MONITOR_SETUP="$CONFIG_DIR/monitors/random.conf"

HOME_WORKSPACE_SETUP="$CONFIG_DIR/workspaces/home.conf"
LAPTOP_WORKSPACE_SETUP="$CONFIG_DIR/workspaces/laptop.conf"
WORK_WORKSPACE_SETUP="$CONFIG_DIR/workspaces/work.conf"

CURRENT_MONITOR_CONFIG="$CONFIG_DIR/monitors/current.conf"
CURRENT_WORKSPACE_CONFIG="$CONFIG_DIR/workspaces/current.conf"
TEMP_WORKSPACE_CONFIG="$CONFIG_DIR/workspaces/temp_current.conf"


DEBOUNCE_INTERVAL=2  # Time interval in seconds for debounce
LAST_CALL_FILE="/tmp/monitor_event_last_call"  # Temporary file to track the last event time

HOME_LG_SERIAL_NUMBER="106NTGY1Y495"
HOME_ASUS_SERIAL_NUMBER="K9LMQS091019"

WORK_AOC_SERIAL_NUMBER="F54G8BA002503"
WORK_PHILIPS_WITH_WEBCAM_SERIAL_NUMBER="UHB1728049574"
WORK_PHILIPS_SERIAL_NUMBER="UHB1719039234"

moveworkspaces() {
    while IFS= read -r line; do
    # Extrahera workspace-nummer och monitor från raden
        workspace=$(echo "$line" | grep -oP 'workspace = \K\d+')
        monitor=$(echo "$line" | grep -oP 'monitor:\K\w+-?\w*')

        echo "workspace: $workspace, monitor: $monitor"

    # Run hyprctl command to move each workspace to the specified monitor
    hyprctl dispatch moveworkspacetomonitor "$workspace" "$monitor"

done < "$CURRENT_WORKSPACE_CONFIG"
}

configureMonitors() {
    internal_monitor="monitor = eDP-1,3200x2000,0x0, 1"

    LG_SCREEN_NAME=$(hyprctl monitors -j | jq -r --arg serial "$HOME_LG_SERIAL_NUMBER" '.[] | select(.description | test($serial)) | .name' | grep -v '^$')
    ASUS_SCREEN_NAME=$(hyprctl monitors -j | jq -r --arg serial "$HOME_ASUS_SERIAL_NUMBER" '.[] | select(.description | test($serial)) | .name' | grep -v '^$')

    PHILIPS_WITH_WEBCAM_SCREEN_NAME=$(hyprctl monitors -j | jq -r --arg serial "$WORK_PHILIPS_WITH_WEBCAM_SERIAL_NUMBER" '.[] | select(.description | test($serial)) | .name' | grep -v '^$')
    PHILIPS_SCREEN_NAME=$(hyprctl monitors -j | jq -r --arg serial "$WORK_PHILIPS_SERIAL_NUMBER" '.[] | select(.description | test($serial)) | .name' | grep -v '^$')
    AOC_SCREEN_NAME=$(hyprctl monitors -j | jq -r --arg serial "$WORK_AOC_SERIAL_NUMBER" '.[] | select(.description | test($serial)) | .name' | grep -v '^$')



    connected_monitors=$(hyprctl monitors -j | jq '. | length')
    # If LG and ASUS monitors with the predefined serial numbers are connected
    # It's quite safe to say that we are on the home setup
    if [ -n "$LG_SCREEN_NAME" ] && [ -n "$ASUS_SCREEN_NAME" ]; then
        LG_SETTINGS="2560x1440@74.97, 3200x0, 1"
        ASUS_SETTINGS="1920x1080@60, 5760x0, 1"
        echo "$internal_monitor" > "$HOME_MONITOR_SETUP"
        echo "monitor = $LG_SCREEN_NAME, $LG_SETTINGS" >> "$HOME_MONITOR_SETUP"
        echo "monitor = $ASUS_SCREEN_NAME, $ASUS_SETTINGS" >> "$HOME_MONITOR_SETUP"
        ln -sf "$HOME_MONITOR_SETUP" "$CURRENT_MONITOR_CONFIG"

        # Create a temporary workspace config file, replace {{LG_MONITOR}}
        # and {{ASUS_MONITOR}} with the actual monitor names
        # and then link it as the current workspace config
        sed -e "s/{{LG_MONITOR}}/$LG_SCREEN_NAME/g" \
            -e "s/{{ASUS_MONITOR}}/$ASUS_SCREEN_NAME/g" \
        "$HOME_WORKSPACE_SETUP" > "$TEMP_WORKSPACE_CONFIG"
        ln -sf "$TEMP_WORKSPACE_CONFIG" "$CURRENT_WORKSPACE_CONFIG"

    # If these monitors are connected, it's safe to assume we are on the work setup
    elif [ -n "$PHILIPS_WITH_WEBCAM_SCREEN_NAME" ] && [ -n "$PHILIPS_SCREEN_NAME" ] && [ -n "$AOC_SCREEN_NAME" ]; then
        PHILIPS_SETTINGS="2560x1440@59.95, 0x0, 1"
        PHILIPS_WITH_WEBCAM_SETTINGS="2560x1440@59.95, 2560x0, 1"
        AOC_SETTINGS="1920x1080@60, 5120x0, 1"
        INTERNAL_MONITOR="monitor = eDP-1,3200x2000,7000x0, 1"


        echo $INTERNAL_MONITOR > "$WORK_MONITOR_SETUP"
        echo "monitor = $PHILIPS_SCREEN_NAME, $PHILIPS_SETTINGS" >> "$WORK_MONITOR_SETUP"
        echo "monitor = $PHILIPS_WITH_WEBCAM_SCREEN_NAME, $PHILIPS_WITH_WEBCAM_SETTINGS" >> "$WORK_MONITOR_SETUP"
        echo "monitor = $AOC_SCREEN_NAME, $AOC_SETTINGS" >> "$WORK_MONITOR_SETUP"

        ln -sf "$WORK_MONITOR_SETUP" "$CURRENT_MONITOR_CONFIG"

        # Create a temporary workspace config file, replace {{PHILIPS_MONITOR}}
        # and {{PHILIPS_WITH_WEBCAM_MONITOR}} with the actual monitor names
        # and then link it as the current workspace config
        sed -e "s/{{PHILIPS_MONITOR}}/$PHILIPS_SCREEN_NAME/g" \
            -e "s/{{PHILIPS_WITH_WEBCAM_MONITOR}}/$PHILIPS_WITH_WEBCAM_SCREEN_NAME/g" \
            -e "s/{{AOC_MONITOR}}/$AOC_SCREEN_NAME/g" \
        "$WORK_WORKSPACE_SETUP" > "$TEMP_WORKSPACE_CONFIG"

        ln -sf "$TEMP_WORKSPACE_CONFIG" "$CURRENT_WORKSPACE_CONFIG"

    elif [ $connected_monitors -eq 1 ]; then
        echo "$internal_monitor" > "$LAPTOP_MONITOR_SETUP"
        ln -sf "$LAPTOP_MONITOR_SETUP" "$CURRENT_MONITOR_CONFIG"
        ln -sf "$LAPTOP_WORKSPACE_SETUP" "$CURRENT_WORKSPACE_CONFIG"

    else
        # Unknown setup, use the random config
        ln -sf "$RANDOM_MONITOR_SETUP" "$CURRENT_MONITOR_CONFIG"

    fi

    # moveworkspaces

    hyprctl reload
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

#!/usr/bin/env bash

desktop_file=$(xdg-settings get default-web-browser)

declare -A desktop_to_class=(
  ["firefox.desktop"]="firefox"
  ["google-chrome.desktop"]="Google-chrome"
  ["chromium.desktop"]="chromium"
  ["brave-browser.desktop"]="Brave-browser"
  ["vivaldi-stable.desktop"]="Vivaldi-stable"
)

browser_class="${desktop_to_class[$desktop_file]}"

if [[ -z "$browser_class" ]]; then
    notify-send "Okänd standardwebbläsare: $desktop_file"
    exit 1
fi

clients=$(hyprctl clients -j)

match=$(echo "$clients" | jq -c --arg class "$browser_class" '
  [ .[] | select(.class == $class) | {workspace_id: .workspace.id, monitor: .monitor} ] | first
')

# Kontrollera att match faktiskt är ett objekt
if echo "$match" | jq -e 'type == "object"' > /dev/null 2>&1; then
    workspace_id=$(echo "$match" | jq -r '.workspace_id')
    monitor=$(echo "$match" | jq -r '.monitor')

    hyprctl dispatch focusmonitor "$monitor"
    hyprctl dispatch workspace "$workspace_id"
else
    notify-send "Startar standardwebbläsare: $browser_class"
    xdg-open https://app.daily.dev
    exit 0
fi

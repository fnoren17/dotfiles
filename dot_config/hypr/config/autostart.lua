-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")

    -- From hyprland.conf (hyprpanel and hyprpaper skipped, noctalia handles the panel/shell and wallpaper)
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    -- Detects connected screens by serial and (re)generates the monitor +
    -- workspace lua config - see scripts/monitors.sh
    hl.exec_cmd("$HOME/.config/hypr/scripts/monitors.sh")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Sweet-Dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'candy-icons'")
end)

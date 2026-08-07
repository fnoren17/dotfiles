source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Theming
set -gx GTK_THEME 'Sweet-Dark'
set -gx GTK2_RC_FILES $HOME/.themes/Sweet-Dark-v40/gtk-2.0/gtkrc
set -gx QT_STYLE_OVERRIDE 'Sweet-Dark-v40'
set -gx QT_STYLE_OVERRIDE kvantum-dark
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx LC_ALL en_US.UTF-8
set -gx INFISICAL_API_URL 'http://infisical.dev.pipechain.net/api'
set -gx KEYID 6A80298DE99F101E
set -gx HYPRSHOT_DIR $HOME/Pictures/screenshots

# PATH (highest priority first; SSH_AUTH_SOCK for gpg-agent is set globally
# via ~/.config/environment.d/10-gnupg-ssh.conf, not here)
set -gx N_PREFIX $HOME/.n
set -gx PNPM_HOME $HOME/.local/share/pnpm
set -q ASDF_DATA_DIR; or set -gx ASDF_DATA_DIR $HOME/.asdf
fish_add_path $HOME/.local/bin $PNPM_HOME "$ASDF_DATA_DIR/shims" $HOME/bin \
    $HOME/.config/rofi/scripts $HOME/.npm-global/bin $N_PREFIX/bin

if status is-interactive
    # gpg-agent pinentry needs to know which tty is currently in front
    set -gx GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null

    starship init fish | source

    # Completions
    test -f $HOME/.config/.dart-cli-completion/fish-config.fish
    and source $HOME/.config/.dart-cli-completion/fish-config.fish

    test -s $HOME/.bun/_bun.fish
    and source $HOME/.bun/_bun.fish
end

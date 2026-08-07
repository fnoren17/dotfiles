# dotfiles

Personal dotfiles for a [CachyOS](https://cachyos.org/) + [Hyprland](https://hyprland.org/) desktop, managed with [chezmoi](https://www.chezmoi.io).

## Install

```sh
chezmoi init --apply fnoren17/dotfiles
```

Review changes before they land on a machine:

```sh
chezmoi diff
chezmoi apply
```

## What's in here

| Path | Covers |
|---|---|
| `dot_config/fish/` | Default shell config, built on top of CachyOS's shared fish config (aliases, PATH, greeting). Sets theming/env vars, starship prompt, gpg-agent TTY wiring, and completions. |
| `dot_config/environment.d/` | `systemd --user` environment (currently: points `SSH_AUTH_SOCK` at gpg-agent's ssh socket so it's available session-wide, not just in a shell). |
| `dot_zshrc`, `dot_oh-my-zsh/` | Legacy zsh + oh-my-zsh setup, kept around alongside the fish config. |
| `dot_config/hypr/` | Hyprland config (Lua-based, via CachyOS's `hyprland.lua` module loader), hyprlock, hyprpaper, hypridle, monitor/workspace layout, helper scripts. |
| `dot_config/starship/` | Prompt config ([starship.rs](https://starship.rs)). |
| `dot_config/kitty/` | Terminal emulator config. |
| `dot_config/nvim/` | Neovim config (Lua, lazy.nvim plugin manager). |
| `dot_config/rofi/` | App launcher / powermenu themes and scripts. |
| `dot_config/private_VSCodium/`, `dot_config/private_gtk-3.0/`, `dot_config/gtk-4.0/` | Editor settings and GTK theming (`private_` prefix keeps file perms `0600`). |
| `dot_config/yubikey-touch-detector/` | Desktop notification when the YubiKey is waiting for a touch. |
| `dot_config/xdg-desktop-portal/` | Portal backend config for screen sharing/screenshots under Hyprland. |

Machine-specific files (current monitor/workspace layout) are excluded via `.chezmoiignore` and generated locally instead of tracked.

## GPG / YubiKey SSH auth

SSH auth uses a key on a YubiKey via `gpg-agent`'s ssh-agent emulation instead of `ssh-agent`:

- `gpg-agent-ssh.socket` (systemd socket activation) starts the agent on demand — nothing needs to launch it manually.
- `dot_config/environment.d/10-gnupg-ssh.conf` exports `SSH_AUTH_SOCK` for the whole systemd user session, so GUI apps and anything the compositor launches pick it up too, not just interactive shells.
- `dot_config/fish/config.fish` sets `GPG_TTY` and runs `gpg-connect-agent updatestartuptty` per interactive shell, so pinentry prompts show up in the right terminal.

## Useful commands

```sh
chezmoi edit ~/.config/fish/config.fish   # edit the source file (opens in codium, per .chezmoi.toml.tmpl)
chezmoi cd                                # jump into the source dir
chezmoi status                            # what's changed vs. what's applied
```

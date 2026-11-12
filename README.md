# Dotfiles

My personal Linux desktop and development environment configuration files.

## Environment

* OS: Fedora Linux
* Shell: Zsh (oh-my-zsh) + tmux
* Terminal: Alacritty
* Editor: Neovim
* Window Manager: Sway
* Status Bar: Waybar
* Launcher: Wofi
* Notifications: Mako
* Prompt: Starship
* File Manager: Yazi

## Repository Structure

```text
.
├── alacritty/
├── bin/          # custom scripts, linked into ~/.local/bin by install.sh
├── eww/
├── tmux.conf
├── mako/
├── nvim/
├── sway/
├── waybar/
├── wofi/
├── yazi/
├── install.sh
├── starship.toml
└── wallpapers/
```

## Scripts

Custom scripts live in `bin/<group>/` and are symlinked (flat) into `~/.local/bin`, so configs call them as `~/.local/bin/<name>`:

| Group | Scripts |
|---|---|
| `desktop/` | `wallpaper-pick` (Mod+W), `wallpaper-set`, `clock-start`, `clock-colors`, `notify-focused` |
| `capture/` | `screenshot`, `screen-record` |
| `system/` | `power-profile`, `power-profile-menu`, `session-menu`, `brightness`, `dev-cleanup` |
| `sway/` | `sway-launch` (login session), `workspace-toggle`, `keyboard-layout-next` |
| `media/` | `video-browser`, `yt-download` |

To add a script, drop it into the matching `bin/<group>/` and run `./install.sh --links`.

## Installation (Fedora 41+)

```bash
git clone https://github.com/m-elhabib-dev/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Then log out and pick **Sway** on the login screen (or run `sway-launch` from a TTY).

`install.sh` sets up everything in one go and is safe to re-run:

- links the configs into `~/.config`, `.zshrc` and `tmux.conf` into `~`, and `bin/*/*` into `~/.local/bin` (anything it replaces is kept as `<name>.bak`)
- enables RPM Fusion and the swayosd/yazi COPRs, installs every package the configs and scripts use
- installs Rust (rust-analyzer, rustfmt, stylua) and builds eww
- oh-my-zsh + zsh-autosuggestions/zsh-syntax-highlighting, zsh as login shell, `/etc/doas.conf` (`sudo` is aliased to `doas`)
- tmux plugins, the MacTahoe GTK/icon/cursor themes (as `Tahoe-Neo`), JetBrainsMono Nerd Font, the default wallpaper (`wallpapers/hp.jpg` → `~/sources/wallpapers`)
- Neovim plugins (pinned by `nvim/lazy-lock.json`)

A step that fails doesn't stop the run; failed steps are listed at the end. `./install.sh --links` only redoes the linking.

## Included Configurations

### Neovim

* Lazy.nvim package manager
* LSP support
* Treesitter
* Autocompletion
* Telescope
* Git integration
* Rust development tools

### Sway

* Wayland compositor configuration
* Workspace management
* Keybindings
* Multi-monitor support

### Waybar

* Custom modules
* System monitoring
* Workspace indicators

### Terminal

* Alacritty configuration
* Starship prompt
* Zsh + tmux

## License

This repository is provided as-is for personal reference and learning.


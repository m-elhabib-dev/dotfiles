# Dotfiles

My personal Linux desktop and development environment configuration files.

## Environment

* OS: Fedora Linux
* Shell: Fish
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
├── fish/
├── mako/
├── nvim/
├── sway/
├── waybar/
├── wofi/
├── yazi/
├── install.sh
└── starship.toml
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

On a new machine, clone this repo as `~/.config` and run:

```bash
~/.config/install.sh
```

It links every `bin/*/*` script into `~/.local/bin` and `.zshrc` into `~`, keeps any file it replaces as `<name>.bak`, and removes links left by renamed scripts. To add a script, drop it into the matching `bin/<group>/` and re-run `install.sh`.

## Installation

Clone the repository:

```bash
git clone https://github.com/m-elhabib-dev/dotfiles.git
cd dotfiles
```

Create symbolic links:

```bash
ln -sf $(pwd)/nvim ~/.config/nvim
ln -sf $(pwd)/alacritty ~/.config/alacritty
ln -sf $(pwd)/fish ~/.config/fish
ln -sf $(pwd)/sway ~/.config/sway
ln -sf $(pwd)/waybar ~/.config/waybar
ln -sf $(pwd)/wofi ~/.config/wofi
ln -sf $(pwd)/mako ~/.config/mako
ln -sf $(pwd)/yazi ~/.config/yazi
ln -sf $(pwd)/starship.toml ~/.config/starship.toml
```

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
* Fish shell customizations

## License

This repository is provided as-is for personal reference and learning.


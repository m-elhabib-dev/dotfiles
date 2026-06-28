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
├── fish/
├── mako/
├── nvim/
├── sway/
├── waybar/
├── wofi/
├── yazi/
└── starship.toml
```

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


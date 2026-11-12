#!/bin/bash
# Set up this Sway desktop on a Fedora machine: packages, configs, shell, themes, fonts.
#
#   ./install.sh          full setup (safe to re-run; finished steps are skipped)
#   ./install.sh --links  only (re)link configs and bin/ scripts
#
# Clone the repo anywhere (e.g. ~/dotfiles). Configs are symlinked into ~/.config;
# anything they replace is kept as <name>.bak. A failed step is reported at the end
# instead of stopping the run.
set -u
cd "$(dirname "$(readlink -f "$0")")"
REPO=$PWD

bold() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m    %s\033[0m\n' "$*"; }
has() { command -v "$1" >/dev/null 2>&1; }

failed=() notes=()
step() {  # step <description> <function>
    bold "$1"
    "$2" || { failed+=("$1"); warn "FAILED: $1 (continuing)"; }
}

link() {  # link <repo path> <target>
    local src="$REPO/$1" dst="$2" bak
    [[ -L $dst && $(readlink "$dst") == "$src" ]] && return
    if [[ -e $dst || -L $dst ]]; then
        bak="$dst.bak"
        [[ -e $bak || -L $bak ]] && bak="$dst.bak.$(date +%s)"
        mv "$dst" "$bak" && echo "backed up $dst -> $bak"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst" && echo "linked $dst"
}

# --- links ----------------------------------------------------------------

link_all() {
    # configs (no-op when the repo itself is ~/.config)
    if [[ $REPO != "$HOME/.config" ]]; then
        for c in alacritty eww kitty mako nvim sway waybar wofi yazi starship.toml; do
            [[ -e $c ]] && link "$c" "$HOME/.config/$c"
        done
    fi
    link .zshrc "$HOME/.zshrc"
    link tmux/tmux.conf "$HOME/.tmux.conf"

    chmod +x bin/*/* waybar/scripts/*
    for f in bin/*/*; do link "$f" "$HOME/.local/bin/${f##*/}"; done
    # drop links left behind by renamed/removed scripts
    find "$HOME/.local/bin" -maxdepth 1 -xtype l -lname "$REPO/*" -print -delete
}

if [[ ${1:-} == --links ]]; then
    link_all
    exit
fi

# --- preflight ------------------------------------------------------------

. /etc/os-release 2>/dev/null
if [[ ${ID:-} != fedora ]]; then
    echo "This installer only supports Fedora (found: ${PRETTY_NAME:-unknown})." >&2
    exit 1
fi
if ! has dnf5; then
    echo "dnf5 not found: Fedora 41 or newer is required." >&2
    exit 1
fi
if [[ $EUID -eq 0 ]]; then
    echo "Run this as your normal user, not root (it asks for sudo when needed)." >&2
    exit 1
fi
echo "This sets up Sway + these dotfiles for $USER. You will be asked for your sudo password."
sudo -v || exit 1
# keep sudo alive until the script exits
while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &

has_nvidia() { grep -qs 0x10de /sys/bus/pci/devices/*/vendor; }
FEDORA=$(rpm -E %fedora)

# --- steps ----------------------------------------------------------------

repos() {
    sudo dnf5 install -y dnf5-plugins || return 1
    rpm -q rpmfusion-free-release rpmfusion-nonfree-release >/dev/null 2>&1 ||
        sudo dnf5 install -y \
            "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA.noarch.rpm" \
            "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA.noarch.rpm" ||
        return 1
    local coprs=(erikreider/swayosd lihaohong/yazi) c rc=0
    has_nvidia && coprs+=(sunwire/envycontrol)
    for c in "${coprs[@]}"; do
        sudo dnf5 copr enable -y "$c" || { warn "could not enable COPR $c"; rc=1; }
    done
    return $rc
}

PACKAGES=(
    # desktop
    sway swaybg swaylock waybar wofi mako kanshi swayosd gammastep clipman blueman
    pavucontrol xdg-desktop-portal-wlr nautilus firefox
    # terminal / cli
    kitty alacritty neovim tmux zsh git curl unzip jq zoxide fzf eza fastfetch btop yazi
    opendoas ripgrep fd-find gcc gcc-c++ make
    # media / capture
    grim slurp swappy wl-clipboard wf-recorder ImageMagick mpv yt-dlp libnotify pulseaudio-utils
    # system (power-profile, brightness, hub-dim)
    brightnessctl ddcutil tuned powertop iw upower util-linux python3-gobject python3-cairo
    gtk-layer-shell
    # fonts
    jetbrains-mono-fonts-all fontawesome-6-free-fonts fontawesome-6-brands-fonts fontconfig
    # build deps: eww, MacTahoe theme
    gtk3-devel gtk-layer-shell-devel pango-devel cairo-devel cairo-gobject-devel
    gdk-pixbuf2-devel glib2-devel libdbusmenu-gtk3-devel sassc libxml2
)

packages() {
    local pkgs=("${PACKAGES[@]}")
    has_nvidia && pkgs+=(envycontrol)
    sudo dnf5 install -y --skip-unavailable --skip-broken "${pkgs[@]}" || return 1
    # full ffmpeg (H.264/AAC for screen-record) from RPM Fusion replaces Fedora's ffmpeg-free
    if rpm -q ffmpeg-free >/dev/null 2>&1; then
        sudo dnf5 swap -y ffmpeg-free ffmpeg --allowerasing
    else
        sudo dnf5 install -y ffmpeg
    fi
}

rust_tools() {
    if ! has cargo && [[ ! -x $HOME/.cargo/bin/cargo ]]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || return 1
    fi
    . "$HOME/.cargo/env" 2>/dev/null
    rustup component add rust-analyzer rustfmt clippy || return 1
    has stylua || cargo install --locked stylua || return 1
    if ! has eww; then
        echo "building eww (takes a few minutes)..."
        cargo install --locked --git https://github.com/elkowar/eww \
            --no-default-features --features wayland eww || return 1
    fi
    # sway starts eww from its own environment, where ~/.cargo/bin may not be on PATH
    [[ -x /usr/local/bin/eww ]] || sudo install -m 755 "$HOME/.cargo/bin/eww" /usr/local/bin/eww
}

shell() {
    if [[ ! -d $HOME/.oh-my-zsh ]]; then
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
            "" --unattended || return 1
    fi
    local custom=$HOME/.oh-my-zsh/custom/plugins p
    for p in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting; do
        [[ -d $custom/${p#*/} ]] || git clone --depth=1 "https://github.com/$p" "$custom/${p#*/}" || return 1
    done
    [[ $(getent passwd "$USER" | cut -d: -f7) == */zsh ]] || sudo usermod -s /usr/bin/zsh "$USER"
}

doas_conf() {
    # .zshrc aliases sudo=doas, and sway runs `doas ddcutil`
    if ! sudo test -e /etc/doas.conf; then
        echo 'permit persist :wheel' | sudo tee /etc/doas.conf >/dev/null &&
            sudo chown root:root /etc/doas.conf && sudo chmod 0400 /etc/doas.conf || return 1
        echo "wrote /etc/doas.conf (permit persist :wheel)"
    fi
    id -nG "$USER" | grep -qw wheel ||
        notes+=("$USER is not in the wheel group, so doas (and the sudo alias in zsh) won't work: sudo usermod -aG wheel $USER")
}

tmux_plugins() {
    # clone the @plugin entries from tmux.conf directly (what tpm's prefix+I would do)
    local dir=$HOME/.tmux/plugins p rc=0
    mkdir -p "$dir"
    for p in $(grep -oP "^set -g @plugin '\K[^']+" tmux/tmux.conf); do
        [[ -d $dir/${p#*/} ]] || git clone --depth=1 "https://github.com/$p" "$dir/${p#*/}" || rc=1
    done
    return $rc
}

themes() {
    local tmp rc=0
    tmp=$(mktemp -d)
    # MacTahoe GTK + icon/cursor themes, installed under the names sway/config sets
    if [[ ! -d $HOME/.local/share/themes/Tahoe-Neo-Dark ]]; then
        git clone --depth=1 https://github.com/vinceliuice/MacTahoe-gtk-theme "$tmp/gtk" &&
            (cd "$tmp/gtk" && bash ./install.sh -n Tahoe-Neo -d "$HOME/.local/share/themes" </dev/null) || rc=1
    fi
    if [[ ! -d $HOME/.local/share/icons/Tahoe-Neo ]]; then
        git clone --depth=1 https://github.com/vinceliuice/MacTahoe-icon-theme "$tmp/icon" &&
            (cd "$tmp/icon" && bash ./install.sh -n Tahoe-Neo -d "$HOME/.local/share/icons" </dev/null) || rc=1
    fi
    rm -rf "$tmp"
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark 2>/dev/null
    return $rc
}

fonts() {
    # JetBrainsMono Nerd Font (kitty). JetBrains Mono + Font Awesome come from dnf.
    if ! fc-list | grep -q "JetBrainsMono Nerd Font"; then
        local dir=$HOME/.local/share/fonts/JetBrainsMonoNerd tmp
        tmp=$(mktemp -d)
        curl -fL -o "$tmp/f.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip &&
            mkdir -p "$dir" && unzip -oq "$tmp/f.zip" -d "$dir" || { rm -rf "$tmp"; return 1; }
        rm -rf "$tmp"
        fc-cache -f
    fi
    fc-list | grep -q "SF Pro Display" ||
        notes+=("SF Pro Display (wofi/mako font) is Apple-licensed and not installed; those fall back to sans-serif")
}

wallpaper() {
    local dir=$HOME/sources/wallpapers
    mkdir -p "$dir" && cp --update=none wallpapers/* "$dir/" || return 1
    # point sway at the bundled wallpaper unless the saved one exists on this machine
    [[ -f $(cat sway/wallpaper 2>/dev/null) ]] || printf '%s\n' "$dir/hp.jpg" > sway/wallpaper
}

services() {
    sudo systemctl enable --now tuned bluetooth
}

nvim_plugins() {
    nvim --headless "+Lazy! restore" +qa
}

# --- run ------------------------------------------------------------------

step "Linking configs and scripts" link_all
step "Enabling RPM Fusion and COPR repos" repos
step "Installing packages" packages
step "Installing Rust, stylua and eww" rust_tools
step "Setting up zsh + oh-my-zsh" shell
step "Configuring doas" doas_conf
step "Installing tmux plugins" tmux_plugins
step "Installing GTK, icon and cursor themes" themes
step "Installing fonts" fonts
step "Installing wallpaper" wallpaper
step "Enabling services" services
step "Installing Neovim plugins" nvim_plugins

has_nvidia && ! has nvidia-smi &&
    notes+=("NVIDIA GPU found but no driver: install akmod-nvidia from RPM Fusion yourself if you want it (mind Secure Boot)")
notes+=("Not installed (personal apps the sway config starts if present): Slack, Google Chrome, patrak")
notes+=("kanshi and power-profile are tuned for the original laptop (Dell, HP monitor); edit sway/kanshi for your screens")

bold "Done"
if ((${#failed[@]})); then
    warn "These steps failed (re-run ./install.sh to retry):"
    printf '      - %s\n' "${failed[@]}"
fi
echo "Notes:"
printf '  - %s\n' "${notes[@]}"
cat <<'EOF'

Next: log out, pick "Sway" on the login screen (or run `sway-launch` from a TTY).
Super+Enter opens a terminal, Super+D the app launcher, Super+Shift+C reloads sway.
EOF

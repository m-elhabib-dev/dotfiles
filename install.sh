#!/bin/bash
# Symlink tracked scripts into ~/.local/bin and dotfiles into $HOME.
# Safe to re-run; an existing non-link file is kept as <name>.bak.
cd "$(dirname "$(readlink -f "$0")")"

link() {  # link <repo path> <target>
    local src="$PWD/$1" dst="$2"
    [[ -L $dst && $(readlink "$dst") == "$src" ]] && return
    [[ -e $dst || -L $dst ]] && mv "$dst" "$dst.bak"
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst" && echo "linked $dst"
}

chmod +x bin/*/*
for f in bin/*/*; do link "$f" "$HOME/.local/bin/${f##*/}"; done
link .zshrc "$HOME/.zshrc"

# drop links left behind by renamed/removed scripts
find "$HOME/.local/bin" -maxdepth 1 -xtype l -lname "$PWD/*" -print -delete

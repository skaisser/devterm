#!/usr/bin/env bash
# lib/install/omp.sh — Oh My Posh + skaisser theme

install_omp() {
    # Install Oh My Posh
    if command -v oh-my-posh &>/dev/null; then
        ok "Oh My Posh already installed ($(oh-my-posh version))"
    else
        gum spin --spinner dot --title "Installing Oh My Posh..." -- \
            brew install oh-my-posh
        ok "Oh My Posh installed"
    fi

    # Install skaisser theme
    mkdir -p "$HOME/.zsh/themes"

    local src="$DEVTERM_DIR/assets/skaisser.omp.json"
    local dst="$HOME/.zsh/themes/skaisser.omp.json"

    if [[ -f "$dst" ]]; then
        if gum confirm "  skaisser.omp.json already exists — overwrite?"; then
            cp "$src" "$dst"
            ok "skaisser theme updated → $dst"
        else
            info "Skipped theme overwrite"
        fi
    else
        if [[ ! -f "$src" ]]; then
            err "Theme file not found: $src"
            return
        fi
        cp "$src" "$dst"
        ok "skaisser theme installed → $dst"
    fi
}

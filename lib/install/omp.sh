#!/usr/bin/env bash
# lib/install/omp.sh — Oh My Posh + skaisser theme

install_omp() {
    # Install Oh My Posh
    if formula_installed "oh-my-posh"; then
        ok "Oh My Posh already installed ($(oh-my-posh version 2>/dev/null || echo 'unknown'))"
        track_skipped "Oh My Posh"
    else
        info "Installing Oh My Posh..."
        brew install oh-my-posh

        if command -v oh-my-posh &>/dev/null; then
            ok "Oh My Posh installed"
            track_installed "Oh My Posh"
        else
            err "Oh My Posh failed to install"
            track_failed "Oh My Posh"
            return
        fi
    fi

    # Install skaisser theme
    mkdir -p "$HOME/.zsh/themes"

    local src="$DEVTERM_DIR/assets/skaisser.omp.json"
    local dst="$HOME/.zsh/themes/skaisser.omp.json"

    if [[ ! -f "$src" ]]; then
        err "Theme file not found: $src"
        track_failed "OMP Theme"
        return
    fi

    # Backup existing theme before overwriting
    if [[ -f "$dst" ]]; then
        local bak
        bak="$(backup_file "$dst")"
        info "Backed up existing theme → $bak"
    fi

    cp "$src" "$dst"
    ok "skaisser theme installed → $dst"
    track_installed "OMP Theme"
}

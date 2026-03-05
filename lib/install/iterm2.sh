#!/usr/bin/env bash
# lib/install/iterm2.sh

install_iterm2() {
    if [[ -d "/Applications/iTerm.app" ]]; then
        ok "iTerm2 already installed"
        return
    fi

    gum spin --spinner dot --title "Installing iTerm2..." -- \
        brew install --cask iterm2

    ok "iTerm2 installed"
    info "Launch iTerm2 and re-run the installer, or continue and configure manually"
}

install_vscode() {
    if [[ -d "/Applications/Visual Studio Code.app" ]]; then
        ok "VS Code already installed"
        return
    fi

    gum spin --spinner dot --title "Installing VS Code..." -- \
        brew install --cask visual-studio-code

    ok "VS Code installed"
    info "The 'code' CLI command is available after restarting your terminal"
}

install_iterm2_colors() {
    local preset="$DEVTERM_DIR/assets/skaisser.itermcolors"

    if [[ ! -f "$preset" ]]; then
        err "Color preset not found: $preset"
        return
    fi

    if [[ ! -d "/Applications/iTerm.app" ]]; then
        err "iTerm2 not installed — install iTerm2 first, then re-run this step"
        return
    fi

    # Open with iTerm2 explicitly — it registers .itermcolors as its file handler
    # and imports the color preset automatically on open
    open -a "iTerm" "$preset"

    ok "iTerm2 color preset imported"
    info "In iTerm2: Preferences → Profiles → Colors → Color Presets → skaisser"
}

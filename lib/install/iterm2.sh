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

    # Open with iTerm2 — it handles .itermcolors natively and registers the preset
    open "$preset"

    ok "iTerm2 color preset imported"
    info "In iTerm2: Settings → Profiles → Colors → Color Presets → skaisser"
}

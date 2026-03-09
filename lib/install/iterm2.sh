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

    if [[ ! -d "/Applications/iTerm.app" ]]; then
        err "iTerm2 not installed — install iTerm2 first, then re-run this step"
        return
    fi

    # Copy preset directly into iTerm2's color presets directory (reliable, no dialog needed)
    local presets_dir="$HOME/Library/Application Support/iTerm2/ColorPresets"
    mkdir -p "$presets_dir"
    cp "$preset" "$presets_dir/skaisser.itermcolors"

    # Also open via bundle ID so iTerm2 registers and activates it
    open -b "com.googlecode.iterm2" "$preset" 2>/dev/null || true

    ok "iTerm2 color preset installed"
    info "In iTerm2: Settings → Profiles → Colors → Color Presets → skaisser"
}

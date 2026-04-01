#!/usr/bin/env bash
# lib/install/iterm2.sh

install_iterm2() {
    if [[ -d "/Applications/iTerm.app" ]]; then
        ok "iTerm2 already installed"
        track_skipped "iTerm2"
        return
    fi

    info "Installing iTerm2..."
    brew install --cask iterm2

    if [[ -d "/Applications/iTerm.app" ]]; then
        ok "iTerm2 installed"
        track_installed "iTerm2"
    else
        err "iTerm2 failed to install"
        track_failed "iTerm2"
    fi
}

install_vscode() {
    if [[ -d "/Applications/Visual Studio Code.app" ]]; then
        ok "VS Code already installed"
        track_skipped "VS Code"
        return
    fi

    info "Installing VS Code..."
    brew install --cask visual-studio-code

    if [[ -d "/Applications/Visual Studio Code.app" ]]; then
        ok "VS Code installed"
        track_installed "VS Code"
        info "The 'code' CLI command is available after restarting your terminal"
    else
        err "VS Code failed to install"
        track_failed "VS Code"
    fi
}

install_iterm2_colors() {
    local preset="$DEVTERM_DIR/assets/skaisser.itermcolors"

    if [[ ! -f "$preset" ]]; then
        err "Color preset not found: $preset"
        track_failed "iTerm2 Colors"
        return
    fi

    if [[ ! -d "/Applications/iTerm.app" ]]; then
        # iTerm2 not installed yet — skip importing (user will do it after opening iTerm2)
        info "iTerm2 color preset ready — import it after opening iTerm2"
        track_skipped "iTerm2 Colors"
        return
    fi

    # Open with iTerm2 — it handles .itermcolors natively and registers the preset
    open -a iTerm "$preset" 2>/dev/null || open "$preset" 2>/dev/null || true

    ok "iTerm2 color preset imported"
    track_installed "iTerm2 Colors"
    info "In iTerm2: Settings → Profiles → Colors → Color Presets → skaisser"
}

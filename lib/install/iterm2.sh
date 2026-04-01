#!/usr/bin/env bash
# lib/install/iterm2.sh

install_iterm2() {
    if [[ -d "/Applications/iTerm.app" ]]; then
        ok "iTerm2 already installed"
        track_skipped "iTerm2"
    else
        info "Installing iTerm2..."
        brew install --cask iterm2

        if [[ -d "/Applications/iTerm.app" ]]; then
            ok "iTerm2 installed"
            track_installed "iTerm2"
        else
            err "iTerm2 failed to install"
            track_failed "iTerm2"
            return
        fi
    fi

    # Auto-configure iTerm2 (appearance + hotkey + profile)
    _configure_iterm2
}

_configure_iterm2() {
    local plist="com.googlecode.iterm2"

    # ── Global settings (via defaults write) ─────────────────────────────────

    # Appearance: Minimal (5)
    defaults write "$plist" TabStyleWithAutomaticOption -int 5

    # System-wide hotkey: Cmd+` to toggle iTerm2 from anywhere
    defaults write "$plist" Hotkey -bool true
    defaults write "$plist" HotkeyChar -int 0
    defaults write "$plist" HotkeyCode -int 50
    defaults write "$plist" HotkeyModifiers -int 1048840
    defaults write "$plist" HotkeyMigratedFromSingleToMulti -bool true

    # Smooth scrolling off (snappier feel)
    defaults write "$plist" AppleScrollAnimationEnabled -bool false
    defaults write "$plist" NSScrollAnimationEnabled -bool false

    ok "iTerm2 configured — Minimal appearance + Cmd+\` hotkey"

    # ── Dynamic Profile (font, scrollback, cursor) ───────────────────────────
    local dynamic_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
    local profile_src="$DEVTERM_DIR/assets/iterm2/devterm-profile.json"

    if [[ -f "$profile_src" ]]; then
        mkdir -p "$dynamic_dir"
        cp "$profile_src" "$dynamic_dir/devterm-profile.json"
        ok "devterm profile installed (MesloLGS Nerd Font Mono 18 + unlimited scrollback)"
        info "In iTerm2: Settings → Profiles → select 'devterm' → Other Actions → Set as Default"
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

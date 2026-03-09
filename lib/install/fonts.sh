#!/usr/bin/env bash
# lib/install/fonts.sh

install_fonts() {
    local fonts=(
        "font-meslo-lg-nerd-font"
        "font-fira-code-nerd-font"
    )

    for font in "${fonts[@]}"; do
        if cask_installed "$font"; then
            ok "$font already installed"
        else
            gum spin --spinner dot --title "Installing $font..." -- \
                brew install --cask "$font"
            ok "$font installed"
        fi
    done

    # Install devterm iTerm2 profile (font + size + settings — auto-loads via DynamicProfiles)
    if [[ -d "/Applications/iTerm.app" ]]; then
        local profiles_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
        mkdir -p "$profiles_dir"
        cp "$DEVTERM_DIR/assets/devterm.iterm2profile" "$profiles_dir/devterm.iterm2profile"

        # Set devterm as the default profile via its GUID
        defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "devterm-skaisser-001"
        # Flush preferences cache so iTerm2 picks it up on next launch
        killall cfprefsd 2>/dev/null || true

        ok "iTerm2 profile installed and set as default (MesloLGM Nerd Font Mono 18)"
        info "Relaunch iTerm2 to apply the devterm profile"
    else
        info "Font installed — set manually: iTerm2 → Profiles → Text → MesloLGM Nerd Font Mono, size 18"
    fi
}

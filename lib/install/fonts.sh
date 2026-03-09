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
        ok "iTerm2 profile installed (MesloLGM Nerd Font Mono 18 + devterm settings)"
        info "In iTerm2: Profiles → devterm → Set as Default"
    else
        info "Font installed — set manually: iTerm2 → Profiles → Text → MesloLGM Nerd Font Mono, size 18"
    fi
}

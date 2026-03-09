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

    ok "Fonts installed — MesloLGM Nerd Font Mono + Fira Code Nerd Font"
    info "In iTerm2: Settings → Profiles → Text → Font → MesloLGM Nerd Font Mono, size 18"
}

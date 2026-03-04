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

    echo ""
    info "Set font in iTerm2: Preferences → Profiles → Text → Font → MesloLGS NF"
    info "Set font size to 13 or 14 for best results with Oh My Posh"
}

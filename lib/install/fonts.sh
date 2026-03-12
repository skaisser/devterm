#!/usr/bin/env bash
# lib/install/fonts.sh

install_fonts() {
    # ── MesloLGS Nerd Font ───────────────────────────────────────────────────
    if cask_installed "font-meslo-lg-nerd-font"; then
        ok "font-meslo-lg-nerd-font already installed"
    else
        gum spin --spinner dot --title "Installing font-meslo-lg-nerd-font..." -- \
            brew install --cask "font-meslo-lg-nerd-font"
    fi

    # Verify MesloLGS Nerd Font installed correctly
    if [[ ! -f "$HOME/Library/Fonts/MesloLGSNerdFont-Regular.ttf" ]]; then
        warn "MesloLGS Nerd Font not found — retrying..."
        gum spin --spinner dot --title "Retrying font-meslo-lg-nerd-font..." -- \
            brew install --cask "font-meslo-lg-nerd-font"
        if [[ ! -f "$HOME/Library/Fonts/MesloLGSNerdFont-Regular.ttf" ]]; then
            error "MesloLGS Nerd Font install failed — please install manually: brew install --cask font-meslo-lg-nerd-font"
        else
            ok "font-meslo-lg-nerd-font installed (retry succeeded)"
        fi
    else
        ok "font-meslo-lg-nerd-font installed"
    fi

    # ── Fira Code Nerd Font ──────────────────────────────────────────────────
    if cask_installed "font-fira-code-nerd-font"; then
        ok "font-fira-code-nerd-font already installed"
    else
        gum spin --spinner dot --title "Installing font-fira-code-nerd-font..." -- \
            brew install --cask "font-fira-code-nerd-font"
    fi

    # Verify Fira Code Nerd Font installed correctly
    if [[ ! -f "$HOME/Library/Fonts/FiraCodeNerdFont-Regular.ttf" ]]; then
        warn "Fira Code Nerd Font not found — retrying..."
        gum spin --spinner dot --title "Retrying font-fira-code-nerd-font..." -- \
            brew install --cask "font-fira-code-nerd-font"
        if [[ ! -f "$HOME/Library/Fonts/FiraCodeNerdFont-Regular.ttf" ]]; then
            error "Fira Code Nerd Font install failed — please install manually: brew install --cask font-fira-code-nerd-font"
        else
            ok "font-fira-code-nerd-font installed (retry succeeded)"
        fi
    else
        ok "font-fira-code-nerd-font installed"
    fi

    ok "Fonts installed — MesloLGS Nerd Font + Fira Code Nerd Font"
    info "In iTerm2: Settings → Profiles → Text → Font → MesloLGS Nerd Font, size 18"
}

#!/usr/bin/env bash
# lib/install/fonts.sh

install_fonts() {
    # ── MesloLGS Nerd Font ───────────────────────────────────────────────────
    if cask_installed "font-meslo-lg-nerd-font" && [[ -f "$HOME/Library/Fonts/MesloLGSNerdFont-Regular.ttf" ]]; then
        ok "font-meslo-lg-nerd-font already installed"
        track_skipped "MesloLGS Nerd Font"
    else
        info "Installing font-meslo-lg-nerd-font..."
        brew install --cask font-meslo-lg-nerd-font

        if [[ -f "$HOME/Library/Fonts/MesloLGSNerdFont-Regular.ttf" ]]; then
            ok "font-meslo-lg-nerd-font installed"
            track_installed "MesloLGS Nerd Font"
        else
            err "MesloLGS Nerd Font failed to install — try manually: brew install --cask font-meslo-lg-nerd-font"
            track_failed "MesloLGS Nerd Font"
        fi
    fi

    # ── Fira Code Nerd Font ──────────────────────────────────────────────────
    if cask_installed "font-fira-code-nerd-font" && [[ -f "$HOME/Library/Fonts/FiraCodeNerdFont-Regular.ttf" ]]; then
        ok "font-fira-code-nerd-font already installed"
        track_skipped "Fira Code Nerd Font"
    else
        info "Installing font-fira-code-nerd-font..."
        brew install --cask font-fira-code-nerd-font

        if [[ -f "$HOME/Library/Fonts/FiraCodeNerdFont-Regular.ttf" ]]; then
            ok "font-fira-code-nerd-font installed"
            track_installed "Fira Code Nerd Font"
        else
            err "Fira Code Nerd Font failed to install — try manually: brew install --cask font-fira-code-nerd-font"
            track_failed "Fira Code Nerd Font"
        fi
    fi

    if [[ "${TERM_PROGRAM:-}" == "iTerm.app" ]]; then
        info "In iTerm2: Settings → Profiles → Text → Font → MesloLGS Nerd Font, size 18"
    else
        info "After opening iTerm2: Settings → Profiles → Text → Font → MesloLGS Nerd Font, size 18"
    fi
}

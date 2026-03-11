#!/usr/bin/env bash
# lib/install/tools.sh — generic brew formula installer + fzf + zsh plugins

# Generic formula install (handles tapped formulas too)
brew_install_formula() {
    local formula="$1"
    local display_name="${formula##*/}"  # strip tap prefix for display

    if formula_installed "$display_name" 2>/dev/null || brew list "$formula" &>/dev/null; then
        ok "$display_name already installed"
        return
    fi

    gum spin --spinner dot --title "Installing $display_name..." -- \
        brew install "$formula"
    ok "$display_name installed"
}

# fzf needs extra setup after brew install
install_fzf() {
    if command -v fzf &>/dev/null; then
        ok "fzf already installed"
    else
        gum spin --spinner dot --title "Installing fzf..." -- \
            brew install fzf
        # Install shell bindings (Ctrl+R, Ctrl+T, Alt+C)
        "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish --no-update-rc &>/dev/null || true
        ok "fzf installed (Ctrl+R · Ctrl+T · Alt+C enabled)"
    fi
}

install_zoxide() {
    brew_install_formula "zoxide"
}

# Install zsh plugin from GitHub to ~/.zsh/plugins/
install_zsh_plugin() {
    local repo="$1"
    local name="${repo##*/}"
    local dest="$HOME/.zsh/plugins/$name"

    mkdir -p "$HOME/.zsh/plugins"

    if [[ -d "$dest/.git" ]]; then
        gum spin --spinner dot --title "Updating $name..." -- \
            git -C "$dest" pull --ff-only --quiet
        ok "$name (updated)"
    else
        gum spin --spinner dot --title "Installing $name..." -- \
            git clone --depth=1 "https://github.com/$repo" "$dest"
        ok "$name installed"
    fi
}

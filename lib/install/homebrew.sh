#!/usr/bin/env bash
# lib/install/homebrew.sh

install_homebrew() {
    if command -v brew &>/dev/null; then
        ok "Homebrew already installed ($(brew --version | head -1 | cut -d' ' -f2))"
        return
    fi

    gum spin --spinner dot --title "Installing Homebrew..." -- \
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null \
        || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null

    ok "Homebrew installed"
}

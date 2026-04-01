#!/usr/bin/env bash
# lib/install/homebrew.sh

install_homebrew() {
    if command -v brew &>/dev/null; then
        ok "Homebrew already installed ($(brew --version | head -1 | cut -d' ' -f2))"
        track_skipped "Homebrew"
        return
    fi

    info "Installing Homebrew (non-interactive)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null

    eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null \
        || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null

    if command -v brew &>/dev/null; then
        ok "Homebrew installed"
        track_installed "Homebrew"
    else
        err "Homebrew failed to install"
        track_failed "Homebrew"
    fi
}

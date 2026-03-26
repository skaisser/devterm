#!/usr/bin/env bash
# lib/install/herd.sh — Laravel Herd

install_herd() {
    if [[ -d "/Applications/Herd.app" ]]; then
        ok "Laravel Herd already installed"
        track_skipped "Laravel Herd"
        return
    fi

    info "Installing Laravel Herd..."
    brew install --cask herd

    if [[ -d "/Applications/Herd.app" ]]; then
        ok "Laravel Herd installed"
        track_installed "Laravel Herd"
        info "Open Herd.app to complete PHP/MySQL setup"
        info "Herd serves sites from ~/Sites at <project>.test with HTTPS"
    else
        err "Laravel Herd failed to install"
        track_failed "Laravel Herd"
    fi
}

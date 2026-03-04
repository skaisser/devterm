#!/usr/bin/env bash
# lib/install/herd.sh — Laravel Herd

install_herd() {
    if [[ -d "/Applications/Herd.app" ]]; then
        ok "Laravel Herd already installed"
        return
    fi

    gum spin --spinner dot --title "Installing Laravel Herd..." -- \
        brew install --cask herd

    ok "Laravel Herd installed"
    info "Open Herd.app to complete PHP/MySQL setup"
    info "Herd serves sites from ~/Sites at <project>.test with HTTPS"
}

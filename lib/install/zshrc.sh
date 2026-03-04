#!/usr/bin/env bash
# lib/install/zshrc.sh — apply zshrc template

install_zshrc() {
    local template="$DEVTERM_DIR/assets/zshrc.template"
    local target="$HOME/.zshrc"

    if [[ ! -f "$template" ]]; then
        err "zshrc template not found: $template"
        return
    fi

    # Backup existing .zshrc
    if [[ -f "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$target" "$backup"
        info "Backed up existing .zshrc → $backup"

        if ! gum confirm "  Replace ~/.zshrc with devterm config?"; then
            info "Skipped .zshrc replacement — backup kept at $backup"
            return
        fi
    fi

    cp "$template" "$target"
    ok ".zshrc installed → $target"
    info "Run 'source ~/.zshrc' or open a new terminal to apply"
}

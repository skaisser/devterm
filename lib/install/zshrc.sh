#!/usr/bin/env bash
# lib/install/zshrc.sh — apply zshrc template

install_zshrc() {
    local template="$DEVTERM_DIR/assets/zshrc.template"
    local target="$HOME/.zshrc"

    if [[ ! -f "$template" ]]; then
        err "zshrc template not found: $template"
        track_failed ".zshrc"
        return
    fi

    # Always backup existing .zshrc before overwriting
    if [[ -f "$target" ]]; then
        local bak
        bak="$(backup_file "$target")"
        if [[ -n "$bak" ]]; then
            info "Backed up existing .zshrc → $bak"
        fi
    fi

    cp "$template" "$target"

    # Verify critical markers exist in the new .zshrc
    local valid=true
    if ! grep -q "oh-my-posh" "$target" 2>/dev/null; then
        warn ".zshrc missing oh-my-posh configuration"
        valid=false
    fi
    if ! grep -q "plugins" "$target" 2>/dev/null; then
        warn ".zshrc missing plugin sources"
        valid=false
    fi
    if ! grep -q "PATH" "$target" 2>/dev/null; then
        warn ".zshrc missing PATH entries"
        valid=false
    fi

    if [[ "$valid" == true ]]; then
        ok ".zshrc installed → $target"
        track_installed ".zshrc"
    else
        warn ".zshrc installed but may be incomplete — check template"
        track_installed ".zshrc"
    fi

    info "Run 'source ~/.zshrc' to apply"
}

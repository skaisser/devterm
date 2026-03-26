#!/usr/bin/env bash
# lib/install/claude.sh — Claude Code + statusline

install_claude_code() {
    # Ensure nvm is sourced — could be Herd's nvm or standalone Homebrew nvm
    if ! command -v npm &>/dev/null && ! command -v bun &>/dev/null; then
        if [[ -d "/Applications/Herd.app" ]]; then
            export NVM_DIR="$HOME/Library/Application Support/Herd/config/nvm"
            [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
        else
            export NVM_DIR="$HOME/.nvm"
            [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
            [[ -s "/usr/local/opt/nvm/nvm.sh" ]]    && source "/usr/local/opt/nvm/nvm.sh"
        fi
    fi

    # Prefer bun, fallback to npm
    if command -v bun &>/dev/null; then
        local pkg_manager="bun"
    elif command -v npm &>/dev/null; then
        local pkg_manager="npm"
    else
        err "Node.js not found — enable the JavaScript category or install Node manually"
        info "Then run: npm install -g @anthropic-ai/claude-code"
        track_failed "Claude Code"
        return
    fi

    if command -v claude &>/dev/null; then
        ok "Claude Code already installed ($(claude --version 2>/dev/null | head -1))"
        track_skipped "Claude Code"
        return
    fi

    info "Installing Claude Code via $pkg_manager..."
    "$pkg_manager" install -g @anthropic-ai/claude-code

    if command -v claude &>/dev/null; then
        ok "Claude Code installed"
        track_installed "Claude Code"
        info "Run 'claude' to start · 'claude --help' for all commands"
    else
        err "Claude Code failed to install"
        track_failed "Claude Code"
    fi
}

install_claude_statusline() {
    local src="$DEVTERM_DIR/assets/statusline.sh"
    local claude_dir="$HOME/.claude"
    local dst="$claude_dir/statusline.sh"
    local settings="$claude_dir/settings.json"

    if [[ ! -f "$src" ]]; then
        err "statusline.sh not found in assets"
        track_failed "Claude Statusline"
        return
    fi

    mkdir -p "$claude_dir"

    # Install the statusline script
    cp "$src" "$dst"
    chmod +x "$dst"
    ok "statusline.sh installed → $dst"

    # Wire it into Claude Code settings.json
    if [[ ! -f "$settings" ]]; then
        # Create minimal settings.json with statusline
        cat > "$settings" <<'EOF'
{
  "statusLine": {
    "type": "command",
    "command": "$HOME/.claude/statusline.sh"
  }
}
EOF
        ok "Claude Code settings.json created with statusline"
        track_installed "Claude Statusline"
    else
        # Check if statusLine is already configured
        if grep -q 'statusLine' "$settings" 2>/dev/null; then
            ok "statusLine already configured in settings.json"
            track_skipped "Claude Statusline"
        else
            # Backup before modifying
            local bak
            bak="$(backup_file "$settings")"
            if [[ -n "$bak" ]]; then
                info "Backed up settings.json → $bak"
            fi

            # Add statusLine to existing settings.json using atomic write
            local tmp
            tmp="$(mktemp)"
            # Remove trailing } and add statusLine block
            sed '$ s/}//' "$settings" > "$tmp"
            cat >> "$tmp" << 'EOF'
  ,"statusLine": {
    "type": "command",
    "command": "$HOME/.claude/statusline.sh"
  }
}
EOF
            mv "$tmp" "$settings"
            ok "statusLine added to existing settings.json"
            track_installed "Claude Statusline"
        fi
    fi

    echo ""
    info "The statusline shows: model · context bar · tokens · git branch · folder"
    info "Restart Claude Code to see it in action"
}

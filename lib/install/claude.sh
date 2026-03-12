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
        return
    fi

    if command -v claude &>/dev/null; then
        ok "Claude Code already installed ($(claude --version 2>/dev/null | head -1))"
        return
    fi

    gum spin --spinner dot --title "Installing Claude Code via $pkg_manager..." -- \
        "$pkg_manager" install -g @anthropic-ai/claude-code

    ok "Claude Code installed"
    info "Run 'claude' to start · 'claude --help' for all commands"
}

install_claude_statusline() {
    local src="$DEVTERM_DIR/assets/statusline.sh"
    local claude_dir="$HOME/.claude"
    local dst="$claude_dir/statusline.sh"
    local settings="$claude_dir/settings.json"

    if [[ ! -f "$src" ]]; then
        err "statusline.sh not found in assets"
        return
    fi

    mkdir -p "$claude_dir"

    # Install the statusline script
    cp "$src" "$dst"
    chmod +x "$dst"
    ok "statusline.sh installed → $dst"

    # Ensure python3 is available for JSON manipulation
    if ! command -v python3 &>/dev/null; then
        warn "python3 not found — required to wire settings.json"
        if gum confirm \
            --prompt.foreground="#ffb86c" \
            --selected.background="#ffb86c" \
            --selected.foreground="#000000" \
            "  Install python3 via Homebrew?"; then
            gum spin --spinner dot --title "Installing python3..." -- \
                brew install python3
            ok "python3 installed"
        else
            info "Skipping settings.json wiring — add statusLine manually later"
            return
        fi
    fi

    # Wire it into Claude Code settings.json
    if [[ ! -f "$settings" ]]; then
        # Create minimal settings.json with statusline
        cat > "$settings" <<EOF
{
  "statusLine": {
    "type": "command",
    "command": "\$HOME/.claude/statusline.sh"
  }
}
EOF
        ok "Claude Code settings.json created with statusline"
    else
        # Check if statusLine is already configured
        if python3 -c "import json,sys; d=json.load(open('$settings')); sys.exit(0 if 'statusLine' in d else 1)" 2>/dev/null; then
            ok "statusLine already configured in settings.json"
        else
            # Add statusLine to existing settings.json
            python3 - "$settings" <<'PYEOF'
import json, sys
path = sys.argv[1]
with open(path) as f:
    d = json.load(f)
d['statusLine'] = {"type": "command", "command": "$HOME/.claude/statusline.sh"}
with open(path, 'w') as f:
    json.dump(d, f, indent=2)
PYEOF
            ok "statusLine added to existing settings.json"
        fi
    fi

    echo ""
    info "The statusline shows: model · context bar · tokens · git branch · folder"
    info "Restart Claude Code to see it in action"
}

#!/usr/bin/env bash
# lib/install/claude.sh — Claude Code + statusline

install_claude_code() {
    # Prefer bun, fallback to npm
    if command -v bun &>/dev/null; then
        local pkg_manager="bun"
    elif command -v npm &>/dev/null; then
        local pkg_manager="npm"
    else
        err "No package manager found (npm or bun required)"
        info "Install Node.js or bun first, then run: npm install -g @anthropic-ai/claude-code"
        return
    fi

    if command -v claude &>/dev/null; then
        ok "Claude Code already installed ($(claude --version 2>/dev/null | head -1))"
        return
    fi

    gum spin --spinner dot --title "Installing Claude Code via $pkg_manager..." -- \
        $pkg_manager install -g @anthropic-ai/claude-code

    ok "Claude Code installed"
    info "Run 'claude' to start · 'claude --help' for all commands"
}

install_claude_statusline() {
    local src="$DEVTERMINAL_DIR/assets/statusline.sh"
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

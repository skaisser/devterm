#!/usr/bin/env bash
# lib/utils.sh — shared helpers

ok()   { gum style --foreground="#50fa7b" "  ✓  $*"; }
info() { gum style --foreground="#8be9fd" "  ℹ  $*"; }
warn() { gum style --foreground="#ffb86c" "  ⚠  $*"; }
err()  { gum style --foreground="#ff5555" "  ✗  $*"; }
error() { err "$@"; }
step() {
    echo ""
    gum style --foreground="#bd93f9" --bold "━━  $*"
}

# Detect Homebrew prefix (Apple Silicon vs Intel)
brew_prefix() {
    if [[ -d "/opt/homebrew" ]]; then
        echo "/opt/homebrew"
    else
        echo "/usr/local"
    fi
}

# Check if a cask is installed
cask_installed() {
    brew list --cask "$1" &>/dev/null
}

# Check if a formula is installed
formula_installed() {
    brew list "$1" &>/dev/null
}

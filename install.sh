#!/usr/bin/env bash
#
# devterm — macOS terminal setup by @skaisser
# https://github.com/skaisser/devterm
#
# Usage:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/skaisser/devterm/main/install.sh)"
#   — or —
#   git clone https://github.com/skaisser/devterm && cd devterm && ./install.sh

DEVTERM_REPO="https://github.com/skaisser/devterm"
DEVTERM_INSTALL_DIR="${DEVTERM_INSTALL_DIR:-$HOME/.devterm}"

# ── Self-clone if piped via curl ─────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]:-}" == "" ]]; then
    # On a fresh Mac, macOS provides a /usr/bin/git stub that triggers the
    # Xcode CLT install dialog without actually working. Check CLT directly.
    if ! xcode-select -p &>/dev/null 2>&1; then
        echo "→ Fresh Mac detected: installing Homebrew + Xcode Command Line Tools"
        echo "  (this takes 15-20 minutes on first run — please wait)"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null \
            || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
    fi

    echo "→ Cloning devterm..."
    if [[ -d "$DEVTERM_INSTALL_DIR/.git" ]]; then
        git -C "$DEVTERM_INSTALL_DIR" pull --ff-only --quiet
    else
        git clone --depth=1 "$DEVTERM_REPO" "$DEVTERM_INSTALL_DIR"
    fi
    exec bash "$DEVTERM_INSTALL_DIR/install.sh"
    exit
fi

DEVTERM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── macOS only ───────────────────────────────────────────────────────────────
if [[ "$(uname)" != "Darwin" ]]; then
    echo "✗ devterm requires macOS." >&2
    exit 1
fi


# ── Bootstrap: Homebrew ──────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    echo "→ Installing Homebrew (required)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null \
        || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
fi

# ── Bootstrap: gum ───────────────────────────────────────────────────────────
if ! command -v gum &>/dev/null; then
    echo "→ Installing gum..."
    brew install gum
fi

# ── Bootstrap: figlet ────────────────────────────────────────────────────────
if ! command -v figlet &>/dev/null; then
    brew install figlet
fi

# ── Source libs ──────────────────────────────────────────────────────────────
source "$DEVTERM_DIR/lib/utils.sh"
source "$DEVTERM_DIR/lib/banner.sh"
source "$DEVTERM_DIR/lib/checks.sh"
source "$DEVTERM_DIR/lib/menu.sh"
source "$DEVTERM_DIR/lib/install/homebrew.sh"
source "$DEVTERM_DIR/lib/install/iterm2.sh"
source "$DEVTERM_DIR/lib/install/fonts.sh"
source "$DEVTERM_DIR/lib/install/omp.sh"
source "$DEVTERM_DIR/lib/install/tools.sh"
source "$DEVTERM_DIR/lib/install/plugins.sh"
source "$DEVTERM_DIR/lib/install/claude.sh"
source "$DEVTERM_DIR/lib/install/herd.sh"
source "$DEVTERM_DIR/lib/install/zshrc.sh"

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
    show_banner
    run_checks

    # Show info box with everything that will be installed
    clear
    echo ""
    gum style \
        --border rounded \
        --border-foreground="#bd93f9" \
        --padding "1 2" \
        --margin "0 2" \
        "$(gum style --foreground='#bd93f9' --bold '📦  Installation Summary')" \
        "" \
        "$(gum style --foreground='#50fa7b' 'Core (always installed):')" \
        "  • iTerm2 terminal emulator" \
        "  • Nerd Fonts (Meslo LG S)" \
        "  • Oh My Posh theme engine + skaisser theme" \
        "  • zoxide (z command)" \
        "  • zshrc configuration" \
        "" \
        "$(gum style --foreground='#50fa7b' 'Tools & Utilities:')" \
        "  • VS Code editor" \
        "  • CLI tools (eza, fzf, gh, htop, lazygit, wget)" \
        "  • Zsh plugins (completions, autosuggestions, syntax highlight, history search)" \
        "  • Claude Code AI assistant" \
        "  • PHP/Laravel (composer, Laravel Herd)" \
        "  • JavaScript (bun, yarn)" \
        "  • DevOps (rclone, awscli, ansible, terraform)" \
        "  • Extras (tmux, cmatrix)"

    echo ""
    if ! gum confirm \
        --prompt.foreground="#bd93f9" \
        --selected.background="#bd93f9" \
        --selected.foreground="#000000" \
        "  Proceed with full installation?"; then
        echo ""
        warn "Installation cancelled."
        exit 0
    fi

    clear
    echo ""
    gum style --foreground="#bd93f9" --bold --margin "0 2" "Installing your setup..."
    echo ""

    # Always install core visual components first
    step "iTerm2"
    install_iterm2
    step "Nerd Fonts"
    install_fonts
    step "zoxide"
    brew_install_formula "zoxide"
    step "Oh My Posh + skaisser theme"
    install_omp
    step "iTerm2 color preset"
    install_iterm2_colors

    # Run the full no-wizard install of all selected tools
    install_all

    # Always install zshrc — it is the foundation of devterm
    step "zshrc config"
    install_zshrc

    show_done

    # Post-install guidance for non-iTerm2 users
    if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
        echo ""
        gum style \
            --border rounded \
            --border-foreground="#50fa7b" \
            --padding "1 2" \
            --margin "0 2" \
            "$(gum style --foreground='#50fa7b' --bold '✨  Setup Complete!')" \
            "" \
            "$(gum style --foreground='#f8f8f2' 'Next step: Open iTerm2 for the full experience.')" \
            "$(gum style --foreground='#f8f8f2' 'iTerm2 was installed — find it in your Applications folder.')"
        echo ""
    fi
}

main "$@"

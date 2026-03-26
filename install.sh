#!/usr/bin/env bash
#
# devterm — macOS terminal setup by @skaisser
# https://github.com/skaisser/devterm
#
# Usage:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/skaisser/devterm/main/install.sh)"
#   — or —
#   git clone https://github.com/skaisser/devterm && cd devterm && ./install.sh
#   — or —
#   ./install.sh --check        (verify current install state)
#   ./install.sh --uninstall    (remove devterm)

set -euo pipefail

DEVTERM_REPO="https://github.com/skaisser/devterm"
DEVTERM_INSTALL_DIR="${DEVTERM_INSTALL_DIR:-$HOME/.devterm}"

# ── Flag parsing ─────────────────────────────────────────────────────────────
if [[ "${1:-}" == "--uninstall" ]]; then
    echo "Not yet implemented"
    exit 0
fi

if [[ "${1:-}" == "--check" ]]; then
    echo "Not yet implemented"
    exit 0
fi

# ── Self-clone if piped via curl (remote mode) ──────────────────────────────
if [[ "${BASH_SOURCE[0]:-}" == "" ]]; then
    # ── Bootstrap Xcode CLT (polling loop, 10min timeout) ────────────────
    if ! xcode-select -p &>/dev/null; then
        echo "→ Installing Xcode Command Line Tools..."
        xcode-select --install 2>/dev/null || true
        local_timeout=600
        elapsed=0
        while ! xcode-select -p &>/dev/null; do
            if [[ $elapsed -ge $local_timeout ]]; then
                echo "✗ Timed out waiting for Xcode CLT install (10 minutes)." >&2
                echo "  Please install manually: xcode-select --install" >&2
                exit 1
            fi
            sleep 5
            elapsed=$((elapsed + 5))
        done
        echo "  ✓ Xcode Command Line Tools installed"
    fi

    # ── Bootstrap Homebrew ───────────────────────────────────────────────
    if ! command -v brew &>/dev/null; then
        echo "→ Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null \
            || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
        if ! command -v brew &>/dev/null; then
            echo "✗ Homebrew installation failed." >&2
            exit 1
        fi
        echo "  ✓ Homebrew installed"
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

# ── Local/remote mode detection ─────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -d "$SCRIPT_DIR/lib" ]]; then
    # Local mode — running from cloned repo
    DEVTERM_DIR="$SCRIPT_DIR"
else
    # Remote mode — clone and re-exec
    if [[ -d "$DEVTERM_INSTALL_DIR/.git" ]]; then
        git -C "$DEVTERM_INSTALL_DIR" pull --ff-only --quiet
    else
        git clone --depth=1 "$DEVTERM_REPO" "$DEVTERM_INSTALL_DIR"
    fi
    exec bash "$DEVTERM_INSTALL_DIR/install.sh"
    exit
fi

export DEVTERM_DIR

# ── macOS only ───────────────────────────────────────────────────────────────
if [[ "$(uname)" != "Darwin" ]]; then
    echo "✗ devterm requires macOS." >&2
    exit 1
fi

# ── Bootstrap: Xcode CLT (polling loop, 10min timeout) ──────────────────────
if ! xcode-select -p &>/dev/null; then
    echo "→ Installing Xcode Command Line Tools..."
    xcode-select --install 2>/dev/null || true
    timeout=600
    elapsed=0
    while ! xcode-select -p &>/dev/null; do
        if [[ $elapsed -ge $timeout ]]; then
            echo "✗ Timed out waiting for Xcode CLT install (10 minutes)." >&2
            echo "  Please install manually: xcode-select --install" >&2
            exit 1
        fi
        sleep 5
        elapsed=$((elapsed + 5))
    done
    echo "  ✓ Xcode Command Line Tools installed"
fi

# ── Bootstrap: Homebrew ──────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    echo "→ Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null \
        || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
    if ! command -v brew &>/dev/null; then
        echo "✗ Homebrew installation failed." >&2
        exit 1
    fi
    echo "  ✓ Homebrew installed"
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

    # Let user pick which categories to install
    pick_categories

    # Show summary of what will be installed and confirm
    show_install_summary

    clear
    echo ""
    printf '\033[35m\033[1m  Installing your setup...\033[0m\n'
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

    # Install user-selected categories
    install_selected

    # Always install zshrc — it is the foundation of devterm
    step "zshrc config"
    install_zshrc

    # Show install summary
    show_summary

    show_done

    # Post-install guidance for non-iTerm2 users
    if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
        echo ""
        echo "  ┌──────────────────────────────────────────────┐"
        printf '  │ \033[32m\033[1m✨  Setup Complete!\033[0m                             │\n'
        echo "  │                                              │"
        echo "  │  Next step: Open iTerm2 for the full         │"
        echo "  │  experience. It was installed — find it in    │"
        echo "  │  your Applications folder.                   │"
        echo "  └──────────────────────────────────────────────┘"
        echo ""
    fi
}

main "$@"

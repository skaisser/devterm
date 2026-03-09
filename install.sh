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
    # On a fresh Mac, git requires Xcode CLT which isn't installed yet.
    # Install Homebrew first — its installer handles Xcode CLT and waits for it.
    if ! command -v git &>/dev/null; then
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
source "$DEVTERM_DIR/lib/install/claude.sh"
source "$DEVTERM_DIR/lib/install/herd.sh"
source "$DEVTERM_DIR/lib/install/zshrc.sh"

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
    show_banner
    run_checks

    # show_menu runs the full wizard and prints selections to stdout
    local selections
    selections=$(show_menu)

    [[ -z "$selections" ]] && { warn "Nothing selected. Exiting."; exit 0; }

    clear
    echo ""
    gum style --foreground="#bd93f9" --bold --margin "0 2" "Installing your setup..."
    echo ""

    install_selected "$selections"
    show_done
}

main "$@"

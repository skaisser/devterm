#!/usr/bin/env bash
#
# devterm — macOS terminal setup by @skaisser
# https://github.com/skaisser/devterm
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/skaisser/devterm/main/install.sh)
#   — or —
#   git clone https://github.com/skaisser/devterm && cd devterm && ./install.sh
#   — or —
#   ./install.sh --check        (verify current install state)
#   ./install.sh --uninstall    (remove devterm)

set -euo pipefail

DEVTERM_REPO="https://github.com/skaisser/devterm"
DEVTERM_INSTALL_DIR="${DEVTERM_INSTALL_DIR:-$HOME/.devterm}"

# ── uninstall() — remove devterm and restore previous config ─────────────────
uninstall() {
    echo ""
    printf '\033[35m\033[1m━━  Uninstalling devterm\033[0m\n'
    echo ""

    # Remove ~/.devterm
    if [[ -d "$HOME/.devterm" ]]; then
        rm -rf "$HOME/.devterm"
        printf '\033[32m  ✓  Removed ~/.devterm\033[0m\n'
    else
        printf '\033[36m  ℹ  ~/.devterm not found — skipping\033[0m\n'
    fi

    # Remove devterm-managed zsh plugins
    if [[ -d "$HOME/.zsh/plugins" ]]; then
        rm -rf "$HOME/.zsh/plugins"
        printf '\033[32m  ✓  Removed ~/.zsh/plugins\033[0m\n'
    else
        printf '\033[36m  ℹ  ~/.zsh/plugins not found — skipping\033[0m\n'
    fi

    # Remove skaisser Oh My Posh theme
    if [[ -f "$HOME/.zsh/themes/skaisser.omp.json" ]]; then
        rm -f "$HOME/.zsh/themes/skaisser.omp.json"
        printf '\033[32m  ✓  Removed ~/.zsh/themes/skaisser.omp.json\033[0m\n'
    else
        printf '\033[36m  ℹ  ~/.zsh/themes/skaisser.omp.json not found — skipping\033[0m\n'
    fi

    # Restore most recent .zshrc backup if one exists
    local latest_backup
    latest_backup=$(ls -t "$HOME/.zshrc.bak."* 2>/dev/null | head -1)
    if [[ -n "${latest_backup:-}" ]]; then
        cp "$latest_backup" "$HOME/.zshrc"
        printf '\033[32m  ✓  Restored %s → ~/.zshrc\033[0m\n' "$latest_backup"
    else
        printf '\033[36m  ℹ  No .zshrc backup found — leaving ~/.zshrc as-is\033[0m\n'
    fi

    # Remove devterm statusLine entry from ~/.claude/settings.json
    if [[ -f "$HOME/.claude/settings.json" ]]; then
        # Remove the statusline.sh hook line from the JSON
        sed -i '' '/statusline\.sh/d' "$HOME/.claude/settings.json"
        printf '\033[32m  ✓  Removed devterm statusLine from ~/.claude/settings.json\033[0m\n'
    else
        printf '\033[36m  ℹ  ~/.claude/settings.json not found — skipping\033[0m\n'
    fi

    echo ""
    printf '\033[32m\033[1m  devterm uninstalled.\033[0m\n'
    echo ""
}

# ── check_install() — verify devterm components without installing ────────────
check_install() {
    # Source utils.sh for ok/err helpers if available
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -f "$script_dir/lib/utils.sh" ]]; then
        source "$script_dir/lib/utils.sh"
    elif [[ -f "$HOME/.devterm/lib/utils.sh" ]]; then
        source "$HOME/.devterm/lib/utils.sh"
    else
        # Inline minimal helpers if utils.sh not available
        ok()   { printf '\033[32m  ✓  %s\033[0m\n' "$*"; }
        err()  { printf '\033[31m  ✗  %s\033[0m\n' "$*"; }
        info() { printf '\033[36m  ℹ  %s\033[0m\n' "$*"; }
    fi

    local pass=0
    local fail=0

    _chk() {
        local label="$1"
        local result="$2"   # "ok" or "fail"
        if [[ "$result" == "ok" ]]; then
            ok "$label"
            pass=$((pass + 1))
        else
            err "$label"
            fail=$((fail + 1))
        fi
    }

    echo ""
    printf '\033[35m\033[1m━━  devterm install check\033[0m\n'

    # ── Binaries ────────────────────────────────────────────────────────────
    echo ""
    printf '\033[1;37m  Binaries\033[0m\n'
    for bin in brew oh-my-posh eza fzf gh htop lazygit wget zoxide git; do
        if command -v "$bin" &>/dev/null; then
            _chk "$bin" "ok"
        else
            _chk "$bin" "fail"
        fi
    done

    # ── Casks / Applications ────────────────────────────────────────────────
    echo ""
    printf '\033[1;37m  Applications\033[0m\n'
    if [[ -d "/Applications/iTerm.app" ]]; then
        _chk "iTerm2 (/Applications/iTerm.app)" "ok"
    else
        _chk "iTerm2 (/Applications/iTerm.app)" "fail"
    fi
    if [[ -d "/Applications/Visual Studio Code.app" ]]; then
        _chk "VS Code (/Applications/Visual Studio Code.app)" "ok"
    else
        _chk "VS Code (/Applications/Visual Studio Code.app)" "fail"
    fi
    if [[ -d "/Applications/Herd.app" ]]; then
        _chk "Herd (/Applications/Herd.app)" "ok"
    else
        _chk "Herd (/Applications/Herd.app)" "fail"
    fi

    # ── Fonts ────────────────────────────────────────────────────────────────
    echo ""
    printf '\033[1;37m  Fonts (~/Library/Fonts/)\033[0m\n'
    local fonts_dir="$HOME/Library/Fonts"
    if ls "$fonts_dir"/MesloLGS* &>/dev/null 2>&1; then
        _chk "MesloLGS Nerd Font" "ok"
    else
        _chk "MesloLGS Nerd Font" "fail"
    fi
    if ls "$fonts_dir"/FiraCode* &>/dev/null 2>&1; then
        _chk "Fira Code" "ok"
    else
        _chk "Fira Code" "fail"
    fi

    # ── Plugins ──────────────────────────────────────────────────────────────
    echo ""
    printf '\033[1;37m  Zsh Plugins (~/.zsh/plugins/)\033[0m\n'
    local plugins_dir="$HOME/.zsh/plugins"
    for plugin in zsh-autosuggestions zsh-completions zsh-history-substring-search fast-syntax-highlighting; do
        if [[ -d "$plugins_dir/$plugin" ]]; then
            _chk "$plugin" "ok"
        else
            _chk "$plugin" "fail"
        fi
    done

    # ── Config ───────────────────────────────────────────────────────────────
    echo ""
    printf '\033[1;37m  Config\033[0m\n'
    if [[ -f "$HOME/.zshrc" ]]; then
        _chk "~/.zshrc exists" "ok"
        if grep -q "oh-my-posh" "$HOME/.zshrc" 2>/dev/null; then
            _chk "~/.zshrc has oh-my-posh marker" "ok"
        else
            _chk "~/.zshrc has oh-my-posh marker" "fail"
        fi
        if grep -q "plugins" "$HOME/.zshrc" 2>/dev/null; then
            _chk "~/.zshrc has plugins marker" "ok"
        else
            _chk "~/.zshrc has plugins marker" "fail"
        fi
    else
        _chk "~/.zshrc exists" "fail"
    fi

    if [[ -f "$HOME/.zsh/themes/skaisser.omp.json" ]]; then
        _chk "~/.zsh/themes/skaisser.omp.json" "ok"
    else
        _chk "~/.zsh/themes/skaisser.omp.json" "fail"
    fi

    # ── Claude ───────────────────────────────────────────────────────────────
    echo ""
    printf '\033[1;37m  Claude Code\033[0m\n'
    if [[ -f "$HOME/.claude/statusline.sh" ]]; then
        _chk "~/.claude/statusline.sh" "ok"
    else
        _chk "~/.claude/statusline.sh" "fail"
    fi

    # ── Summary ──────────────────────────────────────────────────────────────
    echo ""
    printf '\033[35m\033[1m━━  Summary\033[0m\n'
    echo ""
    printf '\033[32m  ✓  %d found\033[0m\n' "$pass"
    if (( fail > 0 )); then
        printf '\033[31m  ✗  %d missing\033[0m\n' "$fail"
    fi
    echo ""
}

# ── Flag parsing ─────────────────────────────────────────────────────────────
if [[ "${1:-}" == "--uninstall" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -d "$SCRIPT_DIR/lib" ]]; then
        source "$SCRIPT_DIR/lib/utils.sh"
    fi
    read -rp "  Remove devterm and restore previous config? [y/N] " ans
    case "$(printf '%s' "$ans" | tr '[:upper:]' '[:lower:]')" in
        y|yes) uninstall ;;
        *) echo "  Cancelled."; exit 0 ;;
    esac
    exit 0
fi

if [[ "${1:-}" == "--check" ]]; then
    check_install
    exit 0
fi

# ── Self-clone if run via curl (remote mode) ─────────────────────────────────
# Detect: pipe (BASH_SOURCE empty) or process substitution (/dev/fd/*)
if [[ -z "${BASH_SOURCE[0]:-}" || "${BASH_SOURCE[0]:-}" == /dev/fd/* || "${BASH_SOURCE[0]:-}" == /proc/self/fd/* ]]; then
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
        echo "→ Installing Homebrew (non-interactive)..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
        eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null \
            || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
        if ! command -v brew &>/dev/null; then
            echo "✗ Homebrew installation failed." >&2
            exit 1
        fi
        echo "  ✓ Homebrew installed"
    fi

    echo "→ Cloning devterm..."
    rm -rf "$DEVTERM_INSTALL_DIR" 2>/dev/null || true
    git clone --depth=1 "$DEVTERM_REPO" "$DEVTERM_INSTALL_DIR"
    exec bash "$DEVTERM_INSTALL_DIR/install.sh"
    exit
fi

# ── Local/remote mode detection ─────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -d "$SCRIPT_DIR/lib" ]]; then
    # Local mode — running from cloned repo
    DEVTERM_DIR="$SCRIPT_DIR"
else
    # Remote mode — always fresh clone
    rm -rf "$DEVTERM_INSTALL_DIR" 2>/dev/null || true
    git clone --depth=1 "$DEVTERM_REPO" "$DEVTERM_INSTALL_DIR"
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
    echo "→ Installing Homebrew (non-interactive)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
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
}

main "$@"

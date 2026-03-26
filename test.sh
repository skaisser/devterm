#!/usr/bin/env bash
#
# test.sh — validate devterm installed state
# Run after install to verify everything is in place.
#
# Usage: bash test.sh

set -euo pipefail

PASS=0
FAIL=0

check() {
    local label="$1"
    local result="$2"  # 0 = pass, 1 = fail

    if [[ "$result" -eq 0 ]]; then
        printf '\033[32m  ✓  %s\033[0m\n' "$label"
        PASS=$((PASS + 1))
    else
        printf '\033[31m  ✗  %s\033[0m\n' "$label"
        FAIL=$((FAIL + 1))
    fi
}

echo ""
printf '\033[35m\033[1m━━  devterm install verification\033[0m\n'
echo ""

# ── Binaries ──────────────────────────────────────────────────────────────────
printf '\033[36m  Binaries:\033[0m\n'
for cmd in brew oh-my-posh eza fzf gh htop lazygit wget zoxide git; do
    if command -v "$cmd" &>/dev/null; then
        check "$cmd" 0
    else
        check "$cmd (not found)" 1
    fi
done

# ── Applications ──────────────────────────────────────────────────────────────
echo ""
printf '\033[36m  Applications:\033[0m\n'
for app_check in \
    "/Applications/iTerm.app:iTerm2" \
    "/Applications/Visual Studio Code.app:VS Code" \
    "/Applications/Herd.app:Laravel Herd"; do
    app_path="${app_check%%:*}"
    app_name="${app_check##*:}"
    if [[ -d "$app_path" ]]; then
        check "$app_name" 0
    else
        check "$app_name (not found)" 1
    fi
done

# ── Fonts ─────────────────────────────────────────────────────────────────────
echo ""
printf '\033[36m  Fonts:\033[0m\n'
for font_check in \
    "$HOME/Library/Fonts/MesloLGSNerdFont-Regular.ttf:MesloLGS Nerd Font" \
    "$HOME/Library/Fonts/FiraCodeNerdFont-Regular.ttf:Fira Code Nerd Font"; do
    font_path="${font_check%%:*}"
    font_name="${font_check##*:}"
    if [[ -f "$font_path" ]]; then
        check "$font_name" 0
    else
        check "$font_name (not found)" 1
    fi
done

# ── Zsh Plugins ───────────────────────────────────────────────────────────────
echo ""
printf '\033[36m  Zsh Plugins:\033[0m\n'
for plugin in zsh-autosuggestions zsh-completions zsh-history-substring-search fast-syntax-highlighting; do
    if [[ -d "$HOME/.zsh/plugins/$plugin" ]] && ls "$HOME/.zsh/plugins/$plugin/"*.zsh &>/dev/null 2>&1; then
        check "$plugin" 0
    elif [[ -d "$HOME/.zsh/plugins/$plugin" ]]; then
        check "$plugin (dir exists but no .zsh files)" 1
    else
        check "$plugin (not found)" 1
    fi
done

# ── Configuration ─────────────────────────────────────────────────────────────
echo ""
printf '\033[36m  Configuration:\033[0m\n'

# .zshrc exists
if [[ -f "$HOME/.zshrc" ]]; then
    check ".zshrc exists" 0
else
    check ".zshrc missing" 1
fi

# .zshrc has Oh My Posh
if grep -q "oh-my-posh" "$HOME/.zshrc" 2>/dev/null; then
    check ".zshrc has oh-my-posh" 0
else
    check ".zshrc missing oh-my-posh" 1
fi

# .zshrc has plugin sources
if grep -q "plugins/" "$HOME/.zshrc" 2>/dev/null; then
    check ".zshrc has plugin references" 0
else
    check ".zshrc missing plugin references" 1
fi

# Oh My Posh theme
if [[ -f "$HOME/.zsh/themes/skaisser.omp.json" ]]; then
    check "skaisser.omp.json theme" 0
else
    check "skaisser.omp.json theme (not found)" 1
fi

# Claude statusline
if [[ -f "$HOME/.claude/statusline.sh" ]]; then
    check "Claude statusline.sh" 0
else
    check "Claude statusline.sh (not found)" 1
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
printf '\033[35m\033[1m━━  Results\033[0m\n'
echo ""
printf '\033[32m  Passed: %d\033[0m\n' "$PASS"
if [[ "$FAIL" -gt 0 ]]; then
    printf '\033[31m  Failed: %d\033[0m\n' "$FAIL"
else
    printf '\033[36m  Failed: 0\033[0m\n'
fi
echo ""

if [[ "$FAIL" -eq 0 ]]; then
    printf '\033[32m\033[1m  All checks passed!\033[0m\n'
else
    printf '\033[33m  Some checks failed — run the installer to fix.\033[0m\n'
fi
echo ""

exit "$FAIL"

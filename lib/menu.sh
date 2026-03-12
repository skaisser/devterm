#!/usr/bin/env bash
# lib/menu.sh — category picker + install runner

# ── Category definitions ─────────────────────────────────────────────────────
# Each category has a key, a display label, and an install block.
# Core items (iTerm2, fonts, OMP, zoxide, zshrc) always install — not listed.

CATEGORIES=(
    "editor"
    "cli-tools"
    "zsh-plugins"
    "claude-code"
    "php-laravel"
    "javascript"
    "devops"
    "extras"
)

category_label() {
    case "$1" in
        editor)       echo "Editor — VS Code" ;;
        cli-tools)    echo "CLI Tools — eza, fzf, gh, htop, lazygit, wget" ;;
        zsh-plugins)  echo "Zsh Plugins — completions, autosuggestions, syntax, history" ;;
        claude-code)  echo "Claude Code — AI assistant + statusline" ;;
        php-laravel)  echo "PHP / Laravel — composer, Herd" ;;
        javascript)   echo "JavaScript — nvm, Node 22+18, bun, yarn" ;;
        devops)       echo "DevOps — rclone" ;;
        extras)       echo "Extras — tmux, cmatrix" ;;
    esac
}

# ── Install functions per category ───────────────────────────────────────────

install_category() {
    case "$1" in
        editor)
            step "Editor — VS Code"
            install_vscode
            ;;
        cli-tools)
            step "CLI tools — eza, fzf, gh, htop, lazygit, wget"
            brew_install_formula "eza"
            install_fzf
            brew_install_formula "gh"
            brew_install_formula "htop"
            brew_install_formula "lazygit"
            brew_install_formula "wget"
            ;;
        zsh-plugins)
            step "Zsh plugins — completions, autosuggestions, history search, syntax highlighting"
            install_zsh_completions
            install_zsh_autosuggestions
            install_zsh_history_search
            install_fast_syntax_highlighting
            ;;
        claude-code)
            step "Claude Code — CLI + statusline"
            install_claude_code
            install_claude_statusline
            ;;
        php-laravel)
            step "PHP / Laravel — Composer + Herd"
            brew_install_formula "composer"
            install_herd
            ;;
        javascript)
            step "JavaScript — nvm + Node + Bun + Yarn"
            install_nvm_node
            brew_install_formula "oven-sh/bun/bun"
            brew_install_formula "yarn"
            ;;
        devops)
            step "DevOps — rclone"
            brew_install_formula "rclone"
            ;;
        extras)
            step "Extras — tmux, cmatrix"
            brew_install_formula "tmux"
            brew_install_formula "cmatrix"
            ;;
    esac
}

# ── Category picker (single screen) ─────────────────────────────────────────

pick_categories() {
    clear
    echo ""

    gum style \
        --border rounded \
        --border-foreground="#bd93f9" \
        --padding "1 2" \
        --margin "0 2" \
        "$(gum style --foreground='#bd93f9' --bold '📦  Choose what to install')" \
        "" \
        "$(gum style --foreground='#50fa7b' 'Always installed (core):')" \
        "  iTerm2 · Nerd Fonts · Oh My Posh + theme · zoxide · zshrc config" \
        "" \
        "$(gum style --foreground='#8be9fd' 'Space to toggle · Enter to confirm')"

    echo ""

    # Build options list — all pre-selected by default
    local options=()
    local preselected=()
    for cat in "${CATEGORIES[@]}"; do
        local label
        label=$(category_label "$cat")
        options+=("$label")
        preselected+=("$label")
    done

    # Join preselected with commas for --selected flag
    local selected_str
    selected_str=$(printf '%s,' "${preselected[@]}")
    selected_str="${selected_str%,}"

    local picks
    picks=$(gum choose --no-limit \
        --no-show-help \
        --cursor="  › " \
        --cursor-prefix="◉ " \
        --selected-prefix="◉ " \
        --unselected-prefix="○ " \
        --cursor.foreground="#ff79c6" \
        --selected.foreground="#50fa7b" \
        --height="${#CATEGORIES[@]}" \
        --selected="$selected_str" \
        "${options[@]}" \
    )

    # Map selected labels back to category keys
    SELECTED_CATEGORIES=()
    while IFS= read -r pick; do
        [[ -z "$pick" ]] && continue
        for cat in "${CATEGORIES[@]}"; do
            if [[ "$(category_label "$cat")" == "$pick" ]]; then
                SELECTED_CATEGORIES+=("$cat")
                break
            fi
        done
    done <<< "$picks"
}

# ── Summary screen ───────────────────────────────────────────────────────────

show_install_summary() {
    clear
    echo ""

    # Build selected list for display
    local selected_display=""
    for cat in "${SELECTED_CATEGORIES[@]}"; do
        selected_display+="  • $(category_label "$cat")"$'\n'
    done

    # Build skipped list for display
    local skipped_display=""
    for cat in "${CATEGORIES[@]}"; do
        local found=false
        for sel in "${SELECTED_CATEGORIES[@]}"; do
            [[ "$cat" == "$sel" ]] && found=true && break
        done
        if ! $found; then
            skipped_display+="  • $(category_label "$cat")"$'\n'
        fi
    done

    local summary_lines=(
        "$(gum style --foreground='#bd93f9' --bold '📦  Installation Summary')"
        ""
        "$(gum style --foreground='#50fa7b' 'Core (always installed):')"
        "  • iTerm2 terminal emulator"
        "  • Nerd Fonts (MesloLGS + Fira Code)"
        "  • Oh My Posh + skaisser theme"
        "  • zoxide (z command)"
        "  • zshrc configuration"
    )

    if [[ -n "$selected_display" ]]; then
        summary_lines+=(
            ""
            "$(gum style --foreground='#50fa7b' 'Selected:')"
        )
        while IFS= read -r line; do
            [[ -n "$line" ]] && summary_lines+=("$line")
        done <<< "$selected_display"
    fi

    if [[ -n "$skipped_display" ]]; then
        summary_lines+=(
            ""
            "$(gum style --foreground='#6272a4' 'Skipped:')"
        )
        while IFS= read -r line; do
            [[ -n "$line" ]] && summary_lines+=("$(gum style --foreground='#6272a4' "$line")")
        done <<< "$skipped_display"
    fi

    gum style \
        --border rounded \
        --border-foreground="#bd93f9" \
        --padding "1 2" \
        --margin "0 2" \
        "${summary_lines[@]}"

    echo ""
    if ! gum confirm \
        --prompt.foreground="#bd93f9" \
        --selected.background="#bd93f9" \
        --selected.foreground="#000000" \
        "  Proceed with installation?"; then
        echo ""
        warn "Installation cancelled."
        exit 0
    fi
}

# ── Install selected categories ──────────────────────────────────────────────

install_selected() {
    for cat in "${SELECTED_CATEGORIES[@]}"; do
        install_category "$cat"
    done
}

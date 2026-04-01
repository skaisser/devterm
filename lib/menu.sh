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

    # Reuse the DEVTERM gradient logo
    local themes=(
        "213 213 207 177 141 105 69  39"
        "196 196 202 208 214 220 226 226"
        "51  51  45  39  33  27  21  21"
        "201 201 165 129 93  57  21  21"
        "46  46  82  118 154 190 226 226"
        "99  99  141 183 219 225 231 231"
        "214 214 208 202 196 160 124 88"
        "87  87  81  75  69  63  57  51"
    )
    local chosen="${themes[$((RANDOM % ${#themes[@]}))]}"
    _gradient_print "$(_logo_lines)" "$chosen"

    printf "\033[32m  Always installed (core):\033[0m\n"
    printf "\033[36m  iTerm2 · Nerd Fonts · Oh My Posh + theme · zoxide · zshrc config\033[0m\n"

    echo ""
    printf "\033[38;5;141m\033[1m  Optional categories:\033[0m\n"
    echo ""

    # Show category list
    for cat in "${CATEGORIES[@]}"; do
        printf "  \033[38;5;141m•\033[0m  %s\n" "$(category_label "$cat")"
    done

    echo ""

    # Ask: install all or pick individually
    read -rp "  Install all? [Y/n] (n = pick one by one) " ans_all
    echo ""

    SELECTED_CATEGORIES=()

    case "$(printf '%s' "$ans_all" | tr '[:upper:]' '[:lower:]')" in
        ''|y|yes)
            # Select all categories
            SELECTED_CATEGORIES=("${CATEGORIES[@]}")
            info "All categories selected."
            ;;
        *)
            # Prompt Y/n per category
            printf '\033[36m  ℹ  Select categories to install:\033[0m\n'
            echo ""
            for cat in "${CATEGORIES[@]}"; do
                local label
                label=$(category_label "$cat")
                read -rp "  Install ${label}? [Y/n] " ans_cat
                case "$(printf '%s' "$ans_cat" | tr '[:upper:]' '[:lower:]')" in
                    ''|y|yes)
                        SELECTED_CATEGORIES+=("$cat")
                        ;;
                esac
            done
            ;;
    esac

    echo ""
}

# ── Summary screen ───────────────────────────────────────────────────────────

show_install_summary() {
    clear
    echo ""

    printf '\033[38;5;141m\033[1m━━  Installation Summary\033[0m\n'

    echo ""

    # Core section (always installed)
    printf '\033[32m  Core (always installed):\033[0m\n'
    printf '\033[32m    •  iTerm2 terminal emulator\033[0m\n'
    printf '\033[32m    •  Nerd Fonts (MesloLGS + Fira Code)\033[0m\n'
    printf '\033[32m    •  Oh My Posh + skaisser theme\033[0m\n'
    printf '\033[32m    •  zoxide (z command)\033[0m\n'
    printf '\033[32m    •  zshrc configuration\033[0m\n'

    # Selected section
    if [[ ${#SELECTED_CATEGORIES[@]} -gt 0 ]]; then
        echo ""
        printf '\033[32m  Selected:\033[0m\n'
        for cat in "${SELECTED_CATEGORIES[@]}"; do
            printf '\033[32m    •  %s\033[0m\n' "$(category_label "$cat")"
        done
    fi

    # Skipped section
    local skipped=()
    for cat in "${CATEGORIES[@]}"; do
        local found=false
        for sel in "${SELECTED_CATEGORIES[@]}"; do
            [[ "$cat" == "$sel" ]] && found=true && break
        done
        $found || skipped+=("$cat")
    done

    if [[ ${#skipped[@]} -gt 0 ]]; then
        echo ""
        printf '\033[38;5;239m  Skipped:\033[0m\n'
        for cat in "${skipped[@]}"; do
            printf '\033[38;5;239m    •  %s\033[0m\n' "$(category_label "$cat")"
        done
    fi

    echo ""

    read -rp "  Proceed with installation? [Y/n] " ans
    case "$(printf '%s' "$ans" | tr '[:upper:]' '[:lower:]')" in
        ''|y|yes)
            return 0
            ;;
        *)
            echo ""
            warn "Installation cancelled."
            exit 0
            ;;
    esac
}

# ── Install selected categories ──────────────────────────────────────────────

install_selected() {
    for cat in "${SELECTED_CATEGORIES[@]}"; do
        install_category "$cat"
    done
}

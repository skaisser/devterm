#!/usr/bin/env bash
# lib/menu.sh — step-by-step wizard

# ── Wizard state ─────────────────────────────────────────────────────────────
WIZARD_SELECTIONS=()
WIZARD_TOTAL_STEPS=7
WIZARD_CURRENT_STEP=0

# ── Step header ───────────────────────────────────────────────────────────────
_wizard_header() {
    local step="$1"
    local title="$2"
    local icon="$3"
    WIZARD_CURRENT_STEP=$step

    clear
    echo ""
    gum style \
        --foreground="#6272a4" --margin "0 2" \
        "Step $step of $WIZARD_TOTAL_STEPS"

    gum style \
        --foreground="#bd93f9" --bold --margin "0 2" \
        "$icon  $title"

    gum style \
        --foreground="#8be9fd" --margin "0 2" \
        "Space to select · Enter to confirm · Ctrl+A select all"
    echo ""
}

# ── Progress bar between steps ────────────────────────────────────────────────
_wizard_progress() {
    local step="$1"
    local filled=$(( step * 30 / WIZARD_TOTAL_STEPS ))
    local empty=$(( 30 - filled ))
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="━"; done
    for ((i=0; i<empty; i++)); do bar+="─"; done

    echo ""
    gum style \
        --foreground="#6272a4" --margin "0 2" \
        "Progress  $(gum style --foreground='#bd93f9' "$bar")  $step/$WIZARD_TOTAL_STEPS"
    echo ""
}

# ── Individual wizard steps ───────────────────────────────────────────────────

_step_terminal() {
    _wizard_header 1 "Terminal & Editor" "🖥"

    local picks
    picks=$(gum choose --no-limit \
        --no-show-help \
        --cursor="  › " \
        --cursor-prefix="◉ " \
        --selected-prefix="◉ " \
        --unselected-prefix="○ " \
        --cursor.foreground="#ff79c6" \
        --selected.foreground="#50fa7b" \
        --height=12 \
        --selected="💻  VS Code,🔡  Nerd Fonts,✨  Oh My Posh + skaisser theme,⚙️   zshrc config,🎨  iTerm2 skaisser color preset" \
        "💻  VS Code                      best code editor — includes 'code' CLI command" \
        "🔡  Nerd Fonts (MesloLGS NF + Fira Code NF)  required for icons in the prompt" \
        "✨  Oh My Posh + skaisser theme  smart prompt with git · PHP · Node · Go · Python" \
        "⚙️   zshrc config                per-window colors · SSH danger mode · git title" \
        "🎨  iTerm2 skaisser color preset the @skaisser Custom Smart Theme color palette" \
    )
    WIZARD_SELECTIONS+=("$picks")
    _wizard_progress 1
}

_step_cli_tools() {
    _wizard_header 2 "Core CLI Tools" "🔧"

    local picks
    picks=$(gum choose --no-limit \
        --no-show-help \
        --cursor="  › " \
        --cursor-prefix="◉ " \
        --selected-prefix="◉ " \
        --unselected-prefix="○ " \
        --cursor.foreground="#ff79c6" \
        --selected.foreground="#50fa7b" \
        --height=15 \
        --selected="📂  eza,🔍  fzf,🐙  gh,📊  htop,🌿  lazygit,📥  wget,💡  zsh-autosuggestions,🌈  zsh-syntax-highlighting,🔎  zsh-history-substring-search" \
        "📂  eza                          modern ls — icons · colors · git status in listing" \
        "🔍  fzf                          fuzzy finder — Ctrl+R history · Ctrl+T files" \
        "🐙  gh                           GitHub CLI — PRs · issues · repos in terminal" \
        "📊  htop                         visual process and memory monitor" \
        "🌿  lazygit                      interactive git TUI — stage hunks · resolve conflicts" \
        "📥  wget                         essential download utility" \
        "💡  zsh-autosuggestions          suggests commands as you type based on history" \
        "🌈  zsh-syntax-highlighting      highlights valid/invalid commands in real-time" \
        "🔎  zsh-history-substring-search Up/Down arrow searches history by current input" \
    )
    WIZARD_SELECTIONS+=("$picks")
    _wizard_progress 2
}

_step_claude() {
    _wizard_header 3 "Claude Code" "🤖"

    gum style \
        --border rounded \
        --border-foreground="#6272a4" \
        --padding "0 2" \
        --margin "0 2" \
        "$(gum style --foreground='#ff79c6' --bold 'The statusline shows:') $(gum style --foreground='#f8f8f2' 'model · context bar · tokens · git branch · folder')" \
        "$(gum style --foreground='#8be9fd' 'claude-sonnet-4-6 │ ████████░░ 80% │ 164K/200K │ feat/login ~2 │ myapp')"
    echo ""

    local picks
    picks=$(gum choose --no-limit \
        --no-show-help \
        --cursor="  › " \
        --cursor-prefix="◉ " \
        --selected-prefix="◉ " \
        --unselected-prefix="○ " \
        --cursor.foreground="#ff79c6" \
        --selected.foreground="#50fa7b" \
        --height=6 \
        --selected="🧠  Claude Code,📈  Claude Code statusline" \
        "🧠  Claude Code          AI coding assistant in your terminal — by Anthropic" \
        "📈  Claude Code statusline  context bar · token count · git · model in your prompt" \
    )
    WIZARD_SELECTIONS+=("$picks")
    _wizard_progress 3
}

_step_php() {
    _wizard_header 4 "PHP / Laravel" "🐘"

    local picks
    picks=$(gum choose --no-limit \
        --no-show-help \
        --cursor="  › " \
        --cursor-prefix="◉ " \
        --selected-prefix="◉ " \
        --unselected-prefix="○ " \
        --cursor.foreground="#ff79c6" \
        --selected.foreground="#50fa7b" \
        --height=6 \
        "🎼  composer       PHP package manager — required for Laravel projects" \
        "🐘  Laravel Herd   PHP dev environment · serves project.test with HTTPS · zero config" \
    )
    WIZARD_SELECTIONS+=("$picks")
    _wizard_progress 4
}

_step_javascript() {
    _wizard_header 5 "JavaScript" "⚡"

    local picks
    picks=$(gum choose --no-limit \
        --no-show-help \
        --cursor="  › " \
        --cursor-prefix="◉ " \
        --selected-prefix="◉ " \
        --unselected-prefix="○ " \
        --cursor.foreground="#ff79c6" \
        --selected.foreground="#50fa7b" \
        --height=6 \
        "🍞  bun    fast JS runtime and package manager — modern Node alternative" \
        "🧶  yarn   classic JS package manager" \
    )
    WIZARD_SELECTIONS+=("$picks")
    _wizard_progress 5
}

_step_devops() {
    _wizard_header 6 "DevOps / Cloud" "☁️"

    local picks
    picks=$(gum choose --no-limit \
        --no-show-help \
        --cursor="  › " \
        --cursor-prefix="◉ " \
        --selected-prefix="◉ " \
        --unselected-prefix="○ " \
        --cursor.foreground="#ff79c6" \
        --selected.foreground="#50fa7b" \
        --height=8 \
        "☁️   rclone      sync files to Google Drive · S3 · Dropbox and more" \
        "🔶  awscli      AWS command-line interface" \
        "🤝  ansible     automate server configuration and deployments" \
        "🏗️   terraform   infrastructure as code (HashiCorp)" \
    )
    WIZARD_SELECTIONS+=("$picks")
    _wizard_progress 6
}

_step_extras() {
    _wizard_header 7 "Extras" "✨"

    local picks
    picks=$(gum choose --no-limit \
        --no-show-help \
        --cursor="  › " \
        --cursor-prefix="◉ " \
        --selected-prefix="◉ " \
        --unselected-prefix="○ " \
        --cursor.foreground="#ff79c6" \
        --selected.foreground="#50fa7b" \
        --height=8 \
        "🪟  tmux      terminal multiplexer — multiple sessions · survives disconnects" \
        "🧹  bfg       clean large files or secrets accidentally committed to git history" \
        "🔤  woff2     convert fonts to WOFF2 format for web projects" \
        "🌧️   cmatrix   matrix screensaver (because why not)" \
    )
    WIZARD_SELECTIONS+=("$picks")
    _wizard_progress 7
}

# ── Summary screen ────────────────────────────────────────────────────────────
_wizard_summary() {
    clear
    echo ""

    gum style \
        --border double \
        --border-foreground="#bd93f9" \
        --padding "1 3" \
        --margin "0 2" \
        "$(gum style --foreground='#bd93f9' --bold '  Ready to install')"

    echo ""
    gum style --foreground="#f8f8f2" --bold --margin "0 2" "Selected:"
    echo ""

    # Print all selections
    local all_selections
    all_selections=$(printf '%s\n' "${WIZARD_SELECTIONS[@]}" | grep -v '^$' | sort)

    while IFS= read -r item; do
        [[ -z "$item" ]] && continue
        gum style --foreground="#50fa7b" --margin "0 4" "✓  $item"
    done <<< "$all_selections"

    echo ""
}

# ── Main wizard entrypoint ────────────────────────────────────────────────────
show_menu() {
    _step_terminal
    _step_cli_tools
    _step_claude
    _step_php
    _step_javascript
    _step_devops
    _step_extras

    _wizard_summary

    if ! gum confirm \
        --prompt.foreground="#bd93f9" \
        --selected.background="#bd93f9" \
        --selected.foreground="#000000" \
        "  Install everything listed above?"; then
        echo ""
        warn "Installation cancelled."
        exit 0
    fi

    # Return all selections as one newline-separated string
    printf '%s\n' "${WIZARD_SELECTIONS[@]}"
}

# ── Map selections to install functions ──────────────────────────────────────
install_selected() {
    local selections="$1"

    while IFS= read -r item; do
        [[ -z "$item" ]] && continue

        case "$item" in
            "💻"*"VS Code"*)                             step "VS Code";                   install_vscode ;;
            "🔡"*"Nerd Fonts"*)                          step "Nerd Fonts";                install_fonts ;;
            "✨"*"Oh My Posh"*)                          step "Oh My Posh";                install_omp ;;
            "⚙️"*"zshrc"*)                               step "zshrc config";              install_zshrc ;;
            "🎨"*"iTerm2 skaisser"*)                     step "iTerm2 color preset";       install_iterm2_colors ;;
            "📂"*"eza"*)                                 step "eza";                       brew_install_formula "eza" ;;
            "🔍"*"fzf"*)                                 step "fzf";                       install_fzf ;;
            "🐙"*"gh"*)                                  step "gh";                        brew_install_formula "gh" ;;
            "📊"*"htop"*)                                step "htop";                      brew_install_formula "htop" ;;
            "🌿"*"lazygit"*)                             step "lazygit";                   brew_install_formula "lazygit" ;;
            "📥"*"wget"*)                                step "wget";                      brew_install_formula "wget" ;;
            "💡"*"zsh-autosuggestions"*)                 step "zsh-autosuggestions";       install_zsh_plugin "zsh-users/zsh-autosuggestions" ;;
            "🌈"*"zsh-syntax-highlighting"*)             step "zsh-syntax-highlighting";   install_zsh_plugin "zsh-users/zsh-syntax-highlighting" ;;
            "🔎"*"zsh-history-substring-search"*)        step "zsh-history-substring-search"; install_zsh_plugin "zsh-users/zsh-history-substring-search" ;;
            "🧠"*"Claude Code statusline"*)              step "Claude Code statusline";    install_claude_statusline ;;
            "🧠"*"Claude Code"*)                         step "Claude Code";               install_claude_code ;;
            "📈"*"Claude Code statusline"*)              step "Claude Code statusline";    install_claude_statusline ;;
            "🎼"*"composer"*)                            step "composer";                  brew_install_formula "composer" ;;
            "🐘"*"Laravel Herd"*)                        step "Laravel Herd";              install_herd ;;
            "🍞"*"bun"*)                                 step "bun";                       brew_install_formula "oven-sh/bun/bun" ;;
            "🧶"*"yarn"*)                                step "yarn";                      brew_install_formula "yarn" ;;
            "☁️"*"rclone"*)                              step "rclone";                    brew_install_formula "rclone" ;;
            "🔶"*"awscli"*)                              step "awscli";                    brew_install_formula "awscli" ;;
            "🤝"*"ansible"*)                             step "ansible";                   brew_install_formula "ansible" ;;
            "🏗️"*"terraform"*)                           step "terraform";                 brew_install_formula "hashicorp/tap/terraform" ;;
            "🪟"*"tmux"*)                                step "tmux";                      brew_install_formula "tmux" ;;
            "🧹"*"bfg"*)                                 step "bfg";                       brew_install_formula "bfg" ;;
            "🔤"*"woff2"*)                               step "woff2";                     brew_install_formula "woff2" ;;
            "🌧️"*"cmatrix"*)                             step "cmatrix";                   brew_install_formula "cmatrix" ;;
        esac
    done <<< "$selections"
}

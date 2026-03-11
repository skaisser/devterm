#!/usr/bin/env bash
# lib/install/plugins.sh — zsh plugins

install_zsh_autosuggestions() {
    local dest="$HOME/.zsh/plugins/zsh-autosuggestions"
    mkdir -p "$HOME/.zsh/plugins"

    if [[ -d "$dest/.git" ]]; then
        gum spin --spinner dot --title "Updating zsh-autosuggestions..." -- \
            git -C "$dest" pull --ff-only --quiet
        ok "zsh-autosuggestions (updated)"
    else
        gum spin --spinner dot --title "Installing zsh-autosuggestions..." -- \
            git clone --depth=1 "https://github.com/zsh-users/zsh-autosuggestions" "$dest"
        ok "zsh-autosuggestions installed"
    fi
}

install_zsh_history_search() {
    local dest="$HOME/.zsh/plugins/zsh-history-substring-search"
    mkdir -p "$HOME/.zsh/plugins"

    if [[ -d "$dest/.git" ]]; then
        gum spin --spinner dot --title "Updating zsh-history-substring-search..." -- \
            git -C "$dest" pull --ff-only --quiet
        ok "zsh-history-substring-search (updated)"
    else
        gum spin --spinner dot --title "Installing zsh-history-substring-search..." -- \
            git clone --depth=1 "https://github.com/zsh-users/zsh-history-substring-search" "$dest"
        ok "zsh-history-substring-search installed"
    fi
}

install_zsh_completions() {
    local dest="$HOME/.zsh/plugins/zsh-completions"
    mkdir -p "$HOME/.zsh/plugins"

    if [[ -d "$dest/.git" ]]; then
        gum spin --spinner dot --title "Updating zsh-completions..." -- \
            git -C "$dest" pull --ff-only --quiet
        ok "zsh-completions (updated)"
    else
        gum spin --spinner dot --title "Installing zsh-completions..." -- \
            git clone --depth=1 "https://github.com/zsh-users/zsh-completions" "$dest"
        ok "zsh-completions installed"
    fi
}

install_fast_syntax_highlighting() {
    local dest="$HOME/.zsh/plugins/fast-syntax-highlighting"
    mkdir -p "$HOME/.zsh/plugins"

    if [[ -d "$dest/.git" ]]; then
        gum spin --spinner dot --title "Updating fast-syntax-highlighting..." -- \
            git -C "$dest" pull --ff-only --quiet
        ok "fast-syntax-highlighting (updated)"
    else
        gum spin --spinner dot --title "Installing fast-syntax-highlighting..." -- \
            git clone --depth=1 "https://github.com/zdharma-continuum/fast-syntax-highlighting" "$dest"
        ok "fast-syntax-highlighting installed"
    fi
}

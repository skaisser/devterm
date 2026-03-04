#!/usr/bin/env bash
# lib/install/plugins.sh — zsh plugins + CLI tools

install_plugins() {
    mkdir -p "$HOME/.zsh/plugins"

    # ── zsh plugins (git submodules) ─────────────────────────────────────────
    local -A plugins=(
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
        ["zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search"
        ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
        ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting"
        ["z"]="https://github.com/rupa/z"
    )

    for name in "${!plugins[@]}"; do
        local url="${plugins[$name]}"
        local dest="$HOME/.zsh/plugins/$name"

        if [[ -d "$dest/.git" ]]; then
            gum spin --spinner dot --title "Updating $name..." -- \
                git -C "$dest" pull --ff-only --quiet
            ok "$name (updated)"
        else
            gum spin --spinner dot --title "Installing $name..." -- \
                git clone --depth=1 "$url" "$dest"
            ok "$name installed"
        fi
    done

    # ── fzf ──────────────────────────────────────────────────────────────────
    if command -v fzf &>/dev/null; then
        ok "fzf already installed"
    else
        gum spin --spinner dot --title "Installing fzf..." -- \
            brew install fzf
        "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish --no-update-rc &>/dev/null || true
        ok "fzf installed"
    fi

    # ── eza (modern ls) ───────────────────────────────────────────────────────
    if command -v eza &>/dev/null; then
        ok "eza already installed"
    else
        gum spin --spinner dot --title "Installing eza (modern ls)..." -- \
            brew install eza
        ok "eza installed"
    fi
}

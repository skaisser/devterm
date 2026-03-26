#!/usr/bin/env bash
# lib/install/tools.sh — generic brew formula installer + fzf + zsh plugins

# Generic formula install (handles tapped formulas too)
brew_install_formula() {
    local formula="$1"
    local display_name="${formula##*/}"  # strip tap prefix for display

    if formula_installed "$display_name" 2>/dev/null || brew list "$formula" &>/dev/null; then
        ok "$display_name already installed"
        track_skipped "$display_name"
        return
    fi

    info "Installing $display_name..."
    brew install "$formula"

    if formula_installed "$display_name" 2>/dev/null || brew list "$formula" &>/dev/null; then
        ok "$display_name installed"
        track_installed "$display_name"
    else
        err "$display_name failed to install — try manually: brew install $formula"
        track_failed "$display_name"
    fi
}

# fzf needs extra setup after brew install
install_fzf() {
    if command -v fzf &>/dev/null; then
        ok "fzf already installed"
        track_skipped "fzf"
        return
    fi

    info "Installing fzf..."
    brew install fzf

    # Install shell bindings (Ctrl+R, Ctrl+T, Alt+C)
    "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish --no-update-rc &>/dev/null || true

    if command -v fzf &>/dev/null; then
        ok "fzf installed (Ctrl+R · Ctrl+T · Alt+C enabled)"
        track_installed "fzf"
    else
        err "fzf failed to install"
        track_failed "fzf"
    fi
}

install_zoxide() {
    brew_install_formula "zoxide"
}

# nvm + Node.js (22 default + 18 for legacy)
# Skipped entirely if Laravel Herd is installed — Herd manages its own nvm + Node
install_nvm_node() {
    # Herd includes its own nvm and Node — skip if Herd's nvm is actually working
    if [[ -d "/Applications/Herd.app" ]]; then
        export NVM_DIR="$HOME/Library/Application Support/Herd/config/nvm"
        if [[ -s "$NVM_DIR/nvm.sh" ]]; then
            source "$NVM_DIR/nvm.sh"
            if command -v node &>/dev/null && node --version &>/dev/null; then
                ok "Node.js $(node --version) available via Herd (skipping nvm)"
                track_skipped "nvm + Node.js (Herd)"
                return
            fi
        fi
        # Herd is installed but hasn't been opened yet — Node not ready
        info "Herd detected but not yet configured — installing standalone nvm + Node"
    fi

    # Install nvm via Homebrew if missing
    if ! brew list nvm &>/dev/null; then
        info "Installing nvm..."
        brew install nvm
        mkdir -p "$HOME/.nvm"

        if brew list nvm &>/dev/null; then
            ok "nvm installed"
            track_installed "nvm"
        else
            err "nvm failed to install"
            track_failed "nvm"
            return
        fi
    else
        ok "nvm already installed"
        track_skipped "nvm"
    fi

    # Source nvm into current session
    export NVM_DIR="$HOME/.nvm"
    [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
    [[ -s "/usr/local/opt/nvm/nvm.sh" ]]    && source "/usr/local/opt/nvm/nvm.sh"

    if ! command -v nvm &>/dev/null; then
        err "nvm failed to load — try restarting your terminal"
        track_failed "nvm (load)"
        return
    fi

    # Install Node 22 (LTS — default)
    if nvm ls 22 &>/dev/null; then
        ok "Node 22 already installed"
        track_skipped "Node.js 22"
    else
        info "Installing Node.js 22..."
        nvm install 22

        if nvm ls 22 &>/dev/null; then
            ok "Node.js 22 installed"
            track_installed "Node.js 22"
        else
            err "Node.js 22 failed to install"
            track_failed "Node.js 22"
        fi
    fi

    # Install Node 18 (legacy projects)
    if nvm ls 18 &>/dev/null; then
        ok "Node 18 already installed"
        track_skipped "Node.js 18"
    else
        info "Installing Node.js 18..."
        nvm install 18

        if nvm ls 18 &>/dev/null; then
            ok "Node.js 18 installed"
            track_installed "Node.js 18"
        else
            err "Node.js 18 failed to install"
            track_failed "Node.js 18"
        fi
    fi

    # Set Node 22 as default
    nvm use 22 &>/dev/null
    nvm alias default 22 &>/dev/null

    if command -v node &>/dev/null && node --version &>/dev/null; then
        ok "Node.js $(node --version) active — default set to 22"
    else
        warn "Node installed but could not verify — try restarting your terminal"
    fi
}

# Install zsh plugin from GitHub to ~/.zsh/plugins/
install_zsh_plugin() {
    local repo="$1"
    local name="${repo##*/}"
    local dest="$HOME/.zsh/plugins/$name"

    mkdir -p "$HOME/.zsh/plugins"

    if [[ -d "$dest/.git" ]]; then
        info "Updating $name..."
        git -C "$dest" pull --ff-only --quiet || true

        if [[ -n "$(ls -A "$dest" 2>/dev/null)" ]]; then
            ok "$name (updated)"
            track_skipped "$name"
        else
            warn "$name update may have failed — existing install preserved"
            track_skipped "$name"
        fi
    else
        info "Installing $name..."
        git clone --depth=1 "https://github.com/$repo" "$dest" || true

        if [[ -d "$dest" ]] && [[ -n "$(ls -A "$dest" 2>/dev/null)" ]]; then
            ok "$name installed"
            track_installed "$name"
        else
            err "$name failed to install"
            track_failed "$name"
        fi
    fi
}

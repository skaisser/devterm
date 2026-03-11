#!/usr/bin/env bash
# lib/menu.sh — install_all: installs everything in one opinionated pass

install_all() {
    # ── Editors ───────────────────────────────────────────────────────────────
    step "Editors — VS Code"
    install_vscode

    # ── Core CLI tools ────────────────────────────────────────────────────────
    step "CLI tools — eza, fzf, gh, htop, lazygit, wget"
    brew_install_formula "eza"
    install_fzf
    brew_install_formula "gh"
    brew_install_formula "htop"
    brew_install_formula "lazygit"
    brew_install_formula "wget"

    # ── Zsh shell plugins ─────────────────────────────────────────────────────
    step "Zsh plugins — completions, autosuggestions, history search, syntax highlighting"
    install_zsh_completions
    install_zsh_autosuggestions
    install_zsh_history_search
    install_fast_syntax_highlighting

    # ── Claude Code + statusline ──────────────────────────────────────────────
    step "Claude Code — CLI + statusline"
    install_claude_code
    install_claude_statusline

    # ── PHP / Laravel ─────────────────────────────────────────────────────────
    step "PHP / Laravel — Composer + Herd"
    brew_install_formula "composer"
    install_herd

    # ── JavaScript ────────────────────────────────────────────────────────────
    step "JavaScript — Bun + Yarn"
    brew_install_formula "oven-sh/bun/bun"
    brew_install_formula "yarn"

    # ── Infrastructure / DevOps ───────────────────────────────────────────────
    step "Infra / DevOps — rclone, awscli, ansible, terraform"
    brew_install_formula "rclone"
    brew_install_formula "awscli"
    brew_install_formula "ansible"
    brew_install_formula "hashicorp/tap/terraform"

    # ── Extras ────────────────────────────────────────────────────────────────
    step "Extras — tmux, cmatrix"
    brew_install_formula "tmux"
    brew_install_formula "cmatrix"
}

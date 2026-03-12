#!/usr/bin/env bash
# lib/checks.sh — pre-flight checks

run_checks() {
    step "Pre-flight checks"

    # macOS version (require 12.0+)
    local macos_version macos_major
    macos_version=$(sw_vers -productVersion)
    macos_major=$(echo "$macos_version" | cut -d. -f1)
    if [[ "$macos_major" -lt 12 ]]; then
        err "macOS 12 Monterey or later required (you have $macos_version)"
        exit 1
    fi
    ok "macOS $macos_version"

    # Architecture
    local arch; arch=$(uname -m)
    if [[ "$arch" == "arm64" ]]; then
        ok "Apple Silicon (arm64)"
        export BREW_PREFIX="/opt/homebrew"
    else
        ok "Intel Mac (x86_64)"
        export BREW_PREFIX="/usr/local"
    fi

    # Homebrew
    if command -v brew &>/dev/null; then
        ok "Homebrew $(brew --version | head -1 | cut -d' ' -f2)"
    else
        warn "Homebrew not found — will install"
    fi

    # Git
    if command -v git &>/dev/null; then
        ok "git $(git --version | cut -d' ' -f3)"
    else
        warn "git not found — installing via Xcode tools"
        xcode-select --install 2>/dev/null || true
    fi

    # Internet connectivity (required for Homebrew + git clones)
    if curl -sfL --connect-timeout 5 https://github.com >/dev/null 2>&1; then
        ok "Internet connection"
    else
        err "No internet connection — devterm needs to download packages"
        exit 1
    fi

    # Disk space (warn if < 5GB free)
    local free_gb
    free_gb=$(df -g / | awk 'NR==2 {print $4}')
    if [[ "$free_gb" -lt 5 ]]; then
        warn "Low disk space: ${free_gb}GB free"
    else
        ok "${free_gb}GB disk space available"
    fi

    echo ""
}

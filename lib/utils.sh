#!/usr/bin/env bash
# lib/utils.sh — shared helpers

# ── Timestamp & directory ────────────────────────────────────────────────────
TS="$(date +%Y%m%d-%H%M%S)"
export DEVTERM_DIR="${DEVTERM_DIR:-}"

# ── Output helpers (ANSI, no gum) ────────────────────────────────────────────
ok()   { printf '\033[32m  ✓  %s\033[0m\n' "$*"; }
info() { printf '\033[36m  ℹ  %s\033[0m\n' "$*"; }
warn() { printf '\033[33m  ⚠  %s\033[0m\n' "$*"; }
err()  { printf '\033[31m  ✗  %s\033[0m\n' "$*"; }
error() { err "$@"; }
step() {
    echo ""
    printf '\033[35m\033[1m━━  %s\033[0m\n' "$*"
}

# ── Homebrew helpers ─────────────────────────────────────────────────────────
brew_prefix() {
    if [[ -d "/opt/homebrew" ]]; then
        echo "/opt/homebrew"
    else
        echo "/usr/local"
    fi
}

cask_installed() {
    brew list --cask "$1" &>/dev/null
}

formula_installed() {
    brew list "$1" &>/dev/null
}

# ── Verification helpers ─────────────────────────────────────────────────────

# verify_command NAME [TEST_CMD]
# Check that a binary exists in PATH and optionally runs a test command.
# Returns 0 on success, 1 on failure.
verify_command() {
    local name="${1:?verify_command requires a name}"
    local test_cmd="${2:-}"

    if ! command -v "$name" &>/dev/null; then
        return 1
    fi

    if [[ -n "$test_cmd" ]]; then
        eval "$test_cmd" &>/dev/null || return 1
    fi

    return 0
}

# verify_file PATH
# Check that a file exists at the given path.
verify_file() {
    local path="${1:?verify_file requires a path}"
    [[ -f "$path" ]]
}

# backup_file PATH
# Create a timestamped backup copy of a file if it exists.
# Prints the backup path on success.
backup_file() {
    local path="${1:?backup_file requires a path}"
    if [[ -f "$path" ]]; then
        local backup="${path}.bak.${TS}"
        cp "$path" "$backup"
        echo "$backup"
    fi
}

# ── Install summary tracker ─────────────────────────────────────────────────
INSTALLED=()
SKIPPED=()
FAILED=()

track_installed() {
    INSTALLED+=("$1")
}

track_skipped() {
    SKIPPED+=("$1")
}

track_failed() {
    FAILED+=("$1")
}

show_summary() {
    echo ""
    printf '\033[35m\033[1m━━  Install Summary\033[0m\n'
    echo ""

    if [[ ${#INSTALLED[@]} -gt 0 ]]; then
        printf '\033[32m  Installed (%d):\033[0m\n' "${#INSTALLED[@]}"
        for item in "${INSTALLED[@]}"; do
            printf '\033[32m    ✓ %s\033[0m\n' "$item"
        done
    fi

    if [[ ${#SKIPPED[@]} -gt 0 ]]; then
        printf '\033[36m  Skipped (%d):\033[0m\n' "${#SKIPPED[@]}"
        for item in "${SKIPPED[@]}"; do
            printf '\033[36m    - %s\033[0m\n' "$item"
        done
    fi

    if [[ ${#FAILED[@]} -gt 0 ]]; then
        printf '\033[31m  Failed (%d):\033[0m\n' "${#FAILED[@]}"
        for item in "${FAILED[@]}"; do
            printf '\033[31m    ✗ %s\033[0m\n' "$item"
        done
    fi

    echo ""
    if [[ ${#FAILED[@]} -eq 0 ]]; then
        printf '\033[32m\033[1m  All done!\033[0m\n'
    else
        printf '\033[33m  Completed with %d failure(s).\033[0m\n' "${#FAILED[@]}"
    fi
    echo ""
}

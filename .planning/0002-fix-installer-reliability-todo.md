---
id: "0002"
title: "fix: Rewrite installer for reliability and idempotency"
type: fix
status: todo
project: devterm
branch: fix/installer-reliability
base: main
tags: [installer, reliability, idempotency, ux]
linear: null
backlog: null
created: "26/03/2026 18:09"
completed: null
pr: null
session: null
---

# fix: Rewrite installer for reliability and idempotency

## Goal
Rewrite the devterm installer to be reliable on fresh Macs, idempotent (safe to re-run), and independent of `gum`. Inspired by the production-grade patterns in the blueprint installer (`~/Sites/blueprint/install.sh`): strict error mode, verification after every step, timestamped backups, and graceful degradation.

## Non-Goals
- Changing what gets installed (same tools, same categories)
- Modifying assets (zshrc.template, skaisser.omp.json, skaisser.itermcolors, statusline.sh)
- Adding Linux support
- Updating README.md (separate task after installer works)

## Context
- `install.sh` — main orchestrator, broken bootstrap sequence (needs gum before Homebrew exists)
- `lib/utils.sh` — has `ok()`, `info()`, `warn()`, `err()`, `brew_prefix()`, `cask_installed()`, `formula_installed()` — keep and extend
- `lib/banner.sh` — `show_banner()` uses `gum style` for boxed border, `_gradient_print()` already uses ANSI 256-color
- `lib/checks.sh` — pre-flight checks exist but missing Xcode CLT detection
- `lib/menu.sh` — `pick_categories()` depends on `gum choose --no-limit`
- `lib/install/*.sh` — 9 install modules, most lack idempotency checks and post-install verification
- Blueprint reference: `~/Sites/blueprint/install.sh` — `set -euo pipefail`, idempotent, atomic JSON writes, `--uninstall`, timestamped backups
- Constraint: must work on fresh macOS 12+ (no dev tools pre-installed)
- Constraint: `curl -fsSL devterm.skaisser.dev | bash` must work end-to-end

## Phases

### Phase 1: Foundation — install.sh + utils.sh + checks.sh

**Touches:** `install.sh`, `lib/utils.sh`, `lib/checks.sh`

- [ ] Rewrite `install.sh` top section: add `set -euo pipefail`, add `--uninstall` flag parsing, add local/remote mode detection (check if `$SCRIPT_DIR/lib` exists for local vs shallow-clone to `~/.devterm` for remote)
- [ ] Rewrite `install.sh` bootstrap sequence: (1) detect/install Xcode CLT with polling loop (check `xcode-select -p` every 5s, timeout 10min), (2) detect/install Homebrew, (3) remove gum bootstrap entirely
- [ ] Rewrite `install.sh` main function: source libs → show banner → run checks → pick categories → install core → install selected → install zshrc → show summary — remove all `gum` references
- [ ] Add verification helpers to `lib/utils.sh`: `verify_command()` (check binary in PATH and runs), `verify_file()` (check file exists), `backup_file()` (timestamped copy like blueprint's `${FILE}.bak.${TS}` pattern)
- [ ] Add `TS` timestamp variable and `DEVTERM_DIR` variable to `lib/utils.sh` for consistent use across all modules
- [ ] Rewrite `lib/checks.sh`: add Xcode CLT check (`xcode-select -p`), normalize architecture (arm64/amd64 like blueprint), keep macOS version check, internet check, disk space check — remove any gum references
- [ ] Add an install summary tracker to `lib/utils.sh`: arrays `INSTALLED=()`, `SKIPPED=()`, `FAILED=()` that install modules append to, with a `show_summary()` function that prints the final report

**Verify:** `bash -n install.sh && bash -n lib/utils.sh && bash -n lib/checks.sh`

### Phase 2: UI without gum — banner.sh + menu.sh

**Touches:** `lib/banner.sh`, `lib/menu.sh`

- [ ] Rewrite `lib/banner.sh` `show_banner()`: keep `_gradient_print()` and `_logo_lines()` ANSI logic, replace `gum style` boxed border with manual Unicode box-drawing characters (─, │, ┌, ┐, └, ┘) via `printf`
- [ ] Rewrite `lib/banner.sh` `show_done()`: replace gum-styled completion screen with pure ANSI styled output, show install summary (installed/skipped/failed counts), keep the GitHub star prompt as a simple `read -rp` prompt
- [ ] Rewrite `lib/menu.sh` `pick_categories()`: replace `gum choose` with plain bash — show numbered category list, ask "Install all? [Y/n]", if 'n' then prompt Y/n per category, store selections in same `SELECTED_CATEGORIES` array
- [ ] Rewrite `lib/menu.sh` `show_install_summary()`: replace gum-styled summary with printf-based table showing selected/deselected categories, confirm with `read -rp "Proceed? [Y/n]"`

**Verify:** `bash -n lib/banner.sh && bash -n lib/menu.sh`

### Phase 3: Install modules — idempotency + verification

**Touches:** `lib/install/homebrew.sh`, `lib/install/iterm2.sh`, `lib/install/fonts.sh`, `lib/install/omp.sh`, `lib/install/tools.sh`, `lib/install/plugins.sh`, `lib/install/claude.sh`, `lib/install/herd.sh`, `lib/install/zshrc.sh`

- [ ] Rewrite `lib/install/homebrew.sh`: check `command -v brew` before installing, verify after with `brew --version`, track in INSTALLED/SKIPPED arrays
- [ ] Rewrite `lib/install/iterm2.sh`: use `cask_installed iTerm2` before installing, verify `/Applications/iTerm.app` exists after, same for VS Code (`/Applications/Visual Studio Code.app`), track results
- [ ] Rewrite `lib/install/fonts.sh`: check `~/Library/Fonts/` for each font file before downloading, verify font files exist after install, remove fragile retry loop in favor of clear error message, track results
- [ ] Rewrite `lib/install/omp.sh`: use `formula_installed oh-my-posh` before installing, verify `command -v oh-my-posh`, use `backup_file` before overwriting theme in `~/.zsh/themes/`, track results
- [ ] Rewrite `lib/install/tools.sh`: wrap each tool install (eza, fzf, gh, htop, lazygit, wget) with `formula_installed` check, verify each with `command -v`, fix `install_nvm_node()` to properly detect Herd's node vs standalone nvm and verify `node --version` works after, track results
- [ ] Rewrite `lib/install/plugins.sh`: for each plugin, if dir exists do `git -C pull` (update), if not do `git clone`, verify plugin directory has `.zsh` files after, use `|| true` so network failures don't break existing installs, track results
- [ ] Rewrite `lib/install/claude.sh`: check `command -v claude` before installing, verify after, use `backup_file` on `~/.claude/settings.json` before modifying, use atomic JSON write (mktemp + mv pattern from blueprint) for statusline config, track results
- [ ] Rewrite `lib/install/herd.sh`: check `/Applications/Herd.app` before installing, verify after, track results
- [ ] Rewrite `lib/install/zshrc.sh`: always `backup_file ~/.zshrc` before overwriting, install fresh template, verify critical markers exist in new .zshrc (Oh My Posh eval, plugin sources, PATH entries), print backup location to user, track results

**Verify:** `for f in lib/install/*.sh; do bash -n "$f"; done`

### Phase 4: Uninstall + completion

**Touches:** `install.sh`, `lib/banner.sh`, `lib/utils.sh`

- [ ] Add `uninstall()` function to `install.sh`: remove `~/.devterm`, remove `~/.zsh/plugins/` (devterm-managed plugins), remove `~/.zsh/themes/skaisser.omp.json`, restore most recent `.zshrc.bak.*` if exists, remove devterm entries from `~/.claude/settings.json` using sed
- [ ] Add `--uninstall` flag handler at top of `install.sh` that calls `uninstall()` with confirmation prompt before proceeding
- [ ] Update `show_done()` in `lib/banner.sh` to display the `INSTALLED`/`SKIPPED`/`FAILED` summary arrays, show manual steps needed (iTerm2 color preset, font selection), show backup file locations
- [ ] Add `--check` flag to `install.sh` that runs verification-only mode: checks all expected binaries, fonts, plugins, configs exist and reports what's missing without installing anything

**Verify:** `bash -n install.sh`

### Phase 5: Integration testing

**Touches:** `test.sh` (new file)

- [ ] Create `test.sh` that validates installed state: checks all expected binaries (`brew`, `oh-my-posh`, `eza`, `fzf`, `zoxide`, etc.), verifies font files in `~/Library/Fonts/`, verifies plugin dirs in `~/.zsh/plugins/`, verifies `.zshrc` has critical sections, reports pass/fail per check
- [ ] Run `bash -n` syntax check on all `.sh` files in the project to catch syntax errors
- [ ] Run the installer on current machine with `bash install.sh` to verify end-to-end flow works (all tools already installed, so it should detect and skip everything gracefully)

**Verify:** `bash test.sh`

## Acceptance
- [ ] `curl -fsSL devterm.skaisser.dev | bash` works on a Mac with no dev tools (Xcode CLT installs automatically)
- [ ] Running the installer twice skips everything already installed (idempotent)
- [ ] No `gum` dependency anywhere in the codebase
- [ ] Every install step has post-verification (binary exists, file exists, command runs)
- [ ] All config overwrites create timestamped backups first
- [ ] `bash install.sh --uninstall` cleanly removes devterm
- [ ] `bash install.sh --check` reports current install state without changing anything
- [ ] `bash -n` passes on all .sh files (no syntax errors)
- [ ] Install summary at end shows what was installed, skipped, and failed

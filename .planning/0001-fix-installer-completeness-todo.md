---
id: "0001"
title: "Fix installer completeness — iTerm2, VS Code, zoxide, missing plugins"
type: fix
status: awaiting-approval
project: devterm
branch: fix/installer-completeness
base_branch: main
plan_file: 0001-fix-installer-completeness-todo.md
linear: null
created: "10/03/2026 23:39"
completed: null
pr: null
phases_total: 4
phases_done: 0
tasks_total: 17
tasks_done: 0
tags: ["installer", "zshrc", "zoxide", "iterm2", "vscode"]
sessions:
  - "10/03/2026 23:39 - Plan created"
---

# Fix: Installer Completeness — iTerm2, VS Code, zoxide, missing plugins

> **Status:** Awaiting Approval
> **Branch:** `fix/installer-completeness`
> **Plan:** `0001-fix-installer-completeness-todo.md`
> **Created:** 10/03/2026 23:39
> **Progress:** Phase 0/4 — 0/17 tasks completed
>
> **Work Sessions:**
> - Session 1: 10/03/2026 23:39 - Plan created
>
> **Rules:**
> - When completing a task, mark `[x]` with timestamp: `- [x] Task ✅ DD/MM/YYYY HH:MM`
> - Get timestamp: `date "+%d/%m/%Y %H:%M"` — NEVER guess
> - Run `/commit` after each phase
> - Phase collapsing happens on resume or plan-check — NEVER during first-run execution
> - After modifying plan files, commit plan changes: `git add .planning/ && git commit -m "..."`

## Overview

The devterm installer has four confirmed bugs that prevent it from working reliably on a friend's Mac: (1) a hard-exit that requires iTerm2 to already be installed before the script can run, (2) a gum `--selected` mismatch that silently pre-selects nothing (so VS Code and other tools are never installed), (3) z/zsh-completions/fast-syntax-highlighting referenced in the zshrc template but never actually installed, and (4) z should be replaced with zoxide (faster, actively maintained Rust rewrite). After this fix, running the installer on a clean Mac from Terminal.app should produce a fully working devterm setup.

⚠️ Note on zoxide vs z: zoxide is objectively better — written in Rust, much faster, has `zi` for interactive directory selection via fzf, maintains a SQLite database, and is actively maintained. The previous Claude session was correct to recommend it. z is legacy.

## Context Pack

- **Goal:** Make the devterm installer work end-to-end on a fresh Mac, installing everything the zshrc template expects.
- **Non-goals:** Adding new features/tools beyond what's already in the project; changing the OMP theme or iTerm2 colors.
- **Constraints:** macOS only; must remain Homebrew-based; installer can run from any terminal (not just iTerm2); no interactive prompts beyond the wizard; zshrc template must load without errors on a fresh install.
- **Key paths:**
  - `install.sh` — entry point, always-install block, iTerm2 requirement check
  - `lib/menu.sh` — gum wizard, `install_selected()` case dispatcher
  - `lib/install/plugins.sh` — zsh plugin installer (`install_plugins()` is dead code)
  - `lib/install/iterm2.sh` — `install_iterm2()`, `install_vscode()`
  - `lib/install/tools.sh` — `brew_install_formula()`, `install_fzf()`
  - `assets/zshrc.template` — the shell config deployed to `~/.zshrc`
- **Interfaces:** none (local installer only)
- **Data:** none
- **Risks:**
  1. gum version differences — `--selected` flag behavior may vary; fix by making option strings short and exactly matching the `--selected` values.
  2. Removing the iTerm2 gate means `install_iterm2_colors` runs `open preset.itermcolors` from a non-iTerm2 terminal — this is fine, it will open the file and register the preset for when iTerm2 is launched.
  3. zoxide replaces z — any user who ran the old installer and has z in their history will get zoxide instead; z commands still work since zoxide registers `z` (and `zi`).
- **Verification:** Manual smoke test — run `./install.sh` from Terminal.app on the dev machine, confirm all steps complete, source the resulting `~/.zshrc`, verify `z`, `zi`, `zsh-autosuggestions`, `fast-syntax-highlighting`, `zsh-completions`, and `code` are all available.

## Phases

### Phase 1: Fix install.sh — Remove iTerm2 gate, fix always-install block

**Touches:** `install.sh`, `lib/install/iterm2.sh`

**Tasks:**
- [ ] Remove the hard-exit `if [[ "$TERM_PROGRAM" != "iTerm.app" ]]` block from `install.sh`
- [ ] Add `install_iterm2` to the always-install block in `main()` (before the menu, so it's installed first)
- [ ] Add a post-install message: if `$TERM_PROGRAM != "iTerm.app"`, show "Now open iTerm2 for the full experience!"
- [ ] Source `lib/install/iterm2.sh` in `install.sh` (verify it's already sourced — it is, but `install_iterm2` is never called)
- [ ] Add `zoxide` to always-install block: `brew_install_formula "zoxide"`

**Verify:** Run `bash install.sh` from a non-iTerm2 terminal, confirm it does not exit early and reaches the wizard.

### Phase 2: Fix gum wizard — make --selected actually work

**Touches:** `lib/menu.sh`

**Tasks:**
- [ ] Rewrite each `gum choose` step to use short option strings that exactly match `--selected` values (e.g., `"💻  VS Code"` not `"💻  VS Code   best code editor..."`)
- [ ] Move descriptions into a `gum style` info block shown above each `gum choose` call
- [ ] Remove `"🌈  zsh-syntax-highlighting"` from the Step 2 menu (it's now always-installed as fast-syntax-highlighting)
- [ ] Update `install_selected()` case patterns to match the new short option strings (verify existing `*"eza"*` patterns still work)
- [ ] Add `zoxide` brew install mapping to `install_selected()` (so it can also be re-run; primary install is always-install)

**Verify:** Run `./install.sh`, press Enter on each wizard step without changing selections — confirm all pre-selected tools appear in the summary screen.

### Phase 3: Fix plugin installer — zoxide, fast-syntax-highlighting, zsh-completions

**Touches:** `lib/install/plugins.sh`, `lib/install/tools.sh`

**Tasks:**
- [ ] Remove the dead `install_plugins()` function from `plugins.sh` (was never called; its contents are now handled by always-install and the menu)
- [ ] Remove `z` from plugins list (replaced by zoxide)
- [ ] Keep only `install_zsh_plugin()` helper in `plugins.sh` for use by `install_selected()`
- [ ] Add `install_fast_syntax_highlighting` function to `tools.sh` or `plugins.sh` that clones `zdharma-continuum/fast-syntax-highlighting` to `~/.zsh/plugins/fast-syntax-highlighting`
- [ ] Add `install_zsh_completions` function that clones `zsh-users/zsh-completions` to `~/.zsh/plugins/zsh-completions`
- [ ] Call both functions in the always-install block in `main()` (after fonts)

**Verify:** After running installer, confirm `~/.zsh/plugins/fast-syntax-highlighting/` and `~/.zsh/plugins/zsh-completions/` exist, and `which zoxide` returns a path.

### Phase 4: Sync zshrc.template with actual installed toolset

**Touches:** `assets/zshrc.template`

**Tasks:**
- [ ] Replace z plugin section with zoxide: `command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"` (add `zi` alias note in comment)
- [ ] Replace `zsh-syntax-highlighting` plugin reference with `fast-syntax-highlighting`: update path from `zsh-syntax-highlighting/zsh-syntax-highlighting.zsh` to `fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh`
- [ ] Verify `zsh-completions` fpath section already in template (it is — `~/.zsh/plugins/zsh-completions/src`) — no change needed
- [ ] Add a brief comment explaining zoxide: `# zoxide — smart cd: z <partial> to jump, zi for interactive (fzf)`
- [ ] Verify all other plugin paths in the template match what the installer actually installs (autosuggestions, history-substring-search, fzf)

**Verify:** On a test machine, `source ~/.zshrc` with no errors; `z` and `zi` work; syntax highlighting active; tab completion enhanced.

## Acceptance Criteria
- [ ] `./install.sh` runs successfully from Terminal.app (no iTerm2 required to start)
- [ ] iTerm2 is installed automatically as part of the setup
- [ ] VS Code installs when selected in the wizard (gum pre-selection works)
- [ ] All plugins referenced in `zshrc.template` are installed by the installer
- [ ] zoxide is installed and `z`/`zi` commands work after sourcing `~/.zshrc`
- [ ] `fast-syntax-highlighting` is installed and active
- [ ] `zsh-completions` is installed and fpath is correctly set
- [ ] After full install + `source ~/.zshrc`, zero errors/warnings
- [ ] Installer ends with clear guidance to open iTerm2 if not already running there

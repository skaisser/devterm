---
id: "0001"
title: "Fix installer completeness — no wizard, zoxide, fonts retry, all tools auto-install"
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
tasks_total: 20
tasks_done: 0
tags: ["installer", "zshrc", "zoxide", "iterm2", "fonts", "no-wizard"]
sessions:
  - "10/03/2026 23:39 - Plan created"
  - "10/03/2026 23:55 - Scope updated: remove wizard, add font retry, zoxide done"
---

# Fix: Installer Completeness — No Wizard, All Tools Auto-Install

> **Status:** Awaiting Approval
> **Branch:** `fix/installer-completeness`
> **Plan:** `0001-fix-installer-completeness-todo.md`
> **Created:** 10/03/2026 23:39
> **Progress:** Phase 0/4 — 0/20 tasks completed
>
> **Work Sessions:**
> - Session 1: 10/03/2026 23:39 - Plan created
> - Session 2: 10/03/2026 23:55 - Scope updated; zshrc.template and ~/.zshrc already updated with zoxide
>
> **Rules:**
> - When completing a task, mark `[x]` with timestamp: `- [x] Task ✅ DD/MM/YYYY HH:MM`
> - Get timestamp: `date "+%d/%m/%Y %H:%M"` — NEVER guess
> - Run `/commit` after each phase
> - Phase collapsing happens on resume or plan-check — NEVER during first-run execution
> - After modifying plan files, commit plan changes: `git add .planning/ && git commit -m "..."`

## Overview

Four confirmed bugs prevented devterm from working on a friend's Mac: (1) hard-exit requiring iTerm2 before it's installed, (2) gum `--selected` silently pre-selecting nothing (tools never get installed), (3) z/zsh-completions/fast-syntax-highlighting referenced in zshrc but never installed, (4) z should be zoxide. **Additional scope from user:** remove the entire interactive wizard — just install everything automatically in a single opinionated pass. Fonts need a retry + verify step since they fail silently. zshrc.template and user's actual ~/.zshrc have already been updated with zoxide and all fixes.

## Already Done (before this plan runs)

- [x] `~/.zshrc`: z → zoxide, removed broken alias `57378u`, removed duplicate PATH, fixed `psg`, added `alias ..`, added `tar.xz` to extract() ✅ 10/03/2026 23:50
- [x] `assets/zshrc.template`: fully rewritten from improved ~/.zshrc as canonical source ✅ 10/03/2026 23:55
- [x] `zoxide` installed via brew on dev machine ✅ 10/03/2026 23:48

## Context Pack

- **Goal:** Run `./install.sh` from any terminal on a clean Mac and get the complete devterm setup — no wizard, no missing tools, everything works after `source ~/.zshrc`.
- **Non-goals:** Adding new tools not already in the project; changing the OMP theme or color scheme.
- **Constraints:** macOS only; Homebrew-based; must run from Terminal.app (not just iTerm2); no interactive prompts except a single final confirm; zshrc template must load without errors.
- **Key paths:**
  - `install.sh` — entry point, always-install block, iTerm2 gate to remove
  - `lib/menu.sh` — entire wizard to replace with a simple confirm prompt
  - `lib/install/plugins.sh` — restructure to expose individual install functions
  - `lib/install/iterm2.sh` — `install_iterm2()` add to always-install
  - `lib/install/fonts.sh` — add retry + verify logic
  - `lib/install/tools.sh` — needs zoxide install function
  - `assets/zshrc.template` — already updated ✅
- **Interfaces:** none (local installer only)
- **Data:** none
- **Risks:**
  1. Removing the wizard means ALL tools install — some users may not want Ansible/Terraform. Accepted: the project is opinionated by design, and these tools are harmless if unused.
  2. Font retry: `brew install --cask` for fonts may hang on slow connections — use timeout or just retry once.
  3. iTerm2 removal: the `.itermcolors` file opener will work from any terminal (it just registers the preset).
- **Verification:** Run `./install.sh` from Terminal.app; after `source ~/.zshrc` confirm: `z`, `zi`, `which eza`, `which fzf`, `which gh`, `which lazygit`, `which zoxide`, fast-syntax-highlighting active, Nerd Fonts in ~/Library/Fonts.

## Phases

### Phase 1: Remove iTerm2 gate + restructure install.sh for no-wizard flow

**Touches:** `install.sh`

**Tasks:**
- [ ] Remove the hard-exit `if [[ "$TERM_PROGRAM" != "iTerm.app" ]]` block
- [ ] Add `install_iterm2` call to always-install block (before menu/confirm, installed first)
- [ ] Replace `show_menu` + `install_selected` flow with a simple `gum confirm` ("Install devterm? This sets up your entire terminal environment.")
- [ ] List what will be installed in a styled box before the confirm (no interactive selection)
- [ ] Add post-install message: if not in iTerm2, show "Now open iTerm2 for the full experience!"
- [ ] Add `brew_install_formula "zoxide"` to always-install block

**Verify:** `bash install.sh` from Terminal.app proceeds past the entry check and reaches the confirm prompt.

### Phase 2: Fix lib/menu.sh — replace wizard with install_all

**Touches:** `lib/menu.sh`

**Tasks:**
- [ ] Remove all 7 `_step_*` wizard functions
- [ ] Remove `show_menu` and `install_selected` functions
- [ ] Add `install_all` function that calls every install function in sequence: VS Code, eza, fzf, gh, htop, lazygit, wget, zsh plugins, Claude Code, statusline, composer, Herd, bun, yarn, rclone, awscli, ansible, terraform, tmux, cmatrix
- [ ] Keep `_wizard_progress` visuals as a simple step counter during `install_all`
- [ ] Update `install.sh` to call `install_all` instead of `install_selected`

**Verify:** All tools listed in `install_all` are called when the installer runs.

### Phase 3: Fix fonts — add retry + verify, fix plugins always-install

**Touches:** `lib/install/fonts.sh`, `lib/install/plugins.sh`, `lib/install/tools.sh`

**Tasks:**
- [ ] In `fonts.sh`: after brew cask install, verify the font files exist in `~/Library/Fonts/`; if not, retry once
- [ ] In `fonts.sh`: check for specific Nerd Font files (e.g. `MesloLGSNerdFont-Regular.ttf`) so the check is meaningful
- [ ] In `plugins.sh`: rename to expose individual functions — `install_zsh_autosuggestions`, `install_zsh_history_search`, `install_zsh_completions`, `install_fast_syntax_highlighting` — called from `install_all`
- [ ] In `tools.sh`: add `install_zoxide` function: `brew_install_formula "zoxide"`
- [ ] Remove the dead `install_plugins()` batch function

**Verify:** After install, `ls ~/Library/Fonts/ | grep -i meslo` shows font files; `ls ~/.zsh/plugins/` shows all 4 plugin directories.

### Phase 4: Commit zshrc.template changes + end-to-end smoke test

**Touches:** `assets/zshrc.template` (commit only — already written), `assets/zshrc.template` (verify)

**Tasks:**
- [ ] Stage and commit `assets/zshrc.template` and `~/.zshrc` (user's personal file stays local, not committed — template only)
- [ ] Run a dry-run syntax check: `zsh -n assets/zshrc.template`
- [ ] Manual smoke test: `source ~/.zshrc` confirms no errors, `z --version` (zoxide), `zi` works, `eza` works, syntax highlighting active
- [ ] Update README if install command or behavior changed
- [ ] Verify `zshrc.sh` deploy function still copies template correctly

**Verify:** `zsh -n assets/zshrc.template` → no errors; smoke test passes.

## Acceptance Criteria
- [ ] `./install.sh` runs from Terminal.app without exiting early
- [ ] iTerm2 is installed automatically (no manual step needed)
- [ ] No interactive wizard — single confirm prompt then everything installs
- [ ] VS Code installs automatically
- [ ] Fonts install and are verified; retry on failure
- [ ] All plugins in zshrc.template are installed: zsh-completions, fast-syntax-highlighting, zsh-autosuggestions, zsh-history-substring-search, fzf
- [ ] zoxide installed and `z`/`zi` work after `source ~/.zshrc`
- [ ] zero errors on `source ~/.zshrc` after fresh install
- [ ] Installer ends with clear "open iTerm2" guidance when run from Terminal.app

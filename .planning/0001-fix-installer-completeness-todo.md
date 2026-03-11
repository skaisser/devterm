---
id: "0001"
title: "Fix installer completeness — no wizard, zoxide, fonts retry, all tools auto-install"
type: fix
status: approved
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
tasks_total: 19
tasks_done: 3
tags: ["installer", "zshrc", "zoxide", "iterm2", "fonts", "no-wizard"]
sessions:
  - "10/03/2026 23:39 - Plan created"
  - "10/03/2026 23:55 - Scope updated: remove wizard, add font retry, zoxide done"
  - "10/03/2026 23:58 - Plan reviewed, approved, execution strategy added"
---

# Fix: Installer Completeness — No Wizard, All Tools Auto-Install

> **Status:** In Progress
> **Branch:** `fix/installer-completeness`
> **Plan:** `0001-fix-installer-completeness-todo.md`
> **Created:** 10/03/2026 23:39
> **Progress:** Phase 0/4 — 0/19 tasks completed (3 pre-done)
>
> **Work Sessions:**
> - Session 1: 10/03/2026 23:39 - Plan created
> - Session 2: 10/03/2026 23:55 - Scope updated; zshrc.template and ~/.zshrc already updated with zoxide
> - Session 3: 10/03/2026 23:58 - Plan reviewed and approved
> - Session 4: 11/03/2026 00:01 - Execution started — dispatching 3 parallel workers (Round 1)
>
> **Rules:**
> - When completing a task, mark `[x]` with timestamp: `- [x] Task ✅ DD/MM/YYYY HH:MM`
> - Get timestamp: `date "+%d/%m/%Y %H:%M"` — NEVER guess
> - Run `/commit` after each phase
> - Phase collapsing happens on resume or plan-check — NEVER during first-run execution
> - After modifying plan files, commit plan changes: `git add .planning/ && git commit -m "..."`

## Overview

Four confirmed bugs prevented devterm from working on a friend's Mac: (1) hard-exit requiring iTerm2 before it's installed, (2) gum `--selected` silently pre-selecting nothing (tools never get installed), (3) z/zsh-completions/fast-syntax-highlighting referenced in zshrc but never installed, (4) z should be zoxide. **Additional scope from user:** remove the entire interactive wizard — just install everything automatically in a single opinionated pass. Fonts need a retry + verify step since they fail silently. zshrc.template and user's actual ~/.zshrc have already been updated with zoxide and all fixes.

## Already Done (before execution)

- [x] `~/.zshrc`: z → zoxide, removed broken alias `57378u`, removed duplicate PATH, fixed `psg`, added `alias ..`, added `tar.xz` to extract() ✅ 10/03/2026 23:50
- [x] `assets/zshrc.template`: fully rewritten from improved ~/.zshrc as canonical source ✅ 10/03/2026 23:55
- [x] `zoxide` installed via brew on dev machine ✅ 10/03/2026 23:48

## Context Pack

- **Goal:** Run `./install.sh` from any terminal on a clean Mac and get the complete devterm setup — no wizard, no missing tools, everything works after `source ~/.zshrc`.
- **Non-goals:** Adding new tools not already in the project; changing the OMP theme or color scheme.
- **Constraints:** macOS only; Homebrew-based; must run from Terminal.app (not just iTerm2); single confirm prompt then everything installs; zshrc template must load without errors.
- **Key paths:**
  - `install.sh` — entry point, remove iTerm2 gate, replace wizard call with `install_all`
  - `lib/menu.sh` — entire wizard replaced with `install_all` function
  - `lib/install/plugins.sh` — expose individual functions (contracts below)
  - `lib/install/iterm2.sh` — `install_iterm2()` added to always-install
  - `lib/install/fonts.sh` — add retry + verify logic
  - `lib/install/tools.sh` — add `install_zoxide`
  - `assets/zshrc.template` — already updated ✅
- **Function name contracts (for parallel workers):**
  - `install_zsh_autosuggestions` — in `plugins.sh`
  - `install_zsh_history_search` — in `plugins.sh`
  - `install_zsh_completions` — in `plugins.sh`
  - `install_fast_syntax_highlighting` — in `plugins.sh`
  - `install_zoxide` — in `tools.sh`
  - `install_all` — in `menu.sh` (calls all of the above + brew tools)
- **Risks:**
  1. Parallel workers writing to different files — no conflict (each phase owns distinct files).
  2. Font retry: verify by checking `~/Library/Fonts/MesloLGSNerdFont-Regular.ttf` specifically.
  3. `install_all` in Phase 2 references functions from Phase 3 — function names agreed above.
- **Verification:** `./install.sh` from Terminal.app → single confirm → all tools install → `source ~/.zshrc` → no errors → `z`, `zi`, `eza`, `fzf`, syntax highlighting all work.

## Phases

### Phase 1: Fix install.sh — remove iTerm2 gate, wire no-wizard flow [H]

**Touches:** `install.sh`

**Tasks:**
- [x] [H] Remove the hard-exit `if [[ "$TERM_PROGRAM" != "iTerm.app" ]]` block ✅ 11/03/2026 00:03
- [x] [H] Add `install_iterm2` call to always-install block (first thing, before fonts/OMP) ✅ 11/03/2026 00:03
- [x] [H] Replace `show_menu` + `install_selected` call with `install_all` (from menu.sh) ✅ 11/03/2026 00:03
- [x] [H] Add a `gum style` info box listing everything that will be installed, then `gum confirm` before proceeding ✅ 11/03/2026 00:03
- [x] [H] Add `brew_install_formula "zoxide"` to always-install block (after fonts) ✅ 11/03/2026 00:03
- [x] [H] Add post-install message: if `$TERM_PROGRAM != "iTerm.app"`, show styled "Now open iTerm2 for the full experience!" ✅ 11/03/2026 00:03

**Verify:** `bash -n install.sh` passes ✅; grep confirms no `iTerm.app` exit guard remains ✅.

### Phase 2: Replace lib/menu.sh — wizard out, install_all in [S]

**Touches:** `lib/menu.sh`

**Tasks:**
- [x] [H] Remove all 7 `_step_*` wizard functions and `show_menu` ✅ 11/03/2026 00:03
- [x] [H] Remove `install_selected` case dispatcher ✅ 11/03/2026 00:03
- [x] [S] Write `install_all` that calls every install function in order: `install_vscode`, `brew_install_formula "eza"`, `install_fzf`, `brew_install_formula "gh"`, `brew_install_formula "htop"`, `brew_install_formula "lazygit"`, `brew_install_formula "wget"`, `install_zsh_completions`, `install_zsh_autosuggestions`, `install_zsh_history_search`, `install_fast_syntax_highlighting`, `install_claude_code`, `install_claude_statusline`, `brew_install_formula "composer"`, `install_herd`, `brew_install_formula "oven-sh/bun/bun"`, `brew_install_formula "yarn"`, `brew_install_formula "rclone"`, `brew_install_formula "awscli"`, `brew_install_formula "ansible"`, `brew_install_formula "hashicorp/tap/terraform"`, `brew_install_formula "tmux"`, `brew_install_formula "cmatrix"` ✅ 11/03/2026 00:03
- [x] [H] Add a `step "..."` progress call before each install group so the user sees progress ✅ 11/03/2026 00:03

**Verify:** `bash -n lib/menu.sh` passes; `grep install_all lib/menu.sh` shows the function defined.

### Phase 3: Fix fonts retry + restructure plugin installers [S]

**Touches:** `lib/install/fonts.sh`, `lib/install/plugins.sh`, `lib/install/tools.sh`

**Tasks:**
- [x] [S] In `fonts.sh`: after `brew install --cask`, verify `~/Library/Fonts/MesloLGSNerdFont-Regular.ttf` exists; if not, retry `brew install --cask` once; print clear error if still missing ✅ 11/03/2026 00:03
- [x] [H] In `fonts.sh`: add similar verify + retry for the second font cask (Fira Code Nerd Font if present) ✅ 11/03/2026 00:03
- [x] [H] In `plugins.sh`: replace the dead `install_plugins()` batch with individual named functions: `install_zsh_autosuggestions`, `install_zsh_history_search`, `install_zsh_completions`, `install_fast_syntax_highlighting` — each clones/updates its plugin to `~/.zsh/plugins/` ✅ 11/03/2026 00:03
- [x] [H] In `tools.sh`: add `install_zoxide` function: `brew_install_formula "zoxide"` ✅ 11/03/2026 00:03
- [x] [H] Remove the dead `install_plugins()` function entirely ✅ 11/03/2026 00:03

**Verify:** `bash -n lib/install/fonts.sh lib/install/plugins.sh lib/install/tools.sh` all pass; `grep "install_zoxide\|install_zsh_completions\|install_fast_syntax_highlighting" lib/install/tools.sh lib/install/plugins.sh` shows all functions defined.

### Phase 4: Smoke test + README [H]

**Touches:** `README.md`, `lib/install/zshrc.sh` (read-only verify)

**Tasks:**
- [ ] [H] `zsh -n assets/zshrc.template` — confirm zero errors
- [ ] [H] Verify `lib/install/zshrc.sh` still copies `$DEVTERM_DIR/assets/zshrc.template` to `~/.zshrc` correctly (no path changes needed)
- [ ] [H] Scan README: update any mentions of the wizard/selection steps to reflect the new single-confirm flow; update any "run inside iTerm2" requirements
- [ ] [H] Open a new terminal tab, `source ~/.zshrc`, confirm `z`, `zi`, `eza`, `fzf` all work

**Verify:** README accurately describes the new flow; `source ~/.zshrc` produces zero errors.

## Execution Strategy

> **Approach:** Round 1 → Parallel Subagents (3 workers, dispatched simultaneously) + Round 2 → Leader Direct
> **Total Tasks:** 19 open (16x[H], 3x[S]) — 3 already done pre-plan
> **Estimated Rounds:** 2 (1 parallel, 1 leader-direct)

### Round 1: Phase 1 + Phase 2 + Phase 3 → Parallel Subagents (3 workers)

Zero file overlap — Phase 1 owns `install.sh`, Phase 2 owns `lib/menu.sh`, Phase 3 owns `lib/install/fonts.sh` + `lib/install/plugins.sh` + `lib/install/tools.sh`. Function name contracts are defined above in Context Pack.

| Phase | Worker | Model | Tasks | Notes |
|-------|--------|-------|-------|-------|
| Phase 1: install.sh fixes | worker-1 | Haiku | 1.1–1.6 (6x[H]) | Pure bash edits, no logic |
| Phase 2: menu.sh rewrite | worker-2 | Sonnet | 2.1–2.4 (1x[S]+3x[H]) | install_all must call all functions correctly |
| Phase 3: fonts + plugins | worker-3 | Sonnet | 3.1–3.5 (1x[S]+4x[H]) | Font retry logic needs care |

All 3 dispatched in ONE message. Workers should not commit — leader commits after all 3 report back.

### Round 2: Phase 4 → Leader Direct

4 mechanical [H] tasks — syntax check, README scan, verify zshrc.sh path, smoke test. No spawn needed.

## Acceptance Criteria
- [ ] `./install.sh` runs from Terminal.app without exiting early
- [ ] iTerm2 is installed automatically (no manual step needed)
- [ ] No interactive wizard — single confirm prompt then everything installs
- [ ] VS Code installs automatically
- [ ] Fonts install and are verified; retry on failure
- [ ] All plugins in zshrc.template are installed: zsh-completions, fast-syntax-highlighting, zsh-autosuggestions, zsh-history-substring-search, fzf
- [ ] zoxide installed and `z`/`zi` work after `source ~/.zshrc`
- [ ] Zero errors on `source ~/.zshrc` after fresh install
- [ ] Installer ends with clear "open iTerm2" guidance when run from Terminal.app

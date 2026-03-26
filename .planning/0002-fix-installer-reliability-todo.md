---
id: "0002"
title: "fix: Rewrite installer for reliability and idempotency"
type: fix
status: approved
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
strategy: mixed-dispatch
reviews:
  - "Phase 4 T2: clarified --uninstall handler calls uninstall() — flag parsing already in Phase 1 T1"
  - "Phase 3 T6: fixed git -C syntax to include DIR argument"
  - "Phase 5 T3: marked as Leader Direct — coordinator runs installer and verifies interactively"
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

## Tech Stack Versions
- Pure bash (no PHP/Node runtime required for installer itself)
- Target: macOS 12+ (Monterey and later)
- Homebrew (latest), Oh My Posh (latest), Nerd Fonts v3+

## Phases

### Phase 1: Foundation — install.sh + utils.sh + checks.sh

**Touches:** `install.sh`, `lib/utils.sh`, `lib/checks.sh`

- [ ] [S] Rewrite `install.sh` top section: add `set -euo pipefail`, add `--uninstall`/`--check` flag parsing, add local/remote mode detection (check if `$SCRIPT_DIR/lib` exists for local vs shallow-clone to `~/.devterm` for remote)
- [ ] [S] Rewrite `install.sh` bootstrap sequence: (1) detect/install Xcode CLT with polling loop (check `xcode-select -p` every 5s, timeout 10min), (2) detect/install Homebrew, (3) remove gum bootstrap entirely
- [ ] [H] Rewrite `install.sh` main function: source libs → show banner → run checks → pick categories → install core → install selected → install zshrc → show summary — remove all `gum` references
- [ ] [H] Add verification helpers to `lib/utils.sh`: `verify_command()` (check binary in PATH and runs), `verify_file()` (check file exists), `backup_file()` (timestamped copy like blueprint's `${FILE}.bak.${TS}` pattern)
- [ ] [H] Add `TS` timestamp variable and `DEVTERM_DIR` variable to `lib/utils.sh` for consistent use across all modules
- [ ] [H] Rewrite `lib/checks.sh`: add Xcode CLT check (`xcode-select -p`), normalize architecture (arm64/amd64 like blueprint), keep macOS version check, internet check, disk space check — remove any gum references
- [ ] [H] Add an install summary tracker to `lib/utils.sh`: arrays `INSTALLED=()`, `SKIPPED=()`, `FAILED=()` that install modules append to, with a `show_summary()` function that prints the final report

**Verify:** `bash -n install.sh && bash -n lib/utils.sh && bash -n lib/checks.sh`

### Phase 2: UI without gum — banner.sh + menu.sh

**Touches:** `lib/banner.sh`, `lib/menu.sh`

- [ ] [H] Rewrite `lib/banner.sh` `show_banner()`: keep `_gradient_print()` and `_logo_lines()` ANSI logic, replace `gum style` boxed border with manual Unicode box-drawing characters (─, │, ┌, ┐, └, ┘) via `printf`
- [ ] [H] Rewrite `lib/banner.sh` `show_done()`: replace gum-styled completion screen with pure ANSI styled output, show install summary (installed/skipped/failed counts), keep the GitHub star prompt as a simple `read -rp` prompt
- [ ] [H] Rewrite `lib/menu.sh` `pick_categories()`: replace `gum choose` with plain bash — show numbered category list, ask "Install all? [Y/n]", if 'n' then prompt Y/n per category, store selections in same `SELECTED_CATEGORIES` array
- [ ] [H] Rewrite `lib/menu.sh` `show_install_summary()`: replace gum-styled summary with printf-based table showing selected/deselected categories, confirm with `read -rp "Proceed? [Y/n]"`

**Verify:** `bash -n lib/banner.sh && bash -n lib/menu.sh`

### Phase 3: Install modules — idempotency + verification

**Touches:** `lib/install/homebrew.sh`, `lib/install/iterm2.sh`, `lib/install/fonts.sh`, `lib/install/omp.sh`, `lib/install/tools.sh`, `lib/install/plugins.sh`, `lib/install/claude.sh`, `lib/install/herd.sh`, `lib/install/zshrc.sh`

- [ ] [H] Rewrite `lib/install/homebrew.sh`: check `command -v brew` before installing, verify after with `brew --version`, track in INSTALLED/SKIPPED arrays
- [ ] [H] Rewrite `lib/install/iterm2.sh`: use `cask_installed iterm2` before installing, verify `/Applications/iTerm.app` exists after, same for VS Code (`/Applications/Visual Studio Code.app`), track results
- [ ] [H] Rewrite `lib/install/fonts.sh`: check `~/Library/Fonts/` for each font file before downloading, verify font files exist after install, remove fragile retry loop in favor of clear error message, track results
- [ ] [H] Rewrite `lib/install/omp.sh`: use `formula_installed oh-my-posh` before installing, verify `command -v oh-my-posh`, use `backup_file` before overwriting theme in `~/.zsh/themes/`, track results
- [ ] [S] Rewrite `lib/install/tools.sh`: wrap each tool install (eza, fzf, gh, htop, lazygit, wget) with `formula_installed` check, verify each with `command -v`, fix `install_nvm_node()` to properly detect Herd's node vs standalone nvm and verify `node --version` works after, track results
- [ ] [H] Rewrite `lib/install/plugins.sh`: for each plugin, if dir exists do `git -C DIR pull` (update), if not do `git clone`, verify plugin directory has `.zsh` files after, use `|| true` so network failures don't break existing installs, track results
- [ ] [S] Rewrite `lib/install/claude.sh`: check `command -v claude` before installing, verify after, use `backup_file` on `~/.claude/settings.json` before modifying, use atomic JSON write (mktemp + mv pattern from blueprint) for statusline config, track results
- [ ] [H] Rewrite `lib/install/herd.sh`: check `/Applications/Herd.app` before installing, verify after, track results
- [ ] [H] Rewrite `lib/install/zshrc.sh`: always `backup_file ~/.zshrc` before overwriting, install fresh template, verify critical markers exist in new .zshrc (Oh My Posh eval, plugin sources, PATH entries), print backup location to user, track results

**Verify:** `for f in lib/install/*.sh; do bash -n "$f"; done`

### Phase 4: Uninstall + completion

**Touches:** `install.sh`, `lib/banner.sh`, `lib/utils.sh`

- [ ] [H] Add `uninstall()` function to `install.sh`: remove `~/.devterm`, remove `~/.zsh/plugins/` (devterm-managed plugins), remove `~/.zsh/themes/skaisser.omp.json`, restore most recent `.zshrc.bak.*` if exists, remove devterm entries from `~/.claude/settings.json` using sed
- [ ] [H] Wire `--uninstall` flag (parsed in Phase 1) to call `uninstall()` with confirmation prompt before proceeding
- [ ] [H] Update `show_done()` in `lib/banner.sh` to display the `INSTALLED`/`SKIPPED`/`FAILED` summary arrays, show manual steps needed (iTerm2 color preset, font selection), show backup file locations
- [ ] [H] Wire `--check` flag (parsed in Phase 1) to run verification-only mode: checks all expected binaries, fonts, plugins, configs exist and reports what's missing without installing anything

**Verify:** `bash -n install.sh`

### Phase 5: Integration testing

**Touches:** `test.sh` (new file)

- [ ] [H] Create `test.sh` that validates installed state: checks all expected binaries (`brew`, `oh-my-posh`, `eza`, `fzf`, `zoxide`, etc.), verifies font files in `~/Library/Fonts/`, verifies plugin dirs in `~/.zsh/plugins/`, verifies `.zshrc` has critical sections, reports pass/fail per check
- [ ] [H] Run `bash -n` syntax check on all `.sh` files in the project to catch syntax errors
- [ ] [H] Run the installer on current machine with `bash install.sh` to verify end-to-end flow works (all tools already installed, so it should detect and skip everything gracefully)

**Verify:** `bash test.sh`

## Execution Strategy

> **Approach:** `/plan-approved` with mixed-dispatch (parallel Round 2)
> **Total Tasks:** 27 (H: 23, S: 4, O: 0)
> **Estimated Rounds:** 4 (1 parallel, 3 sequential)

### File-Touch Matrix

| Phase | Files/Dirs Touched | Depends On |
|-------|-------------------|------------|
| Phase 1 | `install.sh`, `lib/utils.sh`, `lib/checks.sh` | — |
| Phase 2 | `lib/banner.sh`, `lib/menu.sh` | Phase 1 (uses utils.sh helpers) |
| Phase 3 | `lib/install/*.sh` (9 files) | Phase 1 (uses utils.sh helpers) |
| Phase 4 | `install.sh`, `lib/banner.sh`, `lib/utils.sh` | Phase 1, 2, 3 |
| Phase 5 | `test.sh` (new) | Phase 1, 2, 3, 4 |

Phase 2 and Phase 3 have **zero file overlap** — safe to parallelize.

### Round 1: Phase 1 → Single Team (foundation, must go first)

| Task | Marker | Worker | Notes |
|------|--------|--------|-------|
| 1.1 install.sh top section | [S] | worker-1 | Mode detection + flag parsing |
| 1.2 bootstrap sequence | [S] | worker-1 | Xcode CLT polling + Homebrew |
| 1.3 main function | [H] | worker-2 | Remove gum, rewrite flow |
| 1.4 verify helpers | [H] | worker-2 | Utils functions |
| 1.5 TS/DEVTERM_DIR vars | [H] | worker-2 | Simple vars |
| 1.6 checks.sh | [H] | worker-2 | Pre-flight hardening |
| 1.7 summary tracker | [H] | worker-2 | Array helpers |

Model: Opus (has [S] tasks). worker-1 handles install.sh rewrites, worker-2 handles utils.sh + checks.sh.

### Round 2: Phase 2 (subagent) + Phase 3 (team-lead) → Mixed dispatch

Independent phases — Phase 2 touches `lib/banner.sh`, `lib/menu.sh` while Phase 3 touches `lib/install/*.sh`.

| Phase | Mode | Model | Tasks | Notes |
|-------|------|-------|-------|-------|
| Phase 2: banner + menu | Subagent | Sonnet | 2.1–2.4 (4x[H]) | Pure ANSI rewrites |
| Phase 3: install modules | Team-lead | Opus | 3.1–3.9 (7x[H] + 2x[S]) | 2 workers internally |

Phase 3 team-lead splits: worker-1 handles [S] tasks (tools.sh, claude.sh), worker-2 handles remaining [H] tasks.

### Round 3: Phase 4 → Single Subagent (depends on Rounds 1+2)

4 tasks, all [H]. Model: Sonnet. Wires uninstall/check flags and updates show_done.

### Round 4: Phase 5 → Leader Direct

3 tasks, all [H]. Coordinator creates test.sh, runs syntax checks, and runs the installer to verify end-to-end.

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

# @skaisser DevTerm

> One command. Perfect developer terminal on macOS, Just Like skaisser's

**Opinionated. Dark. Smart.** Built for people who live in the terminal.
Pick what you need — terminal, editor, AI, PHP, Node, DevOps — configured and ready to go.

[![Install](https://img.shields.io/badge/Install-curl_devterm.skaisser.dev_|_bash-blue?style=for-the-badge)](https://devterm.skaisser.dev) [![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-green?style=for-the-badge)](LICENSE)

> macOS only · Apple Silicon + Intel · Requires macOS 12+

![devterm installer with gradient color banner](imgs/dev-terminal-installer.png)

---

## Install

### Run in any terminal

```bash
curl -fsSL devterm.skaisser.dev | bash
```

Homebrew installs automatically if missing. No other dependencies required.
On a fresh Mac, Xcode Command Line Tools install automatically — the installer waits for completion (~15 min first time only).

A category picker lets you choose exactly what to install. Core tools always install, everything else is optional — all pre-selected by default.

The installer is **idempotent** — safe to run again anytime. It detects what's already installed and skips it. Use `--check` to see what's installed without changing anything, or `--uninstall` to cleanly remove devterm.

### After install

A Finder window opens automatically with the assets folder.

1. **Double-click `skaisser.itermcolors`** → then: `Settings → Profiles → Colors → Color Presets → skaisser`
2. **Set font:** `Settings → Profiles → Text → Font → MesloLGS Nerd Font · size 18`
3. **Open iTerm2** — everything activates automatically

---

## What you get

|                           |                                                                                                      |
| ------------------------- | ---------------------------------------------------------------------------------------------------- |
| **@skaisser Smart Theme** | Dark per-window backgrounds — each terminal gets its own color. Open 4 terminals, always know which is which. |
| **SSH danger mode**       | Full red background the moment you `ssh` into a server. Restores automatically on exit.              |
| **Oh My Posh prompt**     | Path · git branch · PHP · Node · Go · Python · time — only shown when relevant.                      |
| **Category picker**       | Choose exactly what to install — toggle categories on/off before anything runs.                      |
| **Nerd Fonts**            | MesloLGS NF + Fira Code NF — required for prompt icons.                                              |
| **50+ aliases**           | Git, Laravel, navigation, system — all wired into `.zshrc` out of the box.                           |

---

## Claude Code statusline

![Claude Code statusline showing model, context bar, tokens and folder](imgs/claude-code-status-line.png)

Live context directly in your prompt — model, visual progress bar (green → yellow → red), token count, current project.

---

## The Smart Theme

Each window gets a unique dark background based on its TTY — no config needed.

<table>
  <tr>
    <td align="center"><img src="imgs/navy-theme.png" alt="Navy theme"/></td>
    <td align="center"><img src="imgs/green-theme.png" alt="Green theme"/></td>
    <td align="center"><img src="imgs/violet-theme.png" alt="Violet theme"/></td>
  </tr>
  <tr>
    <td align="center">Indigo <code>#1a1a38</code></td>
    <td align="center">Forest green <code>#1a2a1a</code></td>
    <td align="center">Deep violet <code>#261426</code></td>
  </tr>
</table>

| Window | Color                  |
| ------ | ---------------------- |
| 1      | Deep navy `#1e2040`    |
| 2      | Forest green `#1a2a1a` |
| 3      | Burgundy `#2a1818`     |
| 4      | Indigo `#1a1a38`       |
| 5      | Teal `#0f2828`         |
| 6      | Dark plum `#1a0e2a`    |
| 7      | Deep violet `#261426`  |
| 8      | Emerald `#0e2a1a`      |

### SSH danger mode

```bash
ssh user@server  # → entire window goes red instantly so you remember you might be in production so be carefull!
```

![SSH terminal with full red background](imgs/ssh-terminal-red.png)

Restores to its original color automatically when the session ends.

---

## The prompt

![Terminal prompt showing PHP version, Node version, time and git branch](imgs/dev-terminal-php-node-time-branch.png)

```
 myapp   feat/login ~2 +1 ↑1      8.3.0   20.11.0   03:14:22
>>
```

| Segment         | Description                                                        |
| --------------- | ------------------------------------------------------------------ |
| **Path**        | Shortened: `~/Sites/myapp` → `myapp`                               |
| **Git**         | Branch · working (`~`) · staged (`+`) · ahead (`↑`) · behind (`↓`) |
| **PHP**         | Only shown inside PHP projects                                     |
| **Node**        | Only shown when `package.json` is present                          |
| **Go / Python** | Shown when relevant                                                |
| **Time**        | Right-aligned                                                      |

---

## What gets installed

The installer has a **category picker** — core tools always install, everything else is toggleable. All categories are pre-selected by default.

### Core (always installed)

These install on every run — they're the foundation of devterm.

| Tool                   | What it does                                                                                         |
| ---------------------- | ---------------------------------------------------------------------------------------------------- |
| **iTerm2**             | Modern terminal emulator for macOS — supports smart themes, per-window colors, and SSH danger mode. Skipped if already installed. |
| **Nerd Fonts**         | MesloLGS NF + Fira Code NF — patched fonts with icons required for the prompt and file listings.     |
| **Oh My Posh + theme** | Prompt engine with the custom skaisser theme — shows path, git branch, PHP/Node/Go/Python versions, and time. |
| **zoxide**             | Smart `cd` replacement — learns your most-used directories. Type `z myapp` to jump anywhere.         |
| **zshrc config**       | Complete shell configuration with 50+ aliases, functions, smart window colors, SSH danger mode, and plugin sourcing. Your existing `.zshrc` is backed up automatically. |

### Optional categories

Toggle with Space, confirm with Enter. All pre-selected by default.

#### Editor — VS Code

| Tool        | What it does                                                             |
| ----------- | ------------------------------------------------------------------------ |
| **VS Code** | Code editor by Microsoft. Installs the desktop app + `code` CLI command. |

#### CLI Tools — eza, fzf, gh, htop, lazygit, wget

| Tool        | What it does                                                                                         |
| ----------- | ---------------------------------------------------------------------------------------------------- |
| **eza**     | Modern `ls` replacement — file icons, git status indicators, tree view. Aliased to `ls` automatically. |
| **fzf**     | Fuzzy finder — `Ctrl+R` for history search, `Ctrl+T` for file search, `Alt+C` for directory jump.    |
| **gh**      | GitHub CLI — create PRs, manage issues, review code, all from the terminal.                          |
| **htop**    | Interactive process monitor — see CPU, memory, and running processes in real time.                   |
| **lazygit** | Full git TUI — stage hunks, resolve conflicts, manage branches visually.                             |
| **wget**    | Download files from the command line.                                                                |

#### Zsh Plugins — completions, autosuggestions, syntax, history

| Plugin                           | What it does                                                   |
| -------------------------------- | -------------------------------------------------------------- |
| **zsh-completions**              | Enhanced tab-completion for hundreds of commands.              |
| **zsh-autosuggestions**          | Grey ghost text as you type — press Right arrow to accept.     |
| **fast-syntax-highlighting**     | Real-time command validation — green = valid, red = not found. |
| **zsh-history-substring-search** | Press Up/Down to search history by what you've already typed.  |

#### Claude Code — AI assistant + statusline

| Tool                  | What it does                                                                                         |
| --------------------- | ---------------------------------------------------------------------------------------------------- |
| **Claude Code**       | AI coding assistant by Anthropic, wired directly into your terminal. Start with `claude`, or `claudd` to skip permissions. |
| **Claude statusline** | Live context display — model, visual progress bar (green → yellow → red), token count, current project folder. |

#### PHP / Laravel — composer, Herd

| Tool             | What it does                                                                                        |
| ---------------- | --------------------------------------------------------------------------------------------------- |
| **Composer**     | PHP package manager — install and manage project dependencies.                                      |
| **Laravel Herd** | Complete PHP dev environment — serves `project.test` with HTTPS, includes PHP + MySQL, zero config. |

#### JavaScript — nvm, Node 22+18, bun, yarn

| Tool         | What it does                                                                                        |
| ------------ | --------------------------------------------------------------------------------------------------- |
| **nvm**      | Node Version Manager — switch between Node versions per project. Installed via Homebrew.            |
| **Node 22**  | Current LTS — set as default. Required for Claude Code and modern tooling.                          |
| **Node 18**  | Legacy LTS — available for older projects. Switch with `nvm use 18`.                                |
| **Bun**      | Fast JavaScript runtime + package manager — significantly faster than npm for installs and scripts. |
| **Yarn**     | Classic Node package manager — reliable dependency management.                                      |

> If **Laravel Herd** is installed, nvm and Node are skipped — Herd manages its own Node.js.

#### DevOps — rclone

| Tool       | What it does                                                                                       |
| ---------- | -------------------------------------------------------------------------------------------------- |
| **rclone** | Cloud file sync — manage and transfer files to AWS S3, Google Drive, Backblaze, and 70+ providers. |

#### Extras — tmux, cmatrix

| Tool        | What it does                                                                  |
| ----------- | ----------------------------------------------------------------------------- |
| **tmux**    | Terminal multiplexer — split panes, persistent sessions, detach and reattach. |
| **cmatrix** | Matrix-style falling text animation. Because why not.                         |

---

## Quick reference

### Navigation

| Command          |                          |
| ---------------- | ------------------------ |
| `..` `..2` `..3` | Go up 1–3 levels         |
| `-`              | Previous directory       |
| `sites`          | Jump to `~/Sites`        |
| `z myapp`        | Jump anywhere (frecency) |
| `mkcd mydir`     | Create + enter directory |
| `cl`             | Clear                    |

### Git

| Command        |                                           |
| -------------- | ----------------------------------------- |
| `gst`          | `git status`                              |
| `gd` / `gds`   | diff / staged diff                        |
| `gco` / `gcb`  | checkout / new branch                     |
| `gadd`         | Interactive hunk staging                  |
| `gp` / `gpush` | pull / push                               |
| `glog`         | Pretty graph log                          |
| `lazygit`      | Full TUI — stage hunks, resolve conflicts |

### File listing

| Command       |                              |
| ------------- | ---------------------------- |
| `ls`          | Icons + git status           |
| `l` / `ll`    | Long list / with permissions |
| `lt` / `la`   | Tree 2 levels / full tree    |
| `dud` / `duf` | Disk usage                   |

### PHP / Laravel

| Command      |                              |
| ------------ | ---------------------------- |
| `art`        | `php artisan`                |
| `pt` / `ptp` | Pest / Pest parallel         |
| `tc` / `tcq` | Coverage / coverage parallel |
| `cda`        | `composer dump-autoload`     |
| `hfix`       | Restart Laravel Herd         |

### Claude Code

| Command  |                         |
| -------- | ----------------------- |
| `claude` | Start Claude Code       |
| `claudd` | Skip permissions prompt |

### System

| Command                 |                     |
| ----------------------- | ------------------- |
| `ports`                 | All listening ports |
| `memusage` / `cpuusage` | Top consumers       |
| `killp nginx`           | Kill by name        |
| `extract file.tar.gz`   | Extract any archive |
| `weather "Paris"`       | Current weather     |

### Fuzzy finder (fzf)

| Shortcut |                        |
| -------- | ---------------------- |
| `Ctrl+R` | Search command history |
| `Ctrl+T` | Fuzzy-search files     |
| `Alt+C`  | cd into any directory  |

---

## Customization

### Change window colors

Edit `bg_colors` in `~/.zshrc`:

```bash
local bg_colors=(
    "1e2040"    # window 1 — any hex color
    "1a2a1a"    # window 2
    ...
)
```

### Machine-specific config

Create `~/.zshrc.local` — sourced at the end of `.zshrc`, never tracked.
Use it for: API keys, work aliases, SSH agent, 1Password CLI.

---

## Requirements

- macOS 12+ — Apple Silicon or Intel
- Internet connection
- Any terminal (Terminal.app works fine — iTerm2 installs automatically)

Homebrew installs automatically. No other dependencies required.

---

## License

Apache 2.0 — use freely, share openly.

---

Made with ❤️ by **Shirleyson Kaisser** — [to@skaisser.dev](mailto:to@skaisser.dev)

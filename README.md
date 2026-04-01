# DevTerm

> One command. Perfect developer terminal on macOS.

**Opinionated. Dark. Smart.** A complete macOS terminal setup that installs in minutes and just works.
Pick what you need — terminal, editor, AI, PHP, Node, DevOps — configured and ready to go.

[![Install](https://img.shields.io/badge/Install-bash_%3C(curl_devterm.skaisser.dev)-blue?style=for-the-badge)](#install) [![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-green?style=for-the-badge)](LICENSE) [![macOS](https://img.shields.io/badge/macOS-12%2B-lightgrey?style=for-the-badge&logo=apple)](https://github.com/skaisser/devterm) [![Shell](https://img.shields.io/badge/Shell-Zsh-informational?style=for-the-badge&logo=gnu-bash)](https://github.com/skaisser/devterm)

[![GitHub stars](https://img.shields.io/github/stars/skaisser/devterm?style=social)](https://github.com/skaisser/devterm/stargazers) [![GitHub forks](https://img.shields.io/github/forks/skaisser/devterm?style=social)](https://github.com/skaisser/devterm/network/members) [![GitHub issues](https://img.shields.io/github/issues/skaisser/devterm)](https://github.com/skaisser/devterm/issues) [![GitHub last commit](https://img.shields.io/github/last-commit/skaisser/devterm)](https://github.com/skaisser/devterm/commits/main) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/skaisser/devterm/pulls)

> macOS 12+ · Apple Silicon + Intel · Works from any terminal

![devterm installer with gradient color banner](imgs/dev-terminal-installer.png)

---

## Why DevTerm?

Setting up a new Mac for development means hours of installing tools, configuring shells, picking fonts, and wiring plugins together. DevTerm does all of that in one command:

- **Smart per-window themes** — open 4 terminals, always know which is which
- **SSH danger mode** — window goes red when you're on a remote server
- **Oh My Posh prompt** — git branch, PHP/Node versions, time — only when relevant
- **50+ aliases** — git, Laravel, navigation, system — all pre-configured
- **Idempotent installer** — run it again anytime, it only installs what's missing
- **Zero dependencies** — works on a fresh Mac straight out of the box

---

## Install

### Quick install

```bash
bash <(curl -fsSL devterm.skaisser.dev)
```

### Or clone and run locally

```bash
git clone https://github.com/skaisser/devterm && cd devterm && ./install.sh
```

### Other options

```bash
./install.sh --check       # see what's installed without changing anything
./install.sh --uninstall   # cleanly remove devterm and restore previous .zshrc
```

On a fresh Mac, Xcode Command Line Tools and Homebrew install automatically — the installer waits for completion (~15 min first time only). No manual steps required.

A category picker lets you choose exactly what to install. Core tools always install, everything else is optional — all pre-selected by default.

### After install

A Finder window opens automatically with the assets folder.

1. **Double-click `skaisser.itermcolors`** then: `Settings > Profiles > Colors > Color Presets > skaisser`
2. **Set font:** `Settings > Profiles > Text > Font > MesloLGS Nerd Font, size 18`
3. **Open a new iTerm2 tab** — everything activates automatically

---

## Features

### The Smart Theme

Each terminal window gets a unique dark background based on its TTY — no config needed. Open multiple windows and always know which is which at a glance.

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

### SSH Danger Mode

```bash
ssh user@server  # entire window goes red so you never forget you're on production
```

![SSH terminal with full red background](imgs/ssh-terminal-red.png)

Restores to its original color automatically when the session ends.

### The Prompt

![Terminal prompt showing PHP version, Node version, time and git branch](imgs/dev-terminal-php-node-time-branch.png)

```
 myapp   feat/login ~2 +1 ↑1      8.3.0   20.11.0   03:14:22
>>
```

| Segment         | Description                                                        |
| --------------- | ------------------------------------------------------------------ |
| **Path**        | Shortened: `~/Sites/myapp` → `myapp`                               |
| **Git**         | Branch, working (`~`), staged (`+`), ahead (`↑`), behind (`↓`)     |
| **PHP**         | Only shown inside PHP projects                                     |
| **Node**        | Only shown when `package.json` is present                          |
| **Go / Python** | Shown when relevant                                                |
| **Time**        | Right-aligned                                                      |

### Claude Code Statusline

![Claude Code statusline showing model, context bar, tokens and folder](imgs/claude-code-status-line.png)

Live context directly in your prompt — model, visual progress bar (green to yellow to red), token count, current project.

---

## What Gets Installed

The installer has a **category picker** — core tools always install, everything else is toggleable. All categories are pre-selected by default.

### Core (always installed)

| Tool                   | What it does                                                                                         |
| ---------------------- | ---------------------------------------------------------------------------------------------------- |
| **iTerm2**             | Modern terminal emulator for macOS — supports smart themes, per-window colors, and SSH danger mode.  |
| **Nerd Fonts**         | MesloLGS NF + Fira Code NF — patched fonts with icons required for the prompt and file listings.     |
| **Oh My Posh + theme** | Prompt engine with the custom skaisser theme — shows path, git branch, language versions, and time.  |
| **zoxide**             | Smart `cd` replacement — learns your most-used directories. Type `z myapp` to jump anywhere.         |
| **zshrc config**       | Complete shell configuration with 50+ aliases, functions, smart window colors, and plugin sourcing. Your existing `.zshrc` is backed up automatically. |

### Optional categories

All pre-selected by default. Deselect what you don't need.

| Category | Tools |
| -------- | ----- |
| **Editor** | VS Code (desktop app + `code` CLI) |
| **CLI Tools** | eza (modern `ls`), fzf (fuzzy finder), gh (GitHub CLI), htop, lazygit, wget |
| **Zsh Plugins** | zsh-completions, zsh-autosuggestions, fast-syntax-highlighting, zsh-history-substring-search |
| **Claude Code** | AI coding assistant + live statusline |
| **PHP / Laravel** | Composer, Laravel Herd (serves `project.test` with HTTPS, includes PHP + MySQL) |
| **JavaScript** | nvm, Node 22 + 18, Bun, Yarn (skipped if Laravel Herd manages Node) |
| **DevOps** | rclone (cloud file sync — S3, Google Drive, Backblaze, 70+ providers) |
| **Extras** | tmux (terminal multiplexer), cmatrix (Matrix rain) |

---

## Quick Reference

<details>
<summary><strong>Navigation</strong></summary>

| Command          |                          |
| ---------------- | ------------------------ |
| `..` `..2` `..3` | Go up 1–3 levels         |
| `-`              | Previous directory       |
| `sites`          | Jump to `~/Sites`        |
| `z myapp`        | Jump anywhere (frecency) |
| `mkcd mydir`     | Create + enter directory |
| `cl`             | Clear                    |

</details>

<details>
<summary><strong>Git</strong></summary>

| Command        |                                           |
| -------------- | ----------------------------------------- |
| `gst`          | `git status`                              |
| `gd` / `gds`   | diff / staged diff                        |
| `gco` / `gcb`  | checkout / new branch                     |
| `gadd`         | Interactive hunk staging                  |
| `gp` / `gpush` | pull / push                               |
| `glog`         | Pretty graph log                          |
| `lazygit`      | Full TUI — stage hunks, resolve conflicts |

</details>

<details>
<summary><strong>File Listing</strong></summary>

| Command       |                              |
| ------------- | ---------------------------- |
| `ls`          | Icons + git status           |
| `l` / `ll`    | Long list / with permissions |
| `lt` / `la`   | Tree 2 levels / full tree    |
| `dud` / `duf` | Disk usage                   |

</details>

<details>
<summary><strong>PHP / Laravel</strong></summary>

| Command      |                              |
| ------------ | ---------------------------- |
| `art`        | `php artisan`                |
| `pt` / `ptp` | Pest / Pest parallel         |
| `tc` / `tcq` | Coverage / coverage parallel |
| `cda`        | `composer dump-autoload`     |
| `hfix`       | Restart Laravel Herd         |

</details>

<details>
<summary><strong>Claude Code</strong></summary>

| Command  |                         |
| -------- | ----------------------- |
| `claude` | Start Claude Code       |
| `claudd` | Skip permissions prompt |

</details>

<details>
<summary><strong>System</strong></summary>

| Command                 |                               |
| ----------------------- | ----------------------------- |
| `ports`                 | All listening ports           |
| `psg nginx`             | Search running processes      |
| `killp nginx`           | Kill by name (with confirm)   |
| `memusage` / `cpuusage` | Top consumers                 |
| `extract file.tar.gz`   | Extract any archive           |
| `weather "Paris"`       | Current weather               |

</details>

<details>
<summary><strong>Fuzzy Finder (fzf)</strong></summary>

| Shortcut |                        |
| -------- | ---------------------- |
| `Ctrl+R` | Search command history |
| `Ctrl+T` | Fuzzy-search files     |
| `Alt+C`  | cd into any directory  |

</details>

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

`~/.zshrc.local` is created automatically on first install with commented-out examples.
It's sourced at the end of `.zshrc` and never overwritten by reinstalls.

Use it for: API keys, work aliases, SSH agent, Docker shortcuts, custom PATH entries.

---

## Requirements

- macOS 12+ (Monterey or later)
- Apple Silicon or Intel
- Internet connection
- Any terminal (Terminal.app works — iTerm2 installs automatically)

Everything else installs automatically. No manual prerequisites.

---

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feat/my-feature`)
3. Commit your changes
4. Push to the branch (`git push origin feat/my-feature`)
5. Open a Pull Request

---

## License

[Apache 2.0](LICENSE) — use freely, share openly.

---

Made by [Shirleyson Kaisser](https://github.com/skaisser)

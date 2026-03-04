# Devterm

> **@skaisser style** — one command to set up the perfect developer terminal on macOS

Opinionated. Dark. Smart. Built for people who live in the terminal.
Includes Claude Code with a custom statusline that shows context, git status, and model — live in your prompt.

> **macOS only** — Apple Silicon and Intel. Requires macOS 12+.

![devterm installer with gradient color banner](imgs/dev-terminal-installer.png)

---

## What you get

| Component | Description |
|---|---|
| **[iTerm2](https://iterm2.com)** | Best macOS terminal — reliable, fast, scriptable |
| **[VS Code](https://code.visualstudio.com)** | Best code editor — with `code` CLI command wired in |
| **@skaisser Custom Smart Theme** | A fully custom dark color palette built from scratch. Smart theme that detects your terminal window and changes its colors based on what you are working on — especially powerful when running multiple terminals at the same time |
| **Per-window background colors** | Each window gets its own dark accent — navy, green, teal, amber, violet... |
| **SSH danger mode** | Full red background when you SSH — no more accidental production commands |
| **[Oh My Posh](https://ohmyposh.dev) + skaisser prompt** | Custom prompt: path → git branch → PHP → Node → Go → Python → time |
| **[Claude Code](https://github.com/anthropics/claude-code)** | AI coding assistant in your terminal — by Anthropic |
| **Claude Code statusline** | Context bar · token count · git branch · model name — live in your prompt |
| **[Nerd Fonts](https://www.nerdfonts.com)** | MesloLGS NF + Fira Code NF — required for icons in the prompt |
| **zsh plugins** | autosuggestions, syntax highlighting, history search, fzf, eza, z |
| **[Laravel Herd](https://herd.laravel.com)** | PHP dev environment — serves `project.test` with HTTPS, zero config |

## Claude Code statusline

The statusline shows live Claude Code context directly in your terminal:

![Claude Code statusline showing model, context bar, tokens and folder](imgs/claude-code-status-line.png)

- **Model** — which Claude model is active (`Sonnet 4.6`, `Opus`, etc.)
- **Context bar** — visual progress bar (green → yellow → red as context fills)
- **Token count** — `154K/200K` — current vs total
- **Folder** — current project name

Installed to `~/.claude/statusline.sh` and wired into `~/.claude/settings.json` automatically.

---

## Install

Open **Terminal.app** or any terminal on macOS and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/skaisser/devterm/main/install.sh)"
```

Or clone and run manually:

```bash
git clone https://github.com/skaisser/devterm
cd devterm
./install.sh
```

[Homebrew](https://brew.sh), gum, and figlet are installed automatically if missing — no manual steps needed.

---

## After installing

1. **Open iTerm2**
2. **Set theme:** `Preferences → Appearance → General → Theme → Minimal`
   *(tab bar blends with the terminal background)*
3. **Set font:** `Preferences → Profiles → Text → Font → MesloLGS NF, size 13`
4. **Set colors:** `Preferences → Profiles → Colors → Color Presets → skaisser`
5. **Reload shell:** `source ~/.zshrc`

---

## @skaisser Custom Smart Theme

Each iTerm2 window automatically gets a unique dark background based on its TTY number — no config needed.
Open 4 terminals and they'll each have a distinct color so you always know which project you're in.

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

| Window | Background | Accent |
|---|---|---|
| 1 | Deep navy `#1e2040` | Blue |
| 2 | Forest green `#1a2a1a` | Green |
| 3 | Burgundy `#2a1818` | Red |
| 4 | Indigo `#1a1a38` | Violet |
| 5 | Teal `#0f2828` | Teal |
| 6 | Amber `#2a1e0e` | Orange |
| 7 | Deep violet `#261426` | Purple |
| 8 | Emerald `#0e2a1a` | Green |

### SSH danger mode

`ssh user@server` — the entire window goes red the moment you connect.
Restores to its original color automatically when the session ends.

![SSH terminal with full red background](imgs/ssh-terminal-red.png)

---

## The prompt

![Terminal prompt showing PHP version, Node version, time and git branch](imgs/dev-terminal-php-node-time-branch.png)

```
 myapp   feat/login ~2 +1 ↑1      8.3.0   20.11.0   03:14:22
>>
```

- **Path** — shortened: `~/Sites/myapp` → `myapp`
- **Git branch** — with working (`~`), staged (`+`), ahead (`↑`), behind (`↓`) counts
- **PHP version** — only shown inside PHP projects
- **Node version** — only shown when `package.json` is present
- **Go / Python** — shown when relevant
- **Time** — right-aligned

---

## What the wizard installs

The installer walks you through 7 steps — you choose exactly what you want:

**Step 1 — Terminal & Editor**
[iTerm2](https://iterm2.com) · [VS Code](https://code.visualstudio.com) · [Nerd Fonts](https://www.nerdfonts.com) · [Oh My Posh](https://ohmyposh.dev) + skaisser theme · zshrc config · color preset

**Step 2 — Core CLI tools**
[eza](https://github.com/eza-community/eza) · [fzf](https://github.com/junegunn/fzf) · [gh](https://cli.github.com) · [htop](https://htop.dev) · [lazygit](https://github.com/jesseduffield/lazygit) · [wget](https://www.gnu.org/software/wget/) · [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) · [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) · [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)

**Step 3 — Claude Code**
[Claude Code](https://github.com/anthropics/claude-code) · statusline

**Step 4 — PHP / Laravel**
[composer](https://getcomposer.org) · [Laravel Herd](https://herd.laravel.com)

**Step 5 — JavaScript**
[bun](https://bun.sh) · [yarn](https://yarnpkg.com)

**Step 6 — DevOps / Cloud**
[rclone](https://rclone.org) · [awscli](https://aws.amazon.com/cli/) · [ansible](https://www.ansible.com) · [terraform](https://www.terraform.io)

**Step 7 — Extras**
[tmux](https://github.com/tmux/tmux) · [bfg](https://rtyley.github.io/bfg-repo-cleaner/) · [woff2](https://github.com/google/woff2) · [cmatrix](https://github.com/abishekvashok/cmatrix)

---

## Quick Reference

Everything the installed `.zshrc` gives you — no need to memorize, just look it up here.

### Navigation

| Command | What it does |
|---|---|
| `..` | Go up one directory |
| `..2` `..3` `..4` `..5` | Go up 2–5 levels |
| `-` | Go back to previous directory |
| `sites` | Jump to `~/Sites` |
| `z myapp` | Jump to `myapp` from anywhere *(frecency-based)* |
| `mkcd mydir` | Create a directory and enter it |
| `cl` | Clear the terminal |

### Git

| Command | What it does |
|---|---|
| `gst` | `git status` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gco branch` | `git checkout branch` |
| `gcb feature/name` | Create and switch to new branch |
| `gadd` | `git add -p` — interactively pick which hunks to stage |
| `gp` | `git pull` |
| `gpush` | `git push origin` |
| `glog` | Pretty graph log |
| `lazygit` | Full interactive git TUI — stage hunks, view diffs, resolve conflicts |

### File listing

| Command | What it does |
|---|---|
| `ls` | Icons + git status in listing |
| `l` | Long list, all files |
| `ll` | Long list, all files + permissions |
| `lt` | Tree view 2 levels deep |
| `ltree` | Tree view without details |
| `la` | Full tree view |
| `dud` | Disk usage, one level deep |
| `duf` | Disk usage of each item in current directory |

### PHP / Laravel

| Command | What it does |
|---|---|
| `art` | `php artisan` |
| `pt` | Run Pest tests |
| `ptp` | Run Pest tests in parallel (10 processes) |
| `tc` | Run Pest with coverage report |
| `tcq` | Run Pest with coverage, parallel |
| `cda` | `composer dump-autoload` |
| `hfix` | Restart Laravel Herd |

### Claude Code

| Command | What it does |
|---|---|
| `claude` | Start Claude Code |
| `claudd` | Start Claude Code skipping permissions prompt |

### System

| Command | What it does |
|---|---|
| `ports` | Show all listening ports |
| `psa` | `ps aux` — all running processes |
| `memusage` | Top memory consumers |
| `cpuusage` | Top CPU consumers |
| `killp nginx` | Kill a process by name |
| `df` | Disk space (human-readable) |
| `du` | Directory sizes (human-readable) |

### Utilities

| Command | What it does |
|---|---|
| `extract file.tar.gz` | Extract any archive — zip, tar, gz, bz2, rar, 7z... |
| `weather` | Current weather (default city) |
| `weather "Paris"` | Weather for a specific city |

### Fuzzy finder (fzf)

| Shortcut | What it does |
|---|---|
| `Ctrl+R` | Search command history interactively |
| `Ctrl+T` | Fuzzy-search files and paste path at cursor |
| `Alt+C` | Fuzzy-search directories and cd into one |

### zsh-autosuggestions

As you type, a grey suggestion appears based on your history. Press `→` (Right arrow) or `End` to accept it. Keep typing to ignore it.

### zsh-history-substring-search

Type part of a command (e.g. `git push`) then press `↑` / `↓` to cycle through matching history entries.

---

## Customization

### Change window background colors

Edit `bg_colors` in `~/.zshrc`:

```bash
local bg_colors=(
    "1e2040"    # window 1 — any hex color
    "1a2a1a"    # window 2
    ...
)
```

### Machine-specific overrides

Create `~/.zshrc.local` — sourced at the end of `.zshrc`, never tracked in version control.
Perfect for: API keys, 1Password CLI, work-specific aliases, SSH agent config.

### Add packages to the installer

Edit `lib/menu.sh` to add new items, then add the install function to `lib/install/`.

---

## Requirements

- **macOS 12+** — Apple Silicon or Intel
- Internet connection

[Homebrew](https://brew.sh), gum, and figlet are installed automatically if missing.

---

## License

MIT — use freely, share openly.

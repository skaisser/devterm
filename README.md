# DevTerm

> One command. Perfect developer terminal on macOS.

**Opinionated. Dark. Smart.** Built for people who live in the terminal.
Installs everything you need — iTerm2 theme, prompt, Claude Code, PHP, Node, DevOps tools — configured and ready to go.

> macOS only · Apple Silicon + Intel · Requires macOS 12+

![devterm installer with gradient color banner](imgs/dev-terminal-installer.png)

---

## Install

### 1 — Download iTerm2

**[iterm2.com](https://iterm2.com)** — download and install it first.

> devterm must run inside iTerm2. It configures your terminal live as it installs.

### 2 — Run inside iTerm2

```bash
curl -fsSL https://raw.githubusercontent.com/skaisser/devterm/main/install.sh | bash
```

Homebrew, gum, and figlet install automatically if missing.
On a fresh Mac this includes Xcode Command Line Tools — allow it and wait (~15 min first time only).

### 3 — After install

A Finder window opens automatically with the assets folder.

1. **Double-click `skaisser.itermcolors`** → then: `Settings → Profiles → Colors → Color Presets → skaisser`
2. **Set font:** `Settings → Profiles → Text → Font → MesloLGM Nerd Font Mono · size 18`
3. **Open a new iTerm2 tab** — everything activates automatically

---

## What you get

| | |
|---|---|
| **@skaisser Smart Theme** | Dark per-window backgrounds — each terminal gets its own color. Open 4 terminals, always know which is which. |
| **SSH danger mode** | Full red background the moment you `ssh` into a server. Restores automatically on exit. |
| **Oh My Posh prompt** | Path · git branch · PHP · Node · Go · Python · time — only shown when relevant. |
| **Claude Code** | AI coding assistant by Anthropic, wired directly into your terminal. |
| **Claude statusline** | Model · context bar · token count · folder — live in your prompt. |
| **Laravel Herd** | PHP dev environment. `project.test` with HTTPS, zero config. |
| **Nerd Fonts** | MesloLGS NF + Fira Code NF — required for prompt icons. |
| **zsh plugins** | autosuggestions · syntax highlighting · history search · fzf · eza · z |

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

| Window | Color |
|--------|-------|
| 1 | Deep navy `#1e2040` |
| 2 | Forest green `#1a2a1a` |
| 3 | Burgundy `#2a1818` |
| 4 | Indigo `#1a1a38` |
| 5 | Teal `#0f2828` |
| 6 | Dark plum `#1a0e2a` |
| 7 | Deep violet `#261426` |
| 8 | Emerald `#0e2a1a` |

### SSH danger mode

```bash
ssh user@server  # → entire window goes red instantly
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

| Segment | Description |
|---------|-------------|
| **Path** | Shortened: `~/Sites/myapp` → `myapp` |
| **Git** | Branch · working (`~`) · staged (`+`) · ahead (`↑`) · behind (`↓`) |
| **PHP** | Only shown inside PHP projects |
| **Node** | Only shown when `package.json` is present |
| **Go / Python** | Shown when relevant |
| **Time** | Right-aligned |

---

## Wizard — choose what you need

The installer walks you through 7 steps. Everything is pre-selected — deselect what you don't want.

| Step | Tools |
|------|-------|
| **Terminal & Editor** | VS Code · Nerd Fonts · Oh My Posh + skaisser theme · iTerm2 color preset |
| **Core CLI** | eza · fzf · gh · htop · lazygit · wget · zsh-autosuggestions · zsh-syntax-highlighting · zsh-history-substring-search |
| **Claude Code** | Claude Code · statusline |
| **PHP / Laravel** | composer · Laravel Herd |
| **JavaScript** | bun · yarn |
| **DevOps / Cloud** | rclone · awscli · ansible · terraform |
| **Extras** | tmux · bfg · woff2 · cmatrix |

> `.zshrc` is always installed — it's the foundation of devterm. Your existing one is backed up automatically.

---

## Quick reference

### Navigation

| Command | |
|---------|---|
| `..` `..2` `..3` | Go up 1–3 levels |
| `-` | Previous directory |
| `sites` | Jump to `~/Sites` |
| `z myapp` | Jump anywhere (frecency) |
| `mkcd mydir` | Create + enter directory |
| `cl` | Clear |

### Git

| Command | |
|---------|---|
| `gst` | `git status` |
| `gd` / `gds` | diff / staged diff |
| `gco` / `gcb` | checkout / new branch |
| `gadd` | Interactive hunk staging |
| `gp` / `gpush` | pull / push |
| `glog` | Pretty graph log |
| `lazygit` | Full TUI — stage hunks, resolve conflicts |

### File listing

| Command | |
|---------|---|
| `ls` | Icons + git status |
| `l` / `ll` | Long list / with permissions |
| `lt` / `la` | Tree 2 levels / full tree |
| `dud` / `duf` | Disk usage |

### PHP / Laravel

| Command | |
|---------|---|
| `art` | `php artisan` |
| `pt` / `ptp` | Pest / Pest parallel |
| `tc` / `tcq` | Coverage / coverage parallel |
| `cda` | `composer dump-autoload` |
| `hfix` | Restart Laravel Herd |

### Claude Code

| Command | |
|---------|---|
| `claude` | Start Claude Code |
| `claudd` | Skip permissions prompt |

### System

| Command | |
|---------|---|
| `ports` | All listening ports |
| `memusage` / `cpuusage` | Top consumers |
| `killp nginx` | Kill by name |
| `extract file.tar.gz` | Extract any archive |
| `weather "Paris"` | Current weather |

### Fuzzy finder (fzf)

| Shortcut | |
|----------|---|
| `Ctrl+R` | Search command history |
| `Ctrl+T` | Fuzzy-search files |
| `Alt+C` | cd into any directory |

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
- iTerm2 (download from [iterm2.com](https://iterm2.com))

Homebrew, gum, and figlet install automatically.

---

## License

MIT — use freely, share openly.

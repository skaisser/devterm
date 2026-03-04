# devterm

> **@skaisser style** — one command to set up the perfect developer terminal on macOS

Opinionated. Dark. Smart. Built for people who live in the terminal.
Includes Claude Code with a custom statusline that shows context, git status, and model — live in your prompt.

> **macOS only** — Apple Silicon and Intel. Requires macOS 12+.

![devterm installer with gradient color banner](imgs/dev-terminal-installer.png)

---

## What you get

| Component | Description |
|---|---|
| **iTerm2** | Best macOS terminal — reliable, fast, scriptable |
| **@skaisser Custom Smart Theme** | A fully custom dark color palette built from scratch. Smart theme that detects your terminal window and changes its colors based on what you are working on — especially powerful when running multiple terminals at the same time |
| **Per-window background colors** | Each window gets its own dark accent — navy, green, teal, amber, violet... |
| **SSH danger mode** | Full red background when you SSH — no more accidental production commands |
| **Oh My Posh + skaisser prompt** | Custom prompt: path → git branch → PHP → Node → Go → Python → time |
| **Claude Code** | AI coding assistant in your terminal — by Anthropic |
| **Claude Code statusline** | Context bar · token count · git branch · model name — live in your prompt |
| **Nerd Fonts** | MesloLGS NF + Fira Code NF — required for icons in the prompt |
| **zsh plugins** | autosuggestions, syntax highlighting, history search, fzf, eza, z |
| **Laravel Herd** | PHP dev environment — serves `project.test` with HTTPS, zero config |

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

The installer will automatically set up Homebrew, gum, and figlet if missing — no manual steps needed.

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

![Terminal window with green background theme](imgs/green-theme.png)

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

## Claude Code statusline

The statusline shows live Claude Code context directly in your terminal:

![Claude Code statusline showing model, context bar, tokens and folder](imgs/claude-code-status-line.png)

- **Model** — which Claude model is active (`Sonnet 4.6`, `Opus`, etc.)
- **Context bar** — visual progress bar (green → yellow → red as context fills)
- **Token count** — `154K/200K` — current vs total
- **Folder** — current project name

Installed to `~/.claude/statusline.sh` and wired into `~/.claude/settings.json` automatically.

---

## What the wizard installs

The installer walks you through 7 steps — you choose exactly what you want:

**Step 1 — Terminal setup**
iTerm2 · Nerd Fonts · Oh My Posh + skaisser theme · zshrc config · color preset

**Step 2 — Core CLI tools**
eza · fzf · gh · htop · lazygit · wget · zsh-autosuggestions · zsh-syntax-highlighting

**Step 3 — Claude Code**
Claude Code · statusline

**Step 4 — PHP / Laravel**
composer · Laravel Herd

**Step 5 — JavaScript**
bun · yarn

**Step 6 — DevOps / Cloud**
rclone · awscli · ansible · terraform

**Step 7 — Extras**
tmux · bfg · woff2 · cmatrix

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

### Add packages to the installer

Edit `lib/menu.sh` to add new items, then add the install function to `lib/install/`.

---

## Requirements

- **macOS 12+** — Apple Silicon or Intel
- Internet connection

Homebrew, gum, and figlet are installed automatically if missing.

---

## License

MIT — use freely, share openly.

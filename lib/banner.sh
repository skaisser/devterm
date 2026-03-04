#!/usr/bin/env bash
# lib/banner.sh — opening banner and closing screen

# ── ANSI 256-color gradient printer ─────────────────────────────────────────
_gradient_print() {
    local text="$1"
    local theme="$2"

    local colors
    IFS=' ' read -ra colors <<< "$theme"
    local nc="${#colors[@]}"

    local i=0
    while IFS= read -r line; do
        local color="${colors[$((i % nc))]}"
        printf "\033[38;5;%sm%s\033[0m\n" "$color" "$line"
        (( i++ ))
    done <<< "$text"
}

# ── Block-art logo ("DEVTERM") ───────────────────────────────────────────────
# Hand-crafted Unicode box-drawing — same style as Laravel installer
_logo_lines() {
    printf '%s\n' \
        "" \
        "  ██████╗ ███████╗██╗   ██╗████████╗███████╗██████╗ ███╗   ███╗" \
        "  ██╔══██╗██╔════╝██║   ██║╚══██╔══╝██╔════╝██╔══██╗████╗ ████║" \
        "  ██║  ██║█████╗  ╚██╗ ██╔╝   ██║   █████╗  ██████╔╝██╔████╔██║" \
        "  ██║  ██║██╔══╝   ╚████╔╝    ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║" \
        "  ██████╔╝███████╗  ╚██╔╝     ██║   ███████╗██║  ██║██║ ╚═╝ ██║" \
        "  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝" \
        ""
}

show_banner() {
    clear
    echo ""

    # ── Gradient themes (8 colors, one per logo line incl. blanks) ──────────
    local themes=(
        "213 213 207 177 141 105 69  39"    # Vaporwave: pink → purple → blue
        "196 196 202 208 214 220 226 226"   # Fire: red → orange → yellow
        "51  51  45  39  33  27  21  21"    # Ice: cyan → blue
        "201 201 165 129 93  57  21  21"    # Cyberpunk: magenta → blue
        "46  46  82  118 154 190 226 226"   # Matrix: dark → bright green
        "99  99  141 183 219 225 231 231"   # Lavender rise
        "214 214 208 202 196 160 124 88"    # Sunset: orange → deep red
        "87  87  81  75  69  63  57  51"    # Deep ocean fade
    )

    local chosen="${themes[$((RANDOM % ${#themes[@]}))]}"
    _gradient_print "$(_logo_lines)" "$chosen"

    # ── Info box — bright colors for visibility on any dark background ────────
    echo ""
    gum style \
        --border rounded \
        --border-foreground="#bd93f9" \
        --padding "1 4" \
        --margin "0 2" \
        "$(gum style --foreground='#ff79c6' --bold '@skaisser') $(gum style --foreground='#ffffff' --bold 'Custom Smart Theme')" \
        "" \
        "$(gum style --foreground='#8be9fd' 'A smart terminal setup that detects your window and adapts')" \
        "$(gum style --foreground='#8be9fd' 'its colors to what you are working on — built for developers')" \
        "$(gum style --foreground='#8be9fd' 'who run multiple terminals at the same time.')"

    echo ""
    printf "\033[38;5;141m  iTerm2  ·  Oh My Posh  ·  Claude Code  ·  zsh  ·  Laravel Herd\033[0m\n"

    echo ""
    printf "\033[38;5;83m  Press Enter to begin the setup wizard →\033[0m\n"
    echo ""

    # Wait for keypress before starting wizard
    read -r -s -n 1
}

show_done() {
    clear
    echo ""

    gum style \
        --border double \
        --border-foreground="#50fa7b" \
        --padding "1 4" \
        --margin "0 2" \
        "$(gum style --foreground='#50fa7b' --bold '  Installation complete!')" \
        "" \
        "$(gum style --foreground='#ffffff' --bold 'Next steps:')" \
        "" \
        "$(gum style --foreground='#8be9fd' '  1.  Open iTerm2')" \
        "$(gum style --foreground='#8be9fd' '  2.  Preferences → Appearance → General → Theme → Minimal')" \
        "$(gum style --foreground='#8be9fd' '  3.  Preferences → Profiles → Text → Font → MesloLGS NF')" \
        "$(gum style --foreground='#8be9fd' '  4.  Profiles → Colors → Color Presets → skaisser')" \
        "$(gum style --foreground='#8be9fd' '  5.  Run:  source ~/.zshrc')" \
        "" \
        "$(gum style --foreground='#bd93f9' '  github.com/skaisser/devterm')"

    echo ""

    if gum confirm \
        --prompt.foreground="#ffb86c" \
        --selected.background="#ffb86c" \
        --selected.foreground="#000000" \
        "  ⭐  Enjoying devterm? Star us on GitHub!"; then
        open "https://github.com/skaisser/devterm"
    fi

    echo ""
}

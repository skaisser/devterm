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

# ── Draw a box using Unicode box-drawing characters ──────────────────────────
# Usage: _draw_box WIDTH LINE [LINE ...]
_draw_box() {
    local width="$1"; shift
    local inner=$((width - 2))

    # Top border
    printf "\033[38;5;141m  ┌"
    printf '─%.0s' $(seq 1 $inner)
    printf "┐\033[0m\n"

    # Content lines
    for line in "$@"; do
        printf "\033[38;5;141m  │\033[0m  %s" "$line"
        # Calculate visible length (strip ANSI escape codes for padding)
        local visible
        visible=$(printf '%s' "$line" | sed 's/\x1b\[[0-9;]*m//g')
        local pad=$(( inner - ${#visible} - 2 ))
        if (( pad > 0 )); then
            printf '%*s' "$pad" ''
        fi
        printf "\033[38;5;141m  │\033[0m\n"
    done

    # Bottom border
    printf "\033[38;5;141m  └"
    printf '─%.0s' $(seq 1 $inner)
    printf "┘\033[0m\n"
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

    local title_line
    title_line="$(printf '\033[38;5;205m\033[1m@skaisser\033[0m \033[1;37mCustom Smart Theme\033[0m')"

    local desc1="$(printf '\033[38;5;81mA smart terminal setup that detects your window and adapts\033[0m')"
    local desc2="$(printf '\033[38;5;81mits colors to what you are working on — built for developers\033[0m')"
    local desc3="$(printf '\033[38;5;81mwho run multiple terminals at the same time.\033[0m')"

    # Box width: enough to fit the widest visible line + 4 padding chars + 2 border chars
    # Widest visible: "@skaisser Custom Smart Theme" = 28 chars
    # Widest desc: "its colors to what you are working on — built for developers" = 60 chars
    # inner = 60 + 4 = 64, total width = 66
    local box_width=70

    local inner=$(( box_width - 2 ))
    printf "\033[38;5;141m  ┌"
    printf '─%.0s' $(seq 1 $inner)
    printf "┐\033[0m\n"

    # Empty padding line
    printf "\033[38;5;141m  │%*s│\033[0m\n" $inner ''

    # Title line
    local title_visible="@skaisser Custom Smart Theme"
    local title_pad=$(( inner - ${#title_visible} - 4 ))
    printf "\033[38;5;141m  │\033[0m  %s" "$title_line"
    (( title_pad > 0 )) && printf '%*s' "$title_pad" ''
    printf "  \033[38;5;141m│\033[0m\n"

    # Empty separator line
    printf "\033[38;5;141m  │%*s│\033[0m\n" $inner ''

    # Description lines
    local descs=("$desc1" "$desc2" "$desc3")
    local descs_visible=(
        "A smart terminal setup that detects your window and adapts"
        "its colors to what you are working on — built for developers"
        "who run multiple terminals at the same time."
    )
    for idx in 0 1 2; do
        local vis_len=${#descs_visible[$idx]}
        local d_pad=$(( inner - vis_len - 4 ))
        printf "\033[38;5;141m  │\033[0m  %s" "${descs[$idx]}"
        (( d_pad > 0 )) && printf '%*s' "$d_pad" ''
        printf "  \033[38;5;141m│\033[0m\n"
    done

    # Empty padding line
    printf "\033[38;5;141m  │%*s│\033[0m\n" $inner ''

    printf "\033[38;5;141m  └"
    printf '─%.0s' $(seq 1 $inner)
    printf "┘\033[0m\n"

    echo ""
    printf "\033[38;5;141m  iTerm2  ·  Oh My Posh  ·  Claude Code  ·  zsh  ·  Laravel Herd\033[0m\n"

    echo ""
    printf "\033[38;5;83m  Press Enter to begin the setup wizard →\033[0m\n"
    echo ""

    # Wait for keypress before starting wizard (60s timeout — auto-continues)
    read -r -s -n 1 -t 60 || true
}

show_done() {
    clear
    echo ""

    # ── Detect terminal for context-aware messages ────────────────────────────
    local in_iterm=false
    [[ "${TERM_PROGRAM:-}" == "iTerm.app" ]] && in_iterm=true

    # ── Completion box ────────────────────────────────────────────────────────
    local box_width=72
    local inner=$(( box_width - 2 ))

    printf "\033[38;5;83m  ┌"
    printf '─%.0s' $(seq 1 $inner)
    printf "┐\033[0m\n"

    # Empty padding line
    printf "\033[38;5;83m  │%*s│\033[0m\n" $inner ''

    # Title
    local title="  Installation complete!"
    local title_vis="  Installation complete!"
    local t_pad=$(( inner - ${#title_vis} - 2 ))
    printf "\033[38;5;83m  │\033[0m\033[32m\033[1m%s\033[0m" "$title"
    (( t_pad > 0 )) && printf '%*s' "$t_pad" ''
    printf " \033[38;5;83m│\033[0m\n"

    printf "\033[38;5;83m  │%*s│\033[0m\n" $inner ''

    if $in_iterm; then
        # ── iTerm2-specific next steps ────────────────────────────────────
        local hdr="Next steps in iTerm2:"
        local hdr_pad=$(( inner - ${#hdr} - 4 ))
        printf "\033[38;5;83m  │\033[0m  \033[1;37m%s\033[0m" "$hdr"
        (( hdr_pad > 0 )) && printf '%*s' "$hdr_pad" ''
        printf "  \033[38;5;83m│\033[0m\n"

        printf "\033[38;5;83m  │%*s│\033[0m\n" $inner ''

        # Step 1
        local s1a="  1.  A Finder window is opening — double-click skaisser.itermcolors"
        local s1b="         then: Settings → Profiles → Colors → Color Presets → skaisser"
        local s1a_pad=$(( inner - ${#s1a} - 2 ))
        local s1b_pad=$(( inner - ${#s1b} - 2 ))

        printf "\033[38;5;83m  │\033[0m\033[38;5;81m%s\033[0m" "$s1a"
        (( s1a_pad > 0 )) && printf '%*s' "$s1a_pad" ''
        printf " \033[38;5;83m│\033[0m\n"

        printf "\033[38;5;83m  │\033[0m\033[38;5;81m%s\033[0m" "$s1b"
        (( s1b_pad > 0 )) && printf '%*s' "$s1b_pad" ''
        printf " \033[38;5;83m│\033[0m\n"

        printf "\033[38;5;83m  │%*s│\033[0m\n" $inner ''

        # Step 2
        local s2a="  2.  Settings → Profiles → Text → Font"
        local s2b="         MesloLGS Nerd Font  ·  size 18"
        local s2a_pad=$(( inner - ${#s2a} - 2 ))
        local s2b_pad=$(( inner - ${#s2b} - 2 ))

        printf "\033[38;5;83m  │\033[0m\033[38;5;81m%s\033[0m" "$s2a"
        (( s2a_pad > 0 )) && printf '%*s' "$s2a_pad" ''
        printf " \033[38;5;83m│\033[0m\n"

        printf "\033[38;5;83m  │\033[0m\033[38;5;81m%s\033[0m" "$s2b"
        (( s2b_pad > 0 )) && printf '%*s' "$s2b_pad" ''
        printf " \033[38;5;83m│\033[0m\n"

        printf "\033[38;5;83m  │%*s│\033[0m\n" $inner ''

        # Step 3
        local s3a="  3.  Open a new iTerm2 tab — everything activates automatically"
        local s3a_pad=$(( inner - ${#s3a} - 2 ))

        printf "\033[38;5;83m  │\033[0m\033[38;5;81m%s\033[0m" "$s3a"
        (( s3a_pad > 0 )) && printf '%*s' "$s3a_pad" ''
        printf " \033[38;5;83m│\033[0m\n"
    else
        # ── Terminal.app / other terminal next steps ──────────────────────
        local hdr="Next steps:"
        local hdr_pad=$(( inner - ${#hdr} - 4 ))
        printf "\033[38;5;83m  │\033[0m  \033[1;37m%s\033[0m" "$hdr"
        (( hdr_pad > 0 )) && printf '%*s' "$hdr_pad" ''
        printf "  \033[38;5;83m│\033[0m\n"

        printf "\033[38;5;83m  │%*s│\033[0m\n" $inner ''

        # Step 1
        local s1a="  1.  Open iTerm2 from Applications for the full experience"
        local s1a_pad=$(( inner - ${#s1a} - 2 ))
        printf "\033[38;5;83m  │\033[0m\033[38;5;81m%s\033[0m" "$s1a"
        (( s1a_pad > 0 )) && printf '%*s' "$s1a_pad" ''
        printf " \033[38;5;83m│\033[0m\n"

        printf "\033[38;5;83m  │%*s│\033[0m\n" $inner ''

        # Step 2
        local s2a="  2.  In iTerm2: double-click skaisser.itermcolors from Finder"
        local s2b="         then: Settings → Profiles → Colors → Color Presets → skaisser"
        local s2a_pad=$(( inner - ${#s2a} - 2 ))
        local s2b_pad=$(( inner - ${#s2b} - 2 ))

        printf "\033[38;5;83m  │\033[0m\033[38;5;81m%s\033[0m" "$s2a"
        (( s2a_pad > 0 )) && printf '%*s' "$s2a_pad" ''
        printf " \033[38;5;83m│\033[0m\n"

        printf "\033[38;5;83m  │\033[0m\033[38;5;81m%s\033[0m" "$s2b"
        (( s2b_pad > 0 )) && printf '%*s' "$s2b_pad" ''
        printf " \033[38;5;83m│\033[0m\n"

        printf "\033[38;5;83m  │%*s│\033[0m\n" $inner ''

        # Step 3
        local s3a="  3.  Settings → Profiles → Text → Font → MesloLGS Nerd Font, 18"
        local s3a_pad=$(( inner - ${#s3a} - 2 ))

        printf "\033[38;5;83m  │\033[0m\033[38;5;81m%s\033[0m" "$s3a"
        (( s3a_pad > 0 )) && printf '%*s' "$s3a_pad" ''
        printf " \033[38;5;83m│\033[0m\n"
    fi

    printf "\033[38;5;83m  │%*s│\033[0m\n" $inner ''

    # Repo link
    local repo="  github.com/skaisser/devterm"
    local repo_pad=$(( inner - ${#repo} - 2 ))
    printf "\033[38;5;83m  │\033[0m\033[38;5;141m%s\033[0m" "$repo"
    (( repo_pad > 0 )) && printf '%*s' "$repo_pad" ''
    printf " \033[38;5;83m│\033[0m\n"

    printf "\033[38;5;83m  │%*s│\033[0m\n" $inner ''

    printf "\033[38;5;83m  └"
    printf '─%.0s' $(seq 1 $inner)
    printf "┘\033[0m\n"

    echo ""

    # ── Install summary ───────────────────────────────────────────────────────
    show_summary

    # Show backup location if a .zshrc backup was created during this run
    local latest_backup
    latest_backup=$(ls -t "$HOME/.zshrc.bak."* 2>/dev/null | head -1)
    if [[ -n "${latest_backup:-}" ]]; then
        info "Previous .zshrc backed up to: $latest_backup"
    fi

    echo ""

    # GitHub star prompt (10s timeout — auto-skips if user walks away)
    read -t 10 -rp "  ⭐  Enjoying devterm? Star us on GitHub! [Y/n] " ans || ans="n"
    case "$(printf '%s' "$ans" | tr '[:upper:]' '[:lower:]')" in
        ''|y|yes)
            open "https://github.com/skaisser/devterm"
            ;;
    esac

    echo ""

    # Open the assets folder AFTER all prompts so it doesn't steal focus
    open "${DEVTERM_DIR:-$HOME/.devterm}/assets/"
}

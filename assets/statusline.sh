#!/bin/bash

# Claude Code Status Line Script
# Converted from Oh My Posh theme: skaisser.omp.json

input=$(cat)
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // ""')

# Display relative path from project root if available
if [ -n "$project_dir" ] && [ "$current_dir" != "$project_dir" ]; then
    rel_path="${current_dir#$project_dir/}"
    if [ "$rel_path" = "$current_dir" ]; then
        dir_display=$(basename "$current_dir")
    else
        dir_display="$(basename "$project_dir")/$rel_path"
    fi
else
    dir_display=$(basename "$current_dir")
fi

# Context window calculation
pct=0
tokens=""
usage=$(echo "$input" | jq '.context_window.current_usage')
if [ "$usage" != "null" ]; then
    input_tokens=$(echo "$usage" | jq '.input_tokens // 0')
    cache_create=$(echo "$usage" | jq '.cache_creation_input_tokens // 0')
    cache_read=$(echo "$usage" | jq '.cache_read_input_tokens // 0')
    current=$((input_tokens + cache_create + cache_read))
    size=$(echo "$input" | jq '.context_window.context_window_size // 1')
    if [ "$size" != "null" ] && [ "$size" -gt 0 ]; then
        pct=$((current * 100 / size))
    fi
    # Format tokens with K suffix - show current/total
    if [ "$current" -ge 1000 ]; then
        current_display="$((current / 1000))K"
    else
        current_display="$current"
    fi
    if [ "$size" -ge 1000 ]; then
        size_display="$((size / 1000))K"
    else
        size_display="$size"
    fi
    tokens="${current_display}/${size_display}"
fi

# Progress bar (10 chars wide)
bar_width=10
filled=$((pct * bar_width / 100))
empty=$((bar_width - filled))
bar=""
for ((i=0; i<filled; i++)); do bar+="█"; done
for ((i=0; i<empty; i++)); do bar+="░"; done

# Color the bar based on usage (matching Oh My Posh git background templates)
if [ "$pct" -lt 50 ]; then
    bar_color="\033[32m"  # Green (addb67)
elif [ "$pct" -lt 80 ]; then
    bar_color="\033[33m"  # Yellow (e4cf6a)
else
    bar_color="\033[31m"  # Red (f78c6c)
fi

# Git info (matching Oh My Posh git segment)
git_info=""
if git -C "$current_dir" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git -C "$current_dir" --no-optional-locks branch --show-current 2>/dev/null)
    if [ -n "$git_branch" ]; then
        # Check for working changes
        working_changed=""
        if ! git -C "$current_dir" --no-optional-locks diff --quiet 2>/dev/null; then
            working_count=$(git -C "$current_dir" --no-optional-locks diff --numstat 2>/dev/null | wc -l | tr -d ' ')
            if [ "$working_count" -gt 0 ]; then
                working_changed=" ~${working_count}"
            fi
        fi

        # Check for staged changes
        staging_changed=""
        if ! git -C "$current_dir" --no-optional-locks diff --cached --quiet 2>/dev/null; then
            staging_count=$(git -C "$current_dir" --no-optional-locks diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
            if [ "$staging_count" -gt 0 ]; then
                staging_changed=" +${staging_count}"
            fi
        fi

        # Check for ahead/behind
        upstream_info=""
        upstream=$(git -C "$current_dir" --no-optional-locks rev-parse --abbrev-ref @{upstream} 2>/dev/null)
        if [ -n "$upstream" ]; then
            ahead=$(git -C "$current_dir" --no-optional-locks rev-list --count @{upstream}..HEAD 2>/dev/null || echo 0)
            behind=$(git -C "$current_dir" --no-optional-locks rev-list --count HEAD..@{upstream} 2>/dev/null || echo 0)
            if [ "$ahead" -gt 0 ]; then
                upstream_info="↑${ahead}"
            fi
            if [ "$behind" -gt 0 ]; then
                upstream_info="${upstream_info}↓${behind}"
            fi
            if [ -n "$upstream_info" ]; then
                upstream_info=" ${upstream_info}"
            fi
        fi

        git_info="${git_branch}${upstream_info}${working_changed}${staging_changed}"
    fi
fi

# Current time (matching Oh My Posh time segment format)
current_time=$(date +%H:%M:%S)

# Colors (based on Oh My Posh theme)
reset="\033[0m"
dim="\033[2m"
blue="\033[34m"      # Path (82AAFF)
green="\033[32m"     # Git (addb67)
cyan="\033[36m"      # Context percentage
yellow="\033[33m"    # Tokens
magenta="\033[35m"   # Model name
gray="\033[37m"      # Time

# Build status line: Model | Progress Bar | Percentage | Tokens | Git | Folder
output=""

# Model segment
output+="${magenta}${model_name}${reset}"

# Context window segment (Progress Bar + Percentage)
output+=" ${dim}│${reset} "
output+="${bar_color}${bar}${reset}"
output+=" ${cyan}${pct}%${reset}"

# Tokens segment
if [ -n "$tokens" ]; then
    output+=" ${dim}│${reset} "
    output+="${yellow}${tokens}${reset}"
fi

# Git segment (branch only)
if [ -n "$git_info" ]; then
    output+=" ${dim}│${reset} "
    output+="${green}${git_info}${reset}"
fi

# Folder segment
output+=" ${dim}│${reset} "
output+="${blue}${dir_display}${reset}"

echo -e "$output"

#!/usr/bin/env bash
# lib/install/plugins.sh — zsh plugins (uses install_zsh_plugin from tools.sh)

install_zsh_autosuggestions()      { install_zsh_plugin "zsh-users/zsh-autosuggestions"; }
install_zsh_history_search()       { install_zsh_plugin "zsh-users/zsh-history-substring-search"; }
install_zsh_completions()          { install_zsh_plugin "zsh-users/zsh-completions"; }
install_fast_syntax_highlighting() { install_zsh_plugin "zdharma-continuum/fast-syntax-highlighting"; }

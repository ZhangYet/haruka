# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc
# Minimal, fast, extensible zsh config (Wayland-friendly)
# Requirements:
# 1) minimal + extensible
# 2) plugin manager (zinit), auto-install
# 3) blue-ish theme + theme switch
# 4) git aliases
# 5) fzf-based history search

[[ -o interactive ]] || return

# Get the directory where this zshrc is located (handles symlinks)
# %x is the path of the file being sourced, :A resolves symlinks and makes absolute
ZSH_CONFIG_DIR="${${(%):-%x}:A:h}/zsh"

# Source configuration files
[[ -r "${ZSH_CONFIG_DIR}/env.zsh" ]] && source "${ZSH_CONFIG_DIR}/env.zsh"
[[ -r "${ZSH_CONFIG_DIR}/plugin.zsh" ]] && source "${ZSH_CONFIG_DIR}/plugin.zsh"
[[ -r "${ZSH_CONFIG_DIR}/theme.zsh" ]] && source "${ZSH_CONFIG_DIR}/theme.zsh"
[[ -r "${ZSH_CONFIG_DIR}/alias.zsh" ]] && source "${ZSH_CONFIG_DIR}/alias.zsh"

# Extensibility hook (optional local overrides)
# Put machine-specific, private, or experimental stuff here:
#   ~/.config/zsh/local.zsh
ZSH_LOCAL="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/local.zsh"
[[ -r "$ZSH_LOCAL" ]] && source "$ZSH_LOCAL"

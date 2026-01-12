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

# ------------------------------
# 0) Baseline options (fast; builtin only)
# ------------------------------
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS
setopt AUTO_CD

# History (fast + sane)
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
HISTSIZE=20000
SAVEHIST=20000
: "${HISTFILE:=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history}"

# Keymap: emacs (your requirement)
bindkey -e

# ------------------------------
# 1) Plugin manager: zinit (auto-install)
# ------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -r "${ZINIT_HOME}/zinit.zsh" ]]; then
  mkdir -p -- "${ZINIT_HOME:h}"
  command -v git >/dev/null 2>&1 || { print -u2 "zsh: git not found; cannot install zinit."; return; }
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}" >/dev/null 2>&1 \
    || { print -u2 "zsh: failed to clone zinit."; return; }
fi
source "${ZINIT_HOME}/zinit.zsh"

# ------------------------------
# 2) Theme (blue-ish default) + switching
# ------------------------------
# Persist theme choice here:
ZSH_THEME_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/theme"
mkdir -p -- "${ZSH_THEME_FILE:h}" 2>/dev/null

if [[ -r "$ZSH_THEME_FILE" ]]; then
  ZSH_THEME="$(<"$ZSH_THEME_FILE")"
fi
: "${ZSH_THEME:=pure}"   # default: pure (blue/cyan-ish, fast)

# Minimal fallback prompt (in case theme plugin fails)
PROMPT='%n@%m:%~ %# '

# Load theme via zinit (plugins managed here)
case "$ZSH_THEME" in
  pure)
    # Pure prompt: light, blue-ish by default
    zinit ice depth=1
    zinit light sindresorhus/pure
    ;;
  p10k|powerlevel10k)
    # Powerlevel10k: powerful; you should generate ~/.p10k.zsh later via `p10k configure`
    zinit ice depth=1
    zinit light romkatv/powerlevel10k
    [[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
    ;;
  *)
    print -u2 "zsh: unknown theme '$ZSH_THEME' (using fallback prompt)"
    ;;
esac

# Theme switcher:
#   ztheme pure
#   ztheme p10k
ztheme() {
  local t="$1"
  if [[ -z "$t" ]]; then
    print "Current theme: ${ZSH_THEME}"
    print "Usage: ztheme pure|p10k"
    return 0
  fi
  case "$t" in
    pure|p10k|powerlevel10k)
      print -r -- "$t" >| "$ZSH_THEME_FILE"
      print "Theme set to '$t'. Reopen terminal or run: exec zsh"
      ;;
    *)
      print -u2 "Unknown theme: $t"
      return 1
      ;;
  esac
}

# ------------------------------
# 3) Git aliases (common, minimal)
# ------------------------------
alias g='git'
alias gst='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gl='git log --oneline --decorate --graph -20'
alias glo='git log --oneline --decorate --graph'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull --rebase'
alias gcl='git clone'

# ------------------------------
# 4) fzf-based history search (Ctrl-R)
# ------------------------------
# Requires: fzf (recommend: sudo pacman -S fzf)
# This is implemented as a zle widget (no extra plugin needed).
_fzf_history_widget() {
  # If fzf missing, fallback to default reverse search
  command -v fzf >/dev/null 2>&1 || { zle history-incremental-search-backward; return; }

  # Use builtin history: fc (fast)
  # -l: list, -n: no line numbers, -r: reverse (newest first)
  local selected
  selected=$(
    fc -lnr 1 \
    | sed 's/^[[:space:]]*//' \
    | awk 'NF' \
    | fzf --height=40% --reverse --tiebreak=index --no-sort --prompt='history> ' \
  ) || return 0

  # Put into command line buffer
  LBUFFER+="$selected"
  zle redisplay
}
zle -N _fzf_history_widget
bindkey '^R' _fzf_history_widget

# ------------------------------
# 5) Completion (keep it simple & reasonably fast)
# ------------------------------
autoload -Uz compinit
_compdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p -- "${_compdump:h}" 2>/dev/null
compinit -d "$_compdump" -C

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ------------------------------
# 6) Extensibility hook (optional local overrides)
# ------------------------------
# Put machine-specific, private, or experimental stuff here:
#   ~/.config/zsh/local.zsh
ZSH_LOCAL="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/local.zsh"
[[ -r "$ZSH_LOCAL" ]] && source "$ZSH_LOCAL"

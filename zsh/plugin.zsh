# Plugin manager and plugins
# ------------------------------

# Plugin manager: zinit (auto-install)
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -r "${ZINIT_HOME}/zinit.zsh" ]]; then
  mkdir -p -- "${ZINIT_HOME:h}"
  command -v git >/dev/null 2>&1 || { print -u2 "zsh: git not found; cannot install zinit."; return; }
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}" >/dev/null 2>&1 \
    || { print -u2 "zsh: failed to clone zinit."; return; }
fi
source "${ZINIT_HOME}/zinit.zsh"

# Directory jumping plugin: zsh-z
# Usage: z <directory-name> to jump to frequently used directories
# Example: z repos -> jumps to ~/repos or similar
zinit ice wait lucid
zinit light agkozak/zsh-z

# Directory jumping: alias j to z (zsh-z plugin)
# Usage: j <directory-name> to jump to frequently used directories
j() {
  z "$@"
}


# fzf-based history search (Ctrl-R)
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

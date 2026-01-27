# Environment and shell options
# ------------------------------

# Baseline options (fast; builtin only)
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

# Keymap: emacs
bindkey -e

# Completion (keep it simple & reasonably fast)
autoload -Uz compinit
_compdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p -- "${_compdump:h}" 2>/dev/null
compinit -d "$_compdump" -C

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

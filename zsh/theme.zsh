# Theme configuration and switcher
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

# options — shared between users (no secrets, no user-specific paths)

# Enable command auto-correction
setopt correct

# Enable case-insensitive globbing (e.g., "ls" matches "LS" or "lS")
setopt no_case_glob

# Enable extended globbing (e.g., ** to match recursively)
setopt extended_glob

setopt prompt_subst
# Set default editor to nano (you can change this to vim, emacs, etc.)
export EDITOR="helix"

# Enable color support for ls and other utilities
autoload -Uz colors && colors

# Enable completion
autoload -U compinit
compinit

# LSCOLORS
export CLICOLOR=1
export LSCOLORS="exfxcxdxbxegedabagacad"

#export LSCOLORS=ExFxCxDxBxegedabagacad


# History settings (optional)
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt inc_append_history share_history hist_ignore_all_dups hist_reduce_blanks

# fzf: Ctrl+R history, Ctrl+T files, Alt+C cd
if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

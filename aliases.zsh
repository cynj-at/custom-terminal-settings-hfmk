# aliases — shared between users (no secrets, no user-specific paths)

# Alias definitions (optional)
if command -v eza >/dev/null; then
  alias ll='eza -l'
  alias la='eza -la'
else
  alias ll='ls -l'
  alias la='ls -la'
fi
alias c='clear'
alias rm='rm -i'
alias ffp='ffprobe -hide_banner -i'
alias ffm='ffmpeg -hide_banner -i'
alias sz='source ~/.zshrc'
alias cz='code ~/.zshrc'
alias find_largest_home_files='du -xh ~ 2>/dev/null | sort -hr | head -30'

alias hx='helix'

# git
alias gstat='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpu='git push --set-upstream origin'
alias gpf='git push --force-with-lease'
alias gl='git pull'
alias glo='git pull origin'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gsir='git submodule update --init --recursive'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gbr='git branch'
alias gbrmt='git branch -r'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gm='git merge'
alias gr='git rebase'
alias gri='git rebase -i'
alias gst='git stash'
alias gstp='git stash pop'
alias gd='git diff'
alias gdc='git diff --cached'
alias glog='git log --oneline --graph --decorate'
alias glogh='git log --oneline --graph --decorate -10'
alias greset='git reset --hard HEAD'

alias sga='show_git_aliases'

# OS-specific aliases
case $OSTYPE in
  darwin*)
    alias ncpu='sysctl -n hw.ncpu'
    alias preview='open -a Preview'
    alias find_largest_files='sudo du -xh /System/Volumes/Data 2>/dev/null | sort -hr | head -40'
    ;;
  linux*)
    alias ncpu='nproc'
    alias preview='xdg-open'
    alias find_largest_files='sudo du -xh / 2>/dev/null | sort -hr | head -40'
    ;;
esac

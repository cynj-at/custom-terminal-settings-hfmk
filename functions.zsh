# functions — shared between users (no secrets, no user-specific paths)

zle_complete_dotdot() {
  local word=${BUFFER[1,CURSOR]##* }  # last token
  if [[ "$word" == ".." ]]; then
    BUFFER="${BUFFER[1,CURSOR]}/${BUFFER[(CURSOR+1),-1]}"
    CURSOR=$((CURSOR + 1))
    zle redisplay
  else
    zle expand-or-complete
  fi
}
zle -N complete-dotdot zle_complete_dotdot
bindkey '^I' complete-dotdot

up() {
    local n=${1:-1}  # default to 1 if no argument is given
    local target=$(printf '../%.0s' $(seq 1 $n))  # not "path": that's zsh's array tied to $PATH
    cd "$target" || return
}

lowercase_ext() {
  local ext="$1"
  if [ -z "$ext" ]; then
    echo "Usage: lowercase_ext <extension> [zusätzliche Varianten...]"
    return 1
  fi
  shift
  local iname_args=(-iname "*.${ext}")
  for alt in "$@"; do
    iname_args+=(-o -iname "*.${alt}")
  done

  find . -type f \( "${iname_args[@]}" \) -exec bash -c '
  target_ext="$1"
  shift
  for f; do
    dir=$(dirname "$f")
    base=$(basename "$f")
    newname="${base%.*}.${target_ext}"
    if [ "$base" != "$newname" ]; then
      tmpname="${newname}.tmp$$"
      mv -n "$f" "$dir/$tmpname"
      mv -n "$dir/$tmpname" "$dir/$newname"
    fi
  done
  ' _ "$ext" {} +
}

lowercase_all_media() {
  lowercase_ext jpg jpeg
  lowercase_ext mp4
  lowercase_ext mov
  lowercase_ext heic
  lowercase_ext png
}

# Search files by name
f() { find . -iname "*$1*"; }

# Search text in files recursively
g() { grep -Rn --color=always "$1" .; }

# Go to home quickly
home() { cd ~; }

# Go to project directory quickly (example)
proj() { cd ~/dev/"$1"; }

# Kill process by name
# (plain SIGTERM lets programs clean up; use `pkill -9 name` only if that doesn't work)
killp() { pkill "$1"; }

# Show disk usage of directories
duh() { du -sh * | sort -rh | head -n 10; }

duhf() { find . -type f -exec du -h {} + | sort -rh | head -n 10; }

# Create directory and enter it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract archives based on type
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1" ;;
            *.tar.gz)    tar xzf "$1" ;;
            *.bz2)       bunzip2 "$1" ;;
            *.rar)       unrar x "$1" ;;
            *.gz)        gunzip "$1" ;;
            *.tar)       tar xf "$1" ;;
            *.zip)       unzip "$1" ;;
            *.7z)        7z x "$1" ;;
            *)           echo "Cannot extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick HTTP server in current directory
serve() { python3 -m http.server "${1:-8000}"; }

# Check if a port is open
portopen() { nc -zv 127.0.0.1 "$1"; }

list_listening_process() { lsof -ti:3000; }
kill_listening_process() { lsof -ti:3000 | xargs kill; }

# Re-run last command starting with a string: use zsh's builtin `r` (e.g. `r git`),
# no custom function needed

# Quick timestamped backup of a file
backup() { cp "$1" "$1.$(date +%Y%m%d%H%M%S).bak"; }

# move dir
mvdir() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: mvdir <source_folder> <destination>"
        return 1
    fi

    local src="$1"
    local dest="$2"

    # Check if source exists and is a directory
    if [ ! -d "$src" ]; then
        echo "Error: '$src' is not a valid directory."
        return 1
    fi

    # Create destination directory if it doesn’t exist
    if [ ! -d "$dest" ]; then
        echo "Destination '$dest' does not exist. Creating it..."
        mkdir -p "$dest" || {
            echo "Failed to create destination directory."
            return 1
        }
    fi

    # Confirm if folder already exists at destination
    if [ -d "$dest/$(basename "$src")" ]; then
        read -p "Directory already exists at destination. Overwrite? (y/N): " confirm
        [[ "$confirm" =~ ^[Yy]$ ]] || {
            echo "Aborted."
            return 1
        }
    fi

    # Perform move
    mv -v "$src" "$dest"/
}

# needs ghostscript installed
pdf_to_jpg() {
  gs -dNOPAUSE -sDEVICE=jpeg -r200 -dJPEGQ=100 -sOutputFile=document-%02d.jpg "$1" -dBATCH
}

pdfcompress ()
{
   gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dEmbedAllFonts=true -dSubsetFonts=true -dColorImageDownsampleType=/Bicubic -dColorImageResolution=144 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=144 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=144 -sOutputFile="${1%.pdf}.compressed.pdf" "$1";
}

# split-screen for markdown with prewview in kitty terminal
mdp() {
  kitten @ launch --location=vsplit --keep-focus --cwd=current \
    sh -c "ls '$1' | entr -c glow '$1'"
  hx "$1"
}

# find duplicates: -r = reference folder (which to compare with), -d = folder(s) to be checked
# needs czkawka_cli installed
dupes() {
  ~/bin/czkawka_cli dup -d "$1" -r "$2" --dry-run -f ~/dupes-report.txt
}

# Ctrl+G: fuzzy-pick a command from snippets (+ local/snippets) into the prompt
if command -v fzf >/dev/null; then
  _snippet-insert() {
    local sel
    sel=$(cat "$ZSH_CONF/snippets" "$ZSH_CONF/local/snippets" 2>/dev/null \
      | grep -v -e '^\s*$' -e '^\s*#' | fzf --height 40% --reverse) || { zle redisplay; return; }
    setopt localoptions extendedglob
    LBUFFER+="${sel%%[[:space:]][[:space:]]##\#*}"   # drop "  # description"
    zle redisplay
  }
  zle -N _snippet-insert
  bindkey '^G' _snippet-insert
fi

# OS-specific functions
case $OSTYPE in
  darwin*)
    topc() { ps aux -r | head -20; }   # -r = sort by CPU
    myip() { ifconfig | grep "inet " | grep -v "127.0.0.1"; }
    ;;
  linux*)
    topc() { ps aux --sort=-%cpu,-%mem | head -20; }
    myip() { ip addr show | grep "inet " | grep -v "127.0.0.1"; }
    ;;
esac

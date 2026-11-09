# local.example.zsh — template for the PER-USER file ~/.config/zsh/local/local.zsh
# (local/ is git-ignored). Copy it:  mkdir -p ~/.config/zsh/local && cp local.example.zsh local/local.zsh
# Put secrets (tokens, passphrases) in ~/.config/zsh/local/secrets.zsh with chmod 600.

# PATH: your own tools, then system. `typeset -U` removes duplicates.
typeset -U path PATH
path=(
  $HOME/.local/ccache-bin        # ccache masquerade (cc/gcc/clang -> ccache)
  $HOME/.local/bin
  /opt/homebrew/bin /opt/homebrew/sbin
  /usr/local/bin
  /usr/bin /bin /usr/sbin /sbin  # system dirs before $path, so nothing can shadow /usr/bin/clang
  $path
)
export PATH
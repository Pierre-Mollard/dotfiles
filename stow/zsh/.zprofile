# Add default SSH key (adjust path if needed)
ssh-add ~/.ssh/github >/dev/null 2>&1

# Load standard profile for environment variables (Flutter, C paths, etc.)
[[ -f ~/.profile ]] && source ~/.profile

# Modern CLI replacements with automatic fallbacks
unalias ls grep cat cp 2>/dev/null

ls() {
  if command -v lsd >/dev/null 2>&1; then
    command lsd --color=auto "$@"
  else
    command ls --color=auto "$@"
  fi
}

cat() {
  if command -v bat >/dev/null 2>&1; then
    command bat --color=always --paging=never "$@"
  else
    command cat "$@"
  fi
}

cp() {
  if command -v xcp >/dev/null 2>&1; then
    command xcp "$@"
  else
    command cp "$@"
  fi
}

grep() {
  if command -v rg >/dev/null 2>&1; then
    command rg --color=auto "$@"
  else
    command grep --color=auto "$@"
  fi
}

eval "$(ssh-agent -s)"
eval "$(starship init zsh)"

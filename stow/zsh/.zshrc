# 	Interactive behavior: aliases, functions, completions, key bindings, prompt, plugins

# =============================================================================
# 1. ZSH OPTIONS & HISTORY
# =============================================================================
# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY          # Append to history file (don't overwrite)
setopt SHARE_HISTORY           # Share history across multiple terminal windows
setopt HIST_IGNORE_ALL_DUPS    # Don't record duplicate commands
setopt HIST_REDUCE_BLANKS      # Remove extra blanks from commands

# Better directory navigation (type '..' instead of 'cd ..')
setopt AUTO_CD
# No annoying beeps
setopt NO_BEEP

# =============================================================================
# 2. VIM MODE
# =============================================================================
bindkey -v
# Type 'jj' quickly in insert mode to switch to Vim Normal mode
bindkey -M viins 'jj' vi-cmd-mode

# =============================================================================
# 3. PLUGINS (Autosuggestions & Syntax Highlighting)
# =============================================================================
# Source plugins depending on your OS package manager paths
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # Arch Linux paths
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    # Ubuntu/Debian paths
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Change autosuggestion ghost text color to match Tokyo Night's dark comment gray
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#565f89"

# Use Ctrl+Space to accept the ghost text suggestion (doesn't conflict with Right Arrow)
bindkey '^F' autosuggest-accept

# Restore standard Emacs shortcuts for history navigation in Insert mode
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^R' history-incremental-search-backward # Ctrl+R to search history
bindkey '^A' beginning-of-line                   # Ctrl+A to go to start of line
bindkey '^E' end-of-line                         # Ctrl+E to go to end of line
bindkey '^W' backward-kill-word                  # Ctrl+W to delete previous

alias refresh="source ~/.zshrc"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gg="~/projects/dotfiles/scripts/tmux_basic_session.sh"

export VISUAL=vim
export EDITOR="$VISUAL"
export GIT_EDITOR=vim

eval "$(starship init zsh)"

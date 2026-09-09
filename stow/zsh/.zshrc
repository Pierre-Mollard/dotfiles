# 	Interactive behavior: aliases, functions, completions, key bindings, prompt, plugins

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt INC_APPEND_HISTORY        # Write to $HISTFILE immediately upon execution
unsetopt SHARE_HISTORY           # Keep Up/Down arrow local to the active pane
setopt EXTENDED_HISTORY          # Record timestamps (:start_time:elapsed;cmd)

setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming
setopt HIST_IGNORE_DUPS          # Don't record an entry if it matches the previous one
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicates when adding a new entry
setopt HIST_IGNORE_SPACE         # Don't save commands starting with a space (for secrets)
setopt HIST_FIND_NO_DUPS         # Do not display duplicates during search
setopt HIST_REDUCE_BLANKS        # Strip redundant whitespace

# Better directory navigation (type '..' instead of 'cd ..')
setopt AUTO_CD
# No annoying beeps
setopt NO_BEEP

# Partial line unfinished (when receiving data without \n ending yet moving to another line)
# '%' char by default, here colored '⏎' with zsh escape sequence
export PROMPT_EOL_MARK='%F{8}⏎%f'

# LS_COLORS with vivid
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate tokyonight-night)"
fi


## UNUSED: this could change a color retro-active!
## OSC4 200 set to orange 
# print -n '\e]4;200;#2ac3de\a'
## OSC4 200 set to orange 
# print -n '\e]4;200;#ff9e64\a'

# Master starshp configuration file
_STARSHIP_BASE="$HOME/.config/starship/starship.toml"

# Store the runtime variant in RAM
_STARSHIP_RAM="/dev/shm/starship-$UID"
[[ -d /dev/shm ]] || _STARSHIP_RAM="/tmp/starship-$UID"
mkdir -p "$_STARSHIP_RAM"
_STARSHIP_ORANGE="$_STARSHIP_RAM/orange.toml"

# Cache the cyan variant once on shell startup (nt: newer than)
if [[ ! -f "$_STARSHIP_ORANGE" || "$_STARSHIP_BASE" -nt "$_STARSHIP_ORANGE" ]]; then
  sed 's/palette = "tokyo-night-cyan"/palette = "tokyo-night-orange"/' "$_STARSHIP_BASE" > "$_STARSHIP_ORANGE"
fi

# zsh hook to alternate every prompt
typeset -g _PROMPT_TOGGLE=0
function _toggle_starship_color() {
  if (( _PROMPT_TOGGLE ^= 1 )); then
    export STARSHIP_CONFIG="$_STARSHIP_BASE"
  else
    export STARSHIP_CONFIG="$_STARSHIP_ORANGE"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _toggle_starship_color

# Bind Up/Down arrows to search history matching the current typed prefix
## Load and register the prefix-search widgets
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

## Bind Up Arrow (covers normal escape, application mode, and terminfo lookup)
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[OA" up-line-or-beginning-search

## Bind Down Arrow
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search

# Edit-command-line : Ctrl-X Ctrl-E (or 'v' in vi mode) to enter commands with $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Tab completion with interactive tab selection
zmodload zsh/complist
autoload -Uz compinit && compinit
## Enable interactive arrow-key selection in completion menus
zstyle ':completion:*' menu select
## Colorize completion lists matching file types
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
## Case-insensitive tab completion (matching lowercase to uppercase)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Force 'source' and '.' to complete normal files/directories only (othersize very long/lag on WSL)
compdef _files source .

# Vi motions
export ZVM_CURSOR_STYLE_ENABLED=false
bindkey -v
# Type 'jj' quickly in insert mode to switch to Vim Normal mode
bindkey -M viins 'jj' vi-cmd-mode

# Avoid typing lag
ZSH_AUTOSUGGEST_USE_ASYNC=1
# Prioritize valid completions for the current directory
ZSH_AUTOSUGGEST_STRATEGY=(completion history)
# Change autosuggestion ghost text color to match Tokyo Night's dark comment gray
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#565f89"
# Sanity check (could be included in plugin) : clear suggestion when navigating history
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(up-line-or-beginning-search down-line-or-beginning-search)

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

# Use Ctrl+Space to accept the ghost text suggestion (doesn't conflict with Right Arrow)
bindkey '^F' autosuggest-accept

# Restore standard Emacs shortcuts for history navigation in Insert mode
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
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

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

eval "$(starship init zsh)"

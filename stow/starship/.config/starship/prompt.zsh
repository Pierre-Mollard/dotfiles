# Render with the current terminal width on every prompt expansion, including
# resizes. No generated configs, width thresholds, or right-hand prompt.
_dotfiles_starship_prompt() {
  local keymap=$1 region=$2 editor_state=$3
  local rendered first_line probe profile
  local -i available_width=${COLUMNS:-80}
  (( available_width > 0 )) || available_width=80
  # Prompt-length tests otherwise count the column after wrapping, rather than
  # the full line. This is local to the prompt's command-substitution process.
  local COLUMNS=1000000
  local -a args
  args=(
    --terminal-width="$available_width"
    --keymap="$keymap"
    --status="${STARSHIP_CMD_STATUS:-0}"
    --pipestatus="${STARSHIP_PIPE_STATUS[*]:-}"
    --cmd-duration="${STARSHIP_DURATION:-}"
    --jobs="${STARSHIP_JOBS_COUNT:-0}"
  )

  for profile in full no_git no_os directory arrow; do
    if [[ $profile == full ]]; then
      rendered=$(command starship prompt "${args[@]}")
    else
      rendered=$(command starship prompt "${args[@]}" --profile="$profile")
    fi
    [[ $profile == arrow ]] && break
    first_line=${rendered%%$'\n'*}
    # Starship emits zsh's nonprinting delimiters. Prompt expansion therefore
    # measures terminal cells, not ANSI bytes (including wide Unicode paths).
    # Reserve the last column to avoid terminal auto-wrap.
    probe="${first_line}%${available_width}(l.overflows.fits)"
    [[ ${(%)probe} == *fits ]] && break
  done

  local symbol='❯' colour='#9ece6a'
  if (( region )); then
    symbol='◆' colour='#bb9af7'
  elif [[ $editor_state == *overwrite* ]]; then
    symbol='▶' colour='#e0af68'
  elif [[ $keymap == vicmd ]]; then
    symbol='❮' colour='#2ac3de'
  fi
  if (( ${STARSHIP_CMD_STATUS:-0} != 0 )); then
    colour='#f7768e'
  fi
  # Replace only the character line, retaining Starship's layout and modules.
  if [[ $rendered == *$'\n'* ]]; then
    print -rn -- "${rendered%$'\n'*}"$'\n'
  fi
  print -rn -- "%B%F{$colour}$symbol%f%b "
}

# Expands inside Starship's existing promptsubst context. Pass ZLE parameters
# explicitly because they are not all available inside command substitutions.
PROMPT='$(_dotfiles_starship_prompt "${KEYMAP:-viins}" "${REGION_ACTIVE:-0}" "${ZLE_STATE:-}")'
RPROMPT=''

# Visual selection and overwrite do not necessarily change KEYMAP, so the
# regular Starship keymap-select hook alone is insufficient.
_dotfiles_starship_mode_redraw() {
  local mode="${KEYMAP:-viins}:${REGION_ACTIVE:-0}:${ZLE_STATE:-}"
  if [[ $mode != ${_DOTFILES_STARSHIP_MODE:-} ]]; then
    typeset -g _DOTFILES_STARSHIP_MODE=$mode
    zle reset-prompt
  fi
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-pre-redraw _dotfiles_starship_mode_redraw

TRAPWINCH() {
  if zle; then
    zle reset-prompt
  fi
  return 0
}

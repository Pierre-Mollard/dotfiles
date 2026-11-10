#!/usr/bin/env bash
# Rings the terminal bell in the tmux pane running Claude Code (settings.json -> hooks.Stop).
#
# Hooks run without the terminal on stdout, so the BEL byte is written straight to the
# pane's tty; tmux then flags the window (monitor-bell) like any other bell.
# Outside tmux this is a no-op (preferredNotifChannel=terminal_bell still covers prompts).

[[ -n $TMUX_PANE ]] || exit 0
tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null) || exit 0
[[ -w $tty ]] && printf '\a' >"$tty"
exit 0

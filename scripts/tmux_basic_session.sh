#!/bin/bash

SESSION="SESSION_NAME"
SESSION=${PWD##*/}          # to assign to a variable
SESSION=${SESSION:-/}        # to correct for the case where PWD is / (root)
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

if [ "$SESSIONEXISTS" = "" ]; then
  tmux new-session -d -s $SESSION -n "DEV"
  tmux send-keys -t $SESSION:0 'nvim .' C-m

  tmux new-window -t $SESSION:1 -n "PRD"
  tmux split-window -t $SESSION:1 -h
  tmux select-pane -t $SESSION:1.0
  tmux send-keys -t $SESSION:1.0 'ls -la' C-m

  tmux new-window -t $SESSION:2 -n "TST"

  tmux new-window -t $SESSION:3 -n "GIT"

fi

tmux attach-session -t $SESSION:0

#SESSION_GROUP="$SESSION-VIEW"
#tmux new-session -t $SESSION -s $SESSION_GROUP

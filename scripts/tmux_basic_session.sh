#!/bin/bash

SESSION="SESSION_NAME"
SESSION=$1
PATH_DEV="$HOME/projects/"
PATH_PROD="$HOME/projects/"
PATH_BENCH="$HOME/projects/"
PATH_IVV="$HOME/cots/"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

if [ "$SESSIONEXISTS" = "" ]; then
  tmux new-session -d -s $SESSION -n "CODE" -c $PATH_DEV
  tmux send-keys -t $SESSION:0 'nvim .' C-m

  tmux new-window -t $SESSION:1 -n "PROD" -c $PATH_PROD
  tmux split-window -t $SESSION:1 -h
  tmux select-pane -t $SESSION:1.0
  tmux send-keys -t $SESSION:1.0 'ls -la' C-m
  tmux send-keys -t $SESSION:1.1 'top' C-m

  tmux new-window -t $SESSION:2 -n "BENCH" -c $PATH_BENCH
  tmux split-window -t $SESSION:2 -h -b
  tmux split-window -t $SESSION:2 -v
  tmux send-keys -t $SESSION:2.0 'ssh user@server3.com'
  tmux select-pane -t $SESSION:2.0

  tmux new-window -t $SESSION:3 -n "IVV" -c $PATH_IVV

fi

tmux attach-session -t $SESSION:0

#SESSION_GROUP="$SESSION-VIEW"
#tmux new-session -t $SESSION -s $SESSION_GROUP

#!/bin/bash

# Function to create or attach to a tmux session for the current directory
function tmuxp() {
    local session_name=$(basename "$PWD" | tr . _)
    if [[ "$1" == "--new" ]]; then
        session_name="random"
        tmux new-session -d -s "$session_name"
        tmux switch-client -t "$session_name"
        return
    fi

    # Check if the session exists
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        # Create a new session with the project name
        tmux new-session -d -s "$session_name"
    fi

    # Attach to the session if we're not already in tmux
    if [ -z "$TMUX" ]; then
        tmux attach-session -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
}

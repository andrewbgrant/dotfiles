#!/bin/bash

# This script provides a function to identify and kill lingering Node.js Language Server Protocol (LSP) processes.
# It specifically targets common Neovim-related LSPs like tsserver, copilot, tailwindcss, and eslint.
# You can add this function to your ~/.bashrc, ~/.zshrc, or equivalent shell configuration file.

# Function to kill lingering Node.js LSP processes
kill-lsps() {
    echo "Searching for lingering Node.js LSP processes..."

    # List of patterns to look for in the command line.
    # These correspond to the LSPs you identified.
    declare -a lsp_patterns=(
        "tsserver.js"
        "language-server.js" # This covers copilot's language server
        "tailwindcss-language-server"
        "vscode-eslint-language-server"
        "typingsInstaller.js" # Added typings installer as it's also a lingering node process
    )

    # Initialize an array to hold PIDs to kill
    pids_to_kill=()

    for pattern in "${lsp_patterns[@]}"; do
        echo "  Looking for processes matching: '$pattern'"
        # Use ps aux to find processes, grep for "node" and the specific pattern,
        # then grep -v to exclude the "grep" command itself.
        # awk is used to extract the PID and the full command line.
        ps aux | grep "node" | grep "${pattern}" | grep -v "grep" | awk '{print $2, $0}' | while read -r pid command_line; do
            # Check if the PID is already in our list to avoid duplicates
            local found=false # Use 'local' for variables inside functions
            for existing_pid in "${pids_to_kill[@]}"; do
                if [[ "$existing_pid" == "$pid" ]]; then
                    found=true
                    break
                fi
            done

            if ! $found; then
                pids_to_kill+=("$pid")
                echo "    Found PID: $pid"
                echo "      Command: $command_line"
            fi
        done
    done

    # Check if any PIDs were found
    if [ ${#pids_to_kill[@]} -eq 0 ]; then
        echo "No relevant Node.js LSP processes found."
    else
        echo ""
        echo "Identified PIDs to kill: ${pids_to_kill[*]}"
        echo "Attempting to kill these processes..."

        # Kill each found PID
        for pid in "${pids_to_kill[@]}"; do
            # Use `kill -9` for a forceful kill as LSPs generally don't require graceful shutdown.
            echo "  Killing process with PID: $pid"
            kill -9 "$pid"
            if [ $? -eq 0 ]; then
                echo "    Successfully killed PID $pid."
            else
                echo "    Failed to kill PID $pid. It might already be gone or permission denied."
            fi
        done

        echo "Kill script execution complete."
    fi
}

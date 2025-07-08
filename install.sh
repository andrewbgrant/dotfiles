#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting dotfiles installation..."

# Function to check if macOS
is_macos() {
    [[ "$(uname)" == "Darwin" ]]
}

# Function to check if Linux
is_linux() {
    [[ "$(uname)" == "Linux" ]]
}

# Function to install Homebrew formulae
install_brew_formulae() {
    for pkg in "$@"; do
        if ! brew list --formula | grep -q "^${pkg}\$"; then
            echo "Installing ${pkg} via Homebrew..."
            brew install "${pkg}"
        else
            echo "${pkg} already installed."
        fi
    done
}

# Function to install Homebrew casks
install_brew_casks() {
    for cask in "$@"; do
        if ! brew list --cask | grep -q "^${cask}\$"; then
            echo "Installing ${cask} via Homebrew cask..."
            brew install --cask "${cask}"
        else
            echo "${cask} already installed."
        fi
    done
}

# Function to install apt packages (Linux)
install_apt_packages() {
    for pkg in "$@"; do
        if ! dpkg -s "$pkg" &>/dev/null; then
            echo "Installing ${pkg} via apt..."
            sudo apt install -y "$pkg"
        else
            echo "${pkg} already installed."
        fi
    done
}

# System Updates (Linux only)
if is_linux; then
    echo "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
fi

# Install Homebrew
if is_macos; then
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew already installed."
    fi
fi

# --- Install Core Tools ---
core_tools=(stow git tmux curl gcc ripgrep btop cloc lazygit fd fzf neovim nvm node pnpm tree-sitter)
zsh_plugins=(zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting)

if is_macos; then
    install_brew_formulae "${core_tools[@]}" zsh "${zsh_plugins[@]}"
elif is_linux; then
    install_apt_packages "${core_tools[@]}" zsh build-essential
else
    echo "Unsupported OS."
    exit 1
fi

# --- macOS Casks ---
if is_macos; then
    install_brew_casks font-sf-mono-nerd-font-ligaturized ghostty
fi

# --- Install Rust/Cargo (via rustup) ---
if ! command -v rustup &>/dev/null; then
    if is_macos; then
        if brew info rustup-init &>/dev/null; then
            brew install rustup-init
            rustup-init -y
        else
            curl https://sh.rustup.rs -sSf | sh -s -- -y
        fi
    elif is_linux; then
        curl https://sh.rustup.rs -sSf | sh -s -- -y
    fi
else
    echo "Rust already installed."
fi

# --- Install uv (Python package installer/resolver) ---
if ! command -v uv &>/dev/null; then
    if is_macos; then
        if brew info uv &>/dev/null; then
            brew install uv
        else
            curl -LsSf https://astral.sh/uv/install.sh | sh
        fi
    elif is_linux; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
else
    echo "uv already installed."
fi

echo "Dotfiles installation complete!"
echo "Source .zshrc to apply changes."

# zmodload zsh/zprof

# History
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS      # Don't record duplicates
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space
setopt SHARE_HISTORY         # Share history between sessions
setopt HIST_VERIFY           # Show command before executing from history

setopt autocd

# Environment
export VISUAL='nvim'
export EDITOR='nvim'

export NVM_DIR="$HOME/.nvm"


# Zsh Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^Y' autosuggest-accept


source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
zstyle ':autocomplete:*' min-input 3
zstyle ':autocomplete:*' delay 0.2
bindkey '^N' menu-select
bindkey '^P' menu-select


# Custom Environment Variables
# Project tools
source /Users/andrewgrant/set_env.sh
source ~/dotfiles/scripts/tmuxp.sh
source ~/dotfiles/scripts/kill-lsp.sh
source ~/dotfiles/scripts/typescript-init.sh
alias ts-init='typescript-init'
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"



# Language & Toolchain Paths
# Ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.3.0/bin:$PATH"
# Add Ruby gem bindir to PATH if not already present
GEM_BINDIR=$(ruby -e 'puts Gem.bindir' 2>/dev/null)
if [[ -n "$GEM_BINDIR" && ":$PATH:" != *":$GEM_BINDIR:"* ]]; then
  PATH=$PATH:$GEM_BINDIR
fi

# MySQL
export PATH="/opt/homebrew/opt/mysql/bin:$PATH"

# Add node to PATH directly (fast, no nvm load)
if [ -d "$NVM_DIR/versions/node" ]; then
  # Get default version (may be partial like "22")
  DEFAULT_VERSION=$(cat "$NVM_DIR/alias/default" 2>/dev/null)

  if [ -n "$DEFAULT_VERSION" ]; then
    # Find matching version in versions directory (e.g., "22" -> "v22.16.0")
    NODE_VERSION=$(ls -1 "$NVM_DIR/versions/node" | grep "^v${DEFAULT_VERSION}" | tail -1)
  else
    # Fall back to most recent version
    NODE_VERSION=$(ls -t "$NVM_DIR/versions/node" | head -1)
  fi

  if [ -n "$NODE_VERSION" ] && [ -d "$NVM_DIR/versions/node/$NODE_VERSION/bin" ]; then
    export PATH="$NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH"
  fi
fi

# Lazy load nvm (only when explicitly needed)
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Python/uv
. "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion zsh)"
if [ -d "$HOME/.uv_global" ]; then
    source $HOME/.uv_global/bin/activate
fi

# LM Studio CLI
export PATH="$PATH:/Users/andrewgrant/.lmstudio/bin"

# pnpm
export PNPM_HOME="/Users/andrewgrant/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac


#####################################################################
# Prompt and Appearance

# Colors
PURPLE='%F{5}'
BLUE='%F{cyan}'
GREEN='%F{green}'
YELLOW='%F{yellow}'
RED='%F{red}'
RESET='%f'

# Git Prompt
git_prompt_info() {
  local branch_name
  branch_name=$(git symbolic-ref HEAD 2> /dev/null) || return 0
  branch_name=${branch_name##refs/heads/}
  local git_status=""
  if git diff --quiet 2> /dev/null; then
    git_status="${GREEN}✔"
  else
    git_status="${RED}✗"
  fi
  echo "${PURPLE}(${branch_name} ${git_status}${PURPLE})${RESET}"
}
setopt PROMPT_SUBST
PROMPT="${BLUE}%3~ \$(git_prompt_info)${RESET}
% "

#####################################################################
# Aliases

alias vim='nvim'
alias l='eza -lha --group-directories-first --icons'
alias ls='eza -lha --group-directories-first --icons'
alias ll='eza'
alias ipy='ipython'
alias lg='lazygit'
alias ld='lazydocker'
alias venv='source venv/bin/activate 2>/dev/null || source .venv/bin/activate'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Process management
alias ps='ps aux | grep -v grep | grep'
alias ports='lsof -i -P -n | grep LISTEN'

#####################################################################

# Port management functions
function stop-port() {
  if [ -z "$1" ]; then
    echo "Usage: stop-port <port_number>"
    return 1
  fi
  
  local port=$1
  local pids=$(lsof -ti :$port)
  
  if [ -z "$pids" ]; then
    echo "No process found listening on port $port"
    return 1
  fi
  
  echo "Killing process(es) on port $port: $pids"
  echo $pids | xargs kill
  
  # Verify it's stopped
  sleep 1
  if lsof -ti :$port > /dev/null 2>&1; then
    echo "Process still running, force killing..."
    echo $pids | xargs kill -9
  else
    echo "Successfully stopped process on port $port"
  fi
}

function show-ports() {
  echo "Common development ports:"
  for port in 3000 3001 8001 8002; do
    local pid=$(lsof -ti :$port 2>/dev/null)
    if [ -n "$pid" ]; then
      local process=$(ps -p $pid -o comm= 2>/dev/null)
      echo "Port $port: PID $pid ($process)"
    else
      echo "Port $port: free"
    fi
  done
  echo ""
  echo "All listening ports:"
  lsof -i -P -n | grep LISTEN | awk '{print $1, $2, $9}' | sort -k3
}
#####################################################################
#####################################################################
# FZF Configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview="bat --color=always {}" --preview-window=right:50%'

# FZF command for directories
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

source <(fzf --zsh)

#####################################################################

# LMS server start function

function start-lms() {
    ssh -t desktop "source ~/.zshrc; lms load deepseek/deepseek-r1-0528-qwen3-8b && lms server start"
}

# opencode
export PATH=/Users/andrewgrant/.opencode/bin:$PATH

#####################################################################
# Enhanced File Navigation & Development Functions


# Quick file finder and opener with preview
function ff() {
    local file=$(fd --type f | fzf --preview 'bat --color=always --style=numbers {}' --height 60%)
    [ -n "$file" ] && $EDITOR "$file"
}

# Better directory navigation
function fcd() {
    local dir=$(fd --type d | fzf --height 40% --preview 'ls -la {}')
    [ -n "$dir" ] && cd "$dir"
}

# Ghostty only auto-injects integration into its initial shell, not tmux shells.
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

bindkey -e

# History
HISTSIZE=5000
SAVEHIST=5000
setopt HIST_IGNORE_DUPS      # Don't record duplicates
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space
setopt SHARE_HISTORY         # Share history between sessions
setopt HIST_VERIFY           # Show command before executing from history




# Language & Toolchain Paths
# Add node to PATH directly (fast, no nvm load; zsh-native, no subprocesses)
export NVM_DIR="$HOME/.nvm"
if [[ -d "$NVM_DIR/versions/node" ]]; then
  if [[ -r "$NVM_DIR/alias/default" && -n "$(<$NVM_DIR/alias/default)" ]]; then
    node_matches=("$NVM_DIR/versions/node"/v$(<$NVM_DIR/alias/default)*(N))
  else
    node_matches=("$NVM_DIR/versions/node"/v*(om[1]))  # most recently installed
  fi
  [[ -n ${node_matches[-1]} ]] && export PATH="${node_matches[-1]}/bin:$PATH"
fi

# Lazy load nvm (only when explicitly needed)
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}


# bun 
export PATH="/Users/andrewgrant/.bun/bin:$PATH"
[ -s "/Users/andrewgrant/.bun/_bun" ] && source "/Users/andrewgrant/.bun/_bun"

# Python/uv
. "$HOME/.local/bin/env"
# Lazy load uv (the completion eval is only needed once uv is used)
uv() {
  unfunction uv
  eval "$(uv generate-shell-completion zsh)"
  uv "$@"
}
if [ -d "$HOME/.uv_global" ]; then
    source $HOME/.uv_global/bin/activate
fi




#####################################################################
# Prompt and Appearance

# Colors
PURPLE='%F{5}'
BLUE='%F{cyan}'
GREEN='%F{green}'
YELLOW='%F{yellow}'
RED='%F{red}'
RESET='%f'

# Git Prompt: branch + staged/unstaged dirty state; untracked files are ignored.
git_prompt_info() {
	local git_cmd=${commands[git]:-git} branch dirty
	# Bypass Apple's launcher without overriding other Git installations on PATH.
	if [[ $git_cmd == /usr/bin/git && -x /Library/Developer/CommandLineTools/usr/bin/git ]]; then
		git_cmd=/Library/Developer/CommandLineTools/usr/bin/git
	fi
	branch=$("$git_cmd" symbolic-ref --short -q HEAD 2>/dev/null) \
		|| branch=$("$git_cmd" rev-parse --short=7 HEAD 2>/dev/null) \
		|| return 0
	if "$git_cmd" diff --quiet HEAD 2>/dev/null; then
		dirty="${GREEN}✔"
	else
		dirty="${RED}✗"
	fi
	echo "${PURPLE}(${branch} ${dirty}${PURPLE})${RESET}"
}
setopt PROMPT_SUBST
PROMPT="${BLUE}%3~ \$(git_prompt_info)${RESET}
% "

#####################################################################
# Aliases

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias vim='nvim'
alias cls="printf '\033[2J\033[3J\033[H'"
alias l='eza'
alias ls='eza -lha --group-directories-first --icons'
alias ipy='ipython'
alias lg='lazygit'
alias venv='source venv/bin/activate 2>/dev/null || source .venv/bin/activate'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

c() {
  clang "$1" -o /tmp/c-run && /tmp/c-run
}

# Project tools
source ~/dotfiles/scripts/tmuxp.sh


# oMLX: CLI shim path begin
case ":$PATH:" in
  *":$HOME/.omlx/bin:"*) ;;
  *) export PATH="$HOME/.omlx/bin:$PATH" ;;
esac
# oMLX: CLI shim path end

# Environment
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export DEJA_CYCLE_KEY="^N"
export DEJA_ACCEPT_KEY="^I"

# PATH additions
export PATH="$PATH:$HOME/.config/git"

# Shell behavior
setopt no_beep              # Disable terminal bell
setopt extended_glob        # Enable extended globbing (**, ~(foo|bar), etc.)
setopt auto_pushd           # cd pushes old dir onto the directory stack
setopt pushd_ignore_dups    # Don't push duplicate directories onto the stack
setopt interactive_comments # Allow # comments in interactive shell
setopt append_history       # Append to history file rather than overwrite
setopt share_history        # Share history across sessions in real time
setopt hist_ignore_space    # Don't record commands starting with a space
setopt hist_ignore_all_dups # Remove older duplicate entries from history
setopt hist_save_no_dups    # Don't save duplicate lines to history file
setopt hist_ignore_dups     # Don't record consecutive duplicate commands
setopt hist_find_no_dups    # Don't show duplicates when searching history
setopt hist_reduce_blanks   # Remove superfluous blanks from history entries
setopt prompt_subst         # Enable command substitution in prompt strings

HISTSIZE=5000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE

# Completion and keymaps
autoload -Uz compinit
compinit

bindkey -v # vi mode
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Commands
alias n='nvim'      # Neovim
alias gg='lazygit'  # Lazygit TUI
alias oc='opencode' # OpenCode

cat() {
  bat "$@"
}
ls() {
  eza "$@" --git --icons=always --group-directories-first
}
tree() {
  eza -T "$@" --icons
}
cd() {
  z "$@"
}
grep() {
  rg "$@" --color=auto
}
find() {
  fd "$@"
}

# Integrations
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"
eval "$($(brew --prefix)/bin/zsh-patina activate)"

if [[ -r "$(brew --prefix)/share/zsh-system-clipboard/zsh-system-clipboard.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-system-clipboard/zsh-system-clipboard.zsh"
fi

# Initialize deja and starship last
eval "$(deja init zsh)"
eval "$(starship init zsh)"

# Local overrides - machine-specific settings not checked into git
if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# Initializers
eval "$(starship init zsh)"
eval "$(atuin init zsh)"

# PATH additions

# Zsh options
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

# History configuration
HISTSIZE=5000              # Max number of commands in memory
HISTFILE="$HOME/.zsh_history"  # History file location
SAVEHIST=$HISTSIZE         # Max lines saved to history file
HISTDUP=erase              # Remove duplicates when loading history

# Completion system
autoload -Uz compinit       # Load completion system on demand (fast startup)
compinit                    # Initialize completion

# Vi mode - vi-style keybindings for command line editing
set -o vi                   # Enable vi mode
bindkey -v                  # Load vi keymap

# Keybindings
bindkey '^I' expand-or-complete        # Tab to complete
bindkey '^[[A' history-search-backward # Up arrow searches history
bindkey '^[[B' history-search-forward  # Down arrow searches history

# Short aliases
alias n='nvim'     # Neovim
alias gg='lazygit' # Lazygit TUI
alias oc='opencode --port' # OpenCode

# Remap aliases
export BAT_THEME="rose-pine"
cat() {
  bat "$@"
}
ls() {
  eza "$@" --icons
}
tree() {
  eza -T "$@" --icons
}

# Plugins
if [[ -r "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
	source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -r "/opt/homebrew/share/zsh-system-clipboard/zsh-system-clipboard.zsh" ]]; then
	source "/opt/homebrew/share/zsh-system-clipboard/zsh-system-clipboard.zsh"
fi

if [[ -r "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
	source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Local overrides - machine-specific settings not checked into git
if [[ -r "$HOME/.zshrc.local" ]]; then
	source "$HOME/.zshrc.local"
fi


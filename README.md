# dotfiles

My personal macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```shell
git clone git@github.com:loremipson/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install
```

The install script will:

1. Install [Homebrew](https://brew.sh) if not already present
2. Run `brew bundle` to install all dependencies from the `Brewfile`
3. Symlink all config packages into `$HOME` via Stow
4. Clone [TPM](https://github.com/tmux-plugins/tpm) for tmux plugin management
5. Set zsh as the default shell if it isn't already

After installation, open tmux and press `prefix + I` to install tmux plugins.

## Structure

Each top-level directory is a Stow package that mirrors the target filesystem layout from `$HOME`.

```
dotfiles/
├── aerospace/     # Tiling window manager
├── atuin/         # Shell history manager
├── bat/           # cat replacement (custom theme)
├── ghostty/       # Terminal emulator
├── opencode/      # AI coding assistant
├── sketchybar/    # Status bar
├── tmux/          # Terminal multiplexer
├── vicinae/       # App launcher
├── yazi/          # Terminal file manager
└── zsh/           # Shell config
```

## Time Tracking (optional)

Tmux hooks can log session activity to [Timewarrior](https://timewarrior.net/) so time is tracked per tmux session. This is off by default, since it's only useful for specific situations, not every machine.

To enable it:

1. Create `~/.tmux.conf.local` with:

```tmux
   set-hook -g client-attached 'run-shell "~/.config/tmux/track-time.sh"'
   set-hook -g client-session-changed 'run-shell "~/.config/tmux/track-time.sh"'
   set-hook -g client-detached 'run-shell "~/.config/tmux/track-time.sh"'
```

2. Reload tmux config or restart the server.

Each tmux session name becomes a Timewarrior tag. View tracked time with `timew summary :all` or `timew day`.

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

## Post-install

There's a couple things you'll want to do after (or before, honestly) installing.

- Set the Menu Bar in MacOS Settings to "Always" hide. You might want to enable the background as well, the default Menu Bar is still accessible by hovering at the top, and background enabled makes it easier to interact with.
- Change or remove the shortcut for MacOS Spotlight found in System Settings -> Keyboard -> Keyboard Shortcuts -> Spotlight. I set mine to `⌥+space` so that it's still accessible if I ever need it. Vicinae will operate with `⌘+space`.

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

## Workmux

This configuration uses [workmux](https://github.com/raine/workmux) to manage Git worktrees and their associated tmux sessions.

There are two supported workflows:

- **Git** — the default, for repositories using normal Git branches.
- **Graphite** — for repositories where Graphite owns the branch/stack topology and workmux owns the worktrees.

The workflow can be selected per project in `.tmux.conf.local`:

```tmux
set -g @workflow "graphite"
```

If no Graphite workflow is configured, the normal Git/workmux workflow is used.

Open the workmux menu with:

```text
prefix + w
```

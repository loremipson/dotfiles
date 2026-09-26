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
4. Ask for your git name and email (saved to `~/.gitconfig`, not this repo)
5. Rebuild bat's theme cache
6. Install language runtimes with [mise](https://mise.jdx.dev)
7. Install [TPM](https://github.com/tmux-plugins/tpm) and the tmux plugins
8. Set zsh as the default shell if it isn't already

## Post-install

There's a couple things you'll want to do after (or before, honestly) installing.

- Set the Menu Bar in MacOS Settings to "Always" hide. You might want to enable the background as well, the default Menu Bar is still accessible by hovering at the top, and background enabled makes it easier to interact with.
- Change or remove the shortcut for MacOS Spotlight found in System Settings -> Keyboard -> Keyboard Shortcuts -> Spotlight. I set mine to `⌥+space` so that it's still accessible if I ever need it. Vicinae will operate with `⌘+space`.

## Re-running
 
The install script is safe to run again whenever. If a step fails, the rest still run, and you'll get a summary at the end with the command to rerun just that part.
 
```shell
./install                     # everything
./install mise tpm            # just these steps
./install stow git yazi       # just these packages (package names go after "stow")
./install --backup stow git   # move existing files out of the way, then stow
```
 
If Stow finds a real file where a symlink should go, it won't touch it. Run with `--backup` to move those files to `~/.dotfiles-backup/` first. Logs from every run end up in `~/.local/state/dotfiles/`.

## Git
 
Shared settings (delta, aliases, defaults) live in `~/.config/git/config`, which comes from this repo. Your name, email, and anything else personal go in `~/.gitconfig`, which stays yours. Git reads both, and `~/.gitconfig` wins if they overlap, so `git config --global` works like normal.

## Language Versions
 
mise installs the default versions of Node, pnpm, Bun, Deno, and Go from `mise/.config/mise/config.toml`. To pin different versions for a project (or a whole folder of them), drop a `mise.toml` in that directory:
 
```toml
[tools]
node = "24"
pnpm = "11"
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

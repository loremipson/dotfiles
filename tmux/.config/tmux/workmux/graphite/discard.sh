#!/usr/bin/env bash
set -euo pipefail

selection=$(workmux list | tail -n +2 | fzf)
[ -z "$selection" ] && exit 0

branch=$(awk '{print $1}' <<< "$selection")

printf 'Discard Graphite branch "%s"? [y/N] ' "$branch"
read -r confirm
[[ "$confirm" =~ ^[Yy]$ ]] || exit 0

# Find the primary repository root from Git's common directory.
git_common_dir=$(git rev-parse --path-format=absolute --git-common-dir)
repo_root=$(dirname "$git_common_dir")

# Launch the Graphite deletion independently of this tmux session.
# It waits until the worktree is actually gone before deleting the branch.
nohup bash -c '
    set -euo pipefail

    branch="$1"
    repo_root="$2"

    while git -C "$repo_root" worktree list --porcelain |
          grep -Fq "branch refs/heads/$branch"
    do
        sleep 0.2
    done

    cd "$repo_root"
    gt delete "$branch"
' _ "$branch" "$repo_root" \
    </dev/null >/tmp/workmux-discard-"$branch".log 2>&1 &

# Remove the tmux session and worktree, but deliberately keep the branch.
workmux remove --keep-branch "$branch"

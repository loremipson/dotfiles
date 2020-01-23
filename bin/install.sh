#!/bin/sh

DF="$HOME/dotfiles"
VIMDIR="$DF/.vim"

warn() {
	echo "$1" >&2
}

die() {
	warn "$1"
	exit 1
}

# vim
[ ! -e "$VIMDIR/autoload/plug.vim" ] && eval "curl -fLo $VIMDIR/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

cd ..

ln -s dotfiles/.vim/ .
ln -s dotfiles/.vim/.vimrc .vimrc

# tmux

ln -s dotfiles/.tmux/ .
ln -s dotfiles/.tmux.conf .tmux.conf

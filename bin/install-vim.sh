#!/bin/sh
source ./bin/utils.sh

VIMDIR="$HOME/.vim"

[ -e ~/.vim ] && die "~/.vim already exists."
[ -e ~/.vimrc ] && die "~/.vimrc already exists."

[ ! -e "$VIMDIR/autoload/plug.vim" ] && eval "curl -fLo $VIMDIR/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

cd ..

ln -s dotfiles/.vim/ .
ln -s dotfiles/.vim/.vimrc .vimrc
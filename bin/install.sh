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

# xcode

echo "Installing Xcode"
xcode-select --install

# Check for Homebrew
if test ! $(which brew)
then
  echo "Installing Homebrew"

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  fi

fi

brew update

echo "Installing brew binaries"
brew install git
brew install node
brew install vim
brew install --HEAD neovim
brew install ripgrep
brew install tmux
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
brew install yarn
brew tap homebrew/cask-fonts
brew cask install font-hack-nerd-font
brew install imagemagick
brew cleanup

# vim
echo "Setting up vim configuration"
[ ! -e "$VIMDIR/autoload/plug.vim" ] && eval "curl -fLo $VIMDIR/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

cd ..

mkdir -p $HOME/.config

ln -s $HOME/dotfiles/.vim/ .
ln -s $HOME/dotfiles/.vim/.vimrc .vimrc

ln -s $HOME/dotfiles/.vim/coc-settings.json .config/nvim/coc-settings.json
ln -s $HOME/dotfiles/.vim/init.vim .config/nvim/init.vim

# tmux

ln -s dotfiles/.tmux/ .
ln -s dotfiles/.tmux.conf .tmux.conf

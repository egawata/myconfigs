#!/bin/bash

set -e

if [ ! -d ~/.vim/dein/repos/github.com/Shougo/dein.vim ]; then
    mkdir -p ~/.vim/dein/repos/github.com/Shougo/dein.vim
    git clone https://github.com/Shougo/dein.vim.git \
            ~/.vim/dein/repos/github.com/Shougo/dein.vim
fi

mkdir -p ~/git
if [ ! -d ~/git/myconfigs ]; then
    git clone https://github.com/egawata/myconfigs.git ~/git/myconfigs
fi

cd ~/git/myconfigs
if [ ! -f ~/.vimrc ]; then
    cp vimrc ~/.vimrc
fi
if [ ! -f ~/.zshrc ]; then
    cp zshrc ~/.zshrc
fi
if [ ! -f ~/.gitconfig ]; then
    cp gitconfig ~/.gitconfig
fi
if [ ! -d ~/bin ]; then
    cp -R bin ~/bin
fi

mkdir -p ~/.vim
cd ~/.vim
mkdir -p colors

git clone https://github.com/tomasr/molokai

mv molokai/colors/molokai.vim ~/.vim/colors/



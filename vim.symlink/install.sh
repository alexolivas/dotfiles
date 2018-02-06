#!/usr/bin/env bash

info () {
    printf "\r  [ \033[00;34m..\033[0m ] \033[00;34m$1\033[0m\n"
}

success () {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

info " "
info 'Installing vim..'

DOTFILES=$PWD
VIM_DIR=vim.symlink
AUTOLOAD_DIR=$VIM_DIR/autoload
BUNDLES_DIR=$VIM_DIR/bundle
COLORS_DIR=$VIM_DIR/colors

mkdir -p $AUTOLOAD_DIR
success "Created autoload directory"

mkdir -p $BUNDLES_DIR
success "Created bundles directory"

mkdir -p $COLORS_DIR
success "Created colors directory"


# Add pathogen
cd $AUTOLOAD_DIR
success "Downloading pathogen.vim.."
curl -LSso pathogen.vim https://tpo.pe/pathogen.vim

sleep 10

# Add your custom bundles
cd $DOTFILES/$BUNDLES_DIR

# NerdTree
if [ ! -d "nerdtree" ]; then
    success "Downloading NerdTree.."
    git clone https://github.com/scrooloose/nerdtree.git # NerdTree
else
    success "NerdTree already installed!"
fi

sleep 10


success "Vim installation complete!"
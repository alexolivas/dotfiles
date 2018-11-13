#!/usr/bin/env bash

export DOTFILES=$HOME/.dotfiles
source $DOTFILES/script/bootstrap.sh -s

user "--------------------------------------"
user "Running vim installer"
user "--------------------------------------"

VIM_DIR=~/.vim
AUTOLOAD_DIR=$VIM_DIR/autoload
BUNDLES_DIR=$VIM_DIR/bundle
COLORS_DIR=$VIM_DIR/colors

success "Running vim setup"

if [ ! -d $VIM_DIR ]; then
    mkdir $VIM_DIR
    info "Created vim directory"
else
    info "vim directory already exists"
fi

if [ ! -d $AUTOLOAD_DIR ]; then
    mkdir $AUTOLOAD_DIR
    info "Created autoload directory"
else
    info "vim autoload directory already exists"
fi

if [ ! -d $BUNDLES_DIR ]; then
    mkdir $BUNDLES_DIR
    info "Created bundles directory"
else
    info "vim bundles directory already exists"
fi

if [ ! -d $COLORS_DIR ]; then
    mkdir $COLORS_DIR
    info "Created colors directory"
else
    info "vim color directory already exists"
fi


######################################################################
# Add pathogen to the autoload directory: this makes it easy to
# install plugins and runtime files in their own private directories
######################################################################

# Add pathogen
cd $AUTOLOAD_DIR

if [ ! "pathogen.vim" ]; then
    # success "Downloading pathogen.."
    info "Downloading pathogen.."
    curl -LSso pathogen.vim https://tpo.pe/pathogen.vim
    sleep 10
    info "Pathogen installed!"
else
    # TODO: Add option to update (e.g. git pull) the repositories
    info "Pathogen already installed!"
fi

######################################################################
# Add your custom bundles to the bundles directory
######################################################################

cd $BUNDLES_DIR

if [ ! -d "nerdtree" ]; then
    info "Downloading NERDTree.."
    git clone https://github.com/scrooloose/nerdtree.git
    sleep 10
    info "NERDTree installed!"
else
    # TODO: Add option to update (e.g. git pull) the repositories
    info "NerdTree already installed!"
fi

success "Vim setup complete."
info " "
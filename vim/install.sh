#!/bin/bash

###########################################################################################
# vim
#
# This installs any customizations I want to use in the vim plugin
###########################################################################################

# Source utils script to use its functions here
cd "$(dirname "$0")/.."
export DOTFILES_ROOT=$(pwd -P)
source $DOTFILES_ROOT/script/utils.sh


user "--------------------------------------"
user "Running vim installer"
user "--------------------------------------"

VIM_DIR=~/.vim
AUTOLOAD_DIR=$VIM_DIR/autoload
BUNDLES_DIR=$VIM_DIR/bundle
COLORS_DIR=$VIM_DIR/colors

success "Bootstrapping vim directories"

if [ ! -d $VIM_DIR ]; then
    mkdir $VIM_DIR
    info "Created vim directory"
else
    info "skipping; vim directory already exists"
fi

if [ ! -d $AUTOLOAD_DIR ]; then
    mkdir $AUTOLOAD_DIR
    info "Created autoload directory"
else
    info "skipping; vim autoload directory already exists"
fi

if [ ! -d $BUNDLES_DIR ]; then
    mkdir $BUNDLES_DIR
    info "Created bundles directory"
else
    info "skipping; vim bundles directory already exists"
fi

if [ ! -d $COLORS_DIR ]; then
    mkdir $COLORS_DIR
    info "Created colors directory"
else
    info "skipping; vim color directory already exists"
fi


######################################################################
# Add pathogen to the autoload directory: this makes it easy to
# install plugins and runtime files in their own private directories
######################################################################

info " "
success "Installing vim plugins"

# Add pathogen
cd $AUTOLOAD_DIR

export PATHOGEN=$AUTOLOAD_DIR/pathogen.vim
if [ ! -f $PATHOGEN ]; then
    info "Downloading pathogen plugin.."
    
    # PATHOGEN_DOWNLOAD=$(curl -LSso pathogen.vim https://tpo.pe/pathogen.vim)
    # while read -r line; do
    #     info $line
    # done <<< "$PATHOGEN_DOWNLOAD"
    curl -LSso pathogen.vim https://tpo.pe/pathogen.vim
    # sleep 3
    info "Pathogen installed!"
else
    info "Pathogen already installed!"
fi

# ######################################################################
# # Add your custom bundles to the bundles directory
# ######################################################################

info " "
success "Installing vim bundles"

cd $BUNDLES_DIR

if [ ! -d "nerdtree" ]; then
    info "Downloading NERDTree bundle.."
    git clone https://github.com/scrooloose/nerdtree.git 2>&1 |
        while read -r line ; do
            info "$line"
        done
    info "NERDTree installed!"
else
    # TODO: Add option to update (e.g. git pull) the repositories
    info "NerdTree already installed!"
fi

# Go back to the dotfiles directory
cd $DOTFILES_ROOT
info " "

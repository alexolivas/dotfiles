#!/bin/sh

###########################################################################################
# This script is responsible for simply copying files like .vimrc, .git-prompt-color.sh, 
# etc onto a system that doesn't require a full bootstrap of dotfiles e.g. my work
# computer. My work computer has its own very dot files used for the entire R&D 
# organization, however I still want to re-use some of the configuration files to 
# customize my work environment just like my personal computers, this helps keep these
# settings in sync.
#
# This prevents overriding my work dot files settings.
##########################################################################################

# Source utils script to use its functions here
cd "$(dirname "$0")/.."
export DOTFILES_ROOT=$(pwd -P)
source $DOTFILES_ROOT/script/utils.sh

# TODO: set a persistent environment variable that helps this script avoid symlinking or check if ~/.profile.d exists, if it does dont symlink

# Copy over only the dotfiles we care about (Should I symlink them instead?)
# TODO Figure out how I can make this exportable so that it is out of git and configurable for that make want to check this project out
VIMRC="${DOTFILES_ROOT}/vim/vimrc.symlink"
GIT_PROMPT="${DOTFILES_ROOT}/bash-git-prompt/git-prompt-colors.sh.symlink"
TMUX="${DOTFILES_ROOT}/tmux/tmux.conf.symlink"
GIT_IGNORE="${DOTFILES_ROOT}/git/gitignore.symlink"
GIT_CONFIG="${DOTFILES_ROOT}/git/gitconfig.symlink"

LIST="${VIMRC} ${GIT_PROMPT} ${TMUX} ${GIT_IGNORE} ${GIT_CONFIG}"
for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
do
    dst="$HOME/.$(basename "${src%.*}")"
    if [[ $LIST =~ (^|[[:space:]])$src($|[[:space:]]) ]]; then
        if [ -f $dst ]; then
            # TODO should I make a backup copy?
            success "Overriding dotfile: ${dst}"
        else
            success "Copying dotfile: ${dst}"
        fi
        cp $src $dst
    fi
done

# Set the global gitignore configuration in git
# TODO: Add an env.sh to do this in the full install as well (this is now done in the .gitconfig file)
# git config --global core.excludesfile ~/.gitignore

success " "

# Copy over my custom tmux configuration script into bin so that its
# automatically added directly to the bin executable path
# TODO: This should probably be added into ~/.profile.d/ instead of /usr/local/bin, rename this to aolivas-tmux.sh
DEV_TMUX="${DOTFILES_ROOT}/bin/devtmux"
cp $DEV_TMUX /usr/local/bin
success "Adding devtmux script to /usr/local/bin/"

success " "

# TODO: do something similar to the installer and find env.sh files: doesn't work for bash-git-prompt

# Copy over bash customizations and functions
# TODO : remove the bash completion from this file and only use the bash git prompt one
BASH_FUNCS="${DOTFILES_ROOT}/bash/env.sh"
cp $BASH_FUNCS ~/.profile.d/aolivas-bash.sh
success "Adding bash customizations to ~/.profile.d/"

# Create the directory structure I use for my personal projects (e.g. this dotfiles)
# Ignore the client folder since I won't use a work laptop for these projects
create_code_directory_structure --ignore clients

# Run homebrew installer (installs or updates brew + installs common packages)
# BREW_INSTALLER="$(sh $DOTFILES_ROOT/homebrew/install.sh; echo x)"
# success "${BREW_INSTALLER%x}"
sh $DOTFILES_ROOT/homebrew/install.sh

# Source bash_profile
source_bash_profile

# Add keys to the ssh agent: ssh-add ~/.ssh/identity
# https://confluence.atlassian.com/bbkb/permission-denied-publickey-302811860.html
# https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

# TODO Rename this file to bv_install so that its clear that this is for BluVector

#!/bin/bash

###########################################################################################
# Homebrew
#
# This installs or updated homebrew and any dependencies you want to
# install on your computer using homebrew
###########################################################################################

# Source utils script to use its functions here
cd "$(dirname "$0")/.."
export DOTFILES_ROOT=$(pwd -P)
source $DOTFILES_ROOT/script/utils.sh

user "--------------------------------------"
user "Running homebrew installer"
user "--------------------------------------"

# Check if Homebrew is already installed, if not install it
if test ! $(which brew)
then
    # Install home brew for OS X (press ENTER when screen hangs)
    success "Installing Homebrew on your system.."
    BREW_INSTALL=$(/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)")
    while read -r line; do
        info "$line"
    done <<< "$BREW_INSTALL"

else
    # Update homebrew
    success "Updating Homebrew.."
    BREW_UPDATE=$(brew update)
    while read -r line; do
        info "$line"
    done <<< "$BREW_UPDATE"
fi
info " "

# Run Homebrew through the Brewfile
success "Installing Homebrew bundles.."
BREW_INSTALLER=$(brew bundle)
while read -r line; do
    info "$line"
done <<< "$BREW_INSTALLER"

info " "
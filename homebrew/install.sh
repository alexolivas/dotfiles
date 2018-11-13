#!/bin/bash

#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

export DOTFILES=$HOME/.dotfiles
source $DOTFILES/script/bootstrap.sh -s

#set -e

user "--------------------------------------"
user "Running homebrew installer"
user "--------------------------------------"

# Check if Homebrew is already installed, if not install it
if test ! $(which brew)
then
  info "Installing Homebrew on your system.."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  fi

else
    # Update homebrew
    success "Updating Homebrew.."
    brew update
fi

# Run Homebrew through the Brewfile
success "Installing Homebrew bundles.."
brew bundle
info " "
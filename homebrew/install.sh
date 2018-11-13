#!/bin/bash

#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

. script/bootstrap.sh --source-only

# Check for Homebrew
if test ! $(which brew)
then
  info "Installing Homebrew on your system"

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  fi

fi

exit 0

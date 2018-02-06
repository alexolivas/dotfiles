#!/usr/bin/env bash

# default to ls with color
alias ls="ls -G"

# enable bash completion if installed via homebrew
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# Stash your environment variables in ~/.localrc to keep them out of the public
# dotfiles repository.
#if [[ -a ~/.localrc ]]
#then
#    source ~/.localrc
#fi

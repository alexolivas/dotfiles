#!/usr/bin/env bash

# Customize the terminal's appearance
export CLICOLOR=1
export LSCOLORS=ExFxCxFxCxegedabagaced

# default to ls with color and to display directories with a trailing slash
 alias ls="ls -GFh"

# enable bash completion if installed via homebrew
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi


################################################################
# Helpful bash functions
################################################################

# Command to help easily ssh into docker containers
function dc_ssh() {
    container_id=`sudo docker ps|grep $1|awk '{print $1}'`
    sudo docker exec -it $container_id /bin/bash
}

# Cleans docker environment by removing exited containers
function dc_clean() {
    sudo docker ps -aq --no-trunc -f status=exited | xargs docker rm
}

# Command to rename a terminal tab
function renametab() {
    echo -ne "\033]0;"$@"\007"
}

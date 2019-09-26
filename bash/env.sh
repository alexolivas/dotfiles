#!/usr/bin/env bash

################################################################
# Personalize my bash environment
################################################################

# TODO Come up with a better strategy to install for the first time (see dotfiles-ansible as an example it install .dev_contianer)

# Customize the terminal's appearance
export CLICOLOR=1
export LSCOLORS=ExFxCxFxCxegedabagaced

# default to ls with color and to display directories with a trailing slash
 alias ls="ls -GFh"

# enable bash completion if installed via homebrew, I should move this into the homebrew directory
# TODO: I don't know if this is actually needed in my personal dotfiles project
# if [ -f $(brew --prefix)/etc/bash_completion ]; then
#   . $(brew --prefix)/etc/bash_completion
# fi

# # Stash your environment variables in ~/.localrc. This means they'll stay out
# # of your main dotfiles repository (which may be public, like this one), but
# # you'll have access to them in your scripts.
# # TODO do something like this in config_vars
# if [[ -a ~/.localrc ]]
# then
#   source ~/.localrc
# fi


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

# Reset DNS cache
function dnsresponder {
    sudo killall -HUP mDNSResponder; sleep 2; echo macOS DNS Cache Reset
}

# TODO Add method to update my dot files here
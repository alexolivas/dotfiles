#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

set -e

#echo ''

displayUsageAndExit() {
	echo "bootstrap.sh "
	echo ""
	echo "Usage: [options]"
	echo ""
	echo "Without any parameters a complete bootstrapping of the dotfiles will be run"
	echo "Options:"
	echo "  -u    Optional parameter to only run updates"
	echo "  -s    Optional parameter to source the file"
	echo " "
}

info () {
  printf "\r[ \033[00;34mOK\033[0m ] $1\n"
}

user () {
  printf "\r[ \033[0;33mOK\033[0m ] \033[0;33m$1\033[0m\n"
}

success () {
  printf "\r\033[2K[ \033[00;32mOK\033[0m ] \033[0;32m$1\033[0m\n"
}

fail () {
  printf "\r\033[2K[\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

IGNORE_SYMLINK_BOOTSTRAP=false
SOURCE_ONLY=false
while getopts 'us' flag; do
    case "${flag}" in
        u)
            # We are only updating so ignore bootstrapping the symlinks
            IGNORE_SYMLINK_BOOTSTRAP=true;;
        s)
            # Don't run any of the updates the user is just sourcing this file to use the methods declared
            SOURCE_ONLY=true;;
        *)
            displayUsageAndExit
        exit 1 ;;
  esac
done
#setup_gitconfig () {
#  if ! [ -f git/gitconfig.local.symlink ]
#  then
#    info 'setup gitconfig'
#
#    git_credential='cache'
#    if [ "$(uname -s)" == "Darwin" ]
#    then
#      git_credential='osxkeychain'
#    fi
#
#    user ' - What is your github author name?'
#    read -e git_authorname
#    user ' - What is your github author email?'
#    read -e git_authoremail
#
#    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.example > git/gitconfig.local.symlink
#
#    success 'gitconfig'
#  fi
#}


# TODO Move this to utils.sh
link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      info "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      info "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      info "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

bootstrap_symlinks () {
  printf "\r\033[0;34m#######################################################################\033[0m\n"
  printf "\r\033[0;34m#                    Bootstrapping symlinks..                  #\033[0m\n"
  printf "\r\033[0;34m#######################################################################\033[0m\n"

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}


#install_certs_in_keychain () {
#    local overwrite_all=false backup_all=false skip_all=false
#
#    ### edit below ###
#
#    info "adding certs to keychain"
#    for src in $(find -H `pwd` -name 'bv*.pem')
#    do
#        info "adding ${src} to keychain"
#        security add-trusted-cert -d -r trustRoot -k ~/Library/Keychains/login.keychain $src
#    done
#
#    ### edit above ###
#
#}


# Do not run any of the bootstrapping code if this file is only being sourced for the functions;
# install.sh files will usually source this file to use the success, fail, info, user methods
#if [ "${1}" != "--source-only" ]; then
if [ $SOURCE_ONLY == false ]; then
    #setup_gitconfig
    #setup_krb5

    if [ $IGNORE_SYMLINK_BOOTSTRAP == false ]; then
        bootstrap_symlinks
    fi
    #setup_sshconfig

    if source script/dot_helper | while read -r data; do info "$data"; done
    then
#      success "--------------------------------------"
#      success "Custom installers completed"
      info " "
    else
      fail "error installing dependencies"
    fi

    user "--------------------------------------"
    user "Sourcing bash_profile"
    user "--------------------------------------"
    SOURCE_BASH_PROFILE=$(. $HOME/.bash_profile)
    success '.bash_profile sourced'

    info ""
    success "Finished installing/updating dotfiles!"
fi

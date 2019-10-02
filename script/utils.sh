#!/bin/bash

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

# This method is responsible for rsync'ing all *.rsync files into the home directory
rsync_dotfiles() {
  user "--------------------------------------"
  user "Syncing dotfiles"
  user "--------------------------------------"

  # TODO: add custom work computer logic >> if there is a profile.d, ignore bash_profile
  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.rsync' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"

    if [[ -d $src ]]; then
      if [ -d $dst ]; then
          info "Overriding dotfile directory: ${dst}"
      else
          info "Copying dotfile directory: ${dst}"
      fi

      # Syncing over a directory and its contents, print out details as it syncs
      SYNC_DOT_DIRECTORY=$(rsync -av "$src/" $dst)
      while read -r line; do
          info "$line"
      done <<< "$SYNC_DOT_DIRECTORY"
    elif [[ -f $src ]]; then
      # Copying over a file
      if [ -f $dst ]; then
          info "Overriding dotfile: ${dst}"
      else
          info "Copying dotfile: ${dst}"
      fi
      rsync $src $dst
    else
      fail "Invalid argument: ${src} is neither a file nor a directory"
    fi
  done
  info " "
}

# This method finds any installers and runs them iteratively
run_installers() {
  find . -name install.sh | while read installer ; do
    sh -c "${installer}" ;
  done
}

# This method adds any custom scripts found in $DOTFILES_ROOT/bin as
# symlinks to /usr/loca/bin so that they are available in your shell
symlink_custom_scripts() {
  local custom_bin=$DOTFILES_ROOT/bin
  if [ -d "$custom_bin" ]; then
    user "--------------------------------------"
    user "Linking scripts to /usr/local/bin"
    user "--------------------------------------"
    for script in $custom_bin/*; do
      link_file $script /usr/local/bin
    done
    info " "
  fi
}

# This method finds all env.sh files and sources them by either adding
# them to the user's ~/profile.d directory (if it exists) or to the user's
# local bin (if it doesn't exist)
source_env_files() {
  user "--------------------------------------"
  user "Sourcing env.sh files to shell"
  user "--------------------------------------"
  local profiled=$HOME/.profile.d
  if [ -d "$profiled" ]; then
    # This is extremely custom for my work computer; we have a dotfiles project at work
    # which takes care of a lot of things these env.sh files do. That dotfiles project
    # creates a ~/profile.d directory so if that exists simply copy over my bash/env.sh
    # file under a different name since that one contains my custom bash functions and
    # setup. All others can be ignored.
    BASH_FUNCS="${DOTFILES_ROOT}/bash/env.sh"
    cp $BASH_FUNCS $profiled/aolivas-bash.sh
    info "Adding bash customizations from bash/env.sh to ~/.profile.d/"
  else
    info ".profile.d does NOT exists, find all env.sh and source them"
    for fname in $(find $DOTFILES_ROOT -name env.sh); do
      info $fname
      # . $fname
    done
  fi
  info " "
}

# This method is responsible for setting up your git config by asking a few questions
setup_gitconfig() {
  user "--------------------------------------"
  user "Setting up git config"
  user "--------------------------------------"

  if ! [ -f git/gitconfig.local.symlink ]; then
    info 'setup gitconfig'
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
  fi
  info " "
}

# Creates a directory structure on your computer, takes in 4 parameters:
#   1: "--ignore", the first argument, if one is passed in, must be the ignore flag,
#       if not, every subsequent parameter is ignored
#   2: A directory name to omit, no match is ignored
#   3: A directory name to omit, no match is ignored
#   4: A directory name to omit, no match is ignored
create_code_directory_structure() {
  user "--------------------------------------"
  user "Creating custom directories"
  user "--------------------------------------"

  local CODE_DIRECTORY=$HOME/code

  # Keep track of personal project repos
  local PERSONAL=$CODE_DIRECTORY/personal

  # Keep track of lab repos  
  local LAB=$CODE_DIRECTORY/lab
  local COMPONENTS=$LAB/components
  local GAMES=$LAB/fun

  # Keep track of client repos
  local CLIENTS=$CODE_DIRECTORY/clients

  # Initialize the array of directories to create with the root,
  # then dynamically build it based on the ignore params passed in
  local DIRS_TO_CREATE=($CODE_DIRECTORY)

  local IGNORE_LIST=($2 $3 $4)
  if [ "$1" == "--ignore" ] && (( ${#IGNORE_LIST[@]} )); then
    index=1

    # The script is explicitly ignore some directories, only
    # create the ones that aren't being listed for ignore
    contains_element "personal" "${IGNORE_LIST[@]}"
    if [ $? == 1 ]; then
      # The "personal" directory is not marked to be ignored, create it
      DIRS_TO_CREATE[$index]=$PERSONAL
      ((index++))
    fi

    contains_element "lab" "${IGNORE_LIST[@]}"
    if [ $? == 1 ]; then
      # The "lab" directory is not marked to be ignored, create it
      DIRS_TO_CREATE[$index]=$LAB
      ((index++))

      DIRS_TO_CREATE[$index]=$COMPONENTS
      ((index++))

      DIRS_TO_CREATE[$index]=$GAMES
      ((index++))
    fi

    contains_element "clients" "${IGNORE_LIST[@]}"
    if [ $? == 1 ]; then
      # The "clients" directory is not marked to be ignored, create it
      DIRS_TO_CREATE[$index]=$CLIENTS
    fi

  else
    # No parameters (or invalid ones) were passed in, simply create all of them
    DIRS_TO_CREATE=(
      $CODE_DIRECTORY,
      $PERSONAL,
      $LAB,
      $GAMES,
      $COMPONENTS,
      $CLIENTS
    )
  fi

  for dir in ${DIRS_TO_CREATE[*]}; do
    create_directory $dir
  done
  info " "
}

############################################################
#            Private Method helper functions               #
############################################################

# This method is responsible for creating a symlink
link_file() {
  local src=$1 dst=$2
  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then
    filename="$(basename -- $src)"
    if [ -L ${dst}/${filename} ] && [ -e ${dst}/${filename} ]; then
      # This symlink exists and is not broken, don't do anything
      info "skipping; $filename already linked to $dst"
    else
      # This is a new symlink, create it
      ln -s "$src" "$dst"
      info "Created symlink: linked $filename to $dst"
    fi
  else
    # TODO: this has to be a warning
    user "Warning! Symlink destination ${dst} is not a file nor directory"
  fi
}

# Creates a directory if it doesn't already exist
create_directory() {
  if [ ! -d "$1" ]; then
    # The directory does not exist, create it
    info "Creating directory: $1"
    mkdir -p $1
  else
    info "skipping; $1 already exists"
  fi
}

# Checks if a string value is in an array
contains_element() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}
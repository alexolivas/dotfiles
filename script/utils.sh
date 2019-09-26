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

source_bash_profile() {
  # user "--------------------------------------"
  # user "Sourcing bash_profile"
  # user "--------------------------------------"
  # SOURCE_BASH_PROFILE=$(. $HOME/.bash_profile)
  # success '.bash_profile sourced'

  SOURCE_BASH_PROFILE=$(. $HOME/.bash_profile)
  while read -r line; do
    info "$line"
  done <<< "$SOURCE_BASH_PROFILE"
  success '.bash_profile sourced'
}

# Creates a directory structure on your computer, takes in 4 parameters:
#   1: "--ignore", the first argument, if one is passed in, must be the ignore flag,
#       if not, every subsequent parameter is ignored
#   2: A directory name to omit, no match is ignored
#   3: A directory name to omit, no match is ignored
#   4: A directory name to omit, no match is ignored
create_code_directory_structure() {
  CODE_DIRECTORY=$HOME/code

  # Keep track of personal project repos
  PERSONAL=$CODE_DIRECTORY/personal

  # Keep track of lab repos  
  LAB=$CODE_DIRECTORY/lab
  COMPONENTS=$LAB/components
  GAMES=$LAB/fun

  # Keep track of client repos
  CLIENTS=$CODE_DIRECTORY/clients

  # Initialize the array of directories to create with the root,
  # then dynamically build it based on the ignore params passed in
  DIRS_TO_CREATE=($CODE_DIRECTORY)

  IGNORE_LIST=($2 $3 $4)
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

  success " "
  for dir in ${DIRS_TO_CREATE[*]}; do
    create_directory $dir
  done
}

############################################################
#            Private Method helper functions               #
############################################################

# Creates a directory if it doesn't already exist
create_directory() {
  if [ ! -d "$1" ]; then
    # The directory does not exist, create it
    success "Creating directory: $1"
    mkdir -p $1
  else
    success "$1 already exists"
  fi
}

# Checks if a string value is in an array
contains_element() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}
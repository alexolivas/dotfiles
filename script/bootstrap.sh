#!/usr/bin/env bash

# Source utils script to use its functions here
cd "$(dirname "$0")/.."
export DOTFILES_ROOT=$(pwd -P)
source $DOTFILES_ROOT/script/utils.sh

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

UPDATE_DOTFILES=false
# SOURCE_ONLY=false
while getopts 'us' flag; do
  case "${flag}" in
    u)
      # We are only updating so ignore bootstrapping the symlinks
      UPDATE_DOTFILES=true;;
    # s)
      # Don't run any of the updates the user is just sourcing this file to use the methods declared
      # SOURCE_ONLY=true;;
    *)
      displayUsageAndExit
      exit 1 ;;
  esac
done

success "############################################################################"
if $UPDATE_DOTFILES; then
  success "Dotfiles Updater Script"
else
  success "Dotfiles Bootstrapper 1.0"
fi
success "By Alex Olivas "
success "############################################################################"
success " "

if $UPDATE_DOTFILES; then
  # Only update the dotfiles repo if the user is running an update, there is no
  # need to do this on initial bootstrap installation.
  CHANGED=$(git diff-index --name-only HEAD --)
  if [ -n "$CHANGED" ]; then
    BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
    user " "
    user "----------------------------------------------------------------"
    user "WARNING! There are uncommited changes in your local dotfiles."
    user "Branch: ${BRANCH}"
    user "----------------------------------------------------------------"
    user " "
  else
    user "--------------------------------------"
    user "Looking for updates"
    user "--------------------------------------"
    GIT_PULL=$(git checkout master && git pull)
    while read -r line; do
        info "$line"
    done <<< "$GIT_PULL"
    info " "
  fi
fi

# rsync all dotfiles files and dotfiles directories to the home directory
rsync_dotfiles

# find and sources all env.sh files
source_env_files

# Symlinks any scripts in $DOTFILES_ROOT/bin into /usr/local/bin
symlink_custom_scripts

# Create the directory structure I use for my personal projects (e.g. this dotfiles)
# Ignore the client folder since I won't use a work laptop for these projects
create_code_directory_structure --ignore clients

# Set macOS defaults
# $DOTFILES/osx/set-defaults.sh

# Setup your git configuration file
setup_gitconfig

# finally, find all install scripts and run them
# run_installers

success " "
success "Done!"
if $UPDATE_DOTFILES; then
  success "Your computer has been updated to the latest dotfiles. Source your bash_profile or start a new shell."
else
  success "Dotfiles has been successfully installed on your computer. Source your bash_profile or start a new shell."
fi
success " "
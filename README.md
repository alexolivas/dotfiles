# Dotfiles Project

This repo contains dotfiles that will help ease development when working directly off of your MacBook. By default, these dotfiles install common development certificates, configure Python, Node, and Docker to use [Artifactory](https://artifactory.blu), configure the Homebrew package manager, and install a set of useful packages.

## Overview

These dotfiles are focused around topics. For example, everything under the `python/` directory pertains to configuring Python utilities like `pip` and associated environment variables. Any file ending in `.symlink` will be symlinked into the home directory preceded by a `.` and without the `.symlink` suffix. For example, `gitconfig.symlink` will be symlinked as `$HOME/.gitconfig`. Any `env.sh` files will be sourced in your shell.

## Special Files and Directories

 * **`bin/`**: Anything in `bin/` will get added to `$PATH` and made available anywhere
 * **`Brewfile`**: This is a list of applications for [Homebrew](https://brew.sh) and [Homebrew Cask](https://caskroom.github.io) to install. Files listed here can be terminal applications installed by Homebrew (like `ack` or `tmux`) or GUI applications installed by Homebrew Cask (like Chrome or Firefox).
 * **`<topic>/env.sh`**: Any `env.sh` files in a topic folder are sourced in your shell. This is a good place to put topic-specific environment variables, `$PATH` additions, or source other scripts.
 * **`<topic>/install.sh`**: Any `install.sh` files in a topic folder will be executed when running `script/install`. These scripts are used for doing any installation tasks beyond installing via Homebrew.
 * **`<topic>/*.symlink`**: Any file or directory ending in `*.symlink` will be symlinked in `$HOME` without the `*.symlink` extension and preceded by a `.`. For example, `ssh.symlink/` will get symlinked as `$HOME/.ssh/` and `python/pypirc.symlink` will get symlinked as `$HOME/.pypirc`.

## Usage

These dotfiles are meant to be useful as is, but you will have the best experience by forking this repo and making it your own by adding topic folders, editing the Brewfile, and keeping your changes in version control. To setup, run the following:

```shell
git clone <repo url> ~/.dotfiles
cd ~/.dotfiles
script/bootstrap.sh
```

This will symlink the appropriate files into your home directory and run through all the install scripts. By default, the `dot` script will run through install scripts and update macOS defaults by running `osx/set-defaults.sh`. It's a good idea to run it from time to time to make sure that everything is up to date.

NOTE: You will want to make sure to uninstall any GUI apps listed in `Brewfile` that were not installed via Homebrew Cask prior to running this script or remove them from `Brewfile`. Homebrew Cask will throw an error if it tries to install an application that is already installed and `script/bootstrap.sh` will fail to finish.

Borrowed liberally from https://github.com/holman/dotfiles.

# Dotfiles Project #

The project contains all my home director's dotfiles (i.e. .bash_profile, .bashrc). The purpose of this project is so that I have these resources available and synced across all my computers.

## Usage

```shell
git clone <repo url> ~/.dotfiles
cd ~/.dotfiles
script/bootstrap.sh
```

This will symlink the appropriate files into your home directory and run through all the install scripts. By default, the `dot` script will run through install scripts and update macOS defaults by running `macos/set-defaults.sh`. It's a good idea to run it from time to time to make sure that everything is up to date.

## Special Files and Directories

 * **`bin/`**: Anything in `bin/` will get added to `$PATH` and made available anywhere
 * **`Brewfile`**: This is a list of applications for [Homebrew](https://brew.sh) and [Homebrew Cask](https://caskroom.github.io) to install. Files listed here can be terminal applications installed by Homebrew (like `ack` or `tmux`) or GUI applications installed by Homebrew Cask (like Chrome or Firefox).
 * **`<topic>/env.sh`**: Any `env.sh` files in a topic folder are sourced in your shell. This is a good place to put topic-specific environment variables, `$PATH` additions, or source other scripts.
 * **`<topic>/install.sh`**: Any `install.sh` files in a topic folder will be executed when running `script/install`. These scripts are used for doing any installation tasks beyond installing via Homebrew.
 * **`<topic>/*.symlink`**: Any file or directory ending in `*.symlink` will be symlinked in `$HOME` without the `*.symlink` extension and preceded by a `.`. For example, `ssh.symlink/` will get symlinked as `$HOME/.ssh/` and `python/pypirc.symlink` will get symlinked as `$HOME/.pypirc`.


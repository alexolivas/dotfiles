#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in the dotfiles project
############################

########## Variables

dir=$(pwd)
files="bashrc bash_profile"    # list of files/folders to symlink in homedir

for file in $files; do
    echo "Creating symlink: ~/.$file -> $dir/$file"
    ln -s ${dir}/${file} ~/.${file}
done

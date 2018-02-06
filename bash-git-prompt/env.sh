#!/usr/bin/env bash

# enable bash-git-prompt if installed via homebrew
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    GIT_PROMPT_THEME="Custom"
    __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

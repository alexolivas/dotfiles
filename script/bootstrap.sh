#!/usr/bin/env bash

#
# bootstrap installs things.

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

set -e

echo ''

info () {
    printf "\r  [ \033[00;34m..\033[0m ] \033[00;34m$1\033[0m\n"
}

user () {
    printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

skip () {
    printf "\r\033[2K  [ \033[0;32mOK\033[0m ] $1:\033[0;33m skipped\033[0m\n"
    echo ''
}

fail () {
    printf "\r\033[2K  [ \033[0;31mFAIL\033[0m ] $1\n"
    echo ''
    exit
}

setup_gitconfig () {
    info '======================================='
    info 'setup gitconfig'
    info '======================================='

    if ! [ -f git/gitconfig.local.symlink ]
    then

        # TODO: Don't do this if a gitconfig.local.symlink is present unless you pass a flag to override
        git_credential='cache'
        if [ "$(uname -s)" == "Darwin" ]
        then
            git_credential='osxkeychain'
        fi

        user ' - What is your github author name?'
        read -e git_authorname
        user ' - What is your github author email?'
        read -e git_authoremail

        sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.example > git/gitconfig.local.symlink

        success 'gitconfig'
    else
        skip 'setup gitconfig'
    fi
}

# TODO: Add worflow to add a new connection (heroku/github/bitbucket/etc) to config.local
#setup_sshconfig () {
#    if ! [ -f ssh.symlink/config.local ]
#    then
#        info 'setup ssh config.local'
#
#        user ' - What is your IPA username?'
#        read -e ipa_username
#
#        sed -e "s/IPAUSERNAME/$ipa_username/g" ssh.symlink/config.example > ssh.symlink/config.local
#    fi
#}

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

                user "\033[0;31mFile already exists\033[0m: \033[0;34m$dst ($(basename "$src"))\033[0m, what do you want to do?\n\
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
            success "removed $dst"
        fi

        if [ "$backup" == "true" ]
        then
            mv "$dst" "${dst}.backup"
            success "moved $dst to ${dst}.backup"
        fi

        if [ "$skip" == "true" ]
        then
            success "skipped $src"
        fi
    fi

    if [ "$skip" != "true" ]  # "false" or empty
    then
        ln -s "$1" "$2"
        success "linked $1 to $2"
    fi
}

install_dotfiles () {
    info '======================================='
    info 'installing dotfiles'
    info '======================================='

    local overwrite_all=false backup_all=false skip_all=false

    for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
    do
        dst="$HOME/.$(basename "${src%.*}")"
        link_file "$src" "$dst"
    done
}

if [ "${1}" != "--source-only" ]; then
    setup_gitconfig
    install_dotfiles
    #setup_sshconfig

    # If we're on a Mac, let's install and setup homebrew.
    if [ "$(uname -s)" == "Darwin" ]
    then
        # install_certs_in_keychain
        echo ''
        info '======================================='
        info "installing dependencies"
        info '======================================='
        if source bin/dot | while read -r data; do info "$data"; done
        then
            success "dependencies installed"
        else
            fail "error installing dependencies"
        fi
    fi

    echo ''
    echo '  System updated!'
fi
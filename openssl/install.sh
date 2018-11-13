#!/bin/bash

export DOTFILES=$HOME/.dotfiles
source $DOTFILES/script/bootstrap.sh -s

user "--------------------------------------"
user "Running openssl installer"
user "--------------------------------------"

install () {
    local overwrite_all=false backup_all=false skip_all=false

    ### edit below ###

    success "Configuring OpenSSL"
    CERT_PATH="$(brew --prefix)/etc/openssl/certs/"
    for src in $(find -H `pwd` -name 'bv*.pem')
    do
        # TODO: Uncomment this and only play around with adding them to the keychain only when a certain param is passed in
#        info "adding ${src} to keychain"
#        security add-trusted-cert -d -r trustRoot -k ~/Library/Keychains/login.keychain $src

#        dst="${CERT_PATH}$(basename "${src}")"
        echo ""
#        link_file "$src" "$dst"
    done

    # TODO: Uncomment this as well
#    if $(brew --prefix)/opt/openssl/bin/c_rehash | while read -r data; do info "$data"; done
#    then
#        success "Certificate hashes updated"
#    else
#        fail "Could not update certificate hashes"
#    fi

    ### edit above ###

}

if [ -f "$(brew --prefix)/opt/openssl/bin/openssl" ]; then
    install
else
    success "Openssl is not installed, ignoring certificates"
fi

info " "
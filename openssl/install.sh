#!/bin/bash

. script/bootstrap.sh --source-only

install () {
    local overwrite_all=false backup_all=false skip_all=false

    ### edit below ###

    success "Configuring OpenSSL"
    CERT_PATH="$(brew --prefix)/etc/openssl/certs/"
    for src in $(find -H `pwd` -name 'bv*.pem')
    do
        dst="${CERT_PATH}$(basename "${src}")"
        link_file "$src" "$dst"
    done

    if $(brew --prefix)/opt/openssl/bin/c_rehash | while read -r data; do info "$data"; done
    then
        success "certificate hashes updated"
    else
        fail "could not update certificate hashes"
    fi

    ### edit above ###

}

if [ -f "$(brew --prefix)/opt/openssl/bin/openssl" ]; then
    install
else
    success "Openssl is not installed, ignoring certificates"
fi

echo ''
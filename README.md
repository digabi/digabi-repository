digabi-repository
=================

This repository includes:

 - Digabi APT repository config
 - digabi-repository .deb package configuration (equivs), which installs 
 Digabi repository into Debian based system.

## Getting Started
Requirements: you need Digabi GPG key + your SSH key must be added to 
server.

    git clone git://github.com/digabi/digabi-repository.git
    cd digabi-repository
    ./tools/sync from-server
    reprepro includedeb mypackage.deb
    ./tools/sync to-server


## Add package to repository

    reprepro includedeb jessie mypackage_1.0_all.deb
    reprepro -C non-free includedeb jessie mynonfree_1.0_all.deb


## Remove package from repository

    reprepro remove jessie mypackage
    
## List packages in repository

    reprepro list jessie    

## Sync repository from server

    ./tools/sync from-server

## Sync repository to server

    ./tools/sync to-server

digabi-repository
=================

This repository includes:

 - Digabi APT repository config
 - digabi-repository .deb package configuration (equivs), which installs 
 Digabi repository into Debian based system.


## Add package to repository

    reprepro includedeb jessie mypackage_1.0_all.deb
    reprepro -C non-free includedeb jessie mynonfree_1.0_all.deb


## Remove package from repository

    reprepro remove jessie mypackage
    
## List packages in repository

    reprepro list jessie    

## Sync repository from server

    ./sync.sh from-server

## Sync repository to server

    ./sync.sh to-server

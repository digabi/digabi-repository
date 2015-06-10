digabi-repository
=================

This repository includes:

 - Digabi APT repository config
 - digabi-repository .deb package configuration (equivs), which installs 
 Digabi repository into Debian based system.


## Getting Started
Install required packages.

    apt-get install reprepro germinate

Initialize package cache.

    ./tools/management.sh update-mirrors


## Selecting packages
Configuration for packages that get pulled from upstream repos is located at `conf/packages/` files. Files are named after the update/pull they're for.

digabi-repository
=================

This repository includes following packages:

 - `digabi-archive`: configuration for Digabi APT archive
 - `digabi-archive-keyring`: keyring that contains all valid Digabi signing keys
 - `digabi-certificates`: root certificate used by DigabiOS & other apps
 - `digabi-repository-server`: tools for running the repository server


## Configuration
### Adding packages to the repository
Configuration for packages that get pulled from upstream repos is located at `conf/packages/` files. Files are named after the update/pull they're for.


## Repository server

    apt-get install digabi-repository-server
    sudo -u digabi-repository gpg --import /path/to/digabi-repository-private.key

Then, initialize the repository & update content.

    digabi-repository-management init
    digabi-repository-management update-mirrors

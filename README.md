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
To install required packages, run

    apt-get install digabi-repository-server
    sudo -u digabi-repository gpg --import /path/to/digabi-repository-private.key

Then, initialize the repository & update content.

    sudo digabi-repository-management init
    sudo digabi-repository-management update-mirrors

Repository is published at `/var/lib/digabi-repository/repository`, share this directory using your favorite HTTP server.

Repository is running as user `digabi-repository`. The management script, ie. `digabi-repository-management` uses sudo to control repository as correct user. If you wan't to allow changes to repository without password, add

    youruser digabi-repository:digabi-repository    NOPASSWD: ALL

to `/etc/sudoers.d/digabi-repository`.

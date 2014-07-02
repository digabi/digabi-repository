How to update repository
==========================

## Requirements
 - your SSH key has been added to server `digabi.fi`
 - you have access to Digabi repository signing key (GPG), needed by `reprepro`
 - `apt-get install reprepro equivs`


## Adding new package to repository
 - build your package: `equivs-build debian/control` (inside your package directory)
 - `cd path/to/digabi-repository`
 - sync repository from server: `./tools/sync from-server`
 - add your package to repository: `reprepro includedeb jessie path/to/your/package.deb`
 - sync changes to server: `./tools/sync to-server`
 - profit!

Server Configuration
============================

## Webserver
 - Apache 2.x
 - configured to serve repository at location `/debian/`, using non-HTTPS host
 - content ALSO served via HTTPS, primarily for publishing GPG key, see <https://digabi.fi/debian/>, but this is completely optional

## Sync
 - using `rsync`
 - full path to `/debian/` is `/srv/digabi-repository/www/debian/`
 
### Create filesystem structure

    mkdir /srv/digabi-repository
    cd /srv/digabi-repository
    git clone git://github.com/digabi/digabi-repository.git .
    

### User
 - created user `reposync`
 - password disabled, login only with SSH keys (`passwd -d reposync`)
 - owns logfile `/var/log/digabi-repository.log`

#### Create user

    adduser --shell /bin/false --gecos "Digabi Repository Sync" --disabled-password reposync

#### Create logfiles for user 

    touch /var/log/digabi-repository.log
    chown root:reposync /var/log/digabi-repository.log
    chmod 0664 /var/log/digabi-repository.log

### Create user syncable directories
We like to minimize content that sync user is able to modify.

    mkdir -p /srv/digabi-repository/db
    mkdir -p /srv/digabi-repository/www/debian/dists
    mkdir -p /srv/digabi-repository/www/debian/pool
    
    chown -R reposync:reposync /srv/digabi-repository/db \
     /srv/digabi-repository/www/debian/dists \
     /srv/digabi-repository/www/debian/pool
    

#### ~/.ssh/authorized_keys
We like to restrict user access, so adding IP limitation + allowing only `rsync`.

    from="127.0.0.1",command="rsync --log-file=/var/log/digabi-repository.log --server --sender -vltprCz . /srv/digabi-repository/" ssh-rsa AAAA....
    # to get correct rsync flags: rsync -avz -e'ssh -v' path/to/digabi-repository/debian/ reposync@server:/srv/digabi-repository/
    # see for line like debug1: Sending command: ...

You need to replace `127.0.0.1` with your IP address, and `ssh-rsa AAAA....` with your SSH key (public part).

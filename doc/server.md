Server Configuration
============================

## Webserver
 - Apache 2.x
 - configured to serve repository at location `/debian/`, using non-HTTPS host
 - content ALSO served via HTTPS, primarily for publishing GPG key, see <https://digabi.fi/debian/>, but this is completely optional

## Sync
 - using `rsync`
 - full path to `/debian/` is `/srv/digabi-repository/debian/`

### User
 - created user `reposync`
 - password disabled, login only with SSH keys (`passwd -d reposync`)
 - owns logfile `/var/log/digabi-repository.log`


    adduser --shell /bin/false --gecos "Digabi Repository Sync" --disabled-password reposync

    mkdir /srv/digabi-repository
    chown root:reposync /srv/digabi-repository
    chmod 0775 /srv/digabi-repository

    touch /var/log/digabi-repository.log
    chown root:reposync /var/log/digabi-repository.log
    chmod 0664 /var/log/digabi-repository.log


#### ~/.ssh/authorized_keys
We like to restrict user access, so adding IP limitation + allowing only `rsync`.

    from="127.0.0.1",command="rsync --log-file=/var/log/digabi-repository.log --server --sender -vltprCz . /srv/digabi-repository/" ssh-rsa AAAA....
    # to get correct rsync flags: rsync -avz -e'ssh -v' path/to/digabi-repository/debian/ reposync@server:/srv/digabi-repository/
    # see for line like debug1: Sending command: ...

You need to replace `127.0.0.1` with your IP address, and `ssh-rsa AAAA....` with your SSH key (public part).

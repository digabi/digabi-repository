Server Configuration
============================

## Webserver
 - Apache 2.x
 - configured to serve `digabi-repository/www/debian` as `/debian/`, using non-HTTPS host
 - content ALSO server via HTTPS, primarily for publishing GPG key, see <https://digabi.fi/debian/>, but this is completely optional

## Sync
 - using `rsync`
 - `digabi-repository/www/debian` symlinked to `/srv/digabi-repository`

### User
 - created user `reposync`
 - owns the directory `digabi-repository/www/debian` (files: `chmod 0644`, directories: `chmod 0755`)
 - password disabled, login only with SSH keys (`passwd -d reposync`)
 - owns logfile `/var/log/digabi-repository.log`

#### ~/.ssh/authorized_keys
We like to restrict user access, so adding IP limitation + allowing only `rsync`.

    from="127.0.0.1",command="rsync --log-file=/var/log/digabi-repository.log --server --sender -vltprCz . /srv/digabi-repository/" ssh-rsa AAAA....
    # to get correct rsync flags: rsync -avz -e'ssh -v' path/to/digabi-repository/debian/ reposync@server:/srv/digabi-repository/
    # see for line like debug1: Sending command: ...

You need to replace `127.0.0.1` with your IP address, and `ssh-rsa AAAA....` with your SSH key (public part).

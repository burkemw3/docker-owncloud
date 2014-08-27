OwnCloud
========

This is an OwnCloud docker definition geared towards usage by a handful of people.

It runs the OwnCloud application and a MySQL database in one container. Data is persisted on the docker host across container restarts.

It is meant to be used with the [burkemw3/docker-nginx-proxy-path](https://github.com/burkemw3/docker-nginx-proxy-path) container for hosting at //hostname/$VIRTUAL_PATH/.

Using
=====

0. build the container: `docker build -t owncloud .`
0. create directories on docker host: `mkdir -p /opt/owncloud/mysql && mkdir -p /opt/owncloud/data && mkdir -p /opt/owncloud/config`
0. initialize database: `docker run -v /opt/owncloud/mysql:/var/lib/mysql owncloud /bin/bash -c "/usr/bin/mysql_install_db"`
0. change folder permissions: `docker run -v /opt/owncloud/data:/var/www/owncloud/data -v /opt/owncloud/config:/var/www/owncloud/config owncloud /bin/bash -c "chown www-data /var/www/owncloud/data && chown www-data /var/www/owncloud/config"`
0. start owncloud container: `docker run -d -p 80 -v /opt/owncloud/mysql:/var/lib/mysql -v /opt/owncloud/data:/var/www/owncloud/data -v /opt/owncloud/config:/var/www/owncloud/config owncloud`

A container that reverse proxies requests to the OwnCloud instance is particularly useful (especially since the OwnCloud config tracks the hostname that was originally setup, and changing ports with docker wreak havoc). This is currently configured to use [burkemw3/docker-nginx-proxy-path](https://github.com/burkemw3/docker-nginx-proxy-path). Start the container with the VIRTUAL_PATH environment variable: `docker run -d -p 80 -v /opt/owncloud/mysql:/var/lib/mysql -v /opt/owncloud/data:/var/www/owncloud/data -v /opt/owncloud/config:/var/www/owncloud/config -e VIRTUAL_PATH=owncloud owncloud`. It could use [jwilder's original nginx-proxy](https://github.com/jwilder/nginx-proxy/) by changing the `DocumentRoot` in `000-default.congf` to `/var/www/` and using the `VIRTUAL_HOST` environment variable.

Reasoning
=========

I wanted an OwnCloud installation using docker. I didn't find one that fit my desires in the registry and wanted experience with docker.

The tutum/mysql container provided a self contained MySQL instance that also provided for persisting data across restarts. I used the 5.5 version because some comments mentioned issues with 5.6 series.

OwnCloud and MySQL are running in the same container to keep things contained. One container runs everything necessary for the application. This simplifies configuration, authentication, and authorization.
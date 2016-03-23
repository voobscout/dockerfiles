# Prosody for Docker

(c) 2014 Jens Erat <email@jenserat.de>

Redistribution and modifications are welcome, see the LICENSE file for details.

[Prosody](http://prosody.im/) is a modern XMPP communication server. It aims to be easy to set up and configure, and efficient with system resources.

This Dockerfile provides a Prosody image based on the Debian packages provided in the Prosody repository.

## Setup

This image exports two volumes at the default locations in Debian, `/etc/prosody` for the configuration and `/var/lib/prosody` for (eg. user and message) data. A number of ports is exposed:

- 5000/tcp: mod_proxy65
- 5222/tcp: client to server communication
- 5223/tcp: deprecated, SSL client to server communication
- 5269/tcp: server to server communication
- 5280/tcp: BOSH
- 5281/tcp: Secure BOSH
- 5347/tcp: XMPP component
### Configuration

Create a configuration file in `/etc/prosody/prosody.cfg.lua` following the [configuration guide](http://prosody.im/doc/configure). Make sure the files belong to the prosody user (inside the container), prosody is run without root privileges!

Make sure to disallow prosody to daemonize and configure logging to stdout:

    daemonize = false;
    log = {
      warn = "*console"; -- change to debug, info, warn, error to configure log level
    }

### Database

Although Prosody can also be run without a database, you might prefer to use one for larger installations. The image already contains all available connectors, namely MySQL, PostgreSQL and SQLite.

## Running a Container

The most basic run command would be:

    docker run -d \
    	--name 'prosody' \
    	--publish 5222:5222 \
    	--publish 5269:5269 \
    	--volume /srv/prosody/etc/:/etc/prosody \
    	--volume /srv/prosody/lib:/var/lib/prosody \
    	jenserat/prosody

## Upgrading and Maintenance

Usually, Prosody does not require any special operations while performing an upgrade. To be sure, read the [release notes](http://prosody.im/doc/release).

To enter the container and perform maintenance, use (given you named the container `prosody`):

    docker exec -ti prosody /bin/bash

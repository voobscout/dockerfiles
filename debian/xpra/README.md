# xpra_container
Assuming there's some kind of Display Manager listening for XDMCP queries
i.e. your /etc/lightdm/lightdm.conf file contains:

```
[XDMCPServer]
enabled=true
port=177
```

## usage:
Exactly four parameters are required to run this container:
> order is important, since i'm lazy n'all ;-)

  1. IP address of XDMCP host
  2. TCP port inside the container to run xpra web interface on
  3. Password to access the aforementioned interface
  4. Screen resolution - ie. 1280x800

```bash
export XDMCP_HOST=$(ip addr show docker0 | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)")
export CONTAINER_HTTP_PORT=10000
export XPRA_HTML_PASSWD="mycoolpassword"
export SCREEN_RES=1280x800

export DOCKER_HOST_PORT=15000
export CONTAINER_NAME=xpra2web
```

### without exposing ports on docker host:

```bash
docker run --rm -ti --name $CONTAINER_NAME voobscout/xpra $XDMCP_HOST $CONTAINER_HTTP_PORT $XPRA_HTML_PASSWD $SCREEN_RES
```

### with exposing ports on docker host:

```bash
docker run --rm -ti -p $DOCKER_HOST_PORT:$CONTAINER_HTTP_PORT --name $CONTAINER_NAME voobscout/xpra $XDMCP_HOST $CONTAINER_HTTP_PORT $XPRA_HTML_PASSWD $SCREEN_RES
```

## autostart:

```bash
docker run --restart=always -d -ti -p $DOCKER_HOST_PORT:$CONTAINER_HTTP_PORT --name $CONTAINER_NAME voobscout/xpra $XDMCP_HOST $CONTAINER_HTTP_PORT $XPRA_HTML_PASSWD $SCREEN_RES
```

## accessing:
i.e. in your web browser:

```bash
http://localhost:15000/index.html?username=anything&password=<$XPRA_HTML_PASSWD>
```

### full example:
> assuming access from docker host machine

Run a container, named xpra2web with port 15000 on host forwarded to port 10000 in container(where xpra html5 client listens) use 172.17.0.1 as XDMCP provider and "mycoolpassword" for AUTH.

```bash
docker run --rm -ti -p 15000:10000 --name xpra2web voobscout/xpra 172.17.0.1 10000 mycoolpassword
```

in your browser, that also runs on the same host as the container:

```
http://localhost:15000/index.html?username=anything&password=mycoolpassword
```

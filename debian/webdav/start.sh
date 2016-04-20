#!/bin/bash
uname=$1
passwd=$2

htpasswd -cb /etc/apache2/webdav.passwd $uname $passwd

set -e
source /etc/apache2/envvars
exec apache2 -D FOREGROUND

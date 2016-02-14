#!/bin/bash

set -e
uname=${1}
passwd=${2}

rm -rf /root/.config/yandex-disk

expect -c "
spawn yandex-disk setup
expect \": \" {send \"n\r\"}
expect \"name: \" {send \"${uname}\r\"}
expect \"sword: \" {send \"${passwd}\r\"}
expect \": \" {send \"\r\"}
expect \": \" {send \"y\r\"}
"

yandex-disk start
tail -f /root/Yandex.Disk/.sync/core.log

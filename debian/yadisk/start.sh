#!/bin/bash
set -e

_create_user() {
    useradd -m -o -s /bin/bash -u $RUN_UID $RUN_USER
    chown -R $RUN_USER /home/$RUN_USER
}

_run_yadisk() {
    local bin="/usr/bin/qemu-i386-static /usr/bin/yandex-disk"
    local cfg="${HOME}/.config/yandex-disk"
    [[ -f ${cfg} ]] && rm -rf ${cfg} || true

    runuser $RUN_USER -c '
    expect -c "
    spawn ${bin} setup
    expect \": \" {send \"n\r\"}
    expect \"name: \" {send \"${YANDEX_UNAME}\r\"}
    expect \"sword: \" {send \"${YANDEX_PASSWD}\r\"}
    expect \": \" {send \"${HOME}/Yandex.Disk\r\"}
    expect \": \" {send \"y\r\"}
    "'
    runuser $RUN_USER -c "${bin} start"
    runuser $RUN_USER -c 'tail -f ${HOME}/Yandex.Disk/.sync/core.log'
}

[[ $RUN_USER && $RUN_UID && $YANDEX_UNAME && $YANDEX_PASSWD ]] && _create_user || (echo  '$RUN_USER && $RUN_UID && $YANDEX_UNAME && $YANDEX_PASSWD are required!' && exit 1)
_run_yadisk

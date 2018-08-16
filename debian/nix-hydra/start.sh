#!/bin/bash
set -e

_chk_env() {
    # [[ $HYDRA_DBI && $HYDRA_DATA ]]

    HYDRA_DBI="dbi:Pg:dbname=hydra;host=dbserver.example.org;user=hydra;"
    HYDRA_DATA=/var/lib/hydra
}

_create_user() {
    useradd -m -o -s /bin/bash -u $RUN_UID $RUN_USER
    chown -R $RUN_USER /home/$RUN_USER
}

_run_yadisk() {
    local cfg="${HOME}/.config/yandex-disk"
    [[ -f ${cfg} ]] && rm -rf ${cfg} || true

    runuser $RUN_USER -c '
    expect -c "
    spawn /usr/bin/yandex-disk setup
    expect \": \" {send \"n\r\"}
    expect \"name: \" {send \"${YANDEX_UNAME}\r\"}
    expect \"sword: \" {send \"${YANDEX_PASSWD}\r\"}
    expect \": \" {send \"${HOME}/Yandex.Disk\r\"}
    expect \": \" {send \"y\r\"}
    "'
    runuser $RUN_USER -c "/usr/bin/yandex-disk start"
    runuser $RUN_USER -c 'tail -f ${HOME}/Yandex.Disk/.sync/core.log'
}

# nix-channel --add http://hydra.nixos.org/jobset/hydra/master/channel/latest
# nix-channel --update
# nix-env -i hydra
# [[ $RUN_USER && $RUN_UID && $YANDEX_UNAME && $YANDEX_PASSWD ]] && _create_user || (echo  '$RUN_USER && $RUN_UID && $YANDEX_UNAME && $YANDEX_PASSWD are required!' && exit 1)

exec /home/hydra/.nix-profile/bin/nix-daemon

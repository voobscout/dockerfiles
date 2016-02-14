#! /bin/bash

# The use of this script should be temporary.
# The reason is that fail2ban cannot actually be started in foreground mode AND load the configured jail at the same time
# see: https://github.com/fail2ban/fail2ban/issues/1107
# The first post is still relevant.
# With fail2ban evolution, we should be able to to replace this scrip with a CMD or ENTRYPOINT in the Dockerfile
rm -rf /var/run/fail2ban
mkdir -p /var/run/fail2ban
function check_timezone {
    CURRENT_TZ=`cat /etc/timezone`
    if [ -z $TIMEZONE ]; then
        echo "The environment variable 'TIMEZONE' is not set, using default: $CURRENT_TZ";
    else
        if [ $CURRENT_TZ != $TIMEZONE ]; then
            echo "Configuring timezone to \"$TIMEZONE\""
            echo $TIMEZONE > /etc/timezone
            dpkg-reconfigure -f noninteractive tzdata
        else
            echo "Timezone already configured"
        fi
    fi
}

check_timezone && fail2ban-client start && tail -f /var/log/fail2ban.log

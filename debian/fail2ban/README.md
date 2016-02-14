# fail2ban

## RUN
The /var/log directory of the host is mounted on /var/log/host of the container, edit jail.local accordingly
```
docker run -ti --rm --net=host --privileged -e TIMEZONE="Europe/Paris" -v /var/log:/var/log/host -v ~/your/jail.local:/etc/fail2ban/jail.local voobscout/base-deb:fail2ban
```

## jail.local - example
```
[DEFAULT]
ignoreip = 127.0.0.1/8
bantime  = 3600
findtime  = 3600
maxretry = 3

# JAILS
[ssh]
enabled = true
port    = ssh
filter  = sshd
logpath  = /var/log/host/secure
maxretry = 1

```

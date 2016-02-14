# voobscout/base-deb
```
docker run -d -ti voobscout/base-deb:latest
```

## apache2
```
docker run -d -ti -p 443:443/tcp -p 80:80/tcp -v /your/html/root:/var/www/html voobscout/base-deb:httpd
```


## fail2ban
```
docker run -d -ti --privileged --net host -v /var/log:/var/log/host -v /your/jail.local:/etc/fail2ban/jail.local voobscout/base-deb:fail2ban
```
> jail.local example:

----
```
[DEFAULT]
ignoreip = 127.0.0.1/8
bantime  = 3600
findtime  = 3600
maxretry = 3

[ssh]
enabled = true
port    = ssh
filter  = sshd
logpath  = /var/log/host/secure
maxretry = 1
```

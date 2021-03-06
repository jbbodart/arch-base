#!/bin/bash

# exit script if return code != 0
set -e

# set locale
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen
echo LANG="en_US.UTF-8" > /etc/locale.conf

# install supervisor
pacman -S supervisor --noconfirm

# add user "nobody" to primary group "users" (will remove any other group membership)
usermod -g users nobody

# add user "nobody" to secondary group "nobody" (will retain primary membership)
usermod -a -G nobody nobody

# setup env for user nobody
mkdir -p /home/nobody
chown -R nobody:users /home/nobody
chmod -R 775 /home/nobody
 
# cleanup
yes|pacman -Scc
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /root/*
rm -rf /tmp/*

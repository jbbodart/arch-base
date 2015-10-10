#!/bin/bash

# exit script if return code != 0
set -e

# set locale
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen
echo LANG="en_US.UTF-8" > /etc/locale.conf

# update arch repo list with fr mirrors
echo 'Server = http://archlinux.aubrac-medical.fr/$repo/os/$arch' > /etc/pacman.d/mirrorlist
echo 'Server = http://mirror.archlinux.ikoula.com/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://archlinux.vi-di.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://mir.art-software.fr/arch/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://mirror.bitrain.co/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://fooo.biz/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://fooo.biz/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://mirror.ibcp.fr/pub/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://mirror.lastmikoi.net/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://mirror.bitjungle.info/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirror.bitjungle.info/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://archlinux.mailtunnel.eu/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://www.mailtunnel.eu/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://mir.archlinux.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://arch.nimukaito.net/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://archlinux.mirrors.ovh.net/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://archlinux.mirror.pkern.at/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://archlinux.mirror.pkern.at/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://archlinux.polymorf.fr/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://arch.static.lu/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://arch.static.lu/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://arch.tamcore.eu/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://mirror.tyborek.pl/arch/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://ftp.u-strasbg.fr/linux/distributions/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = http://arch.yourlabs.org/$repo/os/$arch' >> /etc/pacman.d/mirrorlist

# update pacman and db
pacman -Sy --noconfirm
pacman -S pacman --noconfirm
pacman-db-upgrade

# refresh keys for pacman
dirmngr </dev/null
pacman-key --refresh-keys

# install, run and remove reflector
pacman -S --needed --noconfirm reflector
reflector --verbose -l 10 -p http --sort rate --save /etc/pacman.d/mirrorlist
pacman -Rs --noconfirm reflector

# update packages
pacman -Syu --ignore filesystem --noconfirm

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

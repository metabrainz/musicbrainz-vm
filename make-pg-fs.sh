#!/bin/sh

apt-get install -y parted
parted /dev/sdb mklabel msdos
parted /dev/sdb --align cylinder --script -- mkpart primary 0 -1
mkfs.ext4 /dev/sdb1
mkdir -p /mnt/pgdata
mount -t ext4 /dev/sdb1 /mnt/pgdata
mkdir -p /mnt/pgdata/pgdata

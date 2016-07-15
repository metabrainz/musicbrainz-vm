#!/bin/bash

apt-get install -y parted
parted /dev/sdb mklabel msdos
parted /dev/sdb --align cylinder --script -- mkpart primary 0 -1
mkfs.ext4 /dev/sdb1
mkdir -p /mnt/pgdata
mount -t ext4 /dev/sdb1 /mnt/pgdata
mkdir -p /mnt/pgdata/pgdata

FSTAB=`grep pgdata /etc/fstab | wc -l`
echo "$FSTAB lines mentioned pgdata in fstab"
if [[ $FSTAB == "0" ]]; then
    echo "/dev/sdb1     /mnt/pgdata ext4 defaults 0 0" >> /etc/fstab
fi

#!/bin/bash

apt-get install -y parted
parted /dev/sdb mklabel msdos
parted /dev/sdb --align cylinder --script -- mkpart primary 0 -1
mkfs.ext4 /dev/sdb1
mkdir -p /mnt/docker-volumes
mount -t ext4 /dev/sdb1 /mnt/docker-volumes

FSTAB=`grep docker-volumes /etc/fstab | wc -l`
echo "$FSTAB lines mentioned docker-volumes in fstab"
if [[ $FSTAB == "0" ]]; then
    echo "/dev/sdb1     /mnt/docker-volumes ext4 defaults 0 0" >> /etc/fstab
fi

# move the docker volumes to the new disk
echo "stop docker daemon..."
/etc/init.d/docker stop

mv -v /var/lib/docker/* /mnt/docker-volumes
rm -rf /var/lib/docker
ln -s /mnt/docker-volumes /var/lib/docker

echo "start docker daemon..."
/etc/init.d/docker start

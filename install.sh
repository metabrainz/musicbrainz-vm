#!/bin/bash

#FTP_URL=ftp://ftp.musicbrainz.org
FTP_URL=ftp://ftp.eu.metabrainz.org
VMSIZE=10000
PG_DATA_FILE=./pg-data.vmdk

vagrant up --provision
if [[ $? != "0" ]]; then
    echo "creating and provisioning the VM failed."
    exit
fi


VMID=`vboxmanage showvminfo musicbrainz-vm --machinereadable | grep ^UUID | grep -o '[a-fA-F0-9]\{8\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{12\}'`
echo "VM UUID is $VMID"
if [[ $VMID == "" ]]; then
    echo "Unable to detect the VM UUID"
    exit
fi

echo "Creating disk for VM $MVID"
VBoxManage createmedium disk --filename $PG_DATA_FILE --format VMDK --size $VMSIZE
if [[ $? != "0" ]]; then
    echo "creating postgres medium failed"
    exit
fi

VBoxManage storageattach $VMID --storagectl 'SATA Controller' --port 1 --device 0 --type hdd --medium $PG_DATA_FILE
if [[ $? != "0" ]]; then
    echo "attaching postgres medium failed"
    exit
fi

vagrant ssh -- /vagrant/install-musicbrainz.sh
if [[ $? != "0" ]]; then
    echo "installing the MusicBrainz software failed."
    exit
fi

vagrant ssh -- /vagrant/load-data.sh $FTP_URL
if [[ $? != "0" ]]; then
    echo "Loading the MusicBrainz data failed."
    exit
fi

#!/bin/bash

#FTP_SERVER=ftp.musicbrainz.org
FTP_SERVER=ftp.eu.metabrainz.org
VMSIZE=120000
PG_DATA_FILE=./pg-data.vdi

vagrant up --no-provision
if [[ $? != "0" ]]; then
    echo "creating the VM failed."
    exit
fi

VMID=`vboxmanage showvminfo musicbrainz-vm --machinereadable | grep ^UUID | grep -o '[a-fA-F0-9]\{8\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{12\}'`
echo "VM UUID is $VMID"
if [[ $VMID == "" ]]; then
    echo "Unable to detect the VM UUID"
    exit
fi

# if not exists, vboxmanage closemedium ad26ad5c-b19e-46ba-bee6-88c4e82d7ec7 --delete

echo "Creating disk for VM $MVID"
VBoxManage createmedium disk --filename $PG_DATA_FILE --format VDI --size $VMSIZE
ERR=$?
if [[ $ERR != "0" ]]; then
    echo "creating postgres medium failed. Error $ERR"
    exit
fi

vagrant halt
if [[ $? != "0" ]]; then
    echo "stopping the VM to attach a new disk failed"
    exit
fi

VBoxManage storageattach $VMID --storagectl 'SATA Controller' --port 1 --device 0 --type hdd --medium $PG_DATA_FILE
if [[ $? != "0" ]]; then
    echo "attaching postgres medium failed."
    exit
fi

vagrant up --provision
if [[ $? != "0" ]]; then
    echo "provisioning the VM failed."
    exit
fi

echo "Basic setup of the VM"
vagrant ssh -- sudo /vagrant/bootstrap.sh
if [[ $? != "0" ]]; then
    echo "setting basics of the VM failed"
    exit
fi

echo "Create partitions and filesystem for postgres drive"
vagrant ssh -- sudo /vagrant/make-docker-fs.sh
if [[ $? != "0" ]]; then
    echo "create partition and filesystem for docker volumes failed"
    exit
fi

MBVM_RELEASE=`git describe --always --broken --dirty`
echo "Set MusicBrainz Virtual Machine version to ${MBVM_RELEASE-[MISSING RELEASE INFO]}"
vagrant ssh -- sudo /bin/bash -c "echo MBVM_RELEASE=$MBVM_RELEASE > /etc/mbvm-release"
if [[ $? != "0" ]]; then
    echo "Setting the MusicBrainz Virtual Machine release info failed."
    exit
fi

vagrant ssh -- /vagrant/install-musicbrainz.sh
if [[ $? != "0" ]]; then
    echo "installing the MusicBrainz software failed."
    exit
fi

vagrant ssh -- /vagrant/load-data.sh $FTP_SERVER
if [[ $? != "0" ]]; then
    echo "Loading the MusicBrainz data failed."
    exit
fi

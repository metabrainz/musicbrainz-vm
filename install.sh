#!/bin/bash

FTP_MB=ftp://ftp.eu.metabrainz.org/pub/musicbrainz
IMPORT=fullexport
VMSIZE=120000
PG_DATA_FILE=./pg-data.vdi

HELP=$(cat <<EOH

Usage: $0 [-sample] [<MusicBrainz FTP URL>]

Build MusicBrainz Virtual Machine.

Options:
  -sample     Load sample data instead of full data

Full/sample data dump is downloaded from MusicBrainz FTP,
whose URL can be specified (to use a mirror), default is:
"$FTP_MB"
EOH
)

if [ $# -gt 2 ]; then
    echo "$0: too many arguments"
    echo "$HELP"
    exit 1
fi

while [ $# -gt 0 ]; do
    case "$1" in
        -sample )
            IMPORT=sample
            ;;
        -*      )
            echo "$0: unrecognized option '$1'"
            echo "$HELP"
            exit 1
            ;;
        *       )
            FTP_MB="$1"
            ;;
    esac
    shift
done

vagrant up --no-provision
if [[ $? != "0" ]]; then
    echo "creating the VM failed."
    exit 1
fi

VMID=`vboxmanage showvminfo musicbrainz-vm --machinereadable | grep ^UUID | grep -o '[a-fA-F0-9]\{8\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{12\}'`
echo "VM UUID is $VMID"
if [[ $VMID == "" ]]; then
    echo "Unable to detect the VM UUID"
    exit 1
fi

# if not exists, vboxmanage closemedium ad26ad5c-b19e-46ba-bee6-88c4e82d7ec7 --delete

echo "Creating disk for VM $MVID"
VBoxManage createmedium disk --filename $PG_DATA_FILE --format VDI --size $VMSIZE
ERR=$?
if [[ $ERR != "0" ]]; then
    echo "creating postgres medium failed. Error $ERR"
    exit 1
fi

vagrant halt
if [[ $? != "0" ]]; then
    echo "stopping the VM to attach a new disk failed"
    exit 1
fi

VBoxManage storageattach $VMID --storagectl 'SATA Controller' --port 1 --device 0 --type hdd --medium $PG_DATA_FILE
if [[ $? != "0" ]]; then
    echo "attaching postgres medium failed."
    exit 1
fi

vagrant up --provision
if [[ $? != "0" ]]; then
    echo "provisioning the VM failed."
    exit 1
fi

echo "Basic setup of the VM"
vagrant ssh -- sudo /vagrant/lib/basic-setup.sh
if [[ $? != "0" ]]; then
    echo "setting basics of the VM failed"
    exit 1
fi

echo "Create partitions and filesystem for postgres drive"
vagrant ssh -- sudo /vagrant/lib/docker-filesystem.sh
if [[ $? != "0" ]]; then
    echo "create partition and filesystem for docker volumes failed"
    exit 1
fi

MBVM_RELEASE=`git describe --always --broken --dirty`
echo "Set MusicBrainz Virtual Machine version to ${MBVM_RELEASE-[MISSING RELEASE INFO]}"
vagrant ssh -- "sudo /bin/bash -c 'echo MBVM_RELEASE=$MBVM_RELEASE > /etc/mbvm-release'"
if [[ $? != "0" ]]; then
    echo "Setting the MusicBrainz Virtual Machine release info failed."
    exit 1
fi

vagrant ssh -- /vagrant/lib/musicbrainz-software.sh
if [[ $? != "0" ]]; then
    echo "installing the MusicBrainz software failed."
    exit 1
fi

vagrant ssh -- /vagrant/lib/postgresql-data.sh "$FTP_MB" "$IMPORT"
if [[ $? != "0" ]]; then
    echo "Loading the MusicBrainz data failed."
    exit 1
fi

#!/bin/bash

VMID=`vboxmanage list vms | grep musicbrainz-vm | grep -o '[a-fA-F0-9]\{8\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{12\}'`
ROOT_ID=`vboxmanage showvminfo musicbrainz-vm | grep 'SATAController (0, 0)' | grep -o '[a-fA-F0-9]\{8\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{12\}'`
ROOT_FILE=`vboxmanage showvminfo --machinereadable musicbrainz-vm | grep 'SATAController-0-0' | awk -F\" '{print $4}'`
PG_ID=`vboxmanage showvminfo musicbrainz-vm | grep 'SATAController (1, 0)' | grep -o '[a-fA-F0-9]\{8\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{12\}'`
PG_FILE=`vboxmanage showvminfo --machinereadable musicbrainz-vm | grep 'SATAController-1-0' | awk -F\" '{print $4}'`
VM_DIR=$(dirname "${ROOT_FILE}")
DATE=`date +%Y-%m-%d`

echo -n "==="
echo -n `date`
echo "=== start export of MusicBrainz VM:"

echo "=== VM UUID: $VMID $VM_DIR"
echo "=== root fs UUID: $ROOT_ID $ROOT_FILE"
echo "=== postgres fs UUID: $PG_ID $PG_FILE"
echo


echo "=== compact postgres fs:"
vboxmanage modifymedium --compact $PG_ID

echo "=== clone, compact main fs:"
vboxmanage clonemedium --format VDI $ROOT_ID "$VM_DIR/box-disk1.vdi"
vboxmanage storageattach $VMID --storagectl 'SATAController' --port 0 --type hdd --medium "$VM_DIR/box-disk1.vdi"
vboxmanage modifymedium --compact $ROOT_ID

echo "=== export OVA"
vboxmanage export $VMID -o "musicbrainz-server-$DATE.ova"

To export the VM for deployment:
================================

Compact the PG medium:

vboxmanage modifymedium --compact <uuid of PG disk>

Clone, attach and compact the base box:

vboxmanage clonemedium --format VDI <uuid of basebox medium> /Users/robert/VirtualBox\ VMs/musicbrainz-vm/box-disk1.vdi
vboxmanage storageattach <uuid of vm> --storagectl 'SATA Controller' --port 0 --type hdd --medium /Users/robert/VirtualBox\ VMs/musicbrainz-vm/box-disk1.vdi
vboxmanage modifymedium --compact <uuid of cloned basebox medium>

Export the VM:

vboxmanage export bead95d7-05b4-4c11-a65a-7952155b0ab1 -o musicbrainz-server-<date, etc>.ova

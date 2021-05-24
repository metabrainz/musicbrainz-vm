#!/bin/sh

vagrant -f destroy
rm -rf ~/VirtualBox\ VMs/musicbrainz-solr-vm/
rm -rf .vagrant
rm -f pg-data.vmdk
vboxmanage closemedium ./pg-data.vdi --delete

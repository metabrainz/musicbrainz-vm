#!/bin/sh

vagrant -f destroy
rm -rf ~/VirtualBox\ VMs/musicbrainz-vm/ ~/VirtualBox\ VMs/ubuntu-xenial-16.04-cloudimg
rm -rf .vagrant
rm -f pg-data.vmdk
vboxmanage closemedium ./pg-data.vmdk --delete

#!/bin/bash

# install helper scripts dependencies
apt-get install -y docker.io docker-compose lua5.2 lua-yaml

# copy the helper scripts from the musicbrainz-vm repo locally
mkdir -p bin
cp -r /vagrant/bin/* bin
chown -R vagrant.vagrant bin

# copy the doc that explains how to use the generated VM
cp --preserve=timestamps /vagrant/VM-USAGE.md VM-USAGE.md
chown vagrant.vagrant VM-USAGE.md

# copy the script that prints MusicBrainz text at login
cp --preserve=mode,timestamps {/vagrant/provision,}/etc/updated-motd.d/11-musicbrainz-text

echo "Basic setup of the VM is complete. (bootstrap)"

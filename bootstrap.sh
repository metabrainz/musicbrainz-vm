#!/bin/bash

# install helper scripts dependencies
apt-get install -y docker.io docker-compose lua5.2 lua-yaml

# copy the helper scripts from the musicbrainz-vm repo locally
mkdir -p bin
cp -r /vagrant/bin/* bin

echo "Basic setup of the VM is complete. (bootstrap)"

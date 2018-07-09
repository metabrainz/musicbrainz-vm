#!/bin/bash

# install docker and docker-compose
apt-get install -y docker.io docker-compose

# copy the helper scripts from the musicbrainz-vm repo locally
mkdir -p bin
cp -r /vagrant/bin/* bin
mkdir -p lib
cp -r /vagrant/lib/* lib

echo "Basic setup of the VM is complete. (bootstrap)"

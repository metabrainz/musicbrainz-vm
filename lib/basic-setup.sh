#!/bin/bash

set -e -u

# install helper scripts dependencies
DOCKER_GPG_KEY="9DC858229FC7DD38854AE2D88D81803C0EBFCD88"
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys "$DOCKER_GPG_KEY"
add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
apt-get update
apt-get install -y bash-completion docker-ce lua5.2 lua-yaml
DOCKER_COMPOSE_VERSION="1.24.0"
curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -L "https://raw.githubusercontent.com/docker/compose/$DOCKER_COMPOSE_VERSION/contrib/completion/bash/docker-compose" -o /etc/bash_completion.d/docker-compose

# add the vagrant user to the docker group
# for when messing with docker in the VM directly
adduser vagrant docker

# copy the helper scripts from the musicbrainz-vm repo locally
cp -R --preserve=mode,timestamps {/vagrant/provision,}/home/vagrant/bin
chown -R vagrant.vagrant bin

# copy the doc that explains how to use the generated VM
cp --preserve=timestamps /vagrant/VM-USAGE.md VM-USAGE.md
chown vagrant.vagrant VM-USAGE.md

# copy the script that prints MusicBrainz text at login
cp --preserve=mode,timestamps {/vagrant/provision,}/etc/updated-motd.d/11-musicbrainz-text

echo "Basic setup of the VM is complete."

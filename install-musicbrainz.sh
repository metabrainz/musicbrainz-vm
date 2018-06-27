#!/bin/bash

# Add the vagrant user to the docker group for when messing with docker in the VM directly
sudo adduser vagrant docker

cd
mkdir -p musicbrainz
cd musicbrainz

# Clone the musicbrainz-docker repo
if [[ ! -d "musicbrainz-docker" ]]; then
    git clone https://github.com/yvanzo/musicbrainz-docker.git
else
    cd musicbrainz-docker
    git pull origin master
    cd -
fi

if [[ ! -e "~/musicbrainz-server" ]]; then
    ln -s ~/musicbrainz/musicbrainz-docker/musicbrainz-dockerfile/musicbrainz-server ~/musicbrainz-server
fi

cd musicbrainz-docker
sudo docker-compose build
sudo docker-compose up -d
cd 

COUNT=`crontab -l | grep replicate | wc -l`
echo "$COUNT lines mention replication"
if [[ $COUNT == "0" ]]; then
    echo "Adding replication cron entry"
    (crontab -l ; echo "0 * * * * /home/vagrant/bin/replicate now >> /home/vagrant/replication.log") | crontab -
fi
./bin/replicate stop

echo "Installation of MusicBrainz software is complete."
echo 

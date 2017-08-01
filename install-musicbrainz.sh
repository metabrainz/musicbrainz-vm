#!/bin/bash

# Add the vagrant user to the docker group for when messing with docker in the VM directly
sudo adduser vagrant docker

cd
mkdir -p musicbrainz
cd musicbrainz

# Clone the musicbrainz-docker repo
if [[ ! -d "musicbrainz-docker" ]]; then
    git clone https://github.com/mayhem/musicbrainz-docker.git
else
    cd musicbrainz-docker
    git pull origin master
    cd -
fi

if [[ ! -d "search-server" ]]; then
    git clone https://github.com/metabrainz/search-server.git
else
    cd search-server
    git pull origin master
    cd -
fi

cd ~/musicbrainz/musicbrainz-docker/indexer-dockerfile
if [[ ! -e "index.jar" ]]; then
    echo "Downloading search indexer"
    curl -o index.jar http://ftp.musicbrainz.org/pub/musicbrainz/search/index/index.jar
fi

cd ~/musicbrainz/musicbrainz-docker/search-dockerfile
if [[ ! -e "searchserver.war" ]]; then
    echo "Downloading server server"
    curl -o searchserver.war http://ftp.musicbrainz.org/pub/musicbrainz/search/servlet/searchserver.war
fi

# setup to use npm
sudo apt-get install -y nodejs npm
sudo sh -c 'curl -sL https://deb.nodesource.com/setup_6.x | bash'

# clone the repo so it can live in the VM

cd ~/musicbrainz/musicbrainz-docker/musicbrainz-dockerfile
if [[ ! -d "musicbrainz-server" ]]; then
    git clone https://github.com/metabrainz/musicbrainz-server.git
fi

if [[ ! -e "~/musicbrainz-server" ]]; then
    ln -s ~/musicbrainz/musicbrainz-docker/musicbrainz-dockerfile/musicbrainz-server ~/musicbrainz-server
fi

cd musicbrainz-server
cp ../DBDefs.pm lib
npm i

cd ../..

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

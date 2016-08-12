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
    git clone https://bitbucket.org/metabrainz/search-server.git
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

cd ~/musicbrainz/musicbrainz-docker
sudo docker-compose build
sudo docker-compose up -d
cd 

echo "Installation of MusicBrainz software is complete."
echo 

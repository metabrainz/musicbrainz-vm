#!/bin/bash

set -e -u

cd
mkdir -p musicbrainz
cd musicbrainz

# Clone the musicbrainz-docker repo
if [[ ! -d "musicbrainz-docker" ]]; then
    git clone --depth=1 https://github.com/yvanzo/musicbrainz-docker.git
else
    cd musicbrainz-docker
    git pull origin master
    cd -
fi

cd musicbrainz-docker
sed -i '/crons.conf/d' musicbrainz-dockerfile/Dockerfile
docker-compose build
docker-compose up -d
sudo systemctl enable docker
cd 

COUNT=`crontab -l | grep replicate | wc -l`
echo "$COUNT lines mention replication"
if [[ $COUNT == "0" ]]; then
    echo "Adding replication cron entry"
    (crontab -l ; echo "0 3 * * * /home/vagrant/bin/replicate cron >> /home/vagrant/replication.log") | crontab -
fi
./bin/replicate stop

echo "Installation of MusicBrainz software is complete."
echo 

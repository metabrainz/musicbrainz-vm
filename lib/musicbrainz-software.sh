#!/bin/bash

set -e -u

cd
mkdir -p musicbrainz
cd musicbrainz

# Clone the musicbrainz-docker repo
git clone http://192.168.0.192:3000/yvanzo/musicbrainz-docker.git

cd musicbrainz-docker
git checkout origin/sir-solr

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

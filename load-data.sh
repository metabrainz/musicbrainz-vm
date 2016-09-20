#!/bin/bash

FTP_SERVER=$1

cd musicbrainz/musicbrainz-docker
sudo docker-compose run --rm musicbrainz /createdb.sh -fetch $FTP_SERVER

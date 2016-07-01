#!/bin/bash

FTP_URL=$1

cd musicbrainz/musicbrainz-docker
sudo docker-compose run --rm musicbrainz /createdb.sh -fetch $FTP_URL

#!/bin/bash

FTP_SERVER=$1

cd musicbrainz/musicbrainz-docker
docker-compose run --rm musicbrainz /createdb.sh -fetch $FTP_SERVER

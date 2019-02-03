#!/bin/bash

FTP_MB=$1

cd musicbrainz/musicbrainz-docker
docker-compose run --rm musicbrainz /createdb.sh -fetch $FTP_MB

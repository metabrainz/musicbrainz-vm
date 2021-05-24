#!/bin/bash

set -e -u

FTP_MB="$1"
IMPORT="$2"

if [[ $IMPORT == "sample" ]]; then
  SAMPLE="-sample"
else
  SAMPLE=""
fi

cd musicbrainz/musicbrainz-docker
#docker-compose run --rm musicbrainz /createdb.sh "$SAMPLE" -fetch "$FTP_MB"

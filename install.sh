#!/bin/bash

#FTP_URL=ftp://ftp.musicbrainz.org
FTP_URL=ftp://ftp.eu.metabrainz.org

vagrant up --provision
if [[ $? != "0" ]]; then
    echo "creating and provisioning the VM failed."
    exit
fi

vagrant ssh -- /vagrant/install-musicbrainz.sh
if [[ $? != "0" ]]; then
    echo "installing the MusicBrainz software failed."
    exit
fi

vagrant ssh -- /vagrant/load-data.sh $FTP_URL
if [[ $? != "0" ]]; then
    echo "Loading the MusicBrainz data failed."
    exit
fi

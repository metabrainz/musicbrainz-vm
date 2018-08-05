# MusicBrainz Virtual Machine

This project embeds the MusicBrainz server in slave mode, along with its search
server, its search indexer, and its dependencies Redis and PostgreSQL, in a VM.

## Using Public VM

Beta images built for VirtualBox are released here:

    ftp://ftp.eu.metabrainz.org/pub/musicbrainz-vm/

Read [VM usage](VM-USAGE.md) for usage instructions.

## Building VM

**Only do these steps if you want to go the looong way**,
otherwise download an image from the above links instead.

Please note that build scripts do not support Windows,
using VirtualBox for Mac or Linux should work fine.

0. Make sure you have 100GB free (preferably SSD) disk space (including 55GB for pg-data.vdi)
1. Clone this repo
2. Install VirtualBox. If you already have it installed, update to the lastest version!
3. Install Vagrant. Get the latest version! (1.8.x+) https://www.vagrantup.com/
4. run install.sh
5. Wait.
6. Wait some more.
7. Really, wait more.
8. You're thinking about complaining how slowly this is going? You should wait some more.
9. Better be safe than sorry, wait some more.
10. With some amount of luck you'll have a working VM without search indexes at this point.

If you encounter an error, ping ruaok or yvanzo in #metabrainz on Freenode.

Note that every _remote command_ mentionned in [VM usage](VM-USAGE.md)
instructions can be run with:

    $ vagrant ssh -- _remote command_

## Post build clean-up

Once the VM is built, a few cleanup bits should be done:

* Delete the datadump files from /media/dbdump
* Compress the data volume with this command:

        vboxmanage modifymedium disk --compact <uuid>

## Exporting VM for deployment

Stop the Vagrant environment:

    $ vagrant halt

Export the compacted VM:

    $ export.sh

Do a little dance.

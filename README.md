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

## Creating search indexes

NOTE: All of the steps below work from vagrant, but you can invoke them from the VM directly as well.

In order to use the search functions of the web site/API you will need to build search indexes. Run:

     $ vagrant ssh -- bin/reindex

This process will also take several hours -- be patient. Perhaps it is best to run this overnight.

## Connecting 

Once the machine is fully set up, you can connect to the MusicBrainz VM by going to:

     http://localhost:5000

The search service is running on port 8080 if you want to connect to it directly.

To connect to the MusicBrainz VM from another host by going to `http://example:5000`,
first set web server name (it must be resolved by every client that connects to it):

     $ vagrant ssh -- bin/set-web-server-name example

## Replication / Live Data Feed

There are a few scripts to make running the VM a little easier. The set-token script will
configure the VM with a replication access token you generate from the MetaBrainz site:

     https://metabrainz.org/supporters/account-type

After you've generated the access token, run this:

     $ vagrant ssh -- bin/set-token <replication token>

Then, to replicate the data immediately, you can run:

     $ vagrant ssh -- bin/replicate now

To replicate the data automatically once an hour, you can run:

     $ vagrant ssh -- bin/replicate start

To stop automatic replication, use:

     $ vagrant ssh -- bin/replicate stop

## Troubleshooting

If you get a mysterious error about containers not being started or some-such, try running this command:

     $ vagrant ssh -- bin/reset-containers

## Connecting additional ports

Additional ports 6379 (redis) and 15432 (db/postgresql) can be connected after running this:

     $ vagrant ssh -- bin/turn-port db on
     $ vagrant ssh -- bin/turn-port redis on

## Post build clean-up

Once the VM is built, a few cleanup bits should be done:

* Delete the datadump files from /media/dbdump
* Compress the data volume with this command:

        vboxmanage modifymedium disk --compact <uuid>

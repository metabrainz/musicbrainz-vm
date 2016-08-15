## Getting started

This project exists to create the MusicBrainz VM. If you would like to *use* the MusicBrainz VM,
consider just downloading it from here:

    https://musicbrainz.org/doc/MusicBrainz_Server/Setup

Using this project you can make your own MusicBrainz VM. Please note that this project is not supported
under Windows. Use a Mac or Linux and it should work fine.


## How to build a VM

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

If you encounter an error, ping ruaok in #metabrainz on Freenode.

## Creating search indexes

In order to use the search functions of the web site/API you will need to build search indexes. Run:

     $ vagrant ssh -- bin/reindex

This process will also take several hours -- be patient. Perhaps it is best to run this overnight.

## Connecting 

Once the machine is fully set up, you can connect to the MusicBrainz VM by going to:

     http://localhost:5000

The search service is running on port 8080 if you want to connect to it directly.


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

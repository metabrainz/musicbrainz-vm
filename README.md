This project is far from complete. Shit will break. Promise!

But, if you want to try:

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

The search indexes are next. If you encounter an error, ping ruaok in #metabrainz on Freenode.


## Troubleshooting

If you get this error:

  mount: unknown filesystem type 'vboxsf'

try:

  vagrant plugin install vagrant-vbguest


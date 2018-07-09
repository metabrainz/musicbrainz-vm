# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

NCPUS = ENV['CB_NCPUS'] || '2'
MEM = ENV['CB_MEM'] || '2048'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.hostname = "musicbrainz"

  config.vm.provider "virtualbox" do |v|
    v.memory = MEM.to_i
    v.cpus = NCPUS.to_i
    v.customize "pre-boot", ["modifyvm", :id, "--name", "musicbrainz-vm"]
  end

  config.vm.synced_folder ".", "/vagrant"
  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.network :forwarded_port, guest:  5000, host:  5000, auto_correct: true, id: "musicbrainz"
  config.vm.network :forwarded_port, guest:  8080, host:  8080, auto_correct: true, id: "search"
  config.vm.network :forwarded_port, guest:  5432, host: 15432, auto_correct: true, id: "db"
end

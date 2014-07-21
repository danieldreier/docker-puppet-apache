    # -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if defined? VagrantPlugins::Cachier
  # Cache yum update files using vagrant-cachier, if installed
    config.cache.auto_detect = true
  end
  if defined? VagrantPlugins::Vbguest
    # set auto_update to false, if you do NOT want to check the correct
    # additions version when booting this machine
    config.vbguest.auto_update = false
  end

  config.vm.define :webserver do |node|
    node.vm.box = 'puppetlabs/debian-7.4-64-nocm'
    node.vm.hostname = 'webserver.boxnet'

    config.vm.synced_folder "./hieradata", "/etc/puppet/hieradata",
      id: "hieradata",
      mount_options: ["dmode=775,fmode=664"]
    config.vm.synced_folder "./site", "/etc/puppet/local/site",
      id: "site-module-data",
      mount_options: ["dmode=775,fmode=664"]
    config.vm.synced_folder "./www", "/var/www/example.com/www",
      id: "site-www-data",
      mount_options: ["dmode=775,fmode=664"]

    config.vm.provision "shell", inline: "hash puppet || curl getpuppet.whilefork.com | bash"
    config.vm.provision "shell",
      inline: "cp /vagrant/Puppetfile /etc/puppet/Puppetfile"
    config.vm.provision "shell",
      inline: "apt-get update && puppet apply /etc/puppet/local/site/manifests/roles/base/r10k/install.pp"
    config.vm.provision "shell",
      inline: "puppet apply -e \"class { 'site::roles::base::hiera::install': }\""
    config.vm.provision "shell",
      inline: "puppet apply /etc/puppet/manifests/site.pp"

    node.vm.network :forwarded_port, guest: 80, host: 80

    node.vm.network :private_network, ip: "192.168.133.14"

    node.vm.provider :virtualbox do |vb|
       vb.customize ["modifyvm", :id, "--memory", "512", "--cpus", "4", "--ioapic", "on"]
    end
  end
end

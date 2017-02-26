# -*- mode: ruby -*-
# vi: set ft=ruby :
$script = <<SCRIPT
	export DEBIAN_FRONTEND=noninteractive
  dist=$( cat /etc/apt/sources.list | grep updates | grep 'deb http' | cut -d ' ' -f 3 | cut -d "/" -f 1)
  echo "### Adding PuppetLabs repository"
  wget -q \
	  https://apt.puppetlabs.com/puppetlabs-release-pc1-${dist}.deb \
	  -O ${HOME}/puppetlabs-release-pc1-${dist}.deb
  dpkg --install ${HOME}/puppetlabs-release-pc1-${dist}.deb >/dev/null 2>&1

  echo "### Updating repository cache"
  apt-get update >/dev/null 2>&1

  echo "### Installing Puppet and its dependencies"
  apt-get install -y apt-transport-https >/dev/null
  apt-get install -y puppet-agent >/dev/null

  echo "### Stopping Puppet service"
  PATH=$PATH:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin
  puppet resource service puppet ensure=stopped enable=false  >/dev/null 2>&1

  ln -sf /vagrant/puppet/hiera.yaml /etc/puppetlabs/puppet/hiera.yaml
SCRIPT
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
$HOSTNAME = 'dev.saboteur.vm'
$HOST_IP = '192.168.32.32'

Vagrant.configure(2) do |config|

  config.vm.box = "debian/jessie64"
  config.vm.hostname = $HOSTNAME

  config.vm.network 'private_network', ip: $HOST_IP
  # VirtualBox-specific configuration.
  config.vm.provider "virtualbox" do |vb|
    # Use VBoxManage to customize the VM.
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ['modifyvm', :id, '--name', config.vm.hostname]
  end

  config.vm.provision "install puppet", type: "shell", run: "once", inline: $script

  config.vm.synced_folder ".", "/vagrant", :nfs => true

  config.vm.synced_folder "puppet", "/etc/puppetlabs/code/environments/production", :nfs => true

  if Vagrant.has_plugin?("landrush")
    config.landrush.enabled = true
    config.landrush.host $HOSTNAME, $HOST_IP
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
    config.vbguest.auto_reboot = true
    config.vbguest.no_remote = true
  end
end

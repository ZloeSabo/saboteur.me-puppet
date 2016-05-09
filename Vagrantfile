# -*- mode: ruby -*-
# vi: set ft=ruby :
$script = <<SCRIPT
which puppet 2>&1 > /dev/null && exit 0
sudo apt-get -y update;
sudo -E apt-get -y install puppet;
sudo puppet agent --disable;
sudo service puppet stop;
SCRIPT
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "debian/jessie64"
  config.vm.hostname = 'dev.saboteur.vm'

  config.vm.network 'private_network', ip: '192.168.32.32'
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

  # config.vm.provision "bootstrap", type: "shell", run: 'once' do |s|
  #   s.privileged  = false
  #   s.path        = 'script/bootstrap.sh'
  # end

  config.vm.synced_folder ".", "/vagrant", :nfs => true
  config.vm.synced_folder "puppet/hieradata", "/tmp/vagrant-puppet/hieradata", :nfs => true

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = ["puppet/modules", "puppet/manifests"]
    puppet.hiera_config_path = "puppet/hiera.yaml"
    puppet.working_directory = "/tmp/vagrant-puppet"
    #puppet.options = ['--verbose', '--debug']
  end

  if Vagrant.has_plugin?("landrush")
    config.landrush.enabled = true
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
    config.vbguest.auto_reboot = true
    config.vbguest.no_remote = true
  end
end

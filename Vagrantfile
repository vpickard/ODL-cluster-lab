# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# NOTE: Netmask is assumed 255.255.255.0 for all

# devstack setup for control and compute nodes
DS_CONTROL1_DATA_IP     = "192.168.254.250"
DS_CONTROL2_DATA_IP     = "192.168.254.251"
DS_CONTROL3_DATA_IP     = "192.168.254.252"
DS_CONTROL_GATEWAY      = "192.168.254.254"
DS_CONTROL1_MGMT_IP     = "10.8.125.250"
DS_CONTROL2_MGMT_IP     = "10.8.125.251"
DS_CONTROL3_MGMT_IP     = "10.8.125.252"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos-7.3.virtualbox"

  #config.vm.provision.puppet.manifests_path = "/root/vic/SR-IOV-lab/puppet/manifests"
  #config.vm.provision "shell", inline: "echo Hello, World"
  config.vm.provision "shell", path: "puppet.sh"
  #config.vm.provision "puppet"


  # "Control/Compute"
  config.vm.define "control1" do |server|
    server.vm.hostname = "control1"

    # Control node data network
    server.vm.network "private_network",
                      :libvirt__network_name => 'data_net',
                      :libvirt__forward_mode => 'none',
                      ip: DS_CONTROL1_DATA_IP,
                      netmask: "255.255.255.0"

    # Management/Control network
    server.vm.network :public_network,
                      :mode => 'bridge',
                      :dev => 'em3',
                      :type => 'direct',
                      :trust_guest_rx_filters => 'true',
                      ip: DS_CONTROL1_MGMT_IP,
                      netmask: "255.255.255.0"

    server.vm.provider "libvirt" do |lv|
      lv.memory = 8096
      lv.cpus = 4
    end

    server.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "site.pp"
      puppet.options = "--verbose --debug"
    end
  end


  # "Control/Compute"
  config.vm.define "control2" do |server|
    server.vm.hostname = "control2"

    # Control node data network
    server.vm.network "private_network",
                      :libvirt__network_name => 'data_net',
                      :libvirt__forward_mode => 'none',
                      ip: DS_CONTROL2_DATA_IP,
                      netmask: "255.255.255.0"

    # Management/Control network
    server.vm.network :public_network,
                      :mode => 'bridge',
                      :dev => 'em3',
                      :type => 'direct',
                      :trust_guest_rx_filters => 'true',
                      ip: DS_CONTROL2_MGMT_IP,
                      netmask: "255.255.255.0"

    server.vm.provider "libvirt" do |lv|
      lv.memory = 8096
      lv.cpus = 4
    end

    server.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "site.pp"
      puppet.options = "--verbose --debug"
    end
  end

  # "Control/Compute"
  config.vm.define "control3" do |server|
    #server.vm.box = "rboyer/ubuntu-trusty64-libvirt" 14.04, java 7
    #server.vm.box = "rboyer/ubuntu-xenial64-libvirt" no ssh
    #server.vm.box = "wholebits/ubuntu16.04-64" no puppet
    #server.vm.box = "bento/ubuntu-16.04" no libvirt
    #server.vm.box = "yk0/ubuntu-xenial"
    #server.vm.box = "ubuntu/xenial64"

    #server.vm.box = "centos-7.3.virtualbox"
    server.vm.hostname = "control3"

    # Control node data network
    server.vm.network "private_network",
                      :libvirt__network_name => 'data_net',
                      :libvirt__forward_mode => 'none',
                      ip: DS_CONTROL3_DATA_IP,
                      netmask: "255.255.255.0"

    # Management/Control network
    server.vm.network :public_network,
                      :mode => 'bridge',
                      :dev => 'em3',
                      :type => 'direct',
                      :trust_guest_rx_filters => 'true',
                      ip: DS_CONTROL3_MGMT_IP,
                      netmask: "255.255.255.0"

    server.vm.provider "libvirt" do |lv|
      lv.memory = 8192
      lv.cpus = 4
    end

    server.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "site.pp"
      puppet.options = "--verbose --debug"
    end
  end

end

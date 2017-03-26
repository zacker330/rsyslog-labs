# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure(2) do |config|


  ANSIBLE_RAW_SSH_ARGS = []
  VAGRANT_VM_PROVIDER = "virtualbox"
  machine_box = "CentOS-7.1.1503-x86_64-netboot"


   config.vm.define "rsyslog1" do |machine|
     machine.vm.box = machine_box
     machine.vm.network "private_network", ip: "192.168.55.11"
     machine.vm.provider "virtualbox" do |node|
         node.name = "rsyslog1"
         node.memory = 1024
         node.cpus = 2
     end
    end


   config.vm.define "rsyslog2" do |machine|
     machine.vm.box = machine_box
     machine.vm.network "private_network", ip: "192.168.55.12"
     machine.vm.provider "virtualbox" do |node|
         node.name = "rsyslog2"
         node.memory = 2048
         node.cpus = 2
     end
    end


    config.vm.define "rsyslog3" do |machine|
      machine.vm.box = machine_box
      machine.vm.network "private_network", ip: "192.168.55.13"
      machine.vm.provider "virtualbox" do |node|
          node.name = "rsyslog3"
          node.memory = 1024
          node.cpus = 2
      end
     end

end

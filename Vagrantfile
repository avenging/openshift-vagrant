# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
	if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http  = ""
		config.proxy.https = ""
		config.proxy.no_proxy = "localhost,127.0.0.1,10.0.0.0/8,os-master"
  end
  config.vm.define "os-master" do |os_master|
	  os_master.vm.hostname = "os-master"
	  os_master.vm.box = "centos/7"
	  os_master.vm.network "private_network", ip: "192.168.33.10"
		os_master.vm.provision "chef_zero" do |chef|
			chef.synced_folder_type = "rsync"
		  chef.cookbooks_path = "cookbooks"
		  chef.data_bags_path = "data_bags"
		  chef.nodes_path = "nodes"
		  chef.roles_path = "roles"
		  chef.add_role "openshift_master"
	  end
	  os_master.vm.provider :libvirt do |libvirt|
		  libvirt.memory = 4096
		  libvirt.cpus = 4
		end
		os_master.vm.provider :virtualbox do |virtualbox|
		  virtualbox.memory = 4096
		  virtualbox.cpus = 4
	  end
  end

  config.vm.define "os-pod1" do |os_pod1|
	  os_pod1.vm.hostname = "os-pod1"
	  os_pod1.vm.box = "centos/7"
    os_pod1.vm.network "private_network", ip: "192.168.33.11"
	  os_pod1.vm.provision "chef_zero" do |chef|
		  chef.cookbooks_path = "cookbooks"
		  chef.data_bags_path = "data_bags"
		  chef.nodes_path = "nodes"
		  chef.roles_path = "roles"
		  chef.add_recipe "openshiftmaster"
	  end
  end
end

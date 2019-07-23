Vagrant.configure("2") do |config|
    config.vm.box = "pbarriscale/centos7-gui"
    config.vm.box_version = "1.0.0"
    config.vm.network "private_network", ip: "192.0.0.2"
    config.vm.provision "shell", path: "provision.sh"
	config.vm.provider :virtualbox do |v|
	    v.gui = true
        v.name = "mysql"
        v.memory = "8192" 
        v.cpus = 4
	end
end

Vagrant.configure("2") do |config|
    config.vm.box = "narethim/centos7-desktop"
    config.vm.box_version = "0.01"
    config.vm.network "private_network", ip: "192.0.0.2"
    config.vm.provision "shell", path: "openjdk11.sh"
	config.vm.provider :virtualbox do |v|
	    v.gui = true
        v.name = "centosOpenJDK11"
        v.memory = "4096" 
        v.cpus = 4
	end
end
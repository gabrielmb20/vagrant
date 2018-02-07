Vagrant.configure("2") do |config|

  config.vm.define "pruebas" do |pruebas|
    pruebas.vm.box = "ubuntu/xenial64"
    pruebas.vm.hostname = 'pruebas'
#    pruebas.vm.box_url = 'http://10.42.30.5/Vagrant/boxes/xenial64/virtualbox.box'

    pruebas.vm.network "private_network", ip: "10.20.30.41"

    pruebas.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--name", "pruebas"]
    end

    pruebas.vm.provision "shell", inline: "sudo apt-get install -y python" 

    pruebas.vm.provision "ansible" do |ansible|
      ansible.playbook = "instalacion-mariadb-server.yml"
      ansible.inventory_path = "inventory/hosts"
      ansible.limit = '10.20.30.41'
    end
    
  end

  config.vm.define "pruebas2" do |pruebas2|
    pruebas2.vm.box = "ubuntu/xenial64"
    pruebas2.vm.hostname = 'pruebas2'
#    pruebas.vm.box_url = 'http://10.42.30.5/Vagrant/boxes/xenial64/virtualbox.box'

    pruebas2.vm.network "private_network", ip: "10.20.30.42"

    pruebas2.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--name", "pruebas2"]
    end

    pruebas2.vm.provision "shell", inline: "sudo apt-get install -y python" 

    pruebas2.vm.provision "ansible" do |ansible|
      ansible.playbook = "instalacion-mariadb-server.yml"
      ansible.inventory_path = "inventory/hosts"
      ansible.limit = '10.20.30.42'
    end
    
  end
end

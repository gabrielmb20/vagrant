Vagrant.configure("2") do |config|
# -----------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------
# -----------------------------------
# PROXY #1
# -----------------------------------
  config.vm.define "proxy01" do |proxy01|
    proxy01.vm.box = "ubuntu/xenial64"
    proxy01.vm.hostname = 'proxy01'
    proxy01.vm.network "private_network", ip: "10.20.30.41"

    proxy01.vm.provision "shell", inline: "sudo apt-get update; sudo apt-get install -y python python-pip"
    config.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      SHELL
    end
    proxy01.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--cpus", 4]
      v.customize ["modifyvm", :id, "--name", "proxy01"]
    end
  end

# -----------------------------------
# PROXY #2
# -----------------------------------
  config.vm.define "proxy02" do |proxy02|
    proxy02.vm.box = "ubuntu/xenial64"
    proxy02.vm.hostname = 'proxy02'

    proxy02.vm.network "private_network", ip: "10.20.30.42"

    proxy02.vm.provision "shell", inline: "sudo apt-get update; sudo apt-get install -y python python-pip"
    config.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      SHELL
    end

    proxy02.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--cpus", 4]
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--name", "proxy02"]
    end
  end
# -----------------------------------
# JOOMLA #1
# -----------------------------------
  config.vm.define "joomla01" do |joomla01|
    joomla01.vm.box = "ubuntu/trusty64"
    joomla01.vm.hostname = 'joomla01'

    joomla01.vm.network "private_network", ip: "10.20.30.43"

    joomla01.vm.provision "shell", inline: "sudo apt-get update; sudo apt-get install -y python python-pip"
    config.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      SHELL
    end

    joomla01.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--cpus", 4]
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--name", "joomla01"]
    end
  end
# -----------------------------------
# JOOMLA #2
# -----------------------------------
  config.vm.define "joomla02" do |joomla02|
    joomla02.vm.box = "ubuntu/trusty64"
    joomla02.vm.hostname = 'joomla02'

    joomla02.vm.network "private_network", ip: "10.20.30.44"

    joomla02.vm.provision "shell", inline: "sudo apt-get update; sudo apt-get install -y python python-pip"
    config.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      SHELL
    end

    joomla02.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--cpus", 4]
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--name", "joomla02"]
    end
  end
# -----------------------------------
# MARIADB #1
# -----------------------------------
  config.vm.define "mariadb01" do |mariadb01|
    mariadb01.vm.box = "ubuntu/xenial64"
    mariadb01.vm.hostname = 'mariadb01'

    mariadb01.vm.network "private_network", ip: "10.20.30.45"

    mariadb01.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--cpus", 4]
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--name", "mariadb01"]
    end

    mariadb01.vm.provision "shell", inline: "sudo apt-get update; sudo apt-get install -y python python-pip"
    config.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      SHELL
    end

#    mariadb01.vm.provision "ansible" do |ansible|
#      ansible.playbook = "instalacion-mariadb-server.yml"
#      ansible.inventory_path = "inventory/hosts"
#      ansible.limit = '10.20.30.45'
#    end

  end
# -----------------------------------
# MARIADB #2
# -----------------------------------
  config.vm.define "mariadb02" do |mariadb02|
    mariadb02.vm.box = "ubuntu/xenial64"
    mariadb02.vm.hostname = 'mariadb02'

    mariadb02.vm.network "private_network", ip: "10.20.30.46"

    mariadb02.vm.provision "shell", inline: "sudo apt-get update; sudo apt-get install -y python python-pip"
    config.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      SHELL
    end

#    mariadb02.vm.provision "ansible" do |ansible|
#      ansible.playbook = "instalacion-mariadb-server.yml"
#      ansible.inventory_path = "inventory/hosts"
#      ansible.limit = '10.20.30.46'
#    end

    mariadb02.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--cpus", 4]
      v.customize ["modifyvm", :id, "--name", "mariadb02"]
    end
  end
#### -----------------------------------
#### APP #1
#### -----------------------------------
###  config.vm.define "app01" do |app01|
###    app01.vm.box = "ubuntu/trusty64"
###    app01.vm.hostname = 'app01'
###
###    app01.vm.network "private_network", ip: "10.20.30.47"
###
###    app01.vm.provision "shell", inline: "sudo apt-get update; sudo apt-get install -y python python-pip"
###
###    app01.vm.provider :virtualbox do |v|
###      v.customize ["modifyvm", :id, "--memory", 1024]
###      v.customize ["modifyvm", :id, "--name", "app01"]
###    end
###  end
#### -----------------------------------
#### APP #2
#### -----------------------------------
###  config.vm.define "app02" do |app02|
###    app02.vm.box = "ubuntu/trusty64"
###    app02.vm.hostname = 'app02'
###
###    app02.vm.network "private_network", ip: "10.20.30.48"
###
###    app02.vm.provision "shell", inline: "sudo apt-get update; sudo apt-get install -y python python-pip"
###
###    app02.vm.provider :virtualbox do |v|
###      v.customize ["modifyvm", :id, "--memory", 1024]
###      v.customize ["modifyvm", :id, "--name", "app02"]
###    end
###  end
###
# -----------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------
end

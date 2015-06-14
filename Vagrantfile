# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

nodes = {
  'sv' => [3,11]
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  nodes.each do |prefix, (count, ip_start)|
    count.times do |i|
      hostname = "%s%d" % [prefix, (i + 1)]
      config.vm.define "#{hostname}" do |conf|
        conf.vm.hostname = "#{hostname}.local"
        conf.vm.network :forwarded_port, guest: "15672", host: "#{5672 + 10000 * (i + 1)}"
        conf.vm.network :private_network, ip: "10.0.0.#{ip_start + i}"
        conf.vm.network :private_network, ip: "10.0.1.#{ip_start + i}"
        conf.vm.network :public_network,  ip: "0.0.0.0", bridge: "eno1"
        conf.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--memory", "4096",
                       "--nicpromisc4", "allow-all",
                       "--cpus", 2]
        end
      end
    end
  end

  config.vm.define "starter" do |conf|
    conf.vm.hostname = "starter.local"
    conf.vm.network :private_network, ip: "10.0.0.254"
    conf.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", "512" ]
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/site.yml"
  end
end

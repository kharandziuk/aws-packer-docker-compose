# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.define "server1" do |server1|
    server1.vm.hostname = "server1"
    server1.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
      # run a particular task with e.g. $ START_TASK="task name" vagrant provision
      ansible.start_at_task=ENV['START_TASK']
    end
  end

end

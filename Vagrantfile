Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "stanford-api-prod"
  
  # Network configuration
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 5433, host: 5433
  
  # VM resources
  config.vm.provider "virtualbox" do |vb|
    vb.name = "stanford-api-production"
    vb.memory = "2048"
    vb.cpus = 2
    vb.gui = true
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  
  # Increase boot timeout
  config.vm.boot_timeout = 600
  
  # Sync project files
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  
  # Provisioning script
  config.vm.provision "shell", path: "scripts/setup-production.sh"
  
  # Post-provision message
  config.vm.post_up_message = <<-MSG
    Stanford Students API Production Environment Ready!
    
    Access the API at: http://localhost:8080
    SSH into VM: vagrant ssh
    
    Inside VM, run:
      cd /vagrant
      make run-api
  MSG
end
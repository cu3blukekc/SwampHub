# -*- mode: ruby -*-
# vi: set ft=ruby :

# List plugins dependencies
plugins_dependencies = %w( vagrant-gatling-rsync vagrant-docker-compose vagrant-vbguest vagrant-docker-login )
plugin_status = false
plugins_dependencies.each do |plugin_name|
  unless Vagrant.has_plugin? plugin_name
    system("vagrant plugin install #{plugin_name}")
    plugin_status = true
    puts " #{plugin_name}  Dependencies installed"
  end
end

# Restart Vagrant if any new plugin installed
if plugin_status === true
  exec "vagrant #{ARGV.join' '}"
else
  puts "All Plugin Dependencies already installed"
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--memory", "8192"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  portSSH = 2225

  portMetamodel = 8081
  portManifest = 8082
  portBackEnd = 3030
  portFrontEnd = 8080
  portPlantUML = 9000

  docker_compose_version ="2.9.0"

  config.vm.hostname = "vagrant-swamphub"
  config.vm.network "private_network", ip: "192.168.44.10"

  #config.vm.network :forwarded_port, guest: 22, host: 2200, id: 'ssh'
  #config.ssh.port = portSSH


  config.vm.network(:forwarded_port, guest: 22, host: portSSH,id: 'ssh')

  config.vm.network(:forwarded_port, guest: portFrontEnd, host: portFrontEnd)
  config.vm.network(:forwarded_port, guest: portMetamodel, host: portMetamodel)
  config.vm.network(:forwarded_port, guest: portManifest, host: portManifest)
  config.vm.network(:forwarded_port, guest: portBackEnd, host: portBackEnd)
  config.vm.network(:forwarded_port, guest: portPlantUML, host: portPlantUML)




  config.vm.provision :shell, inline: "apt-get update"
  config.vm.provision :shell, inline: "export DOCKER_BUILDKIT=1" # or configure in daemon.json
  config.vm.provision :shell, inline: "export COMPOSE_DOCKER_CLI_BUILD=1"

   ## Avoid plugin conflicts
   if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end


  ##install docker
  #config.vm.provision :shell, inline: "sudo curl -fsSL https://get.docker.com -o get-docker.sh"
  #config.vm.provision :shell, inline: "sudo DRY_RUN=1 sh ./get-docker.sh"

  ##install docker-compose
  #config.vm.provision :shell, inline: "sudo curl -SL \"https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose"
  #config.vm.provision :shell, inline: "sudo chmod +x /usr/local/bin/docker-compose"


  ##install docker-compose
  #config.vm.provision :shell, path: "scripts/install.sh"

  ##build docker-compose
  #config.vm.provision :shell, path: "scripts/build.sh"
  ##run docker-compose
  #config.vm.provision :shell, path: "scripts/run.sh" , run: 'always'

  #config.vm.provision :docker
  #config.vm.provision :docker_compose,
    # compose_version: "1.29.2"
  #  compose_version: "2.90.0"


#     env: { "PORT" => "#{portWeb}"},
#     #,"COMPOSE_DOCKER_CLI_BUILD"=>1,"DOCKER_BUILDKIT"=>1},
#     #executable_symlink_path:"COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 #{executable_symlink_path }",
#     #options:{"COMPOSE_DOCKER_CLI_BUILD"=>1, "DOCKER_BUILDKIT"=>1},
#     yml: "/vagrant/docker-compose.yaml",
#     rebuild: false,
#     project_name: "archdochub",
#     run: "always"
end
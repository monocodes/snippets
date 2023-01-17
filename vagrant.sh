### VAGRANT INSTALL -----------------------------
brew install vagrant


### VAGRANT INSTALL MACOS M1 ###
# create an account on vmware
https://customerconnect.vmware.com/

# download & install VMWare Fusion Tech Preview
https://customerconnect.vmware.com/downloads/get-download?downloadGroup=FUS-PUBTP-2021H1

# create symlink
ln -s /Applications/VMWare\ Fusion\ Tech\ Preview.app /Applications/VMWare\ Fusion.app

# install vmware provider
brew install vagrant-vmware-utility
# or
https://releases.hashicorp.com/vagrant-vmware-utility/1.0.21/vagrant-vmware-utility_1.0.21_x86_64.dmg

# install plugin
vagrant plugin install vagrant-vmware-desktop

# reboot and go to the dir where the Vagrantfile is
vagrant up



### VAGRANT COMMANDS ----------------------------

### VAGRANT STATUS ###
# view vagrant vms
vagrant global-status

# view status of vm in current dir
vagrant status


### VAGRANT UP ###
# download the box from Vagrantfile
#and start up the VM with the chosen hypervisor
vagrant up

# start or reload existing vm with provisioning
vagrant up --provision
vagrant reload --provision

# start the specific vm
vagrant up id


### VAGRANT HALT ###
# gracefully stop the vm
vagrant halt


### VAGRANT HALT ###
# fully delete the vm (may leave VM in hypervisor)
vagrant destroy



### VAGRANT PATHS -------------------------------
# Sync Directory in Vagrant
#dir of the vm on you host is sinking with the same dir in VM
#cd to the vagrant dir in vm
cd /vagrant/
ls

### VAGRANTFILE EXAMPLES ------------------------

### MACOS M1, VMWARE FUSION ---------------------

# Fedora Server 35 arm64 FR
# h-fedsrv35-ud-01
  Vagrant.configure("2") do |config| 
    config.vm.box = "thtom/Fedora-35-Server-arm64-FR"
    config.vm.box_version = "1"
    
    # network
    config.vm.network "private_network", ip: "192.168.56.21"
    # config.vm.network "public_network"
    
    # synced folders
    #config.vm.synced_folder "../data", "/vagrant_data"
    
    # vm settings
    config.vm.provider "vmware_desktop" do |vmware|
      vmware.gui = true
      vmware.allowlist_verified = true
      # vmware.memory = "3096"
      # vmware.cpus = 2
    
    # bash provision script
    config.vm.provision "shell", inline: <<-SHELL
    echo "exclude=kernel*" >> /etc/dnf/dnf.conf
    dnf update -y
    dnf install langpacks-en -y
    localectl set-locale LANG=en_US.UTF-8
    localectl set-keymap us
    dnf autoremove -y
    reboot now
    SHELL
    end
  end


# Fedora Desktop 35 arm64
# h-fed35-ud-01
  Vagrant.configure("2") do |config| 
    config.vm.box = "jacobw/fedora35-arm64" 
    config.vm.network "private_network", ip: "192.168.56.12"
    config.vm.provider "vmware_desktop" do |vmware|
      vmware.gui = true
      vmware.allowlist_verified = true
    
    # bash provision script
    config.vm.provision "shell", inline: <<-SHELL
    echo "exclude=kernel*" >> /etc/dnf/dnf.conf
    dnf update -y
    dnf autoremove -y
    reboot now
    SHELL
    end
  end




# Ubuntu Server 20.04 arm64
# h-ubsrv20-ud-01
  Vagrant.configure("2") do |config| 
    config.vm.box = "bytesguy/ubuntu-server-20.04-arm64"
    config.vm.box_version = "1.0.0"
    config.vm.network "private_network", ip: "192.168.56.22"
    config.vm.provider "vmware_desktop" do |vmware|
      vmware.gui = true
      vmware.allowlist_verified = true
    
    # bash provisioning
    config.vm.provision "shell", inline: <<-SHELL
      apt update
      apt-mark hold linux-image-generic linux-headers-generic
      apt upgrade -y
      apt autoremove -y
      reboot now
    SHELL
    end
  end



# Ubuntu Server 20.04 arm64
# h-ubsrv20-ud-02
  Vagrant.configure("2") do |config| 
    config.vm.box = "spox/ubuntu-arm" 
    config.vm.box_version = "1.0.0"
    config.vm.network "private_network", ip: "192.168.56.11"
    config.vm.provider "vmware_desktop" do |vmware|
      vmware.gui = true
      vmware.allowlist_verified = true
  
    # bash provisioning
    config.vm.provision "shell", inline: <<-SHELL
      apt update
      apt-mark hold linux-image-generic linux-headers-generic
      apt upgrade -y
      apt autoremove -y
      reboot now
    SHELL
    end
  end



### VAGRANTFILE COMMANDS ###
# Fedora Server 35 arm64 FR
# h-fedsrv35-ud-01  
  Vagrant.configure("2") do |config|
    config.vm.box = "thtom/Fedora-35-Server-arm64-FR"
    config.vm.box_version = "1"

    ### network ###
    # configure new private network
    config.vm.network "private_network", ip: "192.168.56.21"
    # get ip from the same network as host
    config.vm.network "public_network" 

    #### synced folders ###
    # sync folder from host to VM
    config.vm.synced_folder "../data", "/vagrant_data"
    config.vm.provider "vmware_desktop" do |vmware|
      
      # vm settings
      vmware.gui = true
      vmware.allowlist_verified = true
      # memory setting
      vmware.memory = "3096"
      # cpu setting
      vmware.cpus = 2
    
    # bash provision script
    config.vm.provision "shell", inline: <<-SHELL
    dnf install wget unzip httpd
    mkdir /opt/devopsdir
    free -h
    uptime
    SHELL
    end
  end


### Default Vagrantfile examples ###


# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # https://vagrantcloud.com/ubuntu
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "private_network", type: "dhcp"

  # Forward ports
  config.vm.network "forwarded_port", guest: 8080, host: 8080 # web server
  config.vm.network "forwarded_port", guest: 5432, host: 5432 # Postgres

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end

  # If true, then any SSH connections made will enable agent forwarding.
  config.ssh.forward_agent = true

  # Share additional folders to the guest VM.
  config.vm.synced_folder "data", "/data"

  # Bash provision script
  config.vm.provision "shell", path: "provision/setup.sh"

  # Upload user's ssh key into box so it can be used for downloading stuff from stash
  ssh_key_path = "~/.ssh/"
  config.vm.provision "shell", inline: "mkdir -p /home/vagrant/.ssh"
  config.vm.provision "file", source: "#{ ssh_key_path + 'id_rsa' }", destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision "file", source: "#{ ssh_key_path + 'id_rsa.pub' }", destination: "/home/vagrant/.ssh/id_rsa.pub"

end



# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # See box list
  #   http://www.vagrantbox.es/
  config.vm.box = "centos65"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network :private_network, ip: "192.168.58.111"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    #   vb.gui = true

    # Enable creating symlinks between guest and host
    vb.customize [
      # see https://github.com/mitchellh/vagrant/issues/713#issuecomment-17296765
      # 1) Added these lines to my config :
      #
      # 2) run this command in an admin command prompt on windows :
      #    >> fsutil behavior set SymlinkEvaluation L2L:1 R2R:1 L2R:1 R2L:1
      #    see http://technet.microsoft.com/ja-jp/library/cc785435%28v=ws.10%29.aspx
      # 3) REBOOT HOST MACHINE
      # 4) 'vagrant up' from an admin command prompt
      "setextradata", :id,
      "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant-root", "1"
    ]

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize [
      'modifyvm', :id,
      '--natdnshostresolver1', 'on',
      '--memory', '512',
      '--cpus', '2'
    ]
  end

  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file centos65.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }
  #
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision "chef_solo" do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
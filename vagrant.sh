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
# show vagrant vms
vagrant global-status

# show status of vm in current dir
vagrant status


### VAGRANT INIT ###
# init vagrant in current dir and create template-based Vagrantfile for that box
vagrant init box-name


### VAGRANT UP ###
# download the box from Vagrantfile
#and start up the VM with the chosen hypervisor
vagrant up

# start or reload existing vm with provisioning
vagrant up --provision
vagrant reload --provision

# start the specific vm
vagrant up id


### VAGRANT SSH ###
# login current vm (vm in dir)
vagrant ssh

# login to specific vm
vagrant ssh vm-name


### VAGRANT HALT ###
# gracefully stop current vm (vm in dir)
vagrant halt

# gracefully stop specific vm
vagrant halt vm-name


### VAGRANT HALT ###
# fully delete the vm (may leave VM in hypervisor)
vagrant destroy



### VAGRANT PATHS -------------------------------
# Sync Directory in Vagrant
#dir of the vm on you host is sinking with the same dir in VM
#cd to the vagrant dir in vm
cd /vagrant/
ls
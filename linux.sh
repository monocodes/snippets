### DEB, APT, DEBIAN, UBUNTU --------------------
### APT -----------------------------------------
# install something without promting
sudo apt install -y package-name



### RPM, YUM, RED HAT, CENTOS -------------------
### YUM -----------------------------------------
# install something without promting
sudo yum install -y pckage-name



# CHMOD -----------------------------------------
# make file executable
sudo chmod +x ./name

# NETWORKING ------------------------------------
# how to see IP
ip a
ip r
# restarting network on Ubuntu 22
sudo systemctl restart systemd-networkd

# hostnamectl
# check hostname
hostnamectl

# change hostname
sudo hostnamectl set-hostname your_name



### BASIC COMMANDS ------------------------------
# get help for the command
command-name --help

# which user now
whoami

# view current path
pwd

# view version of the OS
cat /etc/os-release

# switch to root user
sudo -i

# logout with current user
exit

# make a directory
mkdir directory-name

# make a file
touch filename

# make multiple files
touch filename{1..10}.txt

# delete multiple files with the same name
rm -rf filename{1..10}.txt

# copy file
cp filename directory-name

# copy directory
cp -r directory-name directory-name

# move with mv
mv filename directory-name

# rename with mv
mv filename another-filename
mv directory-name another-directory-name

# move everything with mv
# example
mv *.txt directory-name

# view uptime
uptime

# view free ram
free -m

# delete file
rm filename

# delete directory
rm -r directory-name

# force delete everything in current directory
rm -rf *



# MONITORING ------------------------------------
# top for specified process
top -b | grep java



# ANOTHER UBUNTU/LINUX COMMANDS -----------------
# clear - command to clear terminal
clear



# SOFTWARE --------------------------------------
# check curl
curl parrot.live



# NEEDRESTART OR DAEMONS USING OUTDATED LIBRARIES
# what needs to be restarted using machine-friendly view
sudo needrestart -b

# what needs to be restarted using human-friendly view
sudo needrestart -u NeedRestart::UI::stdio -r l

# restart services with needrestart, reboot if doesn't help
sudo needrestart -u NeedRestart::UI::stdio -r a



# SSH-KEYGEN
# full guide - https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server-ru
# generate new pair of ssh keys
ssh-keygen

# public key default location
cat ~/.ssh/id_rsa.pub

# identification (closed key)
cat ~/.ssh/id_rsa

# copy public key to remote server
ssh-copy-id username@remote_host

# copy public key to remote server without ssh-copy-id
cat ~/.ssh/id_rsa.pub | ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"


# disable password authentication on remote server
sudo nano /etc/ssh/sshd_config
PasswordAuthentication no
sudo service ssh restart
# CentOS/Fedora/RadHat
sudo service sshd restart

# list all local private and public ssh keys
ls -l ~/.ssh/
ls -l ~/.ssh/id_*

# change the passphrase for default SSH private key
ssh-keygen -p

# change the passpharase for particular private key
ssh-keygen -p -f ~ssh/private_key_name
# or
ssh-keygen -f private_key_name -p

# remove a passphrase from private key
ssh-keygen -f ~.ssh/private_key_name -p
# or
ssh-keygen -f ~/.ssh/private_key_name -p -N ""
# for default private key
ssh-keygen -p -N ""
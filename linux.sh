### PATHS ---------------------------------------
# users info
/etc/passwd

# groups info
/etc/group

# logs
/var/log

# starting/stopping/reloading configs of the services
/etc/systemd/system/multi-user.target.wants



### GRUB ----------------------------------------

# to force boot with specific kernel

### UBUNTU ###
# edit grub config
vim /etc/default/grub

# in that file edit this line, in menu count starts with 0
GRUB_DEFAULT="1>2"

# update grub config
update-grub


### FEDORA ###
# you don't need to change anything in grub config, just use the command
grub2-set-default number
grub2-set-default 1


# check the boot
reboot now

# if something goes wrong, go to the hypervisor and press ESC when booting
ESC
# or hold shift for older systems
Shift



### USERS & GROUPS ------------------------------
# which user you are now
whoami

# view current logged in user
who

# view current path
pwd

# view info about user
id username

# add user
useradd username
adduser username # for ubuntu

# add group
groupadd group-name

# add user to the supplementary group without changing primary group
usermod -aG group-name username

# add user to the supplementary group without changing primary group
vim /etc/group

# change your user password
passwd

# change user password
passwd username

# switch to root user
sudo -i

# switch to any user
su - username

# delete the user
userdel username

# delete the user with home dir
userdel -r username

# delete group
groupdel group-name

# view last users logged in into the system
last

# view all opened files by user
lsof -u username


### SYSTEMCTL -----------------------------------
# manage services

# service status
systemctl status service-name

# check service active or not
systemctl is-active service-name

# check service in autorun or not
systemctl is-enabled service-name

# service start
systemctl start service-name

# service restart
systemctl restart service-name

# reload config of the service without restarting
systemctl reload service-name

# service stop
systemctl stop service-name

# add service to autorun
systemctl enable service-name


### PROCESSES, TOP, PS AUX ----------------------
# view all processes
top
htop

# view all processes and exit
ps aux

# view all processes with displaying parent processes
ps -ef

# find specific process PID and kill it
# kill the parent process
ps -ef | grep -i process-name | grep -v 'grep'
kill PID

# forcefully kill the process but without the child processes
kill -9 PID

# forcefully kill all child processes with filtering
# ps -ef - list processes
# grep -v 'grep' - excludes processes with name grep
# awk '{print $2}' - list only 2nd column of the output
# xargs kill -9 - kills every process
ps -ef | grep -i process-name | grep -v 'grep' | awk '{print $2}' | xargs kill -9


### SUDOERS -------------------------------------
# for security reasons insted of using vanilla
#/etc/sudoers file use /etc/sudoers.d dir and generate there sudoers settings
vim /etc/sudoers.d/vagrant
vagrant ALL=(ALL) NOPASSWD: ALL

# to add group to sudoers file use %
vim /etc/sudoers.d/devops
%devops ALL=(ALL) NOPASSWD: ALL

# view all custom /etc/sudoers.d files
cat /etc/sudoers.d *

# edit /etc/sudoers
visudo

# no password for sudoers user
## Allow root to run any commands anywhere 
root    ALL=(ALL)       ALL
ansible ALL=(ALL)       NOPASSWD: ALL


### CHOWN ---------------------------------------
# change user:group owners of the dir or file
chown username:group-name /path/to/filename

# -R = recursively, -v = verbose
chown -R username:group-name /path/to/filename


### CHMOD ---------------------------------------
# change permissions for the file or dirs
# -R = recursively


### Changing Permissions - Symbolic Method ###
# u +- = user +- permission
# g +- = group +- permission
# o +- = others +- permission
# r = read
# w = write
# x = execute

# examples
chmod o-x /path/to/filename
chmod g+w /path/to/filename

# just make file executable for user, group, others
sudo chmod +x ./name


### Changing Permissions - Numeric Method ###
# Uses a three-digit mode number
# first digit = owner's permissions
# second digit = group's permissions
# third digit = others' permissions
# Permissions are calculated by adding:
# 4 (for read)
# 2 (for write)
# 1 (for execute)

# examples
chmod 640 /path/to/filename
# 4 + 2 = read + write for user
# 4 = read for group
# 0 = none for others
chmod 770 /path/to/filename
# 4 + 2 + 1 = read + write + execute for user
# 7 + 2 + 1 = read + write + execute for group
# 0 = none for others



### NETWORKING ----------------------------------
# view the network adapters
ip a
ip r
ip address

# deprecated starting Ubuntu 20
ifconfig 

# restarting network on Ubuntu 22
sudo systemctl restart systemd-networkd

# change hostname
sudo vim /etc/hostname
sudo hostname hostname


### hostnamectl ###
# check hostname
hostnamectl

# change hostname
sudo hostnamectl set-hostname your_name

# traceroute
traceroute address-name
traceroute mirrors.fedoraproject.org



### BASIC COMMANDS ------------------------------

### & && || ; ###
# Run A and then B, regardless of success of A
A ; B

# Run B if A succeeded
A && B 

# Run B if A failed
A || B

# Run A in background.
A &


# get help for the command
command-name --help

# what is it
file filename
file directory-name

# view version of the OS
cat /etc/os-release

# logout with current user
exit

# make a directory
mkdir directory-name

# make directory forcefully
mkdir -p directory/path
mkdir -p /opt/dev/ops/devops/test

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

### TREE ###
# view dirs in tree format
tree /path/to/dir
tree /var/log


### FIND ###
# find anything
find /path/to -name filename*


### LOCATE ###
# command like find but more easy to use
sudo dnf install mlocate

# locate usage
# everytime before search use updatedb command
updatedb
locate host


### ECHO ###
# print command
# print text to the file
echo "text" > /tmp/sysinfo.txt


### EXPORT ###
# export changes environmental variables temporarily
# change default text editor
export EDITOR=vim


### GREP ###
# find word in file
grep word filename

# find word in file and ignore case
grep -i word filename

# find word in the file in all files and dirs
grep -iR word *
# example
grep -R SELINUX /etc/*

# -v - grep process excluding grep process
ps -ef | grep -i process-name | grep -v 'grep'


### GREP EXAMPLES ###
ls /etc/host* | grep host
ls host | grep host

tail -150 /var/log/messages-20230108 | grep -i vagrant

free -h | grep -i mem

# -v - grep process excluding grep process
ps -ef | grep -i httpd | grep -v 'grep'


### CUT, AWK ###
# view needed part of file with cut
cut -d delimiter -f field-number /path/to/filename
# example
cut -d: -f1,7 /etc/passwd

# view needed part of file with awk
awk -F'delimiter' '{print $field-number$field-number}' /path/tofilename
# example
awk -F':' '{print $1$7}' /etc/passwd


### SED ###
# replace text in files g - globally (more than one time in line)
# without -i to view what will be changed
sed 's/word-to-replace/word-that-replace/g' filename
sed -i 's/word-to-replace/word-that-replace/g' filename
sed -i 's/word-to-replace/word-that-replace/g' *.cfg
sed -i 's/word-to-replace/word-that-replace/g' *
# example
sed 's/coronavirus/covid19/g' samplefile.txt
sed -i 's/coronavirus/covid19/g' samplefile.txt


# view uptime
uptime

# view free ram
# -h for human-readable output
free -mh

# delete file
rm filename

# delete directory
rm -r directory-name

# force delete everything in current directory
rm -rf *

# view file
cat filename

# view first 10 lines of the file or any number of lines
head filename
head -20 filename

# view last 10 lines of the file
tail filename
tail -20 filename

# view continuously last 10 lines of the file
tail -f filename

# read file
less filename

# clear terminal
clear


### WC ###
# wc - count anything
# count how many lines in file
wc -l /path/to/filename
wc -l /etc/passwd

# count how many dirs and files
ls | wc -l


### OUTPUT REDIRECTION > ------------------------
# to output command result to a file use >
command-name > /path/to/filename
uptime > /tmp/sysinfo.txt
ls > /tmp/sysinfo.txt
echo "text" > /tmp/sysinfo.txt

# to output command result to a file and did not overwrite its contents and 
#just append
command-name >> /path/to/filename
uptime >> /tmp/sysinfo.txt

# output to nowhere
command-name > /dev/null
yum install vim -y > /dev/null

# remove everything in file
cat /dev/null > /path/to/filename
cat /dev/null > /tmp/sysinfo.txt

# redirect error output
command-name 2> /path/to/filename
freeee 2>> /tmp/error.log

# to redirect standard output 1> (default) or error output 2> use &>
command-name &> /path/to/filename
free -m &>> /tmp/error.log
freddfefe -m &>> /tmp/error.log


### INPUT REDIRECTION < ###
command-name < /path/to/filename
wc -l < /etc/passwd



### LN, LINKS -----------------------------------
# create softlink
ln -s /path/to/filename /path/to/filename
ln -s /opt/dev/ops/devops/test/commands.txt cmds



### PARTITIONING, HDDs --------------------------
# view partitioning
df -h



# MONITORING ------------------------------------
# top for specified process
top -b | grep java



# SOFTWARE --------------------------------------
### RPM, DNF, YUM, RED HAT, CENTOS --------------

### DNF, YUM, RPM -------------------------------

# repos location
/etc/yum.repos.d/

### there might be a problem with metalink in Armenia ###
vim /etc/yum.repos.d/fedora.repo

# comment metalink and enter baseurl
#metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
baseurl=https://fedora-archive.ip-connect.info/fedora/linux/releases/35/Everything/x86_64/os/

# or 
https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-35&arch=x86_64
https://admin.fedoraproject.org/mirrormanager/



### DNF, YUM ###
# almost all these commands applied to yum

# search package
dnf search package-name

# install something without prompts
dnf install -y package-name

# reinstall package
dnf reinstall package-name

# remove package and its config files not touched by user
dnf remove package-name

# update all packages
dnf update

# update specific pckage
dnf update package-name

# list all avalaible Group Packages
dnf grouplist

# install all the packages in a group
dnf groupinstall group-name

# view enabled dnf repos
dnf repolist

# clean dnf cache
dnf clean all

# additional package repository that commonly used software
dnf install epel-release

# view history of dnf
dnf history

# view info of package
dnf info package-name

# exclude package in dnf from updating
# example for kernel updates
echo "exclude=kernel*" >> /etc/dnf/dnf.conf

# exclude package in yum from updating
# deprecated in already in Fedora 35
echo "exclude=kernel*" >> /etc/yum.conf


### RPM ###
# install downloaded package
# -i - install, -v - verbose, -h - human readable
rmp -ivh package-name
# examples
rpm -ivh mozilla-mail-1.7.5-17.i586.rpm
rpm -ivh --test mozilla-mail-1.7.5-17.i586.rpm

# view all installed rpms
rpm -qa
# examples
rpm -qa
rpm -qa | less

# view latest installed rpms
rpm -qa --last

# upgrade installed package
rpm -Uvh package-name
# examples
rpm -Uvh mozilla-mail-1.7.6-12.i586.rpm
rpm -Uvh --test mozilla-mail-1.7.6-12.i586.rpm

# remove installed package
rpm -ev package-name
# example
rpm -ev mozilla-mail

# remove installed package without checking its dependencies
rpm -ev --nodeps
# example
rpm -ev --nodeps mozilla-mail

# view info about installed package
rpm -qi package-name
# example
rpm -qi mozilla-mail

# find out what package a file belongs to i.e. find what package owns the file
rpm -qf /path/to/dir
# examples
rpm -qf /etc/passwd

# view list of configuration file(s) for a package
rpm -qc package-name
# example
rpm -qc httpd

# view list of configuration files for a command
rpm -qcf /path/to/filename
# example
rpm -qcf /usr/X11R6/bin/xeyes

# view what dependencies a rpm file has
rpm -qpR filename.rpm
rpm -qR package-name
# examples
rpm -qpR mediawiki-1.4rc1-4.i586.rpm
rpm -qR bash


### DEB, APT, DEBIAN, UBUNTU --------------------
### APT -----------------------------------------

# apt repos
cat /etc/apt/sources.list

# before installing any package update repos list
apt update

# update al packages
apt upgrade

# update specific package
apt upgrade package-name

# search package from avalaible repos
apt search package-name

# install package without prompts
apt install package-name -y

# reinstall package
apt reinstall package-name

# remove package
apt remove package-name

# remove package and all its configs and data
apt purge package-name

# list all avalaible Group Packages
apt grouplist

# install all the packages in a group
apt groupinstall group-name

# view enabled apt repos
apt repolist

# clean apt cache
apt clean all

# view apt history
apt history

# view info of the package
apt show package-name


### APT-MARK ------------------------------------
# hold specific packages from upgrading
# useful to not update the kernel packages
apt-mark hold package-name

# example for ubuntu m1 vm
apt-mark hold linux-modules-5.4.0-137-generic linux-headers-5.4.0-137 linux-headers-5.4.0-137-generic linux-headers-generic linux-image-unsigned-5.4.0-137-generic linux-modules-5.4.0-137-generic



### DPKG ----------------------------------------
# install downloaded package with dpkg
dpkg -i filename

# view all installed packages
dpkg -l

# search for specific installed package
dpkg -l | grep -i package-name

# remove package
dpkg -r package-name


### TAR, ZIP, ARCHIVES --------------------------

### TAR ###
# tar to create archives
# -c - create
# -z - compress
# -v - verbose
# -f - file
tar -czvf archive-name.tar.gz /path/to/dir

# extract archive
# -x - extract
tar -xzvf filename

# extract archive to some dir
tar -xzvf filename -C /path/to/dir


### ZIP ###
# zip to create archives
# -r - recursively
zip -r filename.zip /path/to/dir

# unzip for unarchive
# -d to point to dir 
unzip filename.zip -d /path/to/dir

### CURL, WGET ----------------------------------
# curl and wget to download something
# you can use curl to download something
curl https://link -o filename

# example
curl https://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/aarch64/os/Packages/t/tree-2.1.0-1.fc38.aarch64.rpm -o tree-2.1.0-1.fc38.aarch64.rpm

# check curl
curl parrot.live

# download file with wget
wget filelink


# NEEDRESTART OR DAEMONS USING OUTDATED LIBRARIES
# what needs to be restarted using machine-friendly view
sudo needrestart -b

# what needs to be restarted using human-friendly view
sudo needrestart -u NeedRestart::UI::stdio -r l

# restart services with needrestart, reboot if doesn't help
sudo needrestart -u NeedRestart::UI::stdio -r a


### LOCALECTL -----------------------------------
# view used locale
localectl

# view installed locales
localectl list-locales

# search for langpack
dnf search langpacks- | grep -i en
dnf install langpacks-en

# set locale
localectl set-locale LANG=en_US.UTF-8

# view specific locale keymaps
localectl list-keymaps | grep -i us

# set keymap locale
localectl set-keymap us


### SSH-KEYGEN ----------------------------------
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
# CentOS/Fedora/RedHat
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
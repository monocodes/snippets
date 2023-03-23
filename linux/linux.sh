
*************************************************
# LOCALECTL
*************************************************



-------------------------------------------------
### GRUB
-------------------------------------------------
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



-------------------------------------------------
### USERS & GROUPS
-------------------------------------------------
# which user you are now
whoami

# show current logged in user
who

# show current path
pwd

# show info about user
id username

# add user
adduser username # for ubuntu, also adds home dir
useradd username # for centos, doesn't add home dir

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

# switch to any user, change user
su - username

# delete user
userdel username

# delete user with home dir
userdel -r username

# delete group
groupdel group-name

# show last users logged in into the system
last

# show all opened files by user
lsof -u username

# show all opened files in particular dir
lsof /path/to/dir
lsof /var/www/html/images


# ubuntu 22 LTS default groups after install with user loco
adm:x:4:syslog,loco
cdrom:x:24:loco
sudo:x:27:loco
dip:x:30:loco
plugdev:x:46:loco
lxd:x:110:loco
loco:x:1000:
docker:x:118:loco



-------------------------------------------------
# change user and group ID for user and files
-------------------------------------------------
# Foo’s old UID: 1005
# Foo’s new UID: 2005
# Our sample group name: foo
# Foo’s old GID: 2000
# Foo’s new GID: 3000

# To assign a new UID to user called foo, enter:
usermod -u 2005 foo

# To assign a new GID to group called foo, enter:
groupmod -g 3000 foo

# Please note that all files which are located in the user’s home directory will have the file UID changed automatically as soon as you type above two command. However, files outside user’s home directory need to be changed manually. To manually change files with old GID and UID respectively, enter:

# WARNING! The following examples may change ownership of unwanted files on your Linux computer if not executed with care. The nixCraft or author is not responsible for data loss.

find / -group 2000 -exec chgrp -h foo {} \;
find / -user 1005 -exec chown -h foo {} \;

# The -exec command executes chgrp command or chmod command command on each file. The -h option passed to the chgrp/chmod command affect each symbolic link instead of any referenced file. Use the following command to verify the same:

ls -l /home/foo/
id -u foo
id -g foo
# search for 'foo' in the passswd file #
grep foo /etc/passwd # search for 'foo' in the group file #
grep foo /etc/group # use the find command to locate files owned by ' foo'#
find / -user foo -ls
find / -group sales -ls



-------------------------------------------------
### SYSTEMCTL
-------------------------------------------------
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

# remove service from autorun
systemctl disable service-name



-------------------------------------------------
### PROCESSES, TOP, PS AUX
-------------------------------------------------
# all processes are in:
cd /var/run/

# to see the PID
cat /var/run/process-name/process-name.pid
cat /var/run/httpd/httpd.pid


# show all processes
top
htop

# show all processes and exit
ps aux

# show all processes with displaying parent processes
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


# list all logged in users
who

# logout user and kill all its processes
pkill -KILL -u username



-------------------------------------------------
### SUDOERS
-------------------------------------------------
# for security reasons insted of using vanilla
#/etc/sudoers file use /etc/sudoers.d dir and generate there sudoers settings
vim /etc/sudoers.d/mono
mono ALL=(ALL) NOPASSWD: ALL
# use sudo without pass

# to add group to sudoers file use %
vim /etc/sudoers.d/devops
%devops ALL=(ALL) NOPASSWD: ALL

# show all custom /etc/sudoers.d files
cat /etc/sudoers.d *

# edit /etc/sudoers
visudo

# or you can use /etc/sudoers file
root ALL=(ALL) ALL
ansible ALL=(ALL) NOPASSWD: ALL



-------------------------------------------------
### CHOWN
-------------------------------------------------
# change user:group owners of the dir or file
chown username:group-name /path/to/filename

# -R = recursively, -v = verbose
chown -R username:group-name /path/to/filename


-------------------------------------------------
### CHMOD
-------------------------------------------------
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



*************************************************
### NETWORKING
*************************************************
### Private IP Ranges ###

# Class A
10.0.0.0 - 10.255.255.255

# Class B
172.16.0.0 - 172.31.255.255

# Class C
192.168.0.0 - 192.168.255.255



# show the network adapters
ip a
ip r
ip address

# deprecated starting Ubuntu 20
ifconfig 

# restarting network on Ubuntu 22
sudo systemctl restart systemd-networkd



-------------------------------------------------
# hostname, hostnamectl
-------------------------------------------------
# show hostname
hostnamectl hostname

# change hostname 
# Ubuntu
sudo hostnamectl hostname web03

# CentOS
sudo hostnamectl set-hostname web03


# NOTE about hostname command
hostname your-hostname
# changes only before reboot, non-persistent



-------------------------------------------------
# OPEN PORTS
-------------------------------------------------
### nmap ###
# show open ports of localhost
nmap localhost

# show open ports of local server
nmap db01


### netstat ###
# show all open TCP ports
netstat -antp
netstat -antp | grep apache2

# search process id, and use it to know on what port app is running, if you
#don't see process name on netstat
ps -ef | grep apache2 # copy PID
netstat -antp | grep PID


### ss ###
# show all open TCP ports
ss -tunlp
ss -tunlp | grep 80


### telnet ###
# use telnet to check the connection via any port
telnet ip-address port
telnet 192.168.40.12 3306
telnet 192.168.40.12 22
telnet db01.vprofile.in 3306
telnet vprofile-mysql-rds.cyg76sxmwbec.us-east-1.rds.amazonaws.com 3306

# to exit
Ctrl + ]
Ctrl + C
Enter
quit



-------------------------------------------------
# DNS LOOKUP, DNS QUARIES
-------------------------------------------------

### dig ###
# dns lookup
dig google.com

### nslookup (older version of dig) ###
nslookup google.com



-------------------------------------------------
# TRACEROUTE
-------------------------------------------------
### traceroute, tracert
# show path to the server and latency problems
traceroute address-name
traceroute mirrors.fedoraproject.org
traceroute google.com


### mtr ###
# traceroute + ping
# show path to the server and latency problems online (live)
mtr google.com



-------------------------------------------------
# GATEWAY LOOKUP
-------------------------------------------------
# show gateways 
route -n
route



-------------------------------------------------
# ARP
-------------------------------------------------
# show arp table
arp


-------------------------------------------------
# FIREWALLD
-------------------------------------------------

# Fedora firewalld fix if httpd doesn't work
systemctl stop firewalld
systecmctl enable firewalld
firewall-cmd --add-service=http --add-service=https --permanent


# firewalld open specific port, for example mysql (mariadb)
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload



-------------------------------------------------
### BASIC COMMANDS
-------------------------------------------------
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

# show version of the OS
cat /etc/os-release

# logout with current user
exit

# make a directory
mkdir directory-name

# make directory forcefully with all needed parents
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
cp -r /path/to/dir /path/to/another/dir

# copy all files and dirs
cp -r * /path/to/dir

# move with mv
mv filename /path/to/dir

# rename with mv
mv filename another-filename
mv directory-name another-directory-name

# move everything with mv
# example
mv *.txt directory-name

# move everything in dir to another dir
# mv path/to/dir/* path/to/another/dir
mv /tmp/img-backup/* /var/www/html/images/

### TREE ###
# show dirs in tree format
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



-------------------------------------------------
# EXPORT
-------------------------------------------------
# export changes environmental variables temporarily
# change default text editor
export EDITOR=vim

# to make it permanent for user add export
# command to ~/.bashrc or ~/.bash_profile
vim ~/.bashrc
export EDITOR=vim # add to the file

# to make it permanent for all users add export
# command to /etc/profile
vim /etc/profile
export EDITOR=vim # add to the file



-------------------------------------------------
# GREP
-------------------------------------------------
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
# show needed part of file with cut
cut -d delimiter -f field-number /path/to/filename
# example
cut -d: -f1,7 /etc/passwd

# show needed part of file with awk
awk -F'delimiter' '{print $field-number$field-number}' /path/tofilename
# example
awk -F':' '{print $1$7}' /etc/passwd


### SED ###
# replace text in files g - globally (more than one time in line)
# without -i to show what will be changed
sed 's/word-to-replace/word-that-replace/g' filename
sed -i 's/word-to-replace/word-that-replace/g' filename
sed -i 's/word-to-replace/word-that-replace/g' *.cfg
sed -i 's/word-to-replace/word-that-replace/g' *
# example
sed 's/coronavirus/covid19/g' samplefile.txt
sed -i 's/coronavirus/covid19/g' samplefile.txt


# show uptime
uptime

# show free ram
# -h for human-readable output
free -mh

# delete file
rm filename

# delete directory
rm -r directory-name

# force delete everything in current directory
rm -rf *

# show file
cat filename

# show first 10 lines of the file or any number of lines
head filename
head -20 filename

# show last 10 lines of the file or any number of lines
tail filename
tail -20 filename

# show continuously last 10 lines of the file
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


-------------------------------------------------
### OUTPUT REDIRECTION >
-------------------------------------------------
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


-------------------------------------------------
### INPUT REDIRECTION <
-------------------------------------------------
command-name < /path/to/filename
wc -l < /etc/passwd



-------------------------------------------------
### LN, LINKS
-------------------------------------------------
# create softlink
ln -s /path/to/filename /path/to/filename
ln -s /opt/dev/ops/devops/test/commands.txt cmds



-------------------------------------------------
### PARTITIONING, HDDs
-------------------------------------------------
# show partitioning
df -h



-------------------------------------------------
# MONITORING
-------------------------------------------------
# top for specified process
top -b | grep java


-------------------------------------------------
# SOFTWARE
-------------------------------------------------
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



-------------------------------------------------
# epel
-------------------------------------------------
# on rpm-based linux firstly install epel-release repo to unlock many packages
# Amazon Linux 2
sudo amazon-linux-extras install epel -y

# RHEL 8
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y

# RHEL 7
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# CentOS 8
sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
sudo dnf config-manager --set-enabled PowerTools

# CentOS 7
sudo yum -y install epel-release

# List repositories that are turned on
# To verify that the EPEL repository is turned on, run the repolist command:
sudo yum repolist



-------------------------------------------------
# dnf, yum
-------------------------------------------------
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

# show enabled dnf repos
dnf repolist

# clean dnf cache
dnf clean all

# additional package repository that commonly used software
dnf install epel-release

# show history of dnf
dnf history

# show info of package
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

# show all installed rpms
rpm -qa
# examples
rpm -qa
rpm -qa | less

# show latest installed rpms
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

# show info about installed package
rpm -qi package-name
# example
rpm -qi mozilla-mail

# find out what package a file belongs to i.e. find what package owns the file
rpm -qf /path/to/dir
# examples
rpm -qf /etc/passwd

# show list of configuration file(s) for a package
rpm -qc package-name
# example
rpm -qc httpd

# show list of configuration files for a command
rpm -qcf /path/to/filename
# example
rpm -qcf /usr/X11R6/bin/xeyes

# show what dependencies a rpm file has
rpm -qpR filename.rpm
rpm -qR package-name
# examples
rpm -qpR mediawiki-1.4rc1-4.i586.rpm
rpm -qR bash



-------------------------------------------------
### DEB, APT, DEBIAN, UBUNTU
-------------------------------------------------
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

# show enabled apt repos
apt repolist

# clean apt cache
apt clean all

# show apt history
apt history

# show info of the package
apt show package-name


-------------------------------------------------
### APT-MARK
-------------------------------------------------
# hold specific packages from upgrading
# useful to not update the kernel packages
apt-mark hold package-name

# example for ubuntu m1 vm
apt-mark hold linux-modules-5.4.0-137-generic linux-headers-5.4.0-137 linux-headers-5.4.0-137-generic linux-headers-generic linux-image-unsigned-5.4.0-137-generic linux-modules-5.4.0-137-generic



-------------------------------------------------
### DPKG
-------------------------------------------------
# install downloaded package with dpkg
dpkg -i filename

# show all installed packages
dpkg -l

# search for specific installed package
dpkg -l | grep -i package-name

# remove package
dpkg -r package-name


-------------------------------------------------
### TAR, ZIP, ARCHIVES
-------------------------------------------------
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

# unzip and overwrite, no question
unzip -o filename.zip /path/to/dir



-------------------------------------------------
# apache2, httpd
-------------------------------------------------
# default path for website for apache2, httpd
/var/www/html



-------------------------------------------------
# tomcat
-------------------------------------------------
# default path for website for tomcat
# ? = version
/var/lib/tomcat?/webapps/
/var/lib/tomcat8/webapps/



-------------------------------------------------
# mysql, mariadb-server
-------------------------------------------------
# default path of mysql
/var/lib/mysql

# install mysql on ubuntu
apt install mysql

# install mysql on centos
yum install mariadb-server

# connect to the mysql remote host
apt install mysql-client

# connect with mysql-client to remote host
mysql -h hostname -u username -ppassword
# example
mysql -h vprofile-mysql-rds.cyg76sxmwbec.us-east-1.rds.amazonaws.com -u admin -plicgiTGxfz8iu128mGHg



-------------------------------------------------
### CURL, WGET
-------------------------------------------------
# curl and wget to download something
# you can use curl to download something
curl https://link -o filename

# example
curl https://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/aarch64/os/Packages/t/tree-2.1.0-1.fc38.aarch64.rpm -o tree-2.1.0-1.fc38.aarch64.rpm

# check curl
curl parrot.live

# check working wevserver (httpd, apache2, nginx)
curl localhost

# download file with wget
wget filelink


# NEEDRESTART OR DAEMONS USING OUTDATED LIBRARIES
# what needs to be restarted using machine-friendly show
sudo needrestart -b

# what needs to be restarted using human-friendly show
sudo needrestart -u NeedRestart::UI::stdio -r l

# restart services with needrestart, reboot if doesn't help
sudo needrestart -u NeedRestart::UI::stdio -r a



-------------------------------------------------
### SSH-KEYGEN
-------------------------------------------------
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
ssh-keygen -f ~/.ssh/private_key_name -p
# or
ssh-keygen -f ~/.ssh/private_key_name -p -N ""
# for default private key
ssh-keygen -p -N ""


# connect to host with specific public key
ssh -i ~/.ssh/id_rsa_name username@computername.swarthmore.edu



-------------------------------------------------
# scp
-------------------------------------------------
# push file to another server
scp filename username@hostname:/absolute/path/to/dir
scp testfile.txt devops@web01:/tmp

# fetch file from another server
scp username@hostname:/absolute/path/to/filename
scp devops@web01:/home/devops/testfile.txt .

-------------------------------------------------
# bat
-------------------------------------------------
# print bat without line numbers
bat --style=plain,header filename
batcat --style=plain,header filename



-------------------------------------------------
# stress
-------------------------------------------------
# stress - utility to stress the hardware
# start stress on cpu with 4 processes for 300 seconds in background
nohup stress -c 4 -t 300 &

# small script to test monitoring alarms
# stress.sh
#!/bin/bash
sudo stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 360 && sleep  && stress -c 4 -t 460 && sleep 30 && stress -c 4 -t 360 && sleep 60

# run it in background
nohup ./stress.sh &




-------------------------------------------------
### INSTALLS
-------------------------------------------------



-------------------------------------------------
### NOTES
-------------------------------------------------
-------------------------------------------------
### BASH '', ""
-------------------------------------------------
# https://stackoverflow.com/questions/6697753/difference-between-single-and-double-quotes-in-bash

The accepted answer is great. I am making a table that helps in quick comprehension of the topic. The explanation involves a simple variable a as well as an indexed array arr.

If we set

a=apple      # a simple variable
arr=(apple)  # an indexed array with a single element
and then echo the expression in the second column, we would get the result / behavior shown in the third column. The fourth column explains the behavior.

#	Expression	Result	Comments
1	"$a"	apple	variables are expanded inside ""
2	'$a'	$a	variables are not expanded inside ''
3	"'$a'"	'apple'	'' has no special meaning inside ""
4	'"$a"'	"$a"	"" is treated literally inside ''
5	'\''	invalid	can not escape a ' within ''; use "'" or $'\'' (ANSI-C quoting)
6	"red$arocks"	red	$arocks does not expand $a; use ${a}rocks to preserve $a
7	"redapple$"	redapple$	$ followed by no variable name evaluates to $
8	'\"'	\"	\ has no special meaning inside ''
9	"\'"	\'	\' is interpreted inside "" but has no significance for '
10	"\""	"	\" is interpreted inside ""
11	"*"	*	glob does not work inside "" or ''
12	"\t\n"	\t\n	\t and \n have no special meaning inside "" or ''; use ANSI-C quoting
13	"`echo hi`"	hi	`` and $() are evaluated inside "" (backquotes are retained in actual output)
14	'`echo hi`'	`echo hi`	`` and $() are not evaluated inside '' (backquotes are retained in actual output)
15	'${arr[0]}'	${arr[0]}	array access not possible inside ''
16	"${arr[0]}"	apple	array access works inside ""
17	$'$a\''	$a'	single quotes can be escaped inside ANSI-C quoting
18	"$'\t'"	$'\t'	ANSI-C quoting is not interpreted inside ""
19	'!cmd'	!cmd	history expansion character '!' is ignored inside ''
20	"!cmd"	cmd args	expands to the most recent command matching "cmd"
21	$'!cmd'	!cmd	history expansion character '!' is ignored inside ANSI-C quotes
See also:

ANSI-C quoting with $'' - GNU Bash Manual - https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html
Locale translation with $"" - GNU Bash Manual - https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html#Locale-Translation
A three-point formula for quotes - https://stackoverflow.com/a/42104627/6862601





-------------------------------------------------
### SED '', ""
-------------------------------------------------

# https://unix.stackexchange.com/questions/542454/escaping-single-quote-in-sed-replace-string

You don't need to escape in sed, where ' has no special significance. You need to escape it in bash.

$ sed -e "s/'/singlequote/g" <<<"'"
singlequote
You can see here that the double quotes protect the single quote from bash, and sed does fine with it. Here's what happens when you switch the single quotes.

$ sed -e 's/'/singlequote/g' <<<"'"
>
The strange thing about ' in bourne like shells (all?) is that it functions less like " and more like a flag to disable other character interpretation until another ' is seen. If you enclose it in double quotes it won't have it's special significance. Observe:

$ echo 'isn'"'"'t this hard?'
isn't this hard?
You can also escape it with a backslash as shown in the other answer. But you have to leave the single quoted block before that will work. So while this seems like it would work:

echo '\''
it does not; the first ' disables the meaning of the \ character.

I suggest you take a different approach. sed expressions can be specified as command line arguments - but at the expense of having to escape from the shell. It's not bad to escape a short and simple sed expression, but yours is pretty long and has a lot of special characters.

I would put your sed command in a file, and invoke sed with the -f argument to specify the command file instead of specifying it at the command line. http://man7.org/linux/man-pages/man1/sed.1.html or man sed will go into detail. This way the sed commands aren't part of what the shell sees (it only sees the filename) and the shell escaping conundrum disappears.

$ cat t.sed
s/'*/singlequote(s)/g

$ sed -f t.sed <<<"' ' '''"
singlequote(s) singlequote(s) singlequote(s)
"""




-------------------------------------------------
### GUIDES
-------------------------------------------------
-------------------------------------------------
### SED GUIDE
-------------------------------------------------
# https://www.cyberciti.biz/faq/how-to-use-sed-to-find-and-replace-text-in-files-in-linux-unix-shell/

How to use sed to find and replace text in files in Linux / Unix shell
Author: Vivek Gite Last updated: January 7, 2023 36 comments
See all GNU/Linux related FAQIam a new Linux user. I wanted to find the text called “foo” and replaced to “bar” in the file named “hosts.txt.” How do I use the sed command to find and replace text/string on Linux or UNIX-like system?

The sed stands for stream editor. It reads the given file, modifying the input as specified by a list of sed commands. By default, the input is written to the screen, but you can force to update file.
ADVERTISEMENT
Find and replace text within a file using sed command
The procedure to change the text in files under Linux/Unix using sed:

Use Stream EDitor (sed) as follows:
sed -i 's/old-text/new-text/g' input.txt
The s is the substitute command of sed for find and replace
It tells sed to find all occurrences of ‘old-text’ and replace with ‘new-text’ in a file named input.txt
Verify that file has been updated:
more input.txt
Let us see syntax and usage in details.
Tutorial details
Difficulty level	Easy
Root privileges	No
Requirements	Linux or Unix terminal
Category	Linux shell scripting
Prerequisites	sed utility
OS compatibility	BSD • Linux • macOS • Unix • WSL
Est. reading time	4 minutes
Syntax: sed find and replace text
The syntax is:
sed 's/word1/word2/g' input.file
## *BSD/macOS sed syntax ##
sed 's/word1/word2/g' input.file > output.file
## GNU/Linux sed syntax ##
sed -i 's/word1/word2/g' input.file
sed -i -e 's/word1/word2/g' -e 's/xx/yy/g' input.file
## Use + separator instead of / ##
sed -i 's+regex+new-text+g' file.txt

The above replace all occurrences of characters in word1 in the pattern space with the corresponding characters from word2.

Examples that use sed to find and replace
Let us create a text file called hello.txt as follows:
cat hello.txt

Sample file:

The is a test file created by nixCrft for demo purpose.
foo is good.
Foo is nice.
I love FOO.
I am going to use s/ for substitute the found expression foo with bar as follows:
sed 's/foo/bar/g' hello.txt

Sample outputs:

The is a test file created by nixCrft for demo purpose.
bar is good.
Foo is nice.
I love FOO.
sed find and replace examples for unix and linux
To update file pass the -i option when using GNU/sed version:
sed -i 's/foo/bar/g' hello.txt
cat hello.txt

The g/ means global replace i.e. find all occurrences of foo and replace with bar using sed. If you removed the /g only first occurrence is changed. For instance:
sed -i 's/foo/bar/' hello.txt

The / act as delimiter characters. To match all cases of foo (foo, FOO, Foo, FoO) add I (capitalized I) option as follows:
sed -i 's/foo/bar/gI' hello.txt
cat hello.txt

Sample outputs:

The is a test file created by nixCrft for demo purpose.
bar is good.
bar is nice.
I love bar.
A note about *BSD and macOS sed version
Please note that the BSD implementation of sed (FreeBSD/OpenBSD/NetBSD/MacOS and co) does NOT support case-insensitive matching including file updates with the help of -i option. Hence, you need to install gnu sed. Run the following command on Apple macOS (first set up home brew on macOS):
brew install gnu-sed
######################################
### now use gsed command as follows ##
######################################
gsed -i 's/foo/bar/gI' hello.txt
#########################################
### make a backup and then update file ##
#########################################
gsed -i'.BAK' 's/foo/bar/gI' hello.txt
cat hello.txt

sed command problems
Consider the following text file:
cat input.txt
http:// is outdate.
Consider using https:// for all your needs.

Find word ‘http://’ and replace with ‘https://www.cyberciti.biz’:
sed 's/http:///https://www.cyberciti.biz/g' input.txt

You will get an error that read as follows:

sed: 1: "s/http:///https://www.c ...": bad flag in substitute command: '/'
Our syntax is correct but the / delimiter character is also part of word1 and word2 in above example. Sed command allows you to change the delimiter / to something else. So I am going to use +:
sed 's+http://+https://www.cyberciti.biz+g' input.txt

Sample outputs:

https://www.cyberciti.biz is outdate.
Consider using https:// for all your needs.
How to use sed to match word and perform find and replace
In this example only find word ‘love’ and replace it with ‘sick’ if line content a specific string such as FOO:
sed -i -e '/FOO/s/love/sick/' input.txt

Use cat command to verify new changes:
cat input.txt

Recap and conclusion – Using sed to find and replace text in given files
The general syntax is as follows:
## find word1 and replace with word2 using sed ##
sed -i 's/word1/word2/g' input
## you can change the delimiter to keep syntax simple ##
sed -i 's+word1+word2+g' input
sed -i 's_word1_word2_g' input
## you can add I option to GNU sed to case insensitive search ##
sed -i 's/word1/word2/gI' input
sed -i 's_word1_word2_gI' input

See BSD (used on macOS too) sed or GNU sed man page by typing the following man command/info command or help command:
man sed
# gnu sed options #
sed --help
info sed
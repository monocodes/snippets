### DEB, APT, DEBIAN, UBUNTU --------------------
### APT -----------------------------------------
# install something without promting
sudo apt install -y package-name



### RPM, YUM, RED HAT, CENTOS -------------------
### YUM -----------------------------------------
# install something without promting
sudo yum install -y pckage-name



### PATHS ---------------------------------------
# users info
/etc/passwd

# groups info
/etc/group

# logs
/var/log



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
# how to see IP
ip a
ip r
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



### BASIC COMMANDS ------------------------------
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


### GREP ###
# find word in file
grep word filename

# find word in file and ignore case
grep -i word filename

# find word in the file in all files and dirs
grep -iR word *
# example
grep -R SELINUX /etc/*


### GREP EXAMPLES ###
ls /etc/host* | grep host
ls host | grep host

tail -150 /var/log/messages-20230108 | grep -i vagrant

free -h | grep -i mem


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
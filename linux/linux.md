---
title: linux
categories:
  - software
  - guides
  - notes
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# linux

- [linux](#linux)
  - [paths](#paths)
  - [bash wildcards](#bash-wildcards)
  - [linux commands](#linux-commands)
    - [basic commands and system packages](#basic-commands-and-system-packages)
      - [`& && || ; \`](#----)
      - [`--help`](#--help)
      - [sysinfo](#sysinfo)
      - [`mkdir`, `touch`, `rm`, `cp`, `mv`, `tree`, `find`, `echo`, `ln`](#mkdir-touch-rm-cp-mv-tree-find-echo-ln)
      - [locate](#locate)
      - [export](#export)
      - [needrestart](#needrestart)
      - [text processing](#text-processing)
        - [cat, head, tail, less](#cat-head-tail-less)
        - [bat](#bat)
        - [grep](#grep)
        - [cut, awk](#cut-awk)
        - [sed](#sed)
        - [wc](#wc)
      - [tar, zip, archives](#tar-zip-archives)
        - [tar](#tar)
        - [zip](#zip)
      - [input/output redirection](#inputoutput-redirection)
        - [output redirection](#output-redirection)
        - [input redirection](#input-redirection)
      - [time, date](#time-date)
      - [locale](#locale)
      - [systemctl](#systemctl)
      - [processes, top, ps](#processes-top-ps)
      - [users \& groups](#users--groups)
        - [change user and group ID for user and files](#change-user-and-group-id-for-user-and-files)
        - [sudoers](#sudoers)
        - [chown](#chown)
        - [chmod](#chmod)
    - [partitioning, mounting, fdisk, gparted](#partitioning-mounting-fdisk-gparted)
      - [grub](#grub)
      - [gparted](#gparted)
      - [df](#df)
      - [fdisk](#fdisk)
      - [mkfs, formatting](#mkfs-formatting)
      - [mount, umount, mounting](#mount-umount-mounting)
    - [network](#network)
      - [network config Ubuntu 22](#network-config-ubuntu-22)
      - [network config CentOS 7](#network-config-centos-7)
      - [hostname, hostnamectl](#hostname-hostnamectl)
      - [ssh](#ssh)
        - [ssh-keygen](#ssh-keygen)
        - [scp](#scp)
      - [https, curl, wget](#https-curl-wget)
      - [open ports](#open-ports)
        - [nmap](#nmap)
        - [netstat](#netstat)
        - [ss](#ss)
        - [telnet](#telnet)
      - [dns lookup, dns quaries](#dns-lookup-dns-quaries)
        - [traceroute, tracert, mtr](#traceroute-tracert-mtr)
        - [gateway lookup](#gateway-lookup)
        - [arp](#arp)
    - [deb-based distros (Debian, Ubuntu, etc)](#deb-based-distros-debian-ubuntu-etc)
      - [apt](#apt)
        - [apt autoremove](#apt-autoremove)
        - [apt-mark](#apt-mark)
      - [dpkg](#dpkg)
    - [rpm-based distros (RHEL, CentOS, Amazon Linux, etc)](#rpm-based-distros-rhel-centos-amazon-linux-etc)
      - [dnf, yum](#dnf-yum)
        - [paths yum](#paths-yum)
      - [epel](#epel)
      - [rpm](#rpm)
      - [firewalld](#firewalld)
  - [third-party packages](#third-party-packages)
    - [jdk](#jdk)
    - [apache2, httpd](#apache2-httpd)
    - [tomcat](#tomcat)
    - [mysql, mariadb](#mysql-mariadb)
  - [network notes](#network-notes)
    - [private IP ranges](#private-ip-ranges)
    - [ifconfig.io](#ifconfigio)
  - [notes](#notes)
    - [DevOps tools usage](#devops-tools-usage)

## paths

users info

```bash
/etc/passwd
```

groups info

```bash
/etc/group
```

logs

```bash
/var/log
```

starting/stopping/reloading configs of the services

```bash
/etc/systemd/system/multi-user.target.wants
```

default webserver data, webhosting

```bash
/var/www/html
```

all processes path

```bash
/var/run/
```

show `PID`

```bash
cat /var/run/process-name/process-name.pid

# example
cat /var/run/httpd/httpd.pid
```

network config, more info here -> [network](#network)

```bash
# Ubuntu 22
/etc/netplan/00-installer-config.yaml

# CentOS 7
/etc/sysconfig/network-scripts/ifcfg-*
```

---

## bash wildcards

search any directory (`**`) any file with `.war` extension (`*.war`)

```bash
**/*.war
```

---

## linux commands

### basic commands and system packages

#### `& && || ; \`

>`A` and `B` are any commands

Run A and then B, regardless of success of A

```bash
A ; B
```

Run B if A succeeded

```bash
A && B
```

Run B if A failed

```bash
A || B
```

Run A in background

```bash
A &
```

Multiline command with `\`

```bash
# docker install example
sudo apt remove docker.io -y ; \
	sudo apt remove containerd -y ; \
  sudo apt remove runc -y ; \
  sudo apt remove docker -y ; \
  sudo apt remove docker-engine -y
```

---

#### `--help`

get help for the command

```bash
command-name --help
```

what is it

```bash
file filename
file directory-name
```

show version of the OS

```bash
cat /etc/os-release
```

logout with current user

```bash
exit
```

---

#### sysinfo

show free ram

```bash
free -mh
```

show uptime

```bash
uptime
```

clear terminal

```bash
clear
```

---

#### `mkdir`, `touch`, `rm`, `cp`, `mv`, `tree`, `find`, `echo`, `ln`

make a directory

```bash
mkdir directory-name
```

make directory forcefully with all needed parents

```bash
mkdir -p directory/path

# example
mkdir -p /opt/dev/ops/devops/test
```

make a file

```bash
touch filename
```

make multiple files with numbers

```bash
touch filename{1..10}.txt
```

delete multiple files with the same name + numbers

```bash
rm -rf filename{1..10}.txt
```

delete file

```bash
rm filename
```

delete dir

```bash
rm -r directory-name
```

force delete everything in current directory

```bash
rm -rf *
```

copy file

```bash
cp filename directory-name
```

copy directory

```bash
cp -r /path/to/dir /path/to/another/dir
```

copy all files and dirs

```bash
cp -r * /path/to/dir
```

move with mv

```bash
mv filename /path/to/dir
```

rename with mv

```bash
mv filename another-filename
mv directory-name another-directory-name
```

move everything with mv

```bash
mv *.txt directory-name
```

move everything in dir to another dir

```bash
mv path/to/dir/* path/to/another/dir

# example
mv /tmp/img-backup/* /var/www/html/images/
```

show dirs in tree format

```bash
tree /path/to/dir

# example
tree /var/log
```

`echo` - print command

print text to the file

```bash
# example

echo "text" > /tmp/sysinfo.txt
```

find anything

```bash
find /path/to -name filename*
```

create softlink

```bash
ln -s /path/to/filename /path/to/filename

# example
ln -s /opt/dev/ops/devops/test/commands.txt cmds
```

#### locate

> `locate` - command like `find` but more easy to use with indexed search

install locate in rpm-based distrib

```bash
sudo dnf install mlocate
```

>every time before search use `updatedb` command

```bash
updatedb
locate host
```

#### export

export environmental variables temporarily  
change default text editor

```bash
export EDITOR=vim
```

to make it permanent for user add export command to `~/.bashrc` or `~/.bash_profile`

```bash
vim ~/.bashrc

export EDITOR=vim
```

to make it permanent for all users add export command to `/etc/profile`

```bash
vim /etc/profile

export EDITOR=vim
```

---

#### needrestart

what needs to be restarted using machine-friendly show

```bash
sudo needrestart -b
```

what needs to be restarted using human-friendly show

```bash
sudo needrestart -u NeedRestart::UI::stdio -r l
```

restart services with needrestart, reboot if doesn't help

```bash
sudo needrestart -u NeedRestart::UI::stdio -r a
```

---

#### text processing

##### cat, head, tail, less

show file contents

```bash
cat filename
```

show first 10 lines of the file or any number of lines

```bash
head filename

head -20 filename
```

show last 10 lines of the file or any number of lines

```bash
tail filename

tail -20 filename
```

show continuously last 10 lines of the file

```bash
tail -f filename
```

show file contents with pager `less`

```bash
less filename
```

##### bat

> `batcat` - `bat` after **Ubuntu 18**
>
> To install `bat` on CentOS use  [multi-os-base-provision.sh](../bash-snippets/provisioning-bash-snippets/multi-os-base-provision.sh)
>
> To install on Ubuntu before 20:
>
>   ```bash
>   wget https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-musl_0.23.0_amd64.deb \
>   	sudo dpkg -i bat-musl_0.22.1_amd64.deb
>   ```
>
>

print `bat` without line numbers and header

```bash
bat -p filename
```

print `bat` without line numbers but with header

```bash
bat --style=plain,header filename
```

##### grep

find word in file

```bash
grep word filename
```

find word in file and ignore case

```bash
grep -i word filename
```

find word in the file in all files and dirs

```bash
grep -iR word *

# example
grep -R SELINUX /etc/*
```

`-v` - grep process excluding grep process

```bash
ps -ef | grep -i process-name | grep -v 'grep'
```

`grep` examples

```bash
ls /etc/host* | grep host

ls host | grep host

tail -150 /var/log/messages-20230108 | grep -i vagrant

free -h | grep -i mem
```

##### cut, awk

show needed part of file with cut

```bash
cut -d delimiter -f field-number /path/to/filename

# example
cut -d: -f1,7 /etc/passwd
```

show needed part of file with awk

```bash
awk -F'delimiter' '{print $field-number$field-number}' /path/tofilename

# example
awk -F':' '{print $1$7}' /etc/passwd
```

##### sed

replace text in files  
`g` - globally (more than one time in line)  
without `-i` to show what will be changed

```bash
sed 's/word-to-replace/word-that-replace/g' filename
sed -i 's/word-to-replace/word-that-replace/g' filename
sed -i 's/word-to-replace/word-that-replace/g' *.cfg
sed -i 's/word-to-replace/word-that-replace/g' *

# example
sed 's/coronavirus/covid19/g' samplefile.txt
sed -i 's/coronavirus/covid19/g' samplefile.txt
```

- `sed` command example for `/etc/apt/sources.list` to switch to location repos or main repos

  - switch to main repos

    - ```bash
                sudo sed -i 's|http://us.|http://|g' /etc/apt/sources.list
                # or
                sed -i 's/http:\/\/in./http:\/\//g' /etc/apt/sources.list
            ```

  - switch to Armenia repos

    - ```bash
                sudo sed -i 's|http://us.|http://am.|g' /etc/apt/sources.list
                # or
                sed -i 's/http:\/\/us./http:\/\/am./g' /etc/apt/sources.list
            ```

##### wc

`wc` - count anything

count how many lines in file

```bash
wc -l /path/to/filename

# example
wc -l /etc/passwd
```

count how many dirs and files

```bash
ls | wc -l
```

---

#### tar, zip, archives

##### tar

create archives

> - `-c` - create
> - `-z` - compress
> - `-v` - verbose
> - `-f` - file

```bash
tar -czvf archive-name.tar.gz /path/to/dir
```

extract archive  
`-x` - extract

```bash
tar -xzvf filename
```

extract archive to some dir

```bash
tar -xzvf filename -C /path/to/dir
```

---

##### zip

create archive  
`-r` - recursively

```bash
zip -r filename.zip /path/to/dir
```

unzip for unarchive  
`-d` - to point to dir

```bash
unzip filename.zip -d /path/to/dir
```

unzip and overwrite, non-interactive

```bash
unzip -o filename.zip /path/to/dir
```

---

#### input/output redirection

##### output redirection

`>` - output command result to a file

```bash
command-name > /path/to/filename

# examples
uptime > /tmp/sysinfo.txt
ls > /tmp/sysinfo.txt
echo "text" > /tmp/sysinfo.txt
```

output command result to a file and did not overwrite its contents and just append

```bash
command-name >> /path/to/filename

# exapmle
uptime >> /tmp/sysinfo.txt
```

output command result to nowhere

```bash
command-name > /dev/null

# example
yum install vim -y > /dev/null
```

remove everything in file with `cat`

```bash
cat /dev/null > /path/to/filename

# example
cat /dev/null > /tmp/sysinfo.txt
```

redirect error output

```bash
command-name 2> /path/to/filename

# example
freeee 2>> /tmp/error.log
```

to redirect standard output `1>` (default) **and** error output `2>` use `&>`

```bash
command-name &> /path/to/filename

# examples
free -m &>> /tmp/error.log
freddfefe -m &>> /tmp/error.log
```

##### input redirection

```bash
command-name < /path/to/filename

# example
wc -l < /etc/passwd
```

---

#### time, date

check timezone

```bash
date
# or
timedatectl
```

list avalaible timezone

```bash
timedatectl list-timezones

timedatectl list-timezones | grep Berlin
```

set new timezone

```bash
sudo timedatectl set-timezone timezone-name
```

---

#### locale

show used locale

```bash
localectl
```

show installed locales

```bash
localectl list-locales
```

search for langpack and install it

```bash
# for rpm-based distros
dnf search langpacks- | grep -i en

dnf install langpacks-en
```

set locale

```bash
localectl set-locale LANG=en_US.UTF-8
```

show specific locale keymaps

```bash
localectl list-maps | grep -i us
```

set keymap locale

```bash
localectl set-keymap us
```

> fix for us locale error
>
> ```bash
> setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
> ```

```bash
echo "LANG=en_US.utf-8" | sudo tee -a /etc/environment && \
echo "LC_ALL=en_US.utf-8" | sudo tee -a /etc/environment
```

---

#### systemctl

service status

```bash
systemctl status service-name
```

check service active or not

```bash
systemctl is-active service-name
```

check service in autorun or not

```bash
systemctl is-enabled service-name
```

start service

```bash
systemctl start service-name
```

restart service

```bash
systemctl restart service-name
```

reload config of the service without restarting

```bash
systemctl reload service-name
```

stop service

```bash
systemctl stop service-name
```

add service to autorun

```bash
systemctl enable service-name
```

remove service from autorun

```bash
systemctl disable service-name
```

---

#### processes, top, ps

all processes path

```bash
/var/run/
```

show process `PID`

```bash
cat /var/run/process-name/process-name.pid

# example
cat /var/run/httpd/httpd.pid
```

process managers, activity monitors

```bash
top
htop
```

top for specified process

```bash
top -b | grep java
```

show all processes and exit

```bash
ps aux
```

show all processes with displaying parent processes

```bash
ps -ef
```

show all processes sorted by memory usage with `Mb` not `%`

```bash
ps -eo size,pid,user,command --sort -size | \
  awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | \
  cut -d "" -f2 | cut -d "-" -f1
```

find specific process PID and kill it  
kill the parent process

```bash
ps -ef | grep -i process-name | grep -v 'grep'
kill PID
```

forcefully kill the process but without the child processes

```bash
kill -9 PID
```

forcefully kill all child processes with filtering  

- ```bash
    ps -ef | grep -i process-name | grep -v 'grep' | awk '{print $2}' | xargs kill -9
    ```

- >`ps -ef` - list processes  
    >`grep -v 'grep'` - excludes processes with name `grep`  
    >`awk '{print $2}'` - lists only 2nd column of the output  
    >`xargs kill -9` - kills every process

list all logged in users

```bash
who
```

logout user and kill all its processes

```bash
pkill -KILL -u username
```

---

#### users & groups

which user you are now

```bash
whoami
```

show all current logged in users with useful info including ip

```bash
who
```

show current path

```bash
pws
```

show info about any user

```bash
id username
```

add user

```bash
adduser username # for ubuntu, also adds home dir
useradd username # for centos, doesn't add home dir
```

add group

```bash
groupadd group-name
```

add user to the supplementary group without changing primary group

```bash
usermod -aG group-name username
# or
vim /etc/group
```

change current user password

```bash
passwd
```

change any user password

```bash
passwd username
```

switch to root user

```bash
sudo -i
```

switch to any user, change user

```bash
su - username
```

delete user

```bash
userdel username
```

delete user with home dir

```bash
userdel -r username
```

delete group

```bash
groupdel group-name
```

show last users logged in into the system

```bash
last
```

show all opened files by user

```bash
lsof -u username
```

show all opened files in particular dir

```bash
lsof /path/to/dir

# example
lsof /var/www/html/images
```

> ubuntu 22 LTS default groups after install with user `username`

```bash
adm:x:4:syslog,username
cdrom:x:24:username
sudo:x:27:username
dip:x:30:username
plugdev:x:46:username
lxd:x:110:username
username:x:1000:
docker:x:118:username
```

---

##### change user and group ID for user and files

Foo’s old `UID`: `1005`  
Foo’s new `UID`: `2005`  
Our sample group name: `foo`  
Foo’s old `GID`: `2000`  
Foo’s new `GID`: `3000`

To assign a new `UID` to user called `foo`, enter:

```bash
usermod -u 2005 foo
```

To assign a new `GID` to group called `foo`, enter:

```bash
groupmod -g 3000 foo
```

> Please note that all files which are located in the user’s home directory will have the file `UID` changed automatically as soon as you type above two command. However, files outside user’s home directory need to be changed manually. To manually change files with old `GID` and `UID` respectively, enter:
>
> **WARNING!** The following examples may change ownership of unwanted files on your Linux computer if not executed with care.

```bash
find / -group 2000 -exec chgrp -h foo {} \;
find / -user 1005 -exec chown -h foo {} \;
```

> The `-exec` command executes `chgrp` command or `chmod` command on each file. The `-h` option passed to the `chgrp`/`chmod` command affect each symbolic link instead of any referenced file. Use the following command to verify the same:

```bash
ls -l /home/foo/
id -u foo
id -g foo
```

search for `foo` in the passswd file

```bash
grep foo /etc/passwd
```

search for 'foo' in the group file

```bash
grep foo /etc/group
```

use the find command to locate files owned by `foo`

```bash
find / -user foo -ls
find / -group sales -ls # maybe -group foo here...
```

---

##### sudoers

>For security reasons instead of using vanilla `/etc/sudoers` file use `/etc/sudoers.d` dir and generate there sudoers settings, for example:
>
>Allow `sudo` without pass for user `username`

```bash
echo "username ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/username
```

to add group to sudoers file use `%`

```bash
echo "%group-name ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/group-name
```

show all `/etc/sudoers.d` files

```bash
cat /etc/sudoers.d/* # maybe working only under root
```

edit `/etc/sudoers` with default text editor

```bash
visudo
# or
vim /etc/sudoers
```

normal `sudoers` example

```bash
root ALL=(ALL) ALL
username ALL=(ALL) NOPASSWD: ALL
```

---

##### chown

change `user:group` owners of the dir or file

```bash
chown username:group-name /path/to/filename
```

`-R` - recursively, `-v` - verbose

```bash
chown -R username:group-name /path/to/filename
```

---

##### chmod

change permissions for the file or dirs  
`-R` - recursively

> Changing Permissions - **Symbolic Method**
>
> - `u` `+-` = user +- permission
> - `g` `+-` = group +- permission
> - `o` `+-` = others +- permission
> - `r` = read
> - `w` = write
> - `x` = execute

```bash
# examples

chmod o-x /path/to/filename
chmod g+w /path/to/filename
```

just make file executable for user, group, others

```bash
chmod +x ./name
```

> Changing Permissions - **Numeric Method**
>
> Uses a three-digit mode number
>
> - first digit = owner's permissions
> - second digit = group's permissions
> - third digit = others' permissions
> - Permissions are calculated by adding:
> - `4` - for read
> - `2` - for write
> - `1` - for execute

```bash
# examples

chmod 640 /path/to/filename
# 4 + 2 = read + write for user
# 4 = read for group
# 0 = none for others

chmod 770 /path/to/filename
# 4 + 2 + 1 = read + write + execute for user
# 7 + 2 + 1 = read + write + execute for group
# 0 = none for others
```

---

### partitioning, mounting, fdisk, gparted

#### grub

force boot with specific kernel

**Ubuntu**

1. edit grub config  

    ```bash
    vim /etc/default/grub
    ```

2. in that file edit this line, in menu count starts with 0  

    ```bash
    GRUB_DEFAULT="1>2"
    ```

3. update grub config  

    ```bash
    update-grub
    ```

**Fedora**

1. don't need to change anything in grub config, just use the command  

    ```bash
    grub2-set-default number
    
    # example
    grub2-set-default 1
    ```

2. check the boot  

    ```bash
    reboot now
    ```

3. if something goes wrong, go to the hypervisor and press `ESC` when booting or hold `Shift` for older systems

#### gparted

[How to resize a root partition in Ubuntu Linux GPT.md](guides/How to resize a root partition in Ubuntu Linux GPT.md)

#### df

show partitions

```bash
df -h
```

#### fdisk

show disks

```bash
fdisk -l
```

show disks with `ls` (including unmounted)

```bash
ls -lh /dev/ | grep disk
```

start disk partitioning

```bash
fdisk /dev/disk-name

# example
fdisk /dev/xvdf
```

> partitioning example

```bash
m # for help
n # add a new partition
p # primary
1 # partition number
Enter # first sector, can be specified
Enter # last sector, can be specified
# or specify last sector for example 3GB
+3G
w # write table to disk and exit
```

---

#### mkfs, formatting

show avalaible formatting utilities

```bash
mkfs # press Tab 2 times
```

do ext4 formatting

```bash
mkfs.ext4 /dev/disk-name

# example
mkfs.ext4 /dev/xvdf1
```

---

#### mount, umount, mounting

mount dir to partition temporarily

```bash
mount /dev/xvdf1 /var/www/html/images/
```

check mounting

```bash
df -h
```

unmount dir from partition

```bash
umount /var/www/html/images/
```

mount dir to partition permanently

```bash
vim /etc/fstab

# add this to file
/dev/xvdf1      /var/www/html/images    ext4    defaults        0 0
```

> `/etc/fstab` example

```bash
# Created by anaconda on Sun Nov 14 11:52:41 2021
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=44a6a613-4e21-478b-a909-ab653c9d39df /                       xfs     defaults        0 0
/dev/xvdf1      /var/www/html/images    ext4    defaults        0 0
/dev/xvdg1      /var/lib/mysql  ext4    defaults        0 0
```

> **DON'T FORGET** after that mount all mounts from `/etc/fstab`

```bash
mount -a
```

---

### network

show network adapters

```bash
ip a
ip r
ip address

# deprecated starting Ubuntu 20
ifconfig
```

restarting network

```bash
# Ubuntu 22
sudo systemctl restart systemd-networkd
```

---

#### network config Ubuntu 22

edit network config

```bash
sudo vim /etc/netplan/00-installer-config.yaml

# example config Ubuntu 22 with DHCP + static IP adapters
network:
  ethernets:
    ens3:
      dhcp4: true
    ens4:
      addresses:
      - 192.168.10.2/24
      nameservers:
        addresses: []
        search: []
  version: 2
```

apply new config

```bash
sudo netplan apply
# or debug
sudo netplan --debug apply
```

check network adapters

```bash
ip a
```

---

#### network config CentOS 7

choose adapter config to edit

```bash
sudo vim /etc/sysconfig/network-scripts/ifcfg-*
```

> examples

- ```bash
    sudo vim /etc/sysconfig/network-scripts/ifcfg-eth0
    
    # dhcp adapter created via installing CentOS
    TYPE=Ethernet
    PROXY_METHOD=none
    BROWSER_ONLY=no
    BOOTPROTO=dhcp
    DEFROUTE=yes
    IPV4_FAILURE_FATAL=no
    IPV6INIT=yes
    IPV6_AUTOCONF=yes
    IPV6_DEFROUTE=yes
    IPV6_FAILURE_FATAL=no
    IPV6_ADDR_GEN_MODE=stable-privacy
    NAME=eth0
    UUID=1714b04e-504c-4d49-be5a-b7574edf1d76
    DEVICE=eth0
    ONBOOT=yes
    IPV6_PRIVACY=no
    ```

- ```bash
    sudo vim /etc/sysconfig/network-scripts/ifcfg-eth1
    
    # static IP adapter created via installing CentOS
    TYPE=Ethernet
    PROXY_METHOD=none
    BROWSER_ONLY=no
    BOOTPROTO=none
    DEFROUTE=yes
    IPV4_FAILURE_FATAL=no
    IPV6INIT=yes
    IPV6_AUTOCONF=yes
    IPV6_DEFROUTE=yes
    IPV6_FAILURE_FATAL=no
    IPV6_ADDR_GEN_MODE=stable-privacy
    NAME=eth1
    UUID=9a59ad66-f598-4bdb-9720-4ad006b65605
    DEVICE=eth1
    ONBOOT=yes
    IPADDR=192.168.10.3
    PREFIX=24
    IPV6_PRIVACY=no
    ```

restart the network

```bash
sudo systemctl restart network
```

check network adapters

```bash
ip a
```

---

#### hostname, hostnamectl

show hostname

```bash
hostnamectl hostname
```

change hostname

```bash
# Ubuntu 22
sudo hostnamectl hostname web03

# CentOS 7
sudo hostnamectl set-hostname web03
```

> NOTE about `hostname` command
>
>   ```bash
>   hostname your-hostname
>   ```
>
> changes only before reboot, non-persistent

---

#### ssh

##### ssh-keygen

[ssh-keygen full guide on DO](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)

generate new pair of ssh keys

```bash
ssh-keygen
```

public key default location

```bash
cat ~/.ssh/id_rsa.pub
```

identification (private key or closed key)

```bash
cat ~/.ssh/id_rsa
```

copy public key to remote server for specific user

```bash
ssh-copy-id username@remote_host
```

copy public key to remote server without ssh-copy-id

```bash
cat ~/.ssh/id_rsa.pub | ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

disable password authentication on remote server

```bash
sudo nano /etc/ssh/sshd_config

# edit in file
PasswordAuthentication no

sudo service ssh restart
sudo service sshd restart # rpm-based distro
```

list all local private and public ssh keys

```bash
ls -l ~/.ssh/
ls -l ~/.ssh/id_*
```

change the passphrase for default SSH private key

```bash
ssh-keygen -p
```

change the passphrase for specific private key

```bash
ssh-keygen -p -f ~/.ssh/private_key_name
# or
ssh-keygen -f private_key_name -p
```

remove a passphrase from private key

```bash
ssh-keygen -f ~/.ssh/private_key_name -p
# or
ssh-keygen -f ~/.ssh/private_key_name -p -N ""
# for default private key
ssh-keygen -p -N ""
```

ssh to host with specific public key

```bash
ssh -i ~/.ssh/id_rsa_name username@hostname

# aws example
ssh -i ~/.ssh/key-name.pem -o ServerAliveInterval=200 username@ip
```

---

##### scp

push file to another server

```bash
scp filename username@hostname:/absolute/path/to/dir

# example
scp testfile.txt devops@web01:/tmp
```

fetch file from another server

```bash
scp username@hostname:/absolute/path/to/filename

# example
scp devops@web01:/home/devops/testfile.txt .
```

---

#### https, curl, wget

> `curl` and `wget` to download something

download anything with `curl`

```bash
curl https://link -o filename

# example
curl https://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/aarch64/os/Packages/t/tree-2.1.0-1.fc38.aarch64.rpm -o tree-2.1.0-1.fc38.aarch64.rpm
```

check curl

```bash
curl parrot.live
```

check working webserver (**httpd**, **apache2**, **nginx**)

```bash
curl localhost
```

download file with `wget`

```bash
wget filelink
```

---

#### open ports

##### nmap

show open ports of localhost

```bash
nmap localhost
```

show open ports of local server

```bash
nmap hostname

# example
nmap db01
```

##### netstat

show all open TCP ports

```bash
netstat -antp

# example
netstat -antp | grep apache2
```

search `PID`, and use it to know on what port app is running, if you don't see process name with `netstat`

```bash
ps -ef | grep apache2 # copy PID

netstat -antp | grep PID
```

##### ss

show all open TCP ports

```bash
ss -tunlp

# example
ss -tunlp | grep 80
```

##### telnet

use telnet to check the connection via any port

```bash
telnet ip-address port

# examples
telnet 192.168.40.12 3306
telnet 192.168.40.12 22
telnet db01.vprofile.in 3306
telnet vprofile-mysql-rds.cyg76sxmwbec.us-east-1.rds.amazonaws.com 3306
```

> to exit:
>
> - `Ctrl + ]`
> - `Ctrl + C`
> - `Enter`
> - type `quit` and hit `Enter`

---

#### dns lookup, dns quaries

`dig` - dns lookup

```bash
dig adress-name

# example
dig google.com
```

`nslookup` - dns lookup (older version of dig)

```bash
nslookup address-name

# example
nslookup google.com
```

##### traceroute, tracert, mtr

show path to the server and latency problems

```bash
traceroute address-name

# example
traceroute mirrors.fedoraproject.org
traceroute google.com
```

`mrt` - traceroute + ping

show path to the server and latency problems online (live)

```bash
mrt adress-name

# example
mtr google.com
```

##### gateway lookup

show gateways

```bash
route -n
route
```

##### arp

show arp table

```bash
arp
```

---

### deb-based distros (Debian, Ubuntu, etc)

#### apt

> `apt` - is the newer version of `apt-get`
>
> - `apt-get` - with scripts and auto provision
> - `apt` - with ssh connection to host

apt repos

```bash
cat /etc/apt/sources.list
```

before installing any package update repos list

```bash
apt update
```

update all packages

```bash
apt upgrade
```

update specific package

```bash
apt upgrade package-name
```

search package from avalaible repos

```bash
apt search package-name
```

install package without prompts

```bash
apt install package-name -y
```

reinstall package

```bash
apt reinstall package-name
```

remove package

```bash
apt remove package-name
```

remove package and all its configs and data

```bash
apt purge package-name
```

list all available *Group Packages*

```bash
apt grouplist
```

install all the packages in a group

```bash
apt groupinstall group-name
```

show enabled apt repos

```bash
apt repolist
```

clean apt cache

```bash
apt clean all
```

show apt history

```bash
apt history
```

show info of the package

```bash
apt show package-name
```

---

##### apt autoremove

delete all unused packages that was installed as dependencies

```bash
apt autoremove
```

delete all unused packages that was installed as dependencies with all config files and data

```bash
apt autoremove --purge
# 1st preffered or
apt autopurge
```

---

##### apt-mark

> Hold specific packages from upgrading. Useful to not update the kernel packages.

```bash
apt-mark hold package-name

# example for ubuntu m1 vm
apt-mark hold linux-modules-5.4.0-137-generic linux-headers-5.4.0-137 linux-headers-5.4.0-137-generic linux-headers-generic linux-image-unsigned-5.4.0-137-generic linux-modules-5.4.0-137-generic
```

---

#### dpkg

> `dpkg` - package manager for local packages

install downloaded package with dpkg

```bash
dpkg -i filename
```

show all installed packages

```bash
dpkg -l
```

search for specific installed package

```bash
dpkg -l | grep -i package-name
```

remove package

```bash
dpkg -r package-name
```

---

### rpm-based distros (RHEL, CentOS, Amazon Linux, etc)

#### dnf, yum

> Almost all these commands applied to `yum`.

---

##### paths yum

repos location

```bash
/etc/yum.repos.d/
```

if there are a problem with repos metalink, comment metalink and enter baseurl

```bash
vim /etc/yum.repos.d/fedora.repo

# comment metalink and enter baseurl

#metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
baseurl=https://fedora-archive.ip-connect.info/fedora/linux/releases/35/Everything/x86_64/os/
# or 
https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-35&arch=x86_64
https://admin.fedoraproject.org/mirrormanager/
```

---

search package

```bash
dnf search package-name
```

install something without prompts

```bash
dnf install -y package-name
```

reinstall package

```bash
dnf reinstall package-name
```

remove package and its config files not touched by user

```bash
dnf remove package-name
```

update all packages

```bash
dnf update
```

update specific package

```bash
dnf update package-name
```

list all avalaible *Group Packages*

```bash
dnf grouplist
```

install all the packages in a group

```bash
dnf groupinstall group-name
```

show enabled dnf repos

```bash
dnf repolist
```

clean dnf cache

```bash
dnf clean all
```

show history of dnf

```bash
dnf history
```

show info of package

```bash
dnf info package-name
```

exclude package in dnf from updating

```bash
# example for kernel updates
echo "exclude=kernel*" >> /etc/dnf/dnf.conf
```

exclude package in yum from updating

```bash
# deprecated in Fedora 35 and maybe previously versions
echo "exclude=kernel*" >> /etc/yum.conf
```

---

#### epel

**epel** - additional package repository with commonly used software

```bash
sudo dnf install epel-release
```

**Amazon Linux 2**

```bash
sudo amazon-linux-extras install epel -y
```

**RHEL 8**

```bash
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
```

**RHEL 7**

```bash
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

**CentOS 8**

```bash
sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
sudo dnf config-manager --set-enabled PowerTools
```

**CentOS 7**

```bash
sudo yum -y install epel-release
```

List repositories that are turned on  
To verify that the EPEL repository is turned on, run the repolist command:

```bash
sudo yum repolist
```

---

#### rpm

> `rpm` - package manager for local packages

install downloaded package  
`-i` - install, `-v` - verbose, `-h` - human readable

```bash
rmp -ivh package-name

# examples
rpm -ivh mozilla-mail-1.7.5-17.i586.rpm
rpm -ivh --test mozilla-mail-1.7.5-17.i586.rpm
```

show all installed rpms

```bash
rpm -qa

# examples
rpm -qa
rpm -qa | less
```

show latest installed rpms

```bash
rpm -qa --last
```

upgrade installed package

```bash
rpm -Uvh package-name

# examples
rpm -Uvh mozilla-mail-1.7.6-12.i586.rpm
rpm -Uvh --test mozilla-mail-1.7.6-12.i586.rpm
```

remove installed package

```bash
rpm -ev package-name

# example
rpm -ev mozilla-mail
```

remove installed package without checking its dependencies

```bash
rpm -ev --nodeps

# example
rpm -ev --nodeps mozilla-mail
```

show info about installed package

```bash
rpm -qi package-name

# example
rpm -qi mozilla-mail
```

find out what package owns the file

```bash
rpm -qf /path/to/dir

# examples
rpm -qf /etc/passwd
```

show list of configuration file(s) for a package

```bash
rpm -qc package-name

# example
rpm -qc httpd
```

show list of configuration files for a command

```bash
rpm -qcf /path/to/filename

# example
rpm -qcf /usr/X11R6/bin/xeyes
```

show what dependencies a rpm file has

```bash
rpm -qpR filename.rpm
rpm -qR package-name

# examples
rpm -qpR mediawiki-1.4rc1-4.i586.rpm
rpm -qR bash
```

---

#### firewalld

open 443, https

```bash
sudo firewall-cmd --add-service=http --add-service=https --permanent
sudo systemctl restart firewalld
```

firewalld open specific port, for example `mysql` (`mariadb`)

```bash
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
```

---

## third-party packages

package for  `ip -a` command - `iproute2`

```bash
apt update
apt install iproute2 -y
```

---

### jdk

Installation of different versions of `java` here [maven.md](maven.md)

check current main version

```bash
java -version
```

check installed jdk versions

```bash
ls /usr/lib/jvm
```

> example  
> here installed openjdk-8-jdk `java-1.8.0-openjdk-amd64` and openjdk-11-jdk `java-1.11.0-openjdk-amd64`

```bash
ls /usr/lib/jvm
java-1.11.0-openjdk-amd64  java-11-openjdk-amd64  openjdk-11
java-1.8.0-openjdk-amd64   java-8-openjdk-amd64
```

---

### apache2, httpd

default path for website for **apache2**, **httpd**

```bash
/var/www/html
```

---

### tomcat

default path for website for tomcat  
`?` - **tomcat** version

```bash
/var/lib/tomcat?/webapps/
/var/lib/tomcat8/webapps/
```

---

### mysql, mariadb

default path for **mysql** db

```bash
/var/lib/mysql
```

install mysql on **deb-based distro**

```bash
apt install mysql
```

install mysql on **rpm-based distro**

```bash
dnf install mariadb-server
```

install **mysql** client to connect to the mysql remote host

```bash
apt install mysql-client
```

connect with mysql-client to remote host

```bash
mysql -h hostname -u username -ppassword

# example
mysql -h vprofile-mysql-rds.cyg76sxmwbec.us-east-1.rds.amazonaws.com -u admin -plicgiTGxfz8iu128mGHg
```

---

## network notes

### private IP ranges

Class A - `10.0.0.0 - 10.255.255.255`

Class B - `172.16.0.0 - 172.31.255.255`

Class C - `192.168.0.0 - 192.168.255.255`

---

### ifconfig.io

<https://ifconfig.io/>

Great diagnostic website. You can diagnose just with `curl` command from anywhere. Great for testing proper VPN connection.

**Simple cURL API**!

| command                       | result                                                       |
| :---------------------------- | ------------------------------------------------------------ |
| curl ifconfig.io/ip           | 146.70.28.163                                                |
| curl ifconfig.io/ip           | 146.70.28.163                                                |
| curl ifconfig.io/host         | 146.70.28.163                                                |
| curl ifconfig.io/country_code | AT                                                           |
| curl ifconfig.io/ua           | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36 |
| curl ifconfig.io/port         | 65218                                                        |
| curl ifconfig.io/lang         | en-US,en;q=0.9,ru;q=0.8 $                                    |
| curl ifconfig.io/encoding     | gzip                                                         |
| curl ifconfig.io/mime         | text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7 |
| curl ifconfig.io/forwarded    | 146.70.28.163                                                |
| curl ifconfig.io/all          |                                                              |
| curl ifconfig.io/all.xml      |                                                              |
| curl ifconfig.io/all.json     |                                                              |
| curl ifconfig.io/all.js       |                                                              |

---

## notes

### DevOps tools usage

**Vagrant** for local

**Terraform** for Cloud

**Ansible** for Servers

**Cloudformation** for AWS

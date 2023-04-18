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
      - [`mkdir`, `touch`, `rm`, `cp`, `mv`, `ls`, `tree`, `find`, `echo`, `ln`, `du`](#mkdir-touch-rm-cp-mv-ls-tree-find-echo-ln-du)
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
          - [generate secured keys and use ssh-agent and `~/.ssh/config`](#generate-secured-keys-and-use-ssh-agent-and-sshconfig)
          - [ssh-keygen guide from DO](#ssh-keygen-guide-from-do)
        - [ssh-agent](#ssh-agent)
          - [SSH-agent forwarding, ProxyJump](#ssh-agent-forwarding-proxyjump)
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
    - [useful packages](#useful-packages)
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

```shell
/etc/passwd
```

groups info

```shell
/etc/group
```

logs

```shell
/var/log
```

starting/stopping/reloading configs of the services

```shell
/etc/systemd/system/multi-user.target.wants
```

default webserver data, webhosting

```shell
/var/www/html
```

all processes path

```shell
/var/run/
```

show `PID`

```shell
cat /var/run/process-name/process-name.pid

# example
cat /var/run/httpd/httpd.pid
```

network config, more info here -> [network](#network)

```shell
# Ubuntu 22
/etc/netplan/00-installer-config.yaml

# CentOS 7
/etc/sysconfig/network-scripts/ifcfg-*
```

banner file (info when login into the system)  
create it with any text

```shell
/etc/motd
```

---

## bash wildcards

search any directory (`**`) any file with `.war` extension (`*.war`)

```shell
**/*.war
```

---

## linux commands

### basic commands and system packages

#### `& && || ; \`

>`A` and `B` are any commands

Run A and then B, regardless of success of A

```shell
A ; B
```

Run B if A succeeded

```shell
A && B
```

Run B if A failed

```shell
A || B
```

Run A in background

```shell
A &
```

Multiline command with `\`

```shell
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

```shell
command-name --help
```

what is it

```shell
file filename
file directory-name
```

show version of the OS

```shell
cat /etc/os-release
```

logout with current user

```shell
exit
```

---

#### sysinfo

show free ram

```shell
free -mh
```

show uptime

```shell
uptime
```

clear terminal

```shell
clear
```

---

#### `mkdir`, `touch`, `rm`, `cp`, `mv`, `ls`, `tree`, `find`, `echo`, `ln`, `du`

make a directory

```shell
mkdir directory-name
```

make directory forcefully with all needed parents

```shell
mkdir -p directory/path

# example
mkdir -p /opt/dev/ops/devops/test
```

make a file

```shell
touch filename
```

make multiple files with numbers

```shell
touch filename{1..10}.txt
```

delete multiple files with the same name + numbers

```shell
rm -rf filename{1..10}.txt
```

delete file

```shell
rm filename
```

delete dir

```shell
rm -r directory-name
```

force delete everything in current directory

```shell
rm -rf *
```

copy file

```shell
cp filename directory-name
```

copy directory

```shell
cp -r /path/to/dir /path/to/another/dir
```

copy all files and dirs

```shell
cp -r * /path/to/dir
```

move with mv

```shell
mv filename /path/to/dir
```

rename with mv

```shell
mv filename another-filename
mv directory-name another-directory-name
```

move everything with mv

```shell
mv *.txt directory-name
```

move everything in dir to another dir

```shell
mv path/to/dir/* path/to/another/dir

# example
mv /tmp/img-backup/* /var/www/html/images/
```

show everything recursively in current dir with `ls`

```shell
ls -R
```

show dirs in tree format

```shell
tree /path/to/dir

# example
tree /var/log
```

`echo` - print command

print text to the file

```shell
# example

echo "text" > /tmp/sysinfo.txt
```

find anything

```shell
find /path/to -name filename*
```

create softlink

```shell
ln -s /path/to/filename /path/to/filename

# example
ln -s /opt/dev/ops/devops/test/commands.txt cmds
```

show disk usage of the current dir and all dirs and files in it

```shell
du -h
```

show total size of current dir

```shell
du -sh
```

#### locate

> `locate` - command like `find` but more easy to use with indexed search

install locate in rpm-based distrib

```shell
sudo dnf install mlocate
```

>every time before search use `updatedb` command

```shell
updatedb
locate host
```

#### export

export environmental variables temporarily  
change default text editor

```shell
export EDITOR=vim
```

to make it permanent for user add export command to `~/.bashrc` or `~/.bash_profile`

```shell
vim ~/.bashrc

export EDITOR=vim
```

to make it permanent for all users add export command to `/etc/profile`

```shell
vim /etc/profile

export EDITOR=vim
```

---

#### needrestart

what needs to be restarted using machine-friendly show

```shell
sudo needrestart -b
```

what needs to be restarted using human-friendly show

```shell
sudo needrestart -u NeedRestart::UI::stdio -r l
```

restart services with needrestart, reboot if doesn't help

```shell
sudo needrestart -u NeedRestart::UI::stdio -r a
```

---

#### text processing

##### cat, head, tail, less

show file contents

```shell
cat filename
```

show first 10 lines of the file or any number of lines

```shell
head filename

head -20 filename
```

show last 10 lines of the file or any number of lines

```shell
tail filename

tail -20 filename
```

show continuously last 10 lines of the file

```shell
tail -f filename
```

show file contents with pager `less`

```shell
less filename
```

##### bat

> `batcat` - `bat` after **Ubuntu 18**
>
> To install `bat` on CentOS use  [multi-os-base-provision.sh](../bash-snippets/provisioning-bash-snippets/multi-os-base-provision.sh)
>
> To install on Ubuntu before 20:
>
>   ```shell
>   wget https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-musl_0.23.0_amd64.deb \
>   	sudo dpkg -i bat-musl_0.22.1_amd64.deb
>   ```
>
>

print `bat` without line numbers and header

```shell
bat -p filename
```

print `bat` without line numbers but with header

```shell
bat --style=plain,header filename
```

##### grep

find word in file

```shell
grep word filename
```

find word in file and ignore case

```shell
grep -i word filename
```

find word in the file in all files and dirs

```shell
grep -iR word *

# example
grep -R SELINUX /etc/*
```

`-v` - grep process excluding grep process

```shell
ps -ef | grep -i process-name | grep -v 'grep'
```

`grep` examples

```shell
ls /etc/host* | grep host

ls host | grep host

tail -150 /var/log/messages-20230108 | grep -i vagrant

free -h | grep -i mem
```

##### cut, awk

show needed part of file with cut

```shell
cut -d delimiter -f field-number /path/to/filename

# example
cut -d: -f1,7 /etc/passwd
```

show needed part of file with awk

```shell
awk -F'delimiter' '{print $field-number$field-number}' /path/tofilename

# example
awk -F':' '{print $1$7}' /etc/passwd
```

##### sed

replace text in files  
`g` - globally (more than one time in line)  
without `-i` to show what will be changed

```shell
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

    - ```shell
                sudo sed -i 's|http://us.|http://|g' /etc/apt/sources.list
                # or
                sed -i 's/http:\/\/in./http:\/\//g' /etc/apt/sources.list
            ```

  - switch to Armenia repos

    - ```shell
                sudo sed -i 's|http://us.|http://am.|g' /etc/apt/sources.list
                # or
                sed -i 's/http:\/\/us./http:\/\/am./g' /etc/apt/sources.list
            ```

##### wc

`wc` - count anything

count how many lines in file

```shell
wc -l /path/to/filename

# example
wc -l /etc/passwd
```

count how many dirs and files

```shell
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

```shell
tar -czvf archive-name.tar.gz /path/to/dir
```

extract archive  
`-x` - extract

```shell
tar -xzvf filename
```

extract archive to some dir

```shell
tar -xzvf filename -C /path/to/dir
```

---

##### zip

create archive  
`-r` - recursively

```shell
zip -r filename.zip /path/to/dir
```

unzip for unarchive  
`-d` - to point to dir

```shell
unzip filename.zip -d /path/to/dir
```

unzip and overwrite, non-interactive

```shell
unzip -o filename.zip /path/to/dir
```

---

#### input/output redirection

##### output redirection

`>` - output command result to a file

```shell
command-name > /path/to/filename

# examples
uptime > /tmp/sysinfo.txt
ls > /tmp/sysinfo.txt
echo "text" > /tmp/sysinfo.txt
```

output command result to a file and did not overwrite its contents and just append

```shell
command-name >> /path/to/filename

# exapmle
uptime >> /tmp/sysinfo.txt
```

output command result to nowhere

```shell
command-name > /dev/null

# example
yum install vim -y > /dev/null
```

remove everything in file with `cat`

```shell
cat /dev/null > /path/to/filename

# example
cat /dev/null > /tmp/sysinfo.txt
```

redirect error output

```shell
command-name 2> /path/to/filename

# example
freeee 2>> /tmp/error.log
```

to redirect standard output `1>` (default) **and** error output `2>` use `&>`

```shell
command-name &> /path/to/filename

# examples
free -m &>> /tmp/error.log
freddfefe -m &>> /tmp/error.log
```

##### input redirection

```shell
command-name < /path/to/filename

# example
wc -l < /etc/passwd
```

---

#### time, date

check timezone

```shell
date
# or
timedatectl
```

list avalaible timezone

```shell
timedatectl list-timezones

timedatectl list-timezones | grep Berlin
```

set new timezone

```shell
sudo timedatectl set-timezone timezone-name
```

---

#### locale

show used locale

```shell
localectl
```

show installed locales

```shell
localectl list-locales
```

search for langpack and install it

```shell
# for rpm-based distros
dnf search langpacks- | grep -i en

dnf install langpacks-en
```

set locale

```shell
localectl set-locale LANG=en_US.UTF-8
```

show specific locale keymaps

```shell
localectl list-maps | grep -i us
```

set keymap locale

```shell
localectl set-keymap us
```

> fix for us locale error
>
> ```shell
> setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
> ```

```shell
echo "LANG=en_US.utf-8" | sudo tee -a /etc/environment && \
echo "LC_ALL=en_US.utf-8" | sudo tee -a /etc/environment
```

---

#### systemctl

service status

```shell
systemctl status service-name
```

check service active or not

```shell
systemctl is-active service-name
```

check service in autorun or not

```shell
systemctl is-enabled service-name
```

start service

```shell
systemctl start service-name
```

restart service

```shell
systemctl restart service-name
```

reload config of the service without restarting

```shell
systemctl reload service-name
```

stop service

```shell
systemctl stop service-name
```

add service to autorun

```shell
systemctl enable service-name
```

remove service from autorun

```shell
systemctl disable service-name
```

---

#### processes, top, ps

all processes path

```shell
/var/run/
```

show process `PID`

```shell
cat /var/run/process-name/process-name.pid

# example
cat /var/run/httpd/httpd.pid
```

process managers, activity monitors

```shell
top
htop
```

top for specified process

```shell
top -b | grep java
```

show all processes and exit

```shell
ps aux
```

show all processes with displaying parent processes

```shell
ps -ef
```

show all processes sorted by memory usage with `Mb` not `%`

```shell
ps -eo size,pid,user,command --sort -size | \
  awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | \
  cut -d "" -f2 | cut -d "-" -f1
```

find specific process PID and kill it  
kill the parent process

```shell
ps -ef | grep -i process-name | grep -v 'grep'
kill PID
```

forcefully kill the process but without the child processes

```shell
kill -9 PID
```

forcefully kill all child processes with filtering  

- ```shell
    ps -ef | grep -i process-name | grep -v 'grep' | awk '{print $2}' | xargs kill -9
    ```

- >`ps -ef` - list processes  
    >`grep -v 'grep'` - excludes processes with name `grep`  
    >`awk '{print $2}'` - lists only 2nd column of the output  
    >`xargs kill -9` - kills every process

list all logged in users

```shell
who
```

logout user and kill all its processes

```shell
pkill -KILL -u username
```

---

#### users & groups

which user you are now

```shell
whoami
```

show all current logged in users with useful info including ip

```shell
who
```

show current path

```shell
pws
```

show info about any user

```shell
id username
```

add user

```shell
adduser username # for ubuntu, also adds home dir
useradd username # for centos, doesn't add home dir
```

add group

```shell
groupadd group-name
```

add user to the supplementary group without changing primary group

```shell
usermod -aG group-name username
# or
vim /etc/group
```

change current user password

```shell
passwd
```

change any user password

```shell
passwd username
```

switch to root user

```shell
sudo -i
```

switch to any user, change user

```shell
su - username
```

delete user

```shell
userdel username
```

delete user with home dir

```shell
userdel -r username
```

delete group

```shell
groupdel group-name
```

show last users logged in into the system

```shell
last
```

show all opened files by user

```shell
lsof -u username
```

show all opened files in particular dir

```shell
lsof /path/to/dir

# example
lsof /var/www/html/images
```

> ubuntu 22 LTS default groups after install with user `username`

```shell
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

```shell
usermod -u 2005 foo
```

To assign a new `GID` to group called `foo`, enter:

```shell
groupmod -g 3000 foo
```

> Please note that all files which are located in the user’s home directory will have the file `UID` changed automatically as soon as you type above two command. However, files outside user’s home directory need to be changed manually. To manually change files with old `GID` and `UID` respectively, enter:
>
> **WARNING!** The following examples may change ownership of unwanted files on your Linux computer if not executed with care.

```shell
find / -group 2000 -exec chgrp -h foo {} \;
find / -user 1005 -exec chown -h foo {} \;
```

> The `-exec` command executes `chgrp` command or `chmod` command on each file. The `-h` option passed to the `chgrp`/`chmod` command affect each symbolic link instead of any referenced file. Use the following command to verify the same:

```shell
ls -l /home/foo/
id -u foo
id -g foo
```

search for `foo` in the passswd file

```shell
grep foo /etc/passwd
```

search for 'foo' in the group file

```shell
grep foo /etc/group
```

use the find command to locate files owned by `foo`

```shell
find / -user foo -ls
find / -group sales -ls # maybe -group foo here...
```

---

##### sudoers

>For security reasons instead of using vanilla `/etc/sudoers` file use `/etc/sudoers.d` dir and generate there sudoers settings, for example:
>
>Allow `sudo` without pass for user `username`

```shell
echo "username ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/username
```

to add group to sudoers file use `%`

```shell
echo "%group-name ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/group-name
```

show all `/etc/sudoers.d` files

```shell
cat /etc/sudoers.d/* # maybe working only under root
```

edit `/etc/sudoers` with default text editor

```shell
visudo
# or
vim /etc/sudoers
```

normal `sudoers` example

```shell
root ALL=(ALL) ALL
username ALL=(ALL) NOPASSWD: ALL
```

---

##### chown

change `user:group` owners of the dir or file

```shell
chown username:group-name /path/to/filename
```

`-R` - recursively, `-v` - verbose

```shell
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

```shell
# examples

chmod o-x /path/to/filename
chmod g+w /path/to/filename
```

just make file executable for user, group, others

```shell
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

```shell
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

    ```shell
    vim /etc/default/grub
    ```

2. in that file edit this line, in menu count starts with 0  

    ```shell
    GRUB_DEFAULT="1>2"
    ```

3. update grub config  

    ```shell
    update-grub
    ```

**Fedora**

1. don't need to change anything in grub config, just use the command  

    ```shell
    grub2-set-default number
    
    # example
    grub2-set-default 1
    ```

2. check the boot  

    ```shell
    reboot now
    ```

3. if something goes wrong, go to the hypervisor and press `ESC` when booting or hold `Shift` for older systems

#### gparted

[How to resize a root partition in Ubuntu Linux GPT.md](guides/How to resize a root partition in Ubuntu Linux GPT.md)

#### df

show partitions

```shell
df -h
```

#### fdisk

show disks

```shell
fdisk -l
```

show disks with `ls` (including unmounted)

```shell
ls -lh /dev/ | grep disk
```

start disk partitioning

```shell
fdisk /dev/disk-name

# example
fdisk /dev/xvdf
```

> partitioning example

```shell
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

```shell
mkfs # press Tab 2 times
```

do ext4 formatting

```shell
mkfs.ext4 /dev/disk-name

# example
mkfs.ext4 /dev/xvdf1
```

---

#### mount, umount, mounting

mount dir to partition temporarily

```shell
mount /dev/xvdf1 /var/www/html/images/
```

check mounting

```shell
df -h
```

unmount dir from partition

```shell
umount /var/www/html/images/
```

mount dir to partition permanently

```shell
vim /etc/fstab

# add this to file
/dev/xvdf1      /var/www/html/images    ext4    defaults        0 0
```

> `/etc/fstab` example

```shell
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

```shell
mount -a
```

---

### network

show network adapters

```shell
ip a
ip r
ip address

# deprecated starting Ubuntu 20
ifconfig
```

restarting network

```shell
# Ubuntu 22
sudo systemctl restart systemd-networkd
```

---

#### network config Ubuntu 22

edit network config

```shell
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

```shell
sudo netplan apply
# or debug
sudo netplan --debug apply
```

check network adapters

```shell
ip a
```

---

#### network config CentOS 7

choose adapter config to edit

```shell
sudo vim /etc/sysconfig/network-scripts/ifcfg-*
```

> examples

- ```shell
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

- ```shell
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

```shell
sudo systemctl restart network
```

check network adapters

```shell
ip a
```

---

#### hostname, hostnamectl

show hostname

```shell
hostnamectl hostname
```

change hostname

```shell
# Ubuntu 22
sudo hostnamectl hostname web03

# CentOS 7
sudo hostnamectl set-hostname web03
```

> NOTE about `hostname` command
>
>   ```shell
>   hostname your-hostname
>   ```
>
> changes only before reboot, non-persistent

---

#### ssh

##### ssh-keygen

###### generate secured keys and use ssh-agent and `~/.ssh/config`

1. Generate **Ed25519** key pair

   ```shell
   ssh-keygen -t ed25519 -a 100 -C "user@hostname"
   ```

2. Or generate **RSA** key pair if you need compatibility

   ```shell
   ssh-keygen -t rsa -b 4096 -C "user@hostname"
   ```

3. On macOS use `~/.ssh/config` file and use multiple ssh-keys

   ```properties
   Host *
     AddKeysToAgent yes
     UseKeychain yes
     IdentitiesOnly yes
     IdentityFile ~/.ssh/id_ed25519
     IdentityFile ~/.ssh/id_rsa
     IdentityFile ~/.ssh/id_rsa_old
   ```

---

###### [ssh-keygen guide from DO](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)

generate new pair of ssh keys

```shell
ssh-keygen
```

generate new pair of ssh keys in specified dir

```shell
ssh-keygen

# Enter file in which to save the key (/Users/mono/.ssh/id_rsa):
/Users/mono/.ssh/aws/vpro-codecommit_rsa
```

public key default location

```shell
cat ~/.ssh/id_rsa.pub
```

identification (private key or closed key)

```shell
cat ~/.ssh/id_rsa
```

copy public key to remote server for specific user

```shell
ssh-copy-id username@remote_host
```

copy public key to remote server without ssh-copy-id

```shell
cat ~/.ssh/id_rsa.pub | ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

disable password authentication on remote server

```shell
sudo nano /etc/ssh/sshd_config

# edit in file
PasswordAuthentication no

sudo service ssh restart
sudo service sshd restart # rpm-based distro
```

list all local private and public ssh keys

```shell
ls -l ~/.ssh/
ls -l ~/.ssh/id_*
```

change the passphrase for default SSH private key

```shell
ssh-keygen -p
```

change the passphrase for specific private key

```shell
ssh-keygen -p -f ~/.ssh/private_key_name
# or
ssh-keygen -f private_key_name -p
```

remove a passphrase from private key

```shell
ssh-keygen -f ~/.ssh/private_key_name -p
# or
ssh-keygen -f ~/.ssh/private_key_name -p -N ""
# for default private key
ssh-keygen -p -N ""
```

ssh to host with specific public key

```shell
ssh -i ~/.ssh/id_rsa_name username@hostname

# aws example
ssh -i ~/.ssh/key-name.pem -o ServerAliveInterval=200 username@ip
```

---

##### ssh-agent

**SSH-agent** is manager for ssh-keys  
ssh-keys should *not* get automatically added to the agent just because you SSH'ed to a server...

list the ssh-agent keys

```shell
ssh-add -l
```

delete all ssh-agent-keys

```shell
ssh-add -D
```

---

###### SSH-agent forwarding, ProxyJump

> Best way to go through **Bastion-host** is to use **SSH ProxyJump**

[Про SSH Agent](https://habr.com/ru/companies/skillfactory/articles/503466/) - хорошая статья на [habr.com](habr.com).

Instead of forwarding **SSH-agent** and all ssh keys use **ProxyJump**

1. Connect to remote host through **Bastion-host**

   ```shell
   ssh -J bastion.example.com cloud.computer.internal
   ```

2. Local ssh-keys will be used to connect to remote host

3. It's like *ssh-session* inside another *ssh-session*, but actually ssh-session never launched on **Bastion-host**

Configure **ProxyJump** inside `~/.ssh/config`

```properties
Host bastion.example.com
	User username

Host *.computer.internal
	ProxyJump bastion.example.com
	User username
```

And connect to the remote host

```shell
ssh cloud.computer.internal
```

---

##### scp

push file to another host

```shell
scp filename username@hostname:/absolute/path/to/dir

# example
scp testfile.txt devops@web01:/tmp
```

fetch file from another host

```shell
scp username@hostname:/absolute/path/to/filename

# example
scp devops@web01:/home/devops/testfile.txt .
```

push file to another host with specified key

```shell
scp -i /path/to/key-filename /path/to/filename username@hostname:/path/to/dest

# aws example
scp -i ~/.ssh/aws/bastion-key.pem ~/.ssh/aws/wave-key.pem ec2-user@52.53.251.116:/home/ec2-user/
```

---

#### https, curl, wget

> `curl` and `wget` to download something

download anything with `curl`

```shell
curl https://link -o filename

# example
curl https://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/aarch64/os/Packages/t/tree-2.1.0-1.fc38.aarch64.rpm -o tree-2.1.0-1.fc38.aarch64.rpm
```

check curl

```shell
curl parrot.live
```

check working webserver (**httpd**, **apache2**, **nginx**)

```shell
curl localhost
```

download file with `wget`

```shell
wget filelink
```

---

#### open ports

##### nmap

show open ports of localhost

```shell
nmap localhost
```

show open ports of local server

```shell
nmap hostname

# example
nmap db01
```

##### netstat

show all open TCP ports

```shell
netstat -antp

# example
netstat -antp | grep apache2
```

search `PID`, and use it to know on what port app is running, if you don't see process name with `netstat`

```shell
ps -ef | grep apache2 # copy PID

netstat -antp | grep PID
```

##### ss

show all open TCP ports

```shell
ss -tunlp

# example
ss -tunlp | grep 80
```

##### telnet

use telnet to check the connection via any port

```shell
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

```shell
dig adress-name

# example
dig google.com
```

`nslookup` - dns lookup (older version of dig)

```shell
nslookup address-name

# example
nslookup google.com
```

##### traceroute, tracert, mtr

show path to the server and latency problems

```shell
traceroute address-name

# example
traceroute mirrors.fedoraproject.org
traceroute google.com
```

`mrt` - traceroute + ping

show path to the server and latency problems online (live)

```shell
mrt adress-name

# example
mtr google.com
```

##### gateway lookup

show gateways

```shell
route -n
route
```

##### arp

show arp table

```shell
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

```shell
cat /etc/apt/sources.list
```

before installing any package update repos list

```shell
apt update
```

update all packages

```shell
apt upgrade
```

update specific package

```shell
apt upgrade package-name
```

search package from avalaible repos

```shell
apt search package-name
```

install package without prompts

```shell
apt install package-name -y
```

reinstall package

```shell
apt reinstall package-name
```

remove package

```shell
apt remove package-name
```

remove package and all its configs and data

```shell
apt purge package-name
```

list all available *Group Packages*

```shell
apt grouplist
```

install all the packages in a group

```shell
apt groupinstall group-name
```

show enabled apt repos

```shell
apt repolist
```

clean apt cache

```shell
apt clean all
```

show apt history

```shell
apt history
```

show info of the package

```shell
apt show package-name
```

---

##### apt autoremove

delete all unused packages that was installed as dependencies

```shell
apt autoremove
```

delete all unused packages that was installed as dependencies with all config files and data

```shell
apt autoremove --purge
# 1st preffered or
apt autopurge
```

---

##### apt-mark

> Hold specific packages from upgrading. Useful to not update the kernel packages.

```shell
apt-mark hold package-name

# example for ubuntu m1 vm
apt-mark hold linux-modules-5.4.0-137-generic linux-headers-5.4.0-137 linux-headers-5.4.0-137-generic linux-headers-generic linux-image-unsigned-5.4.0-137-generic linux-modules-5.4.0-137-generic
```

---

#### dpkg

> `dpkg` - package manager for local packages

install downloaded package with dpkg

```shell
dpkg -i filename
```

show all installed packages

```shell
dpkg -l
```

search for specific installed package

```shell
dpkg -l | grep -i package-name
```

remove package

```shell
dpkg -r package-name
```

---

### rpm-based distros (RHEL, CentOS, Amazon Linux, etc)

#### dnf, yum

> Almost all these commands applied to `yum`.

---

##### paths yum

repos location

```shell
/etc/yum.repos.d/
```

if there are a problem with repos metalink, comment metalink and enter baseurl

```shell
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

```shell
dnf search package-name
```

install something without prompts

```shell
dnf install -y package-name
```

reinstall package

```shell
dnf reinstall package-name
```

remove package and its config files not touched by user

```shell
dnf remove package-name
```

update all packages

```shell
dnf update
```

update specific package

```shell
dnf update package-name
```

list all avalaible *Group Packages*

```shell
dnf grouplist
```

install all the packages in a group

```shell
dnf groupinstall group-name
```

show enabled dnf repos

```shell
dnf repolist
```

clean dnf cache

```shell
dnf clean all
```

show history of dnf

```shell
dnf history
```

show info of package

```shell
dnf info package-name
```

create metadata cache (dnf will do it automatically)

```shell
dnf makecache
```

exclude package in dnf from updating

```shell
# example for kernel updates
echo "exclude=kernel*" >> /etc/dnf/dnf.conf
```

exclude package in yum from updating

```shell
# deprecated in Fedora 35 and maybe previously versions
echo "exclude=kernel*" >> /etc/yum.conf
```

---

#### epel

**epel** - additional package repository with commonly used software

```shell
sudo dnf install epel-release
sudo dnf makecache
```

**Rocky Linux 9**

```shell
sudo dnf -y install epel-release
sudo dnf makecache
```

**Amazon Linux 2**

```shell
sudo amazon-linux-extras install epel -y
```

**RHEL 8**

```shell
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
```

**RHEL 7**

```shell
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

**CentOS 8**

```shell
sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
sudo dnf config-manager --set-enabled PowerTools
```

**CentOS 7**

```shell
sudo yum -y install epel-release
```

List repositories that are turned on  
To verify that the EPEL repository is turned on, run the repolist command:

```shell
sudo yum repolist
```

---

#### rpm

> `rpm` - package manager for local packages

install downloaded package  
`-i` - install, `-v` - verbose, `-h` - human readable

```shell
rmp -ivh package-name

# examples
rpm -ivh mozilla-mail-1.7.5-17.i586.rpm
rpm -ivh --test mozilla-mail-1.7.5-17.i586.rpm
```

show all installed rpms

```shell
rpm -qa

# examples
rpm -qa
rpm -qa | less
```

show latest installed rpms

```shell
rpm -qa --last
```

upgrade installed package

```shell
rpm -Uvh package-name

# examples
rpm -Uvh mozilla-mail-1.7.6-12.i586.rpm
rpm -Uvh --test mozilla-mail-1.7.6-12.i586.rpm
```

remove installed package

```shell
rpm -ev package-name

# example
rpm -ev mozilla-mail
```

remove installed package without checking its dependencies

```shell
rpm -ev --nodeps

# example
rpm -ev --nodeps mozilla-mail
```

show info about installed package

```shell
rpm -qi package-name

# example
rpm -qi mozilla-mail
```

find out what package owns the file

```shell
rpm -qf /path/to/dir

# examples
rpm -qf /etc/passwd
```

show list of configuration file(s) for a package

```shell
rpm -qc package-name

# example
rpm -qc httpd
```

show list of configuration files for a command

```shell
rpm -qcf /path/to/filename

# example
rpm -qcf /usr/X11R6/bin/xeyes
```

show what dependencies a rpm file has

```shell
rpm -qpR filename.rpm
rpm -qR package-name

# examples
rpm -qpR mediawiki-1.4rc1-4.i586.rpm
rpm -qR bash
```

---

#### firewalld

open 443, https

```shell
sudo firewall-cmd --add-service=http --add-service=https --permanent
sudo systemctl restart firewalld
```

firewalld open specific port, for example `mysql` (`mariadb`)

```shell
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
```

---

## third-party packages

### useful packages

`bash-completions` (used for `docker` for example)

```shell
sudo dnf install bash-completion

sudo apt install bash-completion
```

`colordiff` - coloured `diff` - packages for file comparisons  
`-y` - for side-by-side comparison

```shell
colordiff -y /path/to/filename /path/to/filename
```

---

### jdk

Installation of different versions of `java` here [maven.md](maven.md)

check current main version

```shell
java -version
```

check installed jdk versions

```shell
ls /usr/lib/jvm
```

> example  
> here installed openjdk-8-jdk `java-1.8.0-openjdk-amd64` and openjdk-11-jdk `java-1.11.0-openjdk-amd64`

```shell
ls /usr/lib/jvm
java-1.11.0-openjdk-amd64  java-11-openjdk-amd64  openjdk-11
java-1.8.0-openjdk-amd64   java-8-openjdk-amd64
```

---

### apache2, httpd

default path for website for **apache2**, **httpd**

```shell
/var/www/html
```

---

### tomcat

default path for website for tomcat  
`?` - **tomcat** version

```shell
/var/lib/tomcat?/webapps/
/var/lib/tomcat8/webapps/
```

---

### mysql, mariadb

default path for **mysql** db

```shell
/var/lib/mysql
```

install mysql on **deb-based distro**

```shell
apt install mysql
```

install mysql on **rpm-based distro**

```shell
dnf install mariadb-server
```

install **mysql** client to connect to the mysql remote host

```shell
apt install mysql-client
```

connect with mysql-client to remote host

```shell
mysql -h hostname -u username -ppassword

# example
mysql -h vprofile-mysql-rds.cyg76sxmwbec.us-east-1.rds.amazonaws.com -u admin -plicgiTGxfz8iu128mGHg
```

restore mysql backup to a running mysql instance

```shell
mysql -h vprofile-bean-rds.cyg76sxmwbec.us-east-1.rds.amazonaws.com -u admin -pQuz9qrKNPY97jqVa5T8B accounts < src/main/resources/db_backup.sql
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

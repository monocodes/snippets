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
  - [linux commands](#linux-commands)
    - [basic commands](#basic-commands)
      - [`& && || ;`](#---)
      - [`--help`](#--help)
      - [`mkdir`, `touch`, `rm`, `cp`, `mv`, `tree`, `find`, `echo`](#mkdir-touch-rm-cp-mv-tree-find-echo)
      - [locate](#locate)
    - [grub](#grub)
    - [partitioning, mounting, fdisk, gparted](#partitioning-mounting-fdisk-gparted)
      - [gparted](#gparted)
      - [df](#df)
      - [fdisk](#fdisk)
      - [mkfs, formatting](#mkfs-formatting)
      - [mount, umount, mounting](#mount-umount-mounting)
    - [time, date](#time-date)
    - [locale](#locale)
    - [users \& groups](#users--groups)
      - [change user and group ID for user and files](#change-user-and-group-id-for-user-and-files)
      - [sudoers](#sudoers)
      - [chown](#chown)
      - [chmod](#chmod)
    - [systemctl](#systemctl)
    - [text processing](#text-processing)
      - [sed](#sed)
    - [processes, top, ps](#processes-top-ps)
    - [network](#network)
      - [network config Ubuntu 22](#network-config-ubuntu-22)
      - [network config CentOS 7](#network-config-centos-7)
      - [hostname, hostnamectl](#hostname-hostnamectl)
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
      - [apt search](#apt-search)
    - [rpm-based distros (RHEL, CentOS, Amazon Linux, etc)](#rpm-based-distros-rhel-centos-amazon-linux-etc)
      - [firewalld](#firewalld)
  - [linux packages](#linux-packages)
    - [jdk](#jdk)
  - [bash wildcards](#bash-wildcards)
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

## linux commands

### basic commands

#### `& && || ;`

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

#### `mkdir`, `touch`, `rm`, `cp`, `mv`, `tree`, `find`, `echo`

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

---

### grub

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

---

### partitioning, mounting, fdisk, gparted

#### gparted

[How to resize a root partition in Ubuntu Linux GPT.md](guides/How to resize a root partition in Ubuntu Linux GPT.md)

---

#### df

show partitions

```bash
df -h
```

---

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

### time, date

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

### locale

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
>   ```bash
>   setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
>   ```

```bash
echo "LANG=en_US.utf-8" | sudo tee -a /etc/environment && \
echo "LC_ALL=en_US.utf-8" | sudo tee -a /etc/environment
```

---

### users & groups

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

#### change user and group ID for user and files

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

#### sudoers

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

#### chown

change `user:group` owners of the dir or file

```bash
chown username:group-name /path/to/filename
```

`-R` - recursively, `-v` - verbose

```bash
chown -R username:group-name /path/to/filename
```

---

#### chmod

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

### systemctl

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

### text processing

#### sed

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

---

### processes, top, ps

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

#### apt search

search package with apt

```bash
apt search package-name
```

---

### rpm-based distros (RHEL, CentOS, Amazon Linux, etc)

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

## linux packages

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

## bash wildcards

search any directory (`**`) any file with `.war` extension (`*.war`)

```bash
**/*.war
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

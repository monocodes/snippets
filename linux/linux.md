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
    - [partitioning, mounting, fdisk, gparted](#partitioning-mounting-fdisk-gparted)
      - [gparted](#gparted)
      - [df](#df)
      - [fdisk](#fdisk)
      - [mkfs, formatting](#mkfs-formatting)
      - [mount, umount, mounting](#mount-umount-mounting)
    - [time, date](#time-date)
    - [locale](#locale)
    - [deb-based distros (Debian, Ubuntu, etc)](#deb-based-distros-debian-ubuntu-etc)
      - [apt](#apt)
      - [apt search](#apt-search)
    - [sed](#sed)
  - [linux packages](#linux-packages)
    - [jdk](#jdk)
  - [bash wildcards](#bash-wildcards)
  - [network](#network)
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

---

## linux commands

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
localectl list-keymaps | grep -i us
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

### deb-based distros (Debian, Ubuntu, etc)

#### apt

#### apt search

search package with apt

```bash
apt search package-name
```

---

### sed

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

## network

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

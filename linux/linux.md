---
title: linux
categories:
  - software
  - guides
  - notes
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [paths](#paths)
  - [Filesystem Hierarchy Standard](#filesystem-hierarchy-standard)
- [bash wildcards](#bash-wildcards)
- [linux commands](#linux-commands)
  - [basic commands and system packages](#basic-commands-and-system-packages)
    - [`& && || ; ;; \`](#-----)
    - [`--help`](#--help)
    - [sysinfo](#sysinfo)
    - [`mkdir`, `touch`, `rm`, `cp`, `mv`, `ls`, `tree`, `find`, `echo`, `alias`, `ln`, `du`, `source`](#mkdir-touch-rm-cp-mv-ls-tree-find-echo-alias-ln-du-source)
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
    - [crontab examples](#crontab-examples)
    - [systemctl](#systemctl)
    - [processes, top, ps](#processes-top-ps)
    - [users \& groups](#users--groups)
      - [change user and group ID for user and files](#change-user-and-group-id-for-user-and-files)
      - [sudoers](#sudoers)
      - [chown](#chown)
      - [chmod](#chmod)
  - [partitioning, mounting, fdisk, gparted](#partitioning-mounting-fdisk-gparted)
    - [lvm](#lvm)
      - [Resizing of VM with **LVM**](#resizing-of-vm-with-lvm)
    - [grub](#grub)
    - [gparted](#gparted)
    - [df](#df)
    - [fdisk](#fdisk)
    - [mkfs, formatting](#mkfs-formatting)
    - [mount, umount, mounting](#mount-umount-mounting)
  - [network](#network)
    - [network Ubuntu 22](#network-ubuntu-22)
    - [network Rocky Linux 9](#network-rocky-linux-9)
    - [network CentOS 7](#network-centos-7)
    - [hostname, hostnamectl](#hostname-hostnamectl)
    - [ssh](#ssh)
      - [ssh paths](#ssh-paths)
      - [ssh-keygen](#ssh-keygen)
        - [generate secured keys and use ssh-agent and `~/.ssh/config`](#generate-secured-keys-and-use-ssh-agent-and-sshconfig)
        - [ssh-keygen guide from DO](#ssh-keygen-guide-from-do)
      - [ssh-agent](#ssh-agent)
        - [SSH-agent forwarding, ProxyJump](#ssh-agent-forwarding-proxyjump)
      - [scp](#scp)
    - [curl, wget](#curl-wget)
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
      - [remove gpg-key and repo](#remove-gpg-key-and-repo)
    - [firewalld](#firewalld)
- [third-party packages](#third-party-packages)
  - [useful packages](#useful-packages)
  - [jdk](#jdk)
  - [Node.js](#nodejs)
    - [Node.js install Ubuntu](#nodejs-install-ubuntu)
    - [Node.js unintall Ubuntu](#nodejs-unintall-ubuntu)
  - [php](#php)
  - [apache2, httpd](#apache2-httpd)
  - [tomcat](#tomcat)
- [network notes](#network-notes)
  - [private IP ranges](#private-ip-ranges)
  - [ifconfig.io](#ifconfigio)
- [notes](#notes)
  - [DevOps tools usage](#devops-tools-usage)
  - [bash '', ""](#bash--)
  - [sed '', ""](#sed--)
- [guides](#guides)
  - [dependencies version ranges and requirements syntax](#dependencies-version-ranges-and-requirements-syntax)
    - [package.json](#packagejson)
  - [sed guide](#sed-guide)
    - [Find and replace text within a file using sed command](#find-and-replace-text-within-a-file-using-sed-command)
    - [Syntax: sed find and replace text](#syntax-sed-find-and-replace-text)
    - [Examples that use sed to find and replace](#examples-that-use-sed-to-find-and-replace)
    - [A note about \*BSD and macOS sed version](#a-note-about-bsd-and-macos-sed-version)
    - [`sed` command problems](#sed-command-problems)
    - [How to use sed to match word and perform find and replace](#how-to-use-sed-to-match-word-and-perform-find-and-replace)
    - [Recap and conclusion – Using sed to find and replace text in given files](#recap-and-conclusion--using-sed-to-find-and-replace-text-in-given-files)

## paths

`$PATH`

```sh
# global
/etc/environment
/etc/profile

# user bash
~/.bashrc
~/.profile # deb-based
~/.bash_profile # rpm-based

# user zsh
~/.zshrc
~/.zprofile
```

binaries

```sh
/bin
/sbin
/usr/sbin
/usr/local/bin
/usr/local/sbin
$HOME/.local
```

software user configs

```sh
~/.config
```

users info

```sh
/etc/passwd
```

groups info

```sh
/etc/group
```

logs

```sh
/var/log
```

starting/stopping/reloading configs of the services

```sh
/etc/systemd/system/multi-user.target.wants
```

default webserver data, webhosting

```sh
/var/www/html
```

all processes path

```sh
/var/run/
```

show `PID`

```sh
cat /var/run/process-name/process-name.pid

# example
cat /var/run/httpd/httpd.pid
```

network config, more info here -> [network](#network)

```sh
# Ubuntu 22
/etc/netplan/00-installer-config.yaml

# CentOS 7
/etc/sysconfig/network-scripts/ifcfg-*
```

banner file (info when login into the system)  
create it with any text

```sh
/etc/motd
```

---

### Filesystem Hierarchy Standard

The **Filesystem Hierarchy Standard** (**FHS**) is a reference describing the conventions used for the layout of a UNIX system.

| Directory         | Description                                                  |
| :---------------- | :----------------------------------------------------------- |
| `/`               | *Primary hierarchy* root and [root directory](https://en.wikipedia.org/wiki/Root_directory) of the entire file system hierarchy. |
| `/bin`            | Essential command [binaries](https://en.wikipedia.org/wiki/Executable) that need to be available in [single-user mode](https://en.wikipedia.org/wiki/Single-user_mode), including to bring up the system or repair it,[[3\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-3) for all users (e.g., [cat](https://en.wikipedia.org/wiki/Cat_(Unix)), [ls](https://en.wikipedia.org/wiki/Ls), [cp](https://en.wikipedia.org/wiki/Cp_(Unix))). |
| `/boot`           | [Boot loader](https://en.wikipedia.org/wiki/Boot_loader) files (e.g., [kernels](https://en.wikipedia.org/wiki/Kernel_(operating_system)), [initrd](https://en.wikipedia.org/wiki/Initrd)). |
| `/dev`            | [Device files](https://en.wikipedia.org/wiki/Device_file) (e.g., `/dev/null`, `/dev/disk0`, `/dev/sda1`, `/dev/tty`, `/dev/random`). |
| `/etc`            | Host-specific system-wide [configuration files](https://en.wikipedia.org/wiki/Configuration_file). There has been controversy over the meaning of the name itself. In early versions of the UNIX Implementation Document from Bell labs, `/etc` is referred to as the *[etcetera](https://en.wikipedia.org/wiki/Et_cetera) directory*,[[4\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-4) as this directory historically held everything that did not belong elsewhere (however, the FHS restricts `/etc` to static configuration files and may not contain binaries).[[5\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-/etc-5) Since the publication of early documentation, the directory name has been re-explained in various ways. Recent interpretations include [backronyms](https://en.wikipedia.org/wiki/Backronym) such as "Editable Text Configuration" or "Extended Tool Chest".[[6\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-6) |
| `/etc/opt`        | Configuration files for add-on packages stored in `/opt`.    |
| `/etc/sgml`       | Configuration files, such as catalogs, for software that processes [SGML](https://en.wikipedia.org/wiki/SGML). |
| `/etc/X11`        | Configuration files for the [X Window System](https://en.wikipedia.org/wiki/X_Window_System), version 11. |
| `/etc/xml`        | Configuration files, such as catalogs, for software that processes [XML](https://en.wikipedia.org/wiki/XML). |
| `/home`           | Users' [home directories](https://en.wikipedia.org/wiki/Home_directory), containing saved files, personal settings, etc. |
| `/lib`            | [Libraries](https://en.wikipedia.org/wiki/Library_(computer_science)) essential for the [binaries](https://en.wikipedia.org/wiki/Binaries) in `/bin` and `/sbin`. |
| `/lib<qual>`      | Alternate format essential libraries. These are typically used on systems that support more than one executable code format, such as systems supporting [32-bit](https://en.wikipedia.org/wiki/32-bit) and [64-bit](https://en.wikipedia.org/wiki/64-bit) versions of an [instruction set](https://en.wikipedia.org/wiki/Instruction_set). Such directories are optional, but if they exist, they have some requirements. |
| `/media`          | Mount points for [removable media](https://en.wikipedia.org/wiki/Removable_media) such as [CD-ROMs](https://en.wikipedia.org/wiki/CD-ROM) (appeared in FHS-2.3 in 2004). |
| `/mnt`            | Temporarily [mounted](https://en.wikipedia.org/wiki/Mount_(computing)) filesystems. |
| `/opt`            | Add-on [application software](https://en.wikipedia.org/wiki/Application_software) [packages](https://en.wikipedia.org/wiki/Software_package_(installation)).[[7\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-/opt-7) |
| `/proc`           | Virtual [filesystem](https://en.wikipedia.org/wiki/File_system) providing [process](https://en.wikipedia.org/wiki/Process_(computing)) and [kernel](https://en.wikipedia.org/wiki/Kernel_(operating_system)) information as files. In Linux, corresponds to a [procfs](https://en.wikipedia.org/wiki/Procfs) mount. Generally, automatically generated and populated by the system, on the fly. |
| `/root`           | [Home directory](https://en.wikipedia.org/wiki/Home_directory) for the [root](https://en.wikipedia.org/wiki/Superuser) user. |
| `/run`            | Run-time variable data: Information about the running system since last boot, e.g., currently logged-in users and running [daemons](https://en.wikipedia.org/wiki/Daemon_(computer_software)). Files under this directory must be either removed or truncated at the beginning of the boot process, but this is not necessary on systems that provide this directory as a [temporary filesystem](https://en.wikipedia.org/wiki/Temporary_filesystem) ([tmpfs](https://en.wikipedia.org/wiki/Tmpfs)). |
| `/sbin`           | Essential system binaries (e.g., [fsck](https://en.wikipedia.org/wiki/Fsck), [init](https://en.wikipedia.org/wiki/Init), [route](https://en.wikipedia.org/wiki/Route_(command))). |
| `/srv`            | Site-specific data served by this system, such as data and scripts for web servers, data offered by [FTP](https://en.wikipedia.org/wiki/FTP) servers, and repositories for [version control systems](https://en.wikipedia.org/wiki/Version_control_systems) (appeared in FHS-2.3 in 2004). |
| `/sys`            | Contains information about devices, drivers, and some kernel features.[[8\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-/sys-8) |
| `/tmp`            | [Directory for temporary files](https://en.wikipedia.org/wiki/Temporary_folder) (see also `/var/tmp`). Often not preserved between system reboots and may be severely size-restricted. |
| `/usr`            | *Secondary hierarchy* for read-only user data; contains the majority of ([multi-](https://en.wikipedia.org/wiki/Multi-user))user utilities and applications. Should be shareable and read-only.[[9\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-9)[[10\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-10) |
| `/usr/bin`        | Non-essential command [binaries](https://en.wikipedia.org/wiki/Executable) (not needed in [single-user mode](https://en.wikipedia.org/wiki/Single-user_mode)); for all users. |
| `/usr/include`    | Standard [include files](https://en.wikipedia.org/wiki/Header_file). |
| `/usr/lib`        | [Libraries](https://en.wikipedia.org/wiki/Library_(computer_science)) for the [binaries](https://en.wikipedia.org/wiki/Binaries) in `/usr/bin` and `/usr/sbin`. |
| `/usr/libexec`    | Binaries run by other programs that are not intended to be executed directly by users or shell scripts (optional). |
| `/usr/lib<qual>`  | Alternative-format libraries (e.g., `/usr/lib32` for 32-bit libraries on a 64-bit machine (optional)). |
| `/usr/local`      | *Tertiary hierarchy* for local data, specific to this host. Typically has further subdirectories (e.g., `bin`, `lib`, `share`).[[NB 1\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-11) |
| `/usr/sbin`       | Non-essential system binaries (e.g., [daemons](https://en.wikipedia.org/wiki/Daemon_(computer_software)) for various [network services](https://en.wikipedia.org/wiki/Network_service)). |
| `/usr/share`      | Architecture-independent (shared) data.                      |
| `/usr/src`        | [Source code](https://en.wikipedia.org/wiki/Source_code) (e.g., the kernel source code with its header files). |
| `/usr/X11R6`      | [X Window System](https://en.wikipedia.org/wiki/X_Window_System), Version 11, Release 6 (up to FHS-2.3, optional). |
| `/var`            | Variable files: files whose content is expected to continually change during normal operation of the system, such as logs, spool files, and temporary e-mail files. |
| `/var/cache`      | Application cache data. Such data are locally generated as a result of time-consuming I/O or calculation. The application must be able to regenerate or restore the data. The cached files can be deleted without loss of data. |
| `/var/lib`        | State information. Persistent data modified by programs as they run (e.g., databases, packaging system metadata, etc.). |
| `/var/lock`       | Lock files. Files keeping track of resources currently in use. |
| `/var/log`        | Log files. Various logs.                                     |
| `/var/mail`       | Mailbox files. In some distributions, these files may be located in the deprecated `/var/spool/mail`. |
| `/var/opt`        | Variable data from add-on packages that are stored in `/opt`. |
| `/var/run`        | Run-time variable data. This directory contains system information data describing the system since it was booted.[[11\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-12) In FHS 3.0, `/var/run` is replaced by `/run`; a system should either continue to provide a `/var/run` directory or provide a symbolic link from `/var/run` to `/run` for backwards compatibility.[[12\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-13) |
| `/var/spool`      | [Spool](https://en.wikipedia.org/wiki/Spooling) for tasks waiting to be processed (e.g., print queues and outgoing mail queue). |
| `/var/spool/mail` | [Deprecated](https://en.wikipedia.org/wiki/Deprecated) location for users' mailboxes.[[13\]](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard#cite_note-14) |
| `/var/tmp`        | Temporary files to be preserved between reboots.             |

---

## bash wildcards

search any directory (`**`) any file with `.war` extension (`*.war`)

```sh
**/*.war
```

---

## linux commands

### basic commands and system packages

#### `& && || ; ;; \`

>`A` and `B` are any commands

Run A and then B, regardless of success of A

```sh
A ; B
```

`;;` should be used in a `case` statement only

Run B if A succeeded

```sh
A && B
```

Run B if A failed

```sh
A || B
```

Run A in background

```sh
A &
```

Multiline command with `\`

```sh
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

```sh
command-name --help
```

what is it

```sh
file filename
file directory-name
```

show version of the OS

```sh
cat /etc/os-release
```

logout with current user

```sh
exit
```

---

#### sysinfo

show free ram

```sh
free -mh
```

show uptime

```sh
uptime
```

clear terminal

```sh
clear
```

show number of CPU cores (useful for **NGINX** `worker_processes`)

```sh
nproc
```

show the number of files your OS is allowed to open per core (useful for **NGINX** `worker_connections`)

```sh
ulimit -n
```

---

#### `mkdir`, `touch`, `rm`, `cp`, `mv`, `ls`, `tree`, `find`, `echo`, `alias`, `ln`, `du`, `source`

make a directory

```sh
mkdir directory-name
```

make directory forcefully with all needed parents

```sh
mkdir -p directory/path

# example
mkdir -p /opt/dev/ops/devops/test
```

make a file

```sh
touch filename
```

make multiple files with numbers

```sh
touch filename{1..10}.txt
```

delete multiple files with the same name + numbers

```sh
rm -rf filename{1..10}.txt
```

delete file

```sh
rm filename
```

delete dir

```sh
rm -r directory-name
```

force delete everything in current directory

```sh
rm -rf *
```

delete everything except something

```sh
rm -rf !("filename")
rm -rf !("*.war")
```

copy file

```sh
cp filename directory-name
```

copy directory

```sh
cp -r /path/to/dir /path/to/another/dir
```

copy all files and dirs

```sh
cp -r * /path/to/dir
```

move with mv

```sh
mv filename /path/to/dir
```

rename with mv

```sh
mv filename another-filename
mv directory-name another-directory-name
```

move everything with mv

```sh
mv *.txt directory-name
```

move everything in dir to another dir

```sh
mv path/to/dir/* path/to/another/dir

# example
mv /tmp/img-backup/* /var/www/html/images/
```

show everything recursively in current dir with `ls`

```sh
ls -R
```

show dirs in tree format

```sh
tree /path/to/dir

# example
tree /var/log
```

`echo` - print command

print help for `echo`

```sh
/bin/echo --help
```

delete everything in file and add text to the file

```sh
echo "text" > /tmp/filename.txt
```

append text with new line into file  
`-e` - enable interpretation of backslash escapes

```sh
echo -e "text\nnew-line-text" >> filename
# example
echo -e "filetype plugin indent on\nsyntax on" >> ~/.vimrc
```

`alias` - aliases for commands

show current user aliases

```sh
alias
```

add alias to `~/.bashrc` or `~/.zshrc`

```sh
# alias vim example
echo 'alias vim="/volume1/@appstore/vim/bin/vim"' >> ~/.bashrc
```

encode and decode string with base64

```sh
echo -n "secretpass" | base64

# output
c2VjcmV0cGFzcw==

echo 'c2VjcmV0cGFzcw==' | base64 --decode

# output
secretpass

# output on macOS
secretpass%
```

find anything

```sh
find /path/to -name filename*

# example
find . -name "foo*"
```

create softlink

```sh
ln -s /path/to/filename /path/to/filename

# example
ln -s /opt/dev/ops/devops/test/commands.txt cmds
```

create softlink for nginx config

```sh
sudo ln -s /etc/nginx/sites-available/nginx-handbook.conf /etc/nginx/sites-enabled/nginx-handbook.conf
```

> Always use **full paths** for symlinks!

show disk usage of the current dir and all dirs and files in it

```sh
du -h
```

show total size of current dir

```sh
du -sh
```

source something for root (need to test it)

```sh
sudo -s source /root/.profile
```

#### locate

> `locate` - command like `find` but more easy to use with indexed search

install locate in rpm-based distrib

```sh
sudo dnf install mlocate
```

>every time before search use `updatedb` command

```sh
updatedb
locate host
```

#### export

export environmental variables temporarily  
change default text editor

```sh
export EDITOR=vim
```

to make it permanent for user add export command to `~/.bashrc` or `~/.bash_profile`

```sh
vim ~/.bashrc

export EDITOR=vim
```

to make it permanent for all users add export command to `/etc/profile`

```sh
vim /etc/profile

export EDITOR=vim
```

---

#### needrestart

what needs to be restarted using machine-friendly show

```sh
sudo needrestart -b
```

what needs to be restarted using human-friendly show

```sh
sudo needrestart -u NeedRestart::UI::stdio -r l
```

restart services with needrestart, reboot if doesn't help

```sh
sudo needrestart -u NeedRestart::UI::stdio -r a
```

---

#### text processing

##### cat, head, tail, less

show file contents

```sh
cat filename
```

show first 10 lines of the file or any number of lines

```sh
head filename

head -20 filename
```

show last 10 lines of the file or any number of lines

```sh
tail filename

tail -20 filename
```

show continuously last 10 lines of the file

```sh
tail -f filename
```

show continuously last 10 lines of all files in current dir

```sh
tail -f *
```

show file contents with pager `less`

```sh
less filename
```

##### bat

> `batcat` - `bat` after **Ubuntu 18**
>
> To install `bat` on CentOS use  [multi-os-base-provision.sh](../bash-snippets/provisioning-bash-snippets/multi-os-base-provision.sh)
>
> To install on Ubuntu before 20:
>
>   ```sh
>   wget https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-musl_0.23.0_amd64.deb \
>   	sudo dpkg -i bat-musl_0.22.1_amd64.deb
>   ```
>
>

print `bat` without line numbers and header

```sh
bat -p filename
```

print `bat` without line numbers but with header

```sh
bat --style=plain,header filename
```

print `bat` without pager

```sh
bat -P filename
# or
bat --paging=never filename
```

##### grep

find word in file

```sh
grep word filename
```

find word in file and ignore case

```sh
grep -i word filename
```

grep multiple patterns

```sh
grep -E 'pattern1|pattern2'
grep -e pattern1 -e pattern2

# examples
ls -la ~/.ssh/aws | grep -E 'dove|vpro'
ls -la ~/.ssh/aws | grep -e dove -e vpro
```

find word in the file in all files and dirs

```sh
grep -iR word *

# example
grep -R SELINUX /etc/*
```

`-v` - grep process excluding grep process

```sh
ps -ef | grep -i process-name | grep -v 'grep'
```

`grep` examples

```sh
ls /etc/host* | grep host

ls host | grep host

tail -150 /var/log/messages-20230108 | grep -i vagrant

free -h | grep -i mem
```

##### cut, awk

show needed part of file with cut

```sh
cut -d delimiter -f field-number /path/to/filename

# example
cut -d: -f1,7 /etc/passwd
```

show needed part of file with awk

```sh
awk -F'delimiter' '{print $field-number$field-number}' /path/tofilename

# example
awk -F':' '{print $1$7}' /etc/passwd
```

##### sed

replace text in files  
`g` - globally (more than one time in line)  
without `-i` to show what will be changed

```sh
sed 's/word-to-replace/word-that-replace/g' filename
sed -i 's/word-to-replace/word-that-replace/g' filename
sed -i 's/word-to-replace/word-that-replace/g' *.cfg
sed -i 's/word-to-replace/word-that-replace/g' *

# example
sed 's/coronavirus/covid19/g' samplefile.txt
sed -i 's/coronavirus/covid19/g' samplefile.txt

# gsed examples
# gsed is macOS GNU sed
gsed -i 's/url = git@github.com:wandering-mono/url = git@github.com:monocodes/g' config
```

- `sed` command example for `/etc/apt/sources.list` to switch to location repos or main repos

  - switch to main repos

    - ```sh
                sudo sed -i 's|http://us.|http://|g' /etc/apt/sources.list
                # or
                sed -i 's/http:\/\/in./http:\/\//g' /etc/apt/sources.list
            ```

  - switch to Armenia repos

    - ```sh
                sudo sed -i 's|http://us.|http://am.|g' /etc/apt/sources.list
                # or
                sed -i 's/http:\/\/us./http:\/\/am./g' /etc/apt/sources.list
            ```

##### wc

`wc` - count anything

count how many lines in file

```sh
wc -l /path/to/filename

# example
wc -l /etc/passwd
```

count how many dirs and files

```sh
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

```sh
tar -czvf archive-name.tar.gz /path/to/dir
```

extract archive  
`-x` - extract

```sh
tar -xzvf filename
```

extract archive to some dir

```sh
tar -xzvf filename -C /path/to/dir
```

---

##### zip

create archive  
`-r` - recursively

```sh
zip -r filename.zip /path/to/dir
```

unzip for unarchive  
`-d` - to point to dir

```sh
unzip filename.zip -d /path/to/dir
```

unzip and overwrite, non-interactive

```sh
unzip -o filename.zip /path/to/dir
```

---

#### input/output redirection

##### output redirection

`>` - output command result to a file

```sh
command-name > /path/to/filename

# examples
uptime > /tmp/sysinfo.txt
ls > /tmp/sysinfo.txt
echo "text" > /tmp/sysinfo.txt
```

output command result to a file and did not overwrite its contents and just append

```sh
command-name >> /path/to/filename

# exapmle
uptime >> /tmp/sysinfo.txt
```

output command result to nowhere

```sh
command-name > /dev/null

# example
yum install vim -y > /dev/null
```

remove everything in file with `cat`

```sh
cat /dev/null > /path/to/filename

# example
cat /dev/null > /tmp/sysinfo.txt
```

redirect error output

```sh
command-name 2> /path/to/filename

# example
freeee 2>> /tmp/error.log
```

to redirect standard output `1>` (default) **and** error output `2>` use `&>`

```sh
command-name &> /path/to/filename

# examples
free -m &>> /tmp/error.log
freddfefe -m &>> /tmp/error.log
```

##### input redirection

```sh
command-name < /path/to/filename

# example
wc -l < /etc/passwd
```

---

#### time, date

check timezone

```sh
date
# or
timedatectl
```

list avalaible timezone

```sh
timedatectl list-timezones

timedatectl list-timezones | grep Berlin
```

set new timezone

```sh
sudo timedatectl set-timezone timezone-name
```

---

#### locale

show used locale

```sh
localectl
```

show installed locales

```sh
localectl list-locales
```

search for langpack and install it

```sh
# for rpm-based distros
dnf search langpacks- | grep -i en

dnf install langpacks-en
```

set locale

```sh
localectl set-locale LANG=en_US.UTF-8
```

show specific locale keymaps

```sh
localectl list-maps | grep -i us
```

set keymap locale

```sh
localectl set-keymap us
```

> fix for us locale error
>
> ```sh
> setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
> ```

```sh
echo "LANG=en_US.utf-8" | sudo tee -a /etc/environment && \
echo "LC_ALL=en_US.utf-8" | sudo tee -a /etc/environment
```

---

#### crontab examples

[crontab guru](https://crontab.guru/) - The quick and simple editor for cron schedule expressions by [Cronitor](https://cronitor.io/cron-job-monitoring?utm_source=crontabguru&utm_campaign=cronitor_top)

```sh
#       30      20      *               *       1-5     /opt/scripts/11_monit.sh
# run the script every day during monday-friday at 20:30



#       minute  hour    day of month    month   day of week # 0 for sunday
#       MM      HH      DOM             mm      DOW     COMMAND
        *       *       *               *       *       /opt/scripts/11_monit.sh &>> /var/log/monit_httpd.log
# run the script every minute
```

---

#### systemctl

list all running services

```sh
systemctl --type=service --state=running
```

list all services

```sh
systemctl --type=service --all
```

service status

```sh
systemctl status service-name
```

check service active or not

```sh
systemctl is-active service-name
```

check service in autorun or not

```sh
systemctl is-enabled service-name
```

start service and add it to autorun

```sh
sudo systemctl enable --now service-name
```

start service

```sh
systemctl start service-name
```

restart service

```sh
systemctl restart service-name
```

reload config of the service without restarting

```sh
systemctl reload service-name
```

stop service

```sh
systemctl stop service-name
```

add service to autorun

```sh
systemctl enable service-name
```

remove service from autorun

```sh
systemctl disable service-name
```

---

#### processes, top, ps

all processes path

```sh
/var/run/
```

show process `PID`

```sh
cat /var/run/process-name/process-name.pid

# example
cat /var/run/httpd/httpd.pid
```

process managers, activity monitors

```sh
top
htop
```

top for specified process

```sh
top -b | grep java
```

show all processes and exit

```sh
ps aux
```

show all processes with displaying parent processes

```sh
ps -ef
```

show all processes sorted by memory usage with `Mb` not `%`

```sh
ps -eo size,pid,user,command --sort -size | \
  awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | \
  cut -d "" -f2 | cut -d "-" -f1
```

find specific process PID and kill it  
kill the parent process

```sh
ps -ef | grep -i process-name | grep -v 'grep'
kill PID
```

forcefully kill the process but without the child processes

```sh
kill -9 PID
```

forcefully kill all child processes with filtering  

- ```sh
    ps -ef | grep -i process-name | grep -v 'grep' | awk '{print $2}' | xargs kill -9
    ```

- >`ps -ef` - list processes  
    >`grep -v 'grep'` - excludes processes with name `grep`  
    >`awk '{print $2}'` - lists only 2nd column of the output  
    >`xargs kill -9` - kills every process

list all logged in users

```sh
who
```

logout user and kill all its processes

```sh
pkill -KILL -u username
```

---

#### users & groups

which user you are now

```sh
whoami
```

show all current logged in users with useful info including ip

```sh
who
```

show current path

```sh
pws
```

show info about any user

```sh
id username
```

add user

```sh
adduser username # for ubuntu and modern rpm-based, also adds home dir
useradd username # for old centos, doesn't add home dir
```

add group

```sh
groupadd group-name
```

add user to the supplementary group without changing primary group

```sh
usermod -aG group-name username
# or
vim /etc/group
```

change current user password

```sh
passwd
```

change any user password

```sh
passwd username
```

switch to root user

```sh
sudo -i
```

switch to any user, change user

```sh
su - username
```

switch to any user if you don't know the password

```sh
sudo -i
su - username
```

delete user

```sh
userdel username
```

delete user with home dir

```sh
userdel -r username
```

delete group

```sh
groupdel group-name
```

show last users logged in into the system

```sh
last
```

show all opened files by user

```sh
lsof -u username
```

show all opened files in particular dir

```sh
lsof /path/to/dir

# example
lsof /var/www/html/images
```

> ubuntu 22 LTS default groups after install with user `username`

```sh
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

```sh
usermod -u 2005 foo
```

To assign a new `GID` to group called `foo`, enter:

```sh
groupmod -g 3000 foo
```

> Please note that all files which are located in the user’s home directory will have the file `UID` changed automatically as soon as you type above two command. However, files outside user’s home directory need to be changed manually. To manually change files with old `GID` and `UID` respectively, enter:
>
> **WARNING!** The following examples may change ownership of unwanted files on your Linux computer if not executed with care.

```sh
find / -group 2000 -exec chgrp -h foo {} \;
find / -user 1005 -exec chown -h foo {} \;
```

> The `-exec` command executes `chgrp` command or `chmod` command on each file. The `-h` option passed to the `chgrp`/`chmod` command affect each symbolic link instead of any referenced file. Use the following command to verify the same:

```sh
ls -l /home/foo/
id -u foo
id -g foo
```

search for `foo` in the passswd file

```sh
grep foo /etc/passwd
```

search for 'foo' in the group file

```sh
grep foo /etc/group
```

use the find command to locate files owned by `foo`

```sh
find / -user foo -ls
find / -group sales -ls # maybe -group foo here...
```

---

##### sudoers

>For security reasons instead of using vanilla `/etc/sudoers` file use `/etc/sudoers.d` dir and generate there sudoers settings, for example:
>
>Allow `sudo` without pass for user `username`

add passwordless sudo for user

```sh
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USER
```

append linuxbrew to root's `secure_path` in the end

- `sudo sh -c` to preserve root's `$PATH`
- `tee -a` will append to a file named like user that executes script

```sh
sudo sh -c 'echo "Defaults secure_path = $PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"' \
	| sudo tee -a /etc/sudoers.d/$USER
```

add group to sudoers file use `%`

```sh
echo "%group-name ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/group-name
```

show all `/etc/sudoers.d` files

```sh
cat /etc/sudoers.d/* # maybe working only under root
```

edit `/etc/sudoers` with default text editor

```sh
visudo
# or
vim /etc/sudoers
```

normal `sudoers` example

```sh
root ALL=(ALL) ALL
username ALL=(ALL) NOPASSWD: ALL
```

---

##### chown

change `user:group` owners of the dir or file

```sh
chown username:group-name /path/to/filename
```

`-R` - recursively, `-v` - verbose

```sh
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

```sh
# examples

chmod o-x /path/to/filename
chmod g+w /path/to/filename
```

just make file executable for user, group, others

```sh
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

```sh
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

#### lvm

##### Resizing of VM with **LVM**

- Check available free space with `vgdisplay` or `cfdisk` if there are no free space in VG

  ```sh
  sudo vgdisplay
  
  # Output
    --- Volume group ---
    VG Name               rl
    System ID             
    Format                lvm2
    Metadata Areas        1
    Metadata Sequence No  3
    VG Access             read/write
    VG Status             resizable
    MAX LV                0
    Cur LV                2
    Open LV               2
    Max PV                0
    Cur PV                1
    Act PV                1
    VG Size               <12.00 GiB
    PE Size               4.00 MiB
    Total PE              3071
    Alloc PE / Size       3071 / <12.00 GiB
    Free  PE / Size       0 / 0   
    VG UUID               nUJC6V-id1M-sAk0-gCTw-FQzr-hobx-UwPyF6
  ```

  ```sh
  sudo cfdisk
  
  # If it's online resizing and you see no free space use command to rescan disks
  echo 1 > /sys/class/block/sda/device/rescan
  
  # Output
   Disk: /dev/sda
               Size: 20 GiB, 21474836480 bytes, 41943040 sectors
                       Label: dos, identifier: 0xa01be5a7
  
      Device       Boot       Start        End    Sectors  Size  Id Type
      /dev/sda1    *           2048    2099199    2097152    1G  83 Linux
  >>  /dev/sda2             2099200   41943039   39843840   19G  8e Linux LVM 
  
   ┌────────────────────────────────────────────────────────────────────────┐
   │ Partition type: Linux LVM (8e)                                         │
   │Filesystem UUID: GtlmtF-KxKH-oAC7-yrMq-gYqb-DdVK-2re6ph		  │
   │     Filesystem: LVM2_member                                            │
   └────────────────────────────────────────────────────────────────────────┘
     [Bootable]  [ Delete ]  [ Resize ]  [  Quit  ]  [  Type  ]  [  Help  ]
     [  Write ]  [  Dump  ]
  ```

  - `vgdisplay` shows free space  
    check `LV path` of the **LV** that you want to extend

    ```sh
    sudo lvdisplay
    
    # Output
      --- Logical volume ---
      LV Path                /dev/rl/swap
      LV Name                swap
      VG Name                rl
      LV UUID                5EoWMk-xLse-soIc-5cU7-eSNE-btca-VPgaD5
      LV Write Access        read/write
      LV Creation host, time rl9-01, 2023-04-13 19:54:02 +0400
      LV Status              available
      # open                 2
      LV Size                <2.00 GiB
      Current LE             511
      Segments               1
      Allocation             inherit
      Read ahead sectors     auto
      - currently set to     256
      Block device           253:1
       
      --- Logical volume ---
      LV Path                /dev/rl/root
      LV Name                root
      VG Name                rl
      LV UUID                zbzeXH-W6Wx-qeEV-Sd2H-djOp-whwW-F9XV9S
      LV Write Access        read/write
      LV Creation host, time rl9-01, 2023-04-13 19:54:02 +0400
      LV Status              available
      # open                 1
      LV Size                10.00 GiB
      Current LE             2560
      Segments               1
      Allocation             inherit
      Read ahead sectors     auto
      - currently set to     256
      Block device           253:0
    ```

    - extend **LV**

      ```sh
      sudo lvextend -l +100%FREE -r /dev/rl/root
      ```

      >The `lvextend` command with the -l option specifies the size in extents. If you use `-L`, you need to specify the size (`+10 GB` to extend by 10 GB, for example).
      >
      >- The `+100%FREE` option indicates that all remaining free space in the volume group should be added.
      >- The `-r` option resizes the underlying file system together with the logical volume. If you skip this option, you need to use the `sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv` command separately to extend the actual file system.

  - `cfdisk` shows free space

    - choose `Device` you want to resize

    - `Resize` -> `Enter`

    - `Write` -> `Enter`

    - `Quit` -> `Enter`

    - Resize physical volume - **PV**

      - check **PV** name

        ```sh
        sudo pvdisplay
        
        # Output
          --- Physical volume ---
          PV Name               /dev/sda2
          VG Name               rl
          PV Size               <12.00 GiB / not usable 3.00 MiB
          Allocatable           yes (but full)
          PE Size               4.00 MiB
          Total PE              3071
          Free PE               0
          Allocated PE          3071
          PV UUID               GtlmtF-KxKH-oAC7-yrMq-gYqb-DdVK-2re6ph
        ```

      - resize **PV**

        ```sh
        sudo pvresize /dev/sda2
        
        # Output
          Physical volume "/dev/sda2" changed
          1 physical volume(s) resized or updated / 0 physical volume(s) not resized
        ```

      - check **PV** size again

        ```sh
        sudo pvdisplay
        
        # Output
          --- Physical volume ---
          PV Name               /dev/sda2
          VG Name               rl
          PV Size               <19.00 GiB / not usable 2.00 MiB
          Allocatable           yes 
          PE Size               4.00 MiB
          Total PE              4863
          Free PE               1792
          Allocated PE          3071
          PV UUID               GtlmtF-KxKH-oAC7-yrMq-gYqb-DdVK-2re6ph
        ```

      - check added free space to **VG**

        ```sh
        sudo vgdisplay
        
        # Output
          --- Volume group ---
          VG Name               rl
          System ID             
          Format                lvm2
          Metadata Areas        1
          Metadata Sequence No  4
          VG Access             read/write
          VG Status             resizable
          MAX LV                0
          Cur LV                2
          Open LV               2
          Max PV                0
          Cur PV                1
          Act PV                1
          VG Size               <19.00 GiB
          PE Size               4.00 MiB
          Total PE              4863
          Alloc PE / Size       3071 / <12.00 GiB
          Free  PE / Size       1792 / 7.00 GiB
          VG UUID               nUJC6V-id1M-sAk0-gCTw-FQzr-hobx-UwPyF6
        ```

      - extend **LV**

        ```sh
        sudo lvdisplay # to get LV path
        
        sudo lvextend -l +100%FREE -r /dev/rl/root
        
        # Output
          Size of logical volume rl/root changed from 10.00 GiB (2560 extents) to 17.00 GiB (4352 extents).
          Logical volume rl/root successfully resized.
        meta-data=/dev/mapper/rl-root    isize=512    agcount=4, agsize=655360 blks
                 =                       sectsz=512   attr=2, projid32bit=1
                 =                       crc=1        finobt=1, sparse=1, rmapbt=0
                 =                       reflink=1    bigtime=1 inobtcount=1
        data     =                       bsize=4096   blocks=2621440, imaxpct=25
                 =                       sunit=0      swidth=0 blks
        naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
        log      =internal log           bsize=4096   blocks=2560, version=2
                 =                       sectsz=512   sunit=0 blks, lazy-count=1
        realtime =none                   extsz=4096   blocks=0, rtextents=0
        data blocks changed from 2621440 to 4456448
        ```

---

#### grub

force boot with specific kernel

**Ubuntu**

1. edit grub config  

    ```sh
    vim /etc/default/grub
    ```

2. in that file edit this line, in menu count starts with 0  

    ```sh
    GRUB_DEFAULT="1>2"
    ```

3. update grub config  

    ```sh
    update-grub
    ```

**Fedora**

1. don't need to change anything in grub config, just use the command  

    ```sh
    grub2-set-default number
    
    # example
    grub2-set-default 1
    ```

2. check the boot  

    ```sh
    reboot now
    ```

3. if something goes wrong, go to the hypervisor and press `ESC` when booting or hold `Shift` for older systems

#### gparted

[How to resize a root partition in Ubuntu Linux GPT.md](guides/How to resize a root partition in Ubuntu Linux GPT.md)

#### df

show partitions

```sh
df -h
```

#### fdisk

show disks

```sh
fdisk -l
```

show disks with `ls` (including unmounted)

```sh
ls -lh /dev/ | grep disk
```

start disk partitioning

```sh
fdisk /dev/disk-name

# example
fdisk /dev/xvdf
```

> partitioning example

```sh
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

```sh
mkfs # press Tab 2 times
```

do ext4 formatting

```sh
mkfs.ext4 /dev/disk-name

# example
mkfs.ext4 /dev/xvdf1
```

---

#### mount, umount, mounting

mount dir to partition temporarily

```sh
mount /dev/xvdf1 /var/www/html/images/
```

check mounting

```sh
df -h
```

unmount dir from partition

```sh
umount /var/www/html/images/
```

mount dir to partition permanently

```sh
vim /etc/fstab

# add this to file
/dev/xvdf1      /var/www/html/images    ext4    defaults        0 0
```

`/etc/fstab` example

```sh
# Created by anaconda on Sun Nov 14 11:52:41 2021
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=44a6a613-4e21-478b-a909-ab653c9d39df /                       xfs     defaults        0 0
/dev/xvdf1      /var/www/html/images    ext4    defaults        0 0
/dev/xvdg1      /var/lib/mysql  ext4    defaults        0 0
```

**DON'T FORGET** after that mount all mounts from `/etc/fstab`

```sh
mount -a
```

---

### network

show network adapters

```sh
ip a
ip r
ip address

# deprecated starting Ubuntu 20
ifconfig
```

restarting network

```sh
# Ubuntu 22
sudo systemctl restart systemd-networkd
```

---

#### network Ubuntu 22

edit network config

```sh
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

```sh
sudo netplan apply
# or debug
sudo netplan --debug apply
```

check network adapters

```sh
ip a
```

---

#### network Rocky Linux 9

restart network

```sh
sudo systemctl restart NetworkManager
```

---

#### network CentOS 7

choose adapter config to edit

```sh
sudo vim /etc/sysconfig/network-scripts/ifcfg-*
```

> examples

- ```sh
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

- ```sh
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

```sh
sudo systemctl restart network
```

check network adapters

```sh
ip a
```

---

#### hostname, hostnamectl

show hostname

```sh
hostnamectl hostname
```

change hostname

```sh
# Ubuntu 22
sudo hostnamectl hostname web03

# CentOS 7
sudo hostnamectl set-hostname web03
```

> NOTE about `hostname` command
>
>   ```sh
>   hostname your-hostname
>   ```
>
> changes only before reboot, non-persistent

---

#### ssh

##### ssh paths

ssh config path

```sh
/etc/ssh/sshd_config
```

check all ssh settings

```sh
sudo sshd -T
```

##### ssh-keygen

###### generate secured keys and use ssh-agent and `~/.ssh/config`

1. Generate **Ed25519** key pair

   ```sh
   ssh-keygen -t ed25519 -a 100 -C "user@hostname"
   ```

2. Or generate **RSA** key pair if you need compatibility

   ```sh
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

```sh
ssh-keygen
```

generate new pair of ssh keys in specified dir

```sh
ssh-keygen

# Enter file in which to save the key (/Users/mono/.ssh/id_rsa):
/Users/mono/.ssh/aws/vpro-codecommit_rsa
```

public key default location

```sh
cat ~/.ssh/id_rsa.pub
```

identification (private key or closed key)

```sh
cat ~/.ssh/id_rsa
```

copy public key to remote server for specific user

```sh
ssh-copy-id username@remote_host
```

copy public key to remote server without ssh-copy-id

```sh
cat ~/.ssh/id_rsa.pub | ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

disable password authentication on remote server

```sh
sudo nano /etc/ssh/sshd_config

# edit in file
PasswordAuthentication no

sudo service ssh restart
sudo service sshd restart # rpm-based distro
```

list all local private and public ssh keys

```sh
ls -l ~/.ssh/
ls -l ~/.ssh/id_*
```

change the passphrase for default SSH private key

```sh
ssh-keygen -p
```

change the passphrase for specific private key

```sh
ssh-keygen -p -f ~/.ssh/private_key_name
# or
ssh-keygen -f private_key_name -p
```

remove a passphrase from private key

```sh
ssh-keygen -f ~/.ssh/private_key_name -p
# or
ssh-keygen -f ~/.ssh/private_key_name -p -N ""
# for default private key
ssh-keygen -p -N ""
```

ssh to host with specific public key

```sh
ssh -i ~/.ssh/id_rsa_name username@hostname

# aws example
ssh -i ~/.ssh/key-name.pem -o ServerAliveInterval=200 username@ip
```

---

##### ssh-agent

**SSH-agent** is manager for ssh-keys  
ssh-keys should *not* get automatically added to the agent just because you SSH'ed to a server...

list the ssh-agent keys

```sh
ssh-add -l
```

delete all ssh-agent-keys

```sh
ssh-add -D
```

---

###### SSH-agent forwarding, ProxyJump

> Best way to go through **Bastion-host** is to use **SSH ProxyJump**

[Про SSH Agent](https://habr.com/ru/companies/skillfactory/articles/503466/) - хорошая статья на [habr.com](habr.com).

Instead of forwarding **SSH-agent** and all ssh keys use **ProxyJump**

1. Connect to remote host through **Bastion-host**

   ```sh
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

```sh
ssh cloud.computer.internal
```

---

##### scp

push file to another host

```sh
scp filename username@hostname:/absolute/path/to/dir

# example
scp testfile.txt devops@web01:/tmp
```

fetch file from another host

```sh
scp username@hostname:/absolute/path/to/filename

# example
scp devops@web01:/home/devops/testfile.txt .
```

push file to another host with specified key

```sh
scp -i /path/to/key-filename /path/to/filename username@hostname:/path/to/dest

# aws example
scp -i ~/.ssh/aws/bastion-key.pem ~/.ssh/aws/wave-key.pem ec2-user@52.53.251.116:/home/ec2-user/
```

---

#### curl, wget

> `curl` and `wget` to download something
>
> `curl` also to analyse websites

download anything with `curl`

```sh
curl https://link -o filename

# example
curl https://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/aarch64/os/Packages/t/tree-2.1.0-1.fc38.aarch64.rpm -o tree-2.1.0-1.fc38.aarch64.rpm
```

check curl

```sh
curl parrot.live
```

request webpage and get response and all headers

```sh
curl -i address-name

# example
curl -i http://nginx-handbook.test

# output
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 12 May 2023 14:49:27 GMT
Content-Type: text/plain
Content-Length: 41
Connection: keep-alive

this will be logged to the default file.
```

request webpage and get only all headers

```sh
curl -I address-name

# example
curl -i http://nginx-handbook.test

# output
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 12 May 2023 14:50:47 GMT
Content-Type: text/plain
Content-Length: 41
Connection: keep-alive
```

check working webserver (**httpd**, **apache2**, **nginx**)

```sh
curl -i localhost
```

check website element with custom header

```sh
# example with gzip compression
curl -I -H "Accept-Encoding: gzip" http://nginx-handbook.test/mini.min.css
```

download file with `wget`

```sh
wget filelink
```

---

#### open ports

##### nmap

show open ports of localhost

```sh
nmap localhost
```

show open ports of local server

```sh
nmap hostname

# example
nmap db01
```

##### netstat

show all open TCP ports

```sh
netstat -antp

# example
netstat -antp | grep apache2
```

search `PID`, and use it to know on what port app is running, if you don't see process name with `netstat`

```sh
ps -ef | grep apache2 # copy PID

netstat -antp | grep PID
```

##### ss

show all open TCP ports

```sh
ss -tunlp

# example
ss -tunlp | grep 80
```

##### telnet

use telnet to check the connection via any port

```sh
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

```sh
dig adress-name

# example
dig google.com
```

`nslookup` - dns lookup (older version of dig)

```sh
nslookup address-name

# example
nslookup google.com

# check NS example
nslookup -type=ns kubevpro.wandering-mono.top
```

install `nslookup` on rpm-based distro

```sh
sudo dnf install -y bind-utils
```

##### traceroute, tracert, mtr

show path to the server and latency problems

```sh
traceroute address-name

# example
traceroute mirrors.fedoraproject.org
traceroute google.com
```

`mrt` - traceroute + ping

show path to the server and latency problems online (live)

```sh
mrt adress-name

# example
mtr google.com
```

##### gateway lookup

show gateways

```sh
route -n
route
```

##### arp

show arp table

```sh
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

```sh
cat /etc/apt/sources.list
```

before installing any package update repos list

```sh
apt update
```

update all packages

```sh
apt upgrade
```

update specific package

```sh
apt upgrade package-name
```

search package from avalaible repos

```sh
apt search package-name
```

search package and if the list is too big view it with pager

```sh
apt search nodejs | less
```

install package without prompts

```sh
apt install package-name -y
```

reinstall package

```sh
apt reinstall package-name
```

remove package

```sh
apt remove package-name
```

remove package and all its configs and data

```sh
apt purge package-name
```

list all available *Group Packages*

```sh
apt grouplist
```

install all the packages in a group

```sh
apt groupinstall group-name
```

show enabled apt repos

```sh
apt repolist
```

clean apt cache

```sh
apt clean all
```

show apt history

```sh
apt history
```

show info of the package

```sh
apt show package-name
```

---

##### apt autoremove

delete all unused packages that was installed as dependencies

```sh
apt autoremove
```

delete all unused packages that was installed as dependencies with all config files and data

```sh
apt autoremove --purge
# 1st preffered or
apt autopurge
```

---

##### apt-mark

> Hold specific packages from upgrading. Useful to not update the kernel packages.

```sh
apt-mark hold package-name

# example for ubuntu m1 vm
apt-mark hold linux-modules-5.4.0-137-generic linux-headers-5.4.0-137 linux-headers-5.4.0-137-generic linux-headers-generic linux-image-unsigned-5.4.0-137-generic linux-modules-5.4.0-137-generic
```

---

#### dpkg

> `dpkg` - package manager for local packages

install downloaded package with dpkg

```sh
dpkg -i filename
```

show all installed packages

```sh
dpkg -l
```

search for specific installed package

```sh
dpkg -l | grep -i package-name
```

remove package

```sh
dpkg -r package-name
```

---

### rpm-based distros (RHEL, CentOS, Amazon Linux, etc)

#### dnf, yum

> Almost all these commands applied to `yum`.

---

##### paths yum

repos location

```sh
/etc/yum.repos.d/
```

if there are a problem with repos metalink, comment metalink and enter baseurl

```sh
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

```sh
dnf search package-name
```

install something without prompts

```sh
dnf install -y package-name
```

reinstall package

```sh
dnf reinstall package-name
```

remove package and its config files not touched by user

```sh
dnf remove package-name
```

update all packages

```sh
dnf update
```

update specific package

```sh
dnf update package-name
```

list all avalaible *Group Packages*

```sh
dnf grouplist
```

install all the packages in a group

```sh
dnf groupinstall group-name
```

show enabled dnf repos

```sh
dnf repolist
```

clean dnf cache

```sh
dnf clean all
```

show history of dnf

```sh
dnf history
```

show info of package

```sh
dnf info package-name
```

create metadata cache (dnf will do it automatically)

```sh
dnf makecache
```

exclude package in dnf from updating

```sh
# example for kernel updates
echo "exclude=kernel*" >> /etc/dnf/dnf.conf
```

exclude package in yum from updating

```sh
# deprecated in Fedora 35 and maybe previously versions
echo "exclude=kernel*" >> /etc/yum.conf
```

---

#### epel

**epel** - additional package repository with commonly used software

```sh
sudo dnf install epel-release
sudo dnf makecache
```

**Rocky Linux 9**

```sh
sudo dnf -y install epel-release
sudo dnf makecache
```

**Amazon Linux 2**

```sh
sudo amazon-linux-extras install epel -y
```

**RHEL 8**

```sh
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
```

**RHEL 7**

```sh
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

**CentOS 8**

```sh
sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
sudo dnf config-manager --set-enabled PowerTools
```

**CentOS 7**

```sh
sudo yum -y install epel-release
```

List repositories that are turned on  
To verify that the EPEL repository is turned on, run the repolist command:

```sh
sudo yum repolist
```

---

#### rpm

> `rpm` - package manager for local packages

install downloaded package  
`-i` - install, `-v` - verbose, `-h` - human readable

```sh
rmp -ivh package-name

# examples
rpm -ivh mozilla-mail-1.7.5-17.i586.rpm
rpm -ivh --test mozilla-mail-1.7.5-17.i586.rpm
```

show all installed rpms

```sh
rpm -qa

# examples
rpm -qa
rpm -qa | less
```

show latest installed rpms

```sh
rpm -qa --last
```

upgrade installed package

```sh
rpm -Uvh package-name

# examples
rpm -Uvh mozilla-mail-1.7.6-12.i586.rpm
rpm -Uvh --test mozilla-mail-1.7.6-12.i586.rpm
```

remove installed package

```sh
rpm -ev package-name

# example
rpm -ev mozilla-mail
```

remove installed package without checking its dependencies

```sh
rpm -ev --nodeps

# example
rpm -ev --nodeps mozilla-mail
```

show info about installed package

```sh
rpm -qi package-name

# example
rpm -qi mozilla-mail
```

find out what package owns the file

```sh
rpm -qf /path/to/dir

# examples
rpm -qf /etc/passwd
```

show list of configuration file(s) for a package

```sh
rpm -qc package-name

# example
rpm -qc httpd
```

show list of configuration files for a command

```sh
rpm -qcf /path/to/filename

# example
rpm -qcf /usr/X11R6/bin/xeyes
```

show what dependencies a rpm file has

```sh
rpm -qpR filename.rpm
rpm -qR package-name

# examples
rpm -qpR mediawiki-1.4rc1-4.i586.rpm
rpm -qR bash
```

##### remove gpg-key and repo

- Remove installed gpg-key and repo

  1. List last installed packages

     ```sh
     sudo rpm -qa --last | grep gpg
     ```

  2. Remove gpg

     ```sh
     sudo rpm -ev package-name
     ```

  3. Remove repo

     ```sh
     sudo rm -rf /etc/yum.repos.d/repo-name.repo
     ```

---

#### firewalld

open 443, https

```sh
sudo firewall-cmd --add-service=http --add-service=https --permanent
sudo systemctl restart firewalld
```

firewalld open specific port, for example `mysql` (`mariadb`)

```sh
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
```

---

## third-party packages

### useful packages

`bash-completion` (used for `docker`, `kubectl` for example)

```sh
sudo dnf install bash-completion

sudo apt install bash-completion
```

`colordiff` - coloured `diff` - packages for file comparisons  
`-y` - for side-by-side comparison

```sh
colordiff -y /path/to/filename /path/to/filename
```

`stress` - utility to stress a hardware

start stress on cpu with 4 processes for 300 seconds in background

```sh
nohup stress -c 4 -t 300 &
```

small `stress` script to test monitoring alarms

`stress.sh`

```bash
#!/bin/bash
sudo stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 60 && sleep 60 && stress -c 4 -t 360 && sleep  && stress -c 4 -t 460 && sleep 30 && stress -c 4 -t 360 && sleep 60
```

```sh
# run it in background
nohup ./stress.sh &
```

---

### jdk

Installation of different versions of `java` here [maven.md](maven.md)

check current main version

```sh
java -version
```

check installed jdk versions

```sh
ls /usr/lib/jvm
```

> example  
> here installed openjdk-8-jdk `java-1.8.0-openjdk-amd64` and openjdk-11-jdk `java-1.11.0-openjdk-amd64`

```sh
ls /usr/lib/jvm
java-1.11.0-openjdk-amd64  java-11-openjdk-amd64  openjdk-11
java-1.8.0-openjdk-amd64   java-8-openjdk-amd64
```

---

### Node.js

#### Node.js install Ubuntu

**Node.js v20.x**:

Using Ubuntu

```sh
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Using Debian, as root

```sh
curl -fsSL https://deb.nodesource.com/setup_20.x | bash - &&\
apt-get install -y nodejs
```

**Node.js v19.x**:

Using Ubuntu

```sh
curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Using Debian, as root

```sh
curl -fsSL https://deb.nodesource.com/setup_19.x | bash - &&\
apt-get install -y nodejs
```

**Node.js v18.x**:

Using Ubuntu

```sh
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Using Debian, as root

```sh
curl -fsSL https://deb.nodesource.com/setup_18.x | bash - &&\
apt-get install -y nodejs
```

**Node.js v16.x**:

Using Ubuntu

```sh
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Using Debian, as root

```sh
curl -fsSL https://deb.nodesource.com/setup_16.x | bash - &&\
apt-get install -y nodejs
```

**Node.js LTS (v18.x)**:

Using Ubuntu

```sh
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Using Debian, as root

```sh
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - &&\
apt-get install -y nodejs
```

**Node.js Current (v20.x)**:

Using Ubuntu

```sh
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Using Debian, as root

```sh
curl -fsSL https://deb.nodesource.com/setup_current.x | bash - &&\
apt-get install -y nodejs
```

***Optional***: install build tools

To compile and install native addons from npm you may also need to install build tools:

use `sudo` on Ubuntu or run this as root on debian

```sh
apt-get install -y build-essential
```

#### Node.js unintall Ubuntu

To completely remove Node.js installed from the deb.nodesource.com package methods above:

use `sudo` on Ubuntu or run this as root on debian

```sh
apt-get purge nodejs &&\
rm -r /etc/apt/sources.list.d/nodesource.list
```

---

PM2

**PM2** - is a daemon process manager that will help you manage and keep your application online 24/7.

install PM2

```sh
sudo npm install -g pm2
```

monitor all launched node.js processes

```sh
pm2 monit
```

show all launched node.js processes

```sh
pm2 list
```

act on node.js processes

```sh
pm2 start app.js
pm2 stop
pm2 restart
pm2 delete
```

---

### php

install php-fpm in Ubuntu

```sh
sudo apt install php-fpm -y
```

start php app inside the php app dir

```sh
php -S localhost:8000
```

If you have multiple PHP-FPM versions installed, you can simply list all the socket file locations by executing the following command:

```sh
sudo find / -name *fpm.sock

# output
/run/php/php8.1-fpm.sock
/run/php/php-fpm.sock
/var/lib/dpkg/alternatives/php-fpm.sock
```

---

### apache2, httpd

default path for website for **apache2**, **httpd**

```sh
/var/www/html
```

---

### tomcat

default path for website for tomcat  
`?` - **tomcat** version

```sh
/var/lib/tomcat?/webapps/
/var/lib/tomcat8/webapps/
```

---

## network notes

### private IP ranges

Class A - `10.0.0.0 - 10.255.255.255`

Class B - `172.16.0.0 - 172.31.255.255`

Class C - `192.168.0.0 - 192.168.255.255`

---

### ifconfig.io

simply check your ip

```sh
curl -4 icanhazip.com
```

[ifconfig.io](https://ifconfig.io/) - great diagnostic website. You can diagnose just with `curl` command from anywhere. Great for testing proper VPN connection.

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

- **Vagrant** for local
- **Terraform** for Cloud

- **Ansible** for Servers

- **Cloudformation** for AWS

---

### bash '', ""

[Difference between single and double quotes in Bash](https://stackoverflow.com/questions/6697753/difference-between-single-and-double-quotes-in-bash)

The [accepted answer](https://stackoverflow.com/a/6697781/6862601) is great. I am making a table that helps in quick comprehension of the topic. The explanation involves a simple variable `a` as well as an indexed array `arr`.

If we set

```bash
a=apple      # a simple variable
arr=(apple)  # an indexed array with a single element
```

and then `echo` the expression in the second column, we would get the result / behavior shown in the third column. The fourth column explains the behavior.

| #    | Expression     | Result      | Comments                                                     |
| ---- | -------------- | ----------- | ------------------------------------------------------------ |
| 1    | `"$a"`         | `apple`     | variables are expanded inside `""`                           |
| 2    | `'$a'`         | `$a`        | variables are not expanded inside `''`                       |
| 3    | `"'$a'"`       | `'apple'`   | `''` has no special meaning inside `""`                      |
| 4    | `'"$a"'`       | `"$a"`      | `""` is treated literally inside `''`                        |
| 5    | `'\''`         | **invalid** | can not escape a `'` within `''`; use `"'"` or `$'\''` (ANSI-C quoting) |
| 6    | `"red$arocks"` | `red`       | `$arocks` does not expand `$a`; use `${a}rocks` to preserve `$a` |
| 7    | `"redapple$"`  | `redapple$` | `$` followed by no variable name evaluates to `$`            |
| 8    | `'\"'`         | `\"`        | `\` has no special meaning inside `''`                       |
| 9    | `"\'"`         | `\'`        | `\'` is interpreted inside `""` but has no significance for `'` |
| 10   | `"\""`         | `"`         | `\"` is interpreted inside `""`                              |
| 11   | `"*"`          | `*`         | glob does not work inside `""` or `''`                       |
| 12   | `"\t\n"`       | `\t\n`      | `\t` and `\n` have no special meaning inside `""` or `''`; use ANSI-C quoting |
| 13   | `"`echo hi`"`  | `hi`        | ```` and `$()` are evaluated inside `""` (backquotes are retained in actual output) |
| 14   | `'`echo hi`'`  | ``echo hi`` | ```` and `$()` are not evaluated inside `''` (backquotes are retained in actual output) |
| 15   | `'${arr[0]}'`  | `${arr[0]}` | array access not possible inside `''`                        |
| 16   | `"${arr[0]}"`  | `apple`     | array access works inside `""`                               |
| 17   | `$'$a\''`      | `$a'`       | single quotes can be escaped inside ANSI-C quoting           |
| 18   | `"$'\t'"`      | `$'\t'`     | ANSI-C quoting is not interpreted inside `""`                |
| 19   | `'!cmd'`       | `!cmd`      | history expansion character `'!'` is ignored inside `''`     |
| 20   | `"!cmd"`       | `cmd args`  | expands to the most recent command matching `"cmd"`          |
| 21   | `$'!cmd'`      | `!cmd`      | history expansion character `'!'` is ignored inside ANSI-C quotes |

---

See also:

- [ANSI-C quoting with `$''` - GNU Bash Manual](https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html)
- [Locale translation with `$""` - GNU Bash Manual](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html#Locale-Translation)
- [A three-point formula for quotes](https://stackoverflow.com/a/42104627/6862601)

**Accepted answer**

Single quotes won't interpolate anything, but double quotes will. For example: variables, backticks, certain `\` escapes, etc.

Example:

```bash
$ echo "$(echo "upg")"
upg
$ echo '$(echo "upg")'
$(echo "upg")
```

The Bash manual has this to say:

> [3.1.2.2 Single Quotes](http://www.gnu.org/software/bash/manual/html_node/Single-Quotes.html)
>
> Enclosing characters in single quotes (`'`) preserves the literal value of each character within the quotes. A single quote may not occur between single quotes, even when preceded by a backslash.
>
> [3.1.2.3 Double Quotes](http://www.gnu.org/software/bash/manual/html_node/Double-Quotes.html)
>
> Enclosing characters in double quotes (`"`) preserves the literal value of all characters within the quotes, with the exception of `$`, \`, \\, and, when history expansion is enabled, `!`. The characters `$` and \` retain their special meaning within double quotes (see [Shell Expansions](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html#Shell-Expansions)). The backslash retains its special meaning only when followed by one of the following characters: `$`, \`, `"`, \\, or newline. Within double quotes, backslashes that are followed by one of these characters are removed. Backslashes preceding characters without a special meaning are left unmodified. A double quote may be quoted within double quotes by preceding it with a backslash. If enabled, history expansion will be performed unless an `!` appearing in double quotes is escaped using a backslash. The backslash preceding the `!` is not removed.
>
> The special parameters `*` and `@` have special meaning when in double quotes (see [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html#Shell-Parameter-Expansion)).

---

### sed '', ""

[Escaping ' (single quote) in sed replace string](https://unix.stackexchange.com/questions/542454/escaping-single-quote-in-sed-replace-string)

You don't need to escape in sed, where `'` has no special significance. You need to escape it in bash.

```bash
$ sed -e "s/'/singlequote/g" <<<"'"
singlequote
```

You can see here that the double quotes protect the single quote from bash, and sed does fine with it. Here's what happens when you switch the single quotes.

```bash
$ sed -e 's/'/singlequote/g' <<<"'"
>
```

The strange thing about `'` in bourne like shells (all?) is that it functions less like `"` and more like a flag to disable other character interpretation until another `'` is seen. If you enclose it in double quotes it won't have it's special significance. Observe:

```bash
$ echo 'isn'"'"'t this hard?'
isn't this hard?
```

You can also escape it with a backslash as shown in the other answer. But you have to *leave* the single quoted block before that will work. So while this seems like it would work:

```bash
echo '\''
```

it does not; the first `'` disables the meaning of the `\` character.

I suggest you take a different approach. `sed` expressions can be specified as command line arguments - but at the expense of having to escape from the shell. It's not bad to escape a short and simple sed expression, but yours is pretty long and has a lot of special characters.

I would put your `sed` command in a file, and invoke `sed` with the `-f` argument to specify the command file instead of specifying it at the command line. <http://man7.org/linux/man-pages/man1/sed.1.html> or `man sed` will go into detail. This way the `sed` commands aren't part of what the shell sees (it only sees the filename) and the shell escaping conundrum disappears.

```bash
$ cat t.sed
s/'*/singlequote(s)/g

$ sed -f t.sed <<<"' ' '''"
singlequote(s) singlequote(s) singlequote(s)
```

---

## guides

### dependencies version ranges and requirements syntax

#### [package.json](https://docs.npmjs.com/cli/v9/configuring-npm/package-json)

See [semver](https://github.com/npm/node-semver#versions) for more details about specifying version ranges.

- `version` Must match `version` exactly
- `>version` Must be greater than `version`
- `>=version` etc
- `<version`
- `<=version`
- `~version` "Approximately equivalent to version" See [semver](https://github.com/npm/node-semver#versions)
- `^version` "Compatible with version" See [semver](https://github.com/npm/node-semver#versions)
- `1.2.x` 1.2.0, 1.2.1, etc., but not 1.3.0
- `http://...` See 'URLs as Dependencies' below
- `*` Matches any version
- `""` (just an empty string) Same as `*`
- `version1 - version2` Same as `>=version1 <=version2`.
- `range1 || range2` Passes if either range1 or range2 are satisfied.
- `git...` See 'Git URLs as Dependencies' below
- `user/repo` See 'GitHub URLs' below
- `tag` A specific version tagged and published as `tag` See [`npm dist-tag`](https://docs.npmjs.com/cli/v9/commands/npm-dist-tag)
- `path/path/path` See [Local Paths](https://docs.npmjs.com/cli/v9/configuring-npm/package-json#local-paths) below

For example `package.json`, these are all valid:

```json
{
  "dependencies": {
    "foo": "1.0.0 - 2.9999.9999",
    "bar": ">=1.0.2 <2.1.2",
    "baz": ">1.0.2 <=2.3.4",
    "boo": "2.0.1",
    "qux": "<1.0.0 || >=2.3.1 <2.4.5 || >=2.5.2 <3.0.0",
    "asd": "http://asdf.com/asdf.tar.gz",
    "til": "~1.2",
    "elf": "~1.2.3",
    "two": "2.x",
    "thr": "3.3.x",
    "lat": "latest",
    "dyl": "file:../dyl"
  }
}
```

---

### sed guide

[How to use sed to find and replace text in files in Linux / Unix shell](https://www.cyberciti.biz/faq/how-to-use-sed-to-find-and-replace-text-in-files-in-linux-unix-shell/)

am a new Linux user. I wanted to find the text called “foo” and replaced to “bar” in the file named “hosts.txt.” How do I use the sed command to find and replace text/string on Linux or UNIX-like system?

The sed stands for stream editor. It reads the given file, modifying the input as specified by a list of sed commands. By default, the input is written to the screen, but you can force to update file.

#### Find and replace text within a file using sed command

The procedure to change the text in files under Linux/Unix using sed:

1. Use Stream EDitor (sed) as follows:
2. `sed -i 's/old-text/new-text/g' input.txt`
3. The s is the substitute command of sed for find and replace
4. It tells sed to find all occurrences of ‘old-text’ and replace with ‘new-text’ in a file named input.txt
5. Verify that file has been updated:
6. **more input.txt**

Let us see syntax and usage in details.

| Tutorial details  |                                                              |
| :---------------: | ------------------------------------------------------------ |
| Difficulty level  | [Easy](https://www.cyberciti.biz/faq/tag/easy/)              |
|  Root privileges  | No                                                           |
|   Requirements    | Linux or Unix terminal                                       |
|     Category      | [Linux shell scripting](https://bash.cyberciti.biz/guide/Main_Page) |
|   Prerequisites   | sed utility                                                  |
| OS compatibility  | BSD • [Linux](https://www.cyberciti.biz/faq/category/linux/) • [macOS](https://www.cyberciti.biz/faq/category/mac-os-x/) • [Unix](https://www.cyberciti.biz/faq/category/unix/) • WSL |
| Est. reading time | 4 minutes                                                    |

#### Syntax: sed find and replace text

The syntax is:

```sh
sed 's/word1/word2/g' input.file
## *BSD/macOS sed syntax ##
sed 's/word1/word2/g' input.file > output.file
## GNU/Linux sed syntax ##
sed -i 's/word1/word2/g' input.file
sed -i -e 's/word1/word2/g' -e 's/xx/yy/g' input.file
## Use + separator instead of / ##
sed -i 's+regex+new-text+g' file.txt
```

The above replace all occurrences of characters in word1 in the pattern space with the corresponding characters from word2.

#### Examples that use sed to find and replace

Let us [create a text file](https://www.cyberciti.biz/faq/create-a-file-in-linux-using-the-bash-shell-terminal/) called hello.txt as follows:

```sh
cat hello.txt
```

Sample file:

```properties
The is a test file created by nixCrft for demo purpose.
foo is good.
Foo is nice.
I love FOO.
```

I am going to use s/ for substitute the found expression foo with bar as follows:

```sh
sed 's/foo/bar/g' hello.txt
```

Sample outputs:

```properties
The is a test file created by nixCrft for demo purpose.
bar is good.
Foo is nice.
I love FOO.
```

To update file pass the -i option when using GNU/sed version:

```sh
sed -i 's/foo/bar/g' hello.txt$ cat hello.txt
```

The g/ means global replace i.e. find all occurrences of foo and replace with bar using sed. If you removed the /g only first occurrence is changed. For instance:

```sh
sed -i 's/foo/bar/' hello.txt
```

The / act as delimiter characters. [To match all cases of foo (foo, FOO, Foo, FoO) add I (capitalized I) option](https://www.cyberciti.biz/faq/unixlinux-sed-case-insensitive-search-replace-matching/) as follows:

```sh
sed -i 's/foo/bar/g**I**' hello.txt$ cat hello.txt
```

Sample outputs:

```properties
The is a test file created by nixCrft for demo purpose.
bar is good.
bar is nice.
I love bar.
```

#### A note about *BSD and macOS sed version

Please note that the BSD implementation of sed (FreeBSD/OpenBSD/NetBSD/MacOS and co) does NOT support case-insensitive matching including file updates with the help of -i option. Hence, you need to install gnu sed. Run the following command on Apple macOS (first [set up home brew on macOS](https://www.cyberciti.biz/faq/how-to-install-homebrew-on-macos-package-manager/)):

```sh
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
```

#### `sed` command problems

Consider the following text file:
`$ **cat input.txt**http:// is outdate.Consider using https:// for all your needs.`
Find word ‘<http://>’ and replace with ‘<https://www.cyberciti.biz>’:

```sh
sed 's/**http://**/**https://www.cyberciti.biz**/g' input.txt
```

You will get an error that read as follows:

```sh
sed: 1: "s/http:///https://www.c ...": bad flag in substitute command: '/'
```

Our syntax is correct but the / delimiter character is also part of word1 and word2 in above example. Sed command allows you to change the delimiter / to something else. So I am going to use +:

```sh
sed 's+**http://**+**https://www.cyberciti.biz**+g' input.txt
```

Sample outputs:

```sh
https://www.cyberciti.biz is outdate.
Consider using https:// for all your needs.
```

#### How to use sed to match word and perform find and replace

In this example only find word ‘love’ and replace it with ‘sick’ if line content a specific string such as FOO:

```sh
sed -i -e '/FOO/s/love/sick/' input.txt
```

Use [cat command](https://www.cyberciti.biz/faq/linux-unix-appleosx-bsd-cat-command-examples/) to verify new changes:

```sh
cat input.txt
```

#### Recap and conclusion – Using sed to find and replace text in given files

The general syntax is as follows:

```sh
## find word1 and replace with word2 using sed ##
sed -i 's/word1/word2/g' input
## you can change the delimiter to keep syntax simple ##
sed -i 's+word1+word2+g' input
sed -i 's_word1_word2_g' input
## you can add I option to GNU sed to case insensitive search ##
sed -i 's/word1/word2/gI' input
sed -i 's_word1_word2_gI' input
```

See [BSD (used on macOS too)](https://www.freebsd.org/cgi/man.cgi?sed) sed or [GNU](https://www.gnu.org/software/sed/manual/sed.html) sed man page by typing the following [man command](https://bash.cyberciti.biz/guide/Man_command)/info command or [help command](https://bash.cyberciti.biz/guide/Help_command):

```sh
man sed # gnu sed options #$ sed --help$ info sed
```

**About the author:** Vivek Gite is the founder of nixCraft, the oldest running blog about Linux and open source. He wrote more than 7k+ posts and helped numerous readers to master IT topics. Join the nixCraft community via [RSS Feed](https://www.cyberciti.com/atom/atom.xml) or [Email Newsletter](https://newsletter.cyberciti.com/subscription?f=1ojtmiv8892KQzyMsTF4YPr1pPSAhX2rq7Qfe5DiHMgXwKo892di4MTWyOdd976343rcNR6LhdG1f7k9H8929kMNMdWu3g).

---

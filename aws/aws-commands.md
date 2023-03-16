---
title: aws-commands
categories:
  - software
  - notes
  - guides
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# aws-commands

- [aws-commands](#aws-commands)
  - [Amazon Linux 2 AMIs](#amazon-linux-2-amis)
    - [amazon-linux-extras](#amazon-linux-extras)
  - [Amazon EFS](#amazon-efs)
    - [amazon-efs-utils](#amazon-efs-utils)
    - [mount EFS volume](#mount-efs-volume)
  - [AWS Network](#aws-network)

## instances deploying

### ssh to aws instances

ssh to aws instance

```bash
ssh -i ~/.ssh/key-name.pem -o ServerAliveInterval=200 username@ip
```

username for different OS

-   `centos` - CentOS 7
-   `ubuntu` - Ubuntu 18-22
-   `ec2-user` - Amazon Linux 2

---

### user-data

check the user-data provided during deployment and debug it

```bash
curl http://169.254.169.254/latest/user-data
```

---

## Amazon Linux 2 AMIs

### amazon-linux-extras

install docker

```bash
sudo amazon-linux-extras install docker
```

---

## Amazon EFS

### amazon-efs-utils

> install amazon-efs-utils on Amazon Linux 2 to access EFS  
> <https://docs.aws.amazon.com/efs/latest/ug/installing-amazon-efs-utils.html>

```bash
sudo yum install -y amazon-efs-utils
```

---

### mount EFS volume

> Using the EFS mount helper to automatically re-mount EFS file systems.  
> <https://docs.aws.amazon.com/efs/latest/ug/automount-with-efs-mount-helper.html>
>
> Mounting with EFS access points  
> <https://docs.aws.amazon.com/efs/latest/ug/mounting-access-points.html>
>
> Original command has mistake in it, `iam` option.  
> Make sure you have right security groups settings

To mount permanently

```bash
sudo vim /etc/fstab
```

you can use this command in `fstab`

```bash
file_system_id:/ /var/www/html/img efs _netdev,noresvport,tls,iam,accesspoint=access-point-id 0 0
```

> example

```bash
fs-09684528ab385583f:/ /var/www/html/img efs _netdev,noresvport,tls,accesspoint=fsap-03b05a76b9a9a96d4 0 0
```

or this

```bash
file_system_id /var/www/html/img efs _netdev,tls,accesspoint=access-point-id 0 0
```

> example

```bash
fs-09684528ab385583f /var/www/html/img efs _netdev,tls,accesspoint=fsap-03b05a76b9a9a96d4 0 0
```

Test the `fstab` entry by using the mount command with the `fake` option along with the `all` and `verbose` options.

```bash
sudo mount -fav
```

```text
home/ec2-user/efs      : successfully mounted
```

---

## AWS Network

---

---
title: aws-commands
categories:
  - software
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [instances deploying](#instances-deploying)
  - [ssh to aws instances](#ssh-to-aws-instances)
  - [user-data](#user-data)
- [Amazon Linux 2 AMIs](#amazon-linux-2-amis)
  - [amazon-linux-extras](#amazon-linux-extras)
- [CloudWatch Logs](#cloudwatch-logs)
  - [CloudWatch Logs agent](#cloudwatch-logs-agent)
- [Amazon EFS](#amazon-efs)
  - [amazon-efs-utils](#amazon-efs-utils)
  - [mount EFS volume](#mount-efs-volume)
- [AWS Network](#aws-network)
  - [Classic Load Balancer](#classic-load-balancer)
    - [Classic Load Balancer logs](#classic-load-balancer-logs)

## instances deploying

### ssh to aws instances

ssh to aws instance

```sh
ssh -i ~/.ssh/key-name.pem -o ServerAliveInterval=200 username@ip
```

username for different OS

- `centos` - CentOS 7
- `ubuntu` - Ubuntu 18-22
- `ec2-user` - Amazon Linux 2

---

### user-data

check the user-data provided during deployment and debug it

```sh
curl http://169.254.169.254/latest/user-data
```

---

## Amazon Linux 2 AMIs

### amazon-linux-extras

install docker

```sh
sudo amazon-linux-extras install docker
```

---

## CloudWatch Logs

### CloudWatch Logs agent

[Quick Start: Install and configure the CloudWatch Logs agent on a running EC2 Linux instance](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/QuickStartEC2Instance.html)

install CloudWatch Logs agent on **Amazon Linux 2**

```sh
sudo yum update -y && sudo yum install -y awslogs
```

install CloudWatch Logs agent on **Ubuntu Server, CentOS, or Red Hat instance**

```sh
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O

# install and configure with the needed region
# don't forget to CHANGE the --region
sudo python ./awslogs-agent-setup.py --region us-east-1
```

config of CloudWatch Logs agent

```sh
vim /var/awslogs/etc/awslogs.conf
```

---

## Amazon EFS

### amazon-efs-utils

> install amazon-efs-utils on Amazon Linux 2 to access EFS  
> <https://docs.aws.amazon.com/efs/latest/ug/installing-amazon-efs-utils.html>

```sh
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

```sh
sudo vim /etc/fstab
```

you can use this command in `fstab`

```sh
file_system_id:/ /var/www/html/img efs _netdev,noresvport,tls,iam,accesspoint=access-point-id 0 0
```

> example

```sh
fs-09684528ab385583f:/ /var/www/html/img efs _netdev,noresvport,tls,accesspoint=fsap-03b05a76b9a9a96d4 0 0
```

or this

```sh
file_system_id /var/www/html/img efs _netdev,tls,accesspoint=access-point-id 0 0
```

> example

```sh
fs-09684528ab385583f /var/www/html/img efs _netdev,tls,accesspoint=fsap-03b05a76b9a9a96d4 0 0
```

Test the `fstab` entry by using the mount command with the `fake` option along with the `all` and `verbose` options.

```sh
sudo mount -fav
```

```properties
home/ec2-user/efs      : successfully mounted
```

---

## AWS Network

---

### Classic Load Balancer

#### Classic Load Balancer logs

[Enable access logs for your Classic Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html)

sample S3 policy to store logs of Classic Load Balancer in S3 bucket

```json
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::127311923021:root"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::wave-web-logs-2/elb-wave/AWSLogs/account-id/*"
      }
    ]
  }
```

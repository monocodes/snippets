---
title: aws-cli
categories:
  - software
  - notes
  - guides
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# aws-cli

- [aws-cli](#aws-cli)
  - [aws-cli reference](#aws-cli-reference)
  - [aws-cli install macOS and pip](#aws-cli-install-macos-and-pip)
  - [aws configure](#aws-configure)
  - [aws help](#aws-help)
  - [aws sts](#aws-sts)
  - [aws ec2](#aws-ec2)
    - [attach volume](#attach-volume)
  - [aws s3](#aws-s3)
    - [`aws s3 mb` - make bucket](#aws-s3-mb---make-bucket)
    - [`aws s3 cp` - copy](#aws-s3-cp---copy)
    - [`aws s3 ls` - list](#aws-s3-ls---list)
  - [aws-cli example scripts](#aws-cli-example-scripts)
    - [Amazon Linux 2](#amazon-linux-2)
    - [CentOS 7](#centos-7)

## aws-cli reference

<https://docs.aws.amazon.com/cli/latest/reference/>

---

## aws-cli install macOS and pip

brew

```shell
brew install awscli
```

python

```shell
pip install awscli
```

awscli completer install  
[aws-cli command completion install.md](guides/aws-cli command completion install.md)

---

## aws configure

> first create user in aws console with access key  
> use it whenever you want to change user or change config

aws-cli config files

```shell
ls ~/.aws
```

setting the aws-cli output format

```shell
vim ~/.aws/config
```

`config`

```properties
output = table
```

- `json` – The output is formatted as a JSON string.
- `yaml` – The output is formatted as a YAML string.
- yaml-stream – The output is streamed and formatted as a YAML string. Streaming allows for faster handling of large data types.
- `text` – The output is formatted as multiple lines of tab-separated string values. This can be useful to pass the output to a text processor, like grep, sed, or awk.
- `table` – The output is formatted as a table using the characters `+|-` to form the cell borders. It typically presents the information in a "human-friendly" format that is much easier to read than the others, but not as programmatically useful.

---

## aws help

you can get help for every aws command with help

```shell
aws ec2 help
aws s3 mb help
```

---

## aws sts

`aws sts` - check current user/session/etc

```shell
aws sts get-caller-identity 
```

---

## aws ec2

show all instances

```shell
aws ec2 describe-instances
```

---

### attach volume

> To attach volume you must know `InstanceId`.  
> Also view the root volume mapping or another attached volumes.  
> root volume - DeviceName - `/dev/sda1`.  
> BlockDeviceMappings - DeviceName - `/dev/sdp`.
>
> Recommended device names for Linux: `/dev/sda1` for root volume. `/dev/sd[f-p]` for data volumes.

1. ```shell
    aws ec2 describe-instances
    ```

    or  

    ```shell
    aws ec2 describe-instances | grep InstanceId
    ```

2. create volume and copy its id  
    show avalaible volumes  

    ```shell
    aws ec2 describe-volumes
    ```

3. attach volume  

    ```shell
    aws ec2 attach-volume --volume-id vol-05827720c09908177 --instance-id i-0092ded0f237033a1 --device /dev/sdf
    ```

---

## aws s3

### `aws s3 mb` - make bucket

create new s3 bucket

```shell
aws s3 mb s3://bucket-name
```

---

### `aws s3 cp` - copy

copy file to s3 bucket

```shell
aws s3 cp filename s3://bucket-name
```

> example

```shell
aws s3 cp vprofile-v2.war s3://vprofile-artifact-storage-mono
```

---

### `aws s3 ls` - list

show contents of s3 bucket

```shell
aws s3 ls s3://bucket-name
```

> example

```shell
aws s3 ls s3://vprofile-artifact-storage
```

---

## aws-cli example scripts

### Amazon Linux 2

```shell
aws ec2 run-instances \
 --image-id ami-0dfcb1ef8550277af \
 --count 1 \
 --instance-type t2.micro \
 --key-name mono-test \
 --security-groups mono-test-sg \
 --user-data file://~/My\ Drive/study/code/commands/bash-scripts/provisioning-scripts/multi-os-base-aws-provision.sh
```

---

### CentOS 7

US locale fixed  
updated  
installed `epel-release vim htop bat`

```shell
aws ec2 run-instances \
 --image-id ami-002070d43b0a4f171 \
 --count 1 \
 --instance-type t2.micro \
 --key-name tween-dev-nvir \
 --security-groups tween-web-dev-sg \
 --user-data file://~/My\ Drive/study/code/commands/bash-scripts/provisioning-scripts/centos7.sh
```

create tags for instance

```shell
aws ec2 create-tags \
  --resources i-0efd2d3a7e2070c4f \
  --tags Key=Name,Value=webtest
```

grep PublicDnsName

```shell
aws ec2 describe-instances --instance-ids i-0efd2d3a7e2070c4f | grep PublicDnsName
```

ssh in instance  
`-o ServerAliveInterval=60` for not being disconnected every 60 seconds

```shell
ssh -i "/path/to/key-name.pem" -o ServerAliveInterval=200 username@srv-name
```

---

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
  - [awscli install](#awscli-install)
    - [linuxbrew](#linuxbrew)
    - [Linux](#linux)
    - [macOS](#macos)
    - [pip](#pip)
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

## awscli install

[AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)

### linuxbrew

one-liner install linuxbrew

```sh
brew update && brew install awscli && \
	echo "complete -C aws_completer aws" >> ~/.bashrc && \
	source ~/.bashrc
```

### Linux

> In all repos will be **awscliv1**

- Install **awscliv2** with `awscli-update`  
  
  > `awscli-update` is a small script on python, [CLI tool to update AWS CLI 2](https://pypi.org/project/awscli-update/)
  
  1. Install `awscli-update`
  
     ```sh
     pip3 install awscli-update
     ```
  
  2. Run script
  
     ```sh
     awscli-update --prefix $HOME/.local
     
     # --prefix $HOME/.local - install awscliv2 to preferred user location
     # bin to $HOME/.local/bin and app to $HOME/.local
     ```
  
  3. Create cron to check updates every hour
  
     ```sh
     crontab -e
     
     0 * * * * $HOME/.local/bin/awscli-update -q --prefix $HOME/.local
     ```
  
  4. Check installation of `awscli-update`
  
     ```sh
     which awscli-update
     
     # output
     $HOME/.local/bin/awscli-update
     ```
  
  5. Check `aws` installation path
  
     ```sh
     which aws
     
     # output
     $HOME/.local/bin/aws
     ```
  
  6. Check `aws` version
  
     ```sh
     aws --version
     # or
     $HOME/.local/bin/aws --version
     
     # output
     aws-cli/2.11.14 Python/3.11.3 Linux/5.15.0-70-generic exe/x86_64.ubuntu.22 prompt/off
     ```
  
  7. Install **awscli** commands completion, [Command completion](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html)
  
     ```sh
     # Ubuntu 22
     echo "complete -C '\$HOME/.local/bin/aws_completer' aws" >> ~/.profile && source .profile
     ```
  
- Install **awscliv2** manually, [Installing or updating the latest version of the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions)

  1. ```sh
     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
     	unzip awscliv2.zip && \
     	sudo ./aws/install -i $HOME/.local/aws-cli -b $HOME/.local/bin
     ```

  2. Check installed version

     ```sh
     aws --version
     # or
     /usr/local/bin/aws --version
     
     # check installation location
     which aws
     ```

  3. Install **awscli** commands completion, [Command completion](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html)

     ```sh
     # Ubuntu 22
     echo "complete -C '\$HOME/.local/bin/aws_completer' aws" >> ~/.profile && source .profile
     ```

- Uninstall `awscli`, [Uninstalling the AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/uninstall.html)

  1. Locate the symlink and install paths.

     - Use the `which` command to find the symlink. This shows the path you used with the `--bin-dir` parameter.

       ```sh
       which aws
       
       # output
       /usr/local/bin/aws
       ```

     - Use the `ls` command to find the directory that the symlink points to. This gives you the path you used with the `--install-dir` parameter.

       ```sh
       ls -l /usr/local/bin/aws
       
       # output
       lrwxrwxrwx 1 root root 37 Apr 21 13:38 /usr/local/bin/aws -> /usr/local/aws-cli/v2/current/bin/aws
       ```

  2. Delete the two symlinks in the `--bin-dir` directory. If your user has write permission to these directories, you don't need to use `sudo`.

     ```sh
     sudo rm /usr/local/bin/aws
     sudo rm /usr/local/bin/aws_completer
     ```

  3. Delete the `--install-dir` directory. If your user has write permission to this directory, you don't need to use `sudo`.

     ```sh
     sudo rm -rf /usr/local/aws-cli
     ```

  4. **(Optional)** Remove the shared AWS SDK and AWS CLI settings information in the `.aws` folder.

     > Warning
     >
     > These configuration and credentials settings are shared across all AWS SDKs and the AWS CLI. If you remove this folder, they cannot be accessed by any AWS SDKs that are still on your system.
     >
     > The default location of the `.aws` folder differs between platforms, by default the folder is located in `~/.aws/`. If your user has write permission to this directory, you don't need to use `sudo`.

     ```sh
     sudo rm -rf ~/.aws/
     ```

---

### macOS

`brew` will install **awscliv2**

```sh
brew install awscli
```

### pip

python will install **awscliv1**

```sh
pip install awscli
```

awscli completer install  
[aws-cli command completion install.md](guides/aws-cli command completion install.md)

---

## aws configure

> first create user in aws console with access key  
> use it whenever you want to change user or change config

aws-cli config files

```sh
ls ~/.aws
```

setting the aws-cli output format

```sh
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

```sh
aws ec2 help
aws s3 mb help
```

---

## aws sts

`aws sts` - check current user/session/etc

```sh
aws sts get-caller-identity 
```

---

## aws ec2

show all instances

```sh
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

1. ```sh
    aws ec2 describe-instances
    ```

    or  

    ```sh
    aws ec2 describe-instances | grep InstanceId
    ```

2. create volume and copy its id  
    show avalaible volumes  

    ```sh
    aws ec2 describe-volumes
    ```

3. attach volume  

    ```sh
    aws ec2 attach-volume --volume-id vol-05827720c09908177 --instance-id i-0092ded0f237033a1 --device /dev/sdf
    ```

---

## aws s3

### `aws s3 mb` - make bucket

create new s3 bucket

```sh
aws s3 mb s3://bucket-name
```

---

### `aws s3 cp` - copy

copy file to s3 bucket

```sh
aws s3 cp filename s3://bucket-name
```

> example

```sh
aws s3 cp vprofile-v2.war s3://vprofile-artifact-storage-mono
```

---

### `aws s3 ls` - list

show contents of s3 bucket

```sh
aws s3 ls s3://bucket-name
```

> example

```sh
aws s3 ls s3://vprofile-artifact-storage
```

---

## aws-cli example scripts

### Amazon Linux 2

```sh
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

```sh
aws ec2 run-instances \
 --image-id ami-002070d43b0a4f171 \
 --count 1 \
 --instance-type t2.micro \
 --key-name tween-dev-nvir \
 --security-groups tween-web-dev-sg \
 --user-data file://~/My\ Drive/study/code/commands/bash-scripts/provisioning-scripts/centos7.sh
```

create tags for instance

```sh
aws ec2 create-tags \
  --resources i-0efd2d3a7e2070c4f \
  --tags Key=Name,Value=webtest
```

grep PublicDnsName

```sh
aws ec2 describe-instances --instance-ids i-0efd2d3a7e2070c4f | grep PublicDnsName
```

ssh in instance  
`-o ServerAliveInterval=60` for not being disconnected every 60 seconds

```sh
ssh -i "/path/to/key-name.pem" -o ServerAliveInterval=200 username@srv-name
```

---

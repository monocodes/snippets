*************************************************
# awscli reference
*************************************************
https://docs.aws.amazon.com/cli/latest/reference/

aws-cli-part-1.pdf




*************************************************
# awscli install
*************************************************

# brew ------------------------------------------
brew install awscli

# python ----------------------------------------
pip install awscli

# awscli completer install ----------------------
aws-cli-command-completer.pdf




*************************************************
# aws configure
*************************************************
# first create user in aws console with access key
# start using awscli
aws configure

# awscli config files
ls ~/.aws

# Setting the AWS CLI output format
vim ~/.aws/config
output = table

<!-- json – The output is formatted as a JSON string.

yaml – The output is formatted as a YAML string.

yaml-stream – The output is streamed and formatted as a YAML string. Streaming allows for faster handling of large data types.

text – The output is formatted as multiple lines of tab-separated string values. This can be useful to pass the output to a text processor, like grep, sed, or awk.

table – The output is formatted as a table using the characters +|- to form the cell borders. It typically presents the information in a "human-friendly" format that is much easier to read than the others, but not as programmatically useful. -->




*************************************************
# aws sts - check current user/session/etc
*************************************************
# check current user and current account
aws sts get-caller-identity 




*************************************************
# aws ec2
*************************************************
# show all instances
aws ec2 describe-instances



-------------------------------------------------
# attach volume
-------------------------------------------------
# to attach volume you must know InstanceId
# also view the root volume mapping or another attached volumes
# root volume - DeviceName - /dev/sda1 
# BlockDeviceMappings - DeviceName - /dev/sdp
# Recommended device names for Linux: /dev/sda1 for root volume. /dev/sd[f-p] for data volumes. 
aws ec2 describe-instances

# or
aws ec2 describe-instances | grep InstanceId

# create volume and copy its id

# show avalaible volumes
aws ec2 describe-volumes

# attach volume 
aws ec2 attach-volume --volume-id vol-05827720c09908177 --instance-id i-0092ded0f237033a1 --device /dev/sdf




*************************************************
# aws-cli example scripts
*************************************************

# Launch CentOS 7 AMI
# US locale fixed
# updated
# installed epel-release, vim, htop, bat
aws ec2 run-instances \
 --image-id ami-002070d43b0a4f171 \
 --count 1 \
 --instance-type t2.micro \
 --key-name tween-dev-nvir \
 --security-groups tween-web-dev-sg \
 --user-data file://~/My\ Drive/study/code/commands/bash-scripts/provisioning-scripts/centos7.sh

# create tags for instance
aws ec2 create-tags \
  --resources i-0efd2d3a7e2070c4f \
  --tags Key=Name,Value=webtest

# grep PublicDnsName
aws ec2 describe-instances --instance-ids i-0efd2d3a7e2070c4f | grep PublicDnsName

# ssh in instance
# -o ServerAliveInterval=60 for not being disconnected every 60 seconds
ssh -i "~/.ssh/aws/tween-dev-nvir.pem" -o ServerAliveInterval=999 centos@ec2-3-235-7-214.compute-1.amazonaws.com
ssh -i "~/.ssh/aws/mono-docker.pem" -o ServerAliveInterval=999 centos@ec2-user@ec2-34-203-33-71.compute-1.amazonaws.com





*************************************************
# Amazon Linux 2 AMIs
*************************************************

-------------------------------------------------
# amazon-linux-extras
-------------------------------------------------
# docker install
sudo amazon-linux-extras install docker





*************************************************
# Amazon EFS
*************************************************

-------------------------------------------------
# amazon-efs-utils
-------------------------------------------------
# install amazon-efs-utils on Amazon Linux 2 to access EFS
# https://docs.aws.amazon.com/efs/latest/ug/installing-amazon-efs-utils.html
sudo yum install -y amazon-efs-utils



-------------------------------------------------
# mount EFS
-------------------------------------------------
# Using the EFS mount helper to automatically re-mount EFS file systems
# https://docs.aws.amazon.com/efs/latest/ug/automount-with-efs-mount-helper.html

# Mounting with EFS access points
# https://docs.aws.amazon.com/efs/latest/ug/mounting-access-points.html

# original command has mistake in it, "iam" option
# make sure you have right security groups settings

# you can use this command
file_system_id:/ /var/www/html/img efs _netdev,noresvport,tls,iam,accesspoint=access-point-id 0 0
fs-09684528ab385583f:/ /var/www/html/img efs _netdev,noresvport,tls,accesspoint=fsap-03b05a76b9a9a96d4 0 0

# or this
file_system_id /var/www/html/img efs _netdev,tls,accesspoint=access-point-id 0 0
fs-09684528ab385583f /var/www/html/img efs _netdev,tls,accesspoint=fsap-03b05a76b9a9a96d4 0 0

# Test the fstab entry by using the mount command with the 'fake' option along with the 'all' and 'verbose' options.
sudo mount -fav
# home/ec2-user/efs      : successfully mounted
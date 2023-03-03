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
# use it whenever you want to change user or change config
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
# aws help
*************************************************
# you can get help for every aws command with help
aws ec2 help
aws s3 mb help




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
# aws s3
*************************************************

-------------------------------------------------
# aws s3 mb = make bucket
-------------------------------------------------
# create new s3 bucket
# mb = make bucket
aws s3 mb s3://bucket-name


-------------------------------------------------
# aws s3 cp = copy
-------------------------------------------------
# copy file to s3 bucket
aws s3 cp filename s3://bucket-name
# example
aws s3 cp vprofile-v2.war s3://vprofile-artifact-storage-mono


# copy file from s3 bucket
aws s3 cp s3://bucket-name/path/to/filename /path/to/dir/
# example
aws s3 cp s3://vprofile-artifact-storage-mono/vprofile-v2.war /tmp/


-------------------------------------------------
# aws s3 ls = list
-------------------------------------------------
# show contents of s3 bucket
aws s3 ls s3://bucket-name
# example
aws s3 ls s3://vprofile-artifact-storage-mono





*************************************************
# aws-cli example scripts
*************************************************

-------------------------------------------------
# Amazon Linux 2
-------------------------------------------------

aws ec2 run-instances \
 --image-id ami-0dfcb1ef8550277af \
 --count 1 \
 --instance-type t2.micro \
 --key-name mono-test \
 --security-groups mono-test-sg \
 --user-data file://~/My\ Drive/study/code/commands/bash-scripts/provisioning-scripts/multi-os-base-aws-provision.sh



-------------------------------------------------
# CentOS 7
-------------------------------------------------
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
ssh -i "/path/to/key-name.pem" -o ServerAliveInterval=200 username@srv-name
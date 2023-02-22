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
ssh -i "~/.ssh/aws/tween-dev-nvir.pem" -o ServerAliveInterval=60 centos@ec2-3-235-7-214.compute-1.amazonaws.com
ssh -i "~/.ssh/aws/mono-docker.pem" -o ServerAliveInterval=60 centos@ec2-user@ec2-34-203-33-71.compute-1.amazonaws.com





*************************************************
# Amazon Linux 2 AMIs
*************************************************

-------------------------------------------------
# amazon-linux-extras
-------------------------------------------------
# docker install
sudo amazon-linux-extras install docker
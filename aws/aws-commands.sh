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

# to mount permanently
sudo vim /etc/fstab

# you can use this command in fstab
file_system_id:/ /var/www/html/img efs _netdev,noresvport,tls,iam,accesspoint=access-point-id 0 0
# example
fs-09684528ab385583f:/ /var/www/html/img efs _netdev,noresvport,tls,accesspoint=fsap-03b05a76b9a9a96d4 0 0

# or this
file_system_id /var/www/html/img efs _netdev,tls,accesspoint=access-point-id 0 0
# example
fs-09684528ab385583f /var/www/html/img efs _netdev,tls,accesspoint=fsap-03b05a76b9a9a96d4 0 0

# Test the fstab entry by using the mount command with the 'fake' option along with the 'all' and 'verbose' options.
sudo mount -fav
# home/ec2-user/efs      : successfully mounted





*************************************************
# AWS Network
*************************************************

# from inside the EC2 instance show user metadata
curl http://169.254.169.254/latest/user-data
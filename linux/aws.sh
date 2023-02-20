*************************************************
# Amazon Linux 2 EC2
*************************************************

-------------------------------------------------
# connect to EC2 instance
-------------------------------------------------
# -o ServerAliveInterval=60 for not being disconnected every 60
ssh -i "~/.ssh/aws/mono-docker.pem" -o ServerAliveInterval=60 ec2-user@ec2-34-203-33-71.compute-1.amazonaws.com


-------------------------------------------------
# amazon-linux-extras
-------------------------------------------------
# docker install
sudo amazon-linux-extras install docker
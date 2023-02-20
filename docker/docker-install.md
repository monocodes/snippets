*************************************************
# DOCKER INSTALL
*************************************************
# https://docs.docker.com/engine/install/



*************************************************
# Amazon Linux 2 EC2
*************************************************
# docker install
sudo amazon-linux-extras install docker



*************************************************
# UBUNTU
*************************************************
# Uninstall old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt remove docker.io -y ; \
  sudo apt remove containerd -y ; \
  sudo apt remove runc -y ; \
  sudo apt remove docker -y ; \
  sudo apt remove docker-engine -y

# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo apt update

sudo apt install \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Add Docker’s official GPG key:
# mkdir maybe unnecessary
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Use the following command to set up the repository:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
# Update the apt package index:
sudo apt update


-------------------------------------------------
# Optional
-------------------------------------------------
# Receiving a GPG error when running apt update?

# Your default umask may be incorrectly configured, preventing detection of the repository public key file. Try granting read permission for the Docker public key file before updating the package index:
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt update


-------------------------------------------------
# To install a specific version of Docker Engine, start by list the available versions in the repository:
-------------------------------------------------
# List the available versions:
apt-cache madison docker-ce | awk '{ print $3 }'

<!-- 5:20.10.16~3-0~ubuntu-jammy
5:20.10.15~3-0~ubuntu-jammy
5:20.10.14~3-0~ubuntu-jammy
5:20.10.13~3-0~ubuntu-jammy -->

# Select the desired version and install:
VERSION_STRING=5:20.10.13~3-0~ubuntu-jammy
sudo apt install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-compose-plugin

# Verify that the Docker Engine installation is successful by running the hello-world image:
sudo docker run hello-world


-------------------------------------------------
# To install the latest version, run:
-------------------------------------------------
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify that the Docker Engine installation is successful by running the hello-world image:
sudo docker run hello-world


-------------------------------------------------
# Docker Engine post-installation steps
-------------------------------------------------
<!-- These optional post-installation procedures shows you how to configure your Linux host machine to work better with Docker.

Manage Docker as a non-root user
The Docker daemon binds to a Unix socket, not a TCP port. By default it’s the root user that owns the Unix socket, and other users can only access it using sudo. The Docker daemon always runs as the root user.

If you don’t want to preface the docker command with sudo, create a Unix group called docker and add users to it. When the Docker daemon starts, it creates a Unix socket accessible by members of the docker group. On some Linux distributions, the system automatically creates this group when installing Docker Engine using a package manager. In that case, there is no need for you to manually create the group. -->

# Warning
# The docker group grants root-level privileges to the user. For details on how this impacts security in your system, see Docker Daemon Attack Surface.

# Note
# To run Docker without root privileges, see Run the Docker daemon as a non-root user (Rootless mode).
https://docs.docker.com/engine/security/rootless/

-------------------------------------------------
# To create the docker group and add your user:
-------------------------------------------------
# Create the docker group.
sudo groupadd docker

# Add your user to the docker group.
sudo usermod -aG docker $USER

# Log out and log back in so that your group membership is re-evaluated.

# If you’re running Linux in a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

# You can also run the following command to activate the changes to groups:
newgrp docker

# Verify that you can run docker commands without sudo.
docker run hello-world
# This command downloads a test image and runs it in a container. When the container runs, it prints a message and exits.

# If you initially ran Docker CLI commands using sudo before adding your user to the docker group, you may see the following error:
<!-- WARNING: Error loading config file: /home/user/.docker/config.json -
stat /home/user/.docker/config.json: permission denied -->

<!-- This error indicates that the permission settings for the ~/.docker/ directory are incorrect, due to having used the sudo command earlier.

To fix this problem, either remove the ~/.docker/ directory (it’s recreated automatically, but any custom settings are lost), or change its ownership and permissions using the following commands: -->
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R


-------------------------------------------------
# Configure Docker to start on boot with systemd
-------------------------------------------------
<!-- Many modern Linux distributions use systemd to manage which services start when the system boots. On Debian and Ubuntu, the Docker service starts on boot by default. To automatically start Docker and containerd on boot for other Linux distributions using systemd, run the following commands: -->
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# To stop this behavior, use disable instead.
sudo systemctl disable docker.service
sudo systemctl disable containerd.service



*************************************************
# macos (Docker Desktop)
*************************************************
brew install --cask docker

# add user to docker group to use docker commands without sudo
"""
By default, you’ll have to use sudo command or login to root any time you
want to run a Docker command. This next step is optional, but if you’d prefer
the ability to run Docker as your current user, you can add your account to 
the docker group with this command:
"""
sudo usermod -aG docker $USER
reboot


*************************************************
# DOCKER UNINSTALL
*************************************************
# ubuntu
sudo apt remove docker docker-engine docker.io containerd runc docker-ce containerd.io
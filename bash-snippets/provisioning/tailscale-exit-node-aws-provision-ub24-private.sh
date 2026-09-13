#!/bin/bash

# title: tailscale-exit-node-provision-ub24-private.sh
# categories:
#   - bash
#   - scripts
#   - provisioning
# author: monocodes
# url: https://github.com/monocodes/snippets.git

#################################################
# Defining variables
#################################################
HOSTNAME="ts-exit-node-ln-eu-de-2"
AUTHKEY=""

#################################################
# Defining functions
#################################################

# message function
function message() {
  echo
  echo
  echo "########################################"
  echo "$1"
  echo "########################################"
  echo
}

function awscli-v2-install(){
  message "Installing the latest version of awscli-v2 via snap and adding bash completions for default user and root..."
  sudo snap install aws-cli --classic
  grep -wq "^complete -C '/snap/aws-cli/current/bin/aws_completer' aws" /home/ubuntu/.bashrc || echo "complete -C '/snap/aws-cli/current/bin/aws_completer' aws" | tee -a /home/ubuntu/.bashrc
  sudo grep -wq "^complete -C '/snap/aws-cli/current/bin/aws_completer' aws" /root/.bashrc || echo "complete -C '/snap/aws-cli/current/bin/aws_completer' aws" | sudo tee -a /root/.bashrc
}

#################################################
# Start script and record all its output.
#################################################
{
  {
  message "Start recording script output."

  message "Change hostname..."
  sudo hostnamectl hostname $HOSTNAME

  message "Make vim default editor..."
  sudo update-alternatives --set editor /usr/bin/vim.basic

  message "Update and upgrade quietly and without interruptions..."
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade

  message "Snap initialization..."
  sudo snap install core; sudo snap refresh core

  # message "Disable SSH with password and restart SSH..."
  # sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  # sudo service ssh restart
  
  message "Install software..."
  sudo apt-get install bash-completion git bat inetutils-traceroute -y
  sudo snap install tldr
  awscli-v2-install
  # DO
  # curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash

  message "Install tailscale..."
  curl -fsSL https://tailscale.com/install.sh | sh
  echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
  echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
  sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
  printf '#!/bin/sh\n\nethtool -K %s rx-udp-gro-forwarding on rx-gro-list off \n' "$(ip route show 0/0 | cut -f5 -d" ")" | sudo tee /etc/networkd-dispatcher/routable.d/50-tailscale
  sudo chmod 755 /etc/networkd-dispatcher/routable.d/50-tailscale
  sudo /etc/networkd-dispatcher/routable.d/50-tailscale
  sudo tailscale up --authkey $AUTHKEY --advertise-exit-node --advertise-tags=tag:exit-node --accept-routes

  message "Update and Clean up..."
  sudo apt update
  sudo apt upgrade -y
  sudo apt autopurge -y
  sudo 
    
  } 2> >(tee ~/provision-err.log 1>&2);
} |& tee ~/provision-full.log

echo
echo
echo "########################################"
echo "Completed!"
echo "To see full log:"
echo "batcat ~/provision-full.log"
echo
echo "To see error-only log:"
echo "batcat ~/provision-err.log"
echo "########################################"
echo
echo "Showing last 30 lines of provision-err.log..."
echo 
echo
tail -30 ~/provision-err.log
echo "########################################"

sudo reboot now
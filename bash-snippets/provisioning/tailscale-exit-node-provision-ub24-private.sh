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
HOSTNAME="ts-exit-node-ln-eu-de-1"

# home
AUTHKEY="private-key"

# corp
# AUTHKEY="private-key"

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

# vim default function
function vim-default() {
  message "Making vim default editor for default user and root..."
  grep -wq '^export EDITOR=vim' ~/.bashrc || echo 'export EDITOR=vim' | tee -a ~/.bashrc
  sudo grep -wq '^export EDITOR=vim' /root/.bashrc || echo 'export EDITOR=vim' | sudo tee -a /root/.bashrc
  source ~/.bashrc
}

#################################################
# Start script and record all its output.
#################################################
{
  {
  message "Start recording script output."

  message "Change hostname..."
  sudo hostnamectl hostname $HOSTNAME

  message "Make vim defailt editor..."
  vim-default

  message "Update repos..."
  sudo apt-get update
  sudo apt-get upgrade -y
  
  message "Install software..."
  sudo apt-get install bash-completion git bat inetutils-traceroute -y

  message "Disable SSH with password and restart SSH..."
  sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  sudo service ssh restart

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
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
TARGET_HOSTNAME="ts-exit-node-oc-eu-ch-1"
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

#################################################
# Start script and record all its output.
#################################################
{
  {
  message "Start recording script output."

  message "Change hostname..."
  sudo hostnamectl set-hostname "$TARGET_HOSTNAME"

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
  sudo apt-get install curl wget tar ca-certificates iptables-persistent ethtool networkd-dispatcher -y
  sudo apt-get install bash-completion git bat inetutils-traceroute -y
  sudo snap install tldr
  # DO
  # curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash

  message "Configure firewall..."
  sudo iptables -I INPUT -p udp --dport 41641 -j ACCEPT

  message "Install tailscale..."
  curl -fsSL https://tailscale.com/install.sh | sh
  echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
  echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
  sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
  printf '#!/bin/sh\n\nethtool -K %s rx-udp-gro-forwarding on rx-gro-list off \n' "$(ip route show 0/0 | cut -f5 -d" ")" | sudo tee /etc/networkd-dispatcher/routable.d/50-tailscale
  sudo chmod 755 /etc/networkd-dispatcher/routable.d/50-tailscale
  sudo /etc/networkd-dispatcher/routable.d/50-tailscale
  sudo tailscale up --authkey "$AUTHKEY" --advertise-exit-node --advertise-tags=tag:exit-node --accept-routes

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
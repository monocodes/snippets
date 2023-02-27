#!/bin/bash

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


# bat install function
function bat-install() {
  red=`tput setaf 1`
  green=`tput setaf 2`
  bold=`tput bold`
  reset=`tput sgr0`

  echo ""
  echo "${bold}${green}Installing the latest CentOS release version of bat command from GitHub...${reset}"

  echo ""
  echo "${bold}Note${reset}: For more information, please see https://github.com/sharkdp/bat."

  echo ""
  echo "Finding the latest version tag from Github..."

  BAT_VERSION=$(curl --silent "https://api.github.com/repos/sharkdp/bat/releases/latest" | grep -Eo '"tag_name": "v(.*)"' | sed -E 's/.*"([^"]+)".*/\1/')
  BAT_RELEASE="bat-$BAT_VERSION-x86_64-unknown-linux-musl"
  BAT_ARCHIVE="$BAT_RELEASE.tar.gz"

  echo ""
  echo "Version ${bold}$BAT_VERSION${reset} found, downloading ${bold}$BAT_ARCHIVE${reset} from GitHub..."

  curl -sOL "https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/$BAT_ARCHIVE"

  echo ""
  echo "Unarchiving ${bold}$BAT_ARCHIVE${reset} to ${bold}$HOME/$BAT_RELEASE${reset}..."

  tar xzvf $BAT_ARCHIVE -C $HOME/

  echo ""
  echo "Copying executable to ${bold}/usr/local/bin/bat${reset}..."

  sudo sh -c "cp $HOME/$BAT_RELEASE/bat /usr/local/bin/bat"

  echo ""
  echo "Removing ${bold}$BAT_ARCHIVE${reset} and cleaning up..."

  rm $BAT_ARCHIVE

  unset BAT_ARCHIVE
  unset BAT_RELEASE
  unset BAT_VERSION

  if command -v bat &> /dev/null
  then
    echo ""
    echo "${bold}${green}Finished installing $(bat --version).${reset}"
  else
    echo ""
    echo "${bold}${red}Installation failed! Please examine this script and try steps manually.${reset}"
    exit 1
  fi

  # installing bat to root also
  sudo cp /usr/local/bin/bat /bin
}


#################################################
# Start and record all script output.
#################################################
{
  message "Start recording script output."
  message "Trying to determine distro..."

  if [  -n "$(uname -a | grep -i ubuntu)" ]; then
    message "Ubuntu"

    sudo echo "export EDITOR=vim" >> /root/.bashrc
    sudo echo "export EDITOR=vim" >> /home/ubuntu/.bashrc

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt autoremove --purge -y
    sudo apt-get install bat stress -y
    sudo apt-get clean

  elif [  -n "$(uname -a | grep -i amzn)" ]; then
    
    message "Amazon Linux"

    echo "LANG=en_US.utf-8" >> /etc/environment
    echo "LC_ALL=en_US.utf-8" >> /etc/environment
    sudo localectl set-locale LANG=en_US.UTF-8
    sudo localectl set-keymap us

    sudo amazon-linux-extras install epel -y
    sudo yum update -y
    sudo yum install vim htop stress -y
    sudo yum clean all
    bat-install

    sudo echo "export EDITOR=vim" >> /root/.bashrc
    sudo echo "export EDITOR=vim" >> /home/ec2-user/.bashrc

  elif [  -n "$(uname -a | grep -i el[1-99])" ]; then
    
    message "CentOS, RHEL"

    echo "LANG=en_US.utf-8" >> /etc/environment
    echo "LC_ALL=en_US.utf-8" >> /etc/environment
    sudo localectl set-locale LANG=en_US.UTF-8
    sudo localectl set-keymap us

    sudo yum install epel-release -y
    sudo yum update -y
    sudo yum install vim htop stress -y
    sudo yum clean all
    bat-install

    sudo echo "export EDITOR=vim" >> /root/.bashrc
    sudo echo "export EDITOR=vim" >> /home/centos/.bashrc
  fi  
} 2>/tmp/multi-os-base-aws-provision-err.log \ 
  |& tee /tmp/multi-os-base-aws-provision-full.log


echo
echo
echo "########################################"
echo "Completed!"
echo "To see full log:"
echo "bat /tmp/multi-os-base-aws-provision-full.log"
echo
echo "To see error-only log:"
echo "bat /tmp/multi-os-base-aws-provision-err.log"
echo "########################################"
echo
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

  message "Installing bat to root also and cleaning up..."
  sudo cp /usr/local/bin/bat /bin
  rm -rf ~/bat-v*
}


#################################################
# Start and record all script output.
#################################################
{
  message "Start recording script output."
  
  message "Trying to determine distro..."
  if [  -n "$(uname -a | grep -i ubuntu)" ]; then
    message "Distro - Ubuntu"

    message "Making vim default editor for default user and root..."
    echo "export EDITOR=vim" | sudo tee -a ~/.bashrc
    echo "export EDITOR=vim" | sudo tee -a /root/.bashrc

    message "Updating system..."
    sudo apt-get update
    sudo apt-get upgrade -y

    message "Cleaning up..."
    sudo apt autoremove --purge -y
    
    message "Installing software"
    sudo apt-get install bat stress -y
    sudo apt-get clean

  elif [  -n "$(uname -a | grep -i amzn)" ]; then
    message "Distro - Amazon Linux"

    message "Fixing US locale..."
    echo "LANG=en_US.utf-8" | sudo tee -a /etc/environment
    echo "LC_ALL=en_US.utf-8" | sudo tee -a /etc/environment
    sudo localectl set-locale LANG=en_US.UTF-8
    sudo localectl set-keymap us

    message "Installing epel and updating system..."
    sudo amazon-linux-extras install epel -y
    sudo yum update -y

    message "Installing software..."
    sudo yum install vim htop stress -y

    message "Cleaning up..."
    sudo yum autoremove -y
    sudo yum clean all

    message "Installing bat..."
    bat-install

    message "Making vim default editor for default user and root..."
    echo "export EDITOR=vim" | sudo tee -a ~/.bashrc
    echo "export EDITOR=vim" | sudo tee -a /root/.bashrc
    
  elif [  -n "$(uname -a | grep -i el[1-99])" ]; then
    
    message "Distro CentOS/RHEL"

    message "Fixing US locale..."
    echo "LANG=en_US.utf-8" | sudo tee -a /etc/environment
    echo "LC_ALL=en_US.utf-8" | sudo tee -a /etc/environment
    sudo localectl set-locale LANG=en_US.UTF-8
    sudo localectl set-keymap us

    message "Installing epel and updating system..."
    sudo yum install epel-release -y
    sudo yum update -y

    message "Installing software..."
    sudo yum install vim htop stress -y

    message "Cleaning up..."
    sudo yum autoremove -y
    sudo yum clean all

    message "Installing bat..."
    bat-install

    message "Making vim default editor for default user and root..."
    echo "export EDITOR=vim" | sudo tee -a ~/.bashrc
    echo "export EDITOR=vim" | sudo tee -a /root/.bashrc
  fi  
} 2>/tmp/provision-err.log \
  |& tee /tmp/provision-full.log

if [  -n "$(uname -a | grep -i ubuntu)" ]; then
  echo
  echo
  echo "########################################"
  echo "Completed!"
  echo "To see full log:"
  echo "batcat /tmp/provision-full.log"
  echo
  echo "To see error-only log:"
  echo "batcat /tmp/provision-err.log"
  echo "########################################"
  echo "Loading provision-err.log..."
  batcat /tmp/provision-err.log
else
  echo
  echo
  echo "########################################"
  echo "Completed!"
  echo "To see full log:"
  echo "bat /tmp/provision-full.log"
  echo
  echo "To see error-only log:"
  echo "bat /tmp/provision-err.log"
  echo "########################################"
  echo "Loading provision-err.log..."
  bat /tmp/provision-err.log
fi
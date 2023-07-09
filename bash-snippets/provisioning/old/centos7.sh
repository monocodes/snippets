#!/bin/bash

#################################################
# CentOS 7
#################################################

echo
echo "##########################################"
echo "fix US locale settings"
echo "##########################################"
echo
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment
sudo localectl set-locale LANG=en_US.UTF-8
sudo localectl set-keymap us

echo
echo "##########################################"
echo "install epel-release"
echo "##########################################"
echo
sudo yum install epel-release -y

echo
echo "##########################################"
echo "update all packages and install some"
echo "##########################################"
echo
sudo yum update -y
sudo yum install vim htop -y


echo
echo "##########################################"
echo "make vim default editor for root and centos user"
echo "##########################################"
echo
sudo echo "export EDITOR=vim" >> /root/.bashrc
sudo echo "export EDITOR=vim" >> /home/centos/.bashrc



#################################################
# Script installs latest version of bat on CentOS 7
# https://github.com/sharkdp/bat
#################################################

### NOTE
# after installation, if you want to install bat system-wide for root also
# sudo cp /usr/local/bin/bat /bin

### NOTE
# Ubuntu install
# sudo apt install bat
# On Debian and Ubuntu, bat uses the batcat command by default because of a conflict with an existing package, bacula-console-qt. You can, however, use the following commands to link the bat command:
# mkdir -p ~/.local/bin
# ln -s /usr/bin/batcat ~/.local/bin/bat

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
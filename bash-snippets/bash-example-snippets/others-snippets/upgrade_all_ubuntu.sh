#!/bin/bash

# #########
# OS Updater
# *Ubuntu only
# @author @guikingma
# https://gist.github.com/guikingma/17caf4a6acb50905dd134ce2ce5deff4
# #########

# #########

# Determine OS platform
UNAME=$(uname | tr "[:upper:]" "[:lower:]")
# If Linux, try to determine specific distribution
if [ "$UNAME" == "linux" ]; then
    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    # Otherwise, use release info file
    else
        export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
    fi
fi
# For everything else (or if above failed), just use generic identifier
[ "$DISTRO" == "" ] && export DISTRO=$UNAME
unset UNAME

# #########

function message() {
    echo ""
    echo ""
    echo "$1"
    read -n 1 -s -r -p "Press any key to continue"
    clear
}


function upgrade_all() {
    message "Update:"
    sudo apt-get update

    message "Upgrade:"
    sudo apt-get upgrade

    message "Dist Upgrade:"
    sudo apt-get dist-upgrade

    message "Drivers Update:"
    sudo ubuntu-drivers autoinstall

    message "Auto Remove:"
    sudo apt-get autoremove

    message "Auto Clean:"
    sudo apt-get autoclean 

    if [ -d "$HOME/.pyenv" ]; then
        message "pyenv:"
        cd ~/.pyenv
        git pull origin master
    fi

    if [ -d "$HOME/.pyenv/plugins/pyenv-virtualenv" ]; then
        message "pyenv-virtualenv:"
        cd ~/.pyenv/plugins/pyenv-virtualenv
        git pull origin master
    fi

    message "All done!"
    cd
}

# #########

if [ $DISTRO != "Ubuntu" ]; then
    echo "Incompatible distro!"
    echo "Works only on Ubuntu-based Linux operating system."
else
    upgrade_all
fi
---
title: python-modules
categories:
  - software
  - guides
  - notes
  - code
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [pip install](#pip-install)
- [fabric](#fabric)
  - [how to use fabric example](#how-to-use-fabric-example)

## pip install

Install `pip` on **Ubuntu 22**

```sh
sudo apt install python3-pip
```

check `pip` version

```sh
pip3 --version
```

---

## fabric

there are different ways how to install fabric

one of them is using `pip`

```sh
pip install fabric
```

---

### how to use fabric example

create `fabfile.py` in workdir and define functions inside

```python
# example for python2
from fabric.api import *

def greeting(msg):
    print "Good %s" % msg # %s because python2

def system_info():
    print "Disk Space"
    local("df -h")

    print "Ram size"
    local("free -m")

    print "System uptime."
    local("uptime")

def remote_exec():
    print "Get System Info"
    run("hostname")
    run("uptime")
    run("df -h")
    run("free -m")
    
    # sudo will run commands with root priveleges
    sudo("yum install mariadb-server -y")
    sudo("systemctl start mariadb")
    sudo("systemctl enable mariadb")

def web_setup(WEBURL, DIRNAME):
    print "#############################################"
    local("apt update")
    local("apt install zip unzip -y")

    print "#############################################"
    print "Installing dependencies"
    print "#############################################"
    sudo("yum install httpd wget unzip -y")

    print "#############################################"
    print "Start & enable service."
    print "#############################################"
    sudo("systemctl start httpd")
    sudo("systemctl enable httpd")

    print "#############################################"
    print "Downloading and pushing website to webservers."
    print "#############################################"
    local(("wget -O website.zip %s") % WEBURL)
    local("unzip -o website.zip")

    with lcd(DIRNAME): # lcd - local cd
        local("zip -r tooplate.zip * ")
        put("tooplate.zip", "/var/www/html/", use_sudo=True)
    
    with cd("/var/www/html/"):
        sudo("unzip -o tooplate.zip")
    
    sudo("firewall-cmd --add-service=http --permanent")
    sudo("systemctl restart firewalld")
    sudo("systemctl restart httpd")

    print "Website setup is done."
```

check available functions

```sh
fab -l

# output
/usr/local/lib/python2.7/dist-packages/paramiko/transport.py:33: CryptographyDeprecationWarning: Python 2 is no longer supported by the Python core team. Support for it is now deprecated in cryptography, and will be removed in the next release.
  from cryptography.hazmat.backends import default_backend
Available commands:

    greeting
    remote_exec
    system_info
```

call `greeting` function with `Evening` arg

```sh
fab greeting:Evening

# output
/usr/local/lib/python2.7/dist-packages/paramiko/transport.py:33: CryptographyDeprecationWarning: Python 2 is no longer supported by the Python core team. Support for it is now deprecated in cryptography, and will be removed in the next release.
  from cryptography.hazmat.backends import default_backend
Good Evening

Done.
```

`system_info` function

```sh
fab system_info
```

`remote_exec` function example on remote host

```sh
fab -H 192.168.10.3 -u devops remote_exec
# -H - host
# -u - user
# -p - password (should never use it, manage key-based login instead)
```

`web_setup` function example on remote host

```sh
fab -H 192.168.10.3 -u devops web_setup:https://www.tooplate.com/zip-templates/2121_wave_cafe.zip,2121_wave_cafe
# must be no spaces between args!!!

# simultaniosly for two hosts
fab -H 192.168.10.3,192.168.10.4 -u devops web_setup:https://www.tooplate.com/zip-templates/2121_wave_cafe.zip,2121_wave_cafe
```

---

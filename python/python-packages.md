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

- [docstrings](#docstrings)
- [pip](#pip)
  - [pip install](#pip-install)
  - [pip commands](#pip-commands)
- [python packages](#python-packages)
  - [pip-review](#pip-review)
  - [requirements.txt](#requirementstxt)
    - [pipreqs](#pipreqs)
      - [update **pyenv** venv with **pipreqs**](#update-pyenv-venv-with-pipreqs)
    - [pip freeze](#pip-freeze)
  - [fabric](#fabric)
    - [fabric example](#fabric-example)
  - [coursera-dl](#coursera-dl)

## docstrings

show **Docstring** for package

1. launch python

   ```sh
   python
   # or
   python3
   ```

2. import installed package

   ```python
   import plotly
   ```

3. show docstring of specified package

   ```python
   help(plotly.graph_objects)
   ```

4. show docstring of specified function

   ```python
   help(plotly.graph_objects.Bar)
   ```

---

## pip

### pip install

install pip from scratch (where no pip installed)

```sh
python3 -m ensurepip
```

or install pip from official script

```sh
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
```

install pip on **Ubuntu 22**

```sh
sudo apt install python3-pip
```

check pip version

```sh
pip3 --version
```

install pip autocompletion

```sh
# zsh
pip completion --zsh >> ~/.zshrc && \
  source ~/.zshrc
# bash
pip completion --bash >> ~/.bashrc && \
  source ~/.bashrc
```

show pip autocopmletion options

```sh
pip help completion
```

---

### pip commands

upgrade pip  
`-U` - upgrade

```sh
pip install -U pip
```

show installed packages

```sh
pip list
```

show oudated installed packages

```sh
pip list --outdated
```

update package

```sh
pip install package-name -U
```

check missing dependencies

```sh
pip check
# or
python -m pip check
```

completely uninstall pip

```sh
python -m pip uninstall pip setuptools
# or
pip freeze | xargs pip uninstall -y
```

install version less then

```sh
pip install 'package-name<version-name'

# example
pip install 'fabric<2.0'
```

---

## python packages

### pip-review

**pip-review** - a package for easy updating other pip packages

install pip-review

```sh
pip install pip-review
```

show outdated packages

```sh
pip-review
```

upgrade all outdated packages interactively

```sh
pip-review -i
```

upgrade all outdated packages automatically

```sh
pip-review -a
```

---

### requirements.txt

*requirements-general.txt*

```properties
pip-review
pipreqs
```

---

#### pipreqs

**pipreqs** - package for generating requirements.txt

> **pipreqs** scans the *.py* files in the root folder & uses the imports in the project to generate the file, so in case there are some additional plugin dependencies, you will have to add them manually.

install pipreqs

```sh
pip install pipreqs
```

generate *requirements.txt* with pipreqs in current directory

```sh
pipreqs
```

generate *requirements.txt* with pipreqs in specified directory

```sh
pipreqs /path/to/dir
```

review the packages before creating the file

```sh
pipreqs --print
```

generate *requirements.txt* and overwrite existing file

```sh
pipreqs --force
```

generate *requirements.txt* and ignore dirs inside

```sh
pipreqs /path/to/dir --ignore /path/to/directory
```

generate *requirements.txt* and store it in another location

```sh
pipreqs /path/to/dir --savepath /path/to/dir/
```

##### update **pyenv** venv with **pipreqs**

1. generate *requirements.txt* under venv

   ```sh
   pipreqs /path/to/dir
   ```

2. uninstall venv

   ```sh
   pyenv uninstall -f venv-name
   ```

3. create new venv with new python version

   ```sh
   pyenv virtualenv 3.11.3 venv-name
   ```

4. reinstall everything from requirements.txt under venv

   ```sh
   pip install -r requirements.txt
   # or with -U - upgrade
   pip install -U -r requirements.txt
   ```

---

#### pip freeze

> The above approach works well if you have a virtual env that consists of only the project-specific packages. But in case, you don’t have a virtual env created, **pip freeze** will save all the packages that were installed in the base environment even if we are not using them in our project.

show all installed python packages with their versions

```sh
pip freeze
```

generate *requirements.txt* and save it in file

```sh
pip freeze > requirements.txt
```

---

### fabric

there are different ways how to install fabric

one of them is using `pip`

```sh
pip install fabric
```

---

#### fabric example

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

### coursera-dl

> **coursera-dl** from pip is no longer working.

Install working version of **coursera-dl**

1. install python 3.8.10

   ```sh
   pyenv install 3.8.10
   ```

2. create venv

   ```sh
   pyenv virtualenv 3.8.10 venv-test
   ```

3. install coursera-dl raffaem fork in venv-test

   ```sh
   pip uninstall coursera-dl
   git clone https://github.com/raffaem/coursera-dl
   cd coursera-dl
   pip install .
   ```

4. create *coursera-dl.conf*

   ```properties
   --cauth XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   --resume
   --video-resolution 720p
   --subtitle-language en,ru
   --download-quizzes
   --download-notebooks
   --download-delay 120
   #--mathjax-cdn https://cdn.bootcss.com/mathjax/2.7.1/MathJax.js
   # more other parameters
   ```

5. fetch CAUTH token from Google Chrome

   - login on coursera.org -> press `F12` -> Application -> Cookies -> <https://coursera.org>
   - search for **CAUTH**, copy the key and add it to *coursera-dl.conf*

6. fetch the course name from its webpage address

   - for example, <https://www.coursera.org/learn/python-crash-course/home/week/1>
   - python-crash-course

7. download course

   ```sh
   coursera-dl python-crash-course
   ```

---

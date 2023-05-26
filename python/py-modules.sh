### PYTHON HELP ---------------------------------

### DOCSTRINGS ###
# in terminal go to python
python

# firstly import installed package
import plotly

# read the docstring of desired package
help(plotly.graph_objects)

# read the docstring of desired function
help(plotly.graph_objects.Bar)



### PIP -----------------------------------------
# install pip from scratch (where no pip installed)
python3 -m ensurepip

# or install pip from official script
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

# python standard package manager
# upgrade pip
pip install -U pip

# list oudated installed packages
pip list --outdated

# update package
pip install package-name -U

# completely uninstall pip
pip freeze | xargs pip uninstall -y
python -m pip uninstall pip setuptools

# install version less then
pip install 'package-name<version-name'
# example
pip install 'fabric<2.0'



### PIP-REVIEW ----------------------------------
# a package for easy updating other pip packages

# Upgrade all local packages, you can install pip-review:
pip install pip-review

# show outdated packages
pip-review

# After that, you can either upgrade the packages interactively:
pip-review -i

# Or automatically:
pip-review -a



### PYTHON REQUIREMENTS.TXT ---------------------

### PIPREQS -------------------------------------
# pipreqs automatically generates requirements.txt
### NOTE ----------------------------------------
"""
pipreqs scans the .py files in the root folder & uses the imports in the project to generate the file, so in case there are some additional plugin dependencies, you will have to add them manually.
"""
# installing pipreqs
pip install pipreqs

# generate requirements.txt with pipreqs in current directory
pipreqs

# generate requirements.txt with pipreqs in specific directory
pipreqs /home/project/location

# you want to review the packages before creating the file
pipreqs --print

# if the requirements.txt is already created & you want to overwrite it
pipreqs --force

# If there are multiple sub-directories within your project & you want to ignore them while creating the requirements
pipreqs /path/to/project --ignore /path/to/directory

# If you want to store the packages in some other file
pipreqs /path/to/project --savepath /location/of/file/

# best practice to use pipreqs with venvs
# how to update venv python version

# generate requirements.txt under venv
pipreqs /home/project/location
pyenv uninstall -f venv-name
pyenv virtualenv 3.10.7 venv-name

# reinstall everything from requirements.txt under venv
pip install -r requirements.txt

# reinstall and upgrade everything from requirements.txt under venv
pip install -U -r requirements.txt 



### PIP FREEZE ----------------------------------
### NOTE ----------------------------------------
"""
The above approach works well if you have a virtual env that consists of only the project-specific packages. But in case, you don’t have a virtual env created, pip freeze will save all the packages that were installed in the base environment even if we are not using them in our project.
"""
# pip freeze outputs a list of all installed Python modules with their versions
pip freeze

# generates requirements.txt and save it in file
# use this command if you don't want to install and use pipreqs
pip freeze > requirements.txt



### PIP -----------------------------------------
# pip - python package manager

# setup pip autocompletion
# zsh
pip completion --zsh >> ~/.zshrc
# bash
pip completion --bash >> ~/.bashrc

# reintialize shell after modifying it
exec zsh -l
exec bash -l

# display pip autocopmletion options
pip help completion

# install needed package
pip install name-of-module

# show installed packages
pip list

# show outdated packages
pip list --outdated

# upgrade package
pip install -U name-of-package

# check for missing dependencies
python -m pip check



### COURSERA-DL ---------------------------------
# coursera-dl in pip is no longer working
# to install working version you need

# install python 3.8.10
pyenv install 3.8.10

# create venv
pyenv virtualenv 3.8.10 venv-test

# install coursera-dl raffaem fork in venv-test
pip uninstall coursera-dl
git clone https://github.com/raffaem/coursera-dl
cd coursera-dl
pip install .


# create coursera-dl.conf
coursera-dl.conf

--cauth XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--resume
--video-resolution 720p
--subtitle-language en,ru
--download-quizzes
--download-notebooks
--download-delay 120
#--mathjax-cdn https://cdn.bootcss.com/mathjax/2.7.1/MathJax.js
# more other parameters


# fetch CAUTH token from Google Chrome
# login on coursera.org, press F12, Application, Cookies, https://coursera.org
# search for CAUTH, copy the key and add it to coursera-dl.conf

# fetch the course name from its webpage address
# for example, https://www.coursera.org/learn/python-crash-course/home/week/1
# python-crash-course

# download course you need
coursera-dl python-crash-course
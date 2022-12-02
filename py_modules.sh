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
# python standard package manager
# upgrade pip
pip install --upgrade pip

# list oudated installed packages
pip list --outdated



### PIP-REVIEW ----------------------------------
# a package for easy updating other pip packages

# To upgrade all local packages, you can install pip-review:
pip install pip-review

# After that, you can either upgrade the packages interactively:
pip-review --local --interactive

# Or automatically:
pip-review --local --auto



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

# list outdated packages
pip list --outdated

# upgrade package
pip install -U name-of-package

# check for missing dependencies
python -m pip check
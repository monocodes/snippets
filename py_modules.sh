### PYTHON REQUIREMENTS.TXT ---------------------

### PIPREQS -------------------------------------
# pipreqs automatically generates requirements.txt
pip install pipreqs

# generate requirements.txt with pipreqs 
pipreqs

# generate requirements.txt with pipreqs in specific directory
pipreqs /home/project/location

# best practice to use pipreqs with venvs
# how to update venv python version

# generate requirements.txt under venv
pipreqs /home/project/location
pyenv uninstall -f venv-name
pyenv install 3.10.7 venv-name

# reinstall everything from requirements.txt under venv
pip install -r requirements.txt

# reinstall and upgrade everything from requirements.txt under venv
pip install -U -r requirements.txt



### PIP FREEZE ----------------------------------
# pip freeze outputs a list of all installed Python modules with their versions
pip freeze

# generates requirements.txt and save it in file
# use this command if you don't want to install and use pipreqs
pip freeze > requirements.txt



### PIP -----------------------------------------
# pip - python package manager

# install needed package
pip install name-of-module

# list outdated packages
pip list --outdated

# upgrade package
pip install -U name-of-package

# check for missing dependencies
python -m pip check
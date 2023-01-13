### PYTHON INSTALL ------------------------------
# one of the best ways to install and use python on macos involves using brew and pyenv

# first install the homebrew xcode and Xcode Command Line Tools
# prerequisite install Xcode Command Line Tools
xcode-select --install

# install pyenv
brew install pyenv

# configure auto-activation of pyenv and penv-virtualenv
# In other words, to auto activate (and deactivate) virtualenvs upon entering (and leaving) directories that contain a pyenv’s .python-version file, you should have the following lines at the end of ~/.zshrc:

nano ~/.zshrc

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)";
  eval "$(pyenv virtualenv-init -)"; 
fi

# There is a downside to auto-activation, though. The auto-switch seems to slow zsh down quite a bit. For more information on this, read #132 (https://github.com/pyenv/pyenv-virtualenv/issues/132) and #259 (https://github.com/pyenv/pyenv-virtualenv/issues/259).



# check python version
python --version



### PYENV ---------------------------------------

# install peynv-virtualenv
brew install pyenv-virtualenv

# list avalaible python packages
pyenv install -l

# install needed python version, for example:
pyenv install 3.10.4

# set global used python version
pyenv global 3.10.4

# check pyenv installed python versions
pyenv versions

# check global version in use
pyenv version

# create new virtual environment for project specifying a python version or not 
pyenv virtualenv 3.10.5 name-of-virtualenv

# cd to the project directory and specify python version or virtualenv, for example you can use virtualenv name or dedicated python version:
cd /Users/serj/Yandex.Disk.localized/Documents/study/code/python
pyenv local name-of-virtualenv
# check created file
cat .python-version
# don't forget to point VS Code to use this virtualenv

# You can also activate and deactivate a pyenv virtualenv manually:
pyenv activate name
pyenv deactivate name



### PYENV UNINSTALL -----------------------------
pyenv uninstall name-of-python
pyenv uninstall name-of-virtualenv

# force uninstall
pyenv uninstall -f name-of-virtualenv



### PYTHON USEFUL COMMANDS ----------------------
python -V
python3 -V

# where is python bin
which python
which python3


### UNINSTALL PYTHON COMPLETELY -----------------
cd Library
sudo rm -rf Python

# Additionally, three more main directories have to be handled in order to remove Python. Move back to your root user directory and perform the following commands:
sudo rm -rf /Applications/Python
sudo rm -rf /Library/Frameworks/Python.framework
sudo rm -rf /usr/local/bin/python

# Note: We do not recommend this step for novice Mac users. The way Python files are distributed in your Library and cache may differ based on your use, and so, extra files may have to be deleted which you can search for in the Finder or manually in the terminal.

# Step 3: Remove Python symbolic links
"""
The symlinks referencing Python frameworks are in the /usr/local/bin directory. If you would like to see the broken symlinks, please use the following command.
"""
# become root
sudo -i

# check first
ls -l /usr/local/bin | grep '../Library/Frameworks/Python.framework'

# delete
ls -l /usr/local/bin | grep '../Library/Frameworks/Python.framework' | awk '{print $9}' | tr -d @ | xargs rm

# check again
ls /usr/local/bin
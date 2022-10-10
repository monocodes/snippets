### INSTALL GIT ---------------------------------
brew install git

# check version
# don't forget to reset terminal
git --version

# configure git
git config --global user.name "username"
git config --global user.email "username@example.com"

### .gitignore ###
# go to new project directory and make .gitignore file
# for python add __pycache__/



### GIT INIT ------------------------------------
# initializing a repository
git init



### GIT STATUS ----------------------------------
# check the repository
git status



### GIT ADD -------------------------------------
# add all files to repository
git add .



### GIT COMMIT ----------------------------------
# commit with message
git commit -m "Commentary"

# commit with message and add all modified files in the repository to the current commit
git commit -am "Commentary"



### GIT LOG -------------------------------------
# check the git logs
git log

# check git logs short message in one line
git log --pretty=oneline



### GIT CHECKOUT --------------------------------
# revert all to the last commit
git checkout .

# revert changes to the specific commit - use first six symbols of a commit
git checkout ee7641

"""
When you check out a previous commit, you leave the master branch and enter what Git refers to as a detached HEAD state ➊. HEAD is the current committed state of the project; you’re detached because you’ve left a named branch (master, in this case).
"""

# get back to the main branch
git checkout main

# get back to previous commit
git reset --hard ee7641



### GIT COMMANDS

### git ls ###
# display files in repository
git ls-files


### git rm ###
# delete file from repository and filesystem
git rm filename

# delete file only from repository
git rm filename --cached



### DELETING A REPOSITORY -----------------------
rm -rf .git
git init
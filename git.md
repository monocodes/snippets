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

# display last changes before commit
git add -p

# add internal directory in project
"""
If you want to add a directory and all the files which are located inside it recursively, Go to the directory where the directory you want to add is located.
"""
cd directory
git add directoryname



### GIT COMMIT ----------------------------------

# commit with message after "git add filename"
git commit -m "Commentary"

# commit with message and add all modified files in the repository
# to the current commit
git commit -am "Commentary"

# change the last commit message (comment) if there were a mistakes or typos
git commit --amend
# if old commit has already been pushed:
git push --force-with-lease

### BEST PRACTICE for commits ###
git commit -a
"""
Type the subject of your commit on the first line. Remember to keep it short (not more than 50 characters). Leave a blank line after.
Write a detailed description of what happened in the committed change. Use multiple paragraphs and bullet points to give a detailed breakdown. Don’t write everything out on one line, instead, wrap text at 72 characters.

Write your commit message in the imperative: “Fix bug” and not “Fixed bug” or “Fixes bug.” This convention matches up with commit messages generated by commands like git merge and git revert.

A commit message should answer three primary questions;

Why is this change necessary?
How does this commit address the issue?
What effects does this change have?
"""



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



### GIT PUSH ------------------------------------
# sync changes from local repository to external
git push

# forced
git push --force



-------------------------------------------------
# GIT CLONE
-------------------------------------------------
# got clone only single branch
git clone -b mybranch --single-branch git://sub.domain.com/repo.git

# examples
git clone -b local-setup --single-branch https://github.com/devopshydclub/vprofile-project.git



-------------------------------------------------
# GIT COMMANDS
-------------------------------------------------
### git ls ###
# display files in repository
git ls-files


### git rm ###
# delete file from repository and filesystem
git rm filename

# delete file only from repository
git rm filename --cached


### Example to ignore previously committed dir logs/ ###
# update .gitignore file to ignore dir
logs/

# remove dir or file from the repo
#use relative path of the project and "" if you have any spaces in path
git rm -r --cached "Section 5. Building Multi-Container Applications with Docker/goals-multi-web-nodejs/backend/logs"

# do commit
git commit -am "Start ignoring Section 5. Building Multi-Container Applications with Docker/goals-multi-web-nodejs/backend/logs"



### DELETING A REPOSITORY -----------------------
rm -rf .git
git init
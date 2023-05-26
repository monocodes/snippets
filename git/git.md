---
title: git
categories:
  - software
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [install and files](#install-and-files)
  - [install git macos](#install-git-macos)
  - [.gitignore](#gitignore)
  - [git config file](#git-config-file)
  - [sync local git repo with remote git repo](#sync-local-git-repo-with-remote-git-repo)
- [git commands](#git-commands)
  - [git init](#git-init)
  - [git status](#git-status)
  - [git diff](#git-diff)
  - [git add](#git-add)
  - [git commit](#git-commit)
  - [git revert](#git-revert)
  - [git reset](#git-reset)
  - [git log](#git-log)
  - [git show](#git-show)
  - [git clone](#git-clone)
  - [git branch](#git-branch)
  - [git checkout](#git-checkout)
  - [git switch](#git-switch)
  - [git push](#git-push)
  - [git merge](#git-merge)
  - [git pull](#git-pull)
  - [git ls](#git-ls)
  - [git mv](#git-mv)
  - [git rm](#git-rm)
    - [Example to ignore previously committed dir `logs/`](#example-to-ignore-previously-committed-dir-logs)
    - [Delete file or folder from the local and remote repos from every commit](#delete-file-or-folder-from-the-local-and-remote-repos-from-every-commit)
  - [delete a repository](#delete-a-repository)
- [git guides](#git-guides)
  - [Sync local repos with remote repos and renamed account on GitHub](#sync-local-repos-with-remote-repos-and-renamed-account-on-github)
  - [Change remote origin](#change-remote-origin)
  - [git commit -m ""](#git-commit--m-)

## install and files

### install git macos

```sh
brew install git
```

check version  
don't forget to reset terminal

```sh
git --version
```

configure git

```sh
git config --global user.name "username"
git config --global user.email "username@example.com"
```

---

### .gitignore

go to new project directory and make `.gitignore` file  
for python add `__pycache__/`

---

### git config file

repo git config file

```sh
cat .git/config
```

---

### sync local git repo with remote git repo

1. add remote repository to local one  

    ```sh
    git remote add origin https://github.com/username/repo-name.git
    ```

2. change branch name `master` to `main`  

    ```sh
    git branch -M main
    ```

3. push all repo data with all commits to remote repo in branch `main`  

    ```sh
    git push -u origin main
    ```

---

## git commands

### git init

initialise a repository

```sh
git init
```

---

### git status

check the repository

```sh
git status
```

---

### git diff

show differences from last commit

```sh
git diff
```

show cached differences from last commit and staged files (for example, after `git add .` command)

```sh
git diff --cached
```

show differences between commits

```sh
git log --oneline # grab commit ids
git diff 44423ee..9276d47
```

---

### git add

add all files to repository and stage them

```sh
git add .
```

revert file from last staging (`git add .`)

```sh
git restore --staged filename
```

display last changes before commit

```sh
git add -p
```

add internal directory in project

> If you want to add a directory and all the files which are located inside it recursively, go to the directory where the directory you want to add is located.

```sh
cd directory
git add directoryname
```

---

### git commit

commit with message after `git add filename`

```sh
git commit -m "Commentary"
```

commit with message and add automatically stage files that have been modified and deleted, but new files you have not told Git about are not affected.

```sh
git commit -am "Commentary"
```

change the last commit message (comment) if there were a mistakes or typos

```sh
git commit --amend
```

if old commit has already been pushed

```sh
git push --force-with-lease
```

---

### git revert

go back to previous commit  

> use `git revert` if you are ok with history been stored. Instead use `git reset --hard`

```sh
git revert Head
# or specific commit
git revert 44423ee
```

---

### git reset

go back to commit without history been saved

```sh
git reset --hard 44423ee
```

---

### git log

check all commits in current branch

```sh
git log
```

check all commit in current branch oneline

```sh
git log --oneline
```

check all commits in current branch with short message in one line

```sh
git log --pretty=oneline
```

---

### git show

show changes in commit

```sh
git show commit-name
```

---

### git clone

clone repository

```sh
git clone repository-url-name

# example
git clone https://github.com/devopshydclub/vprofile-project.git
```

git clone only single branch

```sh
git clone -b mybranch --single-branch git://sub.domain.com/repo.git

# example
git clone -b local-setup --single-branch https://github.com/devopshydclub/vprofile-project.git
```

---

### git branch

show all available branches

```sh
git branch -a
```

switch to different branch

```sh
git checkout branch-name

# example
git clone https://github.com/devopshydclub/vprofile-project.git
cd vprofile-project
git branch -a
git checkout aws-Refactor
```

create a copy of current branch

```sh
git branch -c branch-name
```

---

### git checkout

switch to different branch

```sh
git checkout branch-name
```

revert the changes to the last commit in particular file

```sh
git checkout filename
```

revert all to the last commit

```sh
git checkout .
```

- revert changes to the specific commit - use first six symbols of a commit

  - ```sh
      git checkout ee7641
      ```

  - > When you check out to a previous commit, you leave the master branch and enter what Git refers to as a detached `HEAD` state ➊. `HEAD` is the current committed state of the project; you’re detached because you’ve left a named branch (`main`, in this case).

  - get back to the main branch

    - ```sh
        git checkout main
        ```

  - get back to previous commit

    - ```sh
        git reset --hard ee7641
        ```

---

### git switch

switch to different branch

```sh
git switch branch-name
```

---

### git push

sync changes from local repo to external (to the current branch)

```sh
git push
```

forced push

```sh
git push --force
```

push changes to `main` branch

```sh
git push origin main
```

push all changes in all branches

```sh
git push --all origin
```

---

### git merge

merge changes to current branch from another branch

```sh
git merge branch-name
```

---

### git pull

pull latest changes

```sh
git pull
```

---

### git ls

display files in repository

```sh
git ls-files
```

---

### git mv

rename or move the file inside working dir and git index

```sh
git mv filename path/to/dir
git mv filename filename1
```

---

### git rm

delete file from repository and filesystem

```sh
git rm filename
```

delete file only from repository

```sh
git rm filename --cached
```

---

#### Example to ignore previously committed dir `logs/`

1. update .gitignore file to ignore dir `logs/`

2. remove dir or file from the repo  
    use relative path of the project and `""` if you have any spaces in path  

    ```sh
    git rm -r --cached "Section 5. Building Multi-Container Applications with Docker/goals-multi-web-nodejs/backend/logs"
    ```

3. do commit  

    ```sh
    git commit -am "Start ignoring Section 5. Building Multi-Container Applications with Docker/goals-multi-web-nodejs/backend/logs"
    ```

---

#### Delete file or folder from the local and remote repos from every commit

> <https://stackoverflow.com/questions/35115585/remove-files-completely-from-git-repository-along-with-its-history>

if you want to use file in future locally update `.gitignore` file to ignore file or dir

```properties
dir-name/
filename
```

1. delete file from local repo globally from every commit  
    `--invert-paths` - indicates to exclude, not include the following paths  

    ```sh
    git filter-repo --invert-paths --force --path filename
    ```

2. link again local repo to remote repo  

    ```sh
    git remote add repo-name repo-url
    
    # example
    git remote add commands https://github.com/monocodes/commands.git
    ```

3. push to master branch  

    ```sh
    git push --set-upstream repo-name main/master branch --force
    
    # example
    git push --set-upstream commands main --force
    ```

---

### delete a repository

```sh
rm -rf .git
git init
```

---

## git apps

### Sourcetree

Sourcetree has glitches with GitHub Auth and ssh keys.

If it can't commit use **GitHub Access Keys** or:

1. Exit Sourcetree

2. Check keys in ssh-agent

   ```sh
   ssh-add -l
   ```

3. Remove your ssh key for GitHub from ssh-agent or all keys

   ```sh
   ssh-add -d
   ```

4. Add again your GitHub ssh key to key-agent

   ```sh
   # example
   ssh-add --apple-use-keychain ~/.ssh/id_ed25519
   ```

5. Start SourceTree

6. Enter Settings with `Cmd + ,` -> Accounts -> OAuth -> SSH  
   Sourcetree will complain that *no key found*, it's ok :)

---

## git guides

### Sync local repos with remote repos and renamed account on GitHub

If all local repos are in **GitHub Desktop** local repos will switch automatically.

### Change remote origin

Switch from **GitHub** to **CodeCommit**

1. Checkout all branches in local repo to push them to another repo after that (branches need to be checked out to be pushed)

2. View all branches without `/` and store them to the text file

    ```sh
    git branch -a | grep -v HEAD | cut -d '/' -f3 | grep -v master
    
    git branch -a | grep -v HEAD | cut -d '/' -f3 | grep -v master > ~/tmp/branches
    
    # check file and delete all unwanted symbols
    vim ~/tmp/branches
    ```

3. Check output of the script first and the checkout all branches

    ```sh
    for i in `cat ~/tmp/branches`; do echo $i;done
    
    for i in `cat ~/tmp/branches`; do git checkout $i;done
    ```

4. Fetch tags

    ```sh
    git fetch --tags
    ```

5. Check that all branches was checked out

    ```sh
    git branch -a
    ```

6. Remove old **GitHub** **origin** from local repo

    ```sh
    git remote rm origin
    ```

7. Add new **CodeCommit** **origin** to the local repo (you need ssh access to the repo)

    ```sh
    git remote add origin ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/vprofile-code-repo
    ```

8. Check new remote repo in **git** config

    ```sh
    cat .git/config
    
    # Output
    [core]
    	repositoryformatversion = 0
    	filemode = true
    	bare = false
    	logallrefupdates = true
    	ignorecase = true
    	precomposeunicode = true
    [remote "origin"]
    	url = ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/vprofile-code-repo
    	fetch = +refs/heads/*:refs/remotes/origin/*
    ```

9. Push all branches and tags to the remote repo

    ```sh
    git push origin --all
    
    git push --tags
    ```

---

### git commit -m ""

Type the subject of your commit on the first line. Remember to keep it short (not more than 50 characters). Leave a blank line after.

Write a detailed description of what happened in the committed change. Use multiple paragraphs and bullet points to give a detailed breakdown. Don’t write everything out on one line, instead, wrap text at 72 characters.

Write your commit message in the imperative: “Fix bug” and not “Fixed bug” or “Fixes bug.” This convention matches up with commit messages generated by commands like git merge and git revert.

A commit message should answer three primary questions:

- Why is this change necessary?
- How does this commit address the issue?
- What effects does this change have?

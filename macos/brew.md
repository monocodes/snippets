---
title: brew
categories:
  - software
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [brew install](#brew-install)
  - [macOS](#macos)
    - [new (need to test)](#new-need-to-test)
    - [old](#old)
  - [Linux](#linux)
- [brew uninstall](#brew-uninstall)
- [brew paths](#brew-paths)
- [brew commands](#brew-commands)
  - [brew multi-user system](#brew-multi-user-system)
    - [brew multi-user scripts](#brew-multi-user-scripts)
  - [diagnostics](#diagnostics)
  - [update and upgrade](#update-and-upgrade)
  - [search](#search)
  - [install](#install)
  - [uninstall](#uninstall)
  - [link](#link)
- [homebrew terminology and theory](#homebrew-terminology-and-theory)

## brew install

- [Install Homebrew](https://brew.sh/)
- [`brew` Shell Completion](https://docs.brew.sh/Shell-Completion)
- [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux)
- [Interesting Taps and Forks](https://docs.brew.sh/Interesting-Taps-and-Forks)

>The installation script installs Homebrew to `/home/linuxbrew/.linuxbrew` using `sudo`. Homebrew does not use `sudo` after installation. Using `/home/linuxbrew/.linuxbrew` allows the use of most binary packages (bottles) which will not work when installing in e.g. your personal home directory.

### macOS

#### new (need to test)

brew install one-liner macOS (interactive)

```bash
xcode-select -p &>/dev/null || xcode-select --install
command -v brew &>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
touch $HOME/.zprofile $HOME/.zshrc
grep -q brew $HOME/.zprofile || cat << EOF >> $HOME/.zprofile
eval \$(/opt/homebrew/bin/brew shellenv)
EOF
eval \$(/opt/homebrew/bin/brew shellenv)
brew analytics off
brew tap beeftornado/rmtree
grep -q compinit $HOME/.zshrc || cat << EOF >> $HOME/.zshrc
if type brew &>/dev/null; then
  fpath=(\$(brew --prefix)/share/zsh/site-functions \$fpath)
  autoload -Uz compinit
  compinit
fi
export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1
export HOMEBREW_NO_ASK=1
EOF
```

#### old

brew install one-liner macOS (non-interactive)  
if user has `ALL=(ALL) NOPASSWD: ALL` in `/etc/sudoers.d`

```bash
xcode-select --install &&
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile &&
eval "$(/opt/homebrew/bin/brew shellenv)" &&
brew analytics off &&
brew tap homebrew/cask &&
brew tap homebrew/cask-drivers &&
brew tap homebrew/cask-versions &&
brew tap beeftornado/rmtree &&
cat <<EOF | sudo tee -a $HOME/.zshrc
# brew completions
if type brew &>/dev/null
then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

  autoload -Uz compinit
  compinit
fi
EOF
source $HOME/.zshrc &&
cat $HOME/.zshrc
```

brew install one-liner macOS (interactive)

```bash
xcode-select --install &&
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile &&
eval "$(/opt/homebrew/bin/brew shellenv)" &&
brew analytics off &&
brew tap homebrew/cask &&
brew tap homebrew/cask-drivers &&
brew tap homebrew/cask-versions &&
brew tap homebrew/core &&
brew tap beeftornado/rmtree &&
cat <<EOF | sudo tee -a $HOME/.zshrc
# brew completions
if type brew &>/dev/null
then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

  autoload -Uz compinit
  compinit
fi
EOF
source $HOME/.zshrc &&
cat $HOME/.zshrc
```

---

### Linux

brew install one-liner Ubuntu 22/24

```bash
sudo apt-get update && sudo apt-get install -y build-essential procps curl file git &&
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
test -r $HOME/.profile &&
cat <<EOF | sudo tee -a $HOME/.profile

# brew
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# brew completions
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="\$(brew --prefix)"
  if [[ -r "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "\${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "\${COMPLETION}" ]] && source "\${COMPLETION}"
    done
  fi
fi
# brew end
EOF
source $HOME/.profile &&
brew analytics off &&
brew update && brew upgrade &&
brew tap beeftornado/rmtree &&
sudo sh -c 'echo "Defaults secure_path = $PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"' \
  | sudo tee -a /etc/sudoers.d/$USER &&
cat <<EOF | sudo tee -a /root/.profile

# brew
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
alias brew='sudo -Hu mono brew'
# brew completions
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="\$(brew --prefix)"
  if [[ -r "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "\${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "\${COMPLETION}" ]] && source "\${COMPLETION}"
    done
  fi
fi
# brew end
EOF
```

brew install one-liner Rocky Linux 9

```bash
sudo dnf groupinstall -y "Development Tools" &&
sudo dnf install -y procps-ng curl file git &&
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
test -r $HOME/.bash_profile &&
cat <<EOF | sudo tee -a $HOME/.bash_profile

# brew
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# brew completions
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="\$(brew --prefix)"
  if [[ -r "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "\${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "\${COMPLETION}" ]] && source "\${COMPLETION}"
    done
  fi
fi
# brew end
EOF
source $HOME/.bash_profile &&
brew analytics off &&
brew update && brew upgrade &&
brew tap beeftornado/rmtree &&
source $HOME/.bash_profile && source $HOME/.bashrc &&
sudo sh -c 'echo "Defaults secure_path = $PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"' \
  | sudo tee -a /etc/sudoers.d/$USER &&
cat <<EOF | sudo tee -a /root/.bash_profile

# brew
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
alias brew='sudo -Hu mono brew'
# brew completions
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="\$(brew --prefix)"
  if [[ -r "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "\${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "\${COMPLETION}" ]] && source "\${COMPLETION}"
    done
  fi
fi
# brew end
EOF
```

brew install one-liner CentOS 7

> Will work only with updated git, not from official repos
>
> Use it only via script, not command

```bash
#!/bin/bash
sudo yum groups mark install "Development Tools"
sudo yum groups mark convert "Development Tools"
sudo yum groupinstall -y "Development Tools"
sudo yum install -y procps-ng curl file git
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -r $HOME/.bash_profile &&
cat <<EOF | sudo tee -a $HOME/.bash_profile

# brew
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# brew completions
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="\$(brew --prefix)"
  if [[ -r "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "\${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "\${COMPLETION}" ]] && source "\${COMPLETION}"
    done
  fi
fi
# brew end
EOF
source $HOME/.bash_profile &&
brew analytics off &&
brew update && brew upgrade &&
brew tap beeftornado/rmtree &&
sudo sh -c 'echo "Defaults secure_path = $PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"' \
  | sudo tee -a /etc/sudoers.d/$USER &&
cat <<EOF | sudo tee -a /root/.bash_profile

# brew
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
alias brew='sudo -Hu mono brew'
# brew completions
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="\$(brew --prefix)"
  if [[ -r "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "\${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "\${COMPLETION}" ]] && source "\${COMPLETION}"
    done
  fi
fi
# brew end
EOF
cat <<EOF | sudo tee -a /root/.bashrc
```

---

## brew uninstall

uninstall brew non-interactively

```bash
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" && \
	sudo rm -rf /home/linuxbrew
```

uninstall brew interactively

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" && \
	sudo rm -rf /home/linuxbrew
```

---

## brew paths

macOS m1

```bash
/opt/homebrew/Cellar
```

macOS intel

```bash
/usr/local/Cellar
```

linux default

```bash
/home/linuxbrew/.linuxbrew/bin/brew
```

---

## brew commands

### brew multi-user system

More info here - [Using Homebrew on a multi-user system (don’t).md](guides/Using Homebrew on a multi-user system (don’t).md)

use brew with user that installed brew or write aliases

```bash
sudo -Hu username brew update
```

- The `-H` option will make sure that the `HOME` directory is set to that of the impersonated user (here `foo`) instead of the _impersonating user_ (here `bar`), so that Homebrew can maintain its cache and other local state in the proper user’s home.
- The `-u` option allows to specify the user to impersonate instead of the default of `root`.

add brew alias

```bash
echo "alias brew='sudo -Hu username brew'" >> ~/.zprofile
```

#### brew multi-user scripts

macOS

```bash
#!/bin/bash
USER='admin'

cat <<EOF | sudo tee -a /Users/$USER/.zprofile

# brew
eval "\$(/opt/homebrew/bin/brew shellenv)"
alias brew='sudo -Hu mono brew'
# brew end
EOF
cat <<EOF | sudo tee -a /Users/$USER/.zshrc

# brew completions
if type brew &>/dev/null
then
  FPATH="\$(brew --prefix)/share/zsh/site-functions:\${FPATH}"

  autoload -Uz compinit
  compinit
fi
# brew end
EOF

sudo bat -pP /Users/$USER/.zprofile &&
sudo bat -pP /Users/$USER/.zshrc &&
USER=$(whoami)
```

linux deb

```bash
#!/bin/bash
USER='ansible'
cat <<EOF | sudo tee -a /home/$USER/.profile

# brew
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
alias brew='sudo -Hu mono brew'

# brew completions
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="\$(brew --prefix)"
  if [[ -r "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "\${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "\${COMPLETION}" ]] && source "\${COMPLETION}"
    done
  fi
fi
# brew end
EOF
sudo bat -pP /home/$USER/.profile && USER=$(whoami)
```

linux rpm

```bash
#!/bin/bash
USER='ansible'
cat <<EOF | sudo tee -a /home/$USER/.bash_profile

# brew
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
alias brew='sudo -Hu mono brew'

# brew completions
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="\$(brew --prefix)"
  if [[ -r "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "\${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "\${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "\${COMPLETION}" ]] && source "\${COMPLETION}"
    done
  fi
fi
# brew end
EOF
sudo bat -pP /home/$USER/.bash_profile && USER=$(whoami)
```

---

### diagnostics

check problems with brew and diagnose it

```bash
brew doctor
```

show brew installation path

```bash
which -a brew
# - a lists all installations found
```

show brew config and system info

```bash
brew config
```

---

### update and upgrade

update brew taps and brew itself

```bash
brew update
```

upgrade all software

```bash
brew upgrade
```

upgrade specific package

```bash
brew upgrade package-name
```

list all upgradable packages

```bash
brew outdated

# only casks
brew outdate --casks
```

prevent upgrading package

```bash
brew pin package-name
```

allow upgrading package

```bash
brew unpin package-name
```

show all installed packages

```bash
brew list

# only casks
brew list --casks
```

---

### search

search for package

```bash
brew search package-name

# only casks
brew search --casks package-name
```

search for formulae with a description matching text

```bash
brew search --desc --eval-all package-name

# only casks
brew search --desc --eval-all --casks package-name
```

list all available packages

```bash
brew formulae
brew casks
```

get info about package

```bash
brew info name
brew info --casks name
```

---

### install

install package

```bash
brew install package-name

# only casks
brew install --casks package-name
```

- To install different (not last) version of formulae or cask

  - go for formula [here](https://github.com/Homebrew/homebrew-core/find/master)

  - go for cask [here](https://github.com/Homebrew/homebrew-cask/find/master)

  - find package you need and click history for searching the commits

  - find version you need and view file

  - click `raw`

  - copy link to raw file from browser address bar

  - go to terminal

    ```bash
    # example
    curl -L https://raw.githubusercontent.com/Homebrew/homebrew-cask/3c3ea5d92137adbb42b1c163f4cbfdd383409e33/Casks/mkvtoolnix.rb > mkvtoolnix.rb && brew install mkvtoolnix.rb
    ```

---

### uninstall

uninstall package

```bash
brew uninstall package-name
```

remove unused dependencies

```bash
brew autoremove
```

- uninstall package with all dependencies with `rmtree`

  - first install `rmtree` command

    ```bash
    brew tap beeftornado/rmtree
    ```

  - uninstall package with all dependencies

    ```bash
    brew rmtree package-name
    ```

uninstall all formulae

```bash
brew remove --force $(brew list --formula)
```

uninstall all casks

```bash
brew remove --cask --force $(brew list --casks)
```

show dependency tree of package

```bash
brew deps -t package-name
brew deps --tree package-name
```

show dependency tree for all installed packages

```bash
brew deps --t --installed
```

cleanup unused directories and files (including old downloads)

```bash
brew cleanup
```

clear fully Homebrew cache

```bash
brew cleanup --prune=all
```

---

### link

link package with different name installed by brew

```bash
brew link package-name
```

unlink package

```bash
brew unlink package-name
```

check which package

```bash
which package-name
```

---

## homebrew terminology and theory

[Homebrew-Cask](https://caskroom.github.io/) is an extension to Homebrew to install GUI applications such as Google Chrome or Atom. It started independently but its maintainers now work closely with Homebrew’s core team.

Homebrew calls its package definition files “formulae” (British plural for “formula”). Homebrew-Cask calls them “casks”. A cask, just like a formula, is a file written in a Ruby-based [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) that describes how to install something.

The **Cellar** is where Homebrew installs things. Its default path is `/usr/local/Cellar` (`/opt/homebrew/Cellar` on Apple Silicon). It then add symlinks from standard locations to it.

For example, when you type `brew install git`:

1. Homebrew installs it under `/usr/local/Cellar/git/<version>/`, with the `git` binary in `/usr/local/Cellar/git/<version>/bin/git`
2. It adds a symlink from `/usr/local/bin/git` to that binary

This allows Homebrew to keep track of what’s installed by Homebrew versus software installed by other means.

A **`tap`** is a source of formulae. The default is `homebrew/core` but you can add more of them. The simplest way to create a formula for your own software is to create a GitHub repository called `homebrew-<something>`; put your formula file in it; then type `brew tap <username>/<something>` to add this new source of formulae to your Homebrew installation and so get access to all its formulae.

Some companies have internal Homebrew taps for their own utilities. There are a lot of public taps like [`atlassian/tap`](https://github.com/atlassian/homebrew-tap) for Atlassian software, or [`ska-sa/tap`](https://github.com/ska-sa/homebrew-tap) for radio astronomy. Homebrew itself used to have additional taps like `homebrew/science` but they deprecated them and imported the formulae in `homebrew/core`.

---
title: brew
categories:
  - software
  - notes
  - guides
author: wandering-mono
url: https://github.com/monocodes/snippets.git
---

# brew

- [brew](#brew)
  - [brew install](#brew-install)
    - [macOS](#macos)
    - [Linux](#linux)
  - [brew paths](#brew-paths)
  - [brew commands](#brew-commands)
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

### macOS

one-liner install macOS (non-interactive)  
if user has `ALL=(ALL) NOPASSWD: ALL` in `/etc/sudoers.d`

```sh
xcode-select --install && \
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile && \
	eval "$(/opt/homebrew/bin/brew shellenv)" && \
	brew analytics off && \
	brew tap homebrew/cask && \
  brew tap homebrew/cask-drivers && \
  brew tap homebrew/cask-versions && \
  brew tap beeftornado/rmtree && \
  sudo chmod 750 /opt/homebrew/bin/brew && \
	cat <<EOF | sudo tee -a $HOME/.zshrc
# brew completions
if type brew &>/dev/null
then
  FPATH="\$(brew --prefix)/share/zsh/site-functions:\${FPATH}"

  autoload -Uz compinit
  compinit
fi
EOF
	source $HOME/.zshrc
	cat $HOME/.zshrc
```

one-liner install macOS (interactive)

```sh
xcode-select --install && \
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile && \
	eval "$(/opt/homebrew/bin/brew shellenv)" && \
	brew analytics off && \
	brew tap homebrew/cask && \
  brew tap homebrew/cask-drivers && \
  brew tap homebrew/cask-versions && \
  brew tap homebrew/core && \
  brew tap beeftornado/rmtree && \
  sudo chmod 750 /opt/homebrew/bin/brew && \
	cat <<EOF | sudo tee -a $HOME/.zshrc
# brew completions
if type brew &>/dev/null
then
  FPATH="\$(brew --prefix)/share/zsh/site-functions:\${FPATH}"

  autoload -Uz compinit
  compinit
fi
EOF
	source $HOME/.zshrc
	cat $HOME/.zshrc
```

---

### Linux

one-liner install Ubuntu 22

```sh
sudo apt-get update && sudo apt-get install -y build-essential procps curl file git && \
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
	test -r $HOME/.profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> $HOME/.profile && \
  source $HOME/.profile && \
  brew analytics off && \
  brew update && brew upgrade && \
  brew install gcc && \
  brew tap beeftornado/rmtree && \
  sudo chmod 750 $(brew --prefix)/Homebrew/bin/brew && \
	cat <<EOF | sudo tee -a $HOME/.profile
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
EOF
	sudo sh -c 'echo "Defaults secure_path = $PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"' \
	| sudo tee -a /etc/sudoers.d/$USER
```

one-liner install Rocky Linux 9

```sh
sudo dnf groupinstall -y "Development Tools" && \
	sudo dnf install -y procps-ng curl file git && \
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
	test -r $HOME/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> $HOME/.bash_profile
  source $HOME/.bash_profile && \
  brew analytics off && \
  brew update && brew upgrade && \
  brew install gcc && \
  brew tap beeftornado/rmtree && \
  sudo chmod 750 /$(brew --prefix)/Homebrew/bin/brew && \
	cat <<EOF | sudo tee -a $HOME/.bash_profile
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
EOF
	sudo sh -c 'echo "Defaults secure_path = $PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"' \
	| sudo tee -a /etc/sudoers.d/$USER
```

>The installation script installs Homebrew to `/home/linuxbrew/.linuxbrew` using `sudo`. Homebrew does not use `sudo` after installation. Using `/home/linuxbrew/.linuxbrew` allows the use of most binary packages (bottles) which will not work when installing in e.g. your personal home directory.

## brew uninstall

uninstall brew non-interactively

```sh
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" && \
	sudo rm -rf /home/linuxbrew
```

uninstall brew interactively

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" && \
	sudo rm -rf /home/linuxbrew
```

---

## brew paths

macOS m1

```sh
/opt/homebrew/Cellar
```

macOS intel

```sh
/usr/local/Cellar
```

linux default

```sh
/home/linuxbrew/.linuxbrew/bin/brew
```

---

## brew commands

### diagnostics

check problems with brew and diagnose it

```sh
brew doctor
```

show brew installation path

```sh
which -a brew
# - a lists all installations found
```

show brew config and system info

```sh
brew config
```

---

### update and upgrade

update brew taps and brew itself

```sh
brew update
```

upgrade all software

```sh
brew upgrade
```

upgrade specific package

```sh
brew upgrade package-name
```

list all upgradable packages

```sh
brew outdated

# only casks
brew outdate --casks
```

prevent upgrading package

```sh
brew pin package-name
```

allow upgrading package

```sh
brew unpin package-name
```

show all installed packages

```sh
brew list

# only casks
brew list --casks
```

---

### search

search for package

```sh
brew search package-name

# only casks
brew search --casks package-name
```

search for formulae with a description matching text

```sh
brew search --desc --eval-all package-name

# only casks
brew search --desc --eval-all --casks package-name
```

list all available packages

```sh
brew formulae
brew casks
```

get info about package

```sh
brew info name
brew info --casks name
```

---

### install

install package

```sh
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

    ```sh
    # example
    curl -L https://raw.githubusercontent.com/Homebrew/homebrew-cask/3c3ea5d92137adbb42b1c163f4cbfdd383409e33/Casks/mkvtoolnix.rb > mkvtoolnix.rb && brew install mkvtoolnix.rb
    ```

---

### uninstall

uninstall package

```sh
brew uninstall package-name
```

remove unused dependencies

```sh
brew autoremove
```

- uninstall package with all dependencies with `rmtree`

  - first install `rmtree` command

    ```sh
    brew tap beeftornado/rmtree
    ```

  - uninstall package with all dependencies

    ```sh
    brew rmtree package-name
    ```

uninstall all formulae

```sh
brew remove --force $(brew list --formula)
```

uninstall all casks

```sh
brew remove --cask --force $(brew list --casks)
```

show dependency tree of package

```sh
brew deps -t package-name
brew deps --tree package-name
```

show dependency tree for all installed packages

```sh
brew deps --t --installed
```

cleanup unused directories and files (including old downloads)

```sh
brew cleanup
```

---

### link

link package with different name installed by brew

```sh
brew link package-name
```

unlink package

```sh
brew unlink package-name
```

check which package

```sh
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

# INSTALL HOMEBREW (m1 and intel)----------------
# xcode command-line tools must be intalled
xcode-select --install

# install homebrew (m1 and intel)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# shell settings on m1
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/serj/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# disable analytics
brew analytics off
export HOMEBREW_NO_ANALYTICS=1

# add casks tap
brew tap homebrew/cask

# check problems with brew and diagnose it
brew doctor
brew config
which -a brew



# BREW PATHS-------------------------------------
# m1
/opt/homebrew/Cellar
# intel
/usr/local/Cellar



# UPDATE AND UPGRADE-----------------------------
# update brew taps and brew itself
brew update

# upgrade all software
brew upgrade

# upgrade specific package
brew upgrade name
brew upgrade --casks name

# list all upgradable packages 
brew outdated
brew outdate --casks

# brew pin to prevent upgrading package
brew pin package-name

# brew unpin to allow upgrading package
brew unpin package-name



# LIST-------------------------------------------
# list all installed packages
brew list



# SEARCH-----------------------------------------
brew search name
brew search --casks package-name

# Search for formulae with a description matching text and casks with a name or description matching text.
brew search --desc --eval-all package-name

# list all available packages
brew formulae
brew casks



# INFO-------------------------------------------
# get info about package before install
brew info name
brew info --casks name



*************************************************
# INSTALL
*************************************************
brew install name
brew install --casks name

# install different version of formulae or casc
# go fo formula here
https://github.com/Homebrew/homebrew-core/find/master
# go for cask here
https://github.com/Homebrew/homebrew-cask/find/master
# find package you need and click history for searching the commits
# find version you need and and view file
# click raw
# copy link to raw file from browser address bar
# go to terminal
curl -L https://raw.githubusercontent.com/Homebrew/homebrew-cask/3c3ea5d92137adbb42b1c163f4cbfdd383409e33/Casks/mkvtoolnix.rb > mkvtoolnix.rb && brew install mkvtoolnix.rb



*************************************************
# BREW LINK
*************************************************
# sometimes you want to link some program installed by brew
brew link package-name

# you can unlink program from brew
brew unlink package-name

# use command which to see what software you are using
which package-name

# more info in Homebrew and Pyenv Python Playing Pleasantly in Partnership.pdf
# https://towardsdatascience.com/homebrew-and-pyenv-python-playing-pleasantly-in-partnership-3a342d86319b



*************************************************
# UNINSTALL
*************************************************
# uninstall package and remove all dependencies
brew uninstall name
brew autoremove

# uninstall package with all dependencies
# first install command
brew tap beeftornado/rmtree
# uninstall package with all dependencies
brew rmtree package-name

# uninstall all formulae
brew remove --force $(brew list --formula)

# uninstall all casks
brew remove --cask --force $(brew list)

# what dependencies exist with a particular package in tree view
brew deps --tree name
brew deps -t name


# lists the dependency tree for all installed packages 
brew deps --tree --installed

# cleanup unused directories and files (including old downloads)
brew cleanup



# ANOTHER COMMANDS-------------------------------



# HOMEBREW TERMINOLOGY AND THEORY----------------
'''Homebrew-Cask is an extension to Homebrew to install GUI applications such as Google Chrome or Atom. It started independently but its maintainers now work closely with Homebrew’s core team.

Homebrew calls its package definition files “formulae” (British plural for “formula”). Homebrew-Cask calls them “casks”. A cask, just like a formula, is a file written in a Ruby-based DSL that describes how to install something.

The Cellar is where Homebrew installs things. Its default path is /usr/local/Cellar (/opt/homebrew/Cellar on Apple Silicon). It then add symlinks from standard locations to it.

For example, when you type brew install git:

Homebrew installs it under /usr/local/Cellar/git/<version>/, with the git binary in /usr/local/Cellar/git/<version>/bin/git
It adds a symlink from /usr/local/bin/git to that binary
This allows Homebrew to keep track of what’s installed by Homebrew versus software installed by other means.

A tap is a source of formulae. The default is homebrew/core but you can add more of them. The simplest way to create a formula for your own software is to create a GitHub repository called homebrew-<something>; put your formula file in it; then type brew tap <username>/<something> to add this new source of formulae to your Homebrew installation and so get access to all its formulae.

Some companies have internal Homebrew taps for their own utilities. There are a lot of public taps like atlassian/tap for Atlassian software, or ska-sa/tap for radio astronomy. Homebrew itself used to have additional taps like homebrew/science but they deprecated them and imported the formulæ in homebrew/core.'''
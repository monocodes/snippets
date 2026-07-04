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
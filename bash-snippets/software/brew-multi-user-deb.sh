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
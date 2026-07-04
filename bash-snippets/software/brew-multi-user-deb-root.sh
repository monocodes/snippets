#!/bin/bash
cat <<EOF | sudo tee -a /root/.profile

# brew
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
alias brew='sudo -Hu mono brew'
# brew end
EOF
cat <<EOF | sudo tee -a /root/.bashrc

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
sudo bat -pP /root/.bash_profile && sudo bat -pP /root/.bashrc
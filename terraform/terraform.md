---
title: terraform
categories:
  - software
  - IAC
  - guides
  - notes
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [terraform install](#terraform-install)
  - [macos via brew](#macos-via-brew)
  - [terraform autocompletion](#terraform-autocompletion)
- [terraform commands](#terraform-commands)

## terraform install

### macos via brew

Use homebrew/core or [hashicorp/tap](hashicorp/tap) <- discussion here.  
I think better is to use homebrew/core.

```bash
# homebrew/core
brew install terraform

# hashicorp/tap
brew tap hashicorp/tap && \
  brew install hashicorp/tap/terraform
```

### terraform autocompletion

```bash
# install autocompletion
terraform -install-autocomplete && \
  source ~./zshrc

# uninstall autocompletion
terraform -uninstall-autocomplete && \
  source ~./zshrc
```

On macOS it just puts line in `~/.zshrc`

```bash
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
```

I think it will not work properly without **brew** with **zsh** because **zsh** needs something like:

```bash
autoload -Uz compinit
```

---

## terraform commands

initialize terraform in current dir  
terraform will check provider and download needed plugins

```bash
terraform init
```

syntax check of files in current dir

```bash
terraform validate
```

format the code in files in current dir

```bash
terraform fmt
```

check what will be executed from files in current dir

```bash
terraform plan
```

apply files from current dir

```bash
terraform apply
```

delete every resource from files from current dir

```bash
terraform destroy
```

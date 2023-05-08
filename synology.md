---
title: synology
categories:
  - software
  - hardware
  - guides
  - notes
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [cmd](#cmd)
- [packages](#packages)
  - [vim](#vim)
  - [tailscale](#tailscale)

## cmd

To add an alias or to modify `$PATH` to shell edit or create `~/.bashrc`. See [this discussion](https://www.synoforum.com/threads/how-to-make-an-alias-in-shell.1211/).

```sh
# $PATH
echo 'export PATH="/volume1/@appstore/vim/bin/vim:$PATH"' >> ~/.bashrc

# alias vim
echo 'alias vim="/volume1/@appstore/vim/bin/vim"' >> ~/.bashrc
```

---

## packages

### vim

Install last version of **vim** from [SynoCommunity](https://packages.synocommunity.com/) and enable syntax in it

1. Add [SynoCommunity](https://packages.synocommunity.com/) repo to a Package Center  
   Package Center -> Settings -> Package Sources -> SynoCommunity - <https://packages.synocommunity.com/>

2. Install **vim** from SynoCommunity

3. Ssh to Synology box with your user

   ```sh
   # via $PATH
   echo 'export PATH="/volume1/@appstore/vim/bin/vim:$PATH"' >> ~/.bashrc && \
     source ./.bashrc && \
     echo -e "filetype plugin indent on\nsyntax on" >> ~/.vimrc && \
     vim --version
   
   # or via alias
   echo 'alias vim="/volume1/@appstore/vim/bin/vim"' >> ~/.bashrc && \
     source ./.bashrc && \
     echo -e "filetype plugin indent on\nsyntax on" >> ~/.vimrc && \
     vim --version
   ```

---

### tailscale

> Maybe now you can do that just from admin panel

[Make synology nas as subnet router](https://youtu.be/uJ8PsImiDrM)

```sh
sudo tailscale up --advertise-routes=192.168.1.0/24 --reset
```

then edit subnet routes in tailscale admin panel, add `subnet` and `DISABLE KEY EXPIRE` on subnet router

To disable subnet routing on nas:

```sh
sudo tailscale ip --reset
```

don't forget to remove subnet routes from admin panel and ENABLE KEY EXPIRE

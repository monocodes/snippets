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

renew Let's Encrypt Certificates

```sh
/usr/syno/sbin/syno-letsencrypt renew-all
```

disable Firewall

```sh
/usr/syno/bin/synofirewall --disable
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
   echo 'export PATH="/volume1/@appstore/vim/bin/:$PATH"' >> ~/.bashrc && \
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

---

## PIA ports for gluetun and firewall

In order to connect to our service using one of the VPN methods we provide, please verify you can connect over these ports: 

- For the PIA Client: 
  - **UDP** ports  8080, 853, 123, 53
  - **TCP** ports  8443, 853, 443, 80
- For OpenVPN: 
  - **UDP** ports 1197, 1198
  - **TCP** ports  501, 502

If you can connect over any of those, you should be able to use at least one of our connection methods. 

In addition, the PIA application pings our gateways over port 8888. This is used to connect you to the server with the lowest latency when you use the auto connect feature. 

We also have more in-depth information on our OpenVPN ports including the protocols, settings, and certificates that should be used with them in this [article](https://www.privateinternetaccess.com/helpdesk/kb/articles/which-encryption-auth-settings-should-i-use-for-ports-on-your-gateways-3). 

---
title: nginx
categories:
  - software
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [install nginx](#install-nginx)
  - [Rocky Linux 9](#rocky-linux-9)
- [nginx commands](#nginx-commands)

## install nginx

### Rocky Linux 9

nginx install one-liner

```sh
sudo dnf install nginx -y && \
  sudo systemctl enable --now nginx && \
  sudo firewall-cmd --permanent --add-service=http && \
  sudo firewall-cmd --reload
```

---

## nginx commands

test current config

```sh
nginx -t
```

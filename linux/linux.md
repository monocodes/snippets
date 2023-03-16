---
title: linux
categories:
  - software
  - guides
  - notes
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# linux

- [linux](#linux)
  - [linux commands](#linux-commands)
    - [apt](#apt)
      - [apt search](#apt-search)
    - [sed](#sed)
  - [linux packages](#linux-packages)

## linux commands

### apt

#### apt search

search package with apt

```bash
apt search package-name
```

---

### sed

- `sed` command example for `/etc/apt/sources.list` to switch to location repos or main repos

  - switch to main repos

  - ```bash
        sudo sed -i 's|http://us.|http://|g' /etc/apt/sources.list
        # or
        sed -i 's/http:\/\/in./http:\/\//g' /etc/apt/sources.list
    ```

  - switch to Armenia repos

  - ```bash
        sudo sed -i 's|http://us.|http://am.|g' /etc/apt/sources.list
        # or
        sed -i 's/http:\/\/us./http:\/\/am./g' /etc/apt/sources.list
    ```

---

## linux packages

package for  `ip -a` command - `iproute2`

```bash
apt update
apt install iproute2 -y
```

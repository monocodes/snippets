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
    - [jdk](#jdk)
  - [bash wildcards](#bash-wildcards)

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

### jdk

check current main version

```bash
java -version
```

check installed jdk versions

```bash
/usr/lib/jvm
```

> example  
> here installed openjdk-8-jdk `java-1.8.0-openjdk-amd64` and openjdk-11-jdk `java-1.11.0-openjdk-amd64`

```bash
ls /usr/lib/jvm
java-1.11.0-openjdk-amd64  java-11-openjdk-amd64  openjdk-11
java-1.8.0-openjdk-amd64   java-8-openjdk-amd64
```

---

## bash wildcards

search any directory (`**`) any file with `.war` extension (`*.war`)

```bash
**/*.war
```

---

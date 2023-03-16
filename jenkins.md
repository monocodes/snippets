---
title: jenkins
categories:
  - software
  - CI/CD
  - notes
  - guides
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# jenkins

## install

### ubuntu

`jenkins-install-ubuntu.sh`

```bash
#!/bin/bash

# optional install of jdk, comment if not needed
sudo apt update
sudo apt install openjdk-11-jdk -y

# jenkins install
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
```

---

## paths

home dir

```bash
/var/lib/jenkins/
```

---

## install plugins

### jdk

#### manual install

1. ssh to host and install needed `jdk` version  

    ```bash
    sudo apt install openjdk-8-jdk -y
    ```

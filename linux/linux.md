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

---

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

## network

### ifconfig.io

<https://ifconfig.io/>

Great diagnostic website. You can diagnose just with `curl` command from anywhere. Great for testing proper VPN connection.

**Simple cURL API**!

| command                       | result                                                       |
| :---------------------------- | ------------------------------------------------------------ |
| curl ifconfig.io/ip           | 146.70.28.163                                                |
| curl ifconfig.io/ip           | 146.70.28.163                                                |
| curl ifconfig.io/host         | 146.70.28.163                                                |
| curl ifconfig.io/country_code | AT                                                           |
| curl ifconfig.io/ua           | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36 |
| curl ifconfig.io/port         | 65218                                                        |
| curl ifconfig.io/lang         | en-US,en;q=0.9,ru;q=0.8 $                                    |
| curl ifconfig.io/encoding     | gzip                                                         |
| curl ifconfig.io/mime         | text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7 |
| curl ifconfig.io/forwarded    | 146.70.28.163                                                |
| curl ifconfig.io/all          |                                                              |
| curl ifconfig.io/all.xml      |                                                              |
| curl ifconfig.io/all.json     |                                                              |
| curl ifconfig.io/all.js       |                                                              |

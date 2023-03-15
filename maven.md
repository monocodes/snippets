---
title: maven
categories:
  - software
  - guides
  - notes
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# maven

## maven install ubuntu

1. first, you need to install `jdk`

2. search for proper `jdk` package needed for your project  

    ```bash
    sudo apt search jdk
    sudo apt install openjdk-8-jdk -y
    java -version # check installed version
    openjdk version "1.8.0_362"
    OpenJDK Runtime Environment (build 1.8.0_362-8u362-ga-0ubuntu1~22.04-b09)
    OpenJDK 64-Bit Server VM (build 25.362-b09, mixed mode)
    ```

3. install `maven`  

    ```bash
    sudo apt install maven -y
    ```

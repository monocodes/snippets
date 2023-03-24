---
title: Docker Install
categories:
  - software
  - guides
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git

---

# Docker Install

---

- [Docker Install](#docker-install)
  - [GNU/Linux](#gnulinux)
    - [Amazon Linux 2](#amazon-linux-2)
    - [Ubuntu or deb-type](#ubuntu-or-deb-type)

---

## GNU/Linux

### Amazon Linux 2

install docker

```bash
sudo amazon-linux-extras install docker
```

---

### Ubuntu or deb-type

1. Uninstall old versions:

    ```bash
    sudo apt-get remove docker docker-engine docker.io containerd runc
    ```

    or

    ```bash
    sudo apt remove docker.io -y ; \
    sudo apt remove containerd -y ; \
    sudo apt remove runc -y ; \
    sudo apt remove docker -y ; \
    sudo apt remove docker-engine -y
    ```

    ---

2. Update the apt package index and install packages to allow apt to use a repository over HTTPS:

    ```bash
    sudo apt update && \
     sudo apt install \
       ca-certificates \
       curl \
       gnupg \
       lsb-release -y
    ```

    ---

3. Add Docker’s official GPG key::

    > need to check: `mkdir` maybe unnecessary

    ```bash
    ls -d /etc/apt/keyrings
    
    sudo mkdir -p /etc/apt/keyrings && \
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    ```

    ---

4. Use the following command to set up the repository:

    ```bash
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```

    ---

5. Install Docker Engine:
    update the apt package list

    ```bash
    sudo apt update
    ```

    ---

6. Receiving a GPG error when running apt update? error

    - solution

        Your default umask may be incorrectly configured, preventing detection of the repository public key file. Try granting read permission for the Docker public key file before updating the package index:

        ```bash
        sudo chmod a+r /etc/apt/keyrings/docker.gpg && \
         sudo apt update
        ```

    ---

7. Install a specific version of Docker Engine. optional

    - optional

        1. List the available versions in the repository:

            ```bash
            apt-cache madison docker-ce | awk '{ print $3 }’
            ```

             ```bash
            5:20.10.16~3-0~ubuntu-jammy
            5:20.10.15~3-0~ubuntu-jammy
            5:20.10.14~3-0~ubuntu-jammy
            5:20.10.13~3-0~ubuntu-jammy
             ```

        2. Select the desired version and install:
            `VERSION_STRING=5:20.10.13~3-0~ubuntu-jammy`

            ```bash
            sudo apt install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-compose-plugin
            ```

        3. Verify that the Docker Engine installation is successful by running the hello-world image:

            ```bash
            sudo docker run hello-world
            ```

    ---

8. To install the latest version, run:

    ```bash
    sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    ```

    ---

9. Verify that the Docker Engine installation is successful by running the hello-world image:

    ```bash
    sudo docker run hello-world
    ```

    ---

10. .Docker Engine post-installation steps:

    - Create the docker group and add your user:

        1. Create the docker group:

            ```bash
            sudo groupadd docker
            ```

        2. Add your user to the docker group:

            ```bash
            sudo usermod -aG docker $USER
            ```

        3. Log out and log back in so that your group membership is re-evaluated or:

            1. You can also run the following command to activate the changes to groups:

                ```bash
                newgrp docker
                ```

            > If you’re running Linux in a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

        4. Verify that you can run docker commands without sudo:

            ```bash
            docker run hello-world
            ```

             - What it does?

                This command downloads a test image and runs it in a container. When the container runs, it prints a message and exits.

    - Configure Docker to start on boot with systemd

        ```bash
        sudo systemctl enable docker.service
        sudo systemctl enable containerd.service
        ```

    - Manage Docker as a non-root user: optional

        The Docker daemon binds to a Unix socket, not a TCP port. By default it’s the root user that owns the Unix socket, and other users can only access it using sudo. The Docker daemon always runs as the root user.

        If you don’t want to preface the docker command with sudo, create a Unix group called docker and add users to it. When the Docker daemon starts, it creates a Unix socket accessible by members of the docker group. On some Linux distributions, the system automatically creates this group when installing Docker Engine using a package manager. In that case, there is no need for you to manually create the group.

        > The docker group grants root-level privileges to the user. For details on how this impacts security in your system, see Docker Daemon Attack Surface.

    To run Docker without root privileges, see Run the Docker daemon as a non-root user (Rootless mode).
        [https://docs.docker.com/engine/security/rootless/](https://docs.docker.com/engine/security/rootless/)

    - If you initially ran Docker CLI commands using sudo before adding your user to the docker group, you may see the following error: error

        ```bash
        WARNING: Error loading config file: /home/user/.docker/config.json -
        stat /home/user/.docker/config.json: permission denied
        ```

        This error indicates that the permission settings for the `~/.docker/` directory are incorrect, due to having used the sudo command earlier.

        To fix this problem, either remove the `~/.docker/` directory (it’s recreated automatically, but any custom settings are lost), or change its ownership and permissions using the following commands:

        ```bash
        sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
        sudo chmod g+rwx "$HOME/.docker" -R
        ```

---

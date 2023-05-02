---
title: Docker Install
categories:
  - software
  - guides
author: wandering-mono
url: https://github.com/monocodes/snippets.git
---

- [GNU/Linux](#gnulinux)
  - [Amazon Linux 2](#amazon-linux-2)
  - [Ubuntu or deb-type](#ubuntu-or-deb-type)
  - [Rocky Linux](#rocky-linux)

## GNU/Linux

### Amazon Linux 2

install docker

```sh
sudo amazon-linux-extras install docker
```

---

### Ubuntu or deb-type

**One-liner** install

```sh
sudo apt-get remove docker docker-engine docker.io containerd runc && \
	sudo apt update && \
 	sudo apt install ca-certificates curl gnupg lsb-release -y && \
	sudo mkdir -p /etc/apt/keyrings && \
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg -f --dearmor -o /etc/apt/keyrings/docker.gpg && \
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
	sudo apt update && \
	sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin bash-completion -y && \
	sudo usermod -aG docker $USER && \
	newgrp docker
```

**Normal** install

1. Uninstall old versions:

    ```sh
    sudo apt-get remove docker docker-engine docker.io containerd runc
    ```

    or

    ```sh
    sudo apt remove docker.io -y ; \
    	sudo apt remove containerd -y ; \
    	sudo apt remove runc -y ; \
    	sudo apt remove docker -y ; \
    	sudo apt remove docker-engine -y
    ```

    ---

2. Update the apt package index and install packages to allow apt to use a repository over HTTPS:

    ```sh
    sudo apt update && \
     sudo apt install \
       ca-certificates \
       curl \
       gnupg \
       lsb-release -y
    ```

    ---

3. Add Docker’s official GPG key::

    > need to check: `mkdir`, maybe unnecessary

    ```sh
    ls -d /etc/apt/keyrings
    
    sudo mkdir -p /etc/apt/keyrings && \
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    ```

    ---

4. Use the following command to set up the repository:

    ```sh
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```

    ---

5. Install Docker Engine:
    update the apt package list

    ```sh
    sudo apt update
    ```

    ---

6. Receiving a GPG error when running apt update? error

    - solution

        Your default umask may be incorrectly configured, preventing detection of the repository public key file. Try granting read permission for the Docker public key file before updating the package index:

        ```sh
        sudo chmod a+r /etc/apt/keyrings/docker.gpg && \
         sudo apt update
        ```

    ---

7. Install a specific version of Docker Engine.

    - optional

        1. List the available versions in the repository:

            ```sh
            apt-cache madison docker-ce | awk '{ print $3 }’
            ```

             ```sh
            5:20.10.16~3-0~ubuntu-jammy
            5:20.10.15~3-0~ubuntu-jammy
            5:20.10.14~3-0~ubuntu-jammy
            5:20.10.13~3-0~ubuntu-jammy
             ```

        2. Select the desired version and install:
            `VERSION_STRING=5:20.10.13~3-0~ubuntu-jammy`

            ```sh
            sudo apt install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-compose-plugin
            ```

        3. Verify that the Docker Engine installation is successful by running the hello-world image:

            ```sh
            sudo docker run hello-world
            ```

    ---

8. To install the latest version, run:

    ```sh
    sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin bash-completion -y
    ```

    ---

9. Verify that the Docker Engine installation is successful by running the hello-world image:

    ```sh
    sudo docker run hello-world
    ```

    ---

10. .Docker Engine post-installation steps:

    - Create the docker group and add your user:

        1. Create the docker group:

            ```sh
            sudo groupadd docker
            ```

        2. Add your user to the docker group:

            ```sh
            sudo usermod -aG docker $USER
            ```

        3. Log out and log back in so that your group membership is re-evaluated or:

            1. You can also run the following command to activate the changes to groups:

                ```sh
                newgrp docker
                ```

            > If you’re running Linux in a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

        4. Verify that you can run docker commands without sudo:

            ```sh
            docker run hello-world
            ```

             - What it does?

                This command downloads a test image and runs it in a container. When the container runs, it prints a message and exits.

    - Configure Docker to start on boot with systemd

        ```sh
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

        ```sh
        WARNING: Error loading config file: /home/user/.docker/config.json -
        stat /home/user/.docker/config.json: permission denied
        ```

        This error indicates that the permission settings for the `~/.docker/` directory are incorrect, due to having used the sudo command earlier.

        To fix this problem, either remove the `~/.docker/` directory (it’s recreated automatically, but any custom settings are lost), or change its ownership and permissions using the following commands:

        ```sh
        sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
        sudo chmod g+rwx "$HOME/.docker" -R
        ```

---

### Rocky Linux

**One-liner install Rocky Linux**

```sh
sudo dnf remove docker docker-engine docker.io containerd runc -y && \
	sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
	sudo dnf makecache && \
	sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin bash-completion && \
	sudo systemctl --now enable docker && \
	sudo usermod -aG docker $USER && \
	newgrp docker
```

**Normal install**

1. Uninstall old versions

    ```sh
    sudo dnf remove docker docker-engine docker.io containerd runc -y
    ```

2. Add docker repo

    ```sh
    sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    ```

3. Create metadata cache

    ```sh
    sudo dnf makecache
    ```

4. Install docker and other needed packages

    ```sh
    sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    ```

    >   notes
    >
    >   ```properties
    >   docker-ce               : This package provides the underlying technology for building and running docker containers (dockerd) 
    >   docker-ce-cli           : Provides the command line interface (CLI) client docker tool (docker)
    >   containerd.io           : Provides the container runtime (runc)
    >   docker-compose-plugin   : A plugin that provides the 'docker compose' subcommand 
    >   ```

5. Enable auto startup and start dockerd daemon now

    ```sh
    sudo systemctl --now enable docker
    ```

6. Add your user to the docker group:

    ```sh
    sudo usermod -aG docker $USER
    ```

7. Log out and log back in so that your group membership is re-evaluated or:

    ```sh
    newgrp docker
    ```

---

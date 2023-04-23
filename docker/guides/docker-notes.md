---
title: Docker Notes
categories:
  - software
  - guides
  - notes
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# Docker Notes

---

- [Docker Notes](#docker-notes)
  - [Docker \& Kubernetes. The Practical Guide \[2023 Edition\] \[Udemy\]](#docker--kubernetes-the-practical-guide-2023-edition-udemy)
    - [Section 2. Docker Images \& Containers. The Core Building Blocks](#section-2-docker-images--containers-the-core-building-blocks)
      - [23. EXPOSE \& A Little Utility Functionality](#23-expose--a-little-utility-functionality)
    - [Section 4. Networking. (Cross-)Container Communication](#section-4-networking-cross-container-communication)
      - [76. Docker Network Drivers](#76-docker-network-drivers)
    - [Section 7. Working with "Utility Containers" \& Executing Commands In Containers](#section-7-working-with-utility-containers--executing-commands-in-containers)
      - [108. Utility Containers, Permissions \& Linux](#108-utility-containers-permissions--linux)
        - [Solution 1:  Use  predefined "node" user (if you're lucky)](#solution-1--use--predefined-node-user-if-youre-lucky)
        - [Solution 2:  Remove the predefined "node" user and add yourself as the user](#solution-2--remove-the-predefined-node-user-and-add-yourself-as-the-user)
      - [118. Fixing Errors With The Next Lecture](#118-fixing-errors-with-the-next-lecture)

---

## Docker & Kubernetes. The Practical Guide [2023 Edition] [Udemy]

### Section 2. Docker Images & Containers. The Core Building Blocks

#### 23. EXPOSE & A Little Utility Functionality

EXPOSE & A Little Utility Functionality
In the last lecture, we started a container which also exposed a port (port 80).  
I just want to clarify again, that EXPOSE 80 in the Dockerfile in the end is optional. It documents that a process in the container will expose this port. But you still need to then actually expose the port with -p when running docker run. So technically, -p is the only required part when it comes to listening on a port. Still, it is a best practice to also add EXPOSE in the Dockerfile to document this behavior.  
As an additional quick side-note: For all docker commands where an ID can be used, you don't always have to copy / write out the full id.  
You can also just use the first (few) character(s) - just enough to have a unique identifier.

So instead of  
`docker run abcdefg`
you could also run  
`docker run abc`
or, if there's no other image ID starting with "a", you could even run just:  
`docker run a`
This applies to ALL Docker commands where IDs are needed.

---

### Section 4. Networking. (Cross-)Container Communication

#### 76. Docker Network Drivers

Docker Network Drivers
Docker Networks actually support different kinds of "Drivers" which influence the behavior of the Network.  
The default driver is the "bridge" driver - it provides the behavior shown in this module (i.e. Containers can find each other by name if they are in the same Network).  
The driver can be set when a Network is created, simply by adding the `--driver` option.  
`docker network create --driver bridge my-net`

Of course, if you want to use the "bridge" driver, you can simply omit the entire option since "bridge" is the default anyways.  
Docker also supports these alternative drivers - though you will use the "bridge" driver in most cases:

- **host**: For standalone containers, isolation between container and host system is removed (i.e. they share localhost as a network)
- **overlay**: Multiple Docker daemons (i.e. Docker running on different machines) are able to connect with each other. Only works in "Swarm" mode which is a dated / almost deprecated way of connecting multiple containers
- **macvlan**: You can set a custom MAC address to a container - this address can then be used for communication with that container
- **none**: All networking is disabled.

- **Third-party plugins**: You can install third-party plugins which then may add all kinds of behaviors and functionalities

As mentioned, the "bridge" driver makes most sense in the vast majority of scenarios.

---

### Section 7. Working with "Utility Containers" & Executing Commands In Containers

#### 108. Utility Containers, Permissions & Linux

When working with "Utility Containers" on Linux, I recommend that you also take a closer look at this very helpful thread in the Q&A section: <https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/#questions/12977214/>

This thread discusses user permissions as set by Docker when working with "Utility Containers" and how you should tweak them.

> Utility Containers and Linux
> 216 upvotes
> Scott · Lecture 111 · 2 years ago
> This is truly an awesome course Max! Well done!

I wanted to point out that on a Linux system, the Utility Container idea doesn't quite work as you describe it.  In Linux, by default Docker runs as the "Root" user, so when we do a lot of the things that you are advocating for with Utility Containers the files that get written to the Bind Mount have ownership and permissions of the Linux Root user.  (On MacOS and Windows10, since Docker is being used from within a VM, the user mappings all happen automatically due to NFS mounts.)

So, for example on Linux, if I do the following (as you described in the course):

`Dockerfile`

```dockerfile
FROM node:14-slim
WORKDIR /app
```

```sh
$ docker build -t node-util:perm .

$ docker run -it --rm -v $(pwd):/app node-util:perm npm init

...

$ ls -la

total 16

drwxr-xr-x  3 scott scott 4096 Oct 31 16:16 ./

drwxr-xr-x 12 scott scott 4096 Oct 31 16:14 ../

drwxr-xr-x  7 scott scott 4096 Oct 31 16:14 .git/

-rw-r--r--  1 root  root   202 Oct 31 16:16 package.json
```

You'll see that the ownership and permissions for the package.json file are "root".  But, regardless of the file that is being written to the Bind Mounted volume from commands emanating from within the docker container, e.g. "npm install", all come out with "Root" ownership.

---

##### Solution 1:  Use  predefined "node" user (if you're lucky)

There is a lot of discussion out there in the docker community (devops) about security around running Docker as a non-privileged user (which might be a good topic for you to cover as a video lecture - or maybe you have; I haven't completed the course yet).  The Official Node.js Docker Container provides such a user that they call "node".

<https://github.com/nodejs/docker-node/blob/master/Dockerfile-slim.template>

```dockerfile
FROM debian:name-slim
RUN groupadd --gid 1000 node \
         && useradd --uid 1000 --gid node --shell /bin/bash --create-home node
```

Luckily enough for me on my local Linux system, my "scott" uid:gid is also 1000:1000 so, this happens to map nicely to the "node" user defined within the Official Node Docker Image.

So, in my case of using the Official Node Docker Container, all I need to do is make sure I specify that I want the container to run as a non-Root user that they make available.  To do that, I just add:

`Dockerfile`

```dockerfile
FROM node:14-slim
USER node
WORKDIR /app
```

If I rebuild my Utility Container in the normal way and re-run "npm init", the ownership of the package.json file is written as if "scott" wrote the file.

```sh
$ ls -la

total 12

drwxr-xr-x  2 scott scott 4096 Oct 31 16:23 ./

drwxr-xr-x 13 scott scott 4096 Oct 31 16:23 ../

-rw-r--r--  1 scott scott 204 Oct 31 16:23 package.json
```

---

##### Solution 2:  Remove the predefined "node" user and add yourself as the user

However, if the Linux user that you are running as is not lucky to be mapped to 1000:1000, then you can modify the Utility Container Dockerfile to remove the predefined "node" user and add yourself as the user that the container will run as:

```dockerfile
FROM node:14-slim

RUN userdel -r node

ARG USER_ID

ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user

RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

USER user

WORKDIR /app
```

And then build the Docker image using the following (which also gives you a nice use of ARG):

```dockerfile
docker build -t node-util:cliuser --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
```

And finally running it with:

```sh
$ docker run -it --rm -v $(pwd):/app node-util:cliuser npm init

$ ls -la

total 12

drwxr-xr-x  2 scott scott 4096 Oct 31 16:54 ./

drwxr-xr-x 13 scott scott 4096 Oct 31 16:23 ../

-rw-r--r--  1 scott scott  202 Oct 31 16:54 package.json
```

Reference to Solution 2 above: <https://vsupalov.com/docker-shared-permissions/>

Keep in mind that this image will not be portable, but for the purpose of the Utility Containers like this, I don't think this is an issue at all for these "Utility Containers"

---

#### 118. Fixing Errors With The Next Lecture

You can ignore this lecture if you're not facing errors in the next lecture. However, if you do, take another look at this text lecture here.

When using Docker on Linux, you might face permission errors when adding a bind mount as shown in the next lecture. If you do, try these steps:

Change the `php.dockerfile` so that it looks like that:

```dockerfile
FROM php:8.0-fpm-alpine

WORKDIR /var/www/html

COPY src .

RUN docker-php-ext-install pdo pdo_mysql

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

USER laravel
```

Please note that the `RUN chown` instruction was removed here, instead we now create a user "laravel" which we use (with the `USER` instruction) for commands executed inside of this image / container).

Also edit the `composer.dockerfile` to look like this:

```dockerfile
FROM composer:latest

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

USER laravel

WORKDIR /var/www/html

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
```

Here, we add that same "laravel" user and use it for creating the project therefore.

These steps should ensure that all files which are created by the Composer container are assigned to a user named "laravel" which exists in all containers which have to work on the files.

Also see this Q&A thread: <https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/#questions/12986850/>

---

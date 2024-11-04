---
title: docker
categories:
  - software
  - guides
  - notes
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [docker compose](#docker-compose)
  - [docker compose commands](#docker-compose-commands)
  - [docker compose updating and rebuilding](#docker-compose-updating-and-rebuilding)
    - [`update-docker-compose-services.sh`](#update-docker-compose-servicessh)
  - [docker compose control startup](#docker-compose-control-startup)
  - [docker compose healthchecks](#docker-compose-healthchecks)
- [Dockerfile building blocks](#dockerfile-building-blocks)
  - [Dockerfile Instructions](#dockerfile-instructions)
  - [Dockerfile runtime ENV](#dockerfile-runtime-env)
    - [Environment Variables \& Security](#environment-variables--security)
    - [nodejs example](#nodejs-example)
  - [Dockerfile build ARG](#dockerfile-build-arg)
    - [example with PORT ARG](#example-with-port-arg)
- [docker commands](#docker-commands)
  - [docker help](#docker-help)
  - [docker inspect](#docker-inspect)
  - [docker run](#docker-run)
  - [docker build](#docker-build)
    - [docker build command on macos m1 linux/amd64 images](#docker-build-command-on-macos-m1-linuxamd64-images)
  - [docker exec](#docker-exec)
    - [docker useful packages for containers](#docker-useful-packages-for-containers)
  - [docker tag](#docker-tag)
  - [docker start](#docker-start)
  - [docker stop](#docker-stop)
  - [docker attach](#docker-attach)
  - [docker push](#docker-push)
  - [docker pull](#docker-pull)
  - [docker search](#docker-search)
  - [docker logs](#docker-logs)
  - [docker cp](#docker-cp)
  - [docker login \& docker logout](#docker-login--docker-logout)
  - [docker port](#docker-port)
  - [docker ps, docker ls](#docker-ps-docker-ls)
  - [docker rm](#docker-rm)
  - [docker volume](#docker-volume)
    - [anonymous volumes](#anonymous-volumes)
    - [named volumes](#named-volumes)
    - [bind mount](#bind-mount)
    - [read-only volumes](#read-only-volumes)
- [docker network](#docker-network)
  - [docker network caveats](#docker-network-caveats)
  - [`host.docker.internal`](#hostdockerinternal)
- [docker monitoring and troubleshooting](#docker-monitoring-and-troubleshooting)
  - [CAdvisor monitoring tool](#cadvisor-monitoring-tool)
  - [docker paths](#docker-paths)
- [Timezone in docker](#timezone-in-docker)
- [docker notes](#docker-notes)
  - [docker-compose multiple commands](#docker-compose-multiple-commands)
  - [docker-compose and sleep](#docker-compose-and-sleep)
  - [mysql - connect to db in container](#mysql---connect-to-db-in-container)
  - [DockerHub image types](#dockerhub-image-types)
- [deploying examples](#deploying-examples)
  - [nodejs setup example](#nodejs-setup-example)
  - [nodejs + reactjs + mongodb example](#nodejs--reactjs--mongodb-example)
  - [Utility Containers (not official name)](#utility-containers-not-official-name)
  - [Utility Containers with `docker compose`](#utility-containers-with-docker-compose)

## docker compose

### docker compose commands

> `docker compose` is v2 of `docker-compose`  
> `docker-compose` deprecated in 2023

create and run containers specified in `docker-compose.yaml` in current dir  

```sh
docker compose up -d
docker-compose up -d
```

create and run only specific services from current `docker-compose.yaml`  

```sh
docker compose up -d service-name

# example
docker compose up -d server php mysql
```

stop all containers from `docker-compose.yaml` and delete them + networks

```sh
docker compose down
```

stop all containers from `docker-compose.yaml` and delete all including volumes  

```sh
docker compose down -v
```

run the service described in `docker-compose.yaml` file with specified command

```sh
docker compose run service-name command-name

# example
docker compose run npm init
```

show running **docker-compose** containers  
need to be in `docker-compose.yaml` dir

```sh
docker compose ps
```

show top of running **docker-compose** containers

```sh
docker compose top
```

just build all images from `docker-compose.yaml`

```sh
docker compose build
```

restart container from `docker-compose.yaml` without recreating it

```sh
docker compose restart service-name
```

recreate a single container without starting any dependent containers

```sh
docker compose up --no-deps -d service-name
```

---

### docker compose updating and rebuilding

```sh
docker compose up -d --remove-orphans
docker compose up -d --remove-orphans service-name
```

- start the services from `docker-compose.yaml`
- will recreate containers if `docker-compose.yaml` was changed
- will not check for new images specified in `docker-compose.yaml` or `Dockerfile`
- `--remove-orphans` - remove containers for services not defined in the `docker-compose.yaml`

```sh
docker compose pull
docker compose pull service-name
```

- only pull the new images for all services or specified ones
- will not check for new images for services with `build:` section (`Dockerfile`)

```sh
docker-compose down --rmi all && docker compose up -d
```

- full clean-up

- stop current services and remove all local images specified in `docker-compose.yaml`

- start the services from `docker-compose.yaml` after that

- > can specify the images to update by `docker rmi -f repo-name/image-name:tag-name`

- > it's time consuming

```sh
docker-compose up -d --build
```

- `--build` - rebuild the services from `docker-compose.yaml` with `build:` section
- will not check for new images for services specified in `docker-compose.yaml` or `Dockerfile`
- start the services from `docker-compose.yaml`

```sh
docker-compose build --pull
docker-compose build --pull --no-cache
```

- rebuild the services from `docker-compose.yaml` with `build:` section
- will check for new images specified **only** in `Dockerfile`
- will not rebuild services without `:build` section in `docker-compose.yaml`
- `--no-cache` is slower
- can specify service to build by `docker-compose build --pull service-name`

```sh
docker compose up --force-recreate --build -d && docker image prune -f
```

- > use it only on purpose

- `--build` rebuild the images from `docker-compose.yaml` with `build:` section

- will not check for new images specified in `docker-compose.yaml` or `Dockerfile`

- `--force-recreate` - forcefully recreate running containers even if their configuration and image haven't changed

- start the services from `docker-compose.yaml`

- removes unused images

---

#### `update-docker-compose-services.sh`

simple script for recreating containers with the latest image versions  
it's better than `--force-recreate`

`update-docker-compose-services.sh`

```sh
#!/bin/bash

sudo docker compose down --remove-orphans # if you need to restart all containers
sudo docker compose build --pull # to rebuild Dockerfile images
sudo docker compose up -d --remove-orphans --pull=always
sudo docker image prune -f
```

- rebuild the services from `docker-compose.yaml` with `build:` section and check new images
- pull the new images for all services
- start the services from `docker-compose.yaml` and remove containers for services not defined in the `docker-compose.yaml`
- removes unused images

> `docker-compose` version

```sh
#!/bin/bash

sudo docker-compose down --remove-orphans # if you need to restart all containers
sudo docker-compose build --pull # to rebuild Dockerfile images
sudo docker-compose up -d --remove-orphans --pull always
sudo docker image prune -f
```

---

### docker compose control startup

> On startup, Compose does not wait until a container is “ready”, only until it’s running. This can cause issues if, for example you have a relational database system that needs to start its own services before being able to handle incoming connections.

The solution for detecting the ready state of a service is to use the `condition` attribute with one of the following options:

- `service_started`. it's default, when use `depends_on`.
- `service_healthy`. This specifies that a dependency is expected to be “healthy”, which is defined with `healthcheck`, before starting a dependent service.
- `service_completed_successfully`. This specifies that a dependency is expected to run to successful completion before starting a dependent service.

> example  
> don't forget make `healthcheck:` in dependent service section

```yaml
depends_on:
      service-name:
        condition: service_healthy
```

---

### docker compose healthchecks

default

```yaml
test: ["CMD", "curl", "-f", "http://localhost"]
```

default parameters

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 1m30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

another variants

```yaml
test: ["CMD-SHELL", "curl -f http://localhost || exit 1"]
```

```yaml
test: curl -f https://localhost || exit 1
```

**my variant**  
`-f`, `--fail` - fail fast with no output on HTTP errors  
`-k`, `--insecure` - allow insecure server connections  
`|| exit 1` - OR operator. If left part returns error (it can return different error codes but we need just `1`)

> The docker curl command returns exit codes such as `0`, `1`, `2` or `3` and many more. If the application returns the status code `200`, the docker curl command will return the exit code `0` and if it fails, it will return exit code `1`.  
> Hence, docker health check command will return healthy if the exit code is `0` and returns unhealthy if the exit code is `1`.

```yaml
healthcheck:
      test: curl -f -k https://localhost:8999 || exit 1
      interval: 10s
      timeout: 3s
      retries: 5
      start_period: 10s
```

dependent service on this healthcheck

```yaml
depends_on:
      service-name:
        condition: service_healthy
```

---

## Dockerfile building blocks

### Dockerfile Instructions

[Dockerfile reference](https://docs.docker.com/engine/reference/builder/)

| Instruction | Description                                                  | Notes                                                        | Example                                                      |
| ----------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| FROM        | Specify the base image                                       |                                                              | `FROM mysql:5.7`, `FROM ubuntu:latest`                       |
| LABELS      | Adds metadata to an image                                    | Like **tags** on AWS                                         | `LABEL "Author"="mono"`, `LABEL "Project"="nano"`            |
| RUN         | Execute commands in a new layer and commit the results       | Install a package, create dir, etc                           | `RUN apt-get update && apt-get install apache2 git -y`       |
| ADD/COPY    | Adds files and folders into image                            | **ADD** can download, unarchive, etc                         | `ADD nano.tar.gz /var/www/html`                              |
| CMD         | Runs binaries/commands on docker run                         |                                                              | `CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]`           |
| ENTRYPOINT  | Allows to configure a container that will run as an executable | Similar to **CMD** but with higher priority. For example, mention command in **ENTRYPOINT** and argument to that command by using **CMD** |                                                              |
| VOLUME      | Creates a mount point and marks it as holding externally mounted volumes |                                                              | `VOLUME mydbdata:/var/lib/mysql`, `VOLUME /var/log/apache2`  |
| EXPOSE      | Container listens on the specified network ports at runtime  | Expose port that container needs to work properly            | `EXPOSE 80`, `EXPOSE 3306`                                   |
| ENV         | Sets the environment variable                                |                                                              | `ENV DEBIAN_FRONTEND=noninteractive` to make commands non-interactive |
| USER        | Sets the user name (or UID)                                  | Specify what user will be running the process                |                                                              |
| WORKDIR     | Sets the working dir                                         |                                                              | `WORKDIR /var/www/html`                                      |
| ARG         | Defines a variable that users can pass at build-time         | Specify variables that the user can pass during build        |                                                              |
| ONBUILD     | Adds to the image a *trigger* instruction to be executed at a later time | Specify the commands that will be running when using this image as base image |                                                              |

---

### Dockerfile runtime ENV

> To use `ENV` parameters, first, you need to define this `ENV` parameter in code.  
>Place `ENV` variables at the bottom of the `Dockerfile`. So, **docker** will not reexecute unnessesary layers.

---

#### Environment Variables & Security

One important note about environment variables and security. Depending on which kind of data you're storing in your environment variables, you might not want to include the secure data directly in your `Dockerfile`.

Instead, go for a separate environment variables file which is then only used at runtime (i.e. when you run your container with `docker run`).

Otherwise, the values are "baked into the image" and everyone can read these values via `docker history image-name`.

For some values, this might not matter but for credentials, private keys etc. you definitely want to avoid that!

If you use a separate file, the values are not part of the image since you point at that file when you run `docker run`. But make sure you don't commit that separate file as part of your source control repository, if you're using source control.

#### nodejs example

1. code in app  

    ```javascript
    app.listen(process.env.PORT);
    ```

2. build new image witn `ENV`  

    ```dockerfile
    ENV PORT $port-number
    EXPOSE $PORT
    
    # example
    ENV PORT 80
    EXPOSE $PORT
    ```

3. run the image  

    ```sh
    docker run -p host-port:container-port --env PORT=port-number
    docker run -p host-port:container-port -e PORT=port-number
    
    # example
    docker run -d --rm -p 3000:8000 -e PORT=8000 --name feedback-web-nodejs -v feedback:/app/feedback -v "$(pwd):/app" -v /app/node_modules -v /app/temp account-name/repo-name:v0.41-env
    ```

    or you can use .env file

    ```sh
    docker run -p host-port:container-port --env-file ./filename
    
    # example
    docker run -d --rm -p 3000:8000 --env-file ./.env --name feedback-web-nodejs -v feedback:/app/feedback -v "$(pwd):/app" -v /app/node_modules -v /app/temp account-name/repo-name:v0.41-env
    ```

---

### Dockerfile build ARG

> Place `ARG` variables at the bottom of the file. So, docker will not reexecute unnessesary layers.

---

#### example with PORT ARG

1. Define `ENV` in `Dockerfile` and `ENV` in code of your app.  
    [Dockerfile runtime ENV](#Dockerfile runtime ENV)

2. Define `ARG` in `Dockerfile`.  

    ```dockerfile
    ARG arg-name=arg-value
    
    # example
    ARG DEFAULT_PORT=80
    ENV PORT $DEFAULT_PORT
    EXPOSE $PORT
    ```

3. Build the image with the `ARG`.  

    ```sh
    docker build -t image-name --build-arg arg-name=arg-value .
    
    # example
    docker build -t account-name/repo-name:v0.42-arg-p8000 --build-arg DEFAULT_PORT=8000 .
    ```

---

## docker commands

### docker help

show help on any command  

```sh
docker --help
docker ps --help
```

docker login to hub.docker.com  

```sh
docker login -u username
```

---

### docker inspect

inspect the image  

```sh
docker inspect image-name:tag-name

docker image inspect image-name
```

inspect the volume  

```sh
docker volume inspect volume-name
```

inspect the container  

```sh
docker container inspect container-name
```

to grep something from docker inspect  

```sh
docker container inspect container-name 2>&1 | grep "IPAddress"
```

---

### docker run

>Pulls image from dockerhub and runs a container based on it.  
>If an image have already been pulled it will use local image version instead.  
>`docker run` WILL NOT UPDATE local image, you need to use docker pull to update the local image .  
>**Attached mode is the default.**

run container and use network from another container

```sh
docker run -d --network=container:container-name image-name
```

attached and interactive example

```sh
docker run --name rng_app --rm -it rng_py_app:latest
```

detached example

```sh
docker run --name goalsapp -p 3000:80 --rm -d goals:node12
```

test docker

```sh
docker run hello-world
```

pull the image and run the container in attached mode

```sh
docker run image-name
```

pull the image and run the container in detached mode

```sh
sudo docker run -d image-name
```

- run the container in detached mode but interactively

  - ```sh
    docker run -it -d image-name
    ```

  - and the you can connect to the container

  - ```sh
    docker container attach container-name
    ```

run the container and login inside  
-i interactive  
-t tty pseudo terminal to container

```sh
docker run -it image-name /bin/bash
docker run -it image-name /bin/sh

# example
docker run -it ubuntu /bin/bash
```

run container on specific port

```sh
docker run -p host-port:container-port

# example
docker run -p 3000:80 image-name
```

docker run -v maps local host directories to the directories inside the Docker container

```sh
docker run -d --name=netdata \
  -p 19999:19999 \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata
```

run non-latest container with tag add `:tag` to the name of the container, for example

```sh
docker run -d -p 80:80 static-website:beta
```

run container with random port - `-P`

```sh
docker run -d -P image-name
```

run docker container with specified name

```sh
docker run --name container-name image-name

# example
docker run -p 3000:80 --name goalsapp --rm -d goalsapp:latest
```

`--rm` - run container and remove it after it stopped

```sh
docker run --rm image-name
```

[run multiple commands in `docker run`](https://www.baeldung.com/ops/docker-run-multiple-commands)

To execute multiple commands in the *docker run* command, we can use the [&&](https://www.baeldung.com/linux/conditional-expressions-shell-script) operator to chain the commands together. **The `&&` operator executes the first command, and if it's successful, it executes the second command.**

But, to avoid running the second command on the host [shell](https://www.baeldung.com/linux/sh-vs-bash), we have to use the `-c` option of the `sh` command to execute multiple commands simultaneously.

```sh
$ docker run centos:latest sh -c "whoami && date"

# output
root
Sun Dec 18 10:10:12 UTC 2022
```

This executes both the `whoami` and `date` commands in a single run command. We can also use the `;` operator with the `-c` option of `sh` to run multiple commands. In addition, let's use the `-w` option to specify the working directory for the command to execute in the Docker container:

```sh
$ docker run -w /home centos:latest sh -c "whoami ; pwd"

# output
root
/home
```

simple way to test DNS and internet connectivity of the container with **shoutrrr**

```sh
sudo docker run --rm -it containrrr/shoutrrr send -v "smtp://GOOGLE_LOGIN:PASSWORD@smtp.gmail.com:587/?auth=Plain&encryption=Auto&fromaddress=FROM_ADDRESS&to=TO_ADDRESS" TestMessage

# smtp://username:password@host:port/?from=fromAddress&to=recipient1[,recipient2,...]
```

---

### docker build

build image from `Dockerfile` in current directory  

- `-t` tag image with name and tag after `:`
- `.` means current dir

```sh
docker build -t image-name:tag-name .

# examples
docker build -t rng_py_app:latest .
docker build -t static-website:beta .
```

build image from different dir

```sh
docker build -t image-name:tag-name path/to/Dockerfile

# example
docker build -t printer:v1 cmd/
# don't need to mention Dockerfile
```

build image with different dir and different `Dockerfile` name

```sh
docker build -f full/path/Dockerfile ./full/path

# example
docker build --platform linux/amd64 -f frontend/Dockerfile.prod -t account-name/repo-name:tag-name ./frontend/
```

build multistaged `Dockerfile` and build only specific stage

```sh
docker build --target stage-name .

# example
docker build --platform linux/amd64 --target build -f frontend/Dockerfile.prod -t account-name/repo-name:tag-name ./frontend/
```

---

#### docker build command on macos m1 linux/amd64 images

use `--platform linux/amd64` to build image on macos m1 for linux/amd64

```sh
docker build --platform linux/amd64 -t image-name .
```

---

### docker exec

execute some command inside docker container

```sh
docker exec container-name command-name

# example
docker exec mynginx ls /
```

login inside the container

```sh
docker exec -it container-name /bin/bash

# if container doesn't have bash use sh
docker exec -it container-name /bin/sh
```

execute some command inside the docker container interactively

```sh
docker exec -it container-name command-name

# example
docker exec -it objective_swartz npm init
```

---

#### docker useful packages for containers

`iproute2` - package for  `ip -a` command (not installed on really thin distros)

```sh
apt update
apt install iproute2 -y
```

`procps` - `ps` command

```sh
apt install procps
```

---

### docker tag

> `docker tag` for renaming images

create renamed copy of the image

```sh
docker tag image-name:tag account-name/repo-name:tag

# example
docker tag webapp_node:latest  wanderingmono/node-hello-world:latest
```

---

### docker start

> docker start just starts the container  
> `detached` mode is the default

detached example

```sh
docker start container-name
```

attached and interactive example  
`-a`, `--attach` - attached mode  
 `-i`, `--interactive`

```sh
docker start -ai container-name
```

---

### docker stop

just stop the container

```sh
docker stop container-name
```

---

### docker attach

login into the running container  

> it's not interactive

```sh
docker attach container-name
```

---

### docker push

pushes the image to the repo, **DockerHub** by default or different provider  
just push image and new public repo on **DockerHub** will be created automatically

```sh
docker push account-name/repo-name:tag

# example
docker push wanderingmono/node-hello-world:latest
docker push wanderingmono/nanoimg:v2
```

---

### docker pull

just pull the image with tag latest

```sh
docker pull image-name
```

pull the image from specific repo

```sh
docker pull account-name/repo-name:tag

# example
docker pull wanderingmono/node-hello-world:latest
```

---

### docker search

search a docker image

```sh
sudo docker search name
```

---

### docker logs

show the output logs of the container

```sh
docker logs container-name
```

attach to the running container and show logs in realtime  

> can exit with Ctrl+C

```sh
docker logs -f container-name
```

grep something from docker logs

```sh
docker logs container-name 2>&1 | grep "127."
```

---

### docker cp

copy something inside the running container  

> `/.` - copy everything from the directory

```sh
docker cp local/path/. container-name:/container/path

# example
docker cp dummy/. fervent_almeida:/test
```

copy from the container to local machine

```sh
docker cp container-name:/container/path/file.txt local/path

# example
docker cp fervent_almeida:/test/test.txt dummy
```

copy full directory from the container to local machine

```sh
docker cp container-name:/container/path local/path

# example
docker cp fervent_almeida:/test dummy
```

---

### docker login & docker logout

login or logout from the dockerhub

```sh
docker login
docker logout
```

---

### docker port

show container's ports

```sh
docker port container-name
```

---

### docker ps, docker ls

show running docker containers

```sh
docker ps
```

show all containers

```sh
docker ps -a
docker container ls -a
```

show all docker images

```sh
docker images
```

which Docker containers are running and their status

```sh
docker container ls
```

docker network configuration

```sh
docker network ls
```

inspect network

```sh
docker network inspect network-name
```

show docker volumes

```sh
docker volume ls
```

---

### docker rm

remove the container

```sh
docker rm -f container-id\container-name
```

remove docker images

```sh
docker rmi -f image-name:tag-name/image-ID

# if tag = latest
docker rmi -f image-name/image-ID
```

remove all stopped containers

```sh
docker container prune
```

remove all unused *dangling* images

```sh
docker image prune
```

remove all unused images including tagged ones

```sh
docker image prune -a
```

remove volume

```sh
docker volume rm volume-name
```

delete all volumes

```sh
docker volume prune
```

delete all unused volumes without asking

```sh
docker volume prune -f
```

if you can't delete volumes with prune try:

> WARNING! It's going to really remove all volumes including named-ones

```sh
docker volume rm $(docker volume ls -qf dangling=true)
```

remove all existing stopped containers then remove all volumes

```sh
docker rm -vf $(docker ps -aq) && docker volume prune -f
```

fully delete all containers, images and cache  
`-a` - `--all`, `-f` - `--force`

```sh
docker system prune -a
```

delete all containers, images, volumes and cache  
*actually it will not delete **named** volumes*

```sh
docker system prune -a --volumes
```

---

### docker volume

create named volume

```sh
docker volume create volume-name
```

list all volumes

```sh
docker volume ls
```

inspect the volume

```sh
docker volume inspect volume-name
```

remove volume

```sh
docker volume rm volume-name
```

remove all unused **anonymous** volumes  
it will not delete **named** volumes

```sh
docker volume prune
```

---

#### anonymous volumes

Create anonymous volume inside the container.  
Managed by docker, mounted somewhere in host filesystem.  
Will be removed on container deletion.  

> Effective when you need to lock something inside the container, if it can be deleted by another command or module.

Volumes are read-write by default, use `:ro` to make them read-only

define in Dockerfile

```dockerfile
VOLUME ["/container/path"]
VOLUME ["/app/node_modules"]
```

or add in docker run command

> this is the only way to ensure that it will override another bind mount if you needed this

```sh
-v /container/path
-v /app/node_modules
```

---

#### named volumes

> Managed by docker, mounted somewhere in host filesystem.  
> Will NOT be removed on container deletion.

create named volume

```sh
-v volume-name:/container/path
```

> example

```sh
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v feedback:/app/feedback account-name/repo-name:tag-name
```

---

#### bind mount

create a bind mount that mounts folder in local system managed by you

> "" used if folder has whitespaces or special symbols

```sh
-v "local/path:/container/path"

# example
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "/full/path with whitespaces/docker-edu/Section 3. Managing Data & Working with Volumes/feedback-web-nodejs/:/app" account-name/repo-name:tag-name
```

to reduce the lenth of the path to the project folder you can use `pwd`

on macOS / Linux

```sh
-v "$(pwd):/container/path"
-v "$(pwd)/local/path:/container/path"
-v "$(pwd):/app"
```

Windows

```powershell
-v "%cd%":/app

# examples
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "$(pwd):/app"  account-name/repo-name:tag-name

docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "$(pwd)/feedback:/app/feedback" -v "$(pwd):/app" -v /app/node_modules account-name/repo-name:tag-name
```

---

#### read-only volumes

Volumes are read-write by default, use `:ro` to make them read-only

```sh
docker run -v local/path:/container/path:ro

# example
docker run -d --rm -p 3000:80 --name feedback-web-nodej
s -v feedback:/app/feedback -v "$(pwd):/app:ro" -v /app/node_modules account-name/repo-name:tag-name
```

exclude folders that need to be writable by defining another anonymous or name volume

```sh
docker run -d --rm -p 3000:80 --name feedback-web-nodej
s -v feedback:/app/feedback -v "$(pwd):/app:ro" -v /app/temp -v /app/node_modules account-name/repo-name:tag-name
```

---

## docker network

default docker network CIDR

```sh
172.17.0.0/16
```

create docker network

```sh
docker network create network-name
```

docker network configuration, show docker networks

```sh
docker network ls
```

> Use created network with container and you don't need to publish ports, because containers will be using docker network.

```sh
docker run -d --name container-name --network network-name image-name

# examples
docker run -d --name mongodb --network favorites-net mongo

docker run --name favorites-web-nodejs --network favorites-net -d --rm -p 3000:3000 account-name/repo-name:tag-name
```

address your app to another container in the same docker network use container-name in your code

```javascript
protocol-name://container-name:27017/

# example
mongodb://mongodb:27017/swfavorites
```

---

### docker network caveats

> It's unnecessary to expose ports (`-p`) of containers which don't need to be reached from host machine or internet.
>
> Containers can freely communicate with each other through the internal docker network.
>
> But it is needed to expose ports which you do want to connect from the host
>
> **BUT be aware**, for example typical React app needs exposed ports anyway because frontend app connects to the backend app through the local browser, not through server because code actually executes in browser, not on server.

**If containers can't reach LAN network except localhost**

```sh
docker network ls
docker network inspect network-name
```

Maybe some docker network shares the same subnet that local network does :)

---

### `host.docker.internal`

> To address docker to host machine keep in mind `localhost`, `127.0.0.1` refers to container itself.
>
> Use `host.docker.internal` to reach `localhost` - machine that runs `docker`.  
> **Docker Desktop** maps `host.docker.internal` automatically.  
> You can map any resources with `extra_hosts`

to map `host.docker.internal` on linux in `docker-compose.yaml` add this to the service that needs it:

```yaml
extra_hosts:
 - "host.docker.internal:host-gateway"
```

or with `docker run`

```sh
docker run -d --add-host host.docker.internal:host-gateway image-name

# examples in code
<http://host.docker.internal:3000>
mongodb://host.docker.internal:27017
```

---

## docker monitoring and troubleshooting

monitor and troubleshoot

```sh
docker stats
```

check logs of container

```sh
docker logs container-name
```

tail docker logs of container

```sh
docker logs -f container-name
```

show docker version

```sh
docker version

docker info
```

show the history of the image

```sh
docker history image-name
```

### CAdvisor monitoring tool

`cadvisor-docker-run.sh`

```sh
#!/bin/bash

# Runs Cadvisor Monitoring tool for Docker Containers

VERSION=v0.37.0 # use the latest release version from <https://github.com/google/cadvisor/releases>
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor:$VERSION
```

---

### docker paths

If you change the profile name and profile dir and docker has old profile dir.

> I'm not sure if that is everything to fix it, but change the dataFolder in the `~/Library/Group\ Containers/group.com.docker/settings.json` file to the new user name and start Docker Desktop again.

**Docker Desktop** image folder on macOS

```sh
~/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw
```

docker user folder

```sh
~/.docker
```

docker containers are just dirs on host  
docker containers dir on linux

```sh
/var/lib/docker/containers
```

docker named volumes dir on Linux

```sh
/var/lib/docker/volumes
```

---

## Timezone in docker

There are multiple ways to sync timezone between host and containers

1. Use `volume` in `docker-compose.yaml`
    `/etc/localtime:/etc/localtime:ro` or `/etc/timezone:/etc/timezone:ro`  
    On some distributions, the `/etc/timezone` file contains the timezone of the system. On some distributions, the `/etc/localtime` file contains a symbolic link to the timezone being used by the system.

    ```yaml
    version: "3.8"
    services:
     mon:
        image: containrrr/watchtower
        container_name: mon
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock
          - /etc/localtime:/etc/localtime:ro
    ```

    Check on host  

    ```sh
    ls -l /etc/localtime
    cat /etc/timezone
    ```

2. Use `TZ` variable:  

    ```yaml
    version: "3.8"
    services:
      vpn:
        image: qmcgaw/gluetun
        container_name: vpn
        cap_add:
          - net_admin
        devices:
          - /dev/net/tun
        volumes:
          - /volume1/docker/gluetun:/gluetun
        environment:
          - TZ=Asia/Yerevan
    ```

---

## docker notes

### docker-compose multiple commands

Found [here](https://stackoverflow.com/questions/30063907/docker-compose-how-to-execute-multiple-commands).

Run multiple commands with `docker-compose`.

```yaml
command: sh -c "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"
```

Same example in multilines:

```yaml
command: >
    sh -c "python manage.py migrate
    && python manage.py runserver 0.0.0.0:8000"
```

Or:

```yaml
command: sh -c "
    python manage.py migrate
    && python manage.py runserver 0.0.0.0:8000
  "
```

---

### docker-compose and sleep

Found [here](https://stackoverflow.com/questions/72217442/unable-to-bring-up-prometheus-using-docker-compose-file-always-throws-the-error).

To run any container with, diagnose it and explore its filesystem use `sleep`. I don't think it can be used efficiently with`docker run`, because with command `sleep inf` you're stuck with it even with `-d` parameter.

*docker-compose.yaml* example

```yaml
version: '3'
volumes:
  prometheus_data:
services:
  prometheus:
    image: prom/prometheus:v2.35.0
    container_name: prometheus
    volumes:
      - ./prometheus:/etc/prometheus
      - prometheus_data:/prometheus
    entrypoint:
      - sleep
      - inf
```

---

### mysql - connect to db in container

The simplest way to connect is to connect from another container in the same network.  
By default **mysql** will block connections outside of local network.

For example, with `docker-compose.yaml` with **app** and **db**

1. Check **IP** and name of the **service** of the **db** container

   ```sh
   docker compose ps
   docker inspect db-container-name | grep -i address
   ```

2. Login inside **app** container

   ```sh
   docker exec container-name /bin/bash
   ```

3. Install **mysql-client**

   ```sh
   apt update ; apt install mysql-client -y
   ```

4. Login into db

   ```sh
   mysql -h service-name-or-ip -u root -ppass
   ```

---

### DockerHub image types

Found [here](https://www.synoforum.com/threads/this-is-why-i-love-docker.2396/post-10799).

**Linuxserver.io** and **Bitnami** images have in common that both use ci servers to periodicly trigger image builds. That's a big plus for both.

**Linuxserver.io** images are aimed toward beginner friendly home usage. Their containers start as root, do the preparation magic - like fixing file permission on volumes and rendering the environment variables into configuration files - and start the main process with the provided UID/GID. They are broadly used, well tested and good documented. Kubernetes distributions with advanced security (userns mapping) are incompatible with **Linuxserver.io** images.

**Bitnami** images are aimed towards corporate (development/testing/prodction) and home usage. Their containers do start as a restricted user, render enviornment variables into configuration files and start the main proccess with this restricted user. You have to make sure to either override the default restrictive user (docker run -u / Security Context in Kubernetes) or change the owner of bind-mount volumes to allign with the user inside the container. Kubernetes allows to use init containers to take care of those type of tasks. This makes the images harder to use for Docker beginners. A lot of Kuberentes Helm charts actualy use those images. They are broadly used, well tested and good documented

Then we have the official images which make sense to use if you are entitled to product support and the vendor only supports his official images. Or if the official images are well made, like the mysql, mariadb or postgres images.

---

## deploying examples

### nodejs setup example

Typical nodejs setup:

- `-v "$(pwd):/app"` ensures that container will use the code from the project path.
- `-v /app/node_modules` ensures that bind mount will not overwrite the node_modules directory inside the container

> more info here:  
>
> - <https://stackoverflow.com/questions/54269442/why-does-docker-create-empty-node-modules-and-how-to-avoid-it/54278208#54278208>
> - <https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22166920#questions/13139726>

```sh
# example

docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "$(pwd):/app" -v /app/node_modules wanderingmono/docker-s3:feedback-web-nodejs-v0.3
```

---

### nodejs + reactjs + mongodb example

Three containers with docker network.

> NOTE
>
> If react app don't work properly try using interactive mode `docker run -it`.

**database - mongodb**

```sh
docker run --rm -d \
  --name mongodb \
  -v goals-multi-mongo:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  --network goals-multi-net mongo
```

**backend - nodejs**  
build

```sh
docker build -t account-name/repo-name:v0.3-mdb-dn .
```

run

```sh
docker run --rm -d -p 80:80 \
  -v "/full/path/to/goals-multi-web-nodejs/backend/logs":/app/logs \
  -v "/full/path/to/goals-multi-web-nodejs/backend":/app \
  -v /app/node_modules \
  -e MONGODB_USERNAME=mongoadmin \
  --name goals-be-web-nodejs \
  --network goals-multi-net \
  account-name/repo-name:v0.7-mdb-dn-pw-v-nm-env-di
```

or with `pwd`

```sh
docker run --rm -d -p 80:80 \
  -v "$(pwd)/logs:/app/logs" \
  -v "$(pwd):/app" \
  -v /app/node_modules \
  -e MONGODB_USERNAME=mongoadmin \
  --name goals-be-web-nodejs \
  --network goals-multi-net \
  account-name/repo-name:v0.7-mdb-dn-pw-v-nm-env-di
```

**frontend - reactjs**  
build

```sh
docker build -t account-name/repo-name:v0.3-node-local .
```

run

```sh
docker run --rm -d -p 3000:3000 \
  -v "$(pwd)/src:/app/src" \
  --name goals-fe-web-react \
  account-name/repo-name:v0.4-node-local-di
```

---

### Utility Containers (not official name)

run container interactively and execute some command inside of it

```sh
docker run -it --name container-name image-name command-name

# example
docker run -it --name util-nodejs account-name/repo-name:v0.1 npm init
```

run utility container with host dir bind mount and command to init node project

```sh
docker run -it --rm -v "$(pwd):/app" account-name/repo-name:v0.1 npm init
```

same and using `ENTRYPOINT` in `Dockerfile` to secure that we can use only `npm` commands

`--save` - npm argument to add express as a package as a dependency to this project

```sh
docker run -it --rm -v "$(pwd):/app" account-name/repo-name:v0.2-entry init

docker run -it --rm -v "$(pwd):/app" account-name/repo-name:v0.2-entry install

docker run -it --rm -v "$(pwd):/app" account-name/repo-name:v0.2-entry install express --save
```

---

### Utility Containers with `docker compose`

run the service described in `docker-compose.yaml` file

```sh
docker compose run service-name command-name

# example
docker compose run --rm npm init
```

---

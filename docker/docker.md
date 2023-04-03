---
title: docker
categories:
  - software
  - guides
  - notes
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# docker

- [docker](#docker)
  - [docker compose](#docker-compose)
    - [docker compose commands](#docker-compose-commands)
    - [docker compose updating and rebuilding](#docker-compose-updating-and-rebuilding)
      - [`update-docker-compose-services.sh`](#update-docker-compose-servicessh)
    - [docker compose control startup](#docker-compose-control-startup)
    - [docker compose healthchecks](#docker-compose-healthchecks)
  - [Dockerfile building blocks](#dockerfile-building-blocks)
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
  - [deploying examples](#deploying-examples)
    - [nodejs setup example](#nodejs-setup-example)
    - [nodejs + reactjs + mongodb example](#nodejs--reactjs--mongodb-example)
    - [Utility Containers (not official name)](#utility-containers-not-official-name)
    - [Utility Containers with `docker compose`](#utility-containers-with-docker-compose)

## docker compose

### docker compose commands

> `docker compose` is v2 of `docker-compose`

create and run containers specified in `docker-compose.yaml` in current dir  

```bash
docker compose up -d
docker-compose up -d
```

create and run only specific services from current `docker-compose.yaml`  

```bash
docker compose up -d service-name
```

> example

```bash
docker compose up -d server php mysql
```

stop all containers from `docker-compose.yaml` and delete them + networks

```bash
docker compose down
```

stop all containers from `docker-compose.yaml` and delete all including volumes  

```bash
docker compose down -v
```

run the service described in `docker-compose.yaml` file with specified command

```bash
docker compose run service-name command-name
```

> example

```bash
docker compose run npm init
```

---

### docker compose updating and rebuilding

```bash
docker compose up -d --remove-orphans
docker compose up -d --remove-orphans service-name
```

- start the services from `docker-compose.yaml`
- will recreate containers if `docker-compose.yaml` was changed
- will not check for new images specified in `docker-compose.yaml` or `Dockerfile`
- `--remove-orphans` - remove containers for services not defined in the `docker-compose.yaml`

```bash
docker compose pull
docker compose pull service-name
```

- only pull the new images for all services or specified ones
- will not check for new images for services with `build:` section (`Dockerfile`)

```bash
docker-compose down --rmi all && docker compose up -d
```

- full clean-up

- stop current services and remove all local images specified in `docker-compose.yaml`

- start the services from `docker-compose.yaml` after that

- >   can specify the images to update by `docker rmi -f repo-name/image-name:tag-name`

- >   it's time consuming

```bash
docker-compose up -d --build
```

- `--build` - rebuild the services from `docker-compose.yaml` with `build:` section
- will not check for new images for services specified in `docker-compose.yaml` or `Dockerfile`
- start the services from `docker-compose.yaml`

```bash
docker-compose build --pull
docker-compose build --pull --no-cache
```

- rebuild the services from `docker-compose.yaml` with `build:` section
- will check for new images specified **only** in `Dockerfile`
- will not rebuild services without `:build` section in `docker-compose.yaml`
- `--no-cache` is slower
- can specify service to build by `docker-compose build --pull service-name`

```bash
docker compose up --force-recreate --build -d && docker image prune -f
```

- >   use it only on purpose

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

```bash
#!/bin/bash
# if you need to restart all containers
# sudo docker compose down --remove-orphans

sudo docker compose build --pull # to rebuild Dockerfile images
sudo docker compose pull
sudo docker compose up -d --remove-orphans
sudo docker image prune -f
```

- rebuild the services from `docker-compose.yaml` with `build:` section and check new images
- pull the new images for all services
- start the services from `docker-compose.yaml` and remove containers for services not defined in the `docker-compose.yaml`
- removes unused images

> `docker-compose` version

```bash
#!/bin/bash
# if you need to restart all containers
# sudo docker-compose down --remove-orphans

sudo docker-compose build --pull # to rebuild Dockerfile images
sudo docker-compose pull
sudo docker-compose up -d --remove-orphans
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

### Dockerfile runtime ENV

> To use `ENV` parameters, first, you need to define this `ENV` parameter in code.
>
> Place `ENV` variables at the bottom of the `Dockerfile`. So, **docker** will not reexecute unnessesary layers.

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
    ```

    >   example

    ```dockerfile
    ENV PORT 80
    EXPOSE $PORT
    ```

3. run the image  

    ```bash
    docker run -p host-port:container-port --env PORT=port-number
    
    docker run -p host-port:container-port -e PORT=port-number
    ```

    >   example

    ```bash
    docker run -d --rm -p 3000:8000 -e PORT=8000 --name feedback-web-nodejs -v feedback:/app/feedback -v "$(pwd):/app" -v /app/node_modules -v /app/temp account-name/repo-name:v0.41-env
    ```

    or you can use .env file

    ```bash
    docker run -p host-port:container-port --env-file ./filename
    ```

    >   example

    ```bash
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
    ```

    >   example

    ```dockerfile
    ARG DEFAULT_PORT=80
    ENV PORT $DEFAULT_PORT
    EXPOSE $PORT
    ```

3. Build the image with the `ARG`.  

    ```bash
    docker build -t image-name --build-arg arg-name=arg-value .
    ```

    >   example

    ```bash
    docker build -t account-name/repo-name:v0.42-arg-p8000 --build-arg DEFAULT_PORT=8000 .
    ```

---

## docker commands

### docker help

show help on any command  

```bash
docker --help
docker ps --help
```

docker login to hub.docker.com  

```bash
docker login -u username
```

---

### docker inspect

inspect the image  

```bash
docker image inspect image-name
```

inspect the volume  

```bash
docker volume inspect volume-name
```

inspect the container  

```bash
docker container inspect container-name
```

to grep something from docker inspect  

```bash
docker container inspect container-name 2>&1 | grep "IPAddress"
```

---

### docker run

>Pulls image from dockerhub and runs a container based on it.  
>If an image have already been pulled it will use local image version instead.  
>`docker run` WILL NOT UPDATE local image, you need to use docker pull to update the local image .  
>**Attached mode is the default.**

run container and use network from another container

```bash
docker run -d --network=container:container-name image-name
```

attached and interactive example

```bash
docker run --name rng_app --rm -it rng_py_app:latest
```

detached example

```bash
docker run --name goalsapp -p 3000:80 --rm -d goals:node12
```

test docker

```bash
docker run hello-world
```

pull the image and run the container in attached mode

```bash
docker run image-name
```

pull the image and run the container in detached mode

```bash
sudo docker run -d image-name
```

- run the container in detached mode but interactively

  - ```bash
    docker run -it -d image-name
    ```

  - and the you can connect to the container

  - ```bash
    docker container attach container-name
    ```

run the container and login inside  
-i interactive  
-t tty pseudo terminal to container

```bash
docker run -it image-name
```

run container on specific port

```bash
docker run -p host-port:container-port
```

> example

```bash
docker run -p 3000:80 image-name
```

docker run -v maps local host directories to the directories inside the Docker container

```bash
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

```bash
docker run -d -p 80:80 static-website:beta
```

run container with random port - `-P`

```bash
docker run -d -P image-name
```

run docker container with specified name

```bash
docker run --name container-name image-name
```

> example

```bash
docker run -p 3000:80 --name goalsapp --rm -d goalsapp:latest
```

`--rm` - run container and remove it after it stopped

```bash
docker run --rm image-name
```

---

### docker build

build image from `Dockerfile` in current directory  

- `-t` tag image with name and tag after `:`
- `.` means current dir

```bash
docker build -t image-name:tag-name .

# examples
docker build -t rng_py_app:latest .
docker build -t static-website:beta .
```

build image with different dir and different `Dockerfile` name

```bash
docker build -f full/path/Dockerfile ./full/path

# example
docker build --platform linux/amd64 -f frontend/Dockerfile.prod -t account-name/repo-name:tag-name ./frontend/
```

build multistaged `Dockerfile` and build only specific stage

```bash
docker build --target stage-name .

# example
docker build --platform linux/amd64 --target build -f frontend/Dockerfile.prod -t account-name/repo-name:tag-name ./frontend/
```

---

#### docker build command on macos m1 linux/amd64 images

use `--platform linux/amd64` to build image on macos m1 for linux/amd64

```bash
docker build --platform linux/amd64 -t image-name .
```

---

### docker exec

execute some command inside docker container

```bash
docker exec container-name command-name
```

login inside the container

```bash
docker exec -it container-name /bin/bash
```

execute some command inside the docker container interactively

```bash
docker exec -it container-name command-name

# example
docker exec -it objective_swartz npm init
```

---

### docker tag

> docker tag for renaming images

create renamed copy of the image

```bash
docker tag image-name:tag account-name/repo-name:tag
```

> example

```bash
docker tag webapp_node:latest  wanderingmono/node-hello-world:latest
```

---

### docker start

> docker start just starts the container  
> `detached` mode is the default

detached example

```bash
docker start container-name
```

attached and interactive example  
`-a`, `--attach` - attached mode  
 `-i`, `--interactive`

```bash
docker start -ai container-name
```

---

### docker stop

just stop the container

```bash
docker stop container-name
```

---

### docker attach

login into the running container  

> it's not interactive

```bash
docker attach container-name
```

---

### docker push

pushes the image to the repo, dockerhub by default or different provider

```bash
docker push account-name/repo-name:tag
```

> example

```bash
docker push wanderingmono/node-hello-world:latest
```

---

### docker pull

just pull the image with tag latest

```bash
docker pull image-name
```

pull the image from specific repo

```bash
docker pull account-name/repo-name:tag
```

> example

```bash
docker pull wanderingmono/node-hello-world:latest
```

---

### docker search

search a docker image

```bash
sudo docker search name
```

---

### docker logs

show the output logs of the container

```bash
docker logs container-name
```

attach to the running container and show logs in realtime  

> can exit with Ctrl+C

```bash
docker logs -f container-name
```

grep something from docker logs

```bash
docker logs container-name 2>&1 | grep "127."
```

---

### docker cp

copy something inside the running container  

> `/.` - copy everything from the directory

```bash
docker cp local/path/. container-name:/container/path
```

> example

```bash
docker cp dummy/. fervent_almeida:/test
```

copy from the container to local machine

```bash
docker co container-name:/container/path/file.txt local/path
```

> example

```bash
docker cp fervent_almeida:/test/test.txt dummy
```

copy full directory from the container to local machine

```bash
docker cp container-name:/container/path local/path
```

> example

```bash
docker cp fervent_almeida:/test dummy
```

---

### docker login & docker logout

login or logout from the dockerhub

```bash
docker login
docker logout
```

---

### docker port

show container's ports

```bash
docker port container-name
```

---

### docker ps, docker ls

show running docker containers

```bash
docker ps
```

show all containers

```bash
docker ps -a
docker container ls -a
```

show all docker images

```bash
docker images
```

which Docker containers are running and their status

```bash
docker container ls
```

docker network configuration

```bash
docker network ls
```

inspect network

```bash
docker network inspect network-name
```

show docker volumes

```bash
docker volume ls
```

---

### docker rm

remove the container

```bash
docker rm -f container-ID-or-name
```

remove docker images

```bash
docker rmi -f image-name-or-image-ID
```

remove all stopped containers

```bash
docker container prune
```

remove all unused *dangling* images

```bash
docker image prune
```

remove all unused images including tagged ones

```bash
docker image prune -a
```

remove volume

```bash
docker volume rm volume-name
```

delete all volumes

```bash
docker volume prune
```

delete all unused volumes without asking

```bash
docker volume prune -f
```

if you can't delete volumes with prune try:

> WARNING! It's going to really remove all volumes including named-ones

```bash
docker volume rm $(docker volume ls -qf dangling=true)
```

remove all existing stopped containers then remove all volumes

```bash
docker rm -vf $(docker ps -aq) && docker volume prune -f
```

fully delete all containers, images and cache  
`-a` - `--all`, `-f` - `--force`

```bash
docker system prune -a
```

fully delete all containers, images, volumes and cache

```bash
docker system prune -a --volumes
```

---

### docker volume

create named volume

```bash
docker volume create volume-name
```

list all volumes

```bash
docker volume ls
```

inspect the volume

```bash
docker volume inspect volume-name
```

remove volume

```bash
docker volume rm volume-name
```

remove all unused volumes

```bash
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

```bash
-v /container/path
-v /app/node_modules
```

---

#### named volumes

> Managed by docker, mounted somewhere in host filesystem.  
> Will NOT be removed on container deletion.

create named volume

```bash
-v volume-name:/container/path
```

> example

```bash
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v feedback:/app/feedback account-name/repo-name:tag-name
```

---

#### bind mount

create a bind mount that mounts folder in local system managed by you

> "" used if folder has whitespaces or special symbols

```bash
-v "local/path:/container/path"
```

> example

```bash
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "/full/path with whitespaces/docker-edu/Section 3. Managing Data & Working with Volumes/feedback-web-nodejs/:/app" account-name/repo-name:tag-name
```

to reduce the lenth of the path to the project folder you can use `pwd`

on macOS / Linux

```bash
-v "$(pwd):/container/path"
-v "$(pwd)/local/path:/container/path"
-v "$(pwd):/app"
```

Windows

```powershell
-v "%cd%":/app
```

> example

```bash
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "$(pwd):/app"  account-name/repo-name:tag-name
```

```bash
docker run -d --rm -p 3000:80 --name feedback-web-nodejs -v "$(pwd)/feedback:/app/feedback" -v "$(pwd):/app" -v /app/node_modules account-name/repo-name:tag-name
```

---

#### read-only volumes

Volumes are read-write by default, use `:ro` to make them read-only

```bash
docker run -v local/path:/container/path:ro
```

> example

```bash
docker run -d --rm -p 3000:80 --name feedback-web-nodej
s -v feedback:/app/feedback -v "$(pwd):/app:ro" -v /app/node_modules account-name/repo-name:tag-name
```

exclude folders that need to be writable by defining another anonymous or name volume

```bash
docker run -d --rm -p 3000:80 --name feedback-web-nodej
s -v feedback:/app/feedback -v "$(pwd):/app:ro" -v /app/temp -v /app/node_modules account-name/repo-name:tag-name
```

---

## docker network

create docker network

```bash
docker network create network-name
```

docker network configuration, show docker networks

```bash
docker network ls
```

> Use created network with container and you don't need to publish ports, because containers will be using docker network.

```bash
docker run -d --name container-name --network network-name image-name
```

> examples

```bash
docker run -d --name mongodb --network favorites-net mongo

docker run --name favorites-web-nodejs --network favorites-net -d --rm -p 3000:3000 account-name/repo-name:tag-name
```

address your app to another container in the same docker network use container-name in your code

```javascript
protocol-name://container-name:27017/
```

> example

```javascript
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

```bash
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

```bash
docker run -d --add-host host.docker.internal:host-gateway image-name
```

> examples in code

```javascript
<http://host.docker.internal:3000>
mongodb://host.docker.internal:27017
```

---

## docker monitoring and troubleshooting

monitor and troubleshoot

```bash
docker stats
```

check logs of container

```bash
docker logs container-name
```

show docker version

```bash
docker version

docker info
```

show the history of the image

```bash
docker history image-name
```

### CAdvisor monitoring tool

`cadvisor-docker-run.sh`

```bash
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

```bash
~/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw
```

docker user folder

```bash
~/.docker
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

    ```bash
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

## deploying examples

### nodejs setup example

Typical nodejs setup:

- `-v "$(pwd):/app"` ensures that container will use the code from the project path.
- `-v /app/node_modules` ensures that bind mount will not overwrite the node_modules directory inside the container

> more info here:  
>
> - <https://stackoverflow.com/questions/54269442/why-does-docker-create-empty-node-modules-and-how-to-avoid-it/54278208#54278208>
> - <https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22166920#questions/13139726>

```bash
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

```bash
docker run --rm -d \
  --name mongodb \
  -v goals-multi-mongo:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  --network goals-multi-net mongo
```

**backend - nodejs**  
build

```bash
docker build -t account-name/repo-name:v0.3-mdb-dn .
```

run

```bash
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

```bash
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

```bash
docker build -t account-name/repo-name:v0.3-node-local .
```

run

```bash
docker run --rm -d -p 3000:3000 \
  -v "$(pwd)/src:/app/src" \
  --name goals-fe-web-react \
  account-name/repo-name:v0.4-node-local-di
```

---

### Utility Containers (not official name)

run container interactively and execute some command inside of it

```bash
docker run -it --name container-name image-name command-name
```

> example

```bash
docker run -it --name util-nodejs account-name/repo-name:v0.1 npm init
```

run utility container with host dir bind mount and command to init node project

```bash
docker run -it --rm -v "$(pwd):/app" account-name/repo-name:v0.1 npm init
```

same and using `ENTRYPOINT` in `Dockerfile` to secure that we can use only `npm` commands

`--save` - npm argument to add express as a package as a dependency to this project

```bash
docker run -it --rm -v "$(pwd):/app" account-name/repo-name:v0.2-entry init

docker run -it --rm -v "$(pwd):/app" account-name/repo-name:v0.2-entry install

docker run -it --rm -v "$(pwd):/app" account-name/repo-name:v0.2-entry install express --save
```

---

### Utility Containers with `docker compose`

run the service described in `docker-compose.yaml` file

```bash
docker compose run service-name command-name
```

> example

```bash
docker compose run --rm npm init
```

---

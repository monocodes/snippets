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

## docker compose

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

> As mentioned in a [doc](https://docs.docker.com/compose/reference/up/), or the help of docker-compose up
>
> - `--build`: build images before starting containers.
> - `--force-recreate`: Recreate containers even if their configuration and image haven't changed.
> - `--build` is a straightforward and it will create the docker images before starting the containers. The `--force-recreate` flag will stop the currently running containers forcefully and spin up all the containers again even if you do not have changed anything into it's configuration. So, if there are any changes, those will be picked-up into the newly created containers while preserving the state of volumes. The counter to this is `--no-recreate` to keep the containers in their existing state and it will not consider the respective changes into the configuration.

run and rebuild the images if something changed in Dockerfiles or there are new versions of images

```bash
docker compose up --build -d
```

rebuild image of service with no cache

```bash
docker-compose build --no-cache service-name
```

run and forcefully recreate containers even if they are already running, also rebuild the images if there are new versions of images

```bash
docker compose up --force-recreate --build -d
docker image prune -f
```

start in detached mode

```bash
docker compose up -d
```

stop all containers from `docker-compose.yaml` and delete them + networks

```bash
docker compose down
```

stop all containers from `docker-compose.yaml` and delete all including volumes  

```bash
docker compose down -v
```

just build or rebuild the images from `docker-compose.yaml`  

```bash
docker compose build
```

run the service described in `docker-compose.yaml` file

```bash
docker compose run service-name command-name
```

> example

```bash
docker compose run npm init
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

## docker network

### `host.docker.internal`

> Use `host.docker.internal` to reach `localhost` - machine that runs `docker`.  
> **Docker Desktop** maps `host.docker.internal` automatically.  
> You can map any resources with `extra_hosts`

to map `host.docker.internal` on linux in `docker-compose.yaml` add this to the service that needs it:

```yaml
extra_hosts:
 - "host.docker.internal:host-gateway"
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

> attached and interactive example

```bash
docker run --name rng_app --rm -it rng_py_app:latest
```

> detached example

```bash
docker run --name goalsapp -p 3000:80 --rm -d goals:node12
```

> Test docker

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

### docker exec

execute some command inside docker container

```bash
docker exec container-name command-name
```

execute some command inside the docker container interactively

```bash
docker exec -it container-name command-name
```

>   example

```bash
docker exec -it objective_swartz npm init
```

---

### docker tag

>   docker tag for renaming images

create renamed copy of the image

```bash
docker tag image-name:tag account-name/repo-name:tag
```

>   example

```bash
docker tag webapp_node:latest  wanderingmono/node-hello-world:latest
```

---

### docker start

>   docker start just starts the container  
>   `detached` mode is the default

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

```bash
docker attach container-name
```

---

### docker login & docker logout

login or logout from the dockerhub

```bash
docker login
docker logout
```


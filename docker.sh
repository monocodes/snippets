# DOCKER INSTALL --------------------------------
# ubuntu
sudo apt update
sudo apt install docker.io

# macos (Docker Desktop)
brew install --cask docker

# DOCKER UNINSTALL ------------------------------
# ubuntu
sudo apt-get remove docker docker-engine docker.io containerd runc docker-ce containerd.io

"""
By default, you’ll have to use sudo command or login to root any time you
want to run a Docker command. This next step is optional, but if you’d prefer
the ability to run Docker as your current user, you can add your account to 
the docker group with this command:
"""
sudo usermod -aG docker $USER
reboot

# DOCKER HELP -----------------------------------
# view help on any command
docker --help
docker ps --help

### docker image inspect ###
# view image info
docker image inspect image-name



# DOCKER RUN ------------------------------------
# attached mode is the default

# attached and interactive example
docker run --name rng_app --rm -it rng_py_app:latest

# detached example
docker run --name goalsapp -p 3000:80 --rm -d goals:node12

# Test docker
sudo docker run hello-world

# pull the image and run the container in attached mode
sudo docker run image-name

# pull the image and run the container in detached mode
sudo docker run -d image-name

# run the container and login inside
# -i interactive
# -t tty pseudo terminal to container
sudo docker run -it image-name

# run container on specific port
sudo docker run -p host-port:container-port-name
# example
docker run -p 3000:80 image-name

# docker run -v maps local host directories to the directories inside the Docker container
docker run -d --name=netdata \
  -p 19999:19999 \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata

# run non-latest container with tag add ':tag' to the name of the container, for example
sudo docker run -d -p 80:80 static-website:beta

# run container with random port - '-P'
sudo docker run -d -P name

# run docker container with specified name
docker run --name container-name image-name
# for example
docker run -p 3000:80 --name goalsapp --rm -d goalsapp:latest

### --rm ### run container and remove it after it will be stopped
docker run --rm image-name



# DOCKER CREATE ---------------------------------
# just create container with specified image
# -i interactive
# -t tty pseudo terminal to container
sudo docker create -it --name container-name image-name
sudo docker create -it --name myfirstubuntucontainer ubuntu



# DOCKER START ----------------------------------
# detached mode is the default

# detached example
docker start container-name

# attached and interactive example
docker start -ai container-name

# just start the existing container, container will start in detached mode
sudo docker start container-name

# start the container in attached mode
docker start -a container-name

# start the container in attached mode and log in into it
# -a = --attach - attached mode
# -i = --interactive
sudo docker start -ai container-name



# DOCKER STOP -----------------------------------
# just stop the container
sudo docker stop container-name



# DOCKER ATTACH ---------------------------------
# login to the running container
sudo docker attach container-name



# DOCKER PULL -----------------------------------
# just pull the image
sudo docker pull name 



# DOCKER SEARCH ---------------------------------
# search a docker image
sudo docker search name



# DOCKER LOGS -----------------------------------
# view the output logs of the container
docker logs container-name

# attach to the running container and view logs in realtime
# can exit with Ctrl+C
docker logs -f container-name



### DOCKER CP -----------------------------------
# cp to copy something inside the running container
docker cp dummy/. fervent_almeida:/test
# where dummy - local directory, /. - copy everything from the directory,
# fervent_almeida - container-name,
# :/test - specify directory-name in container

# copy from the container to local machine
docker cp fervent_almeida:/test/test.txt dummy
# or copy full directory from the container to local machine
docker cp fervent_almeida:/test dummy



# DOCKER PS -------------------------------------
# docker version
sudo docker version
sudo docker info
# see running docker containers
sudo docker ps
# see all containers
sudo docker ps -a
sudo docker container ls -a
# list of all docker images
sudo docker images
# which Docker containers are running and their status
sudo docker container ls
# docker network configuration
sudo docker network ls



# DOCKER RM -------------------------------------
# remove the container
sudo docker rm -f container-ID-or-name

# remove docker images
sudo docker rmi -f image-name-or-image-ID

# remove all stopped containers
sudo docker container prune

# remove all unused images
sudo docker image prune

# remove all unused images including tagged ones
docker image prune -a



# DOCKER BUILD ----------------------------------

# build image from Dockerfile in current directory example
docker build -t rng_py_app:latest .

# -t to tag the image with name, '.' - use the current directory
docker build -t image-name .
# :name to tag the image with something, for example:
docker build -t static-website:beta .



# DOCKER STATS ----------------------------------
# (monitoring and troubleshooting)
sudo docker stats
# check logs
sudo docker logs name

# script for docker CAdvisor
#!/bin/bash
# Runs Cadvisor Monitoring tool for Docker Containers
VERSION=v0.37.0 # use the latest release version from https://github.com/google/cadvisor/releases
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



# ANOTHER DOCKER COMMANDS -----------------------

# docker port
# see container ports
docker port container-name
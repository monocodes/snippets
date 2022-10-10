# DOCKER INSTALL --------------------------------
# ubuntu
sudo apt update
sudo apt install docker.io

# DOCKER UNINSTALL ------------------------------
# ubuntu
sudo apt-get remove docker docker-engine docker.io containerd runc docker-ce containerd.io

# By default, you’ll have to use sudo command or login to root any time you want to run a Docker command. This next step is optional, but if you’d prefer the ability to run Docker as your current user, you can add your account to the docker group with this command:
sudo usermod -aG docker $USER
reboot



# DOCKER ARGUMENTS ------------------------------
-i --interactive
# run and login when combined with '-t'
docker run -it name

-t - tty pseudo terminal to container
# run and it works, no login and it's not in exited state when combine with '-d'
docker run -dt name

-d --detach
# run container in detached mode, background mode

-a --attach



# DOCKER RUN ------------------------------------
# Test docker
sudo docker run hello-world

# pull image and start container
sudo docker run name

# start the container and login inside
# -i interactive
# -t tty pseudo terminal to container
sudo docker run -it name

# run container as background process
# -d --detach - по умолчанию, docker-контейнер запускается присоединенным (attached) к стандартным потокам ввода-вывода. Параметр -d позволяет запускать контейнер в фоне и не выводить на экран содержимое потоков ввода-вывода.
sudo docker run -d name
# run container in detached mode with 
sudo docker run -dt name

# run container on specific port
sudo docker run -p host port:container port name

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
sudo docker run --name name name-of-the-image



# DOCKER CREATE ---------------------------------
# just create container with specified image
# -i interactive
# -t tty pseudo terminal to container
sudo docker create -it --name name name-of-the-image
sudo docker create -it --name myfirstubuntucontainer ubuntu



# DOCKER START ----------------------------------
# just start the container
sudo docker start name
# run and login in the container
sudo docker run -ai name



# DOCKER STOP -----------------------------------
# just stop the container
sudo docker stop name



# DOCKER ATTACH ---------------------------------
# login to the running container
sudo docker attach name



# DOCKER PULL -----------------------------------
# just pull the image
sudo docker pull name 



# DOCKER SEARCH ---------------------------------
# search a docker image
sudo docker search name



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
sudo docker rm -f container-ID

# remove docker images
sudo docker rmi -f image-name-or-image-ID

# remove all stopped containers
sudo docker container prune

# remove all unused
sudo docker image prune



# DOCKER BUILD ----------------------------------
# -t to tag the image with name, '.' - use the current directory
docker build -t name-of-the-image .
# :name to tag the image with something, for example:
sudo docker build -t static-website:beta .



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